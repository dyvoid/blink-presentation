package
{
	import flash.display.BlendMode;
	import flash.display.Sprite;

	
	
	public class Main extends Sprite
	{
		
		public function Main():void
		{
			var plasma:Plasma = new Plasma( 500, 500 );
			plasma.x = 200;
			
			this.addChild( plasma );
		}		
		
	}
	
}