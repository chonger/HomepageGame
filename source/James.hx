package;

import flixel.FlxSprite;

class James extends NPC
{

	public function new(xx : Float, yy : Float)
	{
		super();

		mainSprite = new FlxSprite();
		
		mainSprite.loadGraphic("assets/james.png", true, true, 34, 77);
		mainSprite.addAnimation("default", [1]);
		mainSprite.addAnimation("talk", [0,1], 8, true);
		
		mainSprite.offset.x += 5;

		add(mainSprite);

		mainSprite.play("default");
		
		setPosition(xx,yy);
				
		loadActions("assets/jamesScript.xml");
	}

	
}
