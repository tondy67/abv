package abv.net.web;

import haxe.crypto.Md5;
import haxe.io.Bytes;
import sys.net.Socket;
import sys.io.File;
//import sys.FileSystem;
import abv.net.web.WT;
#if neko
import neko.net.ThreadServer;
#else
import cpp.net.ThreadServer;
#end 

using abv.lib.TP;
using abv.CT;
using abv.sys.ST;

typedef Client = {
	id:Int, 
	sock:Socket, 
	request:String, 
	length:Int, 
	ctx:Map<String,String>, 
	ip: String, 
	sid:String}
typedef Message = {body: String}

class WebServer extends ThreadServer<Client, Message>{
	
	var host = "0.0.0.0";	
	var port = 5000;
	var root = ".";
	var auth = "";
	var index = ["index.html"];	
	var cached = ["","htm","html","png","gif","jpg"];	
	var name = "Hako";
	var version = "0.1.0";
	var maxThreads = 256;
	public static var sign = "";
	public var urls(default,null):Map<String,String>;

	public function config(cfg:Map<String,String>)
	{
		if(cfg.exists("host"))host = cfg["host"];
		if(cfg.exists("port"))port = Std.parseInt(cfg["port"]);
		if(cfg.exists("root"))root = cfg["root"];
		if(cfg.exists("urls")){
			urls = WT.parseQuery(cfg["urls"]);
			if(!urls.exists("fs"))urls.set("fs","/fs/");
			if(!urls.exists("login"))urls.set("login","/login/");
		}
		if(cfg.exists("auth"))auth = cfg["auth"];
		if(cfg.exists("index"))index = cfg["index"].splitt();
		if(cfg.exists("threads")){
			nthreads = Std.parseInt(cfg["threads"]);
			if((nthreads < 2)||(nthreads > maxThreads))nthreads = 2;
		}
		if(cfg.exists("name"))name = cfg["name"];
		if(cfg.exists("version"))version = cfg["version"];
	}// config()

	function print(msg="",level=1){CT.print(msg,level);}
	
	override function clientConnected(sock: Socket)
	{
		var id = Std.random(100000);
		var ip = sock.peer().host + "";
		print('client: $id: $ip',CT.WARN);
		
		return {id: id, sock: sock, request: "", length: 0, ctx: null, ip: ip, sid:""};
	}

	override function clientDisconnected(c: Client)
	{
		print('client: ${c.id} disconnected',CT.WARN);
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
			var form:Map<String,String> = null;
			if(c.ctx == null) c.ctx = WT.parseRequest(c.request); 
			var ctx = c.ctx;
			if(ctx["method"] == "POST"){
				if(c.length > 0){
					ctx["body"] = c.request.substr(c.request.indexOf("\n\r") + 2).trim();
					form = ctx["Content-Type"] == WT.mimeType["post-url"] ? 
						WT.parseQuery(ctx["body"]) : WT.parsePostData(ctx);
				}else if(ctx.exists("Content-Length")){
					c.length = c.request.length + 1 + Std.parseInt(ctx["Content-Length"]);
					return;
				}else ctx["status"] = "411";
			} 
			
			if(ctx["status"] == "200"){
				if(ctx.exists("If-None-Match")){ 
					f = ctx["request"].extname();
					if((cached.indexOf(f)!=-1) && (ctx["If-None-Match"] == WT.etag(ctx["request"]))) ctx["status"] = "304";
				}else if(ctx["path"].starts(urls["fs"])){ 
					p = ctx["path"].substr(urls["fs"].length);  
					if(!p.good())p = "."; 
					if(p.exists()){ 
						if(p.dir()){ 
							f = getIndex(p); 
							if(f.good())mkFile('$p/$f',ctx);
							else ctx["body"] = WT.mkPage('<p><a href="/">Home</a></p>'+WT.dirIndex(p,urls["fs"]));
						}else mkFile(p,ctx);
					}else ctx["status"] = "404";
				}else if(ctx["path"].starts(Icons.p))WT.mkFile(ctx["path"],ctx);
				else if(ctx["path"] == "/favicon.ico")WT.mkFile(ctx["path"],ctx);
				else if(ctx["request"].starts(urls["login"])){  
					if(ctx.exists("Authorization")&&(ctx["Authorization"] == auth))app(ctx); 
					else ctx["status"] = "401";
				}else app(ctx, form);
			}

			sendData(c.sock, WT.response(ctx));
			c.request = ""; c.length = 0; c.ctx = null;
			print('${c.ip} [${WT.getDate(true)}] "${ctx["request"]}" ${ctx["status"]} ${ctx["length"]}',CT.LOG);
		}

	}// clientMessage()
 
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

	function mkFile(path:String,ctx:Map<String,String>)
	{ 
		if(path.extname() != "hxs")WT.mkFile(path,ctx);else hxs(path,ctx);
	}// mkFile()
	
	public dynamic function  hxs(path:String,ctx:Map<String,String>)
	{ 
		ctx["mime"] = "htm";
		ctx["body"] = File.getContent(path);
	}// hxs()
		
	public dynamic function app(ctx:Map<String,String>,form:Map<String,String>=null)
	{
		ctx["mime"] = "";
		var body = '<br><a href="/?d=${Std.random(10000)}">refresh</a><p><a href="/fs">FS</a></p><p><a href="/exit">Exit</a></p>';
		ctx["body"] = WT.mkPage(body);
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
	
