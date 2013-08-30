package;

import flixel.util.FlxPoint;
import flixel.util.FlxTimer;

class Fireball extends Enemy {


	var life : FlxTimer;
	
	public function new(xx : Float, yy : Float) {
		super();

		loadGraphic("assets/fireball.png", true, false, 20, 20);
		addAnimation("roll", [0,1,2,3], 8, true);
		play("roll");
		centerOffsets();
		setPosition(xx,yy);
		velocity = new FlxPoint(230,20);
		acceleration.y = 500;
		fullPhys = true;
		immovable = false;
		elasticity = .7;
		life = FlxTimer.start(5,explode);

	}

	public function explode(t : FlxTimer) {
		GameState.game.remove(this);
		GameState.game.enemyz.remove(this);
	}		

	public override function pause() {
		moves = false;
	}

	public override function unpause() {
		moves = true;
	}
	
	public override function collideHook() {
		life.abort();
		explode(life);
	}

}