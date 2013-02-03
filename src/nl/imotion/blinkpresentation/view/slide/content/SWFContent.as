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

package nl.imotion.blinkpresentation.view.slide.content
{
    import com.greensock.events.LoaderEvent;
    import com.greensock.layout.AlignMode;
    import com.greensock.layout.ScaleMode;
    import com.greensock.loading.SWFLoader;
    import com.greensock.loading.data.SWFLoaderVars;

    import flash.display.DisplayObject;

    import flash.display.Sprite;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.system.Security;
    import flash.system.SecurityDomain;

    import nl.imotion.blinkpresentation.config.Config;
    import nl.imotion.blinkpresentation.model.vo.VOSlideContentData;
    import nl.imotion.interfaces.IIterator;
    import nl.imotion.interfaces.INextIterator;
    import nl.imotion.interfaces.IPreviousIterator;


    /**
     * @author Pieter van de Sluis
     */
    public class SWFContent extends SlideContent implements IIterator
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _loader:SWFLoader;

        private var _content:DisplayObject;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR
        
        public function SWFContent( data:VOSlideContentData )
        {
            super( data );

            init();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC

        override public function destroy():void
        {
            _loader.dispose( true );
            _loader = null;

            super.destroy();
        }


        public function previous():*
        {
            if ( _content is IPreviousIterator )
            {
                return IPreviousIterator( _content ).previous();
            }

            return null;
        }


        public function next():*
        {
            if ( _content is INextIterator )
            {
                return INextIterator( _content ).next();
            }

            return null;
        }

        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init():void
        {
            var loadVars:SWFLoaderVars = new SWFLoaderVars();
            loadVars.container( this );
            loadVars.width( Config.screenWidth );
            loadVars.height( Config.screenHeight );
            loadVars.scaleMode( data.scaleMode );
            loadVars.hAlign( data.hAlign );
            loadVars.vAlign( data.vAlign );
            loadVars.suppressUncaughtErrors( true );
//            loadVars.context( new LoaderContext( false, new ApplicationDomain() ) );
            loadVars.onComplete( handleContentLoadComplete );
            _loader = new SWFLoader( data.path, loadVars );
            _loader.load();
        }
        
        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS

        public function get hasPrevious():Boolean
        {
            if ( _content is IPreviousIterator )
            {
                return IPreviousIterator( _content ).hasPrevious;
            }

            return false;
        }


        public function get hasNext():Boolean
        {
            if ( _content is INextIterator )
            {
                return INextIterator( _content ).hasNext;
            }

            return false;
        }

        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleContentLoadComplete( e:LoaderEvent ):void
        {
            _content = SWFLoader( e.target).rawContent as DisplayObject;

            onReady();
        }

    }

}