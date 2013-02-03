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

package nl.imotion.blinkpresentation.view
{
    import flash.display.DisplayObject;

    import nl.imotion.bindmvc.controller.BindController;
    import nl.imotion.blinkpresentation.config.Config;
    import nl.imotion.notes.DataNote;
    import nl.imotion.notes.Note;
    import nl.imotion.blinkpresentation.definitions.BlinkNote;
    import nl.imotion.blinkpresentation.model.RemoteModel;
    import nl.imotion.blinkpresentation.model.vo.VOPresentation;
    import nl.imotion.blinkpresentation.view.events.PresentationCanvasEvent;


    /**
     * @author Pieter van de Sluis
     */
    public class PresentationCanvasController extends BindController
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function PresentationCanvasController( defaultView:DisplayObject )
        {
            super( defaultView );

            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            startEventInterest( view, PresentationCanvasEvent.SLIDE_CHANGED, handleSlideChanged );

            startNoteInterest( BlinkNote.ACTION_SHOW_PREV_SLIDE, handlePrevSlide );
            startNoteInterest( BlinkNote.ACTION_SHOW_NEXT_SLIDE, handleNextSlide );

            startNoteInterest( BlinkNote.ACTION_ZOOM_OUT, handleZoomOut );
            startNoteInterest( BlinkNote.ACTION_ZOOM_IN, handleZoomIn );

            startNoteInterest( BlinkNote.ACTION_PREV_LAYOUT, handlePrevLayout );
            startNoteInterest( BlinkNote.ACTION_NEXT_LAYOUT, handleNextLayout );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get view():PresentationCanvas
        {
            return defaultView as PresentationCanvas;
        }


        public function get remoteModel():RemoteModel
        {
            return retrieveModel( RemoteModel.NAME ) as RemoteModel;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleSlideChanged( e:PresentationCanvasEvent ):void
        {
            if ( Config.useRemote )
                remoteModel.broadcastSlideChange( e.slideData );
        }


        private function handlePrevSlide( n:Note ):void
        {
            view.previous();
        }

        private function handleNextSlide( n:Note ):void
        {
            view.next();
        }


        private function handleZoomOut( n:Note ):void
        {
            view.zoomOut();
        }

        private function handleZoomIn( n:Note ):void
        {
            view.zoomIn();
        }


        private function handlePrevLayout( n:Note ):void
        {
            view.changeLayoutToPrev();
        }

        private function handleNextLayout( n:Note ):void
        {
            view.changeLayoutToNext();
        }

    }

}