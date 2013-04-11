package org.dinosaurriders.swap.objects {
	import org.dinosaurriders.swap.physics.PhysicsUtil;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.Assets;
	import org.dinosaurriders.swap.Settings;
	import org.flixel.*;
	
	public class Player extends PhysicalBody {
		private var grounded : Boolean;
		private var feetContactCount : int;
		private var _dead : Boolean = false;
		private var tempSwapObject : PhysicalBody;
		
		public function Player(X:Number,Y:Number):void {
			super(X, Y, 100, 0, 1);
			loadGraphic(Assets.Player, true, true, 48, 48);
			
			addAnimation("jump", [1], 10);
			addAnimation("move", [0, 1, 2], 10);
			addAnimation("fall", [1], 10);
			addAnimation("idle", [1], 2);
			
			bodyDef.fixedRotation = true;
			
			bodyDef.type = b2Body.b2_dynamicBody;
		}
		
		override public function update():void 
		{
			var velocity : b2Vec2 = body.GetLinearVelocity();
			
			if (FlxG.keys.LEFT && velocity.x > -Settings.PLAYERMAXVELOCITY)
			{
				body.ApplyImpulse(
					new b2Vec2(grounded ? -Settings.PLAYERSPEED * body.GetMass() : -Settings.PLAYERAIRSPEED * body.GetMass()), 
					new b2Vec2());
			}
			else if (FlxG.keys.RIGHT && velocity.x < Settings.PLAYERMAXVELOCITY)
			{
				body.ApplyImpulse(
					new b2Vec2(grounded ? Settings.PLAYERSPEED * body.GetMass() : Settings.PLAYERAIRSPEED * body.GetMass()),
					new b2Vec2());
			}			
			
			if (FlxG.keys.justPressed("UP")) {
				jump();
			}
			
			
			if (FlxG.keys.justPressed("X") && tempSwapObject != null) {
				PhysicsUtil.enqueueSwap(this, tempSwapObject);
			}
			
			if (Math.abs(velocity.x) > 0) {
				play("move");
			} else {
				play("idle");
			}
			
			super.update();
		}
		
		override public function onStartCollision(contact : b2Contact) : void {
			var collision : Vector.<b2Fixture> = identifyCollision(contact);
			var playerFixture : b2Fixture = collision[0];
			var otherFixture : b2Fixture = collision[1];

			// if feet sensor touched something, then player landed somewhere
			// fixtures[1] is the feet sensor
			if (playerFixture == fixtures[1] && !otherFixture.IsSensor()) {
				feetContactCount++;
				onLand();
				
				var other : PhysicalBody = otherFixture.GetUserData() as PhysicalBody;
					
				if (other != null && other.swappable) {
					tempSwapObject = other;
				}
			}
		}
		
		override public function onEndCollision(contact : b2Contact) : void {
			var collision : Vector.<b2Fixture> = identifyCollision(contact);
			var playerFixture : b2Fixture = collision[0];
			var otherFixture : b2Fixture = collision[1];

			if (playerFixture == fixtures[1] && !otherFixture.IsSensor()) {
				feetContactCount--;
				
				if (feetContactCount == 0) {
					onAir();
				}
			}
		}
		
		override public function onAfterSolveCollision(contact : b2Contact, impulse : b2ContactImpulse) : void {			
			//trace("force: ", impulse.normalImpulses[0]);
			if (impulse.normalImpulses[0] > Settings.MAXFORCE) {
				kill();
				_dead=true;
			}
		}

		override public function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
			var footSensorShape : b2PolygonShape = new b2PolygonShape();			
			var boxDef : b2PolygonShape = new b2PolygonShape();
			
			fixtureDefs[0] = new b2FixtureDef(); // rectangle
			fixtureDefs[1] = new b2FixtureDef(); // foot sensor
			fixtureDefs[2] = new b2FixtureDef(); // bottom circle
			
			boxDef.SetAsBox(width / Settings.ratio / 4.1, height / Settings.ratio / 4.1);
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
			if (grounded) {
				var direction : b2Vec2 = gravityVector.Copy();
				var jumpVector : b2Vec2;
				
				direction.NegativeSelf();
				direction.Normalize();
				
				jumpVector = new b2Vec2(direction.x * Settings.PLAYERJUMP, direction.y * Settings.PLAYERJUMP);
				jumpVector.Multiply(body.GetMass());
				setFriction(0);
				
				body.ApplyImpulse(jumpVector, new b2Vec2());
			}
		}
		
		/*
		 * WorldContactListener calls this function when the player just entered air space
		 */
		public function onAir() : void {
			setFriction(0);
			grounded = false;
		}
		
		/*
		 * WorldContactListener calls this function when the player lands
		 */
		public function onLand() : void {
			setFriction(1);
			grounded = true;
		}
		
		public function setFriction(friction : Number) : void {
			for each (var fixture : b2Fixture in fixtures) {
				fixture.SetFriction(friction);
			}
		}

		public function get dead() : Boolean {
			return _dead;
		}
	}
}