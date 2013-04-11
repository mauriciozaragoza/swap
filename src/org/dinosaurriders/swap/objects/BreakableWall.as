package org.dinosaurriders.swap.objects {
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.Settings;

	/**
	 * @author Drakaen
	 */
	public class BreakableWall extends PhysicalBody {
		private var forceToBreak : Number;
		
		public function BreakableWall(X : Number, Y : Number, image : Class, forceToBreak : Number) {
			super(X, Y, 100, 0, 1);
			
			this.forceToBreak = forceToBreak;
			loadGraphic(image, false, false);
			
			bodyDef.type = b2Body.b2_staticBody;
		}
		
		override public function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
			var polyDef : b2PolygonShape = new b2PolygonShape();
			polyDef.SetAsBox(width / Settings.ratio / 2, height / Settings.ratio / 2);
			
			fixtureDefs[0] = new b2FixtureDef();
			fixtureDefs[0].shape = polyDef;
			
			return super.createPhysicsObject(world, properties);
		}
			
		override public function onBeforeSolveCollision(contact : b2Contact, oldManifold : b2Manifold) : void {
			var forceApplied : Number;
			var otherBody : b2Body = identifyCollision(contact)[1].GetBody();
			
			// kg * m / s
			// FIXME only takes velocity x component into account
			forceApplied = Math.abs(otherBody.GetLinearVelocity().x) * otherBody.GetMass(); 
			
			trace("impulse: ", forceApplied);
			
			if (forceApplied > forceToBreak) {
				trace("omg kill");
				kill();
			}
		}
	}
}
