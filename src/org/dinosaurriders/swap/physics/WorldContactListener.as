package org.dinosaurriders.swap.physics {
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.objects.Player;

	/**
	 * @author Drakaen
	 */
	public class WorldContactListener extends b2ContactListener {
		private var world : b2World;
		private var footContactCount : int = 0;

		public function WorldContactListener(world : b2World) {
			this.world = world;
		}

		override public function BeginContact(contact : b2Contact) : void {
			var playerFixture : b2Fixture, otherFixture : b2Fixture;
			var worldManifold : b2WorldManifold = new b2WorldManifold();
			var player : Player;
			contact.GetWorldManifold(worldManifold);

			if (contact.GetFixtureA().GetUserData() is Player) {
				player = contact.GetFixtureA().GetUserData() as Player;
				playerFixture = contact.GetFixtureA();
				otherFixture = contact.GetFixtureB();

				if (playerFixture == player.fixtures[1]) {
					footContactCount++;
					solvePlayerFeetStatus(playerFixture, otherFixture, worldManifold);
				}
			} else if (contact.GetFixtureB().GetUserData() is Player) {
				player = contact.GetFixtureB().GetUserData() as Player;
				playerFixture = contact.GetFixtureB();
				otherFixture = contact.GetFixtureA();

				if (playerFixture == player.fixtures[1]) {
					footContactCount++;
					solvePlayerFeetStatus(playerFixture, otherFixture, worldManifold);
				}
			}
		}

		override public function EndContact(contact : b2Contact) : void {
			var player : Player;

			if (contact.GetFixtureA().GetUserData() is Player) {
				player = contact.GetFixtureA().GetUserData() as Player;

				if (contact.GetFixtureA() == player.fixtures[1]) {
					footContactCount--;
					removePlayerGroundedStatus(player);
				}
			} else if (contact.GetFixtureB().GetUserData() is Player) {
				player = contact.GetFixtureB().GetUserData() as Player;

				if (contact.GetFixtureB() == player.fixtures[1]) {
					footContactCount--;
					removePlayerGroundedStatus(player);
				}
			}
		}

		private function solvePlayerFeetStatus(playerFixture : b2Fixture, otherFixture : b2Fixture, worldManifold : b2WorldManifold) : void {
			var vel1 : b2Vec2 = playerFixture.GetBody().GetLinearVelocityFromWorldPoint(worldManifold.m_points[0]);
			var vel2 : b2Vec2 = otherFixture.GetBody().GetLinearVelocityFromWorldPoint(worldManifold.m_points[0]);
			var impactVelocity : b2Vec2 = vel1.Copy();
			impactVelocity.Subtract(vel2);

			playerFixture.GetUserData().setFriction(1);

			trace("impact ", impactVelocity.x, impactVelocity.y);
		}

		private function removePlayerGroundedStatus(player : Player) : void {			
			if (footContactCount == 0) {
				player.setFriction(0);
				trace("not grounded");
			}
		}
	}
}
