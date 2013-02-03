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
    import com.greensock.TweenMax;
    import com.greensock.easing.Quint;
    import com.greensock.loading.VideoLoader;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    import nl.imotion.blinkpresentation.config.Config;

    import nl.imotion.display.EventManagedSprite;
    import nl.imotion.util.StageRef;


    /**
     * @author Pieter van de Sluis
     */
    public class Scrubber extends EventManagedSprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public var timeIndicator        :TimeIndicator;
        public var handle               :Sprite;
        public var hairLine             :Sprite;

        private var _loader             :VideoLoader;

        private var _isDragging         :Boolean;

        private var _isShowing          :Boolean;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Scrubber()
        {
            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function setPlayer( loader:VideoLoader ):void
        {
            _loader = loader;
        }
        

        public function transitionIn():void
        {
            if ( _isShowing ) return;

            TweenMax.to( this, 0.5, { autoAlpha: 1 } );

            hairLine.height = parent.height;

            _isShowing = true;
        }


        public function transitionOut():void
        {
            if ( !_isShowing ) return;

            TweenMax.to( this, 0.5, { autoAlpha: 0 } );

            _isShowing = false;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        public function init():void
        {
            timeIndicator.mouseEnabled = false;
            timeIndicator.mouseChildren = false;

            startEventInterest( handle, MouseEvent.MOUSE_DOWN, handleMouseDown );
            startEventInterest( handle, MouseEvent.MOUSE_OVER, handleMouseOver );
            startEventInterest( handle, MouseEvent.MOUSE_OUT, handleMouseOut );

            startEventInterest( handle, Event.ENTER_FRAME, handleEnterFrame );

            this.alpha = 0;
            this.visible = false;
        }


        private function handleMouseOver( e:MouseEvent ):void
        {
            TweenMax.to( handle, 0.25, { scaleX: 2, scaleY: 1, ease: Quint.easeOut } );
        }


        private function handleMouseOut( e:MouseEvent ):void
        {
            TweenMax.to( handle, 0.25, { scaleX: 1, scaleY: 1, ease: Quint.easeIn } );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleMouseDown( e:MouseEvent ):void
        {
            this.startDrag( false, new Rectangle( 0, Config.screenHeight * 0.5, Config.screenWidth, 0 ) );

            startEventInterest( StageRef.getStage(), MouseEvent.MOUSE_UP, handleMouseUp );
            _loader.pauseVideo();

            _isDragging = true;
        }


        private function handleMouseUp( e:MouseEvent ):void
        {
            if ( !_isDragging )
                return;

            this.stopDrag();

            stopEventInterest( StageRef.getStage(), MouseEvent.MOUSE_UP, handleMouseUp );
            _loader.playVideo();

            _isDragging = false;
        }


        private function handleEnterFrame( e:Event ):void
        {
            if ( !_isShowing || !_loader ) return;

            timeIndicator.update( _loader.videoTime );

            if ( _isDragging )
            {
                _loader.playProgress = this.x / Config.screenWidth;
            }
            else
            {
                this.x = _loader.playProgress * Config.screenWidth;
            }

            timeIndicator.x = ( this.x < Config.screenWidth * 0.5 ) ? 0 : -timeIndicator.width;

        }

    }
    
}