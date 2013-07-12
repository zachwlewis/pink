package game
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	/** Floors entity that contains the collision grid. */
	public class Floors extends Entity
	{
		/** Embed the tileset graphic. */
		[Embed(source = '../../assets/tiles.png')] private static const TILES:Class;
		
		/** The image for the floors. */
		public var tiles:Tilemap;
		
		/** The collision for the floors. */
		public var grid:Grid;
		
		/** Constructor. Load the floors from the level XML. */
		public function Floors(level:XML) 
		{
			// set entity type
			type = "solid";
			
			// create and populate the tilemap from the level XML
			graphic = tiles = new Tilemap(TILES, level.width, level.height, 16, 16);
			for each (var tile:XML in level.tiles[0].tile)
			{
				tiles.setTile(tile.@x / 16, tile.@y / 16, tiles.getIndex(tile.@tx / 16, tile.@ty / 16));
			}
			
			// create and populate the collision grid mask from the level XML
			mask = grid = new Grid(level.width, level.height, 16, 16);
			for each (var solid:XML in level.solid[0].rect)
			{
				grid.setRect(solid.@x / 16, solid.@y / 16, solid.@w / 16, solid.@h / 16);
			}
		}
	}
}
