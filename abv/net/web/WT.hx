package abv.net.web;
/**
 * WebTools
 **/
import sys.FileSystem;
import abv.net.web.Icons;
import abv.net.web.WebServer;

using StringTools;
using abv.CT;
 

class WT{

	public static var tz = CT.timezone();
	public static var dow = CT.dow();
	public static var month = CT.month();

	public static var methods = ["GET","POST","HEAD"];
	public static var versions = ["HTTP/1.0","HTTP/1.1"];
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
			"zip" 		=> "application/x-zip-compressed",
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
			"bmp" 		=> "image/bmp",
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
		
	public static var extHtm = ["hxml","htm","html","xml","xhtml","shtml"];
	public static var extImg = ["png","gif","jpg","jpeg","bmp","ico","svg","xcf","tiff"];
	public static var extBin = ["n","o","exe","cgi"];
	public static var extTxt = ["txt","css","json"];
	public static var extScr = ["js","php","sh","pl","py","hxs"];
	public static var extZip = ["zip","7z","gz","lz","bz2"];
	public static var extMp3 = ["mp3","m3u","mid","wav","rm"];
	public static var extMp4 = ["mp4","avi","flv","mov","webm"];
	public static var extVar = ["cpp","h","hx","pdf"];  

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
		r["path"] = a[0];
		if(a[1].good())r["query"] = a[1];
		
