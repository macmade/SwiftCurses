/*******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2023, Jean-David Gadina - www.xs-labs.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the Software), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Foundation

public class Screen: Synchronizable
{
    public static let shared = Screen()

    public private( set ) var hasColors  = false
    public private( set ) var isRunning  = false
    public private( set ) var width      = UInt16( 0 )
    public private( set ) var height     = UInt16( 0 )
    public private( set ) var onResize   = Event< Void >()
    public private( set ) var onKeyPress = Event< Int32 >()
    public private( set ) var onUpdate   = Event< Void >()

    private var screen:  OpaquePointer
    private var windows: [ Either< ( frame: Rect, style: ManagedWindow.Style, update: ( ManagedWindow ) -> Void ), WindowBuilder > ] = []

    private init?()
    {
        guard let screen = Curses.newterm( getenv( "TERM" ), stdout, stdin )
        else
        {
            return nil
        }

        self.screen = screen

        if Curses.has_colors()
        {
            self.hasColors = true

            Curses.start_color()
            Curses.use_default_colors()
        }

        self.initialize()
    }

    deinit
    {
        Curses.clrtoeol()
        Curses.refresh()
        Curses.endwin()
        Curses.delscreen( self.screen )
    }

    private func initialize()
    {
        self.clear()
        Curses.noecho()
        Curses.cbreak()
        Curses.keypad( Curses.stdscr, true )
        Curses.curs_set( 0 )
        self.refresh()

        var s       = winsize()
        _           = ioctl( STDOUT_FILENO, TIOCGWINSZ, &s )
        self.width  = s.ws_col
        self.height = s.ws_row
    }

    private func deinitialize()
    {
        self.clear()
        self.refresh()

        Curses.curs_set( 1 )
        Curses.endwin()
    }

    public func clear()
    {
        self.synchronized
        {
            Curses.clear()
        }
    }

    public func refresh()
    {
        self.synchronized
        {
            Curses.refresh()
        }
    }

    public func disableColors()
    {
        self.synchronized
        {
            self.hasColors = false
        }
    }

    public func print( text: String )
    {
        self.synchronized
        {
            Curses.printw( text )
        }
    }

    public func print( foreground: Color, text: String )
    {
        self.print( foreground: foreground, background: .clear, text: text )
    }

    public func print( foreground: Color, background: Color, text: String )
    {
        self.synchronized
        {
            if self.hasColors
            {
                Curses.attrset( Color.pair( foreground, background ) )
            }

            Curses.printw( text )

            if self.hasColors
            {
                Curses.attrset( Color.pair( .clear, .clear ) )
            }
        }
    }

    public func start()
    {
        let alreadyStarted = self.synchronized
        {
            if self.isRunning
            {
                return true
            }

            self.isRunning = true

            return false
        }

        if alreadyStarted
        {
            return
        }

        self.initialize()

        while true
        {
            if self.synchronized( closure: { self.isRunning } ) == false
            {
                break
            }

            var s = winsize()
            _     = ioctl( STDOUT_FILENO, TIOCGWINSZ, &s )

            var onResize:   () -> Void = {}
            var onKeyPress: () -> Void = {}

            self.synchronized
            {
                if s.ws_col != self.width || s.ws_row != self.height
                {
                    self.width  = s.ws_col
                    self.height = s.ws_row
                    onResize    = { self.onResize.fire() }

                    self.clear()
                }

                var p     = pollfd()
                p.fd      = 0
                p.events  = Int16( POLLIN )
                p.revents = 0

                if poll( &p, 1, 0 ) > 0
                {
                    let key    = getc( stdin )
                    onKeyPress = { self.onKeyPress.fire( key ) }
                }
            }

            onResize()
            onKeyPress()

            var managed: [ ManagedWindow ] = []

            self.windows.forEach
            {
                var frame:  Rect
                let style:  ManagedWindow.Style
                let update: ( ManagedWindow ) -> Void
                let render: Bool

                switch $0
                {
                    case .left( let info ):

                        frame  = info.frame
                        style  = info.style
                        update = info.update
                        render = true

                    case .right( let builder ):

                        frame  = builder.desiredFame
                        style  = builder.style
                        update = builder.render( on: )
                        render = builder.shouldBeRendered()
                }

                guard render
                else
                {
                    return
                }

                if frame.size.width  <= 0 { frame.size.width  = Int32( self.width  ) - frame.origin.x }
                if frame.size.height <= 0 { frame.size.height = Int32( self.height ) - frame.origin.y }

                if frame.origin.x >= self.width  { return }
                if frame.origin.y >= self.height { return }

                if frame.origin.x < 0 { frame.origin.x = ( Int32( self.width  ) - frame.size.width  ) / 2 }
                if frame.origin.y < 0 { frame.origin.y = ( Int32( self.height ) - frame.size.height ) / 2 }

                if frame.origin.x + frame.size.width  > self.width  { frame.size.width  -= ( frame.origin.x + frame.size.width  ) - Int32( self.width  ) }
                if frame.origin.y + frame.size.height > self.height { frame.size.height -= ( frame.origin.y + frame.size.height ) - Int32( self.height ) }

                if frame.size.width  <= 2 { return }
                if frame.size.height <= 2 { return }

                guard let window = ManagedWindow( frame: frame, style: style )
                else
                {
                    return
                }

                update( window )

                managed.append( window )
            }

            managed.forEach
            {
                $0.refresh()
            }

            self.onUpdate.fire()
            self.refresh()
        }

        self.deinitialize()
    }

    public func stop()
    {
        self.synchronized
        {
            self.isRunning = false
        }
    }

    public func addWindow( builder: WindowBuilder )
    {
        self.synchronized
        {
            self.windows.append( .right( builder ) )
        }
    }

    public func addWindow( frame: Rect, style: ManagedWindow.Style, update: @escaping ( ManagedWindow ) -> Void )
    {
        self.synchronized
        {
            self.windows.append( .left( ( frame: frame, style: style, update: update ) ) )
        }
    }
}
