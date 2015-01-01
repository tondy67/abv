package abv.net.web;

import sys.net.Host;
import sys.net.Socket;

class WebClient{

	public static var BUFSIZE = 1024;
	var buffer = haxe.io.Bytes.alloc(BUFSIZE);
	var bufpos = 0;
	var buflen = BUFSIZE;

	public function new()
	{
		var url = "http://localhost:5000/path/to/index.hxs?n=hako&v=1";
		var req = 
'GET $url HTTP/1.1' + "\r\n" +
"Connection: keep-alive\r\n" +
"Accept: text/html\r\n" +
"User-Agent: Hako\r\n" +
"Accept-Language: en-US,en\r\n" + "\r\n";
		
		
		Sys.println("open: "+url);
		var sock = new Socket();
		sock.connect(new Host("localhost"), 5000);
		var t = haxe.Timer.stamp();
//	Sys.println("sending messages");
		sock.write(req);		
		sock.waitForRead();
		var n = sock.input.readBytes(buffer,bufpos,buflen); 
		var r = buffer.getString(bufpos, n); 
		Sys.println(r);
		sock.close();
		Sys.println("close");
	}// new ()
	
}// abv.net.web.WebClient
