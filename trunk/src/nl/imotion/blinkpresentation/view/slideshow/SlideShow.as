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

package nl.imotion.blinkpresentation.view.slideshow
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    import nl.imotion.blinkpresentation.view.slideshow.imageswitcher.IImageSwitcher;
    import nl.imotion.blinkpresentation.view.slideshow.imageswitcher.ImageSwitcher;
    import nl.imotion.interfaces.IIterator;


    /**
     * @author Pieter van de Sluis
     */
    public class SlideShow extends Sprite implements IIterator
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _index          :uint = 0;

        private var _imageContainer :Sprite;

        private var _images         :Vector.<BitmapData>;

        private var _explicitWidth  :Number;
        private var _explicitHeight :Number;

        private var _imageSwitcher  :IImageSwitcher;

        private var _isSwitching    :Boolean;

        private var _loop           :Boolean = false;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function SlideShow( width:Number, height:Number, imageSwitcher:IImageSwitcher = null )
        {
            _explicitWidth = width;
            _explicitHeight = height;

            init();

            _imageSwitcher = imageSwitcher || new ImageSwitcher();
            _imageSwitcher.imageContainer = _imageContainer;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function addImage( image:BitmapData ):void
        {
            _images.push( image );
        }


        public function start( index:uint = 0 ):void
        {
            _index = ( index < _images.length ) ? index : 0;

            _isSwitching = true;

            _imageSwitcher.showFirstImage( new Bitmap( _images[ _index ] ), onSwitchComplete );
        }


        public function previous():*
        {
            if ( !hasPrevious || _isSwitching ) return;

            var newIndex:uint = ( _index == 0 ) ? _images.length - 1 : _index - 1;
            goTo( newIndex );

            return ( _images[ newIndex ] );
        }


        public function next():*
        {
            if ( !hasNext || _isSwitching ) return;

            var newIndex:uint = (_index + 1 ) % _images.length;
            goTo( newIndex );

            return ( _images[ newIndex ] );
        }


        public function goTo( index:uint ):void
        {
            if ( _index == index || index > _images.length - 1 || _isSwitching ) return;

            var delta:Number = index - _index;

            if ( _loop )
            {
                if ( index == 0 && _index == _images.length - 1 )
                {
                    delta = 1;
                }
                else if ( index == _images.length - 1 && _index == 0  )
                {
                    delta = -1;
                }
            }

            _index = index;

            _isSwitching = true;

            _imageSwitcher.switchImage( new Bitmap( _images[ _index ] ), delta, onSwitchComplete );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            graphics.beginFill( 0, 0 );
            graphics.drawRect( 0, 0, _explicitWidth, _explicitHeight );
            graphics.endFill();

            _imageContainer = new Sprite();
            _imageContainer.x = _explicitWidth * 0.5;
            _imageContainer.y = _explicitHeight * 0.5;
            this.addChild( _imageContainer );

            _images = new Vector.<BitmapData>();

            mouseChildren = false;
        }


        private function onSwitchComplete():void
        {
            _isSwitching = false;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        override public function get width():Number
        {
            return _explicitWidth;
        }


        override public function get height():Number
        {
            return _explicitHeight;
        }


        public function get index():uint
        {
            return _index;
        }


        public function get loop():Boolean
        {
            return _loop;
        }

        public function set loop( value:Boolean ):void
        {
            _loop = value;
        }


        public function get hasPrevious():Boolean
        {
            return _loop ? _images.length > 0 : _index > 0;
        }


        public function get hasNext():Boolean
        {
            return _loop ? _images.length > 0 : _index < _images.length - 1;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}