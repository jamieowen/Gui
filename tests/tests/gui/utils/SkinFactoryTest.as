package tests.gui.utils {
	import flash.system.System;
	import gui.render.IGuiObjectSkin;
	import gui.utils.SkinFactory;

	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.hasProperty;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * Tests the SkinFactory with the following :
	 * 
	 * 1. Registering mappings.
	 * 2. Matching patterns to those mappings.
	 * 3. Unregistering all mappings individually.
	 * 4. Register and unregister over time to test GC. ( view in profiler )
	 * 5. Instantiating matched classes and disposing over time with and without cache. ( view in profiler )
	 * 
	 */
	public class SkinFactoryTest 
	{
		public static var factory:SkinFactory;
		
		[BeforeClass]
		public static function setupFactory():void
		{
			factory = new SkinFactory();
		}
		
		[AfterClass]
		public static function removeFactory():void
		{
			factory.unregisterAll();
			factory = null;
		}
			
		[Test(order=1)]
		public function testRegisterMappings():void
		{
			factory.register( "*", MatchAny ); // not the same as a wildcard - just a "default" class
			factory.register( "button", ButtonClass );
			factory.register( "button1,button2,button3", ButtonClass ); 
			
			factory.register( "customContainer.button", CustomButtonClass ); // uses the same buttton name but is in a custom container.
			
			factory.register( "listItem", ListItemClass );
			factory.register( "listItem.subItem", ListItemSubClass );
			
			factory.register( "myList.listItem", ListItemCustomClass ); // should override the normal listItem class.
			factory.register( "myList.listItem.subItem", ListItemCustomSubClass );
			
			assertTrue( factory.numMappings == 10 );		
		}
		
		
		[Test(order=2)]
		public function testMatch():void
		{
			// match any non-registered name

			assertThat( factory.match("button"), org.hamcrest.object.hasProperty("cls", ButtonClass));
			
			assertThat( factory.match("notRegistered1"), org.hamcrest.object.hasProperty("cls",MatchAny ));
			assertThat( factory.match("notRegistered1.notRegistered2"), org.hamcrest.object.hasProperty("cls",MatchAny ));
			assertThat( factory.match("notRegistered1.notRegistered2.notRegistered3"), org.hamcrest.object.hasProperty("cls",MatchAny )); 
			
			// test single pattern
			
			assertThat( factory.match("button"), org.hamcrest.object.hasProperty("cls",ButtonClass ));
			assertThat( factory.match("button1"), org.hamcrest.object.hasProperty("cls",ButtonClass ));
			assertThat( factory.match("button2"), org.hamcrest.object.hasProperty("cls",ButtonClass ));
			assertThat( factory.match("button3"), org.hamcrest.object.hasProperty("cls",ButtonClass ));
			
			// and nested
			assertThat( factory.match("notRegistered1.button"), org.hamcrest.object.hasProperty("cls",ButtonClass )); 
			assertThat( factory.match("notRegistered1.notRegistered2.button3"), org.hamcrest.object.hasProperty("cls",ButtonClass ));
			assertThat( factory.match("notRegistered1.notRegistered2.notRegistered3.button2"), org.hamcrest.object.hasProperty("cls",ButtonClass ));
			assertThat( factory.match("notRegistered1.notRegistered2.notRegistered3.notRegistered4.button3"), org.hamcrest.object.hasProperty("cls",ButtonClass ));
			
			// match custom container button
			assertThat( factory.match("customContainer.button"), org.hamcrest.object.hasProperty("cls",CustomButtonClass ));
			
			// match list
			assertThat( factory.match("listItem"), org.hamcrest.object.hasProperty("cls",ListItemClass ));
			assertThat( factory.match("notRegistered.listItem"), org.hamcrest.object.hasProperty("cls",ListItemClass ));
			
			assertThat( factory.match("listItem.subItem"), org.hamcrest.object.hasProperty("cls",ListItemSubClass ));
			assertThat( factory.match("notRegistered.listItem.subItem"), org.hamcrest.object.hasProperty("cls",ListItemSubClass ));
			assertThat( factory.match("notRegistered1.notRegistered2.listItem.subItem"), org.hamcrest.object.hasProperty("cls",ListItemSubClass ));
			
			// list sub children override
			assertThat( factory.match("myList.listItem"), org.hamcrest.object.hasProperty("cls",ListItemCustomClass ));
			assertThat( factory.match("myList.listItem.subItem"), org.hamcrest.object.hasProperty("cls",ListItemCustomSubClass ));
			assertThat( factory.match("notRegistered.myList.listItem.subItem"), org.hamcrest.object.hasProperty("cls",ListItemCustomSubClass ));
			assertThat( factory.match("notRegistered1.notRegistered2.myList.listItem.subItem"), org.hamcrest.object.hasProperty("cls",ListItemCustomSubClass ));
		}
		
		[Test(order=3)]
		public function testUnregister():void
		{
			// unregister
			factory.unregister( "*" ); 
			factory.unregister( "button" );
			factory.unregister( "button1,button2,button3" ); 
			
			factory.unregister( "customContainer.button" ); 
			
			factory.unregister( "listItem" );
			factory.unregister( "listItem.subItem" );
			
			factory.unregister( "myList.listItem" );
			factory.unregister( "myList.listItem.subItem" );

			assertTrue( factory.numMappings == 0 );
		}
		
		/***
		 * Tests unregistering and registering over time every frame. - To Run through the profiler.
		 * Expects the frameRate of the FlexUnit base class to be at 60fps.
		 *  
		 * Will not be usual usage but testing this for memory reasons anyway.
		 */
		[Test(order=4,async)]
		public function testRegisterUnregisterOverTime():void
		{
			var repeatNumFrames:uint = 100; // register unregister count in frames
			var numMappings:uint = 1;//500; // number of mappings unmappings per frame
					
			var r:uint = 0;
			var i:uint = 0;
				
			var name:String;
			
			var n:uint = 0;
			var nl:uint;
			var time:Number;
			var patterns:Vector.<String> = new Vector.<String>();
			
			var enterFrame:Function = function( $ev:Event ):void
			{
				i = 0;
				
				while( i++<numMappings )
				{
					n = 0;
					nl = Math.floor( (Math.random()*4) + 1 ); 
					name = "root";
					while(n++<nl) // create nested names
						name+=".item" + Math.floor(Math.random()*1000000).toString(); 
					
					patterns.push( name );
				}
				
				// sort() method in factory.register() is v. slow. 
				// this would need some changes if large amounts of registering is happening.
				// usually this will happen once though at app startup.
				
				i=0;
				time = getTimer();
				while(i<numMappings)
					factory.register(patterns[i++], MatchAny );
					
				assertTrue( factory.numMappings == numMappings );
				factory.unregisterAll();
				time = getTimer()-time;
				assertTrue( factory.numMappings == 0 );
				
				trace( "Map/Unmap : " + r + "/" + repeatNumFrames + " (" + (time/1000) + " secs)" );
				
				if( r >= repeatNumFrames )
				{
					( $ev.target as EventDispatcher ).removeEventListener( TimerEvent.TIMER, enterFrame);
					trace( "End Map/Unmap");
					return;
				}
			};
		
			var timer:Timer = new Timer(1000/60,repeatNumFrames);
			timer.addEventListener(TimerEvent.TIMER, enterFrame );
			
			Async.proceedOnEvent(this, timer, TimerEvent.TIMER_COMPLETE, Number.MAX_VALUE );
			timer.start();
		}
		
		/**
		 * Runs and tests creation and disposal.  First without caching, then with.
		 */
		[Test(order=5,async)]
		public function testCreateDisposeOverTime():void
		{
			var repeatNumFrames:uint = 100; // number of frames to repeat.
			
			var numObjectsNoCache:uint 	= 2000;
			var numObjectsCache:uint 	= 2000; // create and dispose every frame with no cache limit set ( all items cached )
			
			var testedNoCache:Boolean = false; // to switch over to with cache.
			var currentFrame:uint 	  = 0;
			var i:uint;
			var time:Number;
			
			// some bitmap data to pass to the skin.
			var bitmapData:BitmapData = new BitmapData(100, 100);
			// create single mapping. // with args..
			var pattern:String = "cacheTest";
			factory.register( pattern, GuiObjectSkinTest, {test1:"Testing",test2:123,testBitmap:bitmapData } );
			factory.setCacheLimit( GuiObjectSkinTest, 0);
			
			var _objs:Vector.<IGuiObjectSkin> = new Vector.<IGuiObjectSkin>();
			var obj:GuiObjectSkinTest;
			
			var enterFrame:Function = function( $event:Event ):void
			{

				if( currentFrame++ >= repeatNumFrames )
				{
					testedNoCache = true;
					factory.setCacheLimit( GuiObjectSkinTest, uint.MAX_VALUE );
					currentFrame = 1;
				}
					
				if( !testedNoCache )
				{
					i = 0;
					time = getTimer();
					while(i++<numObjectsNoCache)
					{
						obj = factory.create(pattern) as GuiObjectSkinTest;
						_objs.push(obj);
					}
					i=0;
					while(i++<numObjectsNoCache)
					{
						factory.dispose( _objs.pop() );
					}
					
					time = getTimer()-time;
					trace( "Create/Dispose Uncache: " + currentFrame + "/" + repeatNumFrames + " (" + (time/1000) + " secs)" );
				}else
				{
					i = 0;
					time = getTimer();
					while(i++<numObjectsCache)
					{
						obj = factory.create(pattern) as GuiObjectSkinTest;
						_objs.push(obj);
					}
					i=0;
					while(i++<numObjectsCache)
					{
						factory.dispose( _objs.pop() );
					}
					time = getTimer()-time;
					
					trace( "Create/Dispose Cache: " + currentFrame + "/" + repeatNumFrames + " (" + (time/1000) + " secs)" );
				}
				
				// cleanup
				if( currentFrame >= repeatNumFrames && testedNoCache )
				{
					factory.unregisterAll();
					bitmapData.dispose();
					_objs.splice(0, uint.MAX_VALUE);
					
					factory.disposeAllCache();
					trace( "End Create/Dispose");
					( $event.target as EventDispatcher ).removeEventListener( TimerEvent.TIMER, enterFrame);
					
					// trigger a gc
					System.gc();
				}
			};
			
			
			var timer:Timer = new Timer(1000/60,repeatNumFrames*2);
			timer.addEventListener(TimerEvent.TIMER, enterFrame );
			
			Async.proceedOnEvent(this, timer, TimerEvent.TIMER_COMPLETE, Number.MAX_VALUE );
			timer.start();
		}

		

	}
}

// some fake classes for mapping
internal class MatchAny{}

internal class ButtonClass{}

internal class CustomButtonClass{}

internal class ListItemClass{}

internal class ListItemSubClass{}

internal class ListItemCustomClass{}

internal class ListItemCustomSubClass{}

