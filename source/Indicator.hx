package;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
	
class Indicator extends FlxSprite
{	
	public function new()
	{
		super();	
		loadGraphic("assets/Zbutton.png");
		setOriginToCenter();

		visible = false;
		
	}

	public function place(n : FlxSprite) {
		
		x = n.x + n.width/2 - width/2;
		y = n.y - 60;

		FlxTween.quadMotion(this, x, y, x, y-40, x, y, 1, true, { type: FlxTween.LOOPING });
		
		visible = true;

	}

}