		return r;
	}// parseURI()
	
	public static function parseQuery(s:String)
	{
		var r = new Map<String,Array<String>>();
		var t:Array<String>;
		
		if(s.good()){
			var lines = s.trim().splitt("&");
			for(l in lines){
				t = l.splitt("=");
				if(t[0].good()){
					r.set(t[0],[]);
					if(t[1].good())r[t[0]][0] = t[1].urlDecode();
				}
			}
		}
		r.set("mimeType",[mimeType["post-url"]]);
				
		return r;
	}// parseQuery()
	
	public static function parsePostData(ctx:Map<String,String>)
	{
		var r = new Map<String,Array<String>>();
		var a = [""],t = [""],p = [""];
		var n = "",f = "",c = "",m = "";
		var b = "--" + ctx["boundary"];
		var lines = ctx["body"].splitt(b); 
		for(l in lines){ 
			if(l.startsWith("Content-Disposition")){
				n = f = c = m = "";
				a = l.splitt("\r\n\r\n");
				if(a[1].good())c = a[1];
				t = a[0].splitt("\r\n");
				if(t[1].good() && t[1].startsWith("Content-Type:")){
					m = t[1].replace("Content-Type:"," ").trim();
				}
				
				p = t[0].splitt(";");
				if(p[2].good()){
					f = p[2].replace("filename="," ").trim();
					f = f.replace('"'," ").trim();
				}

				n = p[1].replace("name="," ").trim();
				n = n.replace('"'," ").trim();
				if(n.good()){
					r.set(n,[]);
					if(c.good()){
						r[n][0] = c;
						if(f.good())r[n][1] = f;
						if(m.good())r[n][2] = m;
					}
				}
				
//			trace(m);
			}
		}
		r.set("mimeType",[mimeType["post-dat"]]);
		
		return r;
	}// parsePostData()
	
	public static function parseRequest(s:String)
	{ // todo: websockets
		var r = [
			"status" => "400", "protocol" => "","version" => "",
			"host" => "", "port" => "",	"request" => "", "path" => "",
			"query" => "", "body" => "", "title" => "", "length" => "0",
			"etag" => "", "mime" => "", "Content-Type" => "", "boundary" => ""];
		var lines = s.trim().splitt("\n");

		if(!lines[0].good()) return r;
		 
		var t = lines[0].splitt(" ");
		if(t.length != 3)return r;
		r["method"] = t[0];
		if(methods.indexOf(r["method"]) == -1){
			r["status"] = "501";
			return r;
		}
 
		var uri = parseURI(t[1]); 
		for(k in uri.keys())r[k] = uri[k];
 
		if(t[2].good())r["version"] = t[2].trim();
		if(versions.indexOf(r["version"]) == -1){
			r["status"] = "505";
			return r;
		}
		
		var f = "";
		for(i in 1...lines.length){
			t = lines[i].splitt(":");
			f = t.shift();
			if(f.good())r[f] = t.join(":");
		}

		if(r["Content-Type"].good() && r["Content-Type"].startsWith("multipart")){
			t = r["Content-Type"].splitt(";");
			r["Content-Type"] = t[0];
			if(t[1].good())r["boundary"] = t[1].replace("boundary="," ").trim();
		}

		if(!r["host"].good() && (r["version"] == "HTTP/1.1")){
			if(r.exists("Host")){
				t = r["Host"].splitt(":");
				r["host"] = t[0];
				if(t[1].good())r["port"] = t[1];
			}else return r;
		}
		r["status"] = "200";
		return r;
	}// parseRequest()
	
	public static inline function response(ctx:Map<String,String>)
	{
		var date = getDate();
		var body = "";

		if(!responseCode.exists(ctx["status"]))ctx["status"] = "500";
		var code = ctx["status"] + " " + responseCode[ctx["status"]];
		var r = "HTTP/1.1 " + code + "\r\n";

		if(ctx["status"] != "200"){
			ctx["body"] = "";
			ctx["title"] = code;
		}
		if(!ctx["body"].good())
			ctx["body"] = '<center>${ctx["request"]}<h1>$code</h1><hr>${WebServer.sign}</center>';

		if(ctx["status"] == "304"){
		}else if(ctx["status"] == "303"){
			var port = ctx["port"].good()?":"+ctx["port"]:"";
			var query = ctx["query"].good()?"?"+ctx["query"]:"";
			r += "Location: http://" + ctx["host"] + port + ctx["path"] + query + "\r\n";
		}else if(ctx["status"] == "401"){
			r += 'WWW-Authenticate: Basic realm="${WebServer.sign}"' + "\r\nContent-Length: 0\r\n";
		}else{
			if(ctx["mime"] != "") body = ctx["body"] ; 
			else{
				body =
'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>\n<head>\n <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <title>${ctx["title"]}</title>\n</head>
<body bgcolor="white">\n ${ctx["body"]}\n</body>\n</html>';
				ctx["mime"] = "htm";
			}
			ctx["length"] = body.length +"";
			if(ctx["method"] == "HEAD")body = "";
			if(ctx["etag"].good())ctx["etag"] += "\r\n";
			r += "Content-Type: " + mimeType[ctx["mime"]] + "\r\n" +
			"Content-Length: " + ctx["length"] + "\r\n" ;
		}

		r += "Date: " + date + "\r\n" + ctx["etag"] +
		"Server: " + WebServer.sign + "\r\n" +
		"Connection: Keep-Alive\r\n" + "\r\n" + body;
 
		return r;
	}// response()
	
	public static inline function getDate(log=false)
	{
		var utc = Date.fromTime(Date.now().getTime() - tz * 3600000); 
		var d = utc.getDate();
		var r = "";
		if(!log)r = '$dow, $d $month ${DateTools.format(utc,"%Y %H:%M:%S GMT")}';
		else r = '$d/$month/${DateTools.format(utc,"%Y:%H:%M:%S")} +0000';
		return r;
	}// getDate()

	public static function dirIndex(path=".",prefix="/fs/")
	{
		var r = "",ext = "",type = "";
		if(!path.good())path=".";
		if(!FileSystem.exists(path))return r;
		var f = "";
		var a = FileSystem.readDirectory(path);	
		var dirs:Array<String> = [];
		var files:Array<String> = [];
		for(p in a){
			if(FileSystem.isDirectory(path+"/"+p))dirs.push(p);else files.push(p);
		}
		dirs.sortAZ();
		dirs.unshift("..");
		files.sortAZ();
		for(p in dirs){
			f = p == ".."?path.dirname():path+"/"+p;
			r += '<img src="${Icons.p}dir.png" alt="dir.png" width="16" height="16" /> <a href="$prefix$f">$p/</a><br>';
		}
		for(p in files){
			type = ext2type(p.extname());
			r += '<img src="${Icons.p}$type.png" alt="$type.png" width="16" height="16" /> $p<br>';
		}
		
		return r;	
	}// dirIndex()

	public static inline function getIcon(n:String)
	{
		var r = "";
		switch(n){
			case "bin": r = Icons.bin;
			case "cpp": r = Icons.cpp;
			case "dir": r = Icons.dir;
			case "favicon": r = Icons.favicon;
			case "h": r = Icons.h;
			case "htm": r = Icons.htm;
			case "hx": r = Icons.hx;
			case "img": r = Icons.img;
			case "mp3": r = Icons.mp3;
			case "mp4": r = Icons.mp4;
			case "non": r = Icons.non;
			case "pdf": r = Icons.pdf;
			case "scr": r = Icons.scr;
			case "txt": r = Icons.txt;
			case "zip": r = Icons.zip;
			default: r = Icons.non;
		}
		
		return haxe.crypto.Base64.decode(r)+"";
	}// getIcon()
	
	public static inline function ext2type(ext:String)
	{
 	         
		var type = "non";

		if(extHtm.indexOf(ext) != -1)type = "htm";
		else if(extImg.indexOf(ext) != -1)type = "img";
		else if(extBin.indexOf(ext) != -1)type = "bin";
		else if(extTxt.indexOf(ext) != -1)type = "txt";
		else if(extScr.indexOf(ext) != -1)type = "scr";
		else if(extZip.indexOf(ext) != -1)type = "zip";
		else if(extMp3.indexOf(ext) != -1)type = "mp3";
		else if(extMp4.indexOf(ext) != -1)type = "mp4";
		else{
			var i = extVar.indexOf(ext);
			if(i != -1)type = extVar[i];
		}
		
		return type;
	}// ext2type()	

}// abv.net.web.WT

