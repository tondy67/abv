package abv.ui;
/**
 * Lang
 **/
import abv.lib.box.Container;
import abv.interfaces.IStates;

using abv.lib.CC;
using abv.lib.TP;

@:build(abv.macro.BM.buildLang())
class LG{

	public static var cur = 0;
	
	inline function new(){ }

	public static function set(lg:Int,o:Container)
	{
		if((lg < 0)||(lg > (langs.length - 1)))return;
		
		var ix = CC.ERR, s = "";

		var l = o.getChildren(); 
		for(el in l){ 
			ix = id.indexOf(el.id);
			if(ix != CC.ERR){ 
				if(Std.is(el,IStates)){
					var st = cast(el,IStates).states; 
					for(i in 0...st.length){
						s = words[ix][lg *st.length + i]; 
						if(s.good())st[i].text = s;
					}
					el.text = st[el.state].text; 
				}else{
					s = words[ix][lg];
					if(s.good()) el.text = s;
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

