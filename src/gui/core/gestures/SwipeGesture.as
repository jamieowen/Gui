package gui.core.gestures
{
	import flash.geom.Vector3D;
	import gui.core.objects.GuiObject;
	import flash.geom.Rectangle;
	import gui.gestures.ISwipeGesture;
	import gui.core.gestures.IGestureDelegate;

	/**
	 * Handles swipe processing.
	 * 
	 * A SwipeGesture is a movement in particular direction for a certain length of time.
	 * 
	 * Swipes can be either up, down, left or right.
	 * A single swipe gesture can trigger more than one swipe during the interaction.
	 * E.g. If the user moves from left to right, a swipe right is triggered. If the user keeps the finger
	 * held down and moves back from right to left a swipe left is triggered.  This can be repeated.
	 * 
	 * Unlike the PhysicsSwipe, the Swipe does not provide any physics information to the Delegate.
	 * 
	 * @author jamieowen
	 */
	public class SwipeGesture implements IGestureProcessor
	{
		/** Holds the specific delegates that this gesture operates on.**/
		private var _delegates:Vector.<ISwipeGesture>;
		
		/** Current objects effected by current swipe **/
		private var _processing:Vector.<ISwipeGesture>;
		
		/** Whether we are processing a swipe**/
		private var _process:Boolean;
		
		/** The previous positions of the input **/
		private var _positions:Vector.<Vector3D>;
		
		/** The directional for each position **/
		private var _directions:Vector.<Vector3D>;
		
		/** The minimum amount of information before we can calculate a direction **/
		private var _bufferMinBeforeCalc:uint;
		
		/** The current number of items added to the buffer since input started **/
		private var _bufferCount:uint;
		
		/** left right switch ( 0=not triggered, 1=left, 2=right ) **/
		private var _leftRightSwitch:uint;
		
		/** up down switch ( 0=not triggered, 1=up, 2=down ) **/
		private var _upDownSwitch:uint;
		
		
		/**
		* Class Constructor Description
		*/
		public function SwipeGesture()
		{
			_delegates = new Vector.<ISwipeGesture>();
			_processing = new Vector.<ISwipeGesture>();
			
			_bufferMinBeforeCalc = 5;
			
			var buffer:uint = 5;
			_positions = new Vector.<Vector3D>(buffer);
			_directions = new Vector.<Vector3D>(buffer);
			
			for( var i:uint = 0; i<buffer; i++ )
			{
				_positions[i] = new Vector3D();
				_directions[i] = new Vector3D();
			}
		}

		/** When a delegate is added to the context - check if this can receive tap events **/
		public function delegateAdded($delegate : IGestureDelegate) : void
		{
			if( $delegate is ISwipeGesture )
			{
				_delegates.push( $delegate );
			}
		}
		
		/** Removes the delegate from processing **/
		public function delegateRemoved( $delegate:IGestureDelegate ):void
		{
			if( $delegate is ISwipeGesture )
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
			_process = false;
			
			// get delegates containing input position
			for( var i:uint = 0; i<_delegates.length; i++ )
			{
				var obj:GuiObject = _delegates[i] as GuiObject;
				var rect:Rectangle = obj.getGlobalBounds();
				
				if( rect.contains($x, $y) )
				{
					_processing.push(obj);
					_process = true;
				}
			}
			if( _process )
			{
				clear();
				pushPosition($x, $y);
			}
		}
		
		public function inputUp($x:Number, $y:Number):void
		{
			_processing.splice(0,uint.MAX_VALUE);
			_process = false;
		}
		
		public function inputMove( $x:Number, $y:Number ):void
		{
			if( _process )
			{
				pushPosition( $x, $y );
				var dir:uint = getDirection();
				
				if( dir == 0 ){ // static
					trace( "static" );
				}else
				if( dir == 1 && (_leftRightSwitch == 0 || _leftRightSwitch == 2) ){ // left
					_leftRightSwitch = 1;
					trace( "left" );
				}else
				if( dir == 2 && (_leftRightSwitch == 0 || _leftRightSwitch == 1) ){ // right
					_leftRightSwitch = 2;
					trace( "right" );
				}else
				if( dir == 3 && (_upDownSwitch == 0 || _upDownSwitch == 2) ){ // up
					_upDownSwitch = 1;
					trace( "up" );
				}else
				if( dir == 4 && (_upDownSwitch == 0 || _upDownSwitch == 1) ){ // down
					_upDownSwitch = 2;
					trace( "down" );
				}
			}	
		}
		
		/** Pushes a new position to the buffer and calculates direction **/
		private function pushPosition( $x:Number,$y:Number ):void
		{
			_bufferCount++;
			
			// shift the first item and push it to the front.
			var buffer:uint 	= _positions.length;
			var p:Vector3D 		= _positions[0];
			var d:Vector3D		= _directions[0];
			
			p.setTo($x, $y, 0);
			for( var i:uint = 1; i<buffer; i++ )
			{
				_positions[i-1]  = _positions[i];
				_directions[i-1] = _directions[i];
			}
	
			var p2:Vector3D = _positions[buffer-2];
			d.setTo( p.x-p2.x,p.y-p2.y,0);
			
			_directions[ buffer-1 ] = d; 
			_positions[buffer-1] 	= p;
		}
		
		private function clear():void
		{
			_leftRightSwitch = _upDownSwitch = 0;
			
			var buffer:uint = _positions.length;
			for( var i:uint = 0; i<buffer; i++ ){
				_positions[i].setTo(0,0,0);
				_directions[i].setTo(0,0,0);
			}
			
			_bufferCount = 0;
		}
		
		/** gets the average direction ( 0=none, 1=left, 2=right, 3=up, 4=down ) **/
		private function getDirection():uint
		{
			if( _bufferCount < _bufferMinBeforeCalc )
				return 0;
			
			var buffer:uint = _directions.length;
			var av:Vector3D = new Vector3D();
			
			for( var i:uint = 0; i<buffer; i++ ){
				av = av.add(_directions[i]);
			}
			
			if( Math.abs(av.x) > Math.abs(av.y) ){
				if( av.x < 0 )
					return 1;
				else
				if( av.x > 0 )
					return 2;
				else
					return 0;
			}else
			if( av.y < 0 ){
				return 3;
			}else
			if( av.y > 0 ){
				return 4;
			}else
				return 0;
		}
	}
}
