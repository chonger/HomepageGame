package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxGradient;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter;


class Background extends FlxGroup
{
	/**
	private var emitter:FlxEmitter;
	*/
	private var fill:FlxSprite;
	
	public function new(w : Int, h : Int) {
		super();

		var colors = new Array<Int>();
		colors.push(0xff000000);
		colors.push(0xff000023);
		colors.push(0xff204083);
		colors.push(0xffa000f3);
		fill = FlxGradient.createGradientFlxSprite(w,h,colors);
		fill.x = 0;
		fill.y = 0;
		//fill.scrollFactor = new FlxPoint(.4, .4);

		add(fill);

		/**
		emitter = new FlxEmitter(0,0); //x and y of the emitter
		emitter.setSize(2000,3);
		emitter.setYSpeed(120,130);
		emitter.setXSpeed(-4,4);
		emitter.setRotation(0,.2);

		var particles:Int = 1000;
			
		for(i in 0 ... particles)
			{
				var particle = new FlxParticle();
				particle.makeGraphic(2, 2);
				emitter.add(particle);
			}

		
		add(emitter);
		emitter.start(false,200,.05);
		*/
	}

}