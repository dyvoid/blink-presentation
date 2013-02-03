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

package nl.imotion.p2p
{
    import flash.events.Event;


    /**
     * @author Pieter van de Sluis
     */
    public class P2PConnectorEvent extends Event
    {
        // EVENT TYPES

        public static const MESSAGE_RECEIVED        :String = "P2PConnectorEvent::MESSAGE_RECEIVED";

        // EVENT DATA

        private var _message   :Message;

        //_________________________________________________________________________________________________________
        //                                                                                    C O N S T R U C T O R

        public function P2PConnectorEvent( type:String, message:Message, bubbles:Boolean = false, cancelable:Boolean = false )
        {
            super( type, bubbles, cancelable );

            _message = message;
        }

        //_________________________________________________________________________________________________________
        //                                                                              P U B L I C   M E T H O D S

        public override function clone():Event
        {
            return new P2PConnectorEvent( type, message, bubbles, cancelable );
        }


        public override function toString():String
        {
            return formatToString( "P2PConnectorEvent", "type", "message", "bubbles", "cancelable", "eventPhase" );
        }

        //_________________________________________________________________________________________________________
        //                                                                          G E T T E R S  /  S E T T E R S

        public function get message():Message
        {
            return _message;
        }

    }
}