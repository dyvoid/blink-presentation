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

package nl.imotion.blinkpresentation.view.slide
{
    import nl.imotion.blinkpresentation.view.background.*;
    import com.greensock.TweenMax;
    import com.greensock.loading.ImageLoader;
    import com.greensock.loading.LoaderMax;
    import com.greensock.loading.LoaderStatus;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    import nl.imotion.blinkpresentation.config.Config;
    import nl.imotion.blinkpresentation.definitions.ContentType;
    import nl.imotion.blinkpresentation.model.vo.VOSlide;
    import nl.imotion.blinkpresentation.model.vo.VOSlideContentData;
    import nl.imotion.blinkpresentation.model.vo.VOSlideShowData;
    import nl.imotion.blinkpresentation.model.vo.VOVideoData;
    import nl.imotion.blinkpresentation.view.slide.content.ImageContent;
    import nl.imotion.blinkpresentation.view.slide.content.SWFContent;
    import nl.imotion.blinkpresentation.view.slide.content.SlideContent;
    import nl.imotion.blinkpresentation.view.slide.content.SlideShowContent;
    import nl.imotion.blinkpresentation.view.slide.content.VideoContent;
    import nl.imotion.display.EventManagedSprite;
    import nl.imotion.interfaces.IIterator;
    import nl.imotion.interfaces.INextIterator;
    import nl.imotion.interfaces.IPreviousIterator;


    /**
     * @author Pieter van de Sluis
     */
    public class Slide extends EventManagedSprite implements IIterator
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        // ASSETS

        private var _background         :Sprite;
        private var _contentContainer   :Sprite;
        private var _titleContainer     :Sprite;
        private var _thumbContainer     :Sprite;
        private var _identifier         :Sprite;

        // FIELDS

        private var _data               :VOSlide;

        private var _thumbBMD           :BitmapData;
        private var _thumbIsLocked      :Boolean = false;

        private var _isSelectable       :Boolean = false;

        private var _isActivated        :Boolean = false;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Slide()
        {
            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function setData( data:VOSlide ):void
        {
            _data = data;

            build();
        }


        public function activate():void
        {
            if ( _isActivated  ) return;

            loadContent();

            _isActivated = true;
        }


        public function deactivate():void
        {
            if ( !_isActivated ) return;

            var screenShot:BitmapData = new BitmapData( Config.screenWidth, Config.screenHeight, false, _data.bgColor );
            screenShot.draw( this, null, null, null, _contentContainer.scrollRect );
            
            clearContents();

            _contentContainer.addChild( new Bitmap( screenShot ) );

            if ( !_thumbIsLocked )
            {
                var m:Matrix = new Matrix();
                m.scale( Config.thumbWidth / Config.screenWidth, Config.thumbHeight / Config.screenHeight );
                _thumbBMD.draw( screenShot, m, null, null, null, true );
            }

            showThumb();

            _isActivated = false;
        }


        public function toggleIdentifier( isVisible:Boolean, useAnimation:Boolean = true ):void
        {
            if ( _identifier.visible == isVisible ) return;
            
            var targetAlpha:Number = isVisible ? 1 : 0;

            if ( useAnimation )
            {
                TweenMax.to( _identifier, 0.75, { autoAlpha: targetAlpha } );
            }
            else
            {
                _identifier.visible = isVisible;
                _identifier.alpha = targetAlpha;
            }
        }


        public function previous():*
        {
            for ( var i:int = 0; i < _contentContainer.numChildren; i++ )
            {
                var displayObject:DisplayObject = _contentContainer.getChildAt( i );

                var iterator:IPreviousIterator = displayObject as IPreviousIterator;

                if ( iterator && iterator.hasPrevious )
                {
                    return iterator.previous();
                }
            }

            return null;
        }


        public function next():*
        {
            for ( var i:int = 0; i < _contentContainer.numChildren; i++ )
            {
                var displayObject:DisplayObject = _contentContainer.getChildAt( i );

                var iterator:INextIterator = displayObject as INextIterator;

                if ( iterator && iterator.hasNext )
                {
                    return iterator.next();
                }
            }

            return null;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            _contentContainer = new Sprite();
            addChild( _contentContainer );

            _titleContainer = new Sprite();
            addChild( _titleContainer );

            _thumbContainer = new Sprite();
            addChild( _thumbContainer );

            _identifier = new Sprite();
            _identifier.y = Config.screenHeight;
            addChild( _identifier );

            _contentContainer.scrollRect = new Rectangle( 0, 0, Config.screenWidth, Config.screenHeight );

            toggleIdentifier( false, false );

            doubleClickEnabled = true;
        }


        private function build():void
        {
            _background = new Sprite();
            _background.graphics.beginFill( _data.bgColor );
            _background.graphics.drawRect( 0, 0, Config.screenWidth, Config.screenHeight );
            _background.graphics.endFill();
            _background.filters = [ new GlowFilter( 0, 0.5, 30, 30, 0.5 ) ];
            this.addChildAt( _background, 0 );

            if ( _data.title )
            {
                _titleContainer.addChild( new TitleCard( _data.title, _data.subTitle, 50, _data.titleColor, _data.subTitleColor  ) );
            }

            var identifierText:String = _data.title || _data.id;
            if ( _data.subTitle )
                identifierText += " - " + _data.subTitle;
            _identifier.addChild( new TitleCard( identifierText, null, 0 ) );

            _thumbBMD = new BitmapData( Config.thumbWidth, Config.thumbHeight, false, _data.bgColor );

            var thumbLoader:ImageLoader = LoaderMax.getLoader( Config.THUMB_NAME_PREFIX + _data.id );

            if ( thumbLoader && thumbLoader.status == LoaderStatus.COMPLETED )
            {
                var bm:Bitmap = thumbLoader.rawContent as Bitmap;
                var m:Matrix = new Matrix();
                m.scale( Config.thumbWidth / bm.width, Config.thumbHeight / bm.height );
                _thumbBMD.draw( bm, m, null, null, null, true );
                thumbLoader.dispose( true );
                _thumbIsLocked = true;
            }

            var thumb:Bitmap = new Bitmap( _thumbBMD );
            thumb.smoothing = true;
            thumb.width  = Config.screenWidth;
            thumb.height = Config.screenHeight;
            _thumbContainer.addChild( thumb );
        }


        private function loadContent():void
        {
            var content:SlideContent;

            for each ( var contentData:VOSlideContentData in _data.contents )
            {
                switch( contentData.type )
                {
                    case ContentType.IMAGE:
                        content = new ImageContent( contentData );
                    break;

                    case ContentType.SLIDE_SHOW:
                        content = new SlideShowContent( contentData as VOSlideShowData );
                    break;

                    case ContentType.SWF:
                        content = new SWFContent( contentData );
                    break;

                    case ContentType.VIDEO:
                        content = new VideoContent( contentData as VOVideoData );
                    break;
                }

                _contentContainer.addChild( content as DisplayObject );

                if ( content.isReady )
                {
                    onContentReady();
                }
                else
                {
                    startEventInterest( content, Event.COMPLETE, contentReadyHandler );
                }
            }
        }


        private function clearContents():void
        {
            while( _contentContainer.numChildren > 0 )
            {
                _contentContainer.removeChildAt( 0 );
            }
        }


        private function showThumb():void
        {
            TweenMax.to( _thumbContainer, 0.5, { autoAlpha: 1, onComplete: onShowThumbComplete } );
        }


        private function hideThumb():void
        {
            TweenMax.to( _thumbContainer, 1.5, { autoAlpha: 0 } );
        }


        private function onShowThumbComplete():void
        {
            clearContents();
        }


        private function onContentReady():void
        {
            var numReady:uint = 0;

            for ( var i:int = 0; i < _contentContainer.numChildren; i++ )
            {
                var slideContent:SlideContent = _contentContainer.getChildAt( i ) as SlideContent;

                // Quick hack to make sure nothing happens when the slide is being deactivated
                if ( !slideContent ) return;

                if ( slideContent.isReady )
                {
                    numReady++;
                }
            }

            if ( numReady == _data.contents.length )
            {
                hideThumb();
            }
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        override public function get width():Number
        {
            return Config.screenWidth;
        }


        override public function get height():Number
        {
            return Config.screenHeight;
        }


        public function get delayedReveal():Boolean
        {
            return _data.delayedReveal;
        }


        public function get isSelectable():Boolean
        {
            return _isSelectable;
        }


        public function set isSelectable( value:Boolean ):void
        {
            if ( _isSelectable == value ) return;

            _isSelectable = value;

            this.mouseChildren = !_isSelectable;

            if ( _isSelectable )
            {
                addEventListener( MouseEvent.DOUBLE_CLICK, handleDoubleClick );
            }
            else
            {
                if ( hasEventListener( MouseEvent.DOUBLE_CLICK ) )
                {
                    removeEventListener( MouseEvent.DOUBLE_CLICK, handleDoubleClick );
                }
            }
        }


        public function get isActivated():Boolean
        {
            return _isActivated;
        }


        public function get hasPrevious():Boolean
        {
            for ( var i:int = 0; i < _contentContainer.numChildren; i++ )
            {
                var displayObject:DisplayObject = _contentContainer.getChildAt( i );

                var iterator:IPreviousIterator = displayObject as IPreviousIterator;

                if ( iterator && iterator.hasPrevious )
                {
                    return true
                }
            }

            return false;
        }


        public function get hasNext():Boolean
        {
            for ( var i:int = 0; i < _contentContainer.numChildren; i++ )
            {
                var displayObject:DisplayObject = _contentContainer.getChildAt( i );

                var iterator:INextIterator = displayObject as INextIterator;

                if ( iterator && iterator.hasNext )
                {
                    return true;
                }
            }

            return false;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleDoubleClick( e:MouseEvent ):void
        {
            dispatchEvent( new Event( Event.SELECT ) );
        }


        private function contentReadyHandler( e:Event ):void
        {
            stopEventInterest( e.target, Event.COMPLETE, contentReadyHandler );

            onContentReady();
        }

    }

}