package abv.net.web;
/**
 * WebTools
 **/
import haxe.crypto.Md5;
import haxe.io.Bytes;

import abv.net.web.WServer;
import abv.cpu.DateGMT;
import abv.ds.VFS;
import abv.ds.Wallet;

using abv.ds.TP;
using abv.sys.ST;
 
typedef WebContext = {
	status: Int,
	version: WebVersion,
	method: WebMethod,
	ip: Int,
	protocol: WebProtocol,
	host: String,
	port: Int,
	request: String,
	path: String,
	query: String,
	mime: String,
	cookies: String,
	r:MapSS,
	length: Int,
	body:Bytes,
}

enum WebMethod{
	POST;
	HEAD;
	GET;
}

enum WebVersion{
	HTTP10;
	HTTP11;
}

enum WebProtocol{
	WP_HTTP;
	WP_HTTPS;
}

@:dce
class WT{

	public static var SESSION_EXPIRE = 300;
	public static var USE_COOKIES = true;
// log levels
	public static inline var LERROR = "ERROR:";
	public static inline var LWARN  = "WARN :";
	public static inline var LINFO  = "INFO :";
	public static inline var LDEBUG = "DEBUG:";
	public static inline var LLOG   = "LOG  :";
//
	public static inline var CONTENT_DISP 	= "Content-Disposition";
	public static inline var CONTENT_TYPE 	= "Content-Type";	
	public static inline var CONTENT_LENGTH = "Content-Length";
	public static inline var DATE 			= "Date";
	public static inline var SERVER 		= "Server";
	public static inline var CONNECTION 	= "Connection";
	public static inline var KEEP_ALIVE 	= "keep-alive";
	public static inline var REFERER 		= "Referer";
	public static inline var IF_NONE_MATCH 	= "If-None-Match";
	public static inline var AUTHORIZATION 	= "Authorization";
	public static inline var ETAG 			= "ETag";
	public static inline var LOCATION 		= "Location"; 
	public static inline var HOST 			= "Host"; 
	public static inline var HTTP_11		= "HTTP/1.1"; 
	public static inline var COOKIE 		= "Cookie"; 
	public static inline var ICONS 			= "/icon"; 
	public static inline var FAVICON 		= "favicon.ico"; 
	public static inline var LHOME 			= '<a href="/">Home</a>'; 
	
	public static var tz = DateGMT.timezone();
	public static var dow = DateGMT.dow();
	public static var month = DateGMT.getMonth();
	static var sessions(default,null) = new Wallet();

	public static inline function getSession(ctx:WebContext)
	{
		var r:MapSS = null;
		if(USE_COOKIES){
			if(ctx.r.exists(COOKIE)){
				var cookies = parseCookie(ctx.r[COOKIE]); 
				if(cookies.exists("sid")){
					var a = cookies["sid"].split(CC.SEP1);
					r = sessions.get(a.pop());
				}
			}
			
			if(sessions.length == 0){
				var sid = sessions.add(SESSION_EXPIRE); 
				r = sessions.get(sid); 
				setCookie(ctx,"sid",sid);
			}
		}
		return r;
	}// getSession()

	public static inline function parseURI(s:String)
	{
		s = s.trim();
		var a:Array<String>;
		var r = {
			protocol : WP_HTTP,
			host : "",
			port : WServer.PORT,
			request : "",
			path : "",
			query : ""};

		if(s.indexOf("://") != -1){
			a = s.explode("://");
			if (a[0].eq("https"))r.protocol = WP_HTTPS;
			a = a[1].explode("/");
			var t = a.shift().explode(":");
			r.host = t[0];
			if(ST.good(t[1]))r.port = ST.toInt(t[1]); 
			s = "/" + a.join("/");
		}
		r.request = s;
		a = r.request.explode("?");
		r.path = a[0];
		if(a[1].good())r.query = a[1];
		
		return r;
	}// parseURI()
	
	public static inline function parseQuery(s:String)
	{  
		return TP.str2map(s.trim().urlDecode(),"=","&");	
	}// parseQuery()

