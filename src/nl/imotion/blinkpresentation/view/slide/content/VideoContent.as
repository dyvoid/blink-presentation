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

package nl.imotion.blinkpresentation.view.slide.content
{
    import nl.imotion.blinkpresentation.model.vo.VOVideoData;
    import nl.imotion.blinkpresentation.view.videoplayer.VideoPlayer;


    /**
     * @author Pieter van de Sluis
     */
    public class VideoContent extends SlideContent
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _player:VideoPlayer;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function VideoContent( data:VOVideoData )
        {
            super( data );

            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        private function init():void
        {
            _player = new VideoPlayer();
            addChild( _player );

            _player.load( data.path, VOVideoData( data ).autoPlay, data.scaleMode );

            onReady();
        }


        override public function destroy():void
        {
            removeChild( _player );
            _player = null;

            super.destroy();
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