package;


import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxPath;
import flixel.FlxObject;

class MovingTextPlatform extends FlxGroup {

	var txt:FlxText;
	public var box:FlxSprite;
	var path:FlxPath;
	var glow:Bool;
	
	public function new(xx : Float, yy : Float, ss : String)
	{
		super();

		glow = false;
		
		var x = xx;
		var y = yy;
		
		txt = new FlxText(x,y,ss.length * 20,ss);
		txt.setFormat("assets/MetalMacabre.ttf", 24);
		txt.centerOffsets();
		txt.alignment = "center";
		txt.color = 0xffe3554a;
		txt.shadow = 0xff000000;
		txt.useShadow = true;
		
		box = new FlxSprite();
		box.width = txt.width;
		box.height = 35;
		box.x = x;
		box.y = y+10;
		box.makeGraphic(Std.int(box.width),Std.int(box.height),0xffffaaaa);
		box.centerOffsets();
		add(box);
		add(txt);
		box.immovable = true;

		path = new FlxPath();
		path.add(box.x+box.width/2,box.y+box.height/2);
		path.add(box.x+box.width/2,box.y+box.height/2-100);
		box.followPath(path,15,FlxPath.YOYO);
		
	}

	public override function update() : Void
	{
		super.update();
		txt.x = box.x;
		txt.y = box.y-12;
	}
	

}