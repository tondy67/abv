package abv.ui;
/**
 * Lang
 **/
import abv.factory.Component;
import abv.factory.IStates;
import abv.bus.MS;

using abv.sys.ST;
using abv.ds.TP;

@:build(abv.macro.BM.buildLang())
class LG{

	public static var cur = 0;
	
	public static function set(lg:Int,o:Component)
	{
		if((lg < 0)||(lg > (langs.length - 1)))return;
		
		var ix = -1, s = "";

		var l = o.getChildren(); 
		for(it in l){ 
			ix = id.indexOf(it.name);
			if(ix != -1){ 
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

