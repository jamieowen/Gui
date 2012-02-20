package gui.utils
{
	/**
	* Mapping object for <code>SkinFactory</code>
	*
	* @author jamieowen
	*/
	public class SkinFactoryMapping 
	{
		public var pattern:String;
		public var cls:Class;
		public var init:Object;
		public var construct:Array;
		
		public var nestedDepth:uint;
	
		
		/**
		* SkinFactory Mapping Helper
		*/
		public function SkinFactoryMapping( $pattern:String, $class:Class, $init:Object = null, $construct:Array = null )
		{
			super();
			
			pattern 	= $pattern;
			cls  		= $class;
			init 		= $init;
			construct 	= $construct;
			
			nestedDepth = pattern.split(".").length;
		}
		
		public function dispose():void
		{
			cls = null;
			init = null;
			if( construct ) construct.splice(0);
			construct = null;
		}
	}
}