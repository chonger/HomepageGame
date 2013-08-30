package;

import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;
import flixel.tweens.motion.LinearMotion;
import flixel.tweens.misc.NumTween;
import flixel.tweens.FlxTween;

class LinkNPC extends NPC {

	var makeLink : Bool;
	var linkMade : Bool;
	var linkSprite : FlxSprite;
	var blank : FlxSprite;
	var linkMask : FlxSprite;
	var linkImg : FlxSprite;
	var makeInd : Int;
	var txt : FlxText;
	var cSize : NumTween;
	
	public function new(linkText : String, url : String) {
		super();

		linkMask = new FlxSprite();
		linkMask.makeGraphic(200,200,0x00000000,true);
		
		blank = new FlxSprite();
		blank.makeGraphic(200,200,0x00000000,true);
		
		linkImg = new FlxSprite();
		linkImg.loadGraphic("assets/linkball.png");
				
		linkSprite = new FlxSprite();
		linkSprite.makeGraphic(200,200,0x00000000,true);
		linkSprite.visible = false;
		linkMade = false;
		makeLink = false;

		txt = new FlxText(0,0,200,"Papers",18);
		txt.alignment = "center" ;
		txt.color = 0xff000000;
		txt.visible = false;

		
		add(linkSprite);
		add(txt);	

		
	}

	public function initLink() {
		txt.visible = false;
		linkSprite.x = x - 88;
		linkSprite.y = x -68;
		linkSprite.visible = false;
		makeLink = false;
	}
	
	public override function nextHook() : Bool { 
		if(makeLink) {
			//TODO : follow the link!
			return true;
		} else {
			return false;
		}
	}

	public override function endHook() : Bool {
		if(makeLink) {
			cSize.cancel();
			initLink();
		}
		mainSprite.play("default");
		return true;
	}

	public function startLink() {

		GameState.cManager.cleanBubs();
		
		makeLink = true;
		linkSprite.visible = true;
			
		FlxTween.linearMotion(linkSprite,x-88,y-68,x-88,y - 268,5);
		
		cSize = new NumTween(endMakeLink);
		cSize.tween(4,100,5);
		FlxTween.manager.add(cSize,true);


	}

	private function endMakeLink(t : FlxTween) : Void {
		cSize = new NumTween(null,FlxTween.PINGPONG);
		cSize.tween(100,90,2);
		FlxTween.manager.add(cSize,true);
		
		txt.visible = true;
		txt.x = linkSprite.x ;
		txt.y = linkSprite.y + 80;
	}

	
	public override function draw() {
		super.draw();
		
		if(makeLink) {
			//linkMask.pixels.clear(0x00000000);
			FlxSpriteUtil.drawCircle(linkMask,100,100,cSize.value,0xffffffff);
			FlxSpriteUtil.alphaMaskFlxSprite(linkImg,linkMask,linkSprite);
		}
		
	}
	

}