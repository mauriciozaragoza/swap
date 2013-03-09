package org.dinosaurriders.swap.objects
{
	import org.flixel.*;
	
	public class Player extends FlxSprite
	{
		[Embed(source='../assets/player2.png')] private var ImgPlayer:Class;
		
		private var _move_speed:int = 400;
		private var _jump_power:int = 1800;   
		private const MAX_ENERGY:Number = 0.3;
		private var energy:Number = MAX_ENERGY;
		private var energyWaitTimer:Number = 0;
		
		public function Player(X:Number,Y:Number):void 
		{
			super(X, Y);
			loadGraphic(ImgPlayer, true, true, 48, 48);
			
			maxVelocity.x = 800;
			maxVelocity.y = 800;
			//Set the player health
			health = 10;
			//Gravity
			acceleration.y = 900;			
			//Friction
			drag.x = 100;
			//bounding box tweaks
			width = 28;
			height = 48;
			offset.x = 8;
			offset.y = 0;
			
			addAnimation("jump", [1], 10);
			addAnimation("move", [0, 1, 2], 10);	// For now move is same anim as jump.
			addAnimation("fall", [1], 10);
			addAnimation("idle", [1], 2);			

//			addAnimation("jump", [3], 10);
//			addAnimation("move", [1, 2], 10);	// For now move is same anim as jump.
//			addAnimation("fall", [3], 10);
//			addAnimation("idle", [0], 2);		
		}
		
		override public function update():void 
		{
			if ( FlxG.keys.LEFT )
			{
				facing = LEFT;
				velocity.x -= _move_speed * FlxG.elapsed;
			}
			else if (FlxG.keys.RIGHT )
			{
				facing = RIGHT;
				velocity.x += _move_speed * FlxG.elapsed;		
			}
			
			if (FlxG.keys.X && energy > 0)
			{
				velocity.y -= _jump_power * FlxG.elapsed;
				energy -= FlxG.elapsed;
				if ( energy <= 0 )
				{
					energyWaitTimer = 0.2;
				}
			}
			else
			{
				if ( energyWaitTimer > 0 )
				{
					energyWaitTimer -= FlxG.elapsed;
				}
				else
				{
					energy = Math.min( energy + FlxG.elapsed, MAX_ENERGY );
				}
			}
			
			if (velocity.y < 0)
			{
				play("jump"); // Check old flixel and new flixel in case I fixed the play anim code if you're already playing.
			}
			else
			{
				if ( velocity.y > 0 )
				{
					play("fall");
				}
				else if (velocity.x == 0)
				{
					play("idle");
				}
				else
				{
					play("move");
				}
			}
			
			super.update();
		}		
	}
}