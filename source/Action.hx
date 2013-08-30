package;

class Action {

	public var typ : String;
	public var conditions : Map<String,Int>;
	
	public function new(s : String) {
		typ = s;
		conditions = new Map<String,Int>();
	}


	public function execute(c : ConvoManager, n : NPC) : Bool {
		
		typ = null;
		var x = typ.length;
		return true;
	}

}