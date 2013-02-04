package  
{

	import flash.display.Sprite;
	import flash.events.Event;
	
	
	/**
	* @author Pieter van de Sluis
	*/
	public class FieryCircle extends Sprite
	{
		private var phase:Number = 0;
		
		
		public function FieryCircle() 
		{
			var plasma:Plasma = new Plasma( 500, 500 );
			
			this.addChild( plasma );
		}
		
	}
	
}
