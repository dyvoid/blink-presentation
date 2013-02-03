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
    public class VOSlide
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _id             :String;

        private var _thumbPath      :String;

        private var _contents       :Vector.<VOSlideContentData>;

        private var _title          :String;
        private var _titleColor     :uint = 0x000000;
        private var _subTitle       :String;
        private var _subTitleColor  :uint = 0x000000;

        private var _bgColor        :uint = 0xffffff;

        private var _delayedReveal  :Boolean = false;

        private var _notes          :String;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function VOSlide( id:String = null )
        {
            _id = id;

            _contents = new Vector.<VOSlideContentData>();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function fromObject( object:Object ):void
        {
            _id = object.id;
            _thumbPath = object.thumbPath;
            _title = object.title;
            _titleColor = parseInt( object.titleColor );
            _subTitle = object.subTitle;
            _subTitleColor = parseInt( object.subTitleColor );
            _bgColor = parseInt( object.bgColor );
            _delayedReveal = object.delayedReveal;
            _notes = object.notes;
        }


        public function addContentData( content:VOSlideContentData ):void
        {
            _contents.push( content );
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get id():String
        {
            return _id;
        }

        public function set id( value:String ):void
        {
            _id = value;
        }


        public function get thumbPath():String
        {
            return _thumbPath;
        }

        public function set thumbPath( value:String ):void
        {
            _thumbPath = value;
        }


        public function get bgColor():uint
        {
            return _bgColor;
        }

        public function set bgColor( value:uint ):void
        {
            _bgColor = value;
        }


        public function get contents():Vector.<VOSlideContentData>
        {
            return _contents;
        }


        public function set contents( value:Vector.<VOSlideContentData> ):void
        {
            _contents = value;
        }


        public function get title():String
        {
            return _title;
        }

        public function set title( value:String ):void
        {
            _title = value;
        }


        public function get subTitle():String
        {
            return _subTitle;
        }

        public function set subTitle( value:String ):void
        {
            _subTitle = value;
        }


        public function get titleColor():uint
        {
            return _titleColor;
        }

        public function set titleColor( value:uint ):void
        {
            _titleColor = value;
        }


        public function get subTitleColor():uint
        {
            return _subTitleColor;
        }

        public function set subTitleColor( value:uint ):void
        {
            _subTitleColor = value;
        }


        public function get delayedReveal():Boolean
        {
            return _delayedReveal;
        }

        public function set delayedReveal( value:Boolean ):void
        {
            _delayedReveal = value;
        }


        public function get notes():String
        {
            return _notes;
        }

        public function set notes( value:String ):void
        {
            _notes = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS



    }
    
}