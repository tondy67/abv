package abv.ds;

#if flash
typedef FS = abv.sys.flash.FS;
#elseif js
typedef FS = abv.sys.js.FS;
#else
typedef FS = openfl.Assets;
#end

//typedef FS = openfl.Assets;
