//Code generated with DAME. http://www.dambots.com

package org.dinosaurriders.swap.levels
{
	import org.flixel.*;
	import flash.utils.Dictionary;
	// Custom imports:
import org.dinosaurriders.swap.*;import org.dinosaurriders.swap.objects.*;
	public class Level_Level3 extends BaseLevel
	{
		//Embedded media...
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level3_Sky.csv", mimeType="application/octet-stream")] public var CSV_Sky:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_Sky:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level3_Background.csv", mimeType="application/octet-stream")] public var CSV_Background:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_Background:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level3_PlayerLayer.csv", mimeType="application/octet-stream")] public var CSV_PlayerLayer:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_PlayerLayer:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level3_FrontLayer.csv", mimeType="application/octet-stream")] public var CSV_FrontLayer:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_FrontLayer:Class;

		//Tilemaps
		public var layerSky:FlxTilemap;
		public var layerBackground:FlxTilemap;
		public var layerPlayerLayer:FlxTilemap;
		public var layerFrontLayer:FlxTilemap;

		//Sprites
		public var SpritesGroup:FlxGroup = new FlxGroup;

		//Shapes
		public var TextGroup:FlxGroup = new FlxGroup;

		//Properties


		public function Level_Level3(addToStage:Boolean = true, onAddCallback:Function = null, parentObject:Object = null)
		{
			// Generate maps.
			var properties:Array = [];
			var tileProperties:Dictionary = new Dictionary;

			properties = generateProperties( null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[15]=generateProperties( { name:"kills", value:true }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerSky = addTilemap( CSV_Sky, Img_Sky, 0.000, -32.000, 32, 32, 0.250, 0.250, false, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[15]=generateProperties( { name:"kills", value:true }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerBackground = addTilemap( CSV_Background, Img_Background, 0.000, -32.000, 32, 32, 0.500, 0.500, false, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[15]=generateProperties( { name:"kills", value:true }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerPlayerLayer = addTilemap( CSV_PlayerLayer, Img_PlayerLayer, 0.000, -32.000, 32, 32, 1.000, 1.000, true, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[15]=generateProperties( { name:"kills", value:true }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerFrontLayer = addTilemap( CSV_FrontLayer, Img_FrontLayer, 0.000, -32.000, 32, 32, 1.000, 1.000, false, 1, 1, properties, onAddCallback );

			//Add layers to the master group in correct order.
			masterLayer.add(layerSky);
			masterLayer.add(layerBackground);
			masterLayer.add(layerPlayerLayer);
			masterLayer.add(SpritesGroup);
			masterLayer.add(layerFrontLayer);
			masterLayer.add(TextGroup);

			if ( addToStage )
				createObjects(onAddCallback, parentObject);

			boundsMinX = 0;
			boundsMinY = -32;
			boundsMaxX = 640;
			boundsMaxY = 480;
			boundsMin = new FlxPoint(0, -32);
			boundsMax = new FlxPoint(640, 480);
			bgColor = 0xff88beef;
		}

		override public function createObjects(onAddCallback:Function = null, parentObject:Object = null):void
		{
			addShapesForLayerText(onAddCallback);
			addSpritesForLayerSprites(onAddCallback);
			generateObjectLinks(onAddCallback);
			if ( parentObject != null )
				parentObject.add(masterLayer);
			else
				FlxG.state.add(masterLayer);
		}

		public function addShapesForLayerText(onAddCallback:Function = null):void
		{
			var obj:Object;

			linkedObjectDictionary[28] = callbackNewData(new TextData(0.000, 30.000, 510.000, 50.000, 0.000, "The S.W.A.P. spell lets me select glowing objects with the [S] key","system", 11, 0x000000, "center"), onAddCallback, TextGroup, generateProperties( null ), 1, 1, true  ) ;
			obj = new BoxData(0.000, 120.000, 0.000, 50.000, 200.000, TextGroup );
			shapes.push(obj);
			linkedObjectDictionary[27] = callbackNewData( obj, onAddCallback, TextGroup, generateProperties( null ), 1, 1, true  );
			obj = new BoxData(330.000, 240.000, 0.000, 50.000, 200.000, TextGroup );
			shapes.push(obj);
			linkedObjectDictionary[29] = callbackNewData( obj, onAddCallback, TextGroup, generateProperties( null ), 1, 1, true  );
			linkedObjectDictionary[30] = callbackNewData(new TextData(0.000, 30.000, 480.000, 50.000, 0.000, "Then I can switch places with the selected object by pressing the [X] key.","system", 11, 0x000000, "center"), onAddCallback, TextGroup, generateProperties( null ), 1, 1, true  ) ;
		}

		public function addSpritesForLayerSprites(onAddCallback:Function = null):void
		{
			linkedObjectDictionary[4] = addSpriteToLayer(new WeightSwitch(450.000, 408.000, Assets.Switch1, 100), WeightSwitch, SpritesGroup , 450.000, 408.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( null ), onAddCallback );//"Switch1"
			addSpriteToLayer(new PolygonBody(240.000, 384.000, Assets.SquareRock2, 4, 2500), PolygonBody, SpritesGroup , 240.000, 384.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"SquareRock2"
			linkedObjectDictionary[5] = addSpriteToLayer(new Exit(600.000, 256.000, Assets.Exit), Exit, SpritesGroup , 600.000, 256.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"sensor", value:true }, { name:"enabled", value:false }, { name:"warp", value:"Level4" }, null ), onAddCallback );//"Exit"
			addSpriteToLayer(null, Player, SpritesGroup , 0.000, 288.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( null ), onAddCallback );//"Player"
		}

		public function generateObjectLinks(onAddCallback:Function = null):void
		{
			createLink(linkedObjectDictionary[4], linkedObjectDictionary[5], onAddCallback, generateProperties( { name:"onActivate", value:"ENABLE" }, null ) );
			createLink(linkedObjectDictionary[27], linkedObjectDictionary[28], onAddCallback, generateProperties( { name:"showText", value:true }, null ) );
			createLink(linkedObjectDictionary[29], linkedObjectDictionary[30], onAddCallback, generateProperties( { name:"showText", value:true }, null ) );
		}

	}
}