	public static inline function parseCookie(s:String,sep=";")
	{
		return TP.str2map(s.urlDecode(),"=",sep);	
	}// parseCookie()

	public static inline function parsePostData(ctx:WebContext)
	{ 
		var r = new MapSS();
		var a = [""],t = [""],p = [""];
		var n = "",f = "",c = "",m = "";
		var b = "--" + ctx.r["boundary"];
		var lines = ctx.r["body"].explode(b); 
		for(l in lines){ 
			if(l.starts(CONTENT_DISP)){
				n = f = c = m = "";
				a = l.explode(CC.LF2);
				if(a[1].good())c = a[1];
				t = a[0].explode(CC.LF);
				if(t[1].starts(CONTENT_TYPE)){
					m = t[1].replace(CONTENT_TYPE+":"," ").trim();
				}
				
				p = t[0].explode(";");
				if(p[2].good()){
					f = p[2].replace("filename="," ").trim();
					f = f.replace('"'," ").trim();
				}

				n = p[1].replace("name="," ").trim();
				n = n.replace('"'," ").trim();
				if(n.good()){
					r.set(n,"");
					if(c.good()){
						if(f.good())r[n] = 'file:$f${CC.SEP3}$m${CC.SEP3}$c';
						else r[n] = c;
					}
				}
			}
		}
		
		return r;
	}// parsePostData()
	
	public static inline function parseRequest(s:String,m:WebMethod=null)
	{ // TODO: websockets, chunked 
		var r:WebContext = {
			status: 400,
			version: null,
			method: m,
			ip: 0,
			protocol : WP_HTTP,
			host : "",
			port : 80,
			request : "",
			path : "",
			query : "",
			mime: "",
			cookies: "",
			r: new MapSS(),
			length: 0,
			body: null,
		}

		var lines = s.trim().explode("\n");

		if(ST.good(lines[0])){
			var t = lines[0].explode(" ");
			if(t.length == 3){
				if(r.method == null){
					r.status = 501;
				}else{
					var uri = parseURI(t[1]); 
					r.protocol = uri.protocol; 
					r.host = uri.host; 
					r.port = uri.port; 
					r.request = uri.request; 
					r.path = uri.path; 
					r.query = uri.query;
			 
					if(ST.good(t[2])){
						if (t[2] == HTTP_11)r.version = HTTP11;
						else if (t[2] == "HTTP/1.0")r.version = HTTP10;
					}
					
					if(r.version == null){
						r.status = 505;
					}else{
						var f = "";
						for(i in 1...lines.length){
							t = lines[i].explode(":");
							f = t.shift();
							if(f.good())r.r[f] = t.join(":");
						}
						if(r.r.exists(CONTENT_LENGTH)){
							try r.length = r.r[CONTENT_LENGTH].toInt()
							catch(e:Dynamic){}
						}
						if(r.r[CONTENT_TYPE].starts("multipart")){
							t = r.r[CONTENT_TYPE].explode(";");
							r.r[CONTENT_TYPE] = t[0];
							if(t[1].good())r.r["boundary"] = t[1].replace("boundary=","");
						}

						r.status = 200; 
						if(!r.host.good() && (r.version == HTTP11)){
							if(r.r.exists(HOST)){
								t = r.r[HOST].explode(":");
								r.host = t[0];
								if(ST.good(t[1]))r.port = ST.toInt(t[1]); 
							}else{
								r.status = 400;
							}
						}
					}
				}
			}
		}
		return r;
	}// parseRequest()
	
