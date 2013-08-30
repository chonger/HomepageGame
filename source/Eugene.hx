package;

import flixel.FlxSprite;

class Eugene extends LinkNPC
{

	public function new(xx : Float, yy : Float)
	{
		super("Papers","www.google.com");

		mainSprite = new FlxSprite();
		
		mainSprite.loadGraphic("assets/eugene.png", true, true, 32, 64);
		mainSprite.addAnimation("default", [0]);
		mainSprite.addAnimation("talk", [0,1,2], 10, true);
		mainSprite.addAnimation("summon1", [3,4,5,6,7], 10, false);
		mainSprite.addAnimation("summon2", [7,8,9], 10, true);

		add(mainSprite);


		
		setPosition(xx,yy);

		initLink(); //must call after set position!
		
		mainSprite.addAnimationCallback(animCallback);

		mainSprite.play("default");
	}

	public override function special(s : String) : Bool {
		GameState.cManager.cleanBubs();
		mainSprite.play("summon1");
		return false;
	}
	
	private function animCallback(animationName : String, currentFrame : Int, currentFrameIndex : Int) : Void
	{
		if(animationName == "summon1" && currentFrame == 4) {
			mainSprite.play("summon2");
			startLink();			
		}
	}
	
}
