package abv;
/**
 * AbstractMachine entry class App
 * haxelib run dox --title Title -o docs -i cpp.xml
 **/

#if flash
	typedef AM = abv.sys.flash.AM;
#elseif ((neko || cpp) && gui)
	typedef AM = abv.sys.cppgui.AM;
#elseif (neko || cpp)
	typedef AM = abv.sys.cpp.AM;
#elseif (js && gui)
	typedef AM = abv.sys.jsgui.AM;
#elseif (java && gui)
	typedef AM = abv.sys.javagui.AM;
#else
	typedef AM = abv.sys.others.AM;
#end
// abv.AM
