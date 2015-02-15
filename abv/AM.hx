package abv;
/**
 * AbstractMachine entry class App
 * haxelib run dox --title Title -o docs -i cpp.xml
 **/

#if openfl
typedef AM = abv.sys.openfl.AM;
#elseif (neko || cpp)
typedef AM = abv.sys.cpp.AM;
#elseif flash
typedef AM = abv.sys.flash.AM;
#elseif js
typedef AM = abv.sys.js.AM;
#else
typedef AM = abv.sys.others.AM;
#end
// abv.AM
