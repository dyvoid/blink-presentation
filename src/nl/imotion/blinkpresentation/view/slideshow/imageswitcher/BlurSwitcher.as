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
    import com.greensock.easing.Quint;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.filters.BitmapFilterQuality;


    /**
     * @author Pieter van de Sluis
     */
    public class BlurSwitcher extends ImageSwitcher
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _transitionDuration:Number;

        private var _currImage  :Bitmap;

        private var _transitionCompleteCallback:Function;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function BlurSwitcher( transitionDuration:Number = 1.5, imageContainer:Sprite = null )
        {
            _transitionDuration = transitionDuration;

            super( imageContainer);
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

            var currImageWrapper:Sprite = new Sprite();
            currImageWrapper.addChild( _currImage );

            var newImageWrapper:Sprite = new Sprite();
            newImageWrapper.addChild( image );

            imageContainer.addChild( currImageWrapper );
            imageContainer.addChild( newImageWrapper );

            var currTargetScale:Number = ( delta >= 0 ) ? 0.8 : 1.2;
            var newTargetScale:Number  = ( delta >= 0 ) ? 1.2 : 0.8;

            new TimelineMax( { tweens: [
                TweenMax.to( currImageWrapper, _transitionDuration, {
                    alpha:0,
                    scaleX: currTargetScale, scaleY: currTargetScale,
                    blurFilter: { blurX: 25, blurY: 25, quality: BitmapFilterQuality.HIGH },
                    ease: Quint.easeInOut } ),
                TweenMax.from( newImageWrapper, _transitionDuration, {
                    alpha:0,
                    scaleX: newTargetScale, scaleY: newTargetScale,
                    blurFilter: { blurX: 25, blurY: 25, quality: BitmapFilterQuality.HIGH },
                    ease: Quint.easeInOut } )
            ], align: TweenAlign.NORMAL, onComplete: cleanup, onCompleteParams: [ image ] } );
        }


        private function cleanup( nextImage:Bitmap ):void
        {
            clear();
            placeImage( nextImage );
            _currImage = nextImage;

            if ( _transitionCompleteCallback != null )
                _transitionCompleteCallback();

            _transitionCompleteCallback = null;
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