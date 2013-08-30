package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

class Enemy extends FlxSprite {

	var ispaused : Bool;
	public var fullPhys : Bool;
	
	public function new() {
		super();
		immovable = true;
		ispaused = false;
		fullPhys = false;
	}

	public function unpause() {
		ispaused = false;
	}

	public function pause() {
		ispaused = true;
	}

	public function collideHook() {
		
	}
	
	public static function collideF(pz : FlxObject, e : FlxObject) {

		var pl = cast(pz,Player);
		
		var xD = pl.x - e.x;
		var yD = pl.y - e.y;

		if(xD > 10) 
			pl.velocity.x = 200;
		if(xD < 10)
			pl.velocity.x = -200;
		if(yD > 10)
			pl.velocity.y = 200;
		if(yD < 10)
			pl.velocity.y = -200;

		pl.jumping = true;
		pl.crouching = false;
		FlxSpriteUtil.flicker(pl,.8);
		cast(e,Enemy).collideHook();
	}
	
}