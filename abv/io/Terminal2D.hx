package abv.io;

#if flash
typedef Terminal2D = abv.sys.flash.Terminal2D;
#elseif js
typedef Terminal2D = abv.sys.js.Terminal2D;
#elseif gui
typedef Terminal2D = abv.sys.gui.Terminal2D;
#else
#end
