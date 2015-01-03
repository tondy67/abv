package abv.net.web;
/**
 *	WebClient
 * 
 **/
import sys.net.Host;
import sys.net.Socket;

class WebClient{

	public static var BUFSIZE = 1 << 14;
	var buffer = haxe.io.Bytes.alloc(BUFSIZE);
	var bufpos = 0;
	var buflen = BUFSIZE;
	var host = "localhost";
	var port = 5000;
	
	public function new()
	{
		var ts = haxe.Timer.stamp(); 
		var url = 'http://$host:$port/path/to/file.hxs?n=hako&ts=$ts';
		
		Sys.println("open: "+url);
		var s = open(url);
		if(s != "")Sys.println(s);
	}// new ()
	
	function open(url:String)
	{
		var r = "";
		var req = 'GET $url HTTP/1.1' + "\r\n" +
		"Connection: keep-alive\r\n" +
		"Accept: text/html\r\n" +
		"User-Agent: Hako\r\n" +
		"Accept-Language: en-US,en\r\n" + 
		"\r\n";
		
		try{
			var sock = new Socket();
			sock.connect(new Host(host), port);
			sock.write(req);		
			sock.waitForRead();
			var n = sock.input.readBytes(buffer,bufpos,buflen); 
			r = buffer.getString(bufpos, n); 
			sock.close();
		}catch(m:Dynamic){Sys.println("Can't open url!");}
		
		return r;
	}// open()
	
}// abv.net.web.WebClient
