package;
	
class Blueball extends Enemy
{	

	public function new(xx : Float, yy : Float)
	{
		super();
		loadGraphic("assets/blueball.png",true,false,32,32);
		addAnimation("spin", [0,1,2,3,4,6,6,5], 13, true);
		play("spin");
		setPosition(xx,yy);
	}


}