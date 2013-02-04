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

package nl.imotion.blinkpresentation.remote
{
    import flash.desktop.NativeApplication;
    import flash.desktop.SystemIdleMode;

    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.text.Font;

    import nl.imotion.util.StageRef;


    /**
     * @author Pieter van de Sluis
     */

    [SWF(backgroundColor="#000000",width="600",height="400",frameRate="30")]
    public class Main extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _remote     :Remote;

        [Embed(source="../../../../../assets/fonts/BebasNeue.otf",
            fontName = "bebas",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="false",
            unicodeRange="U+0020-007E,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183")]
        private var Bebas:Class;

        [Embed(source="../../../../../assets/fonts/arial.ttf",
            fontName = "arial",
            mimeType = "application/x-font",
            fontWeight="normal",
            fontStyle="normal",
            advancedAntiAliasing="true",
            embedAsCFF="false",
            unicodeRange="U+0020-007E,U+00A1-00FF,U+2000-206F,U+20A0-20CF,U+2100-2183")]
        private var Arial:Class;

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

            Font.registerFont( Bebas );

            StageRef.setStage( stage );

            _remote = new Remote();
            addChild( _remote );
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