package org.dinosaurriders.swap.objects {
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.Settings;

	/**
	 * @author Drakaen
	 */
	public class WeightSwitch extends Switch {
		private var requiredForce : Number;
		
		public function WeightSwitch(X : Number, Y : Number, image : Class, requiredForce : Number) {
			super(X, Y, image);
			
			this.requiredForce = requiredForce;
		}

		override public function onStartCollision(contact : b2Contact) : void {
			super.onStartCollision(contact);
			
			var thisBody : PhysicalBody, otherBody : PhysicalBody;
			
			if (contact.GetFixtureA().GetUserData() == this) {
				thisBody = contact.GetFixtureA().GetUserData();
				otherBody = contact.GetFixtureB().GetUserData();
			} else if (contact.GetFixtureB().GetUserData() == this) {
				thisBody = contact.GetFixtureB().GetUserData();
				otherBody = contact.GetFixtureA().GetUserData();
			}
			
			trace("applied", otherBody.body.GetMass() * otherBody.gravityVector.Length(),
				" to switch (mass = ", otherBody.body.GetMass(),
				"gravity: ", otherBody.gravityVector.Length());
				
			if (otherBody.body.GetMass() * otherBody.gravityVector.Length() >= requiredForce) {
				activate();
			}
		}

		override public function onEndCollision(contact : b2Contact) : void {
			super.onEndCollision(contact);
			
			var switchBody : PhysicalBody, otherBody : PhysicalBody;
			
			if (contact.GetFixtureA().GetUserData() == this) {
				switchBody = contact.GetFixtureA().GetUserData();
				otherBody = contact.GetFixtureB().GetUserData();
			} else if (contact.GetFixtureB().GetUserData() == this) {
				switchBody = contact.GetFixtureB().GetUserData();
				otherBody = contact.GetFixtureA().GetUserData();
			}
			
			if (otherBody.body.GetMass() * otherBody.gravityVector.Length() >= requiredForce) {
				deactivate();
			}
		}

		override public function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
			var polyDef : b2PolygonShape = new b2PolygonShape();
			
			polyDef.SetAsBox(width / Settings.ratio / 2, height / Settings.ratio / 2);
			fixtureDefs[0] = new b2FixtureDef();
			fixtureDefs[0].shape = polyDef;
			
			return super.createPhysicsObject(world, properties);
		}
	}
}
