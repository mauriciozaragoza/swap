package org.dinosaurriders.swap {
	import org.dinosaurriders.swap.physics.PhysicsUtil;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.levels.*;
	import org.dinosaurriders.swap.objects.PhysicalBody;
	import org.dinosaurriders.swap.objects.Player;
	import org.dinosaurriders.swap.objects.Trigger;
	import org.dinosaurriders.swap.physics.WorldContactListener;
	import org.flixel.*;

	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class LevelContainer extends FlxState {
		private var currentLevel : BaseLevel;
		private var player : Player;
		private var tempSprite : PhysicalBody;
		private var triggersGroup : FlxGroup = new FlxGroup;
		private var camera : FlxCamera;
		// box2d physics
		protected var world : b2World;
		private var debugSprite : Sprite;
		
		private function setupWorld() : void {
			// Gravity is 0 because is handled individually by each object
			var gravity : b2Vec2 = new b2Vec2(0, 0);
			
			// TODO fix this so that objects can sleep
			world = new b2World(gravity, true);
			world.SetContactListener(new WorldContactListener(world));
			
			debugDrawing();
		}
		
		/*
		 * Creates the physics for the given tilemap
		 */
		private function createTilemapPhysics(tilemap : FlxTilemap, properties : Array, level : BaseLevel, offsetX : Number, offsetY : Number) : void {
			var currentHitLayer : Array;
			
			// DAME tile properties are stored in properties["%DAME_tiledata%"][tileId][key]
			var tileProperties : Dictionary = properties[0] as Dictionary;
			
			if (tileProperties == null) {
				// if it has no properties, we still need to iterate over an empty array
				tileProperties = new Dictionary;
			}
			else if (tileProperties.name != "%DAME_tiledata%") {
				throw new Error("Invalid tilemap properties index");
			}
			else {
				tileProperties = tileProperties.value;
			}	
					
			var currentProperties : Array;
			
			// create map tiles
			if (level.hitTilemaps.members.lastIndexOf(tilemap) != -1) {
				currentHitLayer = tilemap.getData();
				
				// iterates on y then x to special mark platform tiles
				// var isPlatform : Boolean;
				
				for (var y : Number = 0, i : Number = 0; y < tilemap.heightInTiles; y++) {
					for (var x : Number = 0; x < tilemap.widthInTiles; x++, i++) {
						if (currentHitLayer[i] != 0) {
//							isPlatform = i - tilemap.widthInTiles >= 0 ? currentHitLayer[i - tilemap.widthInTiles] == 0 : 0;
							createTileBox(x, y, offsetX, offsetY);
						}
						
						// checks for specific properties of the tile
						// POTENTIALLY SLOW
						currentProperties = tileProperties[currentHitLayer[i]];
						if (currentProperties != null) {
							for (var j : int = 0; j < currentProperties.length; j++) {
								switch (properties[j].name) {
									case "kill":
									if (properties[j].value == true) {
										trace("omg danger at ", x, y);
									}
									break;
								}
							}
						}
					}
				}
			}
			
			// Create border tiles
			for (var y1 : int = -1; y1 <= tilemap.heightInTiles; y1++) {
				createTileBox(-1, y1, offsetX, offsetY);
				createTileBox(tilemap.widthInTiles, y1, offsetX, offsetY);
			}
			
			for (var x1 : int = -1; x1 < tilemap.widthInTiles; x1++) {
				createTileBox(x1, tilemap.heightInTiles, offsetX, offsetY);
			}
		}
		
		/*
		 * Creates a solid and static tile block, all sizes expressed in tiles
		 */
		private function createTileBox(tileX : Number, tileY : Number, offsetX : Number, offsetY : Number) : void {
			var body:b2Body;
            var bodyDef:b2BodyDef;
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
			
			var boxDef : b2PolygonShape = new b2PolygonShape();
			boxDef.SetAsBox(Settings.TILESIZE / Settings.ratio / 2, Settings.TILESIZE / Settings.ratio / 2);
			
			fixtureDef.shape = boxDef;
			fixtureDef.density = 0;
			fixtureDef.friction = 5;
			
			bodyDef = new b2BodyDef();
			bodyDef.position.Set(
				((offsetX + tileX) * Settings.TILESIZE + Settings.TILESIZE / 2) / Settings.ratio,
				((offsetY + tileY) * Settings.TILESIZE + Settings.TILESIZE / 2) / Settings.ratio);
			bodyDef.type = b2Body.b2_staticBody;
			
			body = world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			//body.SetUserData(isPlatform);
		}

		override public function create() : void {
			// sets up the world physics
			setupWorld();
			
			// Creates the level
			currentLevel = new Level_Level1(true, onObjectAddedCallback);
			
			FlxG.bgColor = currentLevel.bgColor;

			camera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
			FlxG.resetCameras(camera);
			camera.follow(player, FlxCamera.STYLE_PLATFORMER);
			camera.setBounds(currentLevel.boundsMin.x, currentLevel.boundsMin.y, currentLevel.boundsMax.x - currentLevel.boundsMin.x, currentLevel.boundsMax.y - currentLevel.boundsMin.y);
			
			// Will be removed when box2d is implemented
			// FlxG.worldBounds = new FlxRect(currentLevel.boundsMin.x, currentLevel.boundsMin.y, currentLevel.boundsMax.x, currentLevel.boundsMax.y);
		}

		protected function onObjectAddedCallback(obj : Object, layer : FlxGroup, level : BaseLevel, scrollX : Number, scrollY : Number, properties : Array) : Object {
			if (obj is Player) {
				player = obj as Player;
				player.createPhysicsObject(world);
			} else if (obj is FlxTilemap) {
				var map : FlxTilemap = obj as FlxTilemap;
				createTilemapPhysics(map, properties, level, map.x / Settings.TILESIZE, map.y / Settings.TILESIZE);
			} else if (obj is PhysicalBody) {
				var physicsBody : PhysicalBody = obj as PhysicalBody;
				tempSprite = physicsBody;
				physicsBody.createPhysicsObject(world);				
			} /*else if (obj is TextData) {
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
			}*/

			return obj;
		}

		override public function update() : void {
			super.update();

			// destroy disposed objects
			PhysicsUtil.destroyPhysicObjects(world);

			// Box2D physics step
			world.Step(FlxG.elapsed, 10, 10);
			//world.DrawDebugData();
			world.ClearForces();
			
			// swap test
			if (FlxG.keys.justPressed("X")) {
				player.swap(tempSprite);
			}
			
			// map collisions
			FlxG.overlap(triggersGroup, player, TriggerEntered);
			//FlxG.collide(currentLevel.hitTilemaps, player);
			//trace(player.isTouching(FlxObject.FLOOR));
		}
		
		private function debugDrawing() : void {
			//Assuming a world is set up, under variable m_world
			//debugSprite is some sprite that we want to draw our debug shapes into.
			debugSprite = new Sprite();
			FlxG.stage.addChild(debugSprite);
			 
			// FIXME debug does not follow camera
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(Settings.ratio);
			debugDraw.SetLineThickness(1);
			debugDraw.SetAlpha(1.0);
			debugDraw.SetFillAlpha(0.5);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			world.SetDebugDraw(debugDraw);
		}

		private function TriggerEntered(trigger : Trigger, plr : FlxSprite) : void {
			var target : Object = trigger.targetObject;

			trace("die plz!");
			target.kill();
		}
	}
}