package  
{
	import com.quasimondo.geom.ColorMatrix;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	* @author Pieter van de Sluis
	*/
	public class Plasma extends Sprite
	{
		private var bm:BitmapData;
		private var phase:Number = 0;
		
		private var _width:Number;
		private var _height:Number;
		private var randomSeed:int;
		private var colorTransform:ColorTransform;
		private var drawMatrix:Matrix;
		private var noise:BitmapData;
		private var offsets:Array;
		
		public function Plasma( width:Number, height:Number ) 
		{
			this._width = width * 0.1;
			this._height = height * 0.1;
			
			bm = new BitmapData( width * 0.5, width * 0.5, true );
			
			var bitMap:Bitmap = new Bitmap( bm );
			bitMap.blendMode = BlendMode.SUBTRACT;
			bitMap.scaleX = bitMap.scaleY = 2;
			this.addChild( bitMap );
			
			randomSeed = Math.random() * 100;
			
			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			colorTransform = new ColorTransform( 2, 2, 2 );
			drawMatrix = new Matrix( 5, 0, 0, 5 );
			noise = new BitmapData( _width, _width );
			
			offsets = [ new Point(), new Point(), new Point(), new Point() ];
		}
		
		
		private function onEnterFrame(e:Event):void 
		{
			offsets[0].x = -phase;
			offsets[0].y = phase;
			
			offsets[1].x = phase;
			offsets[1].y = -phase;
			
			offsets[2].x = phase;
			offsets[2].y = phase;
			
			offsets[3].x = -phase;
			offsets[3].y = -phase;
			
			noise.perlinNoise( _width, _height, 4, randomSeed, false, false, 7, true, offsets );
			bm.draw( noise, drawMatrix, colorTransform, null, null, true );
			
			phase += 0.2;
		}
		
	}
	
}
