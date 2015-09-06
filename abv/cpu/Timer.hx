package abv.cpu;
/**
 * Timer 
 **/ 
#if cpp
	typedef Timer = abv.sys.cpp.Timer;
#elseif java
	typedef Timer = abv.sys.java.Timer;
#else
	typedef Timer = haxe.Timer;
#end
