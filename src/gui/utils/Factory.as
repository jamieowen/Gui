package gui.utils
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	public class Factory
	{
		private var _map:FactoryMap;
		
		private var _disposed:Dictionary;
		
		public function get map():FactoryMap
		{
			return _map;
		}
		
		public function set map( $map:FactoryMap ):void
		{
			_map = $map;
		}
		
		public function Factory( $factoryMap:FactoryMap )
		{
			map = $factoryMap;
			_disposed = new Dictionary(true);
		}
		
		public function create( $data:*, $initObject:Object = null, $instantiateObject:Array = null ):*
		{
			var factoryClass:Class = _map.getFactoryTypeForData( getDefinitionByName( getQualifiedClassName($data) ) as Class );
	
			if( _disposed[ factoryClass ] && _disposed[ factoryClass ].length )
			{
				var item:*;
				item = ( _disposed[ factoryClass ] as Array ).shift();
				for( var s:String in $initObject )
					item[s] = $initObject[s];
				return item;
			}else
				return instantiate( factoryClass, $instantiateObject );
		}
		
		public function dispose( $object:* ):void
		{
			var factoryClass:Class = getDefinitionByName( getQualifiedClassName($object) ) as Class;
			if( _disposed[ factoryClass ] == null )
				_disposed[ factoryClass ] = [ $object ];
			else
				_disposed[ factoryClass ].push( $object );
		}
		
		private static function instantiate( $class:Class, $args:Array ):*
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
	}
}