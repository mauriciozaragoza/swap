package org.dinosaurriders.swap.physics {
	import Box2D.Common.Math.b2Vec2;

	import org.dinosaurriders.swap.Settings;
	import org.flixel.FlxTilemap;
	/**
	 * @author Drakaen
	 */
	public class TilemapGroupSolver {
		private var vertices : Array;
		private var visited : Array;
		private var tilemap : FlxTilemap;
		private var properties : Array;
		private var tag : Object;
		private var offsetX : Number, offsetY : Number;
		
		public function TilemapGroupSolver() {
			vertices = new Array();		
		}
		
		public function groupByTag(tag : Object) : Array {
			this.tag = tag;
			var i : int, j : int;
			
			visited = new Array();			
			for (i = 0; i < tilemap.heightInTiles; i++) {
				visited[i] = new Array();
				for (j = 0; j < tilemap.widthInTiles; j++) {
					visited[i][j] = false;
				}
			}
			
			for (i = 0; i < tilemap.heightInTiles; i++) {
				for (j = 0; j < tilemap.widthInTiles; j++) {
					if (!visited[i][j]) {
						
					}
				}
			}
			
			return vertices;
		}
		
		private function solveGroup(x : Number, y : Number) : Boolean {
			if (x < 0 || y < 0 || 
				x >= tilemap.widthInTiles || y >= tilemap.heightInTiles) {
				return false;
			}
			else if (!visited[y][x] && properties[tilemap.getTile(x, y)] == tag) {
				var neighbors : Array = new Array();
				
				// recursion must go up left down right
				
				neighbors[4] = false;
				neighbors[1] = solveGroup(x, y - 1);
				neighbors[0] = solveGroup(x - 1, y - 1);
				neighbors[3] = solveGroup(x - 1, y);
				neighbors[6] = solveGroup(x - 1, y + 1);
				neighbors[7] = solveGroup(x, y + 1);
				neighbors[8] = solveGroup(x + 1, y + 1);
				neighbors[5] = solveGroup(x + 1, y);
				neighbors[2] = solveGroup(x + 1, y - 1);
				
				if (!neighbors[0] && !neighbors[1]) 
					vertices.push(new b2Vec2(offsetX + Settings.TILESIZE * x, offsetY + Settings.TILESIZE + y));
				if (!neighbors[1] && !neighbors[2]) 
					vertices.push(new b2Vec2(offsetX + Settings.TILESIZE * (x + 1), offsetY + Settings.TILESIZE + y));
				if (!neighbors[3] && !neighbors[7]) 
					vertices.push(new b2Vec2(offsetX + Settings.TILESIZE * x, offsetY + Settings.TILESIZE + (y + 1)));
				if (!neighbors[5] && !neighbors[7]) 
					vertices.push(new b2Vec2(offsetX + Settings.TILESIZE * (x + 1), offsetY + Settings.TILESIZE + (y + 1)));
			}
			
			//solveGroup(x - 1, y, tag);
			
			return properties[tilemap.getTile(x, y)] == tag;
		}
	}
}
