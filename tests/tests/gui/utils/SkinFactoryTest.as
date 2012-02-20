package tests.gui.utils {
	import gui.utils.SkinFactoryMapping;
	import gui.utils.SkinFactory;

	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.hasProperty;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
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
		public function testBruteRegisterUnregisterOverTime():void
		{
			var bruteCount:uint = 500; // number of mappings unmappings per frame
			var bruteRepeat:uint = 100; // register unregister count in frames
					
			var r:uint = 0;
			var i:uint = 0;
				
			var name:String;
			
			var n:uint = 0;
			var nl:uint;
			
			var frameTest:Function = function( $ev:Event ):void
			{
				if( r >= bruteRepeat )
				{
					( $ev.target as EventDispatcher ).removeEventListener( TimerEvent.TIMER, frameTest);
				}
				
				trace( "Map/Unmap : " + r + "/" + bruteRepeat );
				
				r++;
				i = 0;
				while( i<bruteCount )
				{
					n = 0;
					nl = Math.floor( (Math.random()*4) + 1 ); 
					name = "root";
					while(n++<nl) // create nested names
						name+=".item" + Math.floor(Math.random()*1000000).toString(); 
					
					factory.register( name, MatchAny );
				}
				assertTrue( factory.numMappings == bruteCount );
				factory.unregisterAll();
				assertTrue( factory.numMappings == 0 );
					
			};
		
			var timer:Timer = new Timer(1000/60,bruteRepeat);
			timer.addEventListener(TimerEvent.TIMER, frameTest );
			
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

