package org.dinosaurriders.swap.physics {
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2World;
	import org.dinosaurriders.swap.Settings;
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
		
//		private function getPlayerFixtures(contact : b2Contact, playerFixture : b2Fixture, otherFixture : b2Fixture, player : Player) {
//			// Gets the player contact, if there is no player contact, player == null
//			if (contact.GetFixtureA().GetUserData() is Player) {
//				playerFixture = contact.GetFixtureA();
//				player = playerFixture.GetUserData() as Player;
//				otherFixture = contact.GetFixtureB();
//			} else if (contact.GetFixtureB().GetUserData() is Player) {
//				playerFixture = contact.GetFixtureB();
//				player = playerFixture.GetUserData() as Player;
//				otherFixture = contact.GetFixtureA();
//			}
//		}

		override public function BeginContact(contact : b2Contact) : void {
			var playerFixture : b2Fixture, otherFixture : b2Fixture;
			//var worldManifold : b2WorldManifold = new b2WorldManifold();
			var player : Player;
			//contact.GetWorldManifold(worldManifold);

			// Gets the player contact, if there is no player contact, player == null
			if (contact.GetFixtureA().GetUserData() is Player) {
				playerFixture = contact.GetFixtureA();
				player = playerFixture.GetUserData() as Player;
				otherFixture = contact.GetFixtureB();
			} else if (contact.GetFixtureB().GetUserData() is Player) {
				playerFixture = contact.GetFixtureB();
				player = playerFixture.GetUserData() as Player;
				otherFixture = contact.GetFixtureA();
			}

			if (player != null) {
				// if feet sensor touched something, then player landed somewhere
				// fixtures[1] is the feet sensor
				if (playerFixture == player.fixtures[1]) {
					footContactCount++;
					player.onLand();
				}
			}
		}

		override public function EndContact(contact : b2Contact) : void {
			var player : Player;
			var playerFixture : b2Fixture, otherFixture : b2Fixture;
			
			// Gets the player contact, if there is no player contact, player == null
			if (contact.GetFixtureA().GetUserData() is Player) {
				playerFixture = contact.GetFixtureA();
				player = playerFixture.GetUserData() as Player;
				otherFixture = contact.GetFixtureB();
			} else if (contact.GetFixtureB().GetUserData() is Player) {
				playerFixture = contact.GetFixtureB();
				player = playerFixture.GetUserData() as Player;
				otherFixture = contact.GetFixtureA();
			}

			if (player != null && playerFixture == player.fixtures[1]) {
				footContactCount--;
				if (footContactCount == 0) {
					player.onAir();
				}
			}
		}

		override public function PostSolve(contact : b2Contact, impulse : b2ContactImpulse) : void {
			super.PostSolve(contact, impulse);
			var playerFixture : b2Fixture, otherFixture : b2Fixture;
			var player : Player;

			// Gets the player contact, if there is no player contact, player == null
			if (contact.GetFixtureA().GetUserData() is Player) {
				playerFixture = contact.GetFixtureA();
				player = playerFixture.GetUserData() as Player;
				otherFixture = contact.GetFixtureB();
			} else if (contact.GetFixtureB().GetUserData() is Player) {
				playerFixture = contact.GetFixtureB();
				player = playerFixture.GetUserData() as Player;
				otherFixture = contact.GetFixtureA();
			}
			
			if (player != null) {
				//trace("force:", impulse.normalImpulses[0]);
				
				if (impulse.normalImpulses[0] > Settings.MAXFORCE) {
					trace("die!");
					player.kill();
				}
			}
		}
	}
}
