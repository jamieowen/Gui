package gui.core.gestures
{
	import flash.geom.Rectangle;
	import gui.core.objects.GuiObject;
	import gui.gestures.ITapGesture;
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class TapGesture implements IGestureProcessor
	{
		/** Holds the specific delegates that this gesture operates on.**/
		private var _delegates:Vector.<ITapGesture>;
		
		/**
		* Class Constructor Description
		*/
		public function TapGesture()
		{
			_delegates = new Vector.<ITapGesture>();
		}

		/** When a delegate is added to the context - check if this can receive tap events **/
		public function delegateAdded($delegate : IGestureDelegate) : void
		{
			if( $delegate is ITapGesture )
			{
				_delegates.push( $delegate );
			}
		}
		
		/** Removes the delegate from processing **/
		public function delegateRemoved( $delegate:IGestureDelegate ):void
		{
			if( $delegate is ITapGesture )
			{
				var idx:int = _delegates.indexOf($delegate);
				if( idx != -1 )
					_delegates.splice(idx,1);
			}
		}
		
		/** Called every frame **/
		public function update():void
		{
		}
		
		public function dispose():void
		{
			_delegates.splice(0, uint.MAX_VALUE);
			_delegates = null;
		}
		
		public function inputDown($x:Number, $y:Number):void
		{
			
		}
		
		public function inputUp($x:Number, $y:Number):void
		{
			if( _delegates.length )
			{	
				var del:ITapGesture;
				var rect:Rectangle;	
				for( var i:uint = 0; i<_delegates.length; i++ )
				{
					del = _delegates[i];
					rect = ( del as GuiObject ).getGlobalBounds();
					
					if( rect.contains($x, $y) )
						del.onTap();
				}
			}
		}
		
		public function inputMove( $x:Number, $y:Number ):void
		{
			
		}
	
		
	}
}