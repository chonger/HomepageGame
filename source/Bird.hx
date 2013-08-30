package;

	
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

import flixel.tweens.motion.LinearMotion;
import flixel.tweens.misc.NumTween;
import flixel.tweens.FlxTween;

import flixel.util.FlxTimer;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;


class Bird extends Enemy
{	

	public var flying:Bool;
	public var falling:Int;
	public var storeX:Float;
	public var storeY:Float;
	public var lmTween:LinearMotion;
	public var spots: Array<FlxPoint>;
	
	public function new(xx : Float, yy : Float, _spots : Array<FlxPoint>)
	{
		super();

		spots = new Array<FlxPoint>();

		for (s in _spots) {
			if(s.y < 1500)
				spots.push(s);
		}
		
		loadGraphic("assets/bird.png", true, true, 32, 32);
		addAnimation("default",[0]);
		addAnimation("flip", [0,1,1,0], 10, false);
		addAnimation("fly", [2,3,2,4], 10, true);
		addAnimationCallback(animCallback);
		width = 20;
		height = 20;
		offset.x = 6;
		offset.y = 6;
		play("default");

		flying = false;

		FlxTimer.start(2 + Std.random(2),doFlip);

		FlxTimer.start(5 + Std.random(4),doFly);
		
		setPosition(xx,yy);
		lmTween = new LinearMotion(landing);
		FlxTween.manager.add(lmTween,false);
	}

	public function doFlip(t : FlxTimer) {
		if(!flying) {
			play("flip");
		}
		FlxTimer.start(5 + Std.random(4),doFlip,1);
	}


	public override function pause() {
		super.pause();
		lmTween.active = false;
	}
	
	public override function unpause() {
		super.unpause();
		lmTween.active = true;
		FlxTimer.start(5 + Std.random(4),doFly);
	}
	
	public function doFly(t : FlxTimer) {

		if(ispaused) {
			return;
		}
		
		var ok = new Array<FlxPoint>();

		var rrr = new FlxRect(FlxG.camera.scroll.x,FlxG.camera.scroll.y,FlxG.camera.width,FlxG.camera.height);

		var me = new FlxPoint(x,y);
		var pp = new FlxPoint(GameState.player.x,GameState.player.y);
		var maxD = pp.distanceTo(me);
		
		for (pt in spots) {
			if(pt.inFlxRect(rrr)) {
				var d = pt.distanceTo(me);
				if(d < 300 && d > 100 && pt.distanceTo(pp) <= maxD) {
					ok.push(pt);
				}

			}
		}

		if(ok.length == 0) {
			t.reset(3 + Std.random(4));
			return;
		}
		
		var dest = ok[Std.random(ok.length)];
		
	
		lmTween.setMotion(x,y,dest.x-18,dest.y-47,200,false);
		lmTween.setObject(this);
		lmTween.start();
		
		flying = true;
		play("fly");
	}

	private function animCallback(animationName : String, currentFrame : Int, currentFrameIndex : Int) : Void
	{
		if(animationName == "flip" && currentFrame == 2) {
			if(facing == FlxObject.LEFT) {
				facing = FlxObject.RIGHT;
			} else {
				facing = FlxObject.LEFT;
			}
		}

	}
	
	public function landing(t : FlxTween) {
		play("default");
		flying = false;
		FlxTimer.start(3 + Std.random(4),doFly);
	}

}