package abv.ds;

#if (flash && engine)
	typedef FS = abv.sys.flash.FS;
#elseif (ios || engine)
	typedef FS = abv.sys.engine.FS;
#elseif flash
	typedef FS = abv.sys.flash.FS;
#elseif (js && gui)
	typedef FS = abv.sys.jsgui.FS;
#elseif android
	typedef FS = abv.sys.android.FS;
#elseif (java && gui)
	typedef FS = abv.sys.javagui.FS;
#elseif (cpp && gui)
	typedef FS = abv.sys.cppgui.FS;
#else
#end
//
