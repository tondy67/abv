package abv.io;

#if (ios || engine)
	typedef Terminal2D = abv.sys.engine.Terminal2D;
#elseif flash
	typedef Terminal2D = abv.sys.flash.Terminal2D;
#elseif (js && gui)
	typedef Terminal2D = abv.sys.jsgui.Terminal2D;
#elseif android
	typedef Terminal2D = abv.sys.android.Terminal2D;
#elseif (java && gui)
	typedef Terminal2D = abv.sys.javagui.Terminal2D;
#elseif (cpp && gui)
	typedef Terminal2D = abv.sys.cppgui.Terminal2D;
#else
#end
