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
		private var warpTo : String;
		
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
			
			for each (var property in properties) {
				switch (property.name) {
					case "warp":
						warpTo = property.value;
						break;
				}
			}
			
			return super.createPhysicsObject(world, properties);
		}
		
		override public function onStartCollision(contact : b2Contact) : void {
			super.onStartCollision(contact);
			
			var otherBody : PhysicalBody = identifyCollision(contact)[1].GetUserData();
			
			if (otherBody is Player) {
				var player : Player = otherBody as Player;
				player.exitLevel(warpTo);
			}
		}
	}
}
