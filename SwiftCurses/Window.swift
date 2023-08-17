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
    public private( set ) var x:      Int32
    public private( set ) var y:      Int32
    public private( set ) var width:  Int32
    public private( set ) var height: Int32

    private var win: OpaquePointer

    public init?( x: Int32, y: Int32, width: Int32, height: Int32 )
    {
        guard let win = Curses.newwin( height, width, y, x )
        else
        {
            return nil
        }

        self.x      = x
        self.y      = y
        self.width  = width
        self.height = height
        self.win    = win
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

    public func moveTo( x: Int32, y: Int32 )
    {
        self.synchronized
        {
            Curses.wmove( self.win, y, x )
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

    public func addHorizontalLine( width: Int32 )
    {
        self.synchronized
        {
            Curses.whline( self.win, 0, width )
        }
    }

    public func addVerticalLine( height: Int32 )
    {
        self.synchronized
        {
            Curses.whline( self.win, 0, height )
        }
    }
}
