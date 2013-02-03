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

package nl.imotion.blinkpresentation.model
{
    import flash.events.Event;

    import nl.imotion.bindmvc.model.BindModel;
    import nl.imotion.blinkpresentation.definitions.RemoteMessageType;
    import nl.imotion.p2p.Message;
    import nl.imotion.notes.Note;
    import nl.imotion.p2p.P2PConnector;
    import nl.imotion.p2p.P2PConnectorEvent;
    import nl.imotion.blinkpresentation.definitions.BlinkNote;
    import nl.imotion.blinkpresentation.model.vo.VOSlide;


    /**
     * @author Pieter van de Sluis
     */
    public class RemoteModel extends BindModel
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const NAME:String = "RemoteModel";

        private var _connector       :P2PConnector;

        private var _isActive        :Boolean = true;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function RemoteModel()
        {
            super( NAME );

            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function broadcastSlideChange( slideData:VOSlide ):void
        {
            if ( !_isActive ) return;

            _connector.sendMessage( RemoteMessageType.STATE_SLIDE_UPDATE, slideData );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            createConnector();
        }


        private function createConnector():void
        {
            _connector = new P2PConnector();
            _connector.addEventListener( Event.CONNECT, handleConnect );
            _connector.addEventListener( P2PConnectorEvent.MESSAGE_RECEIVED, handleMessage );
            _connector.connect();
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get isActive():Boolean
        {
            return _isActive;
        }

        public function set isActive( value:Boolean ):void
        {
            _isActive = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleConnect( e:Event ):void
        {
            //
        }


        private function handleMessage( e:P2PConnectorEvent ):void
        {
            if ( !_isActive ) return;

            switch ( e.message.type )
            {
                case RemoteMessageType.ACTION_SHOW_PREV_SLIDE:
                    dispatchNote( new Note( BlinkNote.ACTION_SHOW_PREV_SLIDE ) );
                break;

                case RemoteMessageType.ACTION_SHOW_NEXT_SLIDE:
                    dispatchNote( new Note( BlinkNote.ACTION_SHOW_NEXT_SLIDE ) );
                break;
            }
        }

    }

}