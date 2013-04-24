package org.dinosaurriders.swap.objects {
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.b2Manifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.Settings;
	import org.dinosaurriders.swap.physics.PhysicsUtil;
	import org.flixel.FlxSprite;

	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

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
		protected var _fixtureDefs : Vector.<b2FixtureDef>;
		protected var _fixtures : Vector.<b2Fixture>;
		protected var _gravityVector : b2Vec2;
		protected var _enabled : Boolean = true;
		protected var _swappable : Boolean = false;
		protected var _affectsPlayer : Boolean = true;
		
		private var objectLinks : Array;
		private var density : Number, restitution : Number, friction : Number;

		public function PhysicalBody(X : Number, Y : Number, density : Number = 1, restitution : Number = 0, friction : Number = 1) : void {
			super(X, Y);

			this.density = density;
			this.restitution = restitution;
			this.friction = friction;

			objectLinks = new Array();

			// looks ugly when it rotates
			// antialiasing = true;

			fixtureDefs = new Vector.<b2FixtureDef>();
			fixtures = new Vector.<b2Fixture>();

			bodyDef = new b2BodyDef();
		}

		public virtual function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
			var isSensor : Boolean = false;
			
			this.world = world;

			bodyDef.position.Set((x + width / 2) / Settings.ratio, (y + height / 2) / Settings.ratio);
			
			// pre-creation property check
			for each (var property in properties) {
				switch (property.name) {
					case "sensor":
						isSensor = property.value;
						break;
					case "swappable":
						swappable = property.value;
						break;
					case "fixedrotation":
						bodyDef.fixedRotation = property.value;
						break;
					case "friction":
						friction = property.value;
						break;
					case "affectsplayer":
						affectsPlayer = property.value;
						break;
				}
			}
			
			body = world.CreateBody(bodyDef);
			body.SetUserData(this);
			
			// post-creation properties
			for each (var property in properties) {
				switch (property.name) {
					case "enabled":
						enabled = property.value;
						break;
					
					case "fixedx":
						var worldAxis:b2Vec2 = new b2Vec2(0.0, 1.0);
						var jointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
						
						var polyDef : b2PolygonShape = new b2PolygonShape();
						var baseFixture : b2FixtureDef = new b2FixtureDef();
						var baseBody : b2Body;
						var baseBodyDef : b2BodyDef = new b2BodyDef();
						
						baseBodyDef.position = bodyDef.position.Copy();
						//baseBodyDef.position.y -= 100;	
						baseBodyDef.type = b2Body.b2_staticBody;
						polyDef.SetAsBox(0.01, 0.01);
						baseBodyDef.fixedRotation = true;
						baseFixture.isSensor = true;
						
						baseFixture.shape = polyDef;
						
						baseBody = world.CreateBody(baseBodyDef);
						baseBody.CreateFixture(baseFixture);
						
						jointDef.Initialize(body, baseBody, body.GetWorldCenter(), worldAxis);
						jointDef.lowerTranslation= -100;
						jointDef.upperTranslation= 100;
						jointDef.enableLimit     = true;
//						jointDef.maxMotorForce   = 1.0;
//						jointDef.motorSpeed      = 0.0;
//						jointDef.enableMotor     = true;
						world.CreateJoint(jointDef);
						break;
				}
			}
			
			for (var i : int = 0; i < fixtureDefs.length; i++) {
				// create box2D body definitions
				fixtureDefs[i].density = density;
				fixtureDefs[i].restitution = restitution;
				fixtureDefs[i].friction = friction;
				fixtureDefs[i].userData = this;
				
				// does not override sensor status if it was already set to true
				fixtureDefs[i].isSensor = fixtureDefs[i].isSensor || isSensor; 
				
				fixtures[i] = body.CreateFixture(fixtureDefs[i]);
			}

			gravityVector = new b2Vec2(Settings.DEFAULTGRAVITYX, Settings.DEFAULTGRAVITYY);

			return body;
		}

		public override function update() : void {
			x = (body.GetPosition().x * Settings.ratio) - width / 2;
			y = (body.GetPosition().y * Settings.ratio) - height / 2;

			angle = body.GetAngle() * (180 / Math.PI);

			var forceVector : b2Vec2 = gravityVector.Copy();
			forceVector.Multiply(body.GetMass());
			body.ApplyForce(forceVector, body.GetWorldCenter());

			super.update();
		}
		
		public function update2() : void {
			super.update();
		}

		/*
		 * Saves an object link in a dictionary indexed by property name, k -> [v, target]
		 */
		public function addObjectLink(key : String, value : Object, target : PhysicalBody) : void {
			objectLinks.push([key, value, target]);
		}

		protected function findFirstObjectLink(key : String) : Array {
			for each (var v : Array in objectLinks) {
				if (v[0] == key) {
					return v;
				}
			}

			return null;
		}

		protected function findAllObjectLinks(key : String) : Array {
			var resultArray : Array = new Array();

			for each (var v : Array in objectLinks) {
				if (v[0] == key) {
					resultArray.push(v);
				}
			}

			return resultArray;
		}
		
		protected function identifyCollision(contact : b2Contact) : Vector.<b2Fixture> {
			var outputFixtures : Vector.<b2Fixture> = new Vector.<b2Fixture>();
			
			if (contact.GetFixtureA().GetUserData() == this) {
				outputFixtures[0] = contact.GetFixtureA();
				outputFixtures[1] = contact.GetFixtureB();
			} else if (contact.GetFixtureB().GetUserData() == this) {
				outputFixtures[0] = contact.GetFixtureB();
				outputFixtures[1] = contact.GetFixtureA();
			}
			
			return outputFixtures;
		}

		public function onStartCollision(contact : b2Contact) : void {
		}

		public function onEndCollision(contact : b2Contact) : void {
		}

		public function onBeforeSolveCollision(contact : b2Contact, oldManifold : b2Manifold) : void {
		}

		public function onAfterSolveCollision(contact : b2Contact, impulse : b2ContactImpulse) : void {
		}

		public function swap(swapObject : PhysicalBody) : void {
			if (swappable && swapObject.swappable) {
				// linear velocities
				var tmpLin : b2Vec2 = body.GetLinearVelocity().Copy();
				body.SetLinearVelocity(swapObject.body.GetLinearVelocity());
				swapObject.body.SetLinearVelocity(tmpLin);
	
				var tmpPos : b2Vec2 = body.GetPosition().Copy();
				body.SetPosition(swapObject.body.GetPosition());
				swapObject.body.SetPosition(tmpPos);
	
				// Prevents freezing in midair
				swapObject.body.SetAwake(true);
			}
		}

		public override function kill() : void {
			PhysicsUtil.enqueueDeletedBody(body);

			super.kill();
		}

		public function get gravityVector() : b2Vec2 {
			return _gravityVector;
		}

		public function set gravityVector(gravityVector : b2Vec2) : void {
			this._gravityVector = gravityVector;
		}

		public function get body() : b2Body {
			return _body;
		}

		public function set body(body : b2Body) : void {
			this._body = body;
		}

		public function get fixtureDefs() : Vector.<b2FixtureDef> {
			return _fixtureDefs;
		}

		public function set fixtureDefs(fixtureDefs : Vector.<b2FixtureDef>) : void {
			this._fixtureDefs = fixtureDefs;
		}

		public function get fixtures() : Vector.<b2Fixture> {
			return _fixtures;
		}

		public function set fixtures(fixtures : Vector.<b2Fixture>) : void {
			this._fixtures = fixtures;
		}

		public function get enabled() : Boolean {
			return _enabled;
		}

		public function set enabled(enabled : Boolean) : void {
			super.visible = enabled;
			body.SetActive(enabled);

			this._enabled = enabled;
		}

		public function get swappable() : Boolean {
			return _swappable;
		}

		public function set swappable(swappable : Boolean) : void {
			this._swappable = swappable;
			
			if (swappable) {
				framePixels.applyFilter(framePixels, new Rectangle(0, 0, width, height), new Point(0, 0), new GlowFilter(0x6600cc, 0.5, 12, 12, 1.5, 3, true));
			}
		}

		public function get affectsPlayer() : Boolean {
			return _affectsPlayer;
		}

		public function set affectsPlayer(affectsPlayer : Boolean) : void {
			this._affectsPlayer = affectsPlayer;
		}
	}
}
