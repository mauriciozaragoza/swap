package org.dinosaurriders.swap.objects {
	import flash.utils.Dictionary;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.Settings;
	import org.dinosaurriders.swap.objects.PhysicalBody;

	/**
	 * @author Mau
	 */
	public class PropertyField extends PhysicalBody {
		private var gravityField : b2Vec2;		
		private var affectedByField : Dictionary;
		
		public function PropertyField(X : Number, Y : Number) {
			super(X, Y, 0, 0, 0);
			
			affectedByField = new Dictionary();
			
			bodyDef.type = b2Body.b2_staticBody;
		}
			
		override public function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
			var polyDef : b2PolygonShape = new b2PolygonShape();

			polyDef.SetAsBox(width / Settings.ratio / 2, height / Settings.ratio / 2);
			bodyDef.fixedRotation = true;
			
			fixtureDefs[0] = new b2FixtureDef();
			fixtureDefs[0].shape = polyDef;
			fixtureDefs[0].isSensor = true;
			
			gravityField = new b2Vec2(properties[0]);
			
			for each (var property in properties) {
				if (property.name == "gravityx") {
					gravityField.x = property.value;
				}
				else if (property.name == "gravityy") {
					gravityField.y = property.value;
				}
			}
			
			return super.createPhysicsObject(world, properties);
		}

		override public function onStartCollision(contact : b2Contact) : void {
			super.onStartCollision(contact);
			
			var otherBody : PhysicalBody = identifyCollision(contact)[1].GetUserData();
			
			if (otherBody != null && affectedByField[otherBody] == null) {
				affectedByField[otherBody] = true;
				otherBody.gravityVector.Add(gravityField);
			}
		}

		override public function onEndCollision(contact : b2Contact) : void {
			super.onEndCollision(contact);
			
			var otherBody : PhysicalBody = identifyCollision(contact)[1].GetUserData();
			
			if (otherBody != null && affectedByField[otherBody] != null) {
				affectedByField[otherBody] = null;
				otherBody.gravityVector.Subtract(gravityField);
			}
		}
	}
}
