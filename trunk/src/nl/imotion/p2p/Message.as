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
    /**
     * @author Pieter van de Sluis
     */
    public class Message
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _type       :String;
        private var _data       :Object;
        private var _sender     :String;
        private var _timeStamp  :uint;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function Message( type:String = null, data:Object = null )
        {
            _type = type;
            _data = data;
        }

        // ____________________________________________________________________________________________________
        // PUBLIC



        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get type():String
        {
            return _type;
        }

        public function set type( value:String ):void
        {
            _type = value;
        }


        public function get data():Object
        {
            return _data;
        }


        public function set data( value:Object ):void
        {
            _data = value;
        }


        public function get sender():String
        {
            return _sender;
        }


        public function set sender( value:String ):void
        {
            _sender = value;
        }


        public function get timeStamp():uint
        {
            return _timeStamp;
        }


        public function set timeStamp( value:uint ):void
        {
            _timeStamp = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}