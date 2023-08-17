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

public class Color
{
    public private( set ) var value: Int16

    private init( value: Int16 )
    {
        self.value = value
    }

    public static let clear   = Color( value: -1 )
    public static let black   = Color( value: Int16( COLOR_BLACK ) )
    public static let red     = Color( value: Int16( COLOR_RED ) )
    public static let green   = Color( value: Int16( COLOR_GREEN ) )
    public static let yellow  = Color( value: Int16( COLOR_YELLOW ) )
    public static let blue    = Color( value: Int16( COLOR_BLUE ) )
    public static let magenta = Color( value: Int16( COLOR_MAGENTA ) )
    public static let cyan    = Color( value: Int16( COLOR_CYAN ) )
    public static let white   = Color( value: Int16( COLOR_WHITE ) )

    public class func pair( _ foreground: Color, _ background: Color ) -> Int32
    {
        let index = self.pairs.reduce( Int16( 0 ) )
        {
            if $1.foreground == foreground.value, $1.background == background.value
            {
                return $1.index
            }

            return $0
        }

        return Darwin.COLOR_PAIR( Int32( index ) )
    }

    private static let pairs: [ ( index: Int16, foreground: Int16, background: Int16 ) ] =
    {
        var pairs             = [ ( Int16, Int16, Int16 ) ]()
        let colors: [ Int16 ] = [
            Color.clear,
            Color.black,
            Color.red,
            Color.green,
            Color.yellow,
            Color.blue,
            Color.magenta,
            Color.cyan,
            Color.white,
        ]
        .map
        {
            $0.value
        }

        var index = Int16( 0 )

        colors.forEach
        {
            color1 in colors.forEach
            {
                color2 in index += 1

                Darwin.init_pair( Int16( index ), color1, color2 )
                pairs.append( ( Int16( index ), color1, color2 ) )
            }
        }

        return pairs
    }()
}
