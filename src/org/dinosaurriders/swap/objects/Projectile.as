package org.dinosaurriders.swap.objects {
	import org.dinosaurriders.swap.Assets;
	import org.flixel.FlxSprite;

	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Mau
	 */
	public class Projectile extends FlxSprite {
		public function Projectile(X : Number = 0, Y : Number = 0, SimpleGraphic : Class = null) {
			super(X, Y, SimpleGraphic);
			
			loadGraphic(Assets.Exit, true, true, 48, 48);
			
			addAnimation("idle", [0,1,2,3,4,5,6,7,8,9,10], 8,true);
			play("idle");
			
			exists = false;
		}

		override public function update() : void {
			super.update();
			velocity.x = 10;
			framePixels.applyFilter(framePixels, new Rectangle(0, 0, width, height), new Point(0, 0), new GlowFilter(0x6600cc, 0.3, 12, 12, 1, 3, true));
			if (x > 500) {
				exists = false;		
			}
		}
	}
}
