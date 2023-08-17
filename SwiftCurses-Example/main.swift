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

let update = Screen.shared.onUpdate.add
{
    let win1 = Window( x: 0, y: 0, width: Int32( Screen.shared.width ), height: 3 )
    let win2 = Window( x: 0, y: 3, width: Int32( Screen.shared.width ), height: 3 )

    win1?.box()
    win1?.moveTo( x: 2, y: 1 )
    win1?.print( foreground: .magenta, text: "Window 1: hello, world" )
    win1?.refresh()

    win2?.box()
    win2?.moveTo( x: 2, y: 1 )
    win2?.print( foreground: .cyan, text: "Window 2: hello, universe" )
    win2?.refresh()

    Screen.shared.refresh()
}

Screen.shared.start()
