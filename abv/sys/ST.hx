package abv.sys;


#if neko
typedef ST = abv.sys.cpp.ST;
#elseif cpp
typedef ST = abv.sys.cpp.ST;
#else
typedef ST = abv.sys.others.ST;
#end

// abv.sys.ST
