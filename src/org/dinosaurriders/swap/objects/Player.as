package org.dinosaurriders.swap.objects {
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import org.dinosaurriders.swap.Assets;
	import org.dinosaurriders.swap.Settings;
	import org.flixel.*;
	
	public class Player extends PhysicalBody {
		private var _grounded : Boolean;
		
		public function Player(X:Number,Y:Number):void {
			super(X, Y, 0.3, 0, 1);
			loadGraphic(Assets.Player, true, true, 48, 48);
			
			addAnimation("jump", [1], 10);
			addAnimation("move", [0, 1, 2], 10);
			addAnimation("fall", [1], 10);
			addAnimation("idle", [1], 2);
			
			bodyDef.fixedRotation = true;
		}
		
		override public function update():void 
		{
			var velocity : b2Vec2 = body.GetLinearVelocity();
			
			if (FlxG.keys.LEFT && velocity.x > -Settings.PLAYERMAXVELOCITY)
			{
				body.ApplyImpulse(new b2Vec2(-Settings.PLAYERSPEED), new b2Vec2());
			}
			else if (FlxG.keys.RIGHT && velocity.x < Settings.PLAYERMAXVELOCITY)
			{
				body.ApplyImpulse(new b2Vec2(Settings.PLAYERSPEED), new b2Vec2());
			}			
			else if (FlxG.keys.justPressed("UP")) {
				jump();
			}
			
			if (velocity.y < 0)
			{
				play("jump");
			}
			else
			{
				if (velocity.y > 0)
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

		override public function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {			
			var footSensorShape : b2PolygonShape = new b2PolygonShape();			
			var boxDef : b2PolygonShape = new b2PolygonShape();
			
			fixtureDefs[0] = new b2FixtureDef(); // rectangle
			fixtureDefs[1] = new b2FixtureDef(); // foot sensor
			fixtureDefs[2] = new b2FixtureDef(); // bottom circle
			
			boxDef.SetAsBox(width / Settings.ratio / 4.5, height / Settings.ratio / 4.5);
			fixtureDefs[0].shape = boxDef;
			
			var vertices : Array = new Array();
			vertices[0] = new b2Vec2(-width / 8 / Settings.ratio, height / 2 / Settings.ratio);
			vertices[1] = new b2Vec2(-width / 8 / Settings.ratio, (height + Settings.FOOTSENSORSIZE) / 2 / Settings.ratio);
			vertices[2] = new b2Vec2(width / 8 / Settings.ratio, (height + Settings.FOOTSENSORSIZE) / 2 / Settings.ratio);
			vertices[3] = new b2Vec2(width / 8 / Settings.ratio, height / 2 / Settings.ratio);			
			footSensorShape.SetAsArray(vertices, 4);
			
			fixtureDefs[1].shape = footSensorShape;
			fixtureDefs[1].isSensor = true;
			fixtureDefs[1].userData = this;
			
			var circleDef : b2CircleShape = new b2CircleShape();
			
			circleDef.SetRadius(width / Settings.ratio / 4);
			circleDef.SetLocalPosition(new b2Vec2(0, width / Settings.ratio / 4));
			fixtureDefs[2].shape = circleDef;
			
			// Creates the body
			super.createPhysicsObject(world, properties);
			
			body.SetBullet(true);
			return body;
		}
		
		public function jump() : void {
			var direction : b2Vec2 = gravityVector.Copy();
			direction.NegativeSelf();
			direction.Normalize();
			
			body.ApplyImpulse(new b2Vec2(direction.x * Settings.PLAYERJUMP, direction.y * Settings.PLAYERJUMP), new b2Vec2());
		}
		
		/*
		 * WorldContactListener calls this function when the player just entered air space
		 */
		public function onAir() : void {
			
		}
		
		/*
		 * WorldContactListener calls this function when the player lands
		 */
		public function onLand() : void {
			
		}
		
		public function get grounded() : Boolean {
			return _grounded;
		}

		public function set grounded(grounded : Boolean) : void {
			this._grounded = grounded;
		}
		
		public function setFriction(friction : Number) : void {
			for each (var fixture : b2Fixture in fixtures) {
				fixture.SetFriction(friction);
			}
		}
	}
}