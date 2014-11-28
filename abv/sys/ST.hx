package abv.sys;


#if (neko || cpp)
typedef ST = abv.sys.cpp.ST;
#else
typedef ST = abv.sys.others.ST;
#end
// abv.sys.ST
