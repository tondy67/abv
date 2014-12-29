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
		var req = 
'GET /?ttt=ddd HTTP/1.1
Host: localhost:5000
Connection: keep-alive
Accept: text/html
User-Agent: Hako
Accept-Language: en-US,en';
		req = req + "\r\n\r\n";
		
		
		Sys.println("open");
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
