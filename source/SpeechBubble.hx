package;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxSpriteUtil;

class SpeechBubble extends FlxGroup
{

	public var bg:FlxSprite;
	public var txt:FlxText;
	public static var bubWidth:Int = 250;
	public static var BLUE:Int = 0xff8283ff;
	public static var GREEN:Int = 0xff82ff83;
	public static var DARKB:Int = 250;
	public var immovable : Bool;
	
	public function new(x : Int, y : Int, str : String, color : Int) {

		super();

		immovable = false;
		bg = new FlxSprite();
		txt = new FlxText(x+4,y+2,bubWidth,str,12);
		txt.color = 0xff000000;
		var hh = Std.int(txt.height);
		
		bg.x = x;
		bg.y = y;

		bg.makeGraphic(bubWidth,hh,0x00000000,true);

		FlxSpriteUtil.drawRoundRect(bg,0,0,bubWidth,hh,10,10,color);
		
		add(bg);
		add(txt);
	}

	public override function update() {
		super.update();
		txt.x = bg.x + 4;
		txt.y = bg.y + 2;
		super.update();

	}
	

}