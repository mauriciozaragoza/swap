package org.dinosaurriders.swap {
	import org.dinosaurriders.swap.states.StartAnimation;
	import org.flixel.FlxGame;


  [SWF(width="640", height="512", backgroundColor="#ff0000")]
	public class Flixel extends FlxGame {
		public function Flixel() {
			super(640, 512, StartAnimation, 1, 60, 30, true);
		}
	}
}
