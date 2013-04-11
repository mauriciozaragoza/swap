package org.dinosaurriders.swap {
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;

	import org.dinosaurriders.swap.levels.*;
	import org.dinosaurriders.swap.objects.PhysicalBody;
	import org.dinosaurriders.swap.objects.Player;
	import org.dinosaurriders.swap.objects.PropertyField;
	import org.dinosaurriders.swap.objects.SolidTile;
	import org.dinosaurriders.swap.physics.PhysicsUtil;
	import org.dinosaurriders.swap.physics.WorldContactListener;
	import org.flixel.*;

	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class LevelContainer extends FlxState {
		private var currentLevel : BaseLevel;
		private var player : Player;
		private var camera : FlxCamera;
		
		// box2d physics
		protected var world : b2World;
		protected var worldGroup : FlxGroup;
		
		private var debugSprite : Sprite;
		
		override public function create() : void {
			worldGroup = new FlxGroup();
			
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
							createTileBox(x, y, offsetX, offsetY, tileProperties[currentHitLayer[i]]);
						}
					}
				}
			}
			
			// Create border tiles
			for (var y1 : int = -1; y1 <= tilemap.heightInTiles; y1++) {
				createTileBox(-1, y1, offsetX, offsetY, []);
				createTileBox(tilemap.widthInTiles, y1, offsetX, offsetY, []);
			}
			
			for (var x1 : int = -1; x1 < tilemap.widthInTiles; x1++) {
				createTileBox(x1, tilemap.heightInTiles, offsetX, offsetY, [{name : "kills", value : true}]);
			}
		}
		
		/*
		 * Creates a solid and static tile block, all sizes expressed in tiles
		 */
		private function createTileBox(tileX : Number, tileY : Number, offsetX : Number, offsetY : Number, properties : Array) : void {
			var tile : SolidTile;
			var kills : Boolean;
			
			for each (var property : Object in properties) {
				switch (property.name) {
					case "kills":
					kills = property.value;
					break;
				}
			}
			
			tile = new SolidTile(offsetX + tileX * Settings.TILESIZE, offsetY + tileY * Settings.TILESIZE, kills);
			tile.width = Settings.TILESIZE;
			tile.height = Settings.TILESIZE;
			tile.createPhysicsObject(world, properties);
			
			worldGroup.add(tile);
		}

		protected function onObjectAddedCallback(obj : Object, layer : FlxGroup, level : BaseLevel, scrollX : Number, scrollY : Number, properties : Array) : Object {
			if (obj is Player) {
				player = obj as Player;
				player.createPhysicsObject(world, properties);
			} else if (obj is FlxTilemap) {
				var map : FlxTilemap = obj as FlxTilemap;
				createTilemapPhysics(map, properties, level, map.x / Settings.TILESIZE, map.y / Settings.TILESIZE);
			} else if (obj is ObjectLink) {
				var link : ObjectLink = obj as ObjectLink;
				
				// should always be physicalbody anyway
				if (link.fromObject is PhysicalBody) {
					((PhysicalBody)(link.fromObject)).addObjectLink(properties[0].name, properties[0].value, link.toObject);
				}
			} else if (obj is BoxData) {
                var field : PropertyField = new PropertyField(obj.x, obj.y);
                field.width = obj.width;
                field.height = obj.height;
                field.createPhysicsObject(world, properties);
            } 
            
            if (obj is PhysicalBody) {
				var physicsBody : PhysicalBody = obj as PhysicalBody;
				physicsBody.createPhysicsObject(world, properties);
				worldGroup.add(physicsBody);				
			}
            
			return obj;
		}

		override public function update() : void {
			super.update();

			// destroy disposed objects
			PhysicsUtil.destroyPhysicObjects(world);
                        
			// Box2D physics step
			world.Step(FlxG.elapsed, 10, 10);
			world.DrawDebugData();
			world.ClearForces();
            
            PhysicsUtil.callSwaps();
			if(FlxG.keys.justPressed("R")){
				this.reset();
			}
			if(this.player.dead){
				this.reset();
			}
		}
		
		private function reset():void{
			/*var temp:Player=this.player;
			player.kill();
			player.revive();
			player=temp;*/
			
			
			this.kill();
			currentLevel=new Level_Level7(true, onObjectAddedCallback);
			
			/*FlxG.resetCameras(camera);
			camera.follow(player, FlxCamera.STYLE_PLATFORMER);
			camera.setBounds(currentLevel.boundsMin.x, currentLevel.boundsMin.y, currentLevel.boundsMax.x - currentLevel.boundsMin.x, currentLevel.boundsMax.y - currentLevel.boundsMin.y);*/
			
			FlxG.flash(0xffffff,2);
			//FlxG.switchState(new LevelContainer());
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
	}
}