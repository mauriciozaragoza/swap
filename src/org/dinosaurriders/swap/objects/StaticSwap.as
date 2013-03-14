package org.dinosaurriders.swap.objects {
	import org.dinosaurriders.swap.objects.SwapBase;

	/**
	 * @author Mau
	 */
	public class StaticSwap extends SwapBase {
		[Embed(source='../assets/boulder_big_grass.png')] private var imgObject:Class;
		
		public function StaticSwap(X:Number,Y:Number):void {
			super(X, Y);
			loadGraphic(imgObject, false, false, 64, 64);
		}
	}
}
