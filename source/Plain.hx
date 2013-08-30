package;

import flixel.FlxSprite;

class Plain extends Obj {

	var s : FlxSprite;
	
	public function new(x : Float, y : Float, img : String) {
		super();
		s = new FlxSprite();
		s.loadGraphic("assets/" + img);
		s.setPosition(x,y);
		add(s);
	}

}