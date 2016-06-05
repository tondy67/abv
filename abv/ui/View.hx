package abv.ui;
/**
 * View
 **/
#if (ios || engine)
	typedef View = abv.sys.engine.ui.View;
#elseif flash
	typedef View = abv.sys.flash.ui.View;
#elseif js
	typedef View = abv.sys.js.ui.View;
#elseif android
	typedef View = abv.sys.android.ui.View;
#elseif java
	typedef View = abv.sys.java.ui.View;
#elseif (neko || cpp)
	typedef View = abv.sys.cpp.ui.View;
#end

