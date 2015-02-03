package abv.net.web;

import haxe.io.Bytes;
import sys.net.Socket;
import abv.net.web.WT;
import abv.cpu.Thread;
import abv.cpu.Boss;
import abv.net.ThreadServer;
import abv.lib.math.MT;
import abv.ds.*;

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
	ip: String}

typedef Message = {body: String}

@:dce
class WebServer extends ThreadServer<Client, Message>{
	
	var single = false;
	var boss:Thread = null;
	var tid = "";
	var arg = "";
	
	var name = "Hako";
	var version = "0.1.0";
	public static var SIGN(default,null) = "";
	var host = "0.0.0.0";	
	var port = 5000;
// docs root
	var root = "";
	var indexes = ["index.html"];	
// auth = haxe.crypto.Base64.encode(haxe.io.Bytes.ofString('user:pass'));
	var auth = "";
	var useCookies = true;
	var maxThreads = 256;
// expire in seconds
	var sessionExpire = 300;
// urls map 
	public var urls(default,null):Map<String,String>;

	var sessions(default,null) = new Wallet();

	public function config(cfg:Map<String,String>)
	{
		if(cfg.exists("host"))host = cfg["host"];
		if(cfg.exists("port"))
			port = Std.int(MT.range(Std.parseInt(cfg["port"]),10000,80));
		if(cfg.exists("root"))root = cfg["root"];
		if(cfg.exists("urls")){
			urls = WT.parseQuery(cfg["urls"]);
			if(!urls.exists("pa"))urls.set("pa","/pa/");
		} 
		if(cfg.exists("auth"))auth = cfg["auth"];
		if(cfg.exists("index"))indexes = cfg["index"].splitt();
		if(cfg.exists("threads"))
			nthreads = Std.int(MT.range(Std.parseInt(cfg["threads"]),maxThreads,2));
		if(cfg.exists("name"))name = cfg["name"];
		if(cfg.exists("version"))version = cfg["version"];
	}// config()

	override function clientMessage(c: Client, msg: Message)
	{
		var s = msg.body;
		
		c.request += s; 

		if(c.request.length < c.length)	return;
		else if(c.request.length == c.length)s = CR.LF; 

		if(s == CR.LF){ 
			var form:Map<String,String> = null;
			if(c.ctx == null){
				c.ctx = WT.parseRequest(c.request); 
				c.ctx["root"] = root;
				c.ctx["ip"] = c.ip;
			}
			var ctx = c.ctx; // for(k in ctx.keys())trace(k+":"+ctx[k]);
			if(ctx["method"] == "POST"){ 
				if(c.length > 0){ 
					ctx["body"] = c.request.substr(c.request.indexOf(CR.LF2));
					form = ctx[WT.CONTENT_TYPE] == WT.mimeType["post-url"] ? 
						WT.parseQuery(ctx["body"]) : WT.parsePostData(ctx);
				}else if(ctx.exists(WT.CONTENT_LENGTH)){
					c.length = c.request.length + Std.parseInt(ctx[WT.CONTENT_LENGTH]);
					return;
				}else ctx["status"] = "411";
			} 
			
			if(ctx["status"] == "200"){
				CR.lock.acquire();
				var session:Map<String,String> = null;
// session
				if(useCookies){
					if(ctx.exists(WT.COOKIE)){
						var cookies = WT.parseCookie(ctx[WT.COOKIE]); 
						if(cookies.exists("sid")){
							var a = cookies["sid"].splitt(CR.SEP1);
							session = sessions.get(a.pop());
						}
					}
					if(session.empty()){
						var sid = sessions.add(sessionExpire); 
						session = sessions.get(sid); 
						WT.setCookie(ctx,"sid",sid);
					}
				}
//trace(session);	
				var path = WT.fsPath(ctx["path"]); 
				if(ctx.pair(WT.IF_NONE_MATCH,WT.etag(ctx))){ 
					ctx["status"] = "304";
				}else if(!root.good()){
					app(ctx,session,form);
				}else if(ctx["path"].starts(Icons.p)||ctx["path"].eq("/favicon.ico")){
					mkFile(ctx);
				}else if(ctx["path"].eq("/hako.css")){
					mkCss(ctx);
				}else if(ctx["path"].starts(urls["pa"])){  
					if(ctx.pair(WT.AUTHORIZATION,"Basic "+auth))app(ctx,session,form);
					else ctx["status"] = "401";
				}else if(path.exists()){
						if(path.dir())mkDir(ctx); else mkFile(ctx,session);
				}else{
					app(ctx,session,form);
				}
				ctx["length"] = ctx["body"].length +"";
				var now = Date.now().getTime();
				log('${c.ip} [${WT.getDate(now,true)}] "${ctx["request"]}" ${ctx["status"]} ${ctx["length"]}',LOG);
				CR.lock.release();
			}

			response(c.sock, WT.response(ctx));
			c.request = ""; c.length = 0; c.ctx = null;
		}
	}// clientMessage()
	
