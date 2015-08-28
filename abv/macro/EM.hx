package abv.macro;
/**
 * Expression Macros
 **/
import haxe.macro.Context;
import haxe.macro.Expr;

class EM {

	static function getString(e:Expr)
	{
		return  
			switch (e.expr) {
				case EConst(c):
					switch (c) {
						case CString(s): s;
						default: "";
					}
				default: "";
			}
	}// getString()			

}// abv.macro.EM
