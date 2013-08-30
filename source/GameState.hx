package;

import flixel.util.FlxRect;
import flixel.util.FlxPoint;
import openfl.Assets;
import flash.geom.Rectangle;
import flash.net.SharedObject;

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

import Xml.XmlType;

//allow instantiation by name
import Eugene;
import Carl;
import James;
import Bird;
import Fireman;
import Blueball;
import Door;

class GameState extends FlxState
{

	static public var player : Player = null;
	static public var cManager : ConvoManager = null;
	static public var game : GameState = null;
	
	private var bg:FlxGroup;
	private var leftWall:FlxTileblock;
	private var rightWall:FlxTileblock;
	private var walls:FlxGroup;

	public var npcz:Array<NPC>;
	public var enemyz:Array<Enemy>;
	public var objz:Array<Obj>;

	private var tilemapz_no : Array<FlxTilemap>;
	private var tilemapz : Array<FlxTilemap>;

	public var xmlFilename : String;
	public var entryDoor : String;
	public var startX : Float;
	public var startY : Float;

	
	public function new(_xml : String, eDoor : String) {
		super();
		xmlFilename = _xml;
		entryDoor = eDoor;
		startX = 20;
		startY = 20;
	}
	
	/**
	   
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		if(player == null)
			player = new Player();
		if(cManager == null)
			cManager = new ConvoManager();
		game = this;
		
		npcz = new Array<NPC>();
		enemyz = new Array<Enemy>();
		objz = new Array<Obj>();
		
		tilemapz_no = new Array<FlxTilemap>();
		tilemapz = new Array<FlxTilemap>();
		
		// Set a background color
		bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		//FlxG.mouse.show();
		#end

		var ldata = Xml.parse(Assets.getText(xmlFilename)).firstElement();

		var width = Std.parseInt(ldata.get("maxx"));
		var height = Std.parseInt(ldata.get("maxy"));
		
		bg = new Background(width,height);
		add(bg);
		
		for (layer in ldata.elements()) {

			var name = layer.get("name");

			for (n in layer.elements()) {

				if(n.nodeName == "map") {
					var csv = "assets/" + n.get("csv");
					var tiles = "assets/" + n.get("tiles");
					var w = Std.parseInt(n.get("tileWidth"));
					var h = Std.parseInt(n.get("tileHeight"));
					var tmap = new FlxTilemap();
					tmap.loadMap(Assets.getText(csv),tiles,w,h);
					if(name.indexOf("Full") == 0) {
						add(tmap);
						tilemapz.push(tmap);
					} else if (name.indexOf("Top") == 0) {
						//TODO : ALL TILES SHOULD HAVE TOP COLLIDE!
						tmap.setTileProperties(1,FlxObject.UP,null,null,30);
						add(tmap);
						tilemapz.push(tmap);
					} else if (name.indexOf("No") == 0) {
						tmap.solid = false;
						add(tmap);
						tilemapz_no.push(tmap);
					}
				} else if(n.nodeName == "sprite") {
					
					var cl = n.get("class");
					var cname = n.get("name");
					var x = Std.parseFloat(n.get("x"));
					var y = Std.parseFloat(n.get("y"));

					
					if(name == "NPCs") {
						addNPC(cl,x,y,n);
					} else if(name == "Enemies") {
						addEnemy(cl,x,y);
					} else if(name.indexOf("Objs") == 0) {
						addObj(cl,cname,x,y,n);
					}
				}
				
			}
			
		}

		//Make the L/R walls
		walls = new FlxGroup();
		add(walls);		
		leftWall = new FlxTileblock(0,0,10,height);
		walls.add(leftWall);
		rightWall = new FlxTileblock(width-10,0,10,height);
		walls.add(rightWall);
		
		FlxG.camera.follow(player);
		FlxG.camera.style = FlxCamera.STYLE_PLATFORMER;

		var cW = width;
		var cX = 0;
		var cY = 0;
		var cH = height;
		if(cW < FlxG.width) {
			cW = FlxG.width;
			cX = Std.int(-(FlxG.width - width) / 2);
		}
		if(cH < FlxG.height) {
			cH = FlxG.height;
			cY = Std.int(-(FlxG.height - height) / 2);
		}
		FlxG.camera.bounds = new FlxRect(cX,cY,cW,cH);

		FlxG.worldBounds.set(0, 0, width, height);		

	
		add(cManager);
		add(player);		

		player.setPosition(startX,startY);
		
		super.create();
		FlxG.camera.fade(0xffddffee,1,true);
	}

	public function addNPC(name : String, x : Float, y : Float, n : Xml) {
		var xx = Type.resolveClass(name);
		var npc : NPC = cast(Type.createInstance(xx, [x,y]));

		for (prop in n.firstElement().elements()) {
			if(prop.get("name") == "script") {
				npc.loadActions("assets/" + prop.get("value"));
			}	
		}
		
		add(npc);
		npcz.push(npc);
	}
	
	public function addEnemy(name : String, x : Float, y : Float) {
		var xx = Type.resolveClass(name);
		var een : Enemy = cast(Type.createInstance(xx, [x,y]));
		add(een);
		enemyz.push(een);
	}

	public function addObj(cl : String, name : String, x : Float, y : Float, n : Xml) {
		

		var obj : Obj = null;
		
		if(cl == "Door") {

			var dStr = "";
			var dDoor = "";
			var special = false;
			
			for (prop in n.firstElement().elements()) {
				if(prop.get("name") == "dest") {
					dStr = "assets/" + prop.get("value");
				}
				if(prop.get("name") == "destC") {
					dStr = prop.get("value");
					special = true;
				}
				if(prop.get("name") == "destD") {
					dDoor = prop.get("value");
				}	
			}

			obj = new Door(x,y,name,dStr,dDoor,special);
			if(name == entryDoor) {
				startX = x+10;
				startY = y;
			}
			
		} else if (cl == "Plain") {
			for (prop in n.firstElement().elements()) {
				if(prop.get("name") == "img") {
					obj = new Plain(x,y,prop.get("value"));
				}	
			}
		} else {
			var xx = Type.resolveClass(cl);
			obj = Type.createInstance(xx, [x,y]);
		}

		add(obj);
		objz.push(obj);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		player = null;
		cManager = null;
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		
		super.update();

		/**
		if(FlxG.keys.justPressed("Q")){
			Sys.println(player.x + ", " + player.y);
		}
		*/


