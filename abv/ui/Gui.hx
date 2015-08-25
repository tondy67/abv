package abv.ui;
/**
 * Gui
 **/
import abv.bus.*;
import abv.ui.widget.Button;
import abv.ui.LG;

using abv.lib.CC;
using abv.lib.TP;

class Gui extends Root{

	public inline function new(w:Float,h:Float)
	{
		super("Gui",w,h);
		context = CC.CTX_1D;
		MS.cmCode("cmLang"); 		
	}// new()

	override function dispatch(md:MD)
	{ 	//	trace(id+": "+md);
		switch(md.msg) {
			case MD.MSG: 
				var cm = md.f[0];
				if(cm ==  MS.cmCode("cmLang")){
					setLang(md.f[1].int());
				}
		}
	}// dispatch()
	
	function setLang(lg:Int)
	{
		LG.set(lg,this);
		draw(this);
	}// setLang()
	
	public override function toString()
	{
		return "Gui";
	}// toString()

}// abv.ui.Gui

