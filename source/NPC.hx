package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import openfl.Assets;

class NPC extends FlxSpriteGroup {


	public var myTrigs : Map<String,Array<Action> >;
	public var cur : Array<Action>;
	public var inStr : String;
	public var mainSprite : FlxSprite;

	public function new() {
		super();
		cur = null;
		myTrigs = new Map();
		mainSprite = new FlxSprite();
		inStr = "INIT";
	}

	public function initConv() {
		new Trigger(inStr).execute(GameState.cManager,this);
	}
	
	public function loadActions(filename : String) {

		var script = Xml.parse(Assets.getText(filename));

		for (trig in script.firstElement().elements()) {

			var tStr = trig.get("id");

			var actV = new Array<Action>();			

			for (act in trig.elements()) {
				var aStr = act.get("id");
				var a : Action = new Trigger("FAIL");

				if(aStr == "SAY") {
					a = new Say(StringTools.trim(act.firstChild().toString()));
				} else if (aStr == "PSAY") {
					a = new PSay(StringTools.trim(act.firstChild().toString()));
				} else if (aStr == "END") {
					a = new Trigger("END");
				} else if (aStr == "SETVON") {
					a = new SetV(StringTools.trim(act.firstChild().toString()),true);
				} else if (aStr == "SETVOFF") {
					a = new SetV(StringTools.trim(act.firstChild().toString()),false);
				} else if (aStr == "TRIG") {
					a = new Trigger(StringTools.trim(act.firstChild().toString()));
				} else if (aStr == "CHGIN") {
					a = new ChangeIn(StringTools.trim(act.firstChild().toString()));
				} else if (aStr == "SPECIAL") {
					a = new Special(StringTools.trim(act.firstChild().toString()));
				} else if (aStr == "CHOICE") {
					
					var strs = new Array<String> ();
					var targs = new Array<String> ();
					var conds = new Array<Map<String,Int> >();
					
					for (opt in act.elements()) {
						strs.push(StringTools.trim(opt.firstChild().toString()));
						targs.push(opt.get("targ"));
						var m = new Map<String,Int>();
						if(opt.exists("yCond"))
							m[opt.get("yCond")] = 1;
						if(opt.exists("nCond"))
							m[opt.get("nCond")] = 0;
						conds.push(m);
					}
					
					a = new Choice(strs,targs,conds);
					
				}

				if(act.exists("yCond"))
					a.conditions[act.get("yCond")] = 1;
				if(act.exists("nCond"))
					a.conditions[act.get("nCond")] = 0;
				
				actV.push(a);
				
			}			

			myTrigs.set(tStr,actV);
		}

	}

	public function endHook() : Bool {
		return false;
	}
	
	public function nextHook() : Bool {
		//return true if we should abort getting next
		return false;
	}


	public function getNext() : Bool {

		//return true if we should skip and evaluate the next one
		
		if(nextHook())
			return false;
		
		if(cur.length == 0)
			return false;
		
		var c = cur.shift();
		
		if(!GameState.cManager.checkCondition(c.conditions))
			return true;

		return c.execute(GameState.cManager,this);
	}

	
	public function special(inS : String) : Bool {
		//do nothing
		return true;
	}

	
	override public function draw():Void
	{
		var i:Int = 0;
		var basic:IFlxSprite = null;

		while (i < length)
		{
			basic = _members[i++];

			if ((basic != null) && basic.exists && basic.visible)
			{
				basic.draw();
			}
		}
	}

	override public function update():Void
	{
		var i:Int = 0;
		var basic:IFlxSprite = null;

		while (i < length)
		{
			basic = _members[i++];

			if ((basic != null) && basic.exists && basic.visible)
			{
				basic.update();
			}
		}
	}
	
}


class Say extends Action {

	public var txt : String;
	
	public function new(atxt : String) {
		super("SAY");
		txt = atxt;
	}
	
	public override function execute(c : ConvoManager, n : NPC) : Bool {
		c.addSpeech(false,txt);
		if(n.mainSprite.getAnimation("talk") != null)
			n.mainSprite.play("talk");
		return false;
	}
}

class PSay extends Action {

	public var txt : String;
	
	public function new(atxt : String) {
		super("PSAY");
		txt = atxt;
	}

	public override function execute(c : ConvoManager, n : NPC) : Bool {
		c.addSpeech(true,txt);

		if(n.mainSprite.getAnimation("default") != null)
			n.mainSprite.play("default");
		return false;
	}

}


class ChangeIn extends Action {

	public var txt : String;
	
	public function new(atxt : String) {
		super("CHGIN");
		txt = atxt;
	}

	public override function execute(c : ConvoManager, n : NPC) : Bool {
		n.inStr = txt;
		return true;
	}
}

class Special extends Action {

	public var txt : String;
	
	public function new(atxt : String) {
		super("SPECIAL");
		txt = atxt;
	}

	public override function execute(c : ConvoManager, n : NPC) : Bool {
		return n.special(txt);
	}

}


class SetV extends Action {

	public var txt : String;
	public var onoff : Bool;
	
	public function new(key : String, v : Bool) {
		super("SETV");
		txt = key;
		onoff = v;
	}
	
	public override function execute(c : ConvoManager, n : NPC) : Bool {
		if(onoff)
			c.props[txt] = 0;
		else
			c.props.remove(txt);
		return true;
	}
}





