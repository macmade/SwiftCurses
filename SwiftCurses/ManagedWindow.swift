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
import XSLabsSwift

public class ManagedWindow: Synchronizable
{
    public enum Style
    {
        case normal
        case boxed
    }

    public private( set ) var style:        Style
    public private( set ) var frame:        Rect
    public private( set ) var win:          OpaquePointer
    public private( set ) var currentPoint: Point
    public private( set ) var drawRect:     Rect

    public var bounds: Rect
    {
        Rect( x: 0, y: 0, width: self.drawRect.size.width, height: self.drawRect.size.height )
    }

    public init?( frame: Rect, style: Style )
    {
        guard let win = Curses.newwin( frame.size.height, frame.size.width, frame.origin.y, frame.origin.x )
        else
        {
            return nil
        }

        self.style        = style
        self.frame        = frame
        self.win          = win
        self.currentPoint = Point( x: 0, y: 0 )

        if style == .boxed
        {
            Curses.box( self.win, 0, 0 )

            self.drawRect = Rect( x: 2, y: 1, width: frame.size.width - 4, height: frame.size.height - 2 )
        }
        else
        {
            self.drawRect = Rect( x: 0, y: 0, width: frame.size.width, height: frame.size.height )
        }

        self.moveTo( x: 0, y: 0 )
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
            var point = Point( x: self.drawRect.origin.x + x, y: self.drawRect.origin.y + y )

            if point.x < self.drawRect.origin.x { point.x = self.drawRect.origin.x }
            if point.y < self.drawRect.origin.y { point.y = self.drawRect.origin.y }

            if point.x >= self.drawRect.origin.x + self.drawRect.size.width  { point.x = ( self.drawRect.origin.x + self.drawRect.size.width  ) }
            if point.y >= self.drawRect.origin.y + self.drawRect.size.height { point.y = ( self.drawRect.origin.y + self.drawRect.size.height ) }

            Curses.wmove( self.win, point.y, point.x )

            self.currentPoint.x = point.x - self.drawRect.origin.x
            self.currentPoint.y = point.y - self.drawRect.origin.y
        }
    }

    public func moveTo( point: Point )
    {
        self.moveTo( x: point.x, y: point.y )
    }

    public func moveBy( x: Int32, y: Int32 )
    {
        self.synchronized
        {
            self.moveTo( x: self.currentPoint.x + x, y: self.currentPoint.y + y )
        }
    }

    public func moveX( by offset: Int32 )
    {
        self.synchronized
        {
            self.moveBy( x: offset, y: 0 )
        }
    }

    public func moveY( by offset: Int32 )
    {
        self.synchronized
        {
            self.moveBy( x: 0, y: offset )
        }
    }

    private func printableText( text: String ) -> String
    {
        let available = Int( ( self.drawRect.origin.x + self.drawRect.size.width ) - self.currentPoint.x ) - Int( self.drawRect.origin.x )

        if self.currentPoint.y == self.drawRect.size.height
        {
            return ""
        }

        if available <= 0
        {
            return ""
        }

        if text.count > available
        {
            if available >= 4
            {
                return String( text[ text.startIndex ..< text.index( text.startIndex, offsetBy: available - 3 ) ] ) + "..."
            }

            return String( text[ text.startIndex ..< text.index( text.startIndex, offsetBy: available ) ] )
        }

        return text
    }

    public func print( text: String )
    {
        self.synchronized
        {
            let text = self.printableText( text: text )

            Curses.wprintw( self.win, self.printableText( text: text ) )
            self.moveTo( point: self.currentPoint )
            self.moveX( by: Int32( text.count ) )
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

            let text = self.printableText( text: text )

            Curses.wprintw( self.win, text )
            self.moveTo( point: self.currentPoint )
            self.moveX( by: Int32( text.count ) )

            if Screen.shared?.hasColors ?? false
            {
                Curses.wattrset( self.win, Color.pair( .clear, .clear ) )
            }
        }
    }

    public func printLine( text: String )
    {
        self.synchronized
        {
            self.print( text: text )
            self.newLine()
        }
    }

    public func printLine( foreground: Color, text: String )
    {
        self.synchronized
        {
            self.print( foreground: foreground, text: text )
            self.newLine()
        }
    }

    public func printLine( foreground: Color, background: Color, text: String )
    {
        self.synchronized
        {
            self.print( foreground: foreground, background: background, text: text )
            self.newLine()
        }
    }

    public func newLine()
    {
        self.moveTo( x: 0, y: self.currentPoint.y + 1 )
    }

    public func horizontalRuler( width: Int32 )
    {
        self.synchronized
        {
            let maxWidth = self.drawRect.size.width - self.currentPoint.x
            let width    = width > maxWidth ? maxWidth : width

            Curses.whline( self.win, 0, width )
            self.moveX( by: width )
        }
    }

    public func verticalRuler( height: Int32 )
    {
        self.synchronized
        {
            let maxHeight = self.drawRect.size.height - self.currentPoint.y
            let height    = height > maxHeight ? maxHeight : height

            Curses.wvline( self.win, 0, height )
            self.moveY( by: height )
        }
    }

    public func separator()
    {
        if self.currentPoint.x != 0
        {
            self.newLine()
        }

        self.horizontalRuler( width: Int32.max )
        self.newLine()
    }
}
