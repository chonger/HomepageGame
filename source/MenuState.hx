package;

import flixel.FlxState;
import flixel.FlxG;

class MenuState extends FlxState
{
	

	/**
	   
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{	
	
		bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		//FlxG.mouse.show();
		#end

		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		
		super.update();

		
		if(FlxG.keys.justPressed.Z){

			var st = new GameState("assets/Backstage/Level_Group1.xml","Door1");
			
			FlxG.switchState(st);
		}
		
	}	
	
		
}