package abv.net.web;

import haxe.crypto.Md5;
import haxe.io.Bytes;
import sys.net.Socket;
import abv.net.web.WT;
import abv.cpu.Thread;
import abv.cpu.Boss;
import abv.net.ThreadServer;
import abv.lib.math.MT;

using abv.CR;
using abv.lib.TP;
using abv.sys.ST;
using abv.ds.DT;

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
	
	var single = false;
	var boss:Thread = null;
	var tid = "";
	var arg = "";
	
	var host = "0.0.0.0";	
	var port = 5000;
	var root = ".";
	var auth = "";
	var index = ["index.html"];	
	var cached = ["","htm","html","png","gif","jpg","css","js","txt"];	
	var name = "Hako";
	var version = "0.1.0";
	var maxThreads = 256;
	public static var sign = "";
	public var urls(default,null):Map<String,String>;

	public function config(cfg:Map<String,String>)
	{
		if(cfg.exists("host"))host = cfg["host"];
		if(cfg.exists("port"))
			port = Std.int(MT.range(Std.parseInt(cfg["port"]),10000,80));
		if(cfg.exists("root"))root = cfg["root"];
		if(cfg.exists("urls")){
			urls = WT.parseQuery(cfg["urls"]);
			if(!urls.exists("fs"))urls.set("fs","/fs/");
			if(!urls.exists("pa"))urls.set("pa","/pa/");
		}
		if(cfg.exists("auth"))auth = cfg["auth"];
		if(cfg.exists("index"))index = cfg["index"].splitt();
		if(cfg.exists("threads"))
			nthreads = Std.int(MT.range(Std.parseInt(cfg["threads"]),maxThreads,2));
		if(cfg.exists("name"))name = cfg["name"];
		if(cfg.exists("version"))version = cfg["version"];
	}// config()

	override function clientMessage(c: Client, msg: Message)
	{
		var s = msg.body;
		var p = "", f = "";
		c.request += s; 

		if(c.request.length < c.length)	return;
		else if(c.request.length == c.length)s = CR.LF; 
 
		if(s == CR.LF){ 
			var form:Map<String,String> = null;
			if(c.ctx == null) c.ctx = WT.parseRequest(c.request); 
			var ctx = c.ctx; // for(k in ctx.keys())trace(k+":"+ctx[k]);
			if(ctx["method"] == "POST"){ 
				if(c.length > 0){ //ST.save("bin/log.txt",c.request);
					ctx["body"] = c.request.substr(c.request.indexOf(CR.LF2));
					form = ctx["Content-Type"] == WT.mimeType["post-url"] ? 
						WT.parseQuery(ctx["body"]) : WT.parsePostData(ctx);
				}else if(ctx.exists("Content-Length")){
					c.length = c.request.length + Std.parseInt(ctx["Content-Length"]);
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
				}else if(ctx["path"].starts(Icons.p)||
					ctx["path"].eq("/favicon.ico"))WT.mkFile(ctx["path"],ctx);
				else if(ctx["path"].eq("/hako.css"))mkCss(ctx);
				else if(ctx["request"].starts(urls["pa"])){  
					if(ctx.key("Authorization","Basic "+auth))app(ctx); 
					else ctx["status"] = "401";
				}else app(ctx, form);
			}

			response(c.sock, WT.response(ctx));
			c.request = ""; c.length = 0; c.ctx = null;
			log('${c.ip} [${WT.getDate(true)}] "${ctx["request"]}" ${ctx["status"]} ${ctx["length"]}',LOG);
		}

	}// clientMessage()
	
	function response(sock:Socket,data:Bytes)
	{
		sendData(sock, data + "");
	}// response()
	
	override function clientConnected(sock: Socket)
	{
		var id = Std.random(100000);
		var ip = sock.peer().host + "";
		log('client: $id: $ip',DEBUG);
		
		return {id: id, sock: sock, request: "", length: 0, ctx: null, ip: ip, sid:""};
	}

	override function clientDisconnected(c: Client)
	{
		log('client: ${c.id} disconnected',DEBUG);
	}// clientDisconnected()

	override function readClientMessage(c:Client, buf:Bytes, pos:Int, len:Int)
	{
		var ok = false;
		var start = pos; 
		var max = pos + len;
// todo: overflow & zero checks
		while (start < max && !ok){
			ok = (buf.get(start) == 13)&&(buf.get(start+1) == 10);
			if(ok)start += 2;else start++;
		}

		if(!ok && start < max) return null;
		var size = start-pos;

 		return {msg: {body: buf.getString(pos, size)}, bytes: size};
	}// readClientMessage()

///
	function getIndex(path:String)
	{ 
		var r = "";
		var a = path.get();
		if(!a.empty()){
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
		if(path.extname() != "hxs")WT.mkFile(path,ctx);
		else hxs(path,ctx);
	}// mkFile()
	
	function mkCss(ctx:Map<String,String>)
	{ 
		ctx["mime"] = "css";
		ctx["etag"] = "ETag: " + WT.etag(ctx["request"]);
//		ctx["body"] = ST.open("bin/hako.css");
		var td = "text-decoration", ls = "list-style-type", va = "vertical-align";
		ctx["body"] = 'a:link{$td:none;}a:visited{$td:none;}a:hover{$td:underline;}ul.circle{$ls:circle;}ul.no{margin:0;padding-top:0;padding-left:20px;$ls:none;}table td, table td *{$va:top;}';
	}// mkCss()

///
	public dynamic function  hxs(path:String,ctx:Map<String,String>)
	{ 
		ctx["mime"] = "htm";
		ctx["body"] = path.open();
	}// hxs()
		
	public dynamic function app(ctx:Map<String,String>,form:Map<String,String>=null)
	{
		ctx["mime"] = "";
		var body = '<br><a href="/?d=${Std.random(10000)}">refresh</a><p><a href="/fs">FS</a></p><p><a href="/exit">Exit</a></p>';
		ctx["body"] = WT.mkPage(body);
	}// app();

	public dynamic function log(msg="",level:LogLevel)
	{
	}// log()

///	
	public function start()
	{ 
		tset(); 
		Sys.setCwd(root);
		sign = '$name/$version';

		try run(host, port) 
		catch(m:Dynamic){
			throw 'Another server is running at $host Port $port';
		}
	}// start()
///	
	function tset()
	{
		if(!single){ 
			boss = Thread.readMessage(true);
			tid = Thread.readMessage(true);
			arg = Thread.readMessage(true);
		}
	}// tset()

	function tell(msg="",level:LogLevel)
	{
		if(!single && (boss != null))
			boss.sendMessage(tid+":"+level + CR.sep + msg.trim());
	}// tell()
			
}// abv.net.web.WebServer
	
