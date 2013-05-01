//Code generated with DAME. http://www.dambots.com

package org.dinosaurriders.swap.levels
{
	import org.flixel.*;
	import flash.utils.Dictionary;
	// Custom imports:
import org.dinosaurriders.swap.*;import org.dinosaurriders.swap.objects.*;
	public class Level_Level15 extends BaseLevel
	{
		//Embedded media...
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level15_Sky.csv", mimeType="application/octet-stream")] public var CSV_Sky:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_Sky:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level15_Background.csv", mimeType="application/octet-stream")] public var CSV_Background:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_Background:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level15_BlackSpaceLayer.csv", mimeType="application/octet-stream")] public var CSV_BlackSpaceLayer:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_BlackSpaceLayer:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level15_Stars2.csv", mimeType="application/octet-stream")] public var CSV_Stars2:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_Stars2:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level15_Stars1.csv", mimeType="application/octet-stream")] public var CSV_Stars1:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_Stars1:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level15_GlowLayer.csv", mimeType="application/octet-stream")] public var CSV_GlowLayer:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_GlowLayer:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level15_PlayerLayer.csv", mimeType="application/octet-stream")] public var CSV_PlayerLayer:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_PlayerLayer:Class;
		[Embed(source="../../../../../assets/worlds/maps/mapCSV_Level15_FrontLayer.csv", mimeType="application/octet-stream")] public var CSV_FrontLayer:Class;
		[Embed(source="../../../../../assets/spritesheet1.png")] public var Img_FrontLayer:Class;

		//Tilemaps
		public var layerSky:FlxTilemap;
		public var layerBackground:FlxTilemap;
		public var layerBlackSpaceLayer:FlxTilemap;
		public var layerStars2:FlxTilemap;
		public var layerStars1:FlxTilemap;
		public var layerGlowLayer:FlxTilemap;
		public var layerPlayerLayer:FlxTilemap;
		public var layerFrontLayer:FlxTilemap;

		//Sprites
		public var SpritesGroup:FlxGroup = new FlxGroup;

		//Shapes
		public var PropertyFieldsGroup:FlxGroup = new FlxGroup;

		//Properties


		public function Level_Level15(addToStage:Boolean = true, onAddCallback:Function = null, parentObject:Object = null)
		{
			// Generate maps.
			var properties:Array = [];
			var tileProperties:Dictionary = new Dictionary;

			properties = generateProperties( null );
			tileProperties[1]=generateProperties( { name:"affectsplayer", value:false }, null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[15]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[61]=generateProperties( { name:"outerglow", value:65280 }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerSky = addTilemap( CSV_Sky, Img_Sky, 0.000, 0.000, 32, 32, 0.250, 0.250, false, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			tileProperties[1]=generateProperties( { name:"affectsplayer", value:false }, null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[15]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[61]=generateProperties( { name:"outerglow", value:65280 }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerBackground = addTilemap( CSV_Background, Img_Background, 0.000, 0.000, 32, 32, 0.500, 0.500, false, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			tileProperties[1]=generateProperties( { name:"affectsplayer", value:false }, null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[15]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[61]=generateProperties( { name:"outerglow", value:65280 }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerBlackSpaceLayer = addTilemap( CSV_BlackSpaceLayer, Img_BlackSpaceLayer, 896.000, -64.000, 32, 32, 1.000, 1.000, false, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			tileProperties[1]=generateProperties( { name:"affectsplayer", value:false }, null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[15]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[61]=generateProperties( { name:"outerglow", value:65280 }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerStars2 = addTilemap( CSV_Stars2, Img_Stars2, 800.000, -192.000, 32, 32, 0.250, 0.250, false, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			tileProperties[1]=generateProperties( { name:"affectsplayer", value:false }, null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[15]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[61]=generateProperties( { name:"outerglow", value:65280 }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerStars1 = addTilemap( CSV_Stars1, Img_Stars1, 896.000, -64.000, 32, 32, 0.500, 0.500, false, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			tileProperties[1]=generateProperties( { name:"affectsplayer", value:false }, null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[15]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[61]=generateProperties( { name:"outerglow", value:65280 }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerGlowLayer = addTilemap( CSV_GlowLayer, Img_GlowLayer, 1632.000, 448.000, 32, 32, 1.000, 1.000, false, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			tileProperties[1]=generateProperties( { name:"affectsplayer", value:false }, null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[15]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[61]=generateProperties( { name:"outerglow", value:65280 }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerPlayerLayer = addTilemap( CSV_PlayerLayer, Img_PlayerLayer, 0.000, 0.000, 32, 32, 1.000, 1.000, true, 1, 1, properties, onAddCallback );
			properties = generateProperties( null );
			tileProperties[1]=generateProperties( { name:"affectsplayer", value:false }, null );
			tileProperties[14]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[15]=generateProperties( { name:"kills", value:true }, null );
			tileProperties[61]=generateProperties( { name:"outerglow", value:65280 }, null );
			properties.push( { name:"%DAME_tiledata%", value:tileProperties } );
			layerFrontLayer = addTilemap( CSV_FrontLayer, Img_FrontLayer, 0.000, 0.000, 32, 32, 1.000, 1.000, false, 1, 1, properties, onAddCallback );

			//Add layers to the master group in correct order.
			masterLayer.add(layerSky);
			masterLayer.add(layerBackground);
			masterLayer.add(layerBlackSpaceLayer);
			masterLayer.add(layerStars2);
			masterLayer.add(layerStars1);
			masterLayer.add(layerGlowLayer);
			masterLayer.add(layerPlayerLayer);
			masterLayer.add(layerFrontLayer);
			masterLayer.add(PropertyFieldsGroup);
			masterLayer.add(SpritesGroup);

			if ( addToStage )
				createObjects(onAddCallback, parentObject);

			boundsMinX = 0;
			boundsMinY = -64;
			boundsMaxX = 4096;
			boundsMaxY = 960;
			boundsMin = new FlxPoint(0, -64);
			boundsMax = new FlxPoint(4096, 960);
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

			obj = new BoxData(894.000, 420.700, 0.000, 3050.000, 124.980, PropertyFieldsGroup );
			shapes.push(obj);
			callbackNewData( obj, onAddCallback, PropertyFieldsGroup, generateProperties( { name:"onlyPlayer", value:true }, { name:"blur", value:true }, null ), 1, 1 );
		}

		public function addSpritesForLayerSprites(onAddCallback:Function = null):void
		{
			addSpriteToLayer(null, Player, SpritesGroup , 360.000, 180.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"Player"
			addSpriteToLayer(new BreakableWall(448.000, 288.000, Assets.BreakableWall1, Assets.ForestBoulderLarge, 7000), BreakableWall, SpritesGroup , 448.000, 288.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( null ), onAddCallback );//"BreakableWall1"
			addSpriteToLayer(new PolygonBody(159.000, 384.000, Assets.ForestBoulderLarge, 12, 2000), PolygonBody, SpritesGroup , 159.000, 384.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"ForestBoulderLarge"
			addSpriteToLayer(new Exit(3870.000, 480.000, Assets.Exit), Exit, SpritesGroup , 3870.000, 480.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"sensor", value:true }, { name:"warp", value:"Level16" }, null ), onAddCallback );//"Exit"
			addSpriteToLayer(new PolygonBody(64.000, 864.000, Assets.SquareRock2, 4, 2500), PolygonBody, SpritesGroup , 64.000, 864.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"SquareRock2"
			addSpriteToLayer(new PolygonBody(96.000, 864.000, Assets.SquareRock2, 4, 2500), PolygonBody, SpritesGroup , 96.000, 864.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"SquareRock2"
			addSpriteToLayer(new PolygonBody(128.000, 864.000, Assets.SquareRock2, 4, 2500), PolygonBody, SpritesGroup , 128.000, 864.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"SquareRock2"
			addSpriteToLayer(new PolygonBody(160.000, 864.000, Assets.SquareRock2, 4, 2500), PolygonBody, SpritesGroup , 160.000, 864.000, 0.000, 1, 1, false, 1.000, 1.000, generateProperties( { name:"swappable", value:true }, null ), onAddCallback );//"SquareRock2"
		}

		public function generateObjectLinks(onAddCallback:Function = null):void
		{
		}

	}
}
