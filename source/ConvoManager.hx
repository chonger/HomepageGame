package;


import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.tweens.motion.LinearMotion;
import flixel.tweens.FlxTween;

class ConvoManager extends FlxGroup {

	public var pSpeechX : Int;
	public var tSpeechX : Int;
	public var speechY: Int;
	public var sbubs : Array<SpeechBubble>;
	public var inConvo:Bool;
	public var curNPC:NPC;
	public var focusObj:FlxSprite;

	public var choosing : Bool;
	public var curTargs : Array<String>;
	public var choiceBubs : Array<SpeechBubble>;
	public var choiceSel : Int;
	public var choiceSelWant : Int;
	public var choiceSpr : FlxSprite;
	public var tmpBub : SpeechBubble;

	public var noInput : Bool;

	public var props : Map<String,Int>;

	public var talkTarg:NPC;
	public var indicator:Indicator;
	
	public function new() {
		super();

		noInput = false;

		inConvo = false;

		sbubs = new Array<SpeechBubble>();

		//a place to focus during convo
		focusObj = new FlxSprite();
		focusObj.visible = false;
		focusObj.makeGraphic(40,40,0xffff0000);
		add(focusObj);

		choosing = false;
		choiceSpr = new FlxSprite();
		choiceSpr.makeGraphic(40,40,0xffffffff);
		choiceSpr.visible = false;
		add(choiceSpr);
		
		props = new Map<String,Int>();
		talkTarg = null;

		indicator = new Indicator();
		add(indicator);
	}

	public function checkCondition(conditions : Map<String,Int>) {
		for (x in conditions.keys()) {
			if(conditions[x] == 1 && !props.exists(x)) {
				return false;
			}
			if(conditions[x] == 0 && props.exists(x)) {
				return false;
			}
		}
		return true;
	}

	public function cleanBubs() {
		for (sb in sbubs){
			remove(sb);
			sb.destroy();
		}

		while(sbubs.length > 0) {
			sbubs.pop();
		}
	}
	
	public function endConvo() : Void {
		inConvo = false;

		cleanBubs();

		curNPC.endHook();
	
		curNPC = null;

		FlxG.camera.style = FlxCamera.STYLE_PLATFORMER;
		FlxG.camera.follow(GameState.player,0,null,50);

		if(GameState.game != null) {
			for (e in GameState.game.enemyz) {
				e.unpause();
			}
		}
	}

	
	public function startConvo() : Void {

		indicator.visible = false;
		
		var npc : NPC = talkTarg;

		if(GameState.game != null) {
			for (e in GameState.game.enemyz) {
				e.pause();
			}
		}
		
		inConvo = true;

		var pX = GameState.player.x + GameState.player.width/2;
		var nX = npc.x + npc.mainSprite.width/2;
		
		var midP : Int = 0;

		var off = Std.int(.1 * SpeechBubble.bubWidth); 
		
		if(nX > pX) {
			midP = Std.int(pX + (nX - pX)/2);
			pSpeechX = midP - 5*off;
			tSpeechX = midP - 3*off;
		}
		if(nX < pX) {
			midP = Std.int(nX + (pX - nX)/2);
			pSpeechX = midP - 3*off;
			tSpeechX = midP - 5*off;
		}
		
		focusObj.x = midP+200;
		focusObj.y = GameState.player.y-150;
		FlxG.camera.style = FlxCamera.STYLE_LOCKON;
		FlxG.camera.follow(focusObj,0,null,50);

		speechY = Std.int(GameState.player.y - 10);
		

		curNPC = npc;
		npc.initConv();
		
		while(npc.getNext()) {
			//do nothing
		}
	}

	public function addSpeech(isPlayer : Bool, txt : String) {
		var x = Std.int(tSpeechX);
		var c = SpeechBubble.GREEN;

		if(isPlayer) {
			x = Std.int(pSpeechX);
			c = SpeechBubble.BLUE;
		}
		
		var sb = new SpeechBubble(x,0,txt,c);

		sbubs.insert(0,sb);
		add(sb);

		var accum = 0;
		for (asb in sbubs) {
			var myH = Std.int(asb.bg.height);
			asb.bg.y = speechY - accum - myH;
			accum += myH + 5;
		}
	}

	
	public function choice(c : Choice) {
		
		choosing = true;

		choiceBubs = new Array<SpeechBubble>();
		choiceSel = -1;
		choiceSelWant = 0;

		var clr = 0xffffffff;

		var choiceX = Std.int(FlxG.camera.scroll.x + FlxG.camera.width - 300);

		//filter by conditions
		curTargs = new Array<String>();
		for (i in 0 ... c.strs.length) {
			var ok : Bool = checkCondition(c.choiceConds[i]);
			if(ok) {			
				var s = c.strs[i];
				curTargs.push(c.targs[i]);
				var sb = new SpeechBubble(choiceX,0,s,clr);
				choiceBubs.push(sb);
				add(sb);
			}
		}
		
		var accum = Std.int(FlxG.camera.scroll.y + 100);
		for (asb in choiceBubs) {
			var myH = Std.int(asb.bg.height);
			asb.bg.y = accum;
			accum += myH + 40;
		}

		choiceSpr.visible = true;
		choiceSpr.x = choiceX - 60;

		update();
	}

	public override function update() {

		if(choiceSel != choiceSelWant) {
			//move indicator

			choiceSel = choiceSelWant;
			choiceSpr.y = choiceBubs[choiceSel].bg.y;
			
		}
		
		super.update();
	}

	public function incChoice(n : Int) {
		choiceSelWant += n;
		if(choiceSelWant < 0) {
			choiceSelWant = 0;
		}
		if(choiceSelWant >= choiceBubs.length) {
			choiceSelWant = choiceBubs.length-1;
		}
	}

	public function makeChoice() {

		//clone the one we want
		var chosenBub = choiceBubs[choiceSel];

		for (c in  choiceBubs) {
			c.visible = false;
		}
		choiceSpr.visible = false;
		
		tmpBub = new SpeechBubble(Std.int(chosenBub.bg.x),Std.int(chosenBub.bg.y),chosenBub.txt.text,SpeechBubble.BLUE);

		add(tmpBub);

		var lm = new LinearMotion(resume);
		lm.setMotion(tmpBub.bg.x,tmpBub.bg.y,GameState.player.x,GameState.player.y - 50,.5);
		lm.setObject(tmpBub.bg);
		FlxTween.manager.add(lm,true);
		noInput = true;

	}

	public function resume(tw : FlxTween) {
		
		var chosenTarg = curTargs[choiceSel];

		addSpeech(true,choiceBubs[choiceSel].txt.text);
		
		choosing = false;

		remove(tmpBub);
		tmpBub.destroy();

		for (c in  choiceBubs) {
			remove(c);
			c.destroy();
		}
		
		curNPC.cur.push(new Trigger(chosenTarg));
		noInput = false;
	}

	
}