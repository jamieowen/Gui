package gui.core.gestures
{
	import gui.gestures.ITapGesture;
	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class TapGesture implements IGesture
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

		/** Allows the gesture manager to pass a new gesture delegate to be cec **/
		public function delegateAdded($delegate : IGestureDelegate) : void
		{
			if( $delegate is ITapGesture )
			{
				_delegates.push( $delegate );
			}
		}
		
		public function delegateRemoved( $delegate:IGestureDelegate ):void
		{
			if( $delegate is ITapGesture )
			{
				
			}
		}
		
		/** Called every frame **/
		public function update():void
		{
			
		}
		
		
		public function inputDown($x:Number, $y:Number):void
		{
			
		}
		
		public function inputUp($x:Number, $y:Number):void
		{
			
		}
		
		public function inputMove( $x:Number, $y:Number ):void
		{
			
		}
		
	}
}