		for (t in tilemapz) {
			FlxG.collide(t, player);
		}
		
		FlxG.collide(walls, player);

		
		for (e in enemyz) {
			if(e.fullPhys) {
				for (t in tilemapz) {
					FlxG.collide(t, e);
				}
			}
			FlxG.collide(player,e,Enemy.collideF);
		}

		if(!cManager.inConvo) {
			player.updatePlayer();
		}
		
		for (npc in npcz) {
			if(player.x < npc.x) {
				npc.mainSprite.facing = FlxObject.LEFT;
			} else {
				npc.mainSprite.facing = FlxObject.RIGHT;
			}
		}
		
		cManager.talkTarg = null;
		if(player.isTouching(FlxObject.FLOOR)) {
			for (npc in npcz) {
				if(Math.abs(npc.y - player.y) < 20) {
					var xdist = Math.abs(npc.x - player.x);
					if (xdist > 20 && xdist < 60) {
						if((npc.x < player.x && player.facing == FlxObject.LEFT) ||
						(npc.x > player.x && player.facing == FlxObject.RIGHT)) {
							cManager.talkTarg = npc;
						}		   
					}
				}
			}
		}


		if(cManager.inConvo && !cManager.noInput) {
			if(cManager.choosing) {
				if(FlxG.keys.justPressed.UP){
					cManager.incChoice(-1);
				}
				if(FlxG.keys.justPressed.DOWN){
					cManager.incChoice(1);
				}
				if(FlxG.keys.justPressed.Z){
					cManager.makeChoice();
				}
				if(FlxG.keys.justPressed.X){
					cManager.endConvo();
				}
			} else {			 
				if(FlxG.keys.justPressed.Z) {
					while(cManager.curNPC.getNext()){
						//do nothing
					}
				}
				
				if(FlxG.keys.justPressed.X) {
					cManager.endConvo();
				}
			}
		} else {
			if(cManager.talkTarg != null && !cManager.inConvo) {
				//display indicator

				if(!cManager.indicator.visible) 
					cManager.indicator.place(cManager.talkTarg.mainSprite);
				
				if(FlxG.keys.justPressed.Z) {
					cManager.startConvo();
				}			
			} else {
				cManager.indicator.visible = false;
			}

		}

	
	}


		
}