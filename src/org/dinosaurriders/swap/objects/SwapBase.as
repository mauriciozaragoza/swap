package org.dinosaurriders.swap.objects {
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.Shapes.b2ShapeDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.Settings;
	import org.flixel.FlxSprite;
	/**
	 * @author Mau
	 */
	public class SwapBase extends FlxSprite {
		protected var body : b2Body;
				
		public function SwapBase(X:Number,Y:Number) {
			super(X, Y);
		}
		
		public function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
            var bodyDef:b2BodyDef;
            var shapeDef:b2ShapeDef;
			
			var boxDef : b2PolygonDef = new b2PolygonDef();
			boxDef.SetAsBox(width / Settings.ratio / 2, height / Settings.ratio / 2);
			shapeDef = boxDef;
			
//			var circleDef : b2CircleDef = new b2CircleDef();			
//			circleDef.radius = width / Settings.ratio / 2;			
//			shapeDef = circleDef;
			
			shapeDef.density = 50;
			shapeDef.friction = 1;
			
			bodyDef = new b2BodyDef();			
			bodyDef.position.Set((x + width / 2) / Settings.ratio, (y + height / 2) / Settings.ratio);

			body = world.CreateBody(bodyDef);
			body.CreateShape(shapeDef);
			body.SetMassFromShapes();
			
			trace("creating body", x, y, width, height, bodyDef.position.x, bodyDef.position.y);
			
			return body;
		}
		
		override public function update() : void {
			x = (body.GetPosition().x * Settings.ratio) - width / 2;
            y = (body.GetPosition().y * Settings.ratio) - height / 2;
            
			//trace("omg ", x, y);
			
			//angle = body.GetAngle() * (180 / Math.PI);
            
			super.update();
		}
	}
}
