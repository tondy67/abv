package abv.net.web;

import sys.net.Socket;
import haxe.io.Bytes;
import abv.net.web.WT;
#if neko
import neko.net.ThreadServer;
#else
import cpp.net.ThreadServer;
#end 

using StringTools;
using abv.CT;

typedef Client = {id:Int, sock:Socket, request:String}
typedef Message = {body: String}

class WebServer extends ThreadServer<Client, Message>{
	
	var host = "0.0.0.0";	
	var port = 5000;
	var root = ".";
	var index = "index.n";	
	var name = "Hako";
	var version = "0.1.0";
	public static var sign = "";
	public var cmd = "";

	public function config(cfg:Map<String,String>)
	{
		if(cfg.exists("host"))host = cfg["host"];
		if(cfg.exists("port"))port = Std.parseInt(cfg["port"]);
		if(cfg.exists("root"))root = cfg["root"];
		if(cfg.exists("index"))index = cfg["index"];
		if(cfg.exists("threads"))nthreads = Std.parseInt(cfg["threads"]);
		if(cfg.exists("name"))name = cfg["name"];
		if(cfg.exists("version"))version = cfg["version"];
	}// config()

	function print(msg="",level=1){CT.print(msg,level);}
	
	override function clientConnected(sock: Socket)
	{
		var id = Std.random(100000);
		print('client: $id: ' + sock.peer().host,5);
		
		return {id: id, sock: sock, request: ""};
	}

	override function clientDisconnected(c: Client)
	{
		print('client: ${c.id} disconnected',5);
	}// clientDisconnected()

	override function readClientMessage(c:Client, buf:Bytes, pos:Int, len:Int)
	{
		var complete = false;
		var cpos = pos;
		while (cpos < (pos+len) && !complete){
			complete = (buf.get(cpos) == 13);
			cpos++;
		}

		if(!complete) return null;
		var size = cpos-pos;
		
 		return {msg: {body: buf.getString(pos, size)}, bytes: size};
	}// readClientMessage()

	override function clientMessage(c: Client, msg: Message)
	{
		var s = msg.body;

		if(s == "\n\r"){  //trace(c.request);
			var ctx = WT.parseRequest(c.request); 
			var r = ctx["status"] == "200"?app(ctx):WT.response(ctx);
			sendData(c.sock, r);
			c.request = "";
			print('${c.sock.peer().host} [${WT.getDate(true)}] "${ctx["request"]}" ${ctx["status"]} ${ctx["length"]}');
		}else{
			c.request += s; 
		}
	}// clientMessage()
	
	public dynamic function app(ctx:Map<String,String>):String
	{
		ctx["body"] = Date.now() + '<br><a href="/?d=${Std.random(10000)}">refresh</a><p><a href="/fs">FS</a></p><p><a href="/exit">Exit</a></p>';

		return WT.response(ctx);
	}// app();

	public function start()
	{
		Sys.setCwd(root);
		sign = '$name/$version';

		try run(host, port) 
		catch(m:Dynamic){
			print('Another server is running at $host Port $port');
		}
	}// start()
	
			
}// abv.net.web.WebServer
	
