package abv.net.web;

import haxe.io.Bytes;

import abv.net.Socket;
import abv.cpu.Mutex;
import abv.net.web.WT;
import abv.cpu.Thread;
import abv.net.TServer;
import abv.math.MT;
import abv.ds.*;

using abv.ds.TP;
using abv.sys.ST;
using abv.ds.DT;

typedef Client = {
	id:Int, 
	sock:Socket, 
	length:Int, 
	ctx:WebContext, 
	ip: Int}

typedef Message = {body: Bytes}

@:dce
class WServer extends TServer<Client, Message>{

	var mutex = new Mutex();	
	
	var name = "HES";
	var version = "0.1.0";
	public static var SIGN(default,null) = "";
	public static var HOST(default,null) = "0.0.0.0";	
	public static var PORT(default,null) = 5000;
// docs root
	public static var ROOT(default,null) = "";
	public static var TMP(default,null) = "";
	var indexes = ["index.html"];	
// auth = haxe.crypto.Base64.encode(haxe.io.Bytes.ofString('user:pass'));
	var auth = "";
	var useCookies = true;
	var maxThreads = 256;
// expire in seconds
// urls map 
	public static var URLS(default,null):MapSS;

	public function new()
	{
		super();
		config();
	}//
	
	override function readClientMessage(c:Client, buf:Bytes, pos:Int, len:Int)
	{
		//mutex.acquire();
		var ok = false;
		var start = pos; 
		var max = pos + len;
// TODO: overflow & zero checks
		var d = buf.getData();
		while (start < max && !ok){
			ok = d.g(start) == 13 && d.g(start+1) == 10 && 
				d.g(start+2) == 13 && d.g(start+3) == 10;
			if(ok)start += 4;else start++;
		}

		if(!ok && start < max) return null;
		var size = start-pos;
		var r = {msg: {body: buf.sub(pos, size)}, bytes: size};
		//mutex.release();

 		return r;
	}// readClientMessage()
var count=0;
	override function clientMessage(c: Client, msg: Message)
	{
		var method:WebMethod = null;
		var header = "";
		var s = "";
abv.sys.ST.saveFile(count+".dbg",msg.body);count++;
//		c.request.blit(c.length,msg.body,0,msg.body.length);
//		c.length = msg.body.length;
	
//		if(c.request.length < c.length)	return;
//		else if(c.request.length == c.length)s = CC.LF; 
	
		if(c.ctx == null){
			var d = msg.body.getData();
			if (d.g(0) == "P".code && d.g(1) == "O".code && d.g(2) == "S".code && d.g(3) == "T".code){
				header = msg.body+"";
				method = POST; 
			}else if (d.g(0) == "G".code && d.g(1) == "E".code && d.g(2) == "T".code){
				header = msg.body+"";
				method = GET;
			}else if (d.g(0) == "H".code && d.g(1) == "E".code && d.g(2) == "A".code && d.g(3) == "D".code){
				header = msg.body+"";
				method = HEAD;
			}
			
			if(header != ""){
				c.ctx = WT.parseRequest(header,method); 
				c.ctx.ip = c.ip;
			}
		}else if (c.ctx.method == POST){
			if (c.ctx.length == -1){
				c.ctx.status = 411;
				sendData(c.sock, WT.response(c.ctx));
				c.ctx = null;
			}else if (c.ctx.r[WT.CONTENT_TYPE] == WT.mimeType["post-url"]){
				var session = WT.getSession(c.ctx);
				var form = WT.parseQuery(msg.body+"");
				app(c.ctx,session,form);
				sendData(c.sock, WT.response(c.ctx));
				c.ctx = null;
			}else{
				if (c.length == 0) {
					c.length = c.ctx.length  - msg.body.length;
				}else{
					c.length -= msg.body.length;
					if (c.length <= 0){
						app(c.ctx,null,null);
						sendData(c.sock, WT.response(c.ctx));
						c.length = 0;
						c.ctx = null;
					}
					
				}
				trace(c.ctx.length,c.length);
				
			}
//				for(k in c.ctx.r.keys())trace(k+":"+c.ctx.r[k]);
			return;
		}
		
		if((c.ctx != null)&&(c.ctx.method == GET)){
			var form:MapSS = null;
			
			var ctx = c.ctx; 
			
/*			
			if(ctx.method == "POST"){
				if(c.length > 0){ 
					ctx.r["body"] = (c.request+"").substr((c.request+"").indexOf(CC.LF2));
					form = ctx.r[WT.CONTENT_TYPE] == WT.mimeType["post-url"] ? 
						WT.parseQuery(ctx.r["body"]) : WT.parsePostData(ctx);
				}else if(ctx.r.exists(WT.CONTENT_LENGTH)){
					c.length = c.request.length + ST.toInt(ctx.r[WT.CONTENT_LENGTH]);
					return;
				}else{
					ctx.status = 411;
				}
			} 
*/			
			if(ctx.status == 200){
				//mutex.acquire();
				var session = WT.getSession(ctx);

				var path = ROOT + WT.fsPath(ctx.path);
				if(ctx.r[WT.IF_NONE_MATCH] == WT.etag(ctx)){ 
					ctx.status = 304;
				}else if(!ST.good(ROOT)){ 
					app(ctx,session,form);
				}else if(ctx.path.eq("/"+WT.FAVICON)){
					WT.mkFile(ctx);
				}else if(ctx.path.starts(WT.ICONS)){
					WT.mkFile(ctx);
				}else if(ctx.path.eq("/abv.css")){
					mkCss(ctx);
				}else if(ctx.path.starts(URLS["pa"])){  
					if(ctx.r[WT.AUTHORIZATION] == "Basic "+auth)app(ctx,session,form);
					else ctx.status = 401;
				}else if(path.exists()){ 
					if(path.isDir()){
						if (ctx.path.substr(-1,1) != "/"){
							s = ctx.path+"/";
							if (ctx.query != "") s += "?" + ctx.query;
							WT.redirect(ctx, s, 301);
						}else{
							mkDir(ctx); 
						}
					}else{
						WT.mkFile(ctx);
					}
				}else{
					app(ctx,session,form);
				}
				var now = Date.now().getTime();
				if (ctx.body != null) ctx.length = ctx.body.length;
				log('${WT.LINFO} ${c.ip.int2ip()} [${WT.getDate(now,true)}] "${ctx.request}" ${ctx.status} ${ctx.length}');
				//mutex.release();
			}
			
			//mutex.acquire();
			sendData(c.sock, WT.response(ctx));
		
			//mutex.release(); 
	//		c.request = ""; 
			c.length = 0; 
			c.ctx = null;
		}
		
	}// clientMessage()
	
