package abv.io;

#if (ios || engine)
	typedef Terminal3D = abv.sys.engine.Terminal3D;
#elseif flash
	typedef Terminal3D = abv.sys.flash.Terminal3D;
#elseif (js && gui)
	typedef Terminal3D = abv.sys.jsgui.Terminal3D;
#elseif android
	typedef Terminal3D = abv.sys.android.Terminal3D;
#elseif (java && gui)
	typedef Terminal3D = abv.sys.javagui.Terminal3D;
#elseif (cpp && gui)
	typedef Terminal3D = abv.sys.cppgui.Terminal3D;
#else
#end
