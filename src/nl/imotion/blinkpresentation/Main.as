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

package nl.imotion.blinkpresentation
{
    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.ImageLoader;
    import com.greensock.loading.LoaderMax;

    import flash.display.Bitmap;
    import flash.display.Loader;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.media.VideoCodec;
    import flash.system.LoaderContext;
    import flash.text.Font;

    import nl.imotion.bindmvc.core.BindMVCCore;
    import nl.imotion.blinkpresentation.config.Config;
    import nl.imotion.blinkpresentation.model.PresentationModel;
    import nl.imotion.blinkpresentation.model.RemoteModel;
    import nl.imotion.blinkpresentation.view.slide.content.VideoContent;
    import nl.imotion.blinkpresentation.view.videoplayer.VideoPlayer;
    import nl.imotion.util.StageRef;
    import nl.imotion.blinkpresentation.view.slideshow.SlideShow;
    import nl.imotion.blinkpresentation.view.slideshow.imageswitcher.BlurSwitcher;
    import nl.imotion.blinkpresentation.view.slideshow.imageswitcher.CrossFadeSwitcher;
    import nl.imotion.blinkpresentation.view.slideshow.imageswitcher.FlipSwitcher;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(backgroundColor="#ffffff",width="800",height="600",frameRate="30")]
    public class Main extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Main():void
        {
            if ( stage ) init();
            else addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        

        private function init():void
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.quality = StageQuality.BEST;

            Font.registerFont( BebasNeue );

            StageRef.setStage( stage );

            Config.screenWidth  = stage.stageWidth;
            Config.screenHeight = stage.stageHeight;

            var core:BindMVCCore = BindMVCCore.getInstance();
            core.startup( stage, false );

            new StageController( stage );

            new PresentationModel();
        }

        // ____________________________________________________________________________________________________
        // PROTECTED



        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS



        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function addedToStageHandler( e:Event ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
            init();
        }

    }

}