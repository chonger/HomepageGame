package;


class Trigger extends Action {

	public var txt : String;
	
	public function new(atxt : String) {
		super("TRIG");
		txt = atxt;
	}

	public override function execute(c : ConvoManager, n : NPC) : Bool {
		if(txt == "END") {
			c.endConvo();
			return false;
		} else {
			n.cur = n.myTrigs.get(txt).copy();
			return true;
		}
	}
}
