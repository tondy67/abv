package abv.io;

#if flash
typedef Terminal2D = abv.sys.flash.Terminal2D;
#elseif js
typedef Terminal2D = abv.sys.js.Terminal2D;
#else
typedef Terminal2D = abv.sys.openfl.Terminal2D;
#end
