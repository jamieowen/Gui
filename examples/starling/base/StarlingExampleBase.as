package starling.base {
	import flash.display.Sprite;
	import flash.events.Event;
	import gui.core.GuiContext;
	import gui.core.traverser.RenderCollector;
	import gui.display.GuiContainer;
	import gui.renderers.StarlingGuiRenderer;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;



	/**
	* Class Description
	*
	* @author jamieowen
	*/
	public class StarlingExampleBase extends Sprite
	{
		/** Starling instance **/
		protected var starling:Starling;
		
		/** The root container to add UI objects **/
		protected var container:GuiContainer;
		
		protected var collector:RenderCollector;
		
		protected var renderer:StarlingGuiRenderer;
		
		/**
		* Class Constructor Description
		*/
		public function StarlingExampleBase()
		{
			initStarling();		
		}
		
		/** Creates the starling instance. **/
		protected function initStarling():void
		{
			starling = new Starling(StarlingRootView,stage);
			starling.addEventListener( starling.events.Event.CONTEXT3D_CREATE, onStarlingEvent );
			starling.start();	
		}
		
		/** Inits the context **/
		protected function initContext():void
		{
			// TODO : need to introduce the context class again
			container = new GuiContainer(); // container to add UIObjects to
			collector = new RenderCollector(container); // collector traverses UI hierarchy and builds list of renderable items.
			renderer  = new StarlingGuiRenderer(new GuiContext(GuiContainer), starling.stage.getChildAt(0) as DisplayObjectContainer ); // renders the collected items to the starling stage.
			
			container.width = container.height = 500;
			
			registerSkins();
			createExample();
			
			addEventListener( flash.events.Event.ENTER_FRAME, onEnterFrame );
		}
		
		/** Should be overriden by example subclass **/
		protected function registerSkins():void
		{
			
		}
		
		/** Should be overriden by example subclass **/
		protected function createExample():void
		{
			
		}
		
		//-/////////////////
		//-// Events
		
		protected function onEnterFrame( $event:flash.events.Event ):void
		{
			collector.render();
			renderer.render( collector.renderList );
		}
		
		protected function onStarlingEvent( $event:starling.events.Event ):void
		{
			starling.removeEventListener( starling.events.Event.CONTEXT3D_CREATE, onStarlingEvent );
			initContext();
		}
	}
}