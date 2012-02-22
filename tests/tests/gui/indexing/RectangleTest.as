package tests.gui.indexing
{
	import flash.utils.getTimer;
	import flash.geom.Rectangle;
	/**
	* Test to check speed of native flash.
	*
	* @author jamieowen
	*/
	public class RectangleTest 
	{
		public static const NUMBER_OF_ITERATIONS:uint = 50000;
		/**
		 * 
		 */
		[BeforeClass]
		public static function initialise():void
		{
			
		}

		/**
		 * 
		 */	
		[AfterClass]
		public static function dispose():void
		{
		}

		/**
		 * 
		 */
		[Before]
		public  function pre() : void
		{
		}
		
		/**
		 * 
		 */
		[After]
		public function post():void
		{
			
		}
		
		/**
		 * Test the speed of Rectangle.intersects() operation
		 */
		[Test(order=1)]
		public function testIntersectionResultAsBoolean():void
		{ 
			var i:uint = 0;
			var l:uint = NUMBER_OF_ITERATIONS;
			var rect1:Rectangle;
			var rect2:Rectangle;
			var result:Boolean;
			var time:Number = getTimer();
			
			while( i++<l )
			{
				rect1 = new Rectangle(0,0,100,100);
				rect2 = new Rectangle(50,50,100,100);
				
				result = rect1.intersects(rect2);
			}
			time = (getTimer()-time)/1000;
			trace( "Rectangle.intersects() speed for " + l + " calls : " + time + " secs. ( with instantiation )" );
		}
		
		/**
		 * Test the speed of Rectangle.intersection() operation
		 */
		[Test(order=2)]
		public function testIntersectionResultAsRectangle():void
		{ 
			var i:uint = 0;
			var l:uint = NUMBER_OF_ITERATIONS;
			var rect1:Rectangle;
			var rect2:Rectangle;
			var result:Rectangle;
			var time:Number = getTimer();
			
			while( i++<l )
			{
				rect1 = new Rectangle(0,0,100,100);
				rect2 = new Rectangle(50,50,100,100);
				
				result = rect1.intersection(rect2);
			}
			time = (getTimer()-time)/1000;
			trace( "Rectangle.intersection() speed for " + l + " calls : " + time + " secs. ( with instantiation )" );
		}
		
		/**
		 * 
		 */
		[Test(order=3)]
		public function testIntersectionResultAsBooleanWithoutInstantiation():void
		{ 
			var i:uint = 0;
			var l:uint = NUMBER_OF_ITERATIONS;
			var rect1:Rectangle = new Rectangle(0,0,100,100);
			var rect2:Rectangle = new Rectangle(50,50,100,100);
			var result:Boolean;
			var time:Number = getTimer();
		
			
			while( i++<l )
			{
				result = rect1.intersects(rect2);
			}
			
			time = (getTimer()-time)/1000;
			trace( "Rectangle.intersects() speed for " + l + " calls : " + time + " secs. ( without instantiation )" );
		}
		
		/**
		 * 
		 */
		[Test(order=4)]
		public function testIntersectionResultAsRectangleWithoutInstantiation():void
		{ 
			var i:uint = 0;
			var l:uint = NUMBER_OF_ITERATIONS;
			var rect1:Rectangle= new Rectangle(0,0,100,100); 
			var rect2:Rectangle = new Rectangle(50,50,100,100);
			var result:Rectangle;
			var time:Number = getTimer();

			while( i++<l )
			{
				result = rect1.intersection(rect2);
			}
			
			time = (getTimer()-time)/1000;
			trace( "Rectangle.intersection() speed for " + l + " calls : " + time + " secs. ( without instantiation )" );
		}
		
		/**
		 * 
		 */
		[Test(order=5)]
		public function testIntersectionResultAsBooleanWithoutInstantiationRandomised():void
		{ 
			var i:uint = 0;
			var l:uint = NUMBER_OF_ITERATIONS;
			var rect1:Rectangle = new Rectangle(0,0,100,100);
			var rect2:Rectangle = new Rectangle(50,50,100,100);
			var result:Boolean;
			var time:Number = getTimer();
		
			
			while( i++<l )
			{
				rect1.width = Math.random()*1000;
				rect2.height = Math.random()*1000;				
				result = rect1.intersects(rect2);
			}
			
			time = (getTimer()-time)/1000;
			trace( "Rectangle.intersects() speed for " + l + " calls : " + time + " secs. ( without instantiation, randomised )" );
		}
		
		/**
		 * 
		 */
		[Test(order=6)]
		public function testIntersectionResultAsRectangleWithoutInstantiationRandomised():void
		{ 
			var i:uint = 0;
			var l:uint = NUMBER_OF_ITERATIONS;
			var rect1:Rectangle= new Rectangle(0,0,100,100); 
			var rect2:Rectangle = new Rectangle(50,50,100,100);
			var result:Rectangle;
			var time:Number = getTimer();
			
			while( i++<l )
			{
				rect1.width = Math.random()*1000;
				rect2.height = Math.random()*1000;
				result = rect1.intersection(rect2);
			}
			
			time = (getTimer()-time)/1000;
			trace( "Rectangle.intersection() speed for " + l + " calls : " + time + " secs. ( without instantiation, randomised )" );
		}
		
		/**[Test(order7)]
		public function testRect():void
		{
			var rect1:Rectangle= new Rectangle(0,0,100,100); 
			var rect2:Rectangle = new Rectangle(10,10,80,80);
			
			trace( "Intersect test :" );
			trace( rect1.intersection( rect2 ));
			trace( rect2.intersection( rect1 ));
		}**/
		
	}
}