package org.dinosaurriders.swap.physics {
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.Settings;
	import org.dinosaurriders.swap.objects.PhysicalBody;
	/**
	 * @author Drakaen
	 */
	public class PhysicsUtil {
		private static var destroyQueue : Vector.<b2Body> = new Vector.<b2Body>();
		private static var swapQueue : Vector.<PhysicalBody> = new Vector.<PhysicalBody>();
		
		private static var currentSkipCount : int = 0;
		
		public static function destroyPhysicObjects(world : b2World) : void {
			while (destroyQueue.length > 0) {
				world.DestroyBody(destroyQueue.pop());
			}
		}
		
		public static function enqueueDeletedBody(body : b2Body) : void {
			destroyQueue.push(body);
		}
		
		public static function enqueueSwap(body1 : PhysicalBody, body2 : PhysicalBody) : void {
			swapQueue.push(body1, body2);
			currentSkipCount = 0;
		}
		
		public static function callSwaps() : void {
			if (swapQueue.length > 0) {
				currentSkipCount++;
				swapQueue[0].enabled = swapQueue[1].enabled = false;
			}
			
			if (currentSkipCount == Settings.SWAPSKIPCOUNT) {
				while (swapQueue.length > 0) {
					swapQueue[0].enabled = swapQueue[1].enabled = true;
					(swapQueue.pop() as PhysicalBody).swap(swapQueue.pop());
				}
				
				currentSkipCount = 0;
			}
		}
	}
}
