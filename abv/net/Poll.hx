package abv.net;

import abv.net.Socket;

#if java
typedef Poll = abv.sys.java.net.Poll;
#elseif neko
typedef Poll = neko.net.Poll;
#elseif cpp
typedef Poll = cpp.net.Poll;

#end

// abv.net.Poll

