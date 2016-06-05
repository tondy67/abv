package abv.net.web;
/**
 *	Client
 **/
import sys.net.Host;
import sys.net.Socket;

using abv.sys.ST;

class WClient{

	public static var BUFSIZE = 1 << 14;
	var buffer = haxe.io.Bytes.alloc(BUFSIZE);
	var bufpos = 0;
	var buflen = BUFSIZE;
	var host = "localhost";
	var port = 5000;
	var err = "Can't open url!";
	
	public function new()
	{
	}// new ()
	
	function open(url:String)
	{
		var r = "";
		if (!ST.good(url)){
			ST.error(err);
			return r;
		}
/*
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
		}catch(m:Dynamic){ST.error(err,null,null);}
*/
		try r = haxe.Http.requestUrl(url)catch(m:Dynamic){ST.error(err,null,null);}
		return r;
	}// open()
	
}// abv.net.web.WClient
