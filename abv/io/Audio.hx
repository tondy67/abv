package abv.io;

#if flash
typedef Audio = abv.sys.flash.Audio;
#elseif js
	#if gui
typedef Audio = abv.sys.js.Audio;
	#end
#elseif gui
typedef Audio = abv.sys.gui.Audio;
#else
#end
