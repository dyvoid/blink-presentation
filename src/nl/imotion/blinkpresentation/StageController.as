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

package nl.imotion.blinkpresentation
{
    import com.greensock.loading.ImageLoader;
    import com.greensock.loading.LoaderMax;
    import com.greensock.loading.LoaderStatus;

    import flash.display.Bitmap;

    import flash.display.Stage;
    import flash.display.StageDisplayState;

    import nl.imotion.bindmvc.controller.BindController;
    import nl.imotion.blinkpresentation.model.RemoteModel;
    import nl.imotion.notes.DataNote;
    import nl.imotion.blinkpresentation.config.Config;
    import nl.imotion.blinkpresentation.definitions.BlinkNote;
    import nl.imotion.blinkpresentation.model.vo.VOPresentation;
    import nl.imotion.blinkpresentation.view.PresentationCanvas;
    import nl.imotion.blinkpresentation.view.PresentationCanvasController;
    import nl.imotion.blinkpresentation.view.background.Background;


    /**
     * @author Pieter van de Sluis
     */
    public class StageController extends BindController
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES


        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function StageController( defaultView:Stage )
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
            startNoteInterest( BlinkNote.STATE_DATA_LOAD_COMPLETE, handleDataLoadComplete );
        }


        private function start( presentationData:VOPresentation ):void
        {
            if ( Config.fullScreen )
            {
                view.displayState = StageDisplayState.FULL_SCREEN;
            }

            Config.screenWidth = view.stageWidth;
            Config.screenHeight = view.stageHeight;

            var tileLoader:ImageLoader = LoaderMax.getLoader( Config.BACKGROUND_LOADER_ID ) as ImageLoader;

            if ( tileLoader && tileLoader.status == LoaderStatus.COMPLETED )
            {
                var background:Background = new Background( Bitmap( tileLoader.rawContent ).bitmapData );
                view.addChild( background );
                tileLoader.dispose( true );
            }

            if ( Config.useRemote )
                new RemoteModel();

            var canvas:PresentationCanvas = new PresentationCanvas();
            view.addChild( canvas );

            new PresentationCanvasController( canvas );

            canvas.setData( presentationData );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get view():Stage
        {
            return defaultView as Stage;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleDataLoadComplete( n:DataNote ):void
        {
            start( VOPresentation( n.data ) );
        }

    }
    
}