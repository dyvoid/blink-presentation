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
    import flash.display.Bitmap;
    import flash.display.Sprite;


    /**
     * @author Pieter van de Sluis
     */
    public class ImageSwitcher implements IImageSwitcher
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private static const IMAGE_CONTAINER_ERROR  :String = "imageContainer was not set.";

        private var _imageContainer     :Sprite;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function ImageSwitcher( imageContainer:Sprite = null )
        {
            if ( imageContainer )
                this.imageContainer = imageContainer;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function showFirstImage( image:Bitmap, completeCallback:Function = null ):void
        {
            if ( !_imageContainer ) throw new Error( IMAGE_CONTAINER_ERROR );

            placeImage( image );

            if ( completeCallback != null )
            {
                completeCallback();
            }
        }


        public function switchImage( image:Bitmap, delta:Number, completeCallback:Function = null ):void
        {
            if ( !_imageContainer ) throw new Error( IMAGE_CONTAINER_ERROR );

            clear();
            placeImage( image );

            if ( completeCallback != null )
            {
                completeCallback();
            }
        }

        // ____________________________________________________________________________________________________
        // PRIVATE



        // ____________________________________________________________________________________________________
        // PROTECTED

        protected function placeImage( image:Bitmap ):void
        {
            image.x = -image.width * 0.5;
            image.y = -image.height * 0.5;

            _imageContainer.addChild( image );
        }


        protected function clear():void
        {
            while ( _imageContainer.numChildren > 0 )
            {
                _imageContainer.removeChildAt( 0 );
            }
        }

        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get imageContainer():Sprite
        {
            return _imageContainer;
        }

        public function set imageContainer( value:Sprite ):void
        {
            _imageContainer = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}