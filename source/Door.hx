package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

class Door extends Obj {

	public var mainS : FlxSprite;
	public var ind : Indicator;
	public var dest : String;
	public var name : String;
	public var otherDoor : String;
	public var special : Bool;
	
	public function new(x : Float, y : Float, _name : String, _dest : String, _otherDoor : String, _special : Bool = false) {

		super();
		name = _name;
		dest = _dest;
		otherDoor = _otherDoor;
		special = _special;
		
		mainS = new FlxSprite();
		mainS.setPosition(x,y);
		mainS.loadGraphic("assets/door.png",true,true,40,72);
		mainS.addAnimation("close", [0]);
		mainS.addAnimation("open", [1]);
		mainS.play("close");
		add(mainS);
		ind = new Indicator();
		add(ind);

	}
	
	public override function update()  {

		super.update();

		var dx = GameState.player.x - mainS.x;
		var dy = GameState.player.y - mainS.y;
		
		if(dx > 5 && dx < 20) {
			if(!ind.visible)
				ind.place(mainS);
			else {
				if(FlxG.keys.justPressed.Z) {
					mainS.play("open");
					GameState.player.play("default");
					GameState.player.freezeme();
					FlxTween.multiVar(GameState.player,{alpha:0.0}, 2.0, {complete : fadeCam});
				}
			}
		} else {
			ind.visible = false;
		}
		
	}

	public function fadeCam(t : FlxTween) {
		FlxG.camera.fade(0xffddffee,1,false,goto);
	}
	
	public function goto() {
		GameState.player.unfreeze();
		if(special) {
			var xx = Type.resolveClass(dest);
			var st = Type.createInstance(xx, [otherDoor]);			
			FlxG.switchState(st);
		} else {
			var st = new GameState(dest,otherDoor);
			FlxG.switchState(st);
		}
	}

}