	public static inline function response(ctx:WebContext)
	{
		var now = Date.now().getTime();
		var date = getDate(now);
		var header = "";

		if(!responseCode.exists(ctx.status)) ctx.status = 500;
		var code = ctx.status + " " + responseCode[ctx.status];
		header = HTTP_11 + " " + code + CC.LF;

		if(ctx.status != 200){
			ctx.body = mkPage('<center>${ctx.request}<h1>$code</h1><hr>${WServer.SIGN}</center>',code).toBytes(); 
		}

		if(ctx.status == 304){
		}else if ((ctx.status == 301) || (ctx.status == 303)){ 
			header += LOCATION + ": http://" + ctx.host + ":" + ctx.port + ctx.request + CC.LF;
		}else if(ctx.status == 401){
			header += 'WWW-Authenticate: Basic realm="Protected area"' + CC.LF + CONTENT_LENGTH + ": 0" + CC.LF;
		}else{
			if(!ctx.mime.good()) ctx.mime = "htm";
			var type = mimeType.exists(ctx.mime)?mimeType[ctx.mime]:mimeType["bin"];
			if(type.starts("text"))type += ";charset=utf-8";
			if(ctx.method == HEAD)ctx.body = null;
			if (ctx.body != null) ctx.length = ctx.body.length;
			header += CONTENT_TYPE + ": " + type + CC.LF +
			CONTENT_LENGTH + ": " + ctx.length + CC.LF ;
		}

		header += DATE + ": " + date + CC.LF; 
		if(etag(ctx).good()) header += ETAG + ": " + etag(ctx) + CC.LF;
		if(ctx.cookies.good()){
			var cc = parseCookie(ctx.cookies,"\n");
			for(k in cc.keys()) header += 'Set-Cookie: $k=${cc.get(k)}' + CC.LF;
		 }
		header += SERVER + ": " + WServer.SIGN + CC.LF +
		CONNECTION + ": " + KEEP_ALIVE + CC.LF2;
		var r:Bytes;
		if (ctx.body != null){
			r = Bytes.alloc(header.length + ctx.body.length);
			r.blit(0,header.toBytes(),0,header.length);
			r.blit(header.length,ctx.body,0,ctx.body.length);
		}else{
			r = header.toBytes(); 
		}
		 
		return r;
	}// response()
	
	public static inline function redirect(ctx:WebContext,url="/",code=303)
	{ 
		ctx.status = code;
		var p = parseURI(url); 
		if(p.host.good())ctx.host = p.host;
		ctx.port = p.port;
		if(p.request.good())ctx.request = p.request;
	}// redirect()

	public static inline function setCookie(ctx:WebContext,key:String,val="")
	{ 
		if(ST.good(key))ctx.cookies += '$key=$val\n';
	}// setCookie()

	public static inline function referer(ctx:WebContext,url="")
	{
		return ctx.r.exists(REFERER) && (ctx.r[REFERER] == url);
	}// referer()

	public static inline function refresh(time=0,url="")
	{
		var u = url.good()?"; url="+url:"";
		return '<meta http-equiv="refresh" content="$time$u">';
	}// refresh()

	public static inline function etag(ctx:WebContext)
	{
		var r = "";
		var ext = ctx.path.extname(); 
		if(ST.good(ext)) r = '"${Md5.encode(ctx.path)}"';
		return r;
	}// etag()
	
	public static inline function mkFile(ctx:WebContext)
	{
		var b:Bytes=null;
		var f = "";
		var path = ctx.path;
		var ext = path.extname();

		if(ST.good(ext))ctx.mime = ext; 
		else if(f.indexOf("\x00\x00\x00") == -1)ctx.mime = "txt";
		else ctx.mime = "bin";

		if(path == "/"+FAVICON) b = getIcon(ST.RES_DIR + ICONS + "/"+FAVICON);
		else if(path.starts(ICONS))b =  getIcon(ST.RES_DIR + path);
		else b = ST.openFile(WServer.ROOT + path.substr(1)); 
//		f = b + "";

		ctx.body = b; 
	}// mkFile()
	
	public static inline function mkPage(body="",title="",meta="")
	{
		var r =
'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>\n<head>\n <meta http-equiv=$CONTENT_TYPE content="text/html; charset=UTF-8">
 <link rel="stylesheet" type="text/css" href="/abv.css">$meta
 <title>$title</title>\n</head>
<body bgcolor="white">\n $body\n</body>\n</html>';

		return r;
	}// mkPage()
	
