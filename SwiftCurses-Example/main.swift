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
import SwiftCurses

guard let screen = Screen.shared
else
{
    print( "Curses mode is not supported on this terminal." )
    exit( 0 )
}

screen.addWindow( frame: Rect( origin: .zero, size: Size( width: 0, height: 10 ) ), style: .boxed )
{
    $0.print( text: "Window: " )
    $0.print( foreground: .yellow, text: "\( $0.frame )" )
    $0.print( text: " - " )
    $0.print( foreground: .cyan, text: "hello, world" )
    $0.newLine()
    $0.printLine( text: "hello, universe" )
    $0.printLine( foreground: .red, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit." )
}

screen.addWindow( frame: Rect( origin: Point( x: 0, y: 10 ), size: Size( width: 100, height: 10 ) ), style: .boxed )
{
    $0.print( text: "Window: " )
    $0.print( foreground: .yellow, text: "\( $0.frame )" )
    $0.print( text: " - " )
    $0.print( foreground: .cyan, text: "hello, world" )
    $0.newLine()
    $0.printLine( text: "hello, universe" )
    $0.printLine( foreground: .red, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit." )
}

screen.addWindow( frame: Rect( origin: Point( x: 100, y: 10 ), size: Size( width: 100, height: 10 ) ), style: .boxed )
{
    $0.print( text: "Window: " )
    $0.print( foreground: .yellow, text: "\( $0.frame )" )
    $0.print( text: " - " )
    $0.print( foreground: .cyan, text: "hello, world" )
    $0.newLine()
    $0.printLine( text: "hello, universe" )
    $0.printLine( foreground: .red, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit." )
}

screen.addWindow( frame: Rect( origin: Point( x: 200, y: 10 ), size: Size( width: 0, height: 10 ) ), style: .boxed )
{
    $0.print( text: "Window: " )
    $0.print( foreground: .yellow, text: "\( $0.frame )" )
    $0.print( text: " - " )
    $0.print( foreground: .cyan, text: "hello, world" )
    $0.newLine()
    $0.printLine( text: "hello, universe" )
    $0.printLine( foreground: .red, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit." )
}

screen.addWindow( frame: Rect( origin: Point( x: 0, y: 20 ), size: Size( width: 100, height: 0 ) ), style: .boxed )
{
    $0.print( text: "Window: " )
    $0.print( foreground: .yellow, text: "\( $0.frame )" )
    $0.print( text: " - " )
    $0.print( foreground: .cyan, text: "hello, world" )
    $0.newLine()
    $0.printLine( text: "hello, universe" )
    $0.printLine( foreground: .red, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit." )
}

screen.addWindow( frame: Rect( origin: Point( x: 100, y: 20 ), size: Size( width: 0, height: 0 ) ), style: .boxed )
{
    $0.print( text: "Window: " )
    $0.print( foreground: .yellow, text: "\( $0.frame )" )
    $0.print( text: " - " )
    $0.print( foreground: .cyan, text: "hello, world" )
    $0.newLine()
    $0.printLine( text: "hello, universe" )
    $0.printLine( foreground: .red, text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit." )
}

screen.start()
