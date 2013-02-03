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

package nl.imotion.blinkpresentation.model
{
    import com.greensock.events.LoaderEvent;
    import com.greensock.loading.ImageLoader;
    import com.greensock.loading.LoaderMax;
    import com.greensock.loading.XMLLoader;

    import nl.imotion.bindmvc.model.BindModel;
    import nl.imotion.blinkpresentation.definitions.ContentType;
    import nl.imotion.blinkpresentation.model.RemoteModel;
    import nl.imotion.blinkpresentation.model.vo.VOSlideContentData;
    import nl.imotion.blinkpresentation.model.vo.VOSlideShowData;
    import nl.imotion.blinkpresentation.model.vo.VOVideoData;
    import nl.imotion.notes.DataNote;
    import nl.imotion.blinkpresentation.config.Config;
    import nl.imotion.blinkpresentation.definitions.BlinkNote;
    import nl.imotion.blinkpresentation.model.vo.VOPresentation;
    import nl.imotion.blinkpresentation.model.vo.VOSlide;


    /**
     * @author Pieter van de Sluis
     */
    public class PresentationModel extends BindModel
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        public static const NAME:String = "PresentationModel";

        private var _presentationData:VOPresentation;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function PresentationModel()
        {
            super( NAME );

            loadXML();
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function loadXML():void
        {
            var loader:XMLLoader = new XMLLoader( "presentation.xml", { onComplete: handleXMLLoadComplete } );
            loader.load();
        }


        private function parseXml( xml:XML ):void
        {
            var presentationNode:XML = xml.presentation[ 0 ];

            Config.thumbWidth  = uint( presentationNode.@thumbWidth );
            Config.thumbHeight = uint( presentationNode.@thumbHeight );

            Config.fullScreen = ( presentationNode.@fullScreen == "true" );

            Config.useRemote = ( presentationNode.@useRemote == "true" );

            _presentationData = new VOPresentation();

            if ( exists( presentationNode.@layout ) ) _presentationData.layout = presentationNode.@layout;

            var loader:LoaderMax = new LoaderMax( { onComplete: handleThumbsLoadComplete } );

            for each ( var slideNode:XML in presentationNode.slides.children() )
            {
                var slideData:VOSlide = new VOSlide( slideNode.@id );

                var slidePath:String = "slides/" + slideData.id;

                if ( exists( slideNode.@bgColor ) ) slideData.bgColor = uint( slideNode.@bgColor );
                if ( exists( slideNode.@delayedReveal ) ) slideData.delayedReveal = ( slideNode.@delayedReveal == "true" );

                slideData.title = getValue( slideNode.title );
                slideData.subTitle = getValue( slideNode.subTitle );
                if ( exists( slideNode.title.@color ) ) slideData.titleColor = uint( slideNode.title.@color );
                if ( exists( slideNode.subTitle.@color ) ) slideData.subTitleColor = uint( slideNode.subTitle.@color );

                slideData.notes = getValue( slideNode.notes );

                var contentData:VOSlideContentData;

                for each ( var contentNode:XML in slideNode.content.children() )
                {
                    var contentType:String = contentNode.name();

                    switch( contentType )
                    {
                        case ContentType.SLIDE_SHOW:
                            contentData = new VOSlideShowData( contentType );
                            contentData.path = slidePath;

                            for each ( var imageNode:XML in contentNode.children() )
                            {
                                VOSlideShowData( contentData ).addImage( imageNode.@src );
                            }

                            if ( exists( contentNode.@imageSwitcher ) )
                            {
                                VOSlideShowData( contentData ).imageSwitcher = contentNode.@imageSwitcher;
                            }
                        break;

                        case ContentType.VIDEO:
                            contentData = new VOVideoData( contentType );
                            contentData.path = slidePath + "/" + contentNode.@src;

                            if ( exists( contentNode.@autoPlay ) )
                            {
                                VOVideoData( contentData ).autoPlay = ( contentNode.@autoPlay == "true" );
                            }
                        break;

                        default:
                            contentData = new VOSlideContentData( contentType );
                            contentData.path = slidePath + "/" + contentNode.@src;
                        break;
                    }

                    if ( exists( contentNode.@scaleMode ) ) contentData.scaleMode = contentNode.@scaleMode;
                    if ( exists( contentNode.@hAlign ) ) contentData.hAlign = contentNode.@hAlign;
                    if ( exists( contentNode.@vAlign ) ) contentData.vAlign = contentNode.@vAlign;

                    slideData.addContentData( contentData );
                }

                _presentationData.addSlide( slideData );

                loader.append( new ImageLoader( "slides/" + slideData.id + "/thumb.jpg", { name: Config.THUMB_NAME_PREFIX + slideData.id } ) );
            }

            loader.append( new ImageLoader( "background_tile.jpg", { name: Config.BACKGROUND_LOADER_ID } ) );

            loader.load();
        }


        private function exists( xmlValue:* ):Boolean
        {
            return ( xmlValue != undefined );
        }


        private function getValue( xmlValue:* ):*
        {
            return ( exists( xmlValue ) ) ? xmlValue : null;
        }


        private function broadcastLoadComplete():void
        {
            dispatchNote( new DataNote( BlinkNote.STATE_DATA_LOAD_COMPLETE, _presentationData ) );
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS

        private function handleXMLLoadComplete( e:LoaderEvent ):void
        {
            var loader:XMLLoader = e.target as XMLLoader;
            parseXml( loader.content as XML );
            loader.dispose( true );
        }


        private function handleThumbsLoadComplete( e:LoaderEvent ):void
        {
            broadcastLoadComplete();
        }

    }

}