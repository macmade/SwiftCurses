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

public class Window: Synchronizable
{
    public private( set ) var frame: Rect
    public private( set ) var win:   OpaquePointer

    public init?( frame: Rect )
    {
        guard let win = Curses.newwin( frame.size.height, frame.size.width, frame.origin.y, frame.origin.x )
        else
        {
            return nil
        }

        self.frame = frame
        self.win   = win
    }

    deinit
    {
        Curses.delwin( self.win )
    }

    public func refresh()
    {
        self.synchronized
        {
            Curses.wrefresh( self.win )
        }
    }

    public func moveTo( point: Point )
    {
        self.synchronized
        {
            Curses.wmove( self.win, point.y, point.x )
        }
    }

    public func print( text: String )
    {
        self.synchronized
        {
            Curses.wprintw( self.win, text )
        }
    }

    public func print( foreground: Color, text: String )
    {
        self.synchronized
        {
            self.print( foreground: foreground, background: .clear, text: text )
        }
    }

    public func print( foreground: Color, background: Color, text: String )
    {
        self.synchronized
        {
            if Screen.shared?.hasColors ?? false
            {
                Curses.wattrset( self.win, Color.pair( foreground, background ) )
            }

            Curses.wprintw( self.win, text )

            if Screen.shared?.hasColors ?? false
            {
                Curses.wattrset( self.win, Color.pair( .clear, .clear ) )
            }
        }
    }

    public func box()
    {
        self.synchronized
        {
            Curses.box( self.win, 0, 0 )
        }
    }

    public func horizontalRuler( width: Int32 )
    {
        self.synchronized
        {
            Curses.whline( self.win, 0, width )
        }
    }

    public func verticalRuler( height: Int32 )
    {
        self.synchronized
        {
            Curses.wvline( self.win, 0, height )
        }
    }
}
