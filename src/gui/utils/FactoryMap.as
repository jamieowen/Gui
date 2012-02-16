package gui.utils
{
	import flash.utils.Dictionary;

	public class FactoryMap
	{
		private var _default:Class;
		private var _map:Dictionary;
		
		public function FactoryMap( $default:Class, $dataType:Class = null, $factoryType:Class = null, ...$map)
		{
			_map = new Dictionary(true);
			
			_default = $default;
			
			if( $dataType && $factoryType )
			{
				$map.unshift($factoryType);
				$map.unshift($dataType);
			}
			
			var i:uint = 0;
			var l:uint = $map.length;
			
			// need to add some handling here for argument errors
			while( i<l )
			{
				_map[$map[i]] = $map[i+1];
				i+=2;
			}
		}
		
		public function getFactoryTypeForData( $data:Class, $returnDefaultIfNull:Boolean = true ):Class
		{
			var factoryType:Class = _map[ $data ];
			if( factoryType )
				return factoryType;
			else
			if( $returnDefaultIfNull )
				return _default;
			else
				return null;
		}
	}
}