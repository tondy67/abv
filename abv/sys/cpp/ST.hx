package abv.sys.cpp;
/**
 * SystemTools
 **/
import abv.AM;
import sys.io.Process;
import sys.FileSystem;
import sys.io.File;
import abv.cpu.Boss;
import abv.cpu.Mutex;
import abv.cpu.Timer;

using abv.lib.TP;
using abv.lib.CR;

@:dce
class ST{

	public static var lock(default,null) = new Mutex();

	inline function new(){ }

	public static inline function trace(v:Null<Dynamic>,?infos:Null<haxe.PosInfos>)
	{   
		var s = Std.string(v).trim();
		var level = CR.getLevel(s);
		if(CR.lvl2int(AM.verbose) >= CR.lvl2int(level)){ 
			if(s.starts("now:"))s = s.replace("now:",Timer.stamp+"");
			if(level.good())s = s.replace(level,"");
			var color = CR.lvl2color(level);
			if(color.good())s = colorize(s,color); 
			Sys.print(s);
			Sys.print(" ["+infos.fileName+":"+infos.lineNumber+"]\n");
			CR.log(s,level);
		}
	}// trace()

	public static inline function print(msg:String,color="")
	{   
		if(msg.good() && !AM.silent){
			if(color.good())msg = colorize(msg,color); 
			Sys.println(msg); 
		}
	}// print()

	public static inline function colorize(msg:String,color:String)
	{   
		var r = msg;
		var rst = "\x1b[0m";
		var bold = "\x1b[1m";
		var red = "\x1b[31;1m";
		var green = "\x1b[32;1m";
		var yellow = "\x1b[33;1m";
		var blue = "\x1b[34;1m";
		var magenta = "\x1b[35;1m";
		var cyan = "\x1b[36;1m";
		var white = "\x1b[37;1m"; 
		if(AM.colors && hasColor()){ 
			color = color.lower();
			if(color == "green")r = green + msg;
			else if(color == "magenta")r = magenta + msg;
			else if(color == "cyan")r = cyan + msg;
			else if(color == "red")r = red + msg;
			else if(color == "yellow")r = yellow + msg;
			else if(color == "white")r = white + msg;
			else if(color == "blue")r = blue + msg;
			r += rst; 
		}
		return r;
	}// colorize()
	
	public static inline function hasColor()
	{ 
		return Sys.getEnv("TERM") == "xterm" || Sys.getEnv("ANSICON") != null;
	}// hasColor()

	public static inline function exists(path:Null<String>,msg="")
	{ 
		var r = true;

		if(path.good(msg) && !FileSystem.exists(path)){
			if(msg.good())trace(CR.ERROR+msg + ": No such file or directory"); 
			r = false;
		}

		return r;
	}// exists()

	public static inline function get(path:String,msg="")
	{
		var a:Array<String> = [];
		
		if(isDir(path,msg))a = FileSystem.readDirectory(path);
		
		return a;
	}// get()
	
	public static inline function isDir(path:String,msg="")
	{ 		
		return exists(path,msg) && FileSystem.isDirectory(path);
	}// isDir()
	
	public static inline function abs(path:String)
	{
		return FileSystem.fullPath(path);
	}// abs()

	public static inline function open(path:String)
	{
		var r = "";
		if(exists(path))r = isDir(path)?"is dir":File.getContent(path);
		return r;
	}// open()

	public static inline function openurl(url:String)
	{
		var r = "";
		if(url.starts("http")){
			try r = haxe.Http.requestUrl(url)catch(m:Dynamic){trace(CR.ERROR+m);}
		}
		return r;
	}// openurl()

	public static inline function save(path:String,s:String)
	{
		File.saveContent(path, s);
	}// save()

	public static inline function copy(src:String,dst:String)
	{
		if(src.good("copy: src")){
			if(exists(src,'copy: $src'))File.copy(src, dst);
		}
	}// copy()

	public static inline function del(path:String)
	{
		if(isDir(path,"del"))FileSystem.deleteDirectory(path);
		else FileSystem.deleteFile(path);
	}// del()

	public static inline function mkdir(path:Null<String>,opt="p")
	{
		if(path.good() && !isDir(path,path)) 
			FileSystem.createDirectory(path);
	}// mkdir()
	
	public static inline function command(cmd:String, args:Array<String>=null)
	{ 
		var r = 0;

		if(cmd.good()){
			if(args == null){
				r = Sys.command(cmd);
			}else{
				var a = new Array<String>();
				for(l in args)if(l.good())a.push(l.trim());
				r = Sys.command(cmd,a);
			}
		}
		
		return r;
	}

	public static inline function exec(cmd:String, args:Array<String>=null,background=false,input="")
	{ 
		var r = "-1";

		if(cmd.good()){
			if(!background){
					var p:Process = null;
					if((args == null)||(args.length == 0))args = ["-v"];
					var a = new Array<String>();
					for(l in args)if(l.good())a.push(l.trim());
					try{
						p = new Process(cmd,a); 
						if(input.good()){
							p.stdin.writeString(input+"\n");
							p.stdin.flush();
						}; 
						r = p.stdout.readAll() + ""; 
					}catch(m:Dynamic){ print(CR.ERROR+m);}
			}else{
				r = Boss.exec(cmd,args,input) + "";
			}
		}
		return r;
	}// exec()

	public static inline function bg(id:String)
	{ 
		var r:Array<String> = [];
		var i = Std.parseInt(id); 
		if(i != -1)r = Boss.read(i); 

		return r;
	}// bg()

	public static inline function stat(path:String)
	{ 
		if(!path.good())path= "";

		return FileSystem.stat(path);
	}// stat()


}// abv.sys.cpp.ST

