package org.dinosaurriders.swap.objects {
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.Assets;
	import org.dinosaurriders.swap.Settings;
	import org.dinosaurriders.swap.physics.PhysicsUtil;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxControl;
	import org.flixel.plugin.photonstorm.FlxControlHandler;

	import flash.utils.Dictionary;

	public class Player extends PhysicalBody {
		private var grounded : Boolean;
		private var feetContactCount : int;
		private var _dead : Boolean = false;
		private var tempSwapObject : PhysicalBody;
		private var onKillCallback : Function;
		private var onExitCallback : Function;
		private var controls : Dictionary;
		private var groundMoveVector : b2Vec2, airMoveVector : b2Vec2;

		public function Player(X : Number, Y : Number) : void {
			super(X, Y, 100, 0, 1);
			loadGraphic(Assets.Player, true, true, 32, 32);
			
			offset.x = 8;
			width = 16;
			height = 32;		

			controls = new Dictionary();
			controls["JUMP"] = Settings.JUMPKEY;
			controls["SWAP"] = Settings.SWAPKEY;
			controls["TOUCHSWAP"] = Settings.TOUCHSWAPKEY;

//			addAnimation("jump", [1], 10);
//			addAnimation("move", [0, 1, 2], 10);
//			addAnimation("fall", [1], 10);
//			addAnimation("idle", [1], 2);
			
			immovable = false;
			
			bodyDef.fixedRotation = true;
			bodyDef.allowSleep = false;
			
			if (FlxG.getPlugin(FlxControl) == null)
			{
				FlxG.addPlugin(new FlxControl);
			}
			
			FlxControl.create(this, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, true, false);
			FlxControl.player1.setCustomKeys(Settings.UPKEY, Settings.DOWNKEY, Settings.LEFTKEY, Settings.RIGHTKEY);
			
			FlxControl.player1.setJumpButton(controls["JUMP"], FlxControlHandler.KEYMODE_PRESSED, Settings.PLAYERJUMP, FlxObject.FLOOR, 250, 200);
			//FlxControl.player1.setGravity(0, Settings.DEFAULTPLAYERGRAV);
			FlxControl.player1.setMovementSpeed(
				Settings.PLAYERSPEED, 
				0, 
				Settings.PLAYERMAXVELOCITY, 
				Settings.PLAYERMAXFALLSPEED, 
				Settings.PLAYERDECCELERATION,
				0);
				
//			FlxControl.player1.setMovementSpeed(
//				Settings.PLAYERSPEED, Settings.PLAYERSPEED,
//				Settings.PLAYERMAXVELOCITY, Settings.PLAYERMAXVELOCITY, 400, 0);

			FlxControl.player1.setCursorControl(false, false, true, true);
			
			bodyDef.type = b2Body.b2_dynamicBody;
		}

		public function setOnKill(callback : Function) : void {
			this.onKillCallback = callback;
		}

		public function setOnExit(callback : Function) : void {
			this.onExitCallback = callback;
		}

		public function exitLevel(warpToLevel : String) : void {
			if (onExitCallback != null) {
				onExitCallback(warpToLevel);
			}
		}
			
		override public function swap(swapObject : PhysicalBody) : void {
			if (swapObject.swappable) {
				// linear velocities
				var tmpLin : FlxPoint = new FlxPoint();
				velocity.copyTo(tmpLin);
				velocity.x = swapObject.body.GetLinearVelocity().x;
				velocity.y = swapObject.body.GetLinearVelocity().y;
				swapObject.body.SetLinearVelocity(new b2Vec2(tmpLin.x / Settings.ratio, tmpLin.y / Settings.ratio));
	
				var tmpPos : b2Vec2 = body.GetPosition().Copy();
				body.SetPosition(swapObject.body.GetPosition());
				swapObject.body.SetPosition(tmpPos);
				
				// Prevents freezing in midair
				swapObject.body.SetAwake(true);
				
				FlxG.state.add(new SwapTrail(x - width / 2, y - height / 2));
				
				x = (body.GetPosition().x * Settings.ratio) - width / 2;
				y = (body.GetPosition().y * Settings.ratio) - height / 2;
				
				FlxG.state.add(new SwapTrail(x - width / 2, y - height / 2));		
			}
		}

		override public function update() : void {
			super.update2();
			//trace(FlxG.collide(this, levelHitLayers));
//			var velocity : b2Vec2 = body.GetLinearVelocity();
//			var moveDirection : b2Vec2 = groundMoveVector.Copy();
//			moveDirection.Normalize();

//			if (grounded) {
//				if (FlxG.keys.justPressed(controls["LEFT"]) || FlxG.keys.justPressed(controls["RIGHT"])) {
//					setFriction(0.1);
//				}
//				if (FlxG.keys.justReleased(controls["LEFT"]) || FlxG.keys.justReleased(controls["RIGHT"])) {
//					setFriction(1);
//				}	
//			}
//			
//			// dot product
//			if (FlxG.keys.pressed(controls["LEFT"]) && velocity.x * moveDirection.x + velocity.y * moveDirection.y > -Settings.PLAYERMAXVELOCITY) {
//				// body.SetLinearVelocity(groundMoveVector.Copy().GetNegative());
//				// trace("applying", groundMoveVector.GetNegative().x, groundMoveVector.GetNegative().y);
//				body.ApplyImpulse(grounded ? groundMoveVector.Copy().GetNegative() : airMoveVector.Copy().GetNegative(), new b2Vec2());
//			} else if (FlxG.keys.pressed(controls["RIGHT"]) && velocity.x * moveDirection.x + velocity.y * moveDirection.y < Settings.PLAYERMAXVELOCITY) {
//				// body.SetLinearVelocity(groundMoveVector.Copy());
//				body.ApplyImpulse(grounded ? groundMoveVector.Copy() : airMoveVector.Copy(), new b2Vec2());
//			}

			if (FlxG.keys.justPressed(controls["JUMP"])) {
				jump();
			}

			if (FlxG.keys.justPressed(controls["SWAP"]) && tempSwapObject != null) {
				// WARNING: order IS important
				PhysicsUtil.enqueueSwap(tempSwapObject, this);
			}

			if (Math.abs(velocity.x) > 0.1) {
				play("move");
			} else {
				play("idle");
			}
			
			//trace(this.overlaps(levelHitLayers));
			//trace(FlxG.collide(this, levelHitLayers.members[0], lolz));
			
			body.SetPosition(new b2Vec2((x + width / 2) / Settings.ratio, (y + height / 2) / Settings.ratio));
		}
		
		override public function onStartCollision(contact : b2Contact) : void {
			var collision : Vector.<b2Fixture> = identifyCollision(contact);
			var playerFixture : b2Fixture = collision[0];
			var otherFixture : b2Fixture = collision[1];
			var otherBody : PhysicalBody = otherFixture.GetUserData() as PhysicalBody;
			 
			// kill on touch			
			if (otherBody != null && otherBody.kills) {
				kill();
			}
			
			// if feet sensor touched something, then player landed somewhere
			// fixtures[1] is the feet sensor
			else if (playerFixture == fixtures[1] && !otherFixture.IsSensor()) {
				feetContactCount++;
				onLand();
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

		override public function onBeforeSolveCollision(contact : b2Contact, oldManifold : b2Manifold) : void {
			var otherObject : PhysicalBody = identifyCollision(contact)[1].GetUserData() as PhysicalBody;

			if (otherObject != null) {
				if (FlxG.keys.pressed(controls["TOUCHSWAP"]) && otherObject.swappable) {
					tempSwapObject = otherObject;
				}

				if (!otherObject.affectsPlayer) {
					contact.SetEnabled(false);
				}
			}

			super.onBeforeSolveCollision(contact, oldManifold);
		}

		override public function onAfterSolveCollision(contact : b2Contact, impulse : b2ContactImpulse) : void {
			var appliedForce : Number = 0;
			var otherBody : PhysicalBody = identifyCollision(contact)[1].GetUserData() as PhysicalBody;
			
			appliedForce += impulse.normalImpulses[0] * FlxG.framerate; // force by impulse
			//appliedForce += otherBody.gravityVector.y * otherBody.body.GetMass(); // force by gravity * mass
			
			trace("ouch: ", appliedForce);
			if (appliedForce > Settings.MAXFORCE) {
				kill();
				_dead = true;
			}
		}

		override public function kill() : void {
			super.kill();

			if (onKillCallback != null) {
				onKillCallback();
			}
		}

		override public function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
			var footSensorShape : b2PolygonShape = new b2PolygonShape();
			var boxDef : b2PolygonShape = new b2PolygonShape();
			const widthSizeRatio : Number = 0.25, heightSizeRatio : Number = 2.0 / 3.0;
			var w1 : Number = width * widthSizeRatio / Settings.ratio, 
			h1 : Number = height * heightSizeRatio / Settings.ratio;

			fixtureDefs[0] = new b2FixtureDef();
			// rectangle
			fixtureDefs[1] = new b2FixtureDef();
			// foot sensor
			fixtureDefs[2] = new b2FixtureDef();
			// bottom circle

			boxDef.SetAsBox(w1 / 2.2, h1 / 3);
			fixtureDefs[0].shape = boxDef;

			var vertices : Array = new Array();
			vertices[0] = new b2Vec2(-w1 / 3.5, h1 / 2);
			vertices[1] = new b2Vec2(-w1 / 3.5, h1 / 2 + Settings.FOOTSENSORSIZE / Settings.ratio);
			vertices[2] = new b2Vec2(w1 / 3.5, h1 / 2 + Settings.FOOTSENSORSIZE / Settings.ratio);
			vertices[3] = new b2Vec2(w1 / 3.5, h1 / 2);
			footSensorShape.SetAsArray(vertices, 4);

			fixtureDefs[1].shape = footSensorShape;
			fixtureDefs[1].isSensor = true;
			fixtureDefs[1].userData = this;

			var circleDef : b2CircleShape = new b2CircleShape();

			circleDef.SetRadius(w1 / 2);
			circleDef.SetLocalPosition(new b2Vec2(0, h1 * 1.0 / 3.0));
			fixtureDefs[2].shape = circleDef;

			// Creates the body
			super.createPhysicsObject(world, properties);

			body.SetBullet(true);
			return body;
		}

		public function jump() : void {
//			if (grounded) {
//				var direction : b2Vec2 = gravityVector.Copy();
//				var jumpVector : b2Vec2;
//
//				direction.NegativeSelf();
//				direction.Normalize();
//
//				jumpVector = new b2Vec2(direction.x * Settings.PLAYERJUMP, direction.y * Settings.PLAYERJUMP);
//				jumpVector.Multiply(body.GetMass());
//				setFriction(0);
//
//				body.ApplyImpulse(jumpVector, new b2Vec2());
//			}
		}

		/*
		 * WorldContactListener calls this function when the player just entered air space
		 */
		public function onAir() : void {
			setFriction(0);
			// var newAirVel : b2Vec2 = body.GetLinearVelocity().Copy();
			// newAirVel.x = 0;
			// body.SetLinearVelocity(newAirVel);
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

		// This rotates the player and the controls if the gravity changes
		override public function set gravityVector(gravityVector : b2Vec2) : void {
			super.gravityVector = gravityVector;
//
//			var unitVector : b2Vec2 = gravityVector.Copy();
//			unitVector.Normalize();
			
			FlxControl.player1.setGravity(gravityVector.x * Settings.ratio, gravityVector.y * Settings.ratio);
			
//			// Currently it only supports 4 directions
//			if (unitVector.x > 0.9) {
//				
//				groundMoveVector = new b2Vec2(0, Settings.PLAYERSPEED * body.GetMass());
//				airMoveVector = new b2Vec2(0, Settings.PLAYERAIRSPEED * body.GetMass());
//				angle = 270.0;
//				body.SetAngle(angle / 180.0 * Math.PI);
//				trace("lol1");
//			} else if (unitVector.x < -0.9) {
//				controls["LEFT"] = Settings.UPKEY;
//				controls["RIGHT"] = Settings.DOWNKEY;
//				groundMoveVector = new b2Vec2(0, Settings.PLAYERSPEED * body.GetMass());
//				airMoveVector = new b2Vec2(0, Settings.PLAYERAIRSPEED * body.GetMass());
//				angle = 90.0;
//				body.SetAngle(angle / 180.0 * Math.PI);
//				trace("lol2");
//			} else if (unitVector.y > 0.9) {
//				controls["LEFT"] = Settings.LEFTKEY;
//				controls["RIGHT"] = Settings.RIGHTKEY;
//				groundMoveVector = new b2Vec2(Settings.PLAYERSPEED * body.GetMass());
//				airMoveVector = new b2Vec2(Settings.PLAYERAIRSPEED * body.GetMass());
//				angle = 0;
//				body.SetAngle(angle / 180.0 * Math.PI);
//				trace("lol3");
//			} else if (unitVector.y < 0.9) {
//				controls["LEFT"] = Settings.RIGHTKEY;
//				controls["RIGHT"] = Settings.LEFTKEY;
//				groundMoveVector = new b2Vec2(-Settings.PLAYERSPEED * body.GetMass());
//				airMoveVector = new b2Vec2(-Settings.PLAYERAIRSPEED * body.GetMass());
//				angle = 180.0;
//				body.SetAngle(angle / 180.0 * Math.PI);
//				trace("lol3");
			// }
		}
	}
}
