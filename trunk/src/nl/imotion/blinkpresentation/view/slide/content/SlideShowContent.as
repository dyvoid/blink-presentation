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
    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.ImageLoader;
    import com.greensock.loading.LoaderMax;

    import flash.display.Bitmap;

    import nl.imotion.blinkpresentation.config.Config;
    import nl.imotion.blinkpresentation.view.slideshow.imageswitcher.SlideShowImageSwitcher;
    import nl.imotion.blinkpresentation.model.vo.VOSlideContentData;
    import nl.imotion.blinkpresentation.model.vo.VOSlideShowData;
    import nl.imotion.blinkpresentation.model.vo.VOSlideShowData;
    import nl.imotion.blinkpresentation.model.vo.VOSlideShowData;
    import nl.imotion.blinkpresentation.view.slideshow.SlideShow;
    import nl.imotion.blinkpresentation.view.slideshow.imageswitcher.BlurSwitcher;
    import nl.imotion.blinkpresentation.view.slideshow.imageswitcher.CrossFadeSwitcher;
    import nl.imotion.blinkpresentation.view.slideshow.imageswitcher.FlipSwitcher;
    import nl.imotion.blinkpresentation.view.slideshow.imageswitcher.IImageSwitcher;
    import nl.imotion.blinkpresentation.view.slideshow.imageswitcher.ImageSwitcher;
    import nl.imotion.display.EventManagedSprite;
    import nl.imotion.interfaces.IIterator;


    /**
     * @author Pieter van de Sluis
     */
    public class SlideShowContent extends SlideContent implements IIterator
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _slideShow:SlideShow;

        private var _loader:LoaderMax;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function SlideShowContent( data:VOSlideShowData )
        {
            super( data );

            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function destroy():void
        {
            destroyLoader();

            super.destroy();
        }


        public function previous():*
        {
            return _slideShow.previous();
        }

        public function next():*
        {
            return _slideShow.next();
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            var switcher:IImageSwitcher;

            switch( VOSlideShowData( data ).imageSwitcher )
            {
                case SlideShowImageSwitcher.BLUR:
                    switcher = new BlurSwitcher();
                break;

                case SlideShowImageSwitcher.CROSSFADE:
                    switcher = new CrossFadeSwitcher();
                break;
                case SlideShowImageSwitcher.FLIP:
                    switcher = new FlipSwitcher();
                break;

                case SlideShowImageSwitcher.NORMAL:
                default:
                    switcher = new ImageSwitcher();
                break;

            }

            _slideShow = new SlideShow( Config.screenWidth, Config.screenHeight, switcher );
            addChild( _slideShow );

            loadImages( VOSlideShowData( data ).imagePaths );
        }


        private function loadImages( imagePaths:Vector.<String> ):void
        {
            _loader = new LoaderMax( { auditSize: false, onComplete: handleLoadComplete } );

            for each ( var path:String in imagePaths )
            {
                _loader.append( new ImageLoader( path ) );
            }

            _loader.load( true );
        }


        private function destroyLoader():void
        {
            if ( _loader )
            {
                _loader.dispose( true );
                _loader = null;
            }
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get hasPrevious():Boolean
        {
            return _slideShow.hasPrevious;
        }

        public function get hasNext():Boolean
        {
            return _slideShow.hasNext;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleLoadComplete( e:LoaderEvent ):void
        {
            var loaders:Array = _loader.getChildren();

            for each ( var l:ImageLoader in loaders )
            {
                _slideShow.addImage( Bitmap( l.rawContent ).bitmapData );
            }

            _slideShow.start();

            onReady();

            destroyLoader();
        }

    }
}