package rooms 
{
	import flash.utils.ByteArray;
	import net.flashpunk.World;
	
	/** A level with the ability to load XML files. */
	public class LevelLoader extends World
	{
		/** The loading XML file describing the level. */
		public var level:XML;
		
		/**
		 * Constructor
		 * @param	source The XML source of the level.
		 */
		public function LevelLoader(source:Class) 
		{
			// Convert the source XML into a ByteArray
			var file:ByteArray = new source;
			
			// Read the ByteArray and convert it to an XML Object for parsing by children.
			level = XML(file.readUTFBytes(file.length));
		}
	}
}
