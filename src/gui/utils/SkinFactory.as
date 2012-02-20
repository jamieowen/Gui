package gui.utils
{
	import gui.render.IGuiObjectSkin;
	/**
	* The SkinFactory enables mapping of the <code>skin</code> property of a <code>GuiObject</code> to
	* a specific <code>IGuiObjectSkin</code> class.  
	* 
	* It is used during rendering by <code>GuiObjectRenderer</code> objects and all instances of <code>GuiObjectRenderer</code>
	* should contain one.
	* 
	* It enables creation of the <code>IGuiObjectSkin</code> objects by specifying a <code>skin</code> name and manages 
	* created instances and cache limits.  <code>IGuiObjectSkin</code> created should be disposed through this class as well.
	* 
	* @author jamieowen
	*/
	public class SkinFactory 
	{
		// store all mappings
		private var _mappings:Vector.<SkinFactoryMapping>;
		
		// store matched skin names to an object for quick retrieval - this will be called each frame when rendering.
		private var _matchCache:Object;
		
		/**
		 * @return The total number of mappings registered. 
		 */
		public function get numMappings():uint
		{
			return _mappings.length;
		}
		
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
			var mapping:SkinFactoryMapping;
			if( $pattern.indexOf(",") == -1 )
			{
				mapping = new SkinFactoryMapping($pattern, $cls, $initObject, $constructArgs );
				if( mapping.pattern == "*" ) _matchCache["*"] = mapping; // store the default.
				_mappings.push( mapping );
			}else
			{
				var mappings:Array = $pattern.split(",");
				var i:int = 0;
				var l:int = mappings.length;
				while(i<l)
				{
					mapping = new SkinFactoryMapping(mappings[i++], $cls, $initObject, $constructArgs );
					if( mapping.pattern == "*" ) _matchCache["*"] = mapping; // store the default.
					_mappings.push( mapping );
				}
			}
			
			// sort mappings from high to low nestedDepth 
			_mappings.sort( 
				function( $x:SkinFactoryMapping, $y:SkinFactoryMapping):int 
				{
					if( $x.nestedDepth < $y.nestedDepth )
						return 1; 
					else if( $x.nestedDepth > $y.nestedDepth ) 
						return -1; 
					else return 0; 
				} );
		}
		
		/**
		* Unregisters a pattern
		*
		* @param $pattern The pattern or patterns already registered
		* @param $cls The class that was registered
		* 
		*/
		public function unregister($pattern:String):void
		{
			var patterns:Array = $pattern.split(",");
			
			var mapping:SkinFactoryMapping;
			var i:int = 0;
			var f:Boolean = false;
			var l:int;
			var pattern:String;
			while(patterns.length) 
			{
				i = 0;
				l = _mappings.length;
				f = false;
				pattern = patterns.pop();
				while( i<l && !f )
				{
					mapping = _mappings[i];
					if( mapping.pattern == pattern )
					{
						f = true;
						_mappings.splice(i,1);
						if( _matchCache[mapping.pattern] != null ) {
							_matchCache[mapping.pattern] = null;
							delete _matchCache[mapping.pattern];
						}
						mapping.dispose();
					}
					i++;
				}
			}
		}
		
		/**
		 * Unregisters all skin mappings.
		 */
		public function unregisterAll():void
		{
			while( _mappings.length )
				unregister( _mappings[0].pattern );
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
			
			mapping = _matchCache[$pattern];
			if( mapping != null ) return mapping; // return if found in cache
			
			// list.listItem - matches list.listItem and anything.list.listItem
			// listItem - matches l
			
			var patternDepth:uint = $pattern.split(".").length;
			var matched:Boolean = false;
			var regExp:RegExp;

			while(i<l && matched==false )
			{  
				mapping = _mappings[i++];
				 
				// skip invalid depths - the match pattern "button" does not need to test against "list.button" or "list.subItem.button" 
				if( patternDepth >= mapping.nestedDepth )
				{
					matched = false;
					regExp = new RegExp(mapping.pattern + "$", "g");
					matched = $pattern.match(regExp).length != 0;
				}	
			}
			
			if( !matched )
			{
				return _matchCache["*"]; // return the default if we have it.
			}else
			{
				// store the matched pattern
				_matchCache[ mapping.pattern ] = mapping;
				return mapping;
			}
		}
		
		/**
		* Creates an object from a specified skin pattern.
		*
		* @param The pattern / skin name from the <code>GuiObject</code>
		* @return The instantiated or cached <code>IGuiObjectSkin</code> for use.
		*/
		public function create($pattern:String):IGuiObjectSkin
		{
			var mapping:SkinFactoryMapping = match( $pattern );
						
			return null;
		}
	}
}
