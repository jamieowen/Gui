package gui.utils
{
	/**
	* Mapping object for <code>SkinFactory</code>
	*
	* @author jamieowen
	*/
	public class SkinFactoryMapping 
	{

		public var skin:String;
		public var cls:Class;
		public var init:Object;
		public var construct:Array;
		
		// the number of parts to th
		public var parts:uint;
		
		/**
		* SkinFactory Mapping Helper
		*/
		public function SkinFactoryMapping( $skin:String, $class:Class, $init:Object = null, $construct:Array = null )
		{
			super();
			
			skin 		= $skin;
			cls  		= $class;
			init 		= $init;
			construct 	= $construct;
		}
	}
}