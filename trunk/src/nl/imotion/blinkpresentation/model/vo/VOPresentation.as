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
    import flash.utils.Dictionary;

    import nl.imotion.blinkpresentation.definitions.PresentationLayout;


    /**
     * @author Pieter van de Sluis
     */
    public class VOPresentation
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES
        
        private var _slides             :Vector.<VOSlide>;
        private var _slidesMap          :Dictionary;
        
        private var _layout             :String = PresentationLayout.GRID;
        private var _slideTransitionDuration :Number = 1.5;
        
        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function VOPresentation()
        {
            _slides     = new Vector.<VOSlide>();
            _slidesMap  = new Dictionary();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function addSlide( slideData:VOSlide ):void
        {
            _slides.push( slideData );
            _slidesMap[ slideData.id ] = slideData;
        }


        public function getSlideDataByID( id:String ):VOSlide
        {
            return _slidesMap[ id ];
        }

        // ____________________________________________________________________________________________________
        // PRIVATE


        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get numSlides():uint
        {
            return _slides.length;
        }


        public function get slides():Vector.<VOSlide>
        {
            return _slides;
        }


        public function get layout():String
        {
            return _layout;
        }

        public function set layout( value:String ):void
        {
            _layout = value;
        }


        public function get slideTransitionDuration():Number
        {
            return _slideTransitionDuration;
        }

        public function set slideTransitionDuration( value:Number ):void
        {
            _slideTransitionDuration = value;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}