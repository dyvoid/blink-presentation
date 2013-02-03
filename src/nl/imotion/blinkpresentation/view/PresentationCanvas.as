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

package nl.imotion.blinkpresentation.view
{
    import com.greensock.TimelineMax;
    import com.greensock.TweenAlign;
    import com.greensock.TweenMax;
    import com.greensock.easing.Quint;

    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;

    import flash.geom.Point;
    import flash.ui.Keyboard;

    import nl.imotion.display.EventManagedSprite;
    import nl.imotion.blinkpresentation.config.Config;
    import nl.imotion.blinkpresentation.definitions.PresentationLayout;
    import nl.imotion.blinkpresentation.model.vo.VOPresentation;
    import nl.imotion.interfaces.IIterator;
    import nl.imotion.util.StageRef;
    import nl.imotion.blinkpresentation.view.slide.Slide;
    import nl.imotion.blinkpresentation.view.events.PresentationCanvasEvent;
    import nl.imotion.utils.grid.GridCalculator;
    import nl.imotion.utils.range.Range;


    /**
     * @author Pieter van de Sluis
     */
    public class PresentationCanvas extends EventManagedSprite implements IIterator
    {

        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _data   :VOPresentation;
        private var _slides :Vector.<Slide>;

        private var _slidesContainer  :Sprite;
        private var _gridCalculator   :GridCalculator;

        private var _index          :uint = 0;

        private var _slideCenterX   :Number;
        private var _slideCenterY   :Number;

        private var _layout         :String;
        private var _layouts        :Array;

        private var _zoomScaleRange             :Range = new Range( 0.1, 1 );
        private var _zoomFactorRange            :Range = new Range( 0, 1 );
        private var _zoomFactor                 :Number = 1;
        private var _zoomActivationThreshold    :Number = 0.85;
        private var _maxZoomDuration            :Number = 1;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function PresentationCanvas()
        {
            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function setData( data:VOPresentation ):void
        {
            _data = data;
            _layout = _data.layout;

            buildSlides();
        }


        public function moveToSlide( index:int ):void
        {
            TweenMax.killTweensOf( this );
            TweenMax.killChildTweensOf(this);
            TweenMax.killTweensOf( _slidesContainer );

            var newIndex:uint = Math.max( 0, Math.min( index, _data.numSlides - 1 ) );
            var newSlide:Slide = _slides[ newIndex ];

            if ( newIndex != _index )
            {
                _slides[ _index ].deactivate();
            }

            if ( !newSlide.delayedReveal )
                _slides[ newIndex ].activate();

            var pos:Point = _gridCalculator.getCellPos( newIndex );

            var duration:Number = _data.slideTransitionDuration;

            if ( _zoomFactor != 1 )
            {
                new TimelineMax( { tweens: [
                    TweenMax.to( _slidesContainer, 1, { x: -pos.x - _slideCenterX, y: -pos.y - _slideCenterY, ease: Quint.easeOut } ),
                    TweenMax.to( this, 1, { scaleX: 1, scaleY: 1, ease: Quint.easeInOut } )
                ], align: TweenAlign.NORMAL, onComplete: ( newSlide.delayedReveal ) ? newSlide.activate : null } );
                _zoomFactor = 1;
            }
            else
            {
                new TimelineMax( { tweens: [
                    TweenMax.to( _slidesContainer, duration, { x: -pos.x - _slideCenterX, y: -pos.y - _slideCenterY, ease: Quint.easeInOut } ),
                    new TimelineMax( { tweens: [
                        TweenMax.to( this, duration * 0.5, { scaleX: 0.8, scaleY: 0.8 } ),
                        TweenMax.to( this, duration * 0.5, { scaleX: 1, scaleY: 1 } )
                    ], align: TweenAlign.SEQUENCE } )
                ], align: TweenAlign.NORMAL, onComplete: ( newSlide.delayedReveal ) ? newSlide.activate : null } );
            }
            
            _index = newIndex;
            toggleSlideSelectability( false );

            dispatchEvent( new PresentationCanvasEvent( PresentationCanvasEvent.SLIDE_CHANGED, _data.slides[ _index ] ) );
        }


        public function moveSlideBy( delta:int ):void
        {
            moveToSlide( _index + delta );
        }


        public function previous():*
        {
            if ( currSlide.hasPrevious )
            {
                return currSlide.previous();
            }
            else if ( hasPrevious )
            {
                moveSlideBy( -1 );

                return _slides[ _index ];
            }

            return null;
        }
        

        public function next():*
        {
            if ( currSlide.hasNext )
            {
                return currSlide.next();
            }
            else if ( hasNext )
            {
                moveSlideBy( 1 );

                return _slides[ _index ];
            }

            return null;
        }


        public function get hasPrevious():Boolean
        {
            return _index > 0;
        }


        public function get hasNext():Boolean
        {
            return _index < _slides.length;
        }


        public function zoomTo( zoomFactor:Number ):void
        {
            zoomFactor = _zoomFactorRange.constrain( zoomFactor );

            if ( _zoomFactor == zoomFactor ) return;

            if ( zoomFactor == 1 )
            {
                moveToSlide( _index );
            }
            else
            {
                var newZoomFactor:Number = _zoomScaleRange.getValueFromRelativePos( zoomFactor );

                TweenMax.to( this, 1, { scaleX: newZoomFactor, scaleY: newZoomFactor, ease: Quint.easeOut } );
            }

            _zoomFactor = zoomFactor;

            if ( _zoomFactor < _zoomActivationThreshold )
            {
                if ( currSlide.isActivated )
                {
                    currSlide.deactivate();
                }

                toggleSlideSelectability( true );
            }
            else
            {
                if ( !currSlide.isActivated )
                {
                    currSlide.activate();
                }

                toggleSlideSelectability( false );
            }
        }


        public function zoomBy( zoomDelta:Number ):void
        {
            var zoomFactor:Number = _zoomFactorRange.constrain( _zoomFactor + zoomDelta );
            zoomTo( zoomFactor );
        }


        public function zoomOut():void
        {
            zoomTo( 0 );
        }
        

        public function zoomIn():void
        {
            zoomTo( 1 );
        }


        private function toggleSlideSelectability( isSelectable:Boolean ):void
        {
            for each ( var slide:Slide in _slides )
            {
                slide.isSelectable = isSelectable;
                slide.toggleIdentifier( isSelectable );
            }

            if ( isSelectable )
            {
                addEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
            }
            else
            {
                removeEventListener( MouseEvent.MOUSE_DOWN, handleMouseDown );
            }
        }


        public function changeLayout( layout:String ):void
        {
            if ( _layout == layout ) return;

            _layout = layout;

            createGridCalculator();

            for ( var i:int = 0; i < _data.numSlides; i++ )
            {
                var slide:Slide = _slides[ i ];
                var slidePos:Point = _gridCalculator.getCellPos( i );

                var duration:Number = 0.2 + ( 0.1 * i );

                if ( _zoomFactor < 1 )
                {
                    TweenMax.to( slide, duration, { x: slidePos.x, y: slidePos.y, ease: Quint.easeInOut } );
                }
                else
                {
                    slide.x = slidePos.x;
                    slide.y = slidePos.y;
                }
            }

            var newSlidePos:Point = _gridCalculator.getCellPos( _index );
            var slideContainerTargetX:Number = -newSlidePos.x - _slideCenterX;
            var slideContainerTargetY:Number = -newSlidePos.y - _slideCenterY;

            if ( _zoomFactor < 1 )
            {
                TweenMax.to( _slidesContainer, 2, { x: slideContainerTargetX, y: slideContainerTargetY, ease: Quint.easeInOut } );
            }
            else
            {
                _slidesContainer.x = slideContainerTargetX;
                _slidesContainer.y = slideContainerTargetY;
            }
        }


        public function changeLayoutToPrev():void
        {
            sortLayouts();

            changeLayout( _layouts[ _layouts.length - 1 ] );
        }


        public function changeLayoutToNext():void
        {
            sortLayouts();

            changeLayout( _layouts[ 1 ] );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            _slideCenterX = Config.screenWidth  * 0.5;
            _slideCenterY = Config.screenHeight * 0.5;

            this.x = _slideCenterX;
            this.y = _slideCenterY;

            _layouts = PresentationLayout.getAll().concat();

            _slidesContainer = new Sprite();
            _slidesContainer.x = -_slideCenterX;
            _slidesContainer.y = -_slideCenterY;
            this.addChild( _slidesContainer );

            initListeners();
        }


        private function initListeners():void
        {
            var stage:Stage = StageRef.getStage();

            stage.addEventListener( MouseEvent.MOUSE_WHEEL, handleMouseWheel );
            stage.addEventListener( KeyboardEvent.KEY_DOWN, handleKeyDown );
        }


        private function buildSlides():void
        {
            _slides = new Vector.<Slide>();

            createGridCalculator();

            for ( var i:int = 0; i < _data.numSlides; i++ )
            {
                var slide:Slide = new Slide();
                slide.setData( _data.slides[i] );
                slide.addEventListener( Event.SELECT, handleSlideSelect );

                var slidePos:Point = _gridCalculator.getCellPos( i );
                slide.x = slidePos.x;
                slide.y = slidePos.y;
                
                _slidesContainer.addChild( slide );

                _slides.push( slide );
            }

            _slides[ 0 ].activate();
        }


        private function getSlideIndex( slide:Slide ):int
        {
            for ( var i:int = 0; i < _slides.length; i++ )
            {
                var currSlide:Slide = _slides[i];

                if ( currSlide == slide )
                    return i;
            }

            return -1;
        }


        private function createGridCalculator():void
        {
            var numCols:uint;

            switch( _layout )
            {
                case PresentationLayout.GRID:
                    numCols = Math.ceil( Math.sqrt( _data.numSlides ) );
                break;

                case PresentationLayout.HORIZONTAL:
                    numCols = _data.numSlides;
                break;

                case PresentationLayout.VERTICAL:
                    numCols = 1;
                break;
            }

            _gridCalculator = new GridCalculator( numCols, Config.screenWidth, Config.screenHeight, 150, _data.numSlides );
        }


        private function sortLayouts():void
        {
            while( _layouts[ 0 ] != _layout )
            {
                _layouts.unshift( _layouts.pop() );
            }
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        private function get currSlide():Slide
        {
            return _slides[ _index ];
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleSlideSelect( e:Event ):void
        {
            var index:uint = getSlideIndex( e.target as Slide );
            moveToSlide( index );
        }


        private function handleMouseDown( e:MouseEvent ):void
        {
            addEventListener( MouseEvent.MOUSE_UP, handleMouseUp );

            _slidesContainer.startDrag( false );
        }


        private function handleMouseUp( e:MouseEvent ):void
        {
            _slidesContainer.stopDrag();
        }


        public function handleKeyDown( e:KeyboardEvent ):void
        {
            switch ( e.keyCode )
            {
                case Keyboard.LEFT:
                    previous();
                break;

                case Keyboard.RIGHT:
                case Keyboard.SPACE:
                    next();
                break;

                case Keyboard.DOWN:
                    zoomOut();
                break;

                case Keyboard.UP:
                    zoomIn();
                break;

                case Keyboard.MINUS:
                    zoomBy( -0.2 );
                break;

                case Keyboard.EQUAL:
                    if ( e.shiftKey )
                        zoomBy( 0.2 );
                break;

                case Keyboard.LEFTBRACKET:
                    changeLayoutToPrev();
                break;

                case Keyboard.RIGHTBRACKET:
                    changeLayoutToNext();
                break;
            }
        }


        private function handleMouseWheel( e:MouseEvent ):void
        {
            zoomBy( e.delta * 0.05 );
        }
        
    }
    
}