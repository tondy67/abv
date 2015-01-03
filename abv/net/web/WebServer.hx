package abv.net.web;

import haxe.crypto.Md5;
import haxe.io.Bytes;
import sys.net.Socket;
import sys.io.File;
import sys.FileSystem;
import abv.net.web.WT;
#if neko
import neko.net.ThreadServer;
#else
import cpp.net.ThreadServer;
#end 

using StringTools;
using abv.CT;

typedef Client = {id:Int, sock:Socket, request:String, length:Int, ctx:Map<String,String>, sid:String}
typedef Message = {body: String}

class WebServer extends ThreadServer<Client, Message>{
	
	var host = "0.0.0.0";	
	var port = 5000;
	var root = ".";
	var fs = "/fs/";
	var auth = "";
	var login = "/login/";
	var index = ["index.html"];	
	var name = "Hako";
	var version = "0.1.0";
	public static var sign = "";

	public function config(cfg:Map<String,String>)
	{
		if(cfg.exists("host"))host = cfg["host"];
		if(cfg.exists("port"))port = Std.parseInt(cfg["port"]);
		if(cfg.exists("root"))root = cfg["root"];
		if(cfg.exists("fs"))fs = cfg["fs"];
		if(cfg.exists("auth"))auth = cfg["auth"];
		if(cfg.exists("login"))login = cfg["login"];
		if(cfg.exists("index"))index = cfg["index"].splitt();
		if(cfg.exists("threads")){
			nthreads = Std.parseInt(cfg["threads"]);
			if((nthreads < 2)||(nthreads > 256))nthreads = 2;
		}
		if(cfg.exists("name"))name = cfg["name"];
		if(cfg.exists("version"))version = cfg["version"];
	}// config()

	function print(msg="",level=1){CT.print(msg,level);}
	
	override function clientConnected(sock: Socket)
	{
		var id = Std.random(100000);
		print('client: $id: ' + sock.peer().host,5);
		
		return {id: id, sock: sock, request: "", length: 0, ctx: null, sid:""};
	}

	override function clientDisconnected(c: Client)
	{
		print('client: ${c.id} disconnected',5);
	}// clientDisconnected()

	override function readClientMessage(c:Client, buf:Bytes, pos:Int, len:Int)
	{
		var ok = false;
		var cpos = pos; 
		var max = pos + len;

		while (cpos < max && !ok){
			ok = (buf.get(cpos) == 13)&&(buf.get(cpos+1) == 10);
			cpos++;
		}

		if(!ok && cpos < max) return null;
		var size = cpos-pos;

 		return {msg: {body: buf.getString(pos, size)}, bytes: size};
	}// readClientMessage()

	override function clientMessage(c: Client, msg: Message)
	{
		var s = msg.body;
		var p = "", f = "";
		c.request += s; 

		if(c.request.length < c.length){
				return;
		}else if(c.request.length == c.length)s = "\n\r"; 

	
		if(s == "\n\r"){ //trace(c.request);
			if(c.ctx == null) c.ctx = WT.parseRequest(c.request); 
			var ctx = c.ctx;
			if(ctx["method"] == "POST"){
				if(c.length > 0){
					ctx["body"] = c.request.substr(c.request.indexOf("\n\r") + 2).trim();
					var form = ctx["Content-Type"] == WT.mimeType["post-url"] ? 
						WT.parseQuery(ctx["body"]) : WT.parsePostData(ctx);
					app(ctx, form); trace(form);
					for(k in form.keys())form[k].clear();
					form = null;
				}else if(ctx.exists("Content-Length")){
					c.length = c.request.length + 1 + Std.parseInt(ctx["Content-Length"]);
					return;
				}else ctx["status"] = "411";
			} 
			
			if(ctx["status"] == "200"){
				if(ctx.exists("If-None-Match")){ 
					if(ctx["If-None-Match"] == etag(ctx["request"])) ctx["status"] = "304";
				}else if(ctx["path"].startsWith(fs)){ 
					p = ctx["path"].substr(fs.length);  
					if(!p.good())p = ".";
					if(FileSystem.exists(p)){
						if(FileSystem.isDirectory(p)){
							f = getIndex(p); 
							if(f.good())ctx["body"] = File.getContent('$p/$f');
							else ctx["body"] = '<p><a href="/">Home</a></p>'+WT.dirIndex(p,fs);
						}else{ 
							ctx["mime"] = p.extname();
							ctx["body"] = File.getContent(p);
							ctx["etag"] = "ETag: "+etag(ctx["request"]);
						}
					}else ctx["status"] = "404";
				}else if(ctx["path"].startsWith(Icons.p)){ 
					p = ctx["path"].substr(Icons.p.length); 
					ctx["mime"] = "png";
					ctx["body"] = WT.getIcon(p.basename(false));
					ctx["etag"] = "ETag: "+etag(ctx["request"]);
				}else if(ctx["path"] == "/favicon.ico"){
					ctx["mime"] = "ico";
					ctx["body"] = WT.getIcon("favicon");
					ctx["etag"] = "ETag: "+etag(ctx["request"]);
				}else if(ctx["request"].startsWith(login)){  
					if(ctx.exists("Authorization")&&(ctx["Authorization"] == auth))app(ctx); 
					else ctx["status"] = "401";
				}else app(ctx);
			}

			sendData(c.sock, WT.response(ctx));
			c.request = ""; c.length = 0; c.ctx = null;
			print('${c.sock.peer().host} [${WT.getDate(true)}] "${ctx["request"]}" ${ctx["status"]} ${ctx["length"]}');
		}

	}// clientMessage()
 
	function etag(s:String)
	{
		return '"${Md5.encode(s.substr(0,1000))}"';
	}// etag()
	
	function getIndex(path:String)
	{
		var r = "";
		var a = path.getDir();
		if(a.length > 0){
			for(f in index){
				if(a.indexOf(f) != -1){
					r = f;
					break;
				}
			}
		}
		return r;
	}// getIndex()
	
	public dynamic function app(ctx:Map<String,String>,form:Map<String,Array<String>>=null)
	{
		ctx["mime"] = "";
		ctx["body"] = '<br><a href="/?d=${Std.random(10000)}">refresh</a><p><a href="/fs">FS</a></p><p><a href="/exit">Exit</a></p>';
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
	
