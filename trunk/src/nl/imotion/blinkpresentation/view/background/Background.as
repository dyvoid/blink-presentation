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

package nl.imotion.blinkpresentation.view.background
{
    import com.greensock.loading.ImageLoader;
    import com.greensock.loading.LoaderMax;
    import com.greensock.loading.LoaderStatus;

    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.GradientType;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;

    import nl.imotion.blinkpresentation.config.Config;


    /**
     * @author Pieter van de Sluis
     */
    public class Background extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _tile       :BitmapData;
        private var _vignet     :Sprite;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Background( tile:BitmapData )
        {
            _tile = tile;

            if ( stage ) init();
            else addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            _vignet = new Sprite();
//            _vignet.blendMode = BlendMode.OVERLAY;
            this.addChild( _vignet );

            stage.addEventListener( Event.RESIZE, stageResizeHandler );

            draw();
        }


        private function draw():void
        {
            graphics.clear();
            graphics.beginBitmapFill( _tile );
            graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
            graphics.endFill();

            var m:Matrix = new Matrix();
            m.createGradientBox( stage.stageWidth, stage.stageHeight );
            _vignet.graphics.clear();
            _vignet.graphics.beginGradientFill( GradientType.RADIAL, [ 0x000000, 0x000000 ], [ 0, 0.3 ], [ 0x00, 0xff ], m );
            _vignet.graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
            _vignet.graphics.endFill();
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


        private function stageResizeHandler( e:Event ):void
        {
            draw();
        }

    }
    
}