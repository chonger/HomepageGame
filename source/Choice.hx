package;


class Choice extends Action {

	public var strs : Array<String>;
	public var targs : Array<String>;
	public var choiceConds : Array<Map<String,Int> >;
	
	public function new(_strs : Array<String>, _targs : Array<String>, _conds : Array<Map<String,Int> >) {
		super("CHOICE");
		strs = _strs;
		targs = _targs;
		choiceConds = _conds;
	}

	public override function execute(c : ConvoManager, n : NPC) : Bool {
		c.choice(this);
		return false;
	}

	
}