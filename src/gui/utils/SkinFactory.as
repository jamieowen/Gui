package gui.utils
{
	/**
	* Manages skin creation and mapping.
	* 
	* @author jamieowen
	*/
	public class SkinFactory 
	{
		private var _mappings:Vector.<SkinFactoryMapping>;
		
		// store matched skin names to an object for quick retrieval
		private var _matchCache:Object;
		
		/**
		* Creates a new Skin Factory.
		*/
		public function SkinFactory()
		{
			_mappings = new Vector.<SkinFactoryMapping>();
			_matchCache = {};
		}
		
		/**
		* Registers a <code>IGuiObjectSkin</code> when a given pattern for a skin name is matched.
		* 
		* @param $pattern The pattern or comma-seperated patterns of the skin name to match.
		* @param $cls The <code>IGuiObjectSkin</code> to create when matching this pattern
		* @param $initObject The object properties to pass to this <code>IGuiObjectSkin</code> when reusing.
		* @param $constructArgs Constructor arguments passed in on instantiation, initObjects are still set after.
		*/
		public function register($pattern:String,$cls:Class,$initObject:Object=null,$constructArgs:Array=null):void
		{
			if( $pattern.indexOf(",") == -1 )
				_mappings.push( new SkinFactoryMapping($pattern, $cls, $initObject, $constructArgs ) );
			else
			{
				var mappings:Array = $pattern.split(",");
				var i:int = 0;
				var l:int = mappings.length;
				while(i<l)
					_mappings.push( new SkinFactoryMapping(mappings[i++], $cls, $initObject, $constructArgs ) );
				
			}	
		}
		
		/**
		* Unregisters a pattern
		*
		* @param $pattern The pattern already registered
		* @param $cls The class that was registered
		*/
		public function unregister($pattern:String,$cls:Class):void
		{
			
		}
		
		/**
		* Returns a Class that matches the pattern that has been registered.
		* 
		* @param $pattern The skin class matching to return.
		* @return The matching class for this pattern. Null if no match.
		*/
		public function match($pattern:String):SkinFactoryMapping
		{
			var i:int = 0;
			var l:int = _mappings.length;
			var mapping:SkinFactoryMapping;
			
			// list.listItem - matches list.listItem and anything.list.listItem
			// listItem - matches l
			
			while(i<l && mapping == null )
			{  
				mapping = _mappings[i++];
				if( mapping.skin != $pattern ) mapping = null;
			}
			
			return mapping;
		}
	}
}
