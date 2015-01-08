package abv.net;

#if neko
typedef ThreadServer<Client, Message> = neko.net.ThreadServer<Client, Message>;
#elseif cpp
typedef ThreadServer<Client, Message> = cpp.net.ThreadServer<Client, Message>;
#end

// abv.net.ThreadServer

