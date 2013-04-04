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
	public class Exit extends PhysicalBody {
		public function Exit(X : Number, Y : Number, image : Class) {
			super(X, Y, 0, 0, 0);
			
			loadGraphic(image, false, false);
			bodyDef.type = b2Body.b2_staticBody;
		}
			
		override public function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
			var polyDef : b2PolygonShape = new b2PolygonShape();

			polyDef.SetAsBox(width / Settings.ratio / 2, height / Settings.ratio / 2);
			bodyDef.fixedRotation = true;
			
			fixtureDefs[0] = new b2FixtureDef();
			fixtureDefs[0].shape = polyDef;
			fixtureDefs[0].isSensor = true;
			
			return super.createPhysicsObject(world, properties);
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
			
			if (otherBody is Player) {
				trace("exit");
				otherBody.kill();
			}
		}
	}
}
