package abv.ds;

#if flash
	typedef FS = abv.sys.flash.FS;
#elseif (js && gui)
	typedef FS = abv.sys.jsgui.FS;
#elseif (java && gui)
	typedef FS = abv.sys.javagui.FS;
#elseif (cpp && gui)
	typedef FS = abv.sys.cppgui.FS;
#else
#end

