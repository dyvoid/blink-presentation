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
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;

    import nl.imotion.blinkpresentation.definitions.RemoteMessageType;
    import nl.imotion.burst.components.stackpanel.StackPanel;
    import nl.imotion.burst.components.stackpanel.StackPanelOrientation;

    import nl.imotion.p2p.P2PConnector;
    import nl.imotion.p2p.P2PConnectorEvent;
    import nl.imotion.blinkpresentation.model.vo.VOSlide;
    import nl.imotion.util.StageRef;


    /**
     * @author Pieter van de Sluis
     */
    public class Remote extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private static const FONT_ID_ARIAL  :String = "arial";
        private static const FONT_ID_BEBAS  :String = "bebas";
        private static const MARGIN:uint = 25;

        private var _connector:P2PConnector;

        private var _tfTitle:TextField;
        private var _tfNotes:TextField;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Remote()
        {
            init();
        }


        private function init():void
        {
            _connector = new P2PConnector();
            _connector.addEventListener( Event.CONNECT, handleConnect );
            _connector.addEventListener( P2PConnectorEvent.MESSAGE_RECEIVED, handleMessage );
            _connector.connect();

            _tfTitle = createTextField( FONT_ID_BEBAS, 40 );
            _tfTitle.x =
            _tfTitle.y = MARGIN;
            _tfTitle.width = StageRef.getStage().stageWidth - MARGIN * 2;
            _tfTitle.height = 50;

            _tfNotes = createTextField( FONT_ID_ARIAL, 25 );
            _tfNotes.x = MARGIN;
            _tfNotes.y = _tfTitle.getRect( this ).bottom;
            _tfNotes.width = StageRef.getStage().stageWidth - MARGIN * 2;
            _tfNotes.height = StageRef.getStage().stageHeight - MARGIN - _tfNotes.y;

            addChild( _tfTitle );
            addChild( _tfNotes );

            StageRef.getStage().addEventListener( KeyboardEvent.KEY_DOWN, handleKeyDown );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function handleKeyDown( e:KeyboardEvent ):void
        {
            trace(e.keyCode);

            switch( e.keyCode )
            {
                case Keyboard.ENTER:
                    _connector.sendMessage( RemoteMessageType.ACTION_SHOW_NEXT_SLIDE );
                break;
            }
        }


        private function showSlide( slideData:VOSlide ):void
        {
            _tfTitle.text = slideData.title || slideData.id;

            var notes:String = "";

            if ( slideData.subTitle )
                notes += slideData.subTitle + "<br>";

            if ( slideData.notes )
                notes += "<br>" + slideData.notes;

            _tfNotes.htmlText = notes;
        }


        private function createTextField( fontID:String, size:uint ):TextField
        {
            var tf:TextField = new TextField();
            tf.embedFonts = true;
            tf.antiAliasType = AntiAliasType.ADVANCED;
            tf.mouseEnabled = false;
            tf.wordWrap = true;
            tf.multiline = true;
            tf.condenseWhite = true;

            var format:TextFormat = new TextFormat();
            format.font = fontID;
            format.size = size;
            format.color = 0xffffff;

            tf.defaultTextFormat = format;

            return tf;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleConnect( e:Event ):void
        {
            _connector.sendMessage( RemoteMessageType.ACTION_GET_CURRENT_SLIDE_DATA );

            NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
        }


        private function handleMessage( e:P2PConnectorEvent ):void
        {
            switch ( e.message.type )
            {
                case RemoteMessageType.STATE_SLIDE_UPDATE:
                    var slideData:VOSlide = new VOSlide( null );
                    slideData.fromObject( e.message.data );
                    showSlide( slideData );
                break;
            }
        }

    }
}