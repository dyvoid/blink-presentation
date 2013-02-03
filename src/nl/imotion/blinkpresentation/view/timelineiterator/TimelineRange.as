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

package nl.imotion.blinkpresentation.view.timelineiterator
{

    /**
     * Package:    nl.bijenkorf.maffemarathon.view.components.buttons
     * Class:      FrameLabelData
     *
     * @author     pieter.van.de.sluis
     * @since      4/27/11
     */
    public final class TimelineRange
    {
        private var _name:String;
        private var _startFrameNr:int;
		private var _endFrameNr:int;

        //_________________________________________________________________________________________________________
        //                                                                                    C O N S T R U C T O R

        public function TimelineRange( name:String = null, startFrameNr:int = -1, endFrameNr:int = -1 ):void
		{
			_name = name;
			_startFrameNr = startFrameNr;
			_endFrameNr = endFrameNr;
		}

        //_________________________________________________________________________________________________________
        //                                                                              P U B L I C   M E T H O D S

        public function isWithin( frameNr:uint ):Boolean
        {
            return frameNr >= _startFrameNr && frameNr <= _endFrameNr;
        }

        //_________________________________________________________________________________________________________
        //                                                                          G E T T E R S  /  S E T T E R S

        public function get name():String { return _name; }

        public function set name( value:String ):void
        {
            _name = value;
        }


        public function get startFrameNr():uint { return _startFrameNr; }

		public function set startFrameNr( value:uint ):void
		{
			_startFrameNr = value;
		}


		public function get endFrameNr():uint { return _endFrameNr; }

		public function set endFrameNr( value:uint ):void
		{
			_endFrameNr = value;
		}
        

        public function get length():uint
        {
            if ( startFrameNr == -1 || endFrameNr == -1 )
                return 0;

            return _endFrameNr - _startFrameNr;
        }

        //_________________________________________________________________________________________________________
        //                                                                              E V E N T   H A N D L E R S



        //_________________________________________________________________________________________________________
        //                                                                        P R O T E C T E D   M E T H O D S



        //_________________________________________________________________________________________________________
        //                                                                            P R I V A T E   M E T H O D S


	}
}