	function mkDir(ctx:WebContext)
	{
		ctx.path = ctx.path.addSlash(); 
		var path = WT.fsPath(ctx.path);
		var r = ""; 
		var a = ST.ls(ROOT + path); 
		if(a.good()){ 	
			for(f in a){
				f = "/" + f;
				if(indexes.indexOf(f.basename()) != -1){
					r = f;
					break;
				}
			}
		}
		if(r != ""){ 
			ctx.path = r.replace(ROOT,""); 
			WT.mkFile(ctx);
		}else{
			r = WT.mkPage('<p>${WT.LHOME}</p>'+WT.dirIndex(ROOT + path));
			ctx.body = r.toBytes(); 
		}
	}// mkDir()
	
	override function clientConnected(sock: Socket)
	{
		//mutex.acquire();
		var id = ST.rand();
		var ip = sock.peer().host + "";
		log('${WT.LLOG} client: $id: $ip'); 
		var r = {id: id, sock: sock, 
				length: 0, ctx: null, ip: ST.ip2int(ip)};
		//mutex.release();
		return r;
	}

	override function clientDisconnected(c: Client)
	{
		//mutex.acquire();
		c.ctx = null;
		log('${WT.LLOG} client: ${c.id} disconnected');
		//mutex.release();
	}// clientDisconnected()

///
	function mkCss(ctx:WebContext)
	{ 
		ctx.mime = "css";
//		ctx.r["body"] = ST.open("bin/abv.css");
		var td = "text-decoration", ls = "list-style-type", va = "vertical-align";
		ctx.body = 'a:link{$td:none;}a:visited{$td:none;}a:hover{$td:underline;}ul.circle{$ls:circle;}ul.no{margin:0;padding-top:0;padding-left:20px;$ls:none;}table td, table td *{$va:top;}.red{color:#f00;}'.toBytes(); 
	}// mkCss()

///
	public dynamic function app(ctx:WebContext,session:MapSS=null,form:MapSS=null)
	{
		ctx.mime = "";
		var body = '<br><a href="/?d=${Std.random(10000)}">refresh</a><p><a href="/exit">Exit</a></p>';
		ctx.body = WT.mkPage(body).toBytes(); 
	}// app();

	public dynamic function log(s:String)
	{
	}// log()

///	
	public function config()
	{
		var cwd = ST.dirname(ST.exe()); 
		var res = ST.RES_DIR;
		try HOST = CC.HOST catch(e:Dynamic){ST.error(e);}
		try PORT = Std.int(MT.range(ST.toInt(CC.PORT),10000,80)) catch(e:Dynamic){ST.error(e);}
		if (ST.good(CC.ROOT)) try ROOT = ST.addSlash(ST.realpath('$cwd/$res/${CC.ROOT}')) catch(e:Dynamic){ST.error(e);}
		try TMP = ST.addSlash(ST.realpath('$cwd/$res/${CC.TMP}')) catch(e:Dynamic){ST.error(e);}
		try {
			URLS = WT.parseQuery(CC.URLS);
			if(!URLS.exists("pa"))URLS.set("pa","/pa/");
		} catch(e:Dynamic){ST.error(e);}
		try auth = CC.AUTH catch(e:Dynamic){ST.error(e);}
		try indexes = CC.INDEX.split(",") catch(e:Dynamic){ST.error(e);}
		try ntasks = 1;//Std.int(MT.range(ST.toInt(CC.THREADS),maxThreads,2)) catch(e:Dynamic){ST.error(e);}
		try name = CC.NAME catch(e:Dynamic){ST.error(e);}
		try version = CC.VERSION catch(e:Dynamic){ST.error(e);}
		SIGN = '$name/$version';
	}// config()

	public override function start(host="0.0.0.0", port=80)
	{ 
		super.start(HOST, PORT); 
	}// start()
///	
			
}// abv.net.web.WServer
	
