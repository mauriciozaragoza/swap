package org.dinosaurriders.swap {
	import org.dinosaurriders.swap.levels.BaseLevel;
	import org.dinosaurriders.swap.levels.BoxData;
	import org.dinosaurriders.swap.levels.Level_Level1;
	import org.dinosaurriders.swap.levels.ObjectLink;
	import org.dinosaurriders.swap.levels.TextData;
	import org.dinosaurriders.swap.objects.Player;
	import org.dinosaurriders.swap.objects.Trigger;
	import org.flixel.*;

	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	/* Complex Claws PlayState.as
	 * This sample code is intended to be used along with the flixelComplex exporter.
	 * */

	public class LevelLoader extends FlxState
	{
//		[Embed(systemFont = 'Verdana', fontName = 'VerdanaFont', mimeType = 'application/x-font')] private var fontVerdana:Class;
//		[Embed(systemFont='Arial', fontName='ArialFont', mimeType='application/x-font')] private var fontArial:Class;
		
		private var currentLevel:BaseLevel;
		private var player:Player;
		
		public static var elaspedTime:Number = 0;
		private static var lastTime:uint = 0;
		
		private var triggersGroup:FlxGroup = new FlxGroup;
		
		private var ids:Dictionary = new Dictionary(true);
		
		private var camera:FlxCamera;
		
		public function LevelLoader():void
		{
			super();
		}
		
		override public function create():void
		{
			currentLevel = new Level_Level1(true, onObjectAddedCallback);
			
			FlxG.bgColor = currentLevel.bgColor;
			
			camera = new FlxCamera(0, 0, FlxG.width, FlxG.height);
			//camera.setBounds(currentLevel.boundsMin.x, currentLevel.boundsMin.y, currentLevel.boundsMax.x - currentLevel.boundsMin.x, currentLevel.boundsMax.y - currentLevel.boundsMin.y);
			FlxG.resetCameras(camera);
			camera.follow(player, FlxCamera.STYLE_PLATFORMER);
			//FlxG.worldBounds = new FlxRect(BaseLevel.boundsMinX + 1, BaseLevel.boundsMinY + 1, BaseLevel.boundsMaxX - BaseLevel.boundsMinX, BaseLevel.boundsMaxY - BaseLevel.boundsMinY);
			FlxG.worldBounds = new FlxRect(0, 0, 2000, 1000);
		}
		
		protected function onObjectAddedCallback(obj:Object, layer:FlxGroup, level:BaseLevel, scrollX:Number, scrollY:Number, properties:Array):Object
		{
			if ( properties )
			{
				var i:uint = properties.length;
				while(i--)
				{
					if ( properties[i].name == "id" )
					{
						var name:String = properties[i].value;
						ids[name] = obj;
						break;
					}
				}
			}
			if (obj is Player)
			{
				player = obj as Player;
			}
			else if ( obj is TextData )
			{
				var tData:TextData = obj as TextData;
				if ( tData.fontName != "" && tData.fontName != "system" )
				{
					tData.fontName += "Font";
				}
				return level.addTextToLayer(tData, layer, scrollX, scrollY, true, properties, onObjectAddedCallback );
			}
			else if ( obj is BoxData )
			{
				trace("trigger found");
				
				// Create the trigger.
				var bData:BoxData = obj as BoxData;
				var box:Trigger = new Trigger(bData.x, bData.y, bData.width, bData.height);
				level.addSpriteToLayer(box, FlxSprite, layer, box.x, box.y, bData.angle, scrollX, scrollY);
				triggersGroup.add(box);
				
				box.ParseProperties(properties);
				
				return box;
			}
			else if ( obj is ObjectLink )
			{
				trace("link added");
				
				var link:ObjectLink = obj as ObjectLink;
				var fromBox:Trigger = link.fromObject as Trigger;
				
				fromBox.AddLinkTo(link.toObject);
			}
			
			return obj;
		}
		
		override public function update():void
		{
			var time:uint = getTimer();
			elaspedTime = (time - lastTime) / 1000;
			lastTime = time;
			
			super.update();
			
			// map collisions			
			FlxG.collide(currentLevel.hitTilemaps, player);
			FlxG.overlap(triggersGroup, player, TriggerEntered);
		}
		
		private function TriggerEntered(trigger:Trigger, plr:FlxSprite):void
		{
			var target:Object = trigger.targetObject ? trigger.targetObject : ids[trigger.target];
			trace("die plz!");
			target.kill();
		}
	}

}