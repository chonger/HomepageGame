package;

import org.flixel.FlxSprite;
import org.flixel.FlxGroup;
import org.flixel.util.FlxPoint;
import org.flixel.FlxParticle;
import org.flixel.FlxEmitter;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.display.BlendMode;

class Midground extends FlxGroup
{
	private var fill:FlxSprite;
	private var fader:FlxSprite;
	
	public function new() {
		super();

		fill = new FlxSprite();
		fill.x = 0;
		fill.y = 1100;
		fill.makeGraphic(2240,500,0x00000000);
		fill.scrollFactor = new FlxPoint(.6, 1);
		fill.blend = BlendMode.LAYER;
		add(fill);

		//fader = new FlxSprite();
		//fader.makeGraphic(2240,500,0x88000000);
		//fader.blend = BlendMode.ALPHA;

	}

	public override function draw() {

		fill.alpha = .2;
		
		super.draw();

		//fill.stamp(fader,0,0);
		
		//ill.pixels.colorTransform(new Rectangle(2240,500),new ColorTransform(1.0,1.0,1.0,.01));
		//fader.draw();
		fill.drawLine(Std.random(2240),Std.random(550),Std.random(2240),Std.random(550),0xff00ff00,10);
		
		
		
	}

}