package org.dinosaurriders.swap.objects {
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.Settings;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FX.BlurFX;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;

	import flash.utils.Dictionary;

	/**
	 * @author Mau
	 */
	public class PropertyField extends PhysicalBody {
		private var gravityField : b2Vec2;
		private var affectedByField : Dictionary;
		private var blurs : Boolean;
		private var onlyPlayer : Boolean;

		public function PropertyField(X : Number, Y : Number) {
			super(X, Y, 0, 0, 0);

			affectedByField = new Dictionary();
			affectsPlayer = true;

			bodyDef.type = b2Body.b2_staticBody;
		}

		override public function createPhysicsObject(world : b2World, properties : Array = null) : b2Body {
			var polyDef : b2PolygonShape = new b2PolygonShape();

			polyDef.SetAsBox(width / Settings.ratio / 2, height / Settings.ratio / 2);
			bodyDef.fixedRotation = true;

			fixtureDefs[0] = new b2FixtureDef();
			fixtureDefs[0].shape = polyDef;
			fixtureDefs[0].isSensor = true;

			gravityField = new b2Vec2();

			for each (var property in properties) {
				switch (property.name) {
					case "gravityx":
						gravityField.x = property.value;
						break;
					case "gravityy":
						gravityField.y = property.value;
						break;
					case "blur":
						blurs = property.value;
						break;
					case "onlyPlayer":
						onlyPlayer = property.value;
						break;
				}
			}

			return super.createPhysicsObject(world, properties);
		}
		
		

		override public function onStartCollision(contact : b2Contact) : void {
			super.onStartCollision(contact);
			
			var otherBody : PhysicalBody = identifyCollision(contact)[1].GetUserData();
			
			if (otherBody != null && affectedByField[otherBody] == null) {
				if ((affectsPlayer && otherBody is Player) || (!affectsPlayer && !(otherBody is Player))) {
					applyProperties(otherBody);
				}
			}
		}

		override public function onEndCollision(contact : b2Contact) : void {
			super.onEndCollision(contact);

			var otherBody : PhysicalBody = identifyCollision(contact)[1].GetUserData();

			if (otherBody != null && affectedByField[otherBody] != null) {
				if ((affectsPlayer && otherBody is Player) || (!affectsPlayer && !(otherBody is Player))) {
					ripProperties(otherBody)
				}
			}
		}

		public function applyProperties(affectedBody : PhysicalBody) : void {
			if (blurs) {
				if (FlxG.getPlugin(FlxSpecialFX) == null) {
					FlxG.addPlugin(new FlxSpecialFX);
				}
				var blur : BlurFX;
				var blurEffect : FlxSprite;
				blur = FlxSpecialFX.blur();
				blurEffect = blur.create(320, 240, 2, 2, 1);
				blur.addSprite(affectedBody);
				blur.start(2);
			}
			affectedByField[affectedBody] = true;
			var newGravity : b2Vec2 = affectedBody.gravityVector.Copy();
			newGravity.Add(gravityField);
			affectedBody.gravityVector = newGravity;
		}

		public function ripProperties(affectedBody : PhysicalBody) : void {
			if (blurs) {
				FlxG.removePluginType(FlxSpecialFX);
			}
			affectedByField[affectedBody] = null;
			var newGravity : b2Vec2 = affectedBody.gravityVector.Copy();
			newGravity.Subtract(gravityField);
			affectedBody.gravityVector = newGravity;
		}
	}
}