	function mkDir(ctx:Map<String,String>)
	{
		ctx["path"] = WT.slash(ctx["path"]);
		var path = WT.fsPath(ctx["path"]); 
		var r = ""; 
		var a = path.get(); 
		if(a.good()){ 
			for(f in indexes){
				if(a.indexOf(f) != -1){
					r = f;
					break;
				}
			}
		}
		if(r.good()){ 
			ctx["path"] += r; 
			mkFile(ctx);
		}else ctx["body"] = WT.mkPage('<p><a href="/">Home</a></p>'+WT.dirIndex(path));
	}// mkDir()
	
	function mkFile(ctx:Map<String,String>,session:Map<String,String>=null)
	{ 
		if(ctx["path"].ends(".hxs"))app(ctx,session);else WT.mkFile(ctx);
	}// mkFile()
	
	function response(sock:Socket,data:Bytes)
	{
		CR.lock.acquire();
		sendData(sock, data + "");
		CR.lock.release();
	}// response()
	
	override function clientConnected(sock: Socket)
	{
		CR.lock.acquire();
		var id = Std.random(100000);
		var ip = sock.peer().host + "";
		log('client: $id: $ip',DEBUG); 
		var r = {id: id, sock: sock, request: "", length: 0, ctx: null, ip: ip};
		CR.lock.release();
		return r;
	}

	override function clientDisconnected(c: Client)
	{
		CR.lock.acquire();
		log('client: ${c.id} disconnected',DEBUG);
		CR.lock.release();
	}// clientDisconnected()

	override function readClientMessage(c:Client, buf:Bytes, pos:Int, len:Int)
	{
		CR.lock.acquire();
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
		var r = {msg: {body: buf.getString(pos, size)}, bytes: size};
		CR.lock.release();

 		return r;
	}// readClientMessage()

///
	function mkCss(ctx:Map<String,String>)
	{ 
		ctx["mime"] = "css";
//		ctx["body"] = ST.open("bin/hako.css");
		var td = "text-decoration", ls = "list-style-type", va = "vertical-align";
		ctx["body"] = 'a:link{$td:none;}a:visited{$td:none;}a:hover{$td:underline;}ul.circle{$ls:circle;}ul.no{margin:0;padding-top:0;padding-left:20px;$ls:none;}table td, table td *{$va:top;}.red{color:#f00;}';
	}// mkCss()

///
	public dynamic function app(ctx:Map<String,String>,session:Map<String,String>=null,form:Map<String,String>=null)
	{
		ctx["mime"] = "";
		var body = '<br><a href="/?d=${Std.random(10000)}">refresh</a><p><a href="/exit">Exit</a></p>';
		ctx["body"] = WT.mkPage(body);
	}// app();

	public dynamic function log(msg="",level:LogLevel)
	{
	}// log()

///	
	public function start()
	{ 
		tset(); 
		var cwd = root.good()?root:".";
		Sys.setCwd(cwd);
		SIGN = '$name/$version';

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
			boss.sendMessage(tid+":"+level + CR.SEP3 + msg.trim());
	}// tell()
			
}// abv.net.web.WebServer
	
