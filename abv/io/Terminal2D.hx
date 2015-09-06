package abv.io;

#if flash
	typedef Terminal2D = abv.sys.flash.Terminal2D;
#elseif (js && gui)
	typedef Terminal2D = abv.sys.jsgui.Terminal2D;
#elseif (java && gui)
	typedef Terminal2D = abv.sys.javagui.Terminal2D;
#elseif (cpp && gui)
	typedef Terminal2D = abv.sys.cppgui.Terminal2D;
#else
#end
