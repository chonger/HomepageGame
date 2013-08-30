package;

	
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxTimer;

class Fireman extends Enemy
{

	var spitting : Bool;
	
	public function new(xx : Float, yy : Float)
	{
		super();

		loadGraphic("assets/fireman.png", true, true, 42, 42);
		addAnimation("default", [0,1,2,3], 4, true);
		addAnimation("spit", [4,5,4,4], 8, false);
		addAnimationCallback(animCallback);
		play("default");

		spitting = false;
		
		setPosition(xx,yy);

		width = 36;
		height = 36;
		centerOffsets();
		
		FlxTimer.start(10 + Std.random(5), doSpit);
		
	}

	public override function unpause() {
		super.unpause();
		FlxTimer.start(10 + Std.random(5), doSpit);
	}
	
	public function doSpit(t : FlxTimer) {
		if(ispaused) {
			return;
		}
		play("spit");
		spitting = true;
	}

	public override function update() {
		super.update();

		if(!spitting) {
			if(GameState.player.x < x) {
				facing = FlxObject.LEFT;
			} else {
				facing = FlxObject.RIGHT;
			}
		}
	}

	
	private function animCallback(animationName : String, currentFrame : Int, currentFrameIndex : Int) : Void
	{
		if(animationName == "spit" && currentFrame == 2) {

			var fball = new Fireball(x,y);
			GameState.game.add(fball);
			GameState.game.enemyz.push(fball);
			
		}
		if(animationName == "spit" && currentFrame == 3) {
			spitting = false;
			play("default");
			FlxTimer.start(10 + Std.random(5), doSpit);
		}
	}

}