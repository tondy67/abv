package abv;
/**
 * AbstractMachine entry class App
 * haxelib run dox --title Title -o docs -i cpp.xml
 **/

#if (neko || cpp)
typedef AM = abv.sys.cpp.AM;
#else
typedef AM = abv.sys.others.AM;
#end
// abv.AM
