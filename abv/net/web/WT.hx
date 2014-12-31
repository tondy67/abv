package abv.net.web;
/**
 * WebTools
 **/
import sys.FileSystem;
import abv.net.web.Icons;

using StringTools;
using abv.CT;
 
typedef Srv = abv.net.web.WebServer;

class WT{

	public static var tz = CT.timezone();
	public static var dow = CT.dow();
	public static var month = CT.month();

	public static var methods = ["GET","POST","HEAD"];
	public static var versions = ["HTTP/1.0","HTTP/1.1"];
	public static var mimeType = [
			"html" =>  "text/html",
			"htm" =>   "text/html",
			"shtm" =>  "text/html",
			"shtml" => "text/html",
			"css" =>   "text/css",
			"js" =>    "application/x-javascript",
			"ico" =>   "image/x-icon",
			"gif" =>   "image/gif",
			"jpg" =>   "image/jpeg",
			"jpeg" =>  "image/jpeg",
			"png" =>   "image/png",
			"svg" =>   "image/svg+xml",
			"txt" =>   "text/plain",
			"torrent"=>"application/x-bittorrent",
			"wav" =>   "audio/x-wav",
			"mp3" =>   "audio/x-mp3",
			"mid" =>   "audio/mid",
			"m3u" =>   "audio/x-mpegurl",
			"ogg" =>   "audio/ogg",
			"ram" =>   "audio/x-pn-realaudio",
			"xml" =>   "text/xml",
			"json" =>  "text/json",
			"xslt" =>  "application/xml",
			"xsl" =>   "application/xml",
			"ra" =>    "audio/x-pn-realaudio",
			"doc" =>   "application/msword",
			"exe" =>   "application/octet-stream",
			"zip" =>   "application/x-zip-compressed",
			"xls" =>   "application/excel",
			"tgz" =>   "application/x-tar-gz",
			"tar" =>   "application/x-tar",
			"gz" =>    "application/x-gunzip",
			"arj" =>   "application/x-arj-compressed",
			"rar" =>   "application/x-arj-compressed",
			"rtf" =>   "application/rtf",
			"pdf" =>   "application/pdf",
			"swf" =>   "application/x-shockwave-flash",
			"mpg" =>   "video/mpeg",
			"webm" =>  "video/webm",
			"mpeg" =>  "video/mpeg",
			"mov" =>   "video/quicktime",
			"mp4" =>   "video/mp4",
			"m4v" =>   "video/x-m4v",
			"asf" =>   "video/x-ms-asf",
			"avi" =>   "video/x-msvideo",
			"bmp" =>   "image/bmp",
			"hx" =>    "text/plain",
			"n" =>     "application/octet-stream",
			"ttf" =>   "application/x-font-ttf"];

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

	public static function parseRequest(s:String)
	{
		var f = "";
		var r = ["status" => "400"];
		var lines = s.trim().split("\n");

		if(!lines[0].good()) return r;
		r.set("request",lines[0].trim());
		var t = r["request"].split(" ");
		if(t.length != 3)return r;
		if(t[0].good())r.set("method",t[0].trim());
		if(methods.indexOf(r["method"]) == -1){
			r["status"] = "501";
			return r;
		}
		if(t[1].good())r.set("query",t[1].trim());
		if(t[2].good())r.set("version",t[2].trim());
		if(versions.indexOf(r["version"]) == -1){
			r["status"] = "505";
			return r;
		}
		
		if(lines[1].good()){
			t = lines[1].trim().split(":"); 
			if(t[0] == "Host"){
				if(t[1].good())r.set("host",t[1].trim());
				if(t[2].good())r.set("port",t[2].trim());
			}else if(r["version"] == "HTTP/1.1")return r;
		} else return r;
		
		r["status"] = "200";
		for(i in 2...lines.length){
			t = lines[i].trim().split(":");
			f = t.shift();
			if(f.good())r.set(f,t.join(":").trim());
		}
		r.set("body","");
		r.set("title","");
		r.set("length","");
		r.set("type","html");

		return r;
	}// parseRequest()
	
	public static inline function response(ctx:Map<String,String>)
	{
		var date = getDate();
		if(!responseCode.exists(ctx["status"]))ctx["status"] = "500";
		if(ctx["status"] != "200"){
			ctx["body"] = ctx["title"] = "";
		}
		var code = ctx["status"] + " " + responseCode[ctx["status"]];
		if(ctx["title"] == "")ctx["title"] = code;
		if(ctx["body"] == "")ctx["body"] = '<h2>$code</h2>${ctx["query"]} <hr><address>${Srv.sign}</address>';
		var r = "";

		if(ctx["status"] == "303"){
			var port = ctx.exists("port")?":"+ctx["port"]:"";
			r = 
'HTTP/1.1 $code
Location: http://${ctx["host"]}$port${ctx["query"]}' +  "\r\n\r\n";
		}else{
			var body = ctx["type"] == "html" ? 
'<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <title> ${ctx["title"]} </title>
</head>
<body>
 ${ctx["body"]}
</body>
</html>':ctx["body"];
			ctx["length"] = body.length +"";
			r = 
'HTTP/1.1 $code
Content-Type: ${mimeType[ctx["type"]]}
Content-Length: ${ctx["length"]} 
Date: $date
Server: ${Srv.sign}
Connection: Keep-Alive
Keep-Alive: timeout=5' + "\r\n\r\n" + body;
		}

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
	
	public static function ext2type(ext:String)
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

