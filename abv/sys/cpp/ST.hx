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

using abv.ds.TP;
using abv.lib.CC;

@:dce
class ST{

	public static var lock(default,null) = new Mutex();

	inline function new(){ }

	public static inline function trace(v:Null<Dynamic>,?infos:Null<haxe.PosInfos>)
	{   
		var s = Std.string(v).trim();
		var level = CC.getLevel(s);
		if(CC.lvl2int(AM.verbose) >= CC.lvl2int(level)){ 
			if(s.starts("now:"))s = s.replace("now:",Timer.stamp+"");
			s = s.replace(level+"","");
			var color = CC.lvl2color(level);
			if(color.good())s = colorize(s,color); 
			Sys.print(s);
			Sys.print(" ["+infos.fileName+":"+infos.lineNumber+"]\n");
			CC.log(s,level);
		}
	}// trace()

	public static inline function print(msg:String,color="")
	{   
		if(msg.good() && !AM.silent){
			if(color.good())msg = colorize(msg,color); 
			Sys.print(msg); 
		}
	}// print()

	public static inline function println(msg:String,color="")
	{   
		print(msg + CC.LF, color);
	}// println()

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
		path = path.slash(); 		

		if(path.good(msg) && !FileSystem.exists(path)){
//			if(msg.good())trace(ERROR+msg + ": No such file or directory"); 
			r = false;
		}

		return r;
	}// exists()

	public static function ln(path:String,link:String,opt="s")
	{
		path = path.slash(); 		
		link = link.slash();

		if(exists(path)){
			if(CC.OS == WINDOWS)command("cmd",["/c","mklink","/D",link,path]);
			else command("ln",["-s",path,link]);
		}
	}// ln()
	
	public static inline function ls(path=".",opt="")
	{ 
		path = path.slash();
		var r = opt.indexOf("R") != -1? getDir(path,true): getDir(path);

		return r;
	}// ls()
	
	public static inline function getDir(path:String,recursive=false,msg="")
	{
		var r:Array<String> = [];
		
		path = path.slash();
		if(isDir(path,msg)){
			if(recursive){
				getDirR(path,r); 
				if(r.length == 0)r = FileSystem.readDirectory(path);
			}else{
				r = FileSystem.readDirectory(path);
			}
		}
		
		return r;
	}// getDir()
		
	static inline function getDirR(path:String,dirs:Array<String>)
	{
		var t:Array<String>;
		var cur = "";
		if(isDir(path)){
			t = FileSystem.readDirectory(path);
			for(f in t){
				cur = path + "/" + f;
				if(isDir(cur)){
					dirs.push(cur);
					getDirR(cur,dirs);
				}
			}
		}
	}// getDirR()
	
	
	public static inline function isDir(path:String,msg="")
	{ 		
		return path.good()&& exists(path,msg) && FileSystem.isDirectory(path);
	}// isDir()
	
	public static inline function cd(path:String)
	{
		path = path.slash(); 
		if(isDir(path))Sys.setCwd(path); 
	}// cd()
	
	public static inline function pwd()
	{
		return Sys.getCwd();
	}// pwd()
	
	public static inline function absPath(path:String)
	{
		path = path.slash();
		return FileSystem.fullPath(path);
	}// absPath()

	public static inline function read()
	{
		return Sys.stdin().readLine();
	}// read()

	public static inline function open(path:String)
	{
		var r = ""; 
		path = path.slash();
		if(exists(path))r = isDir(path)?"is dir":File.getContent(path);
		return r;
	}// open()

	public static inline function openUrl(url:String)
	{
		var r = "";
		if(url.starts("http")){
			try r = haxe.Http.requestUrl(url)catch(m:Dynamic){trace(ERROR+m);}
		}
		return r;
	}// openUrl()

	public static inline function save(path:String,s:String)
	{
		path = path.slash();
		if(path.good())File.saveContent(path, s);
	}// save()

	public static inline function cp(src:String,dst:String,opt="")
	{
		src = src.slash(); dst = dst.slash();
		if(src.good() && exists(src) && dst.good() && !exists(dst)){
				File.copy(src, dst);
		}
	}// cp()

	public static inline function rm(path:String,opt="")
	{
		path = path.slash();
		if(path.good() && exists(path)){ 
			if(isDir(path)){
				var op = opt.indexOf("r") != -1?"-rf":"";
				if(CC.OS == WINDOWS){
					if(op == "-rf")op = "/S";
					ST.command("cmd",["/c","rd",op,"/Q",path]);
				}else ST.command("rm",[op,path]);
			}else FileSystem.deleteFile(path);
		}
	}// rm()

	public static inline function mkdir(path:String,opt="p")
	{
		path = path.slash();
		if(path.good() && !exists(path)) {
			FileSystem.createDirectory(path);
		}
	}// mkdir()
	
	public static inline function mv(src:String,dst:String)
	{
		src = src.slash(); dst = dst.slash();
		if(src.good() && exists(src) && dst.good()){
			if(CC.OS == WINDOWS) ST.command("move",[src,dst]);
			else ST.command("mv",[src,dst]);
		}
	}// mv()
	
	public static inline function command(cmd:String, args:Array<String>=null)
	{ 
		var r = 0;

		cmd = cmd.slash();
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

		cmd = cmd.slash();
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
					}catch(m:Dynamic){ print(ERROR+m);}
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
		path = path.slash(); 		

		return FileSystem.stat(path);
	}// stat()


}// abv.sys.cpp.ST

