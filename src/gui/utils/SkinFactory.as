package gui.utils
{
	import flash.utils.Dictionary;
	import gui.core.objects.GuiObject;
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
		
		// store matched skin names to class definitions in an object for quick retrieval - this will be called each frame when rendering.
		private var _matchCache:Object;
		
		// creates and disposes of instances whilst maintaining cache limits.
		private var _instanceCache:Cache;
		
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
			_instanceCache = new Cache();
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
			// TODO This is not good here - v. slow on UnitTest SkinfactoryTest. But rarely will we be registering/unregistering.
			// Other option is to manually call sort() after each bulk register...
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
			if( mapping != null ) 
			{
				if( mapping.pattern == "*" )
					trace( "[SkinFactory] No skin found for pattern : " + $pattern + ". Default skin ('*') used instead." );
				return mapping; // return if found in cache
			}
			
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
				trace( "[SkinFactory] No skin found for pattern : " + $pattern + ". Default skin ('*') used instead." );
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
		public function create($pattern:String ):IGuiObjectSkin
		{
			var mapping:SkinFactoryMapping = match( $pattern );
			if( mapping ) return _instanceCache.create(mapping.cls, mapping.init, mapping.construct );
			else throw new Error("No skin found for pattern :" + $pattern );
		}
		
		/**
		 * Disposes of a skin.  This does not mean that the IGuiObjectSkin's <code>dispose()</code>
		 * method is called straight away - The skin is cached for future use first.  If the 
		 * cache exceeds the cache limit for that class the <code>dispose()</code> method is called and
		 * the instance is released for garbage collection.
		 */
		public function dispose($obj:IGuiObjectSkin):void
		{
			_instanceCache.dispose($obj);
		}
		
		/**
		 * Sets the cache limit for a class.
		 */
		public function setCacheLimit( $cls:Class, $max:uint = uint.MAX_VALUE ):void
		{
			_instanceCache.setLimit( $cls, $max );
		}
		
		/**
	 	* Clears the cache of all cache related data.
	 	*/
		public function disposeAllCache():void
		{
			_instanceCache.disposeAllCache();
		}
	
		/**
		 * Clears all cache data for a specific class.
		 */
		public function disposeCache( $cls:Class ):void
		{
			_instanceCache.disposeCache($cls);
		}
	}
}
import avmplus.getQualifiedClassName;
import flash.utils.getDefinitionByName;
import gui.render.IGuiObjectSkin;
import flash.utils.Dictionary;


/**
* Caches the instances disposed by the SkinFactory.  The number of cached instances
* are controlled by the cache min and max limits.
* 
* Items are only cached after disposing.  Instances created 
*
* @author jamieowen
*/
internal class Cache
{
	// stores cached items by class type.
	private var _cacheByClass:Dictionary;
	
	/**
	* Class Constructor Description
	*/
	public function Cache()
	{
		_cacheByClass = new Dictionary(true);
	}
	
	/**
	 * Creates an object or retrieves it from cache.
	 * A newly instantiated instance also has any supplied init object applied to it as well.
	 */
	public function create($cls:Class, $init:Object, $args:Array ):IGuiObjectSkin
	{
		var cacheItem:CacheItem = _cacheByClass[$cls];
		var skin:IGuiObjectSkin;
		if( cacheItem && cacheItem.instances.length )
		{
			return reinit(cacheItem.instances.shift(), $init);
		}else
		{
			skin = instantiate( $cls, $args);
			return reinit(skin, $init);
		}
	}
	
	/**
	 * Disposes of a IGuiObjectSkin.
	 */
	public function dispose( $obj:IGuiObjectSkin ):void
	{
		var cls:Class = getDefinitionByName( getQualifiedClassName($obj)) as Class;
		var cacheItem:CacheItem = _cacheByClass[cls];
		if( cacheItem == null )
		{
			// we have not encountered this class before so create the entry.
			cacheItem = new CacheItem(cls);
			_cacheByClass[cls] = cacheItem;
		}
		
		if( cacheItem.instances.length < cacheItem.cacheMax )
			cacheItem.instances.push( $obj );
		else{
			//trace( "Skin Disposed. Check cache limit.");
			$obj.dispose();
		}
	}
	
	/**
	 * Reinits a cached instance.
	 */
	private static function reinit( $instance:IGuiObjectSkin, $init:Object ):IGuiObjectSkin
	{
		for( var s:String in $init )
			$instance[s] = $init[s];
		return $instance;
	}
	
	/**
	 * Instantiates a class with the given arguments.
	 */
	private static function instantiate( $class:Class, $args:Array ):IGuiObjectSkin
	{
		if( $args == null || $args.length == 0 )
		{
			return new $class();
		}else
		{
			switch( $args.length )
			{
				case 1 : return new $class($args[0]); break;
				case 2 : return new $class($args[0],$args[1]); break;
				case 3 : return new $class($args[0],$args[1],$args[2]); break;
				case 4 : return new $class($args[0],$args[1],$args[2],$args[3]); break;
				case 5 : return new $class($args[0],$args[1],$args[2],$args[3],$args[4]); break;
				case 6 : return new $class($args[0],$args[1],$args[2],$args[3],$args[4],$args[5]); break;
				case 7 : return new $class($args[0],$args[1],$args[2],$args[3],$args[4],$args[5],$args[6]); break;
				case 8 : return new $class($args[0],$args[1],$args[2],$args[3],$args[4],$args[5],$args[6],$args[7]); break;
				case 9 : return new $class($args[0],$args[1],$args[2],$args[3],$args[4],$args[5],$args[6],$args[7],$args[8]); break;
				case 10: return new $class($args[0],$args[1],$args[2],$args[3],$args[4],$args[5],$args[6],$args[7],$args[8],$args[9]); break;
					
				default: 
					return null;
			}
		}
		return null;
	}
	
	/**
	 * Sets the max limit for a class.
	 * When a class instance is passed to dispose(), if the current
	 * number of instances plus the additional instance is greater
	 * than the cache limit, the additional instance's <code>dispose()</code> method is called
	 * and is not stored in cache.
	 */
	public function setLimit( $cls:Class, $max:uint = uint.MAX_VALUE ):void
	{
		var cacheItem:CacheItem = _cacheByClass[$cls];
		if( cacheItem )
			cacheItem.cacheMax = $max;
		else
			_cacheByClass[$cls] = new CacheItem($cls,$max);
	}
	
	/**
	 * Clears the cache of all cache related data.
	 */
	public function disposeAllCache():void
	{
		for( var key:Object in _cacheByClass )
			disposeCache( key as Class );
	}
	
	/**
	 * Clears all cache data for a specific class.
	 */
	public function disposeCache( $cls:Class ):void
	{
		var cacheItem:CacheItem = _cacheByClass[$cls];
		if( cacheItem )
		{
			var skin:IGuiObjectSkin;
			while( cacheItem.instances.length )
			{
				skin = cacheItem.instances.pop();
				skin.dispose();
			}
			cacheItem.dispose();
			_cacheByClass[$cls]=null;
			delete _cacheByClass[$cls];
		}
	}
		
}

/**
 * 
 */
class CacheItem
{
	public var cls:Class;
	public var instances:Vector.<IGuiObjectSkin>;
	public var cacheMax:uint;
	
	public function CacheItem($cls:Class, $cacheMax:uint = uint.MAX_VALUE )
	{
		instances 	= new Vector.<IGuiObjectSkin>();
		cls 	 	= $cls;
		cacheMax 	= $cacheMax;
	}
	
	public function dispose():void
	{
		cls = null;
		instances.splice(0, uint.MAX_VALUE);
		instances = null;
	}
}


