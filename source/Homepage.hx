package;

import flixel.util.FlxRect;
import flixel.util.FlxPoint;
import openfl.Assets;
import flash.geom.Rectangle;
import flash.net.SharedObject;
import flash.text.TextFormat;

import flixel.FlxG;
import flixel.util.FlxPath;
import flixel.util.FlxSave;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.tile.FlxTileblock;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSpriteUtil;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;


//allow instantiation by name
import Eugene;
import Carl;
import James;
import Bird;
import Fireman;
import Blueball;
import Door;

class Homepage extends FlxState
{


	
	private var bg:FlxSprite;
	private var walls:FlxGroup;
	
	public var lHalf :FaceHalf;
	public var rHalf :FaceHalf;

	public var plat : FlxSprite;

	public var linx : FlxGroup;

	public var started : Bool;
	public var doorin : Bool;

	public var self : NPC;

	public var door : Door;

	public var opening : Bool;


	public function new(ds : String = null) {
		super();
		if(ds == null)
			opening = true;
		else
			opening = false;
	}
	
	/**
	   
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{

		if(GameState.player == null)
			GameState.player = new Player();
		if(GameState.cManager == null)
			GameState.cManager = new ConvoManager();

		started = false;
		doorin = false;

		
		// Set a background color
		bgColor = 0xffffffff;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		//FlxG.mouse.show();
		#end

		var width = 800;
		var height = 600;

		bg = new FlxSprite();
		bg.makeGraphic(800,600,0xffffffff);
		add(bg);

		FlxSpriteUtil.drawLine(bg,10,190,300,190,0xffaaaaaa,4);
		FlxSpriteUtil.drawLine(bg,500,190,790,190,0xffaaaaaa,4);
		FlxSpriteUtil.drawLine(bg,10,580,790,580,0xffaaaaaa,4);
		
		//Make the L/R walls
		walls = new FlxGroup();
		add(walls);		
		var leftWall = new FlxTileblock(10,0,10,height);
		walls.add(leftWall);
		var rightWall = new FlxTileblock(width-10,0,10,height);
		walls.add(rightWall);
		var topL = new FlxTileblock(0,190,300,20);
		walls.add(topL);
		var topR = new FlxTileblock(500,190,300,20);
		walls.add(topR);
		var bottom = new FlxTileblock(0,580,width,20);
		walls.add(bottom);		
		
		FlxG.camera.bounds = new FlxRect(0,0,width,height);
		FlxG.worldBounds.set(0, 0, width, height);		

		lHalf = new FaceHalf();
		rHalf = new FaceHalf();

		if(opening) {
			lHalf.setPosition(20,20);
			rHalf.setPosition(95,20);
		} else {
			lHalf.setPosition(0,20);
			rHalf.setPosition(115,20);
		}
		lHalf.play("L");
		rHalf.play("R");
		var blackBack = new FlxSprite();
		blackBack.makeGraphic(40,150,0xff000000);
		blackBack.setPosition(75,20);
		add(blackBack);
		add(lHalf);
		add(rHalf);


		plat = new FlxSprite();
		plat.makeGraphic(210,10,0x00000000);
		FlxSpriteUtil.drawLine(plat,3,2,294,2,0xffaaaaaa,4);
		plat.setPosition(295,188);

		if(opening) {
			add(plat);
			plat.immovable = true;
			plat.allowCollisions = FlxObject.UP;
		}
		
		linx = new FlxGroup();

		var fff = true;
		if(opening)
			fff = false;
		
		linx.add(new LinkText(80,210,"Work Related",true));
		linx.add(new LinkText(100,240,"Publications",false,fff));
		linx.add(new LinkText(100,270,"Software",false,fff));
		linx.add(new LinkText(100,300,"Teaching",false,fff));
		linx.add(new LinkText(100,330,"Datasets",false,fff));

		linx.add(new LinkText(480,210,"Personal",true));
		linx.add(new LinkText(500,240,"Paint",false,fff));
		linx.add(new LinkText(500,270,"Music",false,fff));
		linx.add(new LinkText(500,300,"Photos",false,fff));
		linx.add(new LinkText(500,330,"Recipes",false,fff));
		linx.add(new LinkText(500,360,"Games",false,fff));

		add(linx);

		var infoT = new FlxText(190,30,400,"Ben Swanson\nPhD Candidate, Brown University\nAdvisor: Eugene Charniak\nEmail: chonger <> cs.brown.edu");
		infoT.setFormat("assets/times.ttf",20,0xff000000);
		add(infoT);

		door = new Door(720,507,"D","assets/backstge/Level_Group1.xml","Door1");
		if(opening) {
			door.mainS.alpha = 0.0;
		}
		add(door);

		if(opening) {
			GameState.player.setPosition(88,100);
			GameState.player.alpha = 0.0;
			GameState.player.freezeme();
			FlxTimer.start(2,startFlicker);
			FlxTimer.start(6,openDoor);
		} else {
			GameState.player.setPosition(door.mainS.x + 10,door.mainS.y);
			started = true;
		}

		add(GameState.cManager);
		add(GameState.player);
		self = new NPC();
		self.loadActions("assets/Homepage/monolog.xml");

		super.create();
	}

	public function openDoor(t : FlxTimer) {

		FlxTween.linearMotion(lHalf,lHalf.x,lHalf.y,lHalf.x - 20,lHalf.y,3,true,{complete:fadeMeIn});
		FlxTween.linearMotion(rHalf,rHalf.x,rHalf.y,rHalf.x + 20,rHalf.y,3);
		
	}

	public function fadeMeIn(t : FlxTween) {

		FlxTween.multiVar(GameState.player,{alpha:1.0}, 2.0, {complete : startIt});
		
	}

	public function startIt(t : FlxTween) {
		GameState.player.unfreeze();
	}

	public function startFlicker(t : FlxTimer) {

		for (l in linx.members) {
			var ll = cast(l,LinkText);
			if(!ll.header) {
				ll.flick();
			}
		}
		
	}

	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		GameState.player = null;
		GameState.cManager = null;
		remove(GameState.player);
		remove(GameState.cManager);
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		
		super.update();

		if(started) {
			if(GameState.cManager.inConvo) {
				if(FlxG.keys.justPressed.Z) {
					while(GameState.cManager.curNPC.getNext()){
						//do nothing
					}
					
				}
			} else {
				if(!doorin) {
					FlxTween.multiVar(door.mainS,{alpha:1.0}, 2.0);
					doorin = true;
				}
			}
		}
		
		//do collision
		FlxG.collide(GameState.player,walls);
		FlxG.collide(GameState.player,plat);

		if(!GameState.cManager.inConvo) {
			GameState.player.updatePlayer();	
		}
		
		if(!started && GameState.player.justTouched(FlxObject.FLOOR)) {

			self.x = GameState.player.x + 100;
			self.y = GameState.player.y;

			GameState.cManager.talkTarg = self;
			GameState.cManager.startConvo();
			started = true;
			
		}


		
		if(plat.justTouched(FlxObject.UP))
			plat.velocity.y = 30;
		
	}
}

class FaceHalf extends FlxSprite {

	public function new() {
		super();
		loadGraphic("assets/Homepage/face.png",true,false,75,150);
		addAnimation("L", [0], false);
		addAnimation("R", [1], false);
	}

}

class LinkText extends FlxText {

	public var header : Bool;
	
	public function new(x : Float, y : Float, s : String, _header : Bool = false, faded : Bool = false) {
		super(x,y,300,s);
		header = _header;
		if(header)
			setFormat("assets/times.ttf",20,0xff000000);
		else {
			if(faded) {
				setFormat("assets/times.ttf",18,0xffcccccc);
			} else {
				setFormat("assets/times.ttf",18,0xff0000ff);		
				_format.underline = true;
				_textField.defaultTextFormat = _format;
				updateFormat(_format);
				_regen = true;
			}
		}
		
	}

	public function flick() {
		var t = Std.random(30) / 10.0;
		FlxTimer.start(1 + t,doFlick);
	}

	public function doFlick(t : FlxTimer) {
		FlxSpriteUtil.flicker(this,2,.05);
		setFormat("assets/times.ttf",18,0xffcccccc);
	}
	
}