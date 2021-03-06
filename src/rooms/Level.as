package rooms 
{
	import game.Background;
	import game.Floors;
	import game.Particles;
	import game.Player;
	import net.flashpunk.FP;
	
	public class Level extends LevelLoader
	{
		/** Level XML. */
		[Embed(source = '../../level/level.oel', mimeType = 'application/octet-stream')] private static const LEVEL:Class;
		
		/** Camera following information. */
		public const FOLLOW_TRAIL:Number = 50;
		public const FOLLOW_RATE:Number = .9;
		
		/** Size of the level (so it knows where to keep the player + camera in). */
		public var width:uint;
		public var height:uint;
		public var player:Player;
		
		/** Constructor. */
		public function Level()
		{
			// Pass the level data to the superclass for loading.
			super(LEVEL);
			
			// Read the level dimensions from the level.
			width = level.width;
			height = level.height;
			
			// Add entities for floors, the cool particles and sweet backgrounds.
			add(new Floors(level));
			add(new Particles);
			add(new Background);
			
			// Get all the players (there should only be one).
			for each (var p:XML in level.objects[0].player)
			{
				// Create the player and add it to the level.
				player = new Player(p.@x, p.@y);
				add(player);
			}
		}
		
		/** Update the level. */
		override public function update():void 
		{
			// update entities
			super.update();
			
			// camera following
			cameraFollow();
		}
		
		/** Makes the camera follow the player object. */
		private function cameraFollow():void
		{
			// make camera follow the player
			FP.point.x = FP.camera.x - targetX;
			FP.point.y = FP.camera.y - targetY;
			var dist:Number = FP.point.length;
			if (dist > FOLLOW_TRAIL) dist = FOLLOW_TRAIL;
			FP.point.normalize(dist * FOLLOW_RATE);
			FP.camera.x = int(targetX + FP.point.x);
			FP.camera.y = int(targetY + FP.point.y);
			
			// keep camera in room bounds
			FP.camera.x = FP.clamp(FP.camera.x, 0, width - FP.width);
			FP.camera.y = FP.clamp(FP.camera.y, 0, height - FP.height);
		}
		
		/** The player's X location. */
		private function get targetX():Number { return player.x - FP.width / 2; }
		
		/** The player's Y location. */
		private function get targetY():Number { return player.y - FP.height / 2; }
	}
}
