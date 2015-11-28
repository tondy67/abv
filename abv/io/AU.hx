package abv.io;

#if (ios || engine)
	typedef AU = abv.sys.engine.AU;
#elseif flash
	typedef AU = abv.sys.flash.AU;
#elseif (js && gui)
	typedef AU = abv.sys.jsgui.AU;
#elseif android
	typedef AU = abv.sys.android.AU;
#elseif (java && gui)
	typedef AU = abv.sys.javagui.AU;
#elseif ((neko || cpp) && gui)
	typedef AU = abv.sys.cppgui.AU;
#else
#end
