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
    import com.greensock.easing.Back;
    import com.greensock.easing.Quint;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.PerspectiveProjection;
    import flash.geom.Point;


    /**
     * @author Pieter van de Sluis
     */
    public class FlipSwitcher extends ImageSwitcher
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _transitionDuration:Number;

        private var _flipCompleteCallback:Function;

        private var _matrix     :Matrix;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function FlipSwitcher( transitionDuration:Number = 2, imageContainer:Sprite = null )
        {
            _transitionDuration =  transitionDuration;

            super( imageContainer );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function switchImage( image:Bitmap, delta:Number, completeCallback:Function = null ):void
        {
            _flipCompleteCallback = completeCallback;

            var zoomDuration:Number = _transitionDuration * 0.5;
            var flipDuration:Number =  zoomDuration * 0.5;

            var direction:int = ( delta >= 0 ) ? 1 : -1;

            new TimelineMax( { tweens: [
                new TimelineMax( { tweens: [
                    TweenMax.to( imageContainer, zoomDuration, { z: -400, ease: Back.easeIn } ),
                    TweenMax.to( imageContainer, flipDuration, { rotationY: direction * 90, rotationZ: direction * 30, ease: Quint.easeIn } )
                ], align: TweenAlign.NORMAL, stagger: flipDuration, onComplete: super.switchImage, onCompleteParams: [ image, delta ] } ),
                TweenMax.to( imageContainer, 0.01, { rotationY: direction * 270 } ),
                new TimelineMax( { tweens: [
                    TweenMax.to( imageContainer, flipDuration, { rotationY: direction * 360, rotationZ: 0, ease: Quint.easeOut } ),
                    TweenMax.to( imageContainer, zoomDuration, { z: 0, ease: Quint.easeOut } )
                ], align: TweenAlign.NORMAL } )
            ], align: TweenAlign.SEQUENCE, onComplete: onFlipComplete } );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function onFlipComplete():void
        {
            imageContainer.transform.matrix = _matrix;

            if ( _flipCompleteCallback != null )
                _flipCompleteCallback();

            _flipCompleteCallback = null;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        override public function set imageContainer( value:Sprite ):void
        {
            super.imageContainer = value;

            var projection:PerspectiveProjection = new PerspectiveProjection();
            projection.projectionCenter = new Point( imageContainer.x,  imageContainer.y);
            imageContainer.transform.perspectiveProjection = projection;

            _matrix = value.transform.matrix;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}