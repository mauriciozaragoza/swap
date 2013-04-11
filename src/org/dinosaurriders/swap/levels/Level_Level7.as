//Code generated with DAME. http://www.dambots.com

package org.dinosaurriders.swap.levels
{
	import org.flixel.*;
	import flash.utils.Dictionary;
	// Custom imports:
import org.dinosaurriders.swap.*;import org.dinosaurriders.swap.objects.*;
	public class Level_Level7 extends BaseLevel
	{
		//Embedded media...
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level7_Background.csv", mimeType="application/octet-stream")] public var CSV_Background:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_Background:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level7_BackLayer.csv", mimeType="application/octet-stream")] public var CSV_BackLayer:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_BackLayer:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level7_PlayerLayer.csv", mimeType="application/octet-stream")] public var CSV_PlayerLayer:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_PlayerLayer:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level7_FrontLayer.csv", mimeType="application/octet-stream")] public var CSV_FrontLayer:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_FrontLayer:Class;

		//Tilemaps
		public var layerBackground:FlxTilemap;
		public var layerBackLayer:FlxTilemap;
		public var layerPlayerLayer:FlxTilemap;
		public var layerFrontLayer:FlxTilemap;

		//Sprites
		public var SpritesGroup:FlxGroup = new FlxGroup;

		//Shapes
		public var GravityFieldsGroup:FlxGroup = new FlxGroup;

		//Properties


		public function Level_Level7(addToStage:Boolean = true, onAddCallback:Function = null, parentObject:Object = null)
		{
			// Generate maps.
			var properties:Array = [];
			var tileProperties:Dictionary = new Dictionary;

			properties = generateProperties( null );
			layerBackground = addTilemap( CSV_Background, Img_Background, 1920.000, 0.000, 32, 32, 1.000, 1.000, false, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			layerBackLayer = addTilemap( CSV_BackLayer, Img_BackLayer, 1920.000, 0.000, 32, 32, 1.000, 1.000, false, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			layerPlayerLayer = addTilemap( CSV_PlayerLayer, Img_PlayerLayer, 1920.000, 0.000, 32, 32, 1.000, 1.000, true, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			layerFrontLayer = addTilemap( CSV_FrontLayer, Img_FrontLayer, 1920.000, 0.000, 32, 32, 1.000, 1.000, false, 1, 1, properties, onAddCallback );

			//Add layers to the master group in correct order.
			masterLayer.add(layerBackground);
			masterLayer.add(layerBackLayer);
			masterLayer.add(layerPlayerLayer);
			masterLayer.add(layerFrontLayer);
			masterLayer.add(SpritesGroup);
			masterLayer.add(GravityFieldsGroup);

			if ( addToStage )
				createObjects(onAddCallback, parentObject);

			boundsMinX = 1920;
			boundsMinY = 0;
			boundsMaxX = 2560;
			boundsMaxY = 512;
			boundsMin = new FlxPoint(1920, 0);
			boundsMax = new FlxPoint(2560, 512);
			bgColor = 0xff99cccc;
		}

		override public function createObjects(onAddCallback:Function = null, parentObject:Object = null):void
		{
			addShapesForLayerGravityFields(onAddCallback);
			addSpritesForLayerSprites(onAddCallback);
			generateObjectLinks(onAddCallback);
			if ( parentObject != null )
				parentObject.add(masterLayer);
			else
				FlxG.state.add(masterLayer);
		}

		public function addShapesForLayerGravityFields(onAddCallback:Function = null):void
		{
			var obj:Object;

			obj = new BoxData(2009.000, 120.000, 0.000, 150.000, 150.000, GravityFieldsGroup );
			shapes.push(obj);
			callbackNewData( obj, onAddCallback, GravityFieldsGroup, generateProperties( { name:"gravityx", value:0 }, { name:"gravityy", value:-11 }, null ), 1, 1 );
		}

		public function addSpritesForLayerSprites(onAddCallback:Function = null):void
		{
			addSpriteToLayer(new PolygonBody(2336.000, 96.000, Assets.SquareRock2, 4, 2500), PolygonBody, SpritesGroup , 2336.000, 96.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"SquareRock2"
			addSpriteToLayer(new PolygonBody(2304.000, 224.000, Assets.SquareRock2, 4, 2500), PolygonBody, SpritesGroup , 2304.000, 224.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"SquareRock2"
			addSpriteToLayer(new BreakableWall(1952.000, 160.000, Assets.BreakableWall1, 7000), BreakableWall, SpritesGroup , 1952.000, 160.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( null ), onAddCallback );//"BreakableWall1"
			addSpriteToLayer(new PolygonBody(2304.000, 256.000, Assets.SquareRock2, 4, 2500), PolygonBody, SpritesGroup , 2304.000, 256.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"SquareRock2"
			linkedObjectDictionary[1] = addSpriteToLayer(new Exit(2368.000, 256.000, Assets.Exit), Exit, SpritesGroup , 2368.000, 256.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"sensor", value:true }, { name:"enabled", value:false }, null ), onAddCallback );//"Exit"
			addSpriteToLayer(new PolygonBody(2304.000, 288.000, Assets.SquareRock2, 4, 2500), PolygonBody, SpritesGroup , 2304.000, 288.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"SquareRock2"
			addSpriteToLayer(new PolygonBody(2398.000, 257.000, Assets.ForestBoulderLarge, 10, 2000), PolygonBody, SpritesGroup , 2398.000, 257.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"ForestBoulderLarge"
			linkedObjectDictionary[2] = addSpriteToLayer(new WeightSwitch(2124.000, 440.000, Assets.Switch1, 1000), WeightSwitch, SpritesGroup , 2124.000, 440.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( null ), onAddCallback );//"Switch1"
			linkedObjectDictionary[0] = addSpriteToLayer(new WeightSwitch(2208.000, 440.000, Assets.Switch1, 1000), WeightSwitch, SpritesGroup , 2208.000, 440.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( null ), onAddCallback );//"Switch1"
			addSpriteToLayer(null, Player, SpritesGroup , 1920.000, 400.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"Player"
			addSpriteToLayer(new PolygonBody(2016.000, 384.000, Assets.ForestBoulderLarge, 10, 2000), PolygonBody, SpritesGroup , 2016.000, 384.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"ForestBoulderLarge"
		}

		public function generateObjectLinks(onAddCallback:Function = null):void
		{
			createLink(linkedObjectDictionary[0], linkedObjectDictionary[1], onAddCallback, generateProperties( { name:"onActivate", value:"ENABLE" }, null ) );
			createLink(linkedObjectDictionary[0], linkedObjectDictionary[2], onAddCallback, generateProperties( { name:"require", value:"AND" }, null ) );
		}

	}
}
