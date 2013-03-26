package org.dinosaurriders.swap.objects {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.Settings;
	import org.flixel.FlxSprite;

	/**
	 * @author Mau
	 */
	 
	 /*
	  * This class should be abstract, do not instanciate
	  */
	public class PhysicalBody extends FlxSprite {
		protected var _body : b2Body;
		protected var world : b2World;
		protected var bodyDef : b2BodyDef;
		protected var _fixtureDefs : Array;
		protected var _fixtures : Array;
		protected var _gravityVector : b2Vec2 = new b2Vec2();
		
		private var density : Number, restitution : Number, friction : Number;
		
		public function PhysicalBody(X : Number, Y : Number, density : Number = 1, 
			restitution : Number = 0, friction : Number = 1) : void {
			super(X, Y);
			
			this.density = density;
			this.restitution = restitution;
			this.friction = friction;
			
			// looks ugly when it rotates
			// antialiasing = true;
			
			fixtureDefs = new Array();
			fixtures = new Array();
			
			bodyDef = new b2BodyDef();
			bodyDef.position.Set((x + width * 2) / Settings.ratio, (y + height * 2) / Settings.ratio);
			bodyDef.type = b2Body.b2_dynamicBody;
		}

		public virtual function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
			this.world = world;
			
			body = world.CreateBody(bodyDef);			
			body.SetUserData(this);
						
			for (var i : int = 0; i < fixtureDefs.length; i++) {
				// create box2D body definitions
				fixtureDefs[i].density = density;
				fixtureDefs[i].restitution = restitution;
				fixtureDefs[i].friction = friction;
				fixtureDefs[i].userData = this;
				fixtures[i] = body.CreateFixture(fixtureDefs[i]);
			}
			
			gravityVector = new b2Vec2(0, 9.8);
			
			// if the body sleeps, gravityvector gets screwed up
			body.SetSleepingAllowed(false);
			
			return body;
		}
		
		public override function update() : void {
			x = (body.GetPosition().x * Settings.ratio) - width / 2;
			y = (body.GetPosition().y * Settings.ratio) - height / 2;
			
			angle = body.GetAngle() * (180 / Math.PI);
			
			super.update();
		}
				
		public function swap(swapSprite : PhysicalBody) : void {
			// linear velocities
			var tmpLin : b2Vec2 = body.GetLinearVelocity().Copy();
			body.SetLinearVelocity(swapSprite.body.GetLinearVelocity());
			swapSprite.body.SetLinearVelocity(tmpLin);
			
			var tmpPos : b2Vec2 = body.GetPosition().Copy();
			body.SetPosition(swapSprite.body.GetPosition());
			swapSprite.body.SetPosition(tmpPos);
			
			// Prevents freezing in midair
			swapSprite.body.SetAwake(true);
		}
		
		public override function kill() : void {
			world.DestroyBody(body);
			super.kill();
		}

		public function get gravityVector() : b2Vec2 {
			return _gravityVector;
		}

		public function set gravityVector(gravityVector : b2Vec2) : void {
			// remove previous gravity
			body.ApplyForce(_gravityVector.GetNegative(), body.GetWorldCenter());
			
			this._gravityVector = gravityVector;
			
			this._gravityVector.Multiply(body.GetMass());
			body.ApplyForce(this._gravityVector, body.GetWorldCenter());
			trace("applying", gravityVector.y);
		}

		public function get body() : b2Body {
			return _body;
		}

		public function set body(body : b2Body) : void {
			this._body = body;
		}

		public function get fixtureDefs() : Array {
			return _fixtureDefs;
		}

		public function set fixtureDefs(fixtureDefs : Array) : void {
			this._fixtureDefs = fixtureDefs;
		}

		public function get fixtures() : Array {
			return _fixtures;
		}

		public function set fixtures(fixtures : Array) : void {
			this._fixtures = fixtures;
		}
	}
}
