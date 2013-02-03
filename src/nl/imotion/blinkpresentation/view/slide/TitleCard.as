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

package nl.imotion.blinkpresentation.view.slide
{
    import flash.display.Sprite;
    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    import nl.imotion.blinkpresentation.config.Config;


    /**
     * @author Pieter van de Sluis
     */
    public class TitleCard extends Sprite
    {
        // ____________________________________________________________________________________________________
        // PROPERTIES

        private var _tfTitle       :TextField;
        private var _tfSubTitle    :TextField;

        private var _margin        :Number;

        // ____________________________________________________________________________________________________
        // CONSTRUCTOR

        public function TitleCard( title:String, subTitle:String = null, margin:Number = 50, titleColor:uint = 0x000000, subTitleColor:uint = 0x000000 )
        {
            init( title, subTitle, margin, titleColor, subTitleColor );
        }

        // ____________________________________________________________________________________________________
        // PUBLIC


        // ____________________________________________________________________________________________________
        // PRIVATE

        private function init( title:String, subTitle:String, margin:Number, titleColor:uint, subTitleColor:uint ):void
        {
            _tfTitle = createTextField( 72, titleColor );
            _tfTitle.text = title;
            _tfTitle.width = Config.screenWidth - ( margin * 2 );
            _tfTitle.height = _tfTitle.textHeight + 5;

            _tfTitle.x =
            _tfTitle.y = margin;

            this.addChild( _tfTitle );

            if ( subTitle )
            {
                _tfSubTitle = createTextField( 38, subTitleColor );
                _tfSubTitle.text = subTitle;
                _tfSubTitle.width = Config.screenWidth - ( margin * 2 );
                _tfSubTitle.height = _tfSubTitle.textHeight + 5;

                _tfSubTitle.x = margin;
                _tfSubTitle.y = _tfTitle.getBounds( this ).bottom - 20;

                this.addChild( _tfSubTitle );
            }
        }


        private function createTextField( size:uint, color:uint ):TextField
        {
            var tf:TextField = new TextField();
            tf.embedFonts = true;
            tf.antiAliasType = AntiAliasType.ADVANCED;
            tf.mouseEnabled = false;
            tf.wordWrap = false;

            var format:TextFormat = new TextFormat();
            format.font = "Bebas Neue";
            format.size = size;
            format.color = color;
            format.align = TextFormatAlign.CENTER;

            tf.defaultTextFormat = format;

            return tf;
        }

        // ____________________________________________________________________________________________________
        // PROTECTED


        // ____________________________________________________________________________________________________
        // GETTERS / SETTERS


        // ____________________________________________________________________________________________________
        // EVENT HANDLERS


    }
}