	public static inline function getDate(time:Float,log=false)
	{
		var utc = Date.fromTime(time - tz * 3600000); 
		var d = utc.getDate();
		var r = "";
		if(!log)r = '$dow, $d $month ${DateTools.format(utc,"%Y %H:%M:%S GMT")}';
		else r = '$d/$month/${DateTools.format(utc,"%Y:%H:%M:%S")} +0000';
		return r;
	}// getDate()

	public static inline function fsPath(url:String)
	{ 
		var path = url.substr(1).urlDecode(); 
		if(!path.good())path = ".";
		return path; 
	}// fsPath()
	
	public static inline function dirIndex(path=".",prefix="/",links=false)
	{ 
		var r = "";
		path = path.delSlash();
		if(ST.exists(path)){
			var ext = "",icon = "", f = "";
			var a = ST.ls(path);
			var dirs:Array<String> = [];
			var files:Array<String> = []; 
			for(it in a){
				if(ST.isDir(it))dirs.push(it);else files.push(it);
			}
			dirs.sortAZ(); 
			dirs.unshift(".."); 
			files.sortAZ();
			if(path == ".")path=""; 
			for(it in dirs){
				path = path.replace(WServer.ROOT,"");
				f = it == ".."?path.dirname():path + "/" +it.basename().urlEncode();
				r += '<img src="$ICONS/dir.png" alt="dir.png" width="16" height="16" /> <a href="$prefix$f">${it.basename()}/</a><br>\n';
			}
		
			for(it in files){
				icon = ST.file(it).type;
				it =  ST.basename(it);
				f = links ? '<a href="$prefix$path$it">$it</a>': it;
				r += '<img src="$ICONS/$icon.png" alt="$icon.png" width="16" height="16" /> $f<br>\n';
			}
		}
		return r;	
	}// dirIndex()

	public static inline function getIcon(path:String)
	{ 
		var none = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1+jfqAAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAACxMAAAsTAQCanBgAAAAHdElNRQfgBAsHOxNFUiiAAAAAPElEQVQoz2NkYGBgqPvPgAGaGJE4df/RQd1/mCYmBhygEWouTgX1UKtZcOmHKcJpAgyMKiBSAQsi5LEDAGa3HAJMYCPZAAAAAElFTkSuQmCC";
		var r:Bytes = VFS.openFile(path);
		if (r == null) r = haxe.crypto.Base64.decode(none);
		return r;
	}// getIcon()
	
	public static inline function mkList(a:Array<String>,url="",css="",sep="")
	{
		var r = "", h = "", t = "", p = 0;
		var cs = css.good()?' class="$css" ':"";
		if(a.length < 1){}
		else{ 
			r = '<ul $cs>';
			for(w in a){
				if(sep.good()){
					p = w.indexOf(sep);
					if(p != -1){
						h = w.substr(0,p);
						t = w.substr(p);
					}
				}else h = w;
				if(url.good())r += '<li><a $cs href="$url/${h.urlEncode()}">$h $t</a></li>\n';
				else r += '<li>$h $t</li>\n';
			}
			r += "</ul>";
		}
		return r;
	}// mkList()
	
	public static inline function path2url(p:String,url="",sep="/")
	{
		var r = "", s = url;
		if(p.good()){
			var a = p.explode("/");
			for(l in a){
				s += "/" + l;
				r += '$sep<a href="$s">$l</a>';
			}
		}
		return r;
	}// path2url()

