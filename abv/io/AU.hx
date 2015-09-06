package abv.io;

#if flash
	typedef AU = abv.sys.flash.AU;
#elseif (js && gui)
	typedef AU = abv.sys.jsgui.AU;
#elseif (java && gui)
	typedef AU = abv.sys.javagui.AU;
#elseif (cpp && gui)
	typedef AU = abv.sys.cppgui.AU;
#else
#end
