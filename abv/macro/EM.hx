package abv.macro;
/**
 * Expression Macros
 **/
import haxe.macro.Context;
import haxe.macro.Expr;
//import haxe.macro.ExprOf;

class EM {

	public static function getString(e:Expr)
	{
		return  
			switch (e.expr) {
				case EConst(c): trace(e);
					switch (c) {
						case CString(s): s;
						default: "";
					}
				default: "";
			}
	}// getString()			

	macro public static function pos()
	{
		var c = Context.getLocalClass();
		var m = Context.getLocalMethod(); 
		var r = " [" + c + "." + m + "()]"; 
		return macro $v{r}; 
	}// pos()

}// abv.macro.EM
