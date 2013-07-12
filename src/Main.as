package
{
	import net.flashpunk.*;
	import rooms.*;
	
	/** Main game class. */
	public class Main extends Engine
	{
		/** Constructor. Start the game and set the starting world. */
		public function Main() 
		{
			// Specify the size of the game (640x480) and the framerate (60 fps.)
			super(640, 480, 60);
			
			// Assign the game world to an instance of Level.
			FP.world = new Level;
		}
	}
}
