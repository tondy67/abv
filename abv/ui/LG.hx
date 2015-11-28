package abv.ui;
/**
 * Lang
 **/
import abv.lib.box.Container;
import abv.interfaces.IStates;
import abv.bus.MS;

using abv.lib.CC;
using abv.ds.TP;

@:build(abv.macro.BM.buildLang())
class LG{

	public static var cur = 0;
	
	inline function new(){ }

	public static function set(lg:Int,o:Container)
	{
		if((lg < 0)||(lg > (langs.length - 1)))return;
		
		var ix = CC.ERR, s = "";

		var l = o.getChildren(); 
		for(it in l){ 
			ix = id.indexOf(it.name);
			if(ix != CC.ERR){ 
				if(Std.is(it,IStates)){
					var st = cast(it,IStates).states; 
					for(i in 0...st.length){
						s = words[ix][lg *st.length + i]; 
						if(s.good())st[i].text = s;
					}
					it.text = st[it.state].text; 
				}else{
					s = words[ix][lg];
					if(s.good()) it.text = s;
				}
			}
		}
		cur = lg;

	}// set()

	public static function get(w:String)
	{
		var ix = id.indexOf(w);
		return words[ix][cur]; 
	}//
	
}// abv.ui.LG

