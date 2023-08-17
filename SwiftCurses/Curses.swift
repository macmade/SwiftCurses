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

import Darwin.ncurses
import Foundation

internal class Curses
{
    private init()
    {}

    public static var stdscr: OpaquePointer
    {
        Darwin.stdscr
    }

    public class func initscr()
    {
        Darwin.initscr()
    }

    public class func has_colors() -> Bool
    {
        Darwin.has_colors()
    }

    @discardableResult
    public class func start_color() -> Int32
    {
        Darwin.start_color()
    }

    @discardableResult
    public class func use_default_colors() -> Int32
    {
        Darwin.use_default_colors()
    }

    @discardableResult
    public class func noecho() -> Int32
    {
        Darwin.noecho()
    }

    @discardableResult
    public class func cbreak() -> Int32
    {
        Darwin.cbreak()
    }

    @discardableResult
    public class func keypad( _ window: OpaquePointer, _ enable: Bool ) -> Int32
    {
        Darwin.keypad( window, enable )
    }

    @discardableResult
    public class func clear() -> Int32
    {
        Darwin.clear()
    }

    @discardableResult
    public class func refresh() -> Int32
    {
        Darwin.refresh()
    }

    @discardableResult
    public class func attrset( _ attributes: Int32 ) -> Int32
    {
        Darwin.attrset( attributes )
    }

    @discardableResult
    public class func attron( _ attribute: Int32 ) -> Int32
    {
        Darwin.attron( attribute )
    }

    @discardableResult
    public class func attroff( _ attribute: Int32 ) -> Int32
    {
        Darwin.attroff( attribute )
    }

    @discardableResult
    public class func wattrset( _ window: OpaquePointer, _ attributes: Int32 ) -> Int32
    {
        Darwin.wattrset( window, attributes )
    }

    @discardableResult
    public class func wattron( _ window: OpaquePointer, _ attribute: Int32 ) -> Int32
    {
        Darwin.wattron( window, attribute )
    }

    @discardableResult
    public class func wattroff( _ window: OpaquePointer, _ attribute: Int32 ) -> Int32
    {
        Darwin.wattroff( window, attribute )
    }

    @discardableResult
    public class func curs_set( _ visibility: Int32 ) -> Int32
    {
        Darwin.curs_set( visibility )
    }

    @discardableResult
    public class func clrtoeol() -> Int32
    {
        Darwin.clrtoeol()
    }

    @discardableResult
    public class func endwin() -> Int32
    {
        Darwin.endwin()
    }

    @discardableResult
    public class func printw( _ text: String, _ args: CVarArg... ) -> Int32
    {
        withVaList( args )
        {
            Darwin.vwprintw( self.stdscr, text, $0 )
        }
    }

    @discardableResult
    public class func wprintw( _ window: OpaquePointer, _ text: String, _ args: CVarArg... ) -> Int32
    {
        withVaList( args )
        {
            Darwin.vwprintw( window, text, $0 )
        }
    }

    @discardableResult
    public class func vwprintw( _ window: OpaquePointer, _ text: String, _ args: CVaListPointer ) -> Int32
    {
        Darwin.vwprintw( window, text, args )
    }

    public class func newwin( _ lines: Int32, _ columns: Int32, _ y: Int32, _ x: Int32 ) -> OpaquePointer?
    {
        Darwin.newwin( lines, columns, y, x )
    }

    @discardableResult
    public class func delwin( _ window: OpaquePointer ) -> Int32
    {
        Darwin.delwin( window )
    }

    @discardableResult
    public class func wrefresh( _ window: OpaquePointer ) -> Int32
    {
        Darwin.wrefresh( window )
    }

    @discardableResult
    public class func wmove( _ window: OpaquePointer, _ y: Int32, _ x: Int32 ) -> Int32
    {
        Darwin.wmove( window, y, x )
    }

    @discardableResult
    public class func box( _ window: OpaquePointer, _ vch: UInt32, _ hch: UInt32 ) -> Int32
    {
        Darwin.box( window, vch, hch )
    }

    @discardableResult
    public class func whline( _ window: OpaquePointer, _ ch: UInt32, _ size: Int32 ) -> Int32
    {
        Darwin.whline( window, ch, size )
    }

    @discardableResult
    public class func wvline( _ window: OpaquePointer, _ ch: UInt32, _ size: Int32 ) -> Int32
    {
        Darwin.wvline( window, ch, size )
    }
}
