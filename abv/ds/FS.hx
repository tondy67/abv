package abv.ds;

#if flash
	typedef FS = abv.sys.flash.FS;
#elseif js
	typedef FS = abv.sys.js.FS;
#elseif android
	typedef FS = abv.sys.android.FS;
#elseif java
	typedef FS = abv.sys.java.FS;
#elseif (ios || engine)
	typedef FS = abv.sys.engine.FS;
#elseif (cpp || neko)
	typedef FS = abv.sys.cpp.FS;
#end
// abv.ds.FS
