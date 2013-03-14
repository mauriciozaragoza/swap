package org.dinosaurriders.swap {
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.levels.BaseLevel;
	import org.dinosaurriders.swap.levels.BoxData;
	import org.dinosaurriders.swap.levels.Level_Level1;
	import org.dinosaurriders.swap.levels.ObjectLink;
	import org.dinosaurriders.swap.levels.TextData;
	import org.dinosaurriders.swap.objects.Player;
	import org.dinosaurriders.swap.objects.StaticSwap;
	import org.dinosaurriders.swap.objects.Trigger;
	import org.flixel.*;

	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class LevelContainer extends FlxState {
		private var currentLevel : BaseLevel;
		private var player : Player;
		public static var elapsedTime : Number = 0;
		private static var lastTime : uint = 0;
		private var triggersGroup : FlxGroup = new FlxGroup;
		private var ids : Dictionary = new Dictionary(true);
		private var camera : FlxCamera;
		// box2d physics
		protected var _world : b2World;
		private var physicBodies : Array;

		public function LevelContainer() : void {
			super();
			
			physicBodies = new Array;
		}

		private function setupWorld(x1 : Number, y1 : Number, x2 : Number, y2 : Number) : void {
			trace("creating world", x1, y1, x2, y2);
			
			var worldAABB : b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(x1 / Settings.ratio, y1 / Settings.ratio);
			worldAABB.upperBound.Set(x2 / Settings.ratio, y2 / Settings.ratio);

			// TODO must be able to handle multiple gravities
			var gravity : b2Vec2 = new b2Vec2(0, 9.8);
			_world = new b2World(worldAABB, gravity, true);
			
			var currentHitLayer : Array; 
			for each (var hitLayer : FlxTilemap in currentLevel.hitTilemaps.members) {
				currentHitLayer = hitLayer.getData();
				for (var y : Number = 0, i : Number = 0; y < hitLayer.heightInTiles; y++) {
					for (var x : Number = 0; x < hitLayer.widthInTiles; x++, i++) {
						if (currentHitLayer[i] != 0) {
							createTileBox(x, y);
						}
					}
				}
			}
			
			// TODO must be a higher class than staticswap which extends to other physical bodies 
			for each (var body : StaticSwap in physicBodies) {
				body.createPhysicsObject(_world);
			}
		}
		
		private function createTileBox(tileX : Number, tileY : Number) : void {
			// FIXME hardcoded sizes
			var body:b2Body;
            var bodyDef:b2BodyDef;
            var boxDef:b2PolygonDef;
			
			boxDef = new b2PolygonDef();
			boxDef.SetAsBox(32 / Settings.ratio / 2, 32 / Settings.ratio / 2);
			
			boxDef.density = 0;
			boxDef.friction = 5;
			
			bodyDef = new b2BodyDef();			
			bodyDef.position.Set((tileX * 32 + 16) / Settings.ratio, (tileY * 32 + 16) / Settings.ratio);
			
			body = _world.CreateBody(bodyDef);
			body.CreateShape(boxDef);
			body.SetMassFromShapes();
		}

		override public function create() : void {
			currentLevel = new Level_Level1(true, onObjectAddedCallback);

			FlxG.bgColor = currentLevel.bgColor;

			camera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
			FlxG.resetCameras(camera);
			camera.follow(player, FlxCamera.STYLE_PLATFORMER);
			camera.setBounds(currentLevel.boundsMin.x, currentLevel.boundsMin.y, currentLevel.boundsMax.x - currentLevel.boundsMin.x, currentLevel.boundsMax.y - currentLevel.boundsMin.y);
			FlxG.worldBounds = new FlxRect(currentLevel.boundsMin.x, currentLevel.boundsMin.y, currentLevel.boundsMax.x, currentLevel.boundsMax.y);

			// sets up the world physics
			setupWorld(currentLevel.boundsMin.x, currentLevel.boundsMin.y, currentLevel.boundsMax.x, currentLevel.boundsMax.y);
		}

		protected function onObjectAddedCallback(obj : Object, layer : FlxGroup, level : BaseLevel, scrollX : Number, scrollY : Number, properties : Array) : Object {
			// finds all 
			if (properties) {
				var i : uint = properties.length;
				while (i--) {
					if (properties[i].name == "id") {
						var name : String = properties[i].value;
						ids[name] = obj;
						break;
					}
				}
			}
			
			if (obj is Player) {
				player = obj as Player;
			} else if (obj is StaticSwap) {
				physicBodies.push(obj);
			} else if (obj is TextData) {
				var tData : TextData = obj as TextData;
				if ( tData.fontName != "" && tData.fontName != "system" ) {
					tData.fontName += "Font";
				}
				
				return level.addTextToLayer(tData, layer, scrollX, scrollY, true, properties, onObjectAddedCallback);
			} else if (obj is BoxData) {
				// Create the trigger.
				var bData : BoxData = obj as BoxData;
				var box : Trigger = new Trigger(bData.x, bData.y, bData.width, bData.height);
				level.addSpriteToLayer(box, FlxSprite, layer, box.x, box.y, bData.angle, scrollX, scrollY);
				triggersGroup.add(box);

				box.ParseProperties(properties);

				return box;
			} else if (obj is ObjectLink ) {
				var link : ObjectLink = obj as ObjectLink;
				var fromBox : Trigger = link.fromObject as Trigger;

				fromBox.AddLinkTo(link.toObject);
			}

			return obj;
		}

		override public function update() : void {
			var time : uint = getTimer();
			elapsedTime = (time - lastTime) / 1000;
			lastTime = time;

			super.update();

			// Box2D physics step
			_world.Step(1.0/30.0, 10);
			
			// map collisions
			FlxG.collide(currentLevel.hitTilemaps, player);
			FlxG.overlap(triggersGroup, player, TriggerEntered);
		}

		private function TriggerEntered(trigger : Trigger, plr : FlxSprite) : void {
			var target : Object = trigger.targetObject ? trigger.targetObject : ids[trigger.target];

			trace("die plz!");
			target.kill();
		}
	}
}