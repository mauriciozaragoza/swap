package org.dinosaurriders.swap.objects {
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;

	import org.dinosaurriders.swap.Settings;
	/**
	 * @author Drakaen
	 */
	public class PolygonBody extends PhysicalBody {
		public function PolygonBody(X : Number, Y : Number, image : Class, sides : Number = 4, 
			density : Number = 1, restitution : Number = 0, friction : Number = 1) : void {
			super(X, Y, density, restitution, friction);
			
			loadGraphic(image, false, false);
				
			var polyDef : b2PolygonShape = new b2PolygonShape();
			
			var vertices : Array = new Array;
			var dtheta : Number = 2 * Math.PI / sides, radius : Number = width / Settings.ratio / 2,
			    initAngle : Number = 0;
			
			// dtheta / 2 is so that it starts with flat side below
			if (sides % 2 == 0) {
				initAngle = dtheta / 2.0;
			}
			
			for (var i : int = initAngle; i < sides + initAngle; i++) {
				vertices.push(new b2Vec2(
					Math.cos(dtheta * i) * radius,
					Math.sin(dtheta * i) * radius
				));
			}
			
			polyDef.SetAsVector(vertices, sides);
			
			fixtureDef.shape = polyDef;
		}
	}
}