	public static inline function span(s="",cl=""){return '<span class="$cl">$s</span>';}
	public static inline function strong(s=""){return "<strong>" + s + "</strong>";}
	public static inline function p(s=""){return "<p>" + s + "</p>";}
	public static inline function h2(s=""){return "<h2>" + s + "</h2>";}
	public static inline function h3(s=""){return "<h3>" + s + "</h3>";}
	public static inline function a(s="",url="",js=""){return '<a href="$url" $js>$s</a>';}
//
	public static var mimeType = [
			"html" 		=> "text/html",
			"htm" 		=> "text/html",
			"shtm" 		=> "text/html",
			"shtml" 	=> "text/html",
			"css" 		=> "text/css",
			"js" 		=> "application/x-javascript",
			"ico" 		=> "image/x-icon",
			"gif" 		=> "image/gif",
			"jpg" 		=> "image/jpeg",
			"jpeg" 		=> "image/jpeg",
			"png" 		=> "image/png",
			"bmp" 		=> "image/bmp",
			"svg" 		=> "image/svg+xml",
			"txt" 		=> "text/plain",
			"torrent"	=> "application/x-bittorrent",
			"wav" 		=> "audio/x-wav",
			"mp3" 		=> "audio/x-mp3",
			"mid" 		=> "audio/mid",
			"m3u" 		=> "audio/x-mpegurl",
			"ogg" 		=> "audio/ogg",
			"ram" 		=> "audio/x-pn-realaudio",
			"xml" 		=> "text/xml",
			"json" 		=> "text/json",
			"xslt" 		=> "application/xml",
			"xsl" 		=> "application/xml",
			"ra" 		=> "audio/x-pn-realaudio",
			"doc" 		=> "application/msword",
			"exe" 		=> "application/octet-stream",
			"bin" 		=> "application/octet-stream",
			"zip" 		=> "application/x-zip-compressed",
			"7z" 		=> "application/x-7z-compressed",
			"xls" 		=> "application/excel",
			"tgz" 		=> "application/x-tar-gz",
			"tar" 		=> "application/x-tar",
			"gz" 		=> "application/x-gunzip",
			"arj" 		=> "application/x-arj-compressed",
			"rar" 		=> "application/x-arj-compressed",
			"rtf" 		=> "application/rtf",
			"pdf" 		=> "application/pdf",
			"swf" 		=> "application/x-shockwave-flash",
			"mpg" 		=> "video/mpeg",
			"webm" 		=> "video/webm",
			"mpeg" 		=> "video/mpeg",
			"mov" 		=> "video/quicktime",
			"mp4" 		=> "video/mp4",
			"m4v" 		=> "video/x-m4v",
			"asf" 		=> "video/x-ms-asf",
			"avi" 		=> "video/x-msvideo",
			"hx" 		=> "text/plain",
			"n" 		=> "application/octet-stream",
			"ttf" 		=> "application/x-font-ttf",
			"post-url" 	=> "application/x-www-form-urlencoded",
			"post-dat" 	=> "multipart/form-data",
			"post-mix" 	=> "multipart/mixed",
			];

	public static var responseCode = [
			100 => "Continue",
			101 => "Switching Protocols",
			200 => "OK",
			201 => "Created",
			202 => "Accepted",
			203 => "Non-Authoritative Information",
			204 => "No Content",
			205 => "Reset Content",
			206 => "Partial Content",
			300 => "Multiple Choices",
			301 => "Moved Permanently",
			302 => "Found",
			303 => "See Other",
			304 => "Not Modified",
			305 => "Use Proxy",
			307 => "Temporary Redirect",
			400 => "Bad Request",
			401 => "Unauthorized",
			402 => "Payment Required",
			403 => "Forbidden",
			404 => "Not Found",
			405 => "Method Not Allowed",
			406 => "Not Acceptable",
			407 => "Proxy Authentication Required",
			408 => "Request Time-out",
			409 => "Conflict",
			410 => "Gone",
			411 => "Length Required",
			412 => "Precondition Failed",
			413 => "Request Entity Too Large",
			414 => "Request-URI Too Large",
			415 => "Unsupported Media Type",
			416 => "Requested range not satisfiable",
			417 => "Expectation Failed",
			500 => "Internal Server Error",
			501 => "Not Implemented",
			502 => "Bad Gateway",
			503 => "Service Unavailable",
			504 => "Gateway Time-out",
			505 => "HTTP Version not supported"];
		

}// abv.net.web.WT

