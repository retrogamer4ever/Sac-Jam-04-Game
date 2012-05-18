package
{
	import flash.display.Sprite;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import org.flixel.FlxSprite;
	
	
	[SWF(width="600", height="600", backgroundColor="#ffffff")]
	[Frame(factoryClass="Preloader")]
	
	public class GameJam04 extends FlxGame
	{
		public function GameJam04()
		{
			super( 600, 600, TileScreen );
		}
	}
}