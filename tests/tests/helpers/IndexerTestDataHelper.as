package tests.helpers
{
	import flash.geom.Rectangle;
	import gui.indexing.IGuiIndexer;
	import gui.core.GuiObject;
	import flash.geom.Point;
	import gui.core.GuiObjectContainer;
	
	/**
	* Helper class for generating nested GuiObject data.
	* Creates objects that are of certain size and can be predicatably tested in unit tests for indexing.
	*
	* @author jamieowen
	*/
	public class IndexerTestDataHelper 
	{
		// some constant values used by indexer tests.
		// These values should be used consistantly throughout indexer tests to affect all outcomes in the IndexerSuite
		public static const SQUARE_SMALL_DEPTH:uint		= 6;
		public static const SQUARE_SMALL_SIZE:uint 		= 600;
		public static const SQUARE_SMALL_PADDING:uint 	= 3;
		
		// a constant rect to pass to indexer find() queries in unit tests. Each unit test find() queries the top left rect to check the correct amount objects are returned.
		public static const SQUARE_SMALL_TOP_LEFT_RECT:Rectangle = new Rectangle(
										SQUARE_SMALL_PADDING,
										SQUARE_SMALL_PADDING, 
										(SQUARE_SMALL_SIZE-(SQUARE_SMALL_PADDING*3))/2,
										(SQUARE_SMALL_SIZE-(SQUARE_SMALL_PADDING*3))/2
										);
		
		/**
		 * Recursively creates a box shape with inner squares that can be easily tested with indexing structures.
		 * 
		 * @param $container The Container to create in.
		 * @param $padding The padding to apply to each box
		 * @param $size The width/height to apply to the supplied container.
		 * @param $depth The current depth of recursion
		 * @param $maxDepth The max depth of recursion.
		 * @param $count A point object storing the total number of GuiObjectContainer's in x, and GuiObject's in y. Including the initial supplied container.
		 */
		public static function create4Square($container:GuiObjectContainer,$size:Number, $padding:Number, $depth:uint, $maxDepth:uint, $count:Point ):void
		{ 
			$depth++;
			
			$container.width = $container.height = $size;
			
			$count.x++;
			
			// create 4 children and add again.
			var ix:int = 0;
			var iy:int = 0;
			var cont:GuiObjectContainer;
			var bg:GuiObject;
			$size = ($size - ( $padding*3 ))/2;
			
			var leafNodeSize:Number;
			// add 4 squares inside this.
			while(ix<2)
			{
				iy = 0;
				while(iy<2)
				{
					bg = new TestGuiObject();
					$container.addChild( bg );
					bg.width = bg.height = $size;
					bg.x = (ix*$size) + ( $padding*(ix+1) );
					bg.y = (iy*$size) + ( $padding*(iy+1) );
					$count.y++;

					if( $depth < $maxDepth )
					{
						// add another container and add again
						cont = new TestGuiObjectContainer();
						$container.addChild( cont );
						cont.x = bg.x;
						cont.y = bg.y;
						
						create4Square(cont, $size, $padding, $depth, $maxDepth, $count);	
					}else
					{
						leafNodeSize = $size;
						if( isNaN(leafNodeSize)||leafNodeSize<0.0 )
							throw new Error("Error generating squares - Leaf node size too small! Check the depth or size/padding/etc.");
					}
					
					iy++;
				}
				ix++;
			}
			
			
		}
		
		/**
		 * Calculates the expected number of containers and objects in the create4Square() output.
		 */
		public static function calculateCountsForBox( $depth:uint ):Point
		{
			var count:Point = new Point();
			var i:uint = 1;
			var c:uint = 0; // count for container
			while( i<=$depth )
			{
				count.x += Math.pow(4,c);
				count.y += Math.pow(4,i);
				i++;
				c++;
			}
			return count;
		}
		
		/**
		 * Calculates the total count for one top left box. For asserting find() tests.
		 * 
		 */
		public static function calculateFindResultFor1( $depth:uint ):Number
		{
			var count:Point = calculateCountsForBox( $depth );
			return (( count.x + count.y ) -1 )/4;	// -1 for the container box ( this should be added on again in intersection tests )
		}
		
		/**
		 * Adds all children and sub children of a container to the index.
		 */
		public static function addToIndexer( $container:GuiObjectContainer, $indexer:IGuiIndexer ):void
		{
			$indexer.add( $container );
			
			var i:int = 0;
			var l:uint = $container.numChildren;
			var obj:GuiObject;
			while( i<l )
			{
				obj = $container.getChildAt(i);
				
				if( obj is GuiObjectContainer ) addToIndexer(obj as GuiObjectContainer, $indexer);
				else $indexer.add( obj );
				 
				i++;
			}
		}
		
		/**
		 * Updates all children and sub-children of a container to the index.
		 */
		public static function updateInIndexer( $container:GuiObjectContainer, $indexer:IGuiIndexer ):void
		{
			$indexer.update( $container, $container.getGlobalBounds());
			
			var i:int = 0;
			var l:uint = $container.numChildren;
			var obj:GuiObject;
			while( i<l )
			{
				obj = $container.getChildAt(i);
				
				if( obj is GuiObjectContainer ) updateInIndexer(obj as GuiObjectContainer, $indexer);
				else $indexer.update( obj, obj.getGlobalBounds() );
				
				i++;
			}			
		}
		
		/**
		 * Removes children one by one from indexer.
		 */
		public static function removeFromIndexer( $container:GuiObjectContainer, $indexer:IGuiIndexer ):void
		{
			$indexer.remove( $container );
			
			var i:int = 0;
			var l:uint = $container.numChildren;
			var obj:GuiObject;
			while( i<l )
			{
				obj = $container.getChildAt(i);
				
				if( obj is GuiObjectContainer ) removeFromIndexer(obj as GuiObjectContainer, $indexer);
				else $indexer.remove( obj );
				 
				i++;
			}
		}
		
	}
}