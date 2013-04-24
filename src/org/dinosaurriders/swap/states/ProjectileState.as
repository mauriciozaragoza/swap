package org.dinosaurriders.swap.states {
	import org.dinosaurriders.swap.objects.Projectile;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxState;
	/**
	 * @author Mau
	 */
	public class ProjectileState extends FlxState {
		var projectileGroup : FlxGroup;
		var projectile : Projectile;
		
		public function ProjectileState() {
			projectileGroup = new FlxGroup();
			for (var i : int = 0; i < 10; i++) {
				projectile = new Projectile();
				projectileGroup.add(projectile);
			}
			
			add(projectileGroup);
		}
			
		override public function update() : void {
			super.update();
			
			if (FlxG.mouse.justPressed()) {
				trace("lolz", FlxG.mouse.x, FlxG.mouse.y);
				projectile = projectileGroup.getFirstAvailable() as Projectile;
				projectile.x = FlxG.mouse.x;
				projectile.y = FlxG.mouse.y;
				projectile.exists = true;
				projectile.visible = true;
			}
		}
	}
}
