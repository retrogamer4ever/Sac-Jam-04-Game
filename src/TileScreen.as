package
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flixel.FlxBasic;
	import org.flixel.FlxCamera;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTileblock;
	import org.flixel.FlxU;
	
	
	public class TileScreen extends FlxState
	{
		public var titleScreen:FlxSprite;
		
		
		[Embed(source = "/../data/splash_new.png")]  public var rawTitleScreen:Class;
		
		
		
		public function TileScreen()
		{
			
		}
		
		override public function create():void
		{
			titleScreen = new FlxSprite(-130, 50, rawTitleScreen ); 
			
			add( titleScreen );
		}
		
		override public function update():void
		{
			super.update();
			
			if( FlxG.mouse.pressed() )
			{
				FlxG.switchState( new PlayState() );
			}
		}	
	}
}