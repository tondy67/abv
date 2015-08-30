package abv.ds;

#if flash
typedef FS = abv.sys.flash.FS;
#elseif js
	#if gui
typedef FS = abv.sys.js.FS;
	#end
#elseif gui
typedef FS = abv.sys.gui.FS;
#else
#end

