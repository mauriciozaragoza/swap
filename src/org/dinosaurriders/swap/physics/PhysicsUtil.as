package org.dinosaurriders.swap.physics {
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;
	/**
	 * @author Drakaen
	 */
	public class PhysicsUtil {
		private static var destroyQueue : Array = new Array();
		
		public static function destroyPhysicObjects(world : b2World) : void {
			while (destroyQueue.length > 0) {
				world.DestroyBody(destroyQueue.pop() as b2Body);
			}
		}
		
		public static function enqueueDeletedBody(body : b2Body) : void {
			destroyQueue.push(body);
		}
	}
}
