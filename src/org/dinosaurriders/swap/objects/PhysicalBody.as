package org.dinosaurriders.swap.objects {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
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
		protected var body : b2Body;
		protected var world : b2World;
		protected var bodyDef : b2BodyDef;
		protected var fixtureDef : b2FixtureDef;
		
		public function PhysicalBody(X : Number, Y : Number, density : Number = 1, 
			restitution : Number = 0, friction : Number = 1) : void {
			super(X, Y);
			
			// looks ugly when it rotates
			antialiasing = true;
			
			// create box2D body definitions
			fixtureDef = new b2FixtureDef();
			fixtureDef.density = density;
			fixtureDef.restitution = restitution;
			fixtureDef.friction = friction;
			
			bodyDef = new b2BodyDef();
			bodyDef.position.Set((x + width / 2) / Settings.ratio, (y + height / 2) / Settings.ratio);
			bodyDef.type = b2Body.b2_dynamicBody;
		}

		public function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
			this.world = world;
			
			body = world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			
			return body;
		}
		
		public override function update() : void {
			x = (body.GetPosition().x * Settings.ratio) - width / 2;
			y = (body.GetPosition().y * Settings.ratio) - height / 2;
			
			//angle = body.GetAngle() * (180 / Math.PI);
			
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
		}
		
		public override function kill() : void {
			world.DestroyBody(body);
			super.kill();
		}
	}
}
