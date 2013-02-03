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

package nl.imotion.blinkpresentation.view.videoplayer
{
    import com.greensock.layout.AlignMode;
    import com.greensock.layout.ScaleMode;
    import com.greensock.loading.VideoLoader;
    import com.greensock.loading.data.VideoLoaderVars;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import nl.imotion.blinkpresentation.config.Config;
    import nl.imotion.blinkpresentation.view.videoplayer.scrubber.Scrubber;
    import nl.imotion.blinkpresentation.view.videoplayer.scrubber.ScrubberVC;
    import nl.imotion.display.EventManagedSprite;


    /**
     * @author Pieter van de Sluis
     */
    public class VideoPlayer extends EventManagedSprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _loader:VideoLoader;

        private var _container:Sprite;

        private var _scrubber:Scrubber;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function VideoPlayer()
        {
            init();
        }
        // ____________________________________________________________________________________________________
        // PUBLIC

        public function load( url:String, autoPlay:Boolean = true, scaleMode:String = "none" ):void
        {
            var loadVars:VideoLoaderVars = new VideoLoaderVars();
            loadVars.container( _container );
            loadVars.width( Config.screenWidth );
            loadVars.height( Config.screenHeight );
            loadVars.scaleMode( scaleMode );
            loadVars.hAlign( AlignMode.CENTER );
            loadVars.vAlign( AlignMode.CENTER );
            loadVars.autoPlay( autoPlay );
            loadVars.smoothing( true );

            _loader = new VideoLoader( url, loadVars );
            _loader.load();

            _scrubber.setPlayer( _loader );
        }


        override public function destroy():void
        {
            _loader.dispose( true );
            _loader = null;

            super.destroy();
        }


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            _container = new Sprite();
            this.addChild( _container );

            _scrubber = new ScrubberVC();
            _scrubber.x = Config.screenWidth * 0.5;
            _scrubber.y = Config.screenHeight * 0.5;
            this.addChild( _scrubber );

            startEventInterest( _container, MouseEvent.CLICK, handleContainerClick );
            startEventInterest( this, MouseEvent.MOUSE_MOVE, handleMouseMove );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleMouseMove( e:MouseEvent ):void
        {
            if ( e.stageY > Config.screenHeight * 0.25 && e.stageY < Config.screenHeight * 0.75 )
            {
                _scrubber.transitionIn();
            }
            else
            {
                _scrubber.transitionOut();
            }
        }


        private function handleContainerClick( e:Event ):void
        {
            if ( _loader.videoPaused )
            {
                _loader.playVideo();
            }
            else
            {
                _loader.pauseVideo();
            }
        }

    }
}