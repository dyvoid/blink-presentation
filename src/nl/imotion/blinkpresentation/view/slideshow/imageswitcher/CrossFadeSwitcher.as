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

package nl.imotion.blinkpresentation.view.slideshow.imageswitcher
{
    import com.greensock.TimelineMax;
    import com.greensock.TweenAlign;
    import com.greensock.TweenMax;

    import flash.display.Bitmap;
    import flash.display.Sprite;


    /**
     * @author Pieter van de Sluis
     */
    public class CrossFadeSwitcher extends ImageSwitcher
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _transitionDuration:Number;

        private var _currImage  :Bitmap;

        private var _transitionCompleteCallback:Function;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function CrossFadeSwitcher( transitionDuration:Number = 1, imageContainer:Sprite = null )
        {
            _transitionDuration =  transitionDuration;

            super( imageContainer );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function showFirstImage( image:Bitmap, completeCallback:Function = null ):void
        {
            super.showFirstImage( image, completeCallback );

            _currImage = image;
        }


        override public function switchImage( image:Bitmap, delta:Number, completeCallback:Function = null ):void
        {
            _transitionCompleteCallback = completeCallback;

            placeImage( image );

            new TimelineMax( { tweens: [
                TweenMax.fromTo( _currImage, _transitionDuration, { alpha: 1 }, { alpha:0 } ),
                TweenMax.fromTo( image, _transitionDuration, { alpha: 0 }, { alpha:1 } )
            ], align: TweenAlign.NORMAL, onComplete: cleanup, onCompleteParams: [ image ] } );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function cleanup( nextImage:Bitmap ):void
        {
            imageContainer.removeChild( _currImage );
            _currImage = nextImage;

            if ( _transitionCompleteCallback != null )
                _transitionCompleteCallback();

            _transitionCompleteCallback = null;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}