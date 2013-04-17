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
			affectsPlayer = true;

			bodyDef.type = b2Body.b2_staticBody;
		}

		override public function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
			var polyDef : b2PolygonShape = new b2PolygonShape();

			polyDef.SetAsBox(width / Settings.ratio / 2, height / Settings.ratio / 2);
			bodyDef.fixedRotation = true;

			fixtureDefs[0] = new b2FixtureDef();
			fixtureDefs[0].shape = polyDef;
			fixtureDefs[0].isSensor = true;

			gravityField = new b2Vec2();

			for each (var property in properties) {
				switch (property.name) {
					case "gravityx":
						gravityField.x = property.value;
						break;
					case "gravityy":
						gravityField.y = property.value;
						break;
				}
			}

			return super.createPhysicsObject(world, properties);
		}

		override public function onStartCollision(contact : b2Contact) : void {
			super.onStartCollision(contact);

			var otherBody : PhysicalBody = identifyCollision(contact)[1].GetUserData();

			if (otherBody != null && affectedByField[otherBody] == null) {
				if (affectsPlayer || !(otherBody is Player)) {
					affectedByField[otherBody] = true;
	
					var newGravity : b2Vec2 = otherBody.gravityVector.Copy();
					newGravity.Add(gravityField);
					otherBody.gravityVector = newGravity;
				}
			}
		}

		override public function onEndCollision(contact : b2Contact) : void {
			super.onEndCollision(contact);

			var otherBody : PhysicalBody = identifyCollision(contact)[1].GetUserData();

			if (otherBody != null && affectedByField[otherBody] != null) {
				if (affectsPlayer || !(otherBody is Player)) {
					affectedByField[otherBody] = null;
					var newGravity : b2Vec2 = otherBody.gravityVector.Copy();
					newGravity.Subtract(gravityField);
					otherBody.gravityVector = newGravity;
				}
			}
		}
	}
}
