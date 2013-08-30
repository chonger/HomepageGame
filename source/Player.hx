package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

	
class Player extends FlxSprite
{	

	public var jumping:Bool;
	public var still:Bool;
	public var stop:Bool;
	public var crouching:Bool;
	public var falling:Int;
	public var storeX:Float;
	public var storeY:Float;
	public var freeze : Bool;

	public var groundDrag:Float = 1000;	

	public function freezeme() {
		freeze = true;
		moves = false;
	}

	public function unfreeze() {
		freeze = false;
		moves = true;
	}
	
	public function new()
	{
		super();

		freeze = false;
		
		loadGraphic("assets/bensprite.png", true, true, 32, 64);
		addAnimation("default", [8]);
		addAnimation("walk", [0,1,2,3], 7, true);
		addAnimation("crouch", [3,4,5,6,7], 9, false);
		addAnimation("jump", [7]);
		addAnimation("pause", [1,1,8],1,false);
		play("default");

		width = 16;
		centerOffsets();
		offset.y += 3;	


		acceleration.y = 500;
		drag.x = groundDrag;
		jumping = false;
		crouching = false;
		still = true;
		stop = false;
		addAnimationCallback(animCallback);
	}
	
	private function animCallback(animationName : String, currentFrame : Int, currentFrameIndex : Int) : Void
	{

			
		if(animationName == "pause" && currentFrame == 2) {
			stop = true;
			play("default");
		}
		
		if(animationName == "crouch") {
			if(currentFrame == 4) {
				y -= 10;
				velocity.y = storeY;
				velocity.x = storeX;
				play("jump");
				crouching = false;
				jumping = true;
				drag.x = 50;
			} else {
				if(FlxG.keys.pressed.UP) {
					storeY -= 50;
				}
			}
		}
	}
	
	public function updatePlayer():Void
	{
		if(freeze)
			return;
		
		still = true;
		
		if (FlxG.keys.pressed.LEFT && !crouching) {
			velocity.x = -100;
			facing = FlxObject.LEFT;
			still = false;

		}

		/**
		if (FlxG.keys.DOWN) {
			Linker.go("http://www.google.com");
        }
		*/
		
		if (FlxG.keys.pressed.RIGHT && !crouching) {
			velocity.x = 100;
			facing = FlxObject.RIGHT;
			still = false;

		}

		if(isTouching(FlxObject.FLOOR) && jumping) {
			drag.x = groundDrag;
			jumping = false;
			falling = 0;

		}

		if(!isTouching(FlxObject.FLOOR) && !jumping) {
			falling += 1;
			if(falling > 3) {
				jumping = true;
				drag.x = 50;
				play("jump");

			}
		}
		
		if (isTouching(FlxObject.FLOOR) && FlxG.keys.pressed.UP && !jumping && !crouching) {
			still = false;
			crouching = true;
			storeX = velocity.x;
			velocity.x = 0;
			storeY = -100;
			play("crouch");
		}


		
		if(!jumping && !crouching) {
			if(still) {
				if(!stop)
					play("pause");				
			} else {
				stop = false;
				play('walk');
			}
		} else {
			stop = false;
		}
	}
}
