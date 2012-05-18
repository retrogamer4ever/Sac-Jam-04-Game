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
	
	
	public class PlayState extends FlxState
	{
		public var player:FlxSprite;
		public var block:FlxSprite;
		
		public var enemy:FlxSprite;
		
		public var isEnemyTouchingBlock:Boolean;
		public var isPlayerTouchingBlock:Boolean;
		
		public var gameTimer:Timer;
		public var gameTimerSeconds:int;
		
		public var enemyDelayTimer:Timer;
		
		public var canEnemyMove:Boolean;
		
		public var gameTimerText:FlxText;
		
		public var enemySpeed:int = 10;
		
		
		[Embed(source="/../data/player_small.png")] public var rawPlayer:Class;
		[Embed(source="/../data/enemy.png")] public var rawEnemy:Class;
		[Embed(source = "/../data/bolder.png")]  public var rawBolder:Class;
		[Embed(source = "/../data/platform.png")]  public var rawPlatform:Class;
		
		private var floor0:FlxTileblock;
		
		
		
		public function PlayState()
		{
			
		}
		
		protected function onGameTimerTick( event:TimerEvent ):void
		{
			gameTimerSeconds--;
			
			gameTimerText.text = "Time: " + gameTimerSeconds.toString();	
		}
		
		protected function onEnemyDelay( event:TimerEvent ):void
		{
			canEnemyMove = true;
			
			enemyDelayTimer.removeEventListener(TimerEvent.TIMER, onEnemyDelay );
		}
		
		override public function create():void
		{
			//want to check if we can move the player
			canEnemyMove = true;
			
			gameTimerSeconds = 15;
			
			gameTimerText = new FlxText( 300, 0, 200, "Time: 15");
			add( gameTimerText );
			
			//This will do wthe count down for how long you have till you win the game
			gameTimer = new Timer( 1000 );
			gameTimer.addEventListener(TimerEvent.TIMER, onGameTimerTick );
			gameTimer.start();
			
			isEnemyTouchingBlock = false;
			isPlayerTouchingBlock = false;
	
			enemyDelayTimer = new Timer( 1000 );
			enemyDelayTimer.addEventListener(TimerEvent.TIMER, onEnemyDelay );
			enemyDelayTimer.start();
			
			var i:int;		
			i = 0;
			
			// Floor
			floor0 = new FlxTileblock(0, 300, 800, 32);
			floor0.makeGraphic(800, 32, 0xffCCCCCC);			
			add(floor0);
			
			//player object
			player = new FlxSprite( 50, 35, rawPlayer );
			player.acceleration.y = 200;
			add( player );
			
			//enemy (using raw player for now)
			enemy = new FlxSprite( FlxG.stage.stageWidth , 35, rawEnemy );
			enemy.acceleration.y = 200;
			add( enemy );
			
			FlxG.camera.setBounds(0, 0, 600, 600);
			FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);						
			
			//block for player to push
			block = new FlxSprite( 300, 0, rawBolder );
			block.acceleration.x = 0;
			block.acceleration.y = 200;
			block.maxVelocity.x = 0;
			block.immovable = false;
			add( block );
		}
		
		override public function update():void
		{
			super.update();
			
			//When the timer is up the game is over!
			if( this.gameTimerSeconds <= 0 )
			{
				FlxG.switchState( new WinScreen() );
			}
			
			FlxG.collide(player, floor0);
			FlxG.collide(block, floor0);
			FlxG.collide(enemy, floor0);
			
			//this will check for when enemy is touching the block
			FlxG.collide(enemy, block, function( enemy:FlxBasic, block:FlxBasic ):void
			{
				isEnemyTouchingBlock = true;
				isPlayerTouchingBlock = false;
			});
			
			//this will check for when player is touching the block
			FlxG.collide(player, block, function( player:FlxBasic, block:FlxBasic ):void
			{
				isPlayerTouchingBlock = true;
				canEnemyMove = false;
			});
			
			updateEnemy();
			
			updatePlayer();			
		}
		
		protected function updateEnemy():void
		{
			//We want the enemy to stop moving if the player is touching
			if( isPlayerTouchingBlock && !canEnemyMove )
			{	
				enemyDelayTimer.addEventListener(TimerEvent.TIMER, onEnemyDelay );
				enemyDelayTimer.start();
				
				return;
			}
			else if( isPlayerTouchingBlock && canEnemyMove )
			{
				//this is when we want the enemy to start moving again after delay
				if( !isEnemyTouchingBlock )
				{
					enemy.velocity.x = -30;
				}
				else
				{
					enemy.velocity.x = 30;
					block.velocity.x = 160;
				}
			}
			
			//We want the rock to follow the enemy when it touches it
			if( !isEnemyTouchingBlock )
			{
				enemy.velocity.x = -30;
			}
			else
			{
				enemy.velocity.x = 30;
				block.velocity.x = 160;
			}
			
			
			//if enemy gets to a certain point then game over
			if( enemy.x >= 1000 || enemy.y >= 1000 )
			{
				FlxG.switchState( new GameOverScreen() );
			}
		}
		
		protected function updatePlayer():void
		{
			if( FlxG.keys.RIGHT )
			{
				player.velocity.x = 50;
				
				//Need to make it if you are holding the key down and touching you can pull block!
				if( isPlayerTouchingBlock == true )
				{
					block.velocity.x = 30;	
					
					//We want it to slow the player down when dragging block
					player.velocity.x = 10;
				}
				else
				{
					player.velocity.x = 50;
				}
			}
			else if( FlxG.keys.LEFT )
			{
				//Need to make it if you are holding the key down and touching you can pull block!
				if( isPlayerTouchingBlock == true )
				{
					block.velocity.x = -160;	
					
					//We want it to slow the player down when dragging block
					player.velocity.x = -10;
				}
				else
				{
					player.velocity.x = -50;
				}
			}
			else if( FlxG.keys.SPACE )
			{
				//want to release bolder when this key is pressed
				isPlayerTouchingBlock = false;
			}
			else
			{
				player.velocity.x = 0;
			}
		}		
	}
}