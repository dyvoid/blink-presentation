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

package nl.imotion.blinkpresentation.model.vo
{
    /**
     * @author Pieter van de Sluis
     */
    public class VOSlideContentData
	{
        private var _type:String;

		private var _path:String;

        private var _scaleMode:String = "none";

        private var _hAlign:String = "center";
        private var _vAlign:String = "center";

		public function VOSlideContentData( type:String ):void
		{
			_type = type;
		}


        public function get type():String
        {
            return _type;
        }


        public function set type( value:String ):void
        {
            _type = value;
        }


        public function get path():String
		{
			return this._path;
		}

        public function set path( value:String ):void
        {
            _path = value;
        }


        public function get scaleMode():String
        {
            return _scaleMode;
        }

        public function set scaleMode( value:String ):void
        {
            _scaleMode = value;
        }


        public function get hAlign():String
        {
            return _hAlign;
        }


        public function set hAlign( value:String ):void
        {
            _hAlign = value;
        }


        public function get vAlign():String
        {
            return _vAlign;
        }


        public function set vAlign( value:String ):void
        {
            _vAlign = value;
        }


    }

}