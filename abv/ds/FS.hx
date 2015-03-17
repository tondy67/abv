package abv.ds;

#if flash
typedef FS = abv.sys.flash.FS;
#elseif js
typedef FS = abv.sys.js.FS;
#elseif gui
typedef FS = abv.sys.gui.FS;
#else
#end

