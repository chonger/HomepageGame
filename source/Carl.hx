package;

import flixel.FlxSprite;

class Carl extends NPC
{

	public function new(xx : Float, yy : Float)
	{
		super();
		
		setPosition(xx,yy);

		mainSprite = new FlxSprite();
		
		mainSprite.loadGraphic("assets/carl.png", true, true, 32, 68);
		mainSprite.addAnimation("default", [0]);
		mainSprite.addAnimation("talk", [0], 8, true);
		
		//mainSprite.offset.x += 5;

		add(mainSprite);

		mainSprite.play("default");
		
		loadActions("assets/carlScript.xml");

	
	}
	
}
