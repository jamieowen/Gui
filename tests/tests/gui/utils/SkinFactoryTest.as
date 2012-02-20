package tests.gui.utils {
	import org.hamcrest.object.notNullValue;
	import gui.utils.SkinFactoryMapping;
	import org.hamcrest.object.instanceOf;
	import gui.utils.SkinFactory;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.hasProperty;
	
	public class SkinFactoryTest 
	{
		public var factory:SkinFactory;
		
		[Test]
		public function testRegisterMatchUnregister():void
		{
			factory = new SkinFactory();
			
			factory.register( "*", MatchAny ); // not the same as a wildcard - just a "default" class
			factory.register( "button", ButtonClass );
			factory.register( "button1,button2,button3", ButtonClass ); 
			
			factory.register( "customContainer.button", CustomButtonClass ); // uses the same buttton name but is in a custom container.
			
			factory.register( "listItem", ListItemClass );
			factory.register( "listItem.subItem", ListItemSubClass );
			
			factory.register( "myList.listItem", ListItemCustomClass ); // should override the normal listItem class.
			factory.register( "myList.listItem.subItem", ListItemCustomSubClass );
			
			// match any non-registered name

			assertThat( factory.match("button"), org.hamcrest.object.hasProperty("cls", MatchAny));
			
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

