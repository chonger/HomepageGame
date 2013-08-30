package;

#if js
import js.Lib;
#else
import flash.Lib;
import flash.net.URLRequest;
#end

class Linker
{	
	
	static public function go(dest: String) {
		
		#if js
		Lib.eval("window.open(\"" + dest + "\",\"_blank\");");
		#else
		flash.Lib.getURL(new URLRequest(dest),"_top" );
		#end
	}

}