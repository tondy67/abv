package abv.net.web;
/**
 * WebTools
 **/
import haxe.crypto.Md5;
import haxe.io.Bytes;
import abv.net.web.Icons;
import abv.net.web.WebServer;

using abv.lib.TP;
using abv.sys.ST;
using abv.CR;
 

class WT{

	public static inline var CONTENT_DISPOSITION = "Content-Disposition";
	public static inline var CONTENT_TYPE 		= "Content-Type";	
	public static inline var CONTENT_LENGTH 	= "Content-Length";
	public static inline var DATE 				= "Date";
	public static inline var SERVER 			= "Server";
	public static inline var CONNECTION 		= "Connection";
	public static inline var KEEP_ALIVE 		= "keep-alive";
	public static inline var REFERER 			= "Referer";
	public static inline var IF_NONE_MATCH 		= "If-None-Match";
	public static inline var AUTHORIZATION 		= "Authorization";
	public static inline var ETAG 				= "ETag";
	public static inline var HTTP10 			= "HTTP/1.0";
	public static inline var HTTP11 			= "HTTP/1.1"; 
	public static inline var LOCATION 			= "Location"; 
	public static inline var GET 				= "GET"; 
	public static inline var POST 				= "POST"; 
	public static inline var HEAD 				= "HEAD"; 
	public static inline var HOST 				= "Host"; 
	public static inline var COOKIE 			= "Cookie"; 
	
	public static var tmp = "www/tmp/";
	public static var tz = CR.timezone();
	public static var dow = CR.dow();
	public static var month = CR.month();

