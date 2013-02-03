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
    import com.greensock.TweenMax;
    import com.greensock.easing.Linear;

    import flash.display.FrameLabel;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.utils.Dictionary;

    import nl.imotion.interfaces.IIterator;


    /**
     * @author Pieter van de Sluis
     */
    public class TimelineIterator extends MovieClip implements IIterator
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _timelineRanges:Vector.<TimelineRange>;

        private var _isTransitioning:Boolean = false;

        private var _index:uint = 0;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function TimelineIterator()
        {
            stop();

            if ( stage ) init();
            else addEventListener( Event.ADDED_TO_STAGE, handleAddedToStage );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        public function previous():*
        {
            if ( !hasPrevious || !stage || _isTransitioning ) return;

            _index--;
            gotoAndStop( _timelineRanges[ _index ].endFrameNr );

            return this;
        }


        public function next():*
        {
            if ( !hasNext || !stage || _isTransitioning ) return;

            _index++;
            playRange( _timelineRanges[ _index ] );

            return this;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            gatherTimelineRanges();

            playRange( _timelineRanges[ _index ] );
        }


        private function gatherTimelineRanges():void
        {
            _timelineRanges = new Vector.<TimelineRange>();

            var range:TimelineRange;

            var labels:Array = currentScene.labels;

            if ( labels.length > 0 )
            {
                for ( var i:int = 0; i < labels.length; i++ )
                {
                    var frameLabel:FrameLabel = labels[i];

                    if ( range )
                    {
                        range.endFrameNr = frameLabel.frame - 1;
                    }

                    range = new TimelineRange( frameLabel.name, frameLabel.frame );

                    _timelineRanges.push( range );
                }

                if ( range )
                {
                    range.endFrameNr = currentScene.numFrames;
                }
            }
        }


        private function playRange( range:TimelineRange, playReverse:Boolean = false ):void
        {
            _isTransitioning = true;

            var startFrameNr:uint    = ( !playReverse ) ? range.startFrameNr : this.currentFrame;
            var endFrameNr:uint      = range.endFrameNr;
            
            TweenMax.killTweensOf( this );
            TweenMax.fromTo( this, range.length / stage.frameRate,
                    { frame: startFrameNr },
                    { frame: endFrameNr, ease: Linear.easeNone, onComplete: onTransitionComplete } );
        }
        

        private function onTransitionComplete():void
        {
            _isTransitioning = false;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get hasPrevious():Boolean
        {
            return _index > 0;
        }

        
        public function get hasNext():Boolean
        {
            return _index < _timelineRanges.length - 1;
        }


        public function get isTransitioning():Boolean
        {
            return _isTransitioning;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleAddedToStage( e:Event ):void
        {
            removeEventListener( Event.ADDED_TO_STAGE, handleAddedToStage );
            init();
        }

    }
}