package   
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getTimer;
	import gui.core.context.GuiContextOld;
	import gui.core.nodes.indexing.qtree.QTreeNode;
	import gui.display.GuiBitmap;
	import gui.display.GuiContainer;
	import gui.renderers.StarlingGuiRenderer;

	
	
	// NOT WORKING ANYMORE ---- TO BE REMOVED..
	
	[SWF(width=1280,height=768,frameRate=60)]
	public class Rough extends Sprite
	{
		public var guiContext:GuiContextOld;
		public var starlingRenderer:StarlingGuiRenderer;
		public var subContainer:GuiContainer;
		
		public function Rough()
		{
			stage.align 		= StageAlign.TOP_LEFT;
			stage.scaleMode 	= StageScaleMode.NO_SCALE;
			
			// CONTEXT 
			//guiContext = new GuiContext();
			//guiContext.x = guiContext.y = 100;
			
			//guiContext.width 	= 320;
			//guiContext.height 	= 480;
			
			//var stats:Stats = new Stats();
			//addChild(stats);
			//drawQTreeNodes(qtreeTest.root);
				
			//starlingRenderer = new StarlingGuiRenderer(guiContext,stage);
			
			
		}
		
		private function drawQTreeNodes($node:QTreeNode):void
		{
			graphics.lineStyle(1,0x000000,.3);
			graphics.drawRect($node.rect.x, $node.rect.y, $node.rect.width, $node.rect.height);
			
			var i:int = 0;
			while( i<4 && $node.nodes)
			{
				drawQTreeNodes($node.nodes[i++]);
			}
			
		}
		
		private function onStarlingStartup($event:Event):void
		{
			var i:int = 0;
			var bitmap:GuiBitmap;
			
			while( i < 1000 )
			{
				if( i == 5 )
				{
					// add a clipped container..
					var container:GuiContainer = new GuiContainer();
					container.height = 30;
					container.x = 100;
					container.y = 100 + (i*(bitmap.width+1));
					container.width = 100; // let it be clipped.
					//container.clipChildren = true;
					for( var b:int = 0; b<100; b++ )
					{
						bitmap = new GuiBitmap();
						bitmap.width = bitmap.height = 30;
						bitmap.x = (b*(bitmap.width+1));
						container.addChild( bitmap );
					}
					trace("bitmap container x :" + bitmap.x );
					subContainer = container;
					//guiContext.addChild( container );
				}else
				{
					bitmap = new GuiBitmap();
					bitmap.width = bitmap.height = 30;
					bitmap.x = 100;
					bitmap.y = 100 + (i*(bitmap.width+1));
					
					//guiContext.addChild( bitmap );
				}

				i++;
			}
			trace( "bitmap y extent : " + bitmap.y );

			//trace( "QTree Nodes: " + guiContext.qtree.numNodes );
			//if( guiContext.qtree.root.items )
			//	trace( "Root Items : " + guiContext.qtree.root.items.length );
			addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		protected function onEnterFrame( $event:Event ):void
		{
			var timer:Number = getTimer();
			guiContext.update();
			subContainer.scrollPositionX-=.5;
			timer = ( getTimer() - timer )/1000;
			//trace( "render time : " + timer.toFixed(3) );
			
			//guiContext.scrollPositionX+=.5;
			// renderers perhaps just listen to a context and render then.
			//starlingRenderer.render();
			
		}
	}
}