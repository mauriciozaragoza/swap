//Code generated with DAME. http://www.dambots.com

package org.dinosaurriders.swap.levels
{
	import org.flixel.*;
	import flash.utils.Dictionary;
	// Custom imports:
import org.dinosaurriders.swap.*;import org.dinosaurriders.swap.objects.*;
	public class Level_Level6 extends BaseLevel
	{
		//Embedded media...
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level6_Sky.csv", mimeType="application/octet-stream")] public var CSV_Sky:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_Sky:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level6_PlayerLayer.csv", mimeType="application/octet-stream")] public var CSV_PlayerLayer:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_PlayerLayer:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level6_FrontLayer.csv", mimeType="application/octet-stream")] public var CSV_FrontLayer:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_FrontLayer:Class;

		//Tilemaps
		public var layerSky:FlxTilemap;
		public var layerPlayerLayer:FlxTilemap;
		public var layerFrontLayer:FlxTilemap;

		//Sprites
		public var SpritesGroup:FlxGroup = new FlxGroup;

		//Shapes
		public var PropertyFieldsGroup:FlxGroup = new FlxGroup;

		//Properties


		public function Level_Level6(addToStage:Boolean = true, onAddCallback:Function = null, parentObject:Object = null)
		{
			// Generate maps.
			var properties:Array = [];
			var tileProperties:Dictionary = new Dictionary;

			properties = generateProperties( null );
			tileProperties[1]=generateProperties( { name:"affectsplayer", value:false }, null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerSky = addTilemap( CSV_Sky, Img_Sky, 0.000, 128.000, 32, 32, 0.250, 0.250, false, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			tileProperties[1]=generateProperties( { name:"affectsplayer", value:false }, null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerPlayerLayer = addTilemap( CSV_PlayerLayer, Img_PlayerLayer, 1280.000, 0.000, 32, 32, 1.000, 1.000, true, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			tileProperties[1]=generateProperties( { name:"affectsplayer", value:false }, null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerFrontLayer = addTilemap( CSV_FrontLayer, Img_FrontLayer, 1280.000, 0.000, 32, 32, 1.000, 1.000, false, 1, 1, properties, onAddCallback );

			//Add layers to the master group in correct order.
			masterLayer.add(layerSky);
			masterLayer.add(layerPlayerLayer);
			masterLayer.add(layerFrontLayer);
			masterLayer.add(SpritesGroup);
			masterLayer.add(PropertyFieldsGroup);

			if ( addToStage )
				createObjects(onAddCallback, parentObject);

			boundsMinX = 1280;
			boundsMinY = 0;
			boundsMaxX = 2336;
			boundsMaxY = 800;
			boundsMin = new FlxPoint(1280, 0);
			boundsMax = new FlxPoint(2336, 800);
			bgColor = 0xff88beef;
		}

		override public function createObjects(onAddCallback:Function = null, parentObject:Object = null):void
		{
			addShapesForLayerPropertyFields(onAddCallback);
			addSpritesForLayerSprites(onAddCallback);
			generateObjectLinks(onAddCallback);
			if ( parentObject != null )
				parentObject.add(masterLayer);
			else
				FlxG.state.add(masterLayer);
		}

		public function addShapesForLayerPropertyFields(onAddCallback:Function = null):void
		{
			var obj:Object;

			obj = new BoxData(1470.000, 600.000, 0.000, 690.000, 225.450, PropertyFieldsGroup );
			shapes.push(obj);
			callbackNewData( obj, onAddCallback, PropertyFieldsGroup, generateProperties( { name:"gravityy", value:"-20" }, { name:"affectsplayer", value:false }, null ), 1, 1 );
		}

		public function addSpritesForLayerSprites(onAddCallback:Function = null):void
		{
			linkedObjectDictionary[3] = addSpriteToLayer(new Exit(1408.000, 256.000, Assets.Exit), Exit, SpritesGroup , 1408.000, 256.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"sensor", value:true }, { name:"warp", value:"Level7" }, { name:"enabled", value:false }, null ), onAddCallback );//"Exit"
			linkedObjectDictionary[2] = addSpriteToLayer(new WeightSwitch(2176.000, 312.000, Assets.Switch1, 1000), WeightSwitch, SpritesGroup , 2176.000, 312.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( null ), onAddCallback );//"Switch1"
			addSpriteToLayer(new PolygonBody(1545.000, 298.000, Assets.SquareRock2, 4, 2500), PolygonBody, SpritesGroup , 1545.000, 298.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, { name:"fixedrotation", value:true }, null ), onAddCallback );//"SquareRock2"
			addSpriteToLayer(null, Player, SpritesGroup , 1312.000, 288.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"Player"
			addSpriteToLayer(new PolygonBody(1530.000, 330.000, Assets.SquareRock1, 4, 2000), PolygonBody, SpritesGroup , 1530.000, 330.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:false }, { name:"fixedx", value:true }, { name:"friction", value:1 }, null ), onAddCallback );//"SquareRock1"
			addSpriteToLayer(new PolygonBody(2043.000, 330.000, Assets.SquareRock1, 4, 2000), PolygonBody, SpritesGroup , 2043.000, 330.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:false }, { name:"fixedx", value:true }, null ), onAddCallback );//"SquareRock1"
			addSpriteToLayer(new PolygonBody(1790.000, 333.000, Assets.SquareRock1, 4, 2000), PolygonBody, SpritesGroup , 1790.000, 333.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:false }, { name:"fixedx", value:true }, null ), onAddCallback );//"SquareRock1"
			addSpriteToLayer(new PolygonBody(1920.000, 420.000, Assets.SquareRock1, 4, 2000), PolygonBody, SpritesGroup , 1920.000, 420.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:false }, { name:"fixedx", value:true }, null ), onAddCallback );//"SquareRock1"
			addSpriteToLayer(new PolygonBody(1650.000, 420.000, Assets.SquareRock1, 4, 2000), PolygonBody, SpritesGroup , 1650.000, 420.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:false }, { name:"fixedx", value:true }, null ), onAddCallback );//"SquareRock1"
		}

		public function generateObjectLinks(onAddCallback:Function = null):void
		{
			createLink(linkedObjectDictionary[2], linkedObjectDictionary[3], onAddCallback, generateProperties( { name:"onActivate", value:"ENABLE" }, null ) );
		}

	}
}
