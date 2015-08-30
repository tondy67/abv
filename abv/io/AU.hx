package abv.io;

#if flash
typedef AU = abv.sys.flash.AU;
#elseif js
	#if gui
typedef AU = abv.sys.js.AU;
	#end
#elseif gui
typedef AU = abv.sys.gui.AU;
#else
#end
