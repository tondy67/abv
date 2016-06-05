package abv;
/**
 * Boot
 **/

@:build(abv.macro.BM.buildBoot())
class Boot{

#if (ios || engine)
	static var ready = false;
@:headerCode
	public static function update()
	{ 
		if(!ready && (app != null))ready = true; 
		if(ready)app.update();
		return app.term.listRender;
	}// update()
	
@:headerCode
	public static function resize(w:Int,h:Int)
	{ 
		AM.colors = false;
		AM.WIDTH  = w;
		AM.HEIGHT = h; 
		if(ready)app.onResize();		
	}// setSize()
	
@:headerCode
	public static function getText(id:Int)
	{
		var r = "";
		if(ready && (id >= 0) && (id < app.term.renderText.length))
			r = app.term.renderText[id];
		return r;
	}// getText()
	
@:headerCode
	public static function onMouseDown(x:Int,y:Int)
	{ 
		if(ready)app.term.onMouseDown(x,y); 
	}
	
@:headerCode
	public static function onMouseUp(x:Int,y:Int)
	{ 
		if(ready)app.term.onMouseUp(x,y);
	}
	
@:headerCode
	public static function onKeyDown(key:Int)
	{ 
		if(ready)app.term.onKeyDown(key);
	}
	
@:headerCode
	public static function onKeyUp(key:Int)
	{ 
		if(ready)app.term.onKeyUp(key);
	}

@:headerCode
	public static function test(v=0)
	{
//		trace(v);
		return v + 56;
	}// test()
#end
}// abv.Boot

