/*
 * Licensed under the MIT license
 *
 * Copyright (c) 2009-2013 Pieter van de Sluis
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * http://code.google.com/p/imotionproductions/
 */

package nl.imotion.blinkpresentation.view.videoplayer.scrubber
{
    import flash.display.Sprite;
    import flash.text.TextField;


    /**
     * @author Pieter van de Sluis
     */
    public class TimeIndicator extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var tfTime       :TextField;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function TimeIndicator()
        {

        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function update( videoTime:Number ):void
        {
            videoTime = Math.floor( videoTime );
            tfTime.text = getFormattedTime( Math.floor( videoTime / 60 ) ) + ":" + getFormattedTime( videoTime % 60 );
        }


        private function getFormattedTime( time:Number ):String
        {
            var result:String = time.toString();

            if ( result.length == 1 )
                result = "0" + result;

            return result;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}