package org.dinosaurriders.swap.objects {
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.Settings;

	/**
	 * @author Mau
	 */
	public class SolidTile extends PhysicalBody {
		private var kills : Boolean;
		
		public function SolidTile(X : Number, Y : Number, kills : Boolean, density : Number = 1, restitution : Number = 0, friction : Number = 1) {
			super(X, Y, density, restitution, friction);
			
			this.kills = kills;
			
			bodyDef.type = b2Body.b2_staticBody;
		}
			
		override public function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
			var polyDef : b2PolygonShape = new b2PolygonShape();

			polyDef.SetAsBox(Settings.TILESIZE / Settings.ratio / 2, Settings.TILESIZE / Settings.ratio / 2);
			
			fixtureDefs[0] = new b2FixtureDef();
			fixtureDefs[0].shape = polyDef;
			
			return super.createPhysicsObject(world, properties);
		}

		override public function onStartCollision(contact : b2Contact) : void {
			var collision : Vector.<b2Fixture> = identifyCollision(contact);
			
			if (kills && collision[1].GetUserData() is Player) {
				(collision[1].GetUserData() as Player).kill();
			}
		}
	}
}