	public static inline var methods = '$GET $POST $HEAD';
	public static inline var versions = '$HTTP10 $HTTP11';
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
			"torrent"	=>"application/x-bittorrent",
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
			"100" => "Continue",
			"101" => "Switching Protocols",
			"200" => "OK",
			"201" => "Created",
			"202" => "Accepted",
			"203" => "Non-Authoritative Information",
			"204" => "No Content",
			"205" => "Reset Content",
			"206" => "Partial Content",
			"300" => "Multiple Choices",
			"301" => "Moved Permanently",
			"302" => "Found",
			"303" => "See Other",
			"304" => "Not Modified",
			"305" => "Use Proxy",
			"307" => "Temporary Redirect",
			"400" => "Bad Request",
			"401" => "Unauthorized",
			"402" => "Payment Required",
			"403" => "Forbidden",
			"404" => "Not Found",
			"405" => "Method Not Allowed",
			"406" => "Not Acceptable",
			"407" => "Proxy Authentication Required",
			"408" => "Request Time-out",
			"409" => "Conflict",
			"410" => "Gone",
			"411" => "Length Required",
			"412" => "Precondition Failed",
			"413" => "Request Entity Too Large",
			"414" => "Request-URI Too Large",
			"415" => "Unsupported Media Type",
			"416" => "Requested range not satisfiable",
			"417" => "Expectation Failed",
			"500" => "Internal Server Error",
			"501" => "Not Implemented",
			"502" => "Bad Gateway",
			"503" => "Service Unavailable",
			"504" => "Gateway Time-out",
			"505" => "HTTP Version not supported"];
		
	public static inline var extHtm = " hxml htm html xml xhtml shtml ";
	public static inline var extImg = " png gif jpg jpeg bmp ico svg xcf tiff ";
	public static inline var extBin = " n o exe bin cgi ";
	public static inline var extTxt = " txt css md json ";
	public static inline var extSrc = " js php sh pl py hxs ";
	public static inline var extZip = " zip 7z gz lz bz2 ";
	public static inline var extMp3 = " mp3 m3u mid wav rm ";
	public static inline var extMp4 = " mp4 avi flv mov webm ";
	public static inline var extVar = " cpp h hx pdf ";  

	public static inline function parseURI(s:String)
	{
		s = s.trim();
		var a:Array<String>;
		var r = ["protocol" => "","host" => "","port" => "",
			"request" => "","path" => "","query" => ""];

		if(s.indexOf("://") != -1){
			a = s.splitt("://");
			r["protocol"] = a[0];
			a = a[1].splitt("/");
			var t = a.shift().splitt(":");
			r["host"] = t[0];
			if(t[1].good())r["port"] = t[1]; 
			s = "/" + a.join("/");
		}
		r["request"] = s;
		a = r["request"].splitt("?");
		r["path"] = a[0]; //trace(r["path"] );
		if(a[1].good())r["query"] = a[1];
		
		return r;
	}// parseURI()
	
	public static inline function parseQuery(s:String)
	{
		return TP.str2map(s.urldecode(),"=","&");	
	}// parseQuery()

	public static inline function parseCookie(s:String,sep=";")
	{
		return TP.str2map(s.urldecode(),"=",sep);	
	}// parseCookie()

	public static inline function parsePostData(ctx:Map<String,String>)
	{
		var r = new Map<String,String>();
		var a = [""],t = [""],p = [""];
		var n = "",f = "",c = "",m = "";
		var b = "--" + ctx["boundary"];
		var lines = ctx["body"].splitt(b); 
		for(l in lines){ 
			if(l.starts(CONTENT_DISPOSITION)){
				n = f = c = m = "";
				a = l.splitt(CR.LF2);
				if(a[1].good())c = a[1];
				t = a[0].splitt(CR.LF);
				if(t[1].good() && t[1].starts(CONTENT_TYPE)){
					m = t[1].replace(CONTENT_TYPE+":"," ").trim();
				}
				
				p = t[0].splitt(";");
				if(p[2].good()){
					f = p[2].replace("filename="," ").trim();
					f = f.replace('"'," ").trim();
				}

				n = p[1].replace("name="," ").trim();
				n = n.replace('"'," ").trim();
				if(n.good()){
					r.set(n,"");
					if(c.good()){
						if(f.good())r[n] = 'file:$f${CR.SEP3}$m${CR.SEP3}$c';
						else r[n] = c;
					}
				}
			}
		}
		
		return r;
	}// parsePostData()
	
	public static inline function parseRequest(s:String)
	{ // todo: websockets, chunked 
		var r = [
			"sid" => "","status" => "400", "protocol" => "","version" => "",
			"host" => "", "port" => "",	"request" => "", "path" => "","cookies" => "",
			"query" => "", "body" => "", "title" => "", "length" => "0",
			"etag" => "", "mime" => "", CONTENT_TYPE => "", "boundary" => ""];
		var lines = s.trim().splitt("\n");

		if(lines[0].good()){
			var t = lines[0].splitt(" ");
			if(t.length == 3){
				r["method"] = t[0];
				if(methods.indexOf(r["method"]) == -1){
					r["status"] = "501";
				}else{
					var uri = parseURI(t[1]); 
					for(k in uri.keys())r[k] = uri[k];
			 
					if(t[2].good())r["version"] = t[2].trim();
					if(versions.indexOf(r["version"]) == -1){
						r["status"] = "505";
					}else{
						var f = "";
						for(i in 1...lines.length){
							t = lines[i].splitt(":");
							f = t.shift();
							if(f.good())r[f] = t.join(":");
						}

						if(r[CONTENT_TYPE].good() && r[CONTENT_TYPE].starts("multipart")){
							t = r[CONTENT_TYPE].splitt(";");
							r[CONTENT_TYPE] = t[0];
							if(t[1].good())r["boundary"] = t[1].replace("boundary=","");
						}

						r["status"] = "200"; 
						if(!r["host"].good() && (r["version"] == HTTP11)){
							if(r.exists(HOST)){
								t = r[HOST].splitt(":");
								r["host"] = t[0];
								if(t[1].good())r["port"] = t[1]; 
							}else r["status"] = "400";
						}
					}
				}
			}
		}
		return r;
	}// parseRequest()
	
	public static inline function response(ctx:Map<String,String>)
	{
		var now = Date.now().getTime();
		var date = getDate(now);
		var body = "";

		if(!responseCode.exists(ctx["status"]))ctx["status"] = "500";
		var code = ctx["status"] + " " + responseCode[ctx["status"]];
		var r = HTTP11 + " " + code + CR.LF;

		if(ctx["status"] != "200"){
			ctx["body"] = "";
			ctx["title"] = code;
		}
		if(!ctx["body"].good())
			ctx["body"] = mkPage('<center>${ctx["request"]}<h1>$code</h1><hr>${WebServer.SIGN}</center>',code);

		if(ctx["status"] == "304"){
		}else if(ctx["status"] == "303"){ 
			var port = ctx["port"].good()?":"+ctx["port"]:""; 
			r += LOCATION + ": http://" + ctx["host"] + port + ctx["request"] + CR.LF;
		}else if(ctx["status"] == "401"){
			r += 'WWW-Authenticate: Basic realm="Protected area"' + CR.LF + CONTENT_LENGTH + ": 0" + CR.LF;
		}else{
			body = ctx["body"] ; 
			if(!ctx["mime"].good()) ctx["mime"] = "htm";
			var type = mimeType.exists(ctx["mime"])?mimeType[ctx["mime"]]:mimeType["bin"];
			if(type.starts("text"))type += ";charset=utf-8";
			ctx["length"] = body.length +"";
			if(ctx["method"] == "HEAD")body = "";
			r += CONTENT_TYPE + ": " + type + CR.LF +
			CONTENT_LENGTH + ": " + ctx["length"] + CR.LF ;
		}

		r += DATE + ": " + date + CR.LF; 
		if(etag(ctx).good()) r += ETAG + ": " + etag(ctx) + CR.LF;
		if(ctx["cookies"].good()){
			var cc = parseCookie(ctx["cookies"],"\n");
			for(k in cc.keys()) r += 'Set-Cookie: $k=${cc.get(k)}' + CR.LF;
		 }
		r += SERVER + ": " + WebServer.SIGN + CR.LF +
		CONNECTION + ": " + KEEP_ALIVE + CR.LF2 + body;
		 
		return Bytes.ofString(r);
	}// response()
	
	public static inline function redirect(ctx:Map<String,String>,url="/")
	{ 
		ctx["status"] = "303";
		var p = parseURI(url); 
		if(p["host"].good())ctx["host"] = p["host"];
		if(p["port"].good())ctx["port"] = p["port"];
		if(p["request"].good())ctx["request"] = p["request"];
	}// redirect()

	public static inline function referer(ctx:Map<String,String>,url="")
	{
		return ctx.exists(REFERER) && (ctx[REFERER] == url);
	}// referer()

	public static inline function etag(ctx:Map<String,String>)
	{
		var r = "";
		var ext = ctx["path"].extname(); 
		if(ext.good() && (ext != "hxs"))
			r = '"${Md5.encode(ctx["path"]+ctx["sid"])}"';
		return r;
	}// etag()
	
	public static inline function mkFile(ctx:Map<String,String>)
	{
		var f = "";
		var path = ctx["path"];
		var ext = path.extname();
		if(path == "/favicon.ico") f = WT.getIcon("favicon");
		else if(path.starts(Icons.p))f =  WT.getIcon(path.basename(false));
		else f = path.open();
		if(ext.good())ctx["mime"] = ext;
		else if(f.indexOf("\x00\x00\x00") == -1)ctx["mime"] = "txt";
		else ctx["mime"] = "bin";
		ctx["body"] = f; 
	}// mkFile()
	
	public static inline function mkPage(body="",title="",meta="")
	{
		var r =
'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>\n<head>\n <meta http-equiv=$CONTENT_TYPE content="text/html; charset=UTF-8">
 <link rel="stylesheet" type="text/css" href="/hako.css">$meta
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

	public static function dirIndex(path=".",prefix="/fs/",links=false)
	{
		var r = "",ext = "",type = "", f = "";
		if(!path.good())path=".";
		if(!path.exists())return r;
		var a = path.get();	
		var dirs:Array<String> = [];
		var files:Array<String> = [];
		for(p in a){
			if(ST.dir(path+"/"+p))dirs.push(p);else files.push(p);
		}
		dirs.sortAZ();
		dirs.unshift("..");
		files.sortAZ();
		for(p in dirs){
			f = p == ".."?path.dirname():path+"/"+p.urlencode();
			r += '<img src="${Icons.p}dir.png" alt="dir.png" width="16" height="16" /> <a href="$prefix$f">$p/</a><br>';
		}
		for(p in files){
			type = ext2type(p.extname());
			f = links ? '<a href="$prefix$path$p">$p</a>': p;
			r += '<img src="${Icons.p}$type.png" alt="$type.png" width="16" height="16" /> $f<br>';
		}
		
		return r;	
	}// dirIndex()

	public static inline function getIcon(n:String)
	{
		var r = 
			switch(n){
				case "bin": 	 Icons.bin;
				case "cpp": 	 Icons.cpp;
				case "dir": 	 Icons.dir;
				case "favicon":  Icons.favicon;
				case "h": 		 Icons.h;
				case "htm": 	 Icons.htm;
				case "hx": 		 Icons.hx;
				case "img": 	 Icons.img;
				case "mp3": 	 Icons.mp3;
				case "mp4": 	 Icons.mp4;
				case "non": 	 Icons.non;
				case "pdf": 	 Icons.pdf;
				case "src": 	 Icons.src;
				case "txt": 	 Icons.txt;
				case "zip": 	 Icons.zip;
				default: 		 Icons.non;
			}
		
		return haxe.crypto.Base64.decode(r)+"";
	}// getIcon()
	
	public static inline function ext2type(ext:String)
	{
 	         
		var type = "non";
		if(ext.good()){
			ext = ' $ext ';
			if(extHtm.indexOf(ext) != -1)type = "htm";
			else if(extImg.indexOf(ext) != -1)type = "img";
			else if(extBin.indexOf(ext) != -1)type = "bin";
			else if(extTxt.indexOf(ext) != -1)type = "txt";
			else if(extSrc.indexOf(ext) != -1)type = "src";
			else if(extZip.indexOf(ext) != -1)type = "zip";
			else if(extMp3.indexOf(ext) != -1)type = "mp3";
			else if(extMp4.indexOf(ext) != -1)type = "mp4";
			else{
				var i = extVar.indexOf(ext);
				if(i != -1)type = extVar.substr(i+1,ext.length-2);
			}
		}
 
		return type;
	}// ext2type()	

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
				if(url.good())r += '<li><a $cs href="$url/${h.urlencode()}">$h $t</a></li>\n';
				else r += '<li>$h $t</li>\n';
			}
			r += "</ul>";
		}
		return r;
	}// mkList()
	

}// abv.net.web.WT

