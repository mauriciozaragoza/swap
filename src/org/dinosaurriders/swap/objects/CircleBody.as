package org.dinosaurriders.swap.objects {
	import Box2D.Collision.Shapes.b2CircleShape;

	import org.dinosaurriders.swap.Settings;
	/**
	 * @author Drakaen
	 */
	public class CircleBody extends PhysicalBody {
		public function CircleBody(X : Number, Y : Number, image : Class,
			density : Number = 1, restitution : Number = 0, friction : Number = 1) : void {
			super(X, Y, density, restitution, friction);
			
			loadGraphic(image, false, false);
			
			var circleDef : b2CircleShape = new b2CircleShape();
			circleDef.SetRadius(width / Settings.ratio / 2);
			fixtureDef.shape = circleDef;
		}
	}
}
