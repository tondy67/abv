package abv.io;

import sys.FileSystem;
import sys.io.Process;
import sys.io.File;

using abv.lib.TP;
using abv.lib.Tools;

/**
 * This class mimics Bash Shell 
 **/
class SH{

	public static var ds:Dynamic = null;
	public static var verbose = true;
	static var files:List<String>;
	static var platform = "";

	static function __init__()
	{
		files = new List();
    }// __init__()

	public static function trim(s:String, opt="")
	{
		echo("trim\n");
	}// trim()

	public static function ln(path:String,link:String,opt="s")
	{
		echo('ln: $path $link $opt \n');
	}// ln()
	
	public static inline function ls(path=".",opt="")
	{
		var r:Array<String> = [];

		if (path.dir('ls: $path')) {
			if (opt.indexOf("R") != -1) {
				files.clear();
				ls_R(path);
				for(f in files)r.push(f);
			}else r = FileSystem.readDirectory(path);
		}

		return r;
	}// ls()
	
	public static function ls_R(path:String)
	{
		var c = ""; 
		var f:Array<String> = path.dir('ls_R: $path')?FileSystem.readDirectory(path):[];
		for(i in f){ 
			c = '$path/$i';
			files.push(c);
			if(c.dir("ls_R"))ls_R(c);
		}
	}// ls_R()
	
	public static function cp(src:String,dst:String,opt="")
	{
		if(!src.good("cp: src is null")) return;
		else if(!FileSystem.exists(src)){Tools.log('cp: $src: not exists');return;}
		
		File.copy(src,dst);
	}// cp()
	
	public static inline function dirname(path:String)
	{
		var sep = "/";
		var r = ".";
		var a = path.split(sep); 
		if(a.length > 1){
			a.pop();
			r = a.join(sep);
		}
		return r;
	}// dirname()
	
	public static inline function basename(path:String)
	{
		var sep = "/";
		var a = path.split(sep);
		var r = a.pop(); 
		return r;
	}// basename()
	
	public static function extname(path:String)
	{
		var sep = ".";
		var a = path.split(sep);
		var r = a.pop(); 
		return r;
	}// extname()

	public static function rm(path="")
	{
		if(!path.good("rm")) return;
		else if(!path.exists('rm: $path')) return;
		else if(!FileSystem.fullPath(dirname(path)).startsWith(pwd()))
			throw "rm: Not permitted outside current directory!";

		if(path.dir()){
			files.clear();
			ls_R(path);
			for(f in files){
				if(f.dir()) FileSystem.deleteDirectory(f);
				else FileSystem.deleteFile(f);
			}
			FileSystem.deleteDirectory(path);	
		}else if(path.exists('rm: $path'))FileSystem.deleteFile(path);
	}// rm()
	
	public static inline function mkdir(path:String,opt="p")
	{
		if(path.good("mkdir") && !path.dir('mkdir: $path')) 
			FileSystem.createDirectory(path);
	}// mkdir()
	
	public static function mv(src:String,dst:String)
	{
		if(!src.good("mv: src") && !src.exists('mv: $src') && !dst.good("mv: dst")) return;
// trace(ls(dst).length);	
		if(src.dir()){
/*			if(ls(dst).length == 0)FileSystem.rename(src,dst);
			else {
				cp(src,dst,"r");
			} */
		}else {
			
		}
	}// mv()
	
	public static inline function read()
	{
		return Sys.stdin().readLine();
	}// read()

	public static inline function echo(msg="",path="",append=false)
	{// TODO: colors
		if(path != ""){
			if(!path.dir('echo $path'))File.saveContent(path, msg + " ");
		}else if(msg.good('echo $msg')){
			if(verbose) Sys.print(msg);
		}else if(verbose) Sys.print("\n");
	}//echo()
	
	public static inline function compile(target:String,opt:Array<String>,compiler="haxe")
	{
		Tools.log('compile: $compiler $target $opt');
	}// compile()
	
	public static inline function exec(cmd:String,args:Array<String>=null)
	{
		var r = 1;

		if(cmd.good("exec: cmd")) r = Sys.command(cmd,args);

		return r; 
	}//exec()

	public static inline function clear(lines=25)
	{
		if(lines < 0)lines = 25;
		for(i in 0...lines)Sys.println("");
	}//clear()

	public static inline function export(s:String,v:String)
	{
		if(s.good() && v.good())Sys.putEnv(s,v);
	}//export()

	public static inline function env(what="")
	{
		var r:Map<String,String> = new Map();
		if(what.good('env $what'))r.set(what,Sys.getEnv(what));
		else r = Sys.environment();
		return r;
	}//env()

	public static inline function shell(cmd:String, args:Array<String>)
	{
		var p:Process = null;
		if(cmd.good()){
			if((args == null)||(args.length == 0))args = ["-v"];
			p = new Process(cmd,args);
		}
		return p;
	}//shell()

	public static inline function cat(path="")
	{
		var r = "";

		if(path.exists("cat") && !path.dir('cat: $path')){
			try r = File.getContent(path)
			catch(m:Dynamic){Tools.log('cat: $path: ' + m);}
		}
		
		return r;
	}// cat()
	
	public static inline function date()
	{
		var n = Date.now();
		return {day:n.getDate(),month:n.getMonth(),year:n.getFullYear(),
			hour:n.getHours(),min:n.getMinutes(),sec:n.getSeconds(),
			time:n.getTime(),weekday:n.getDay(),str:n.toString()};
	}// date()

	public static inline function time()
	{
		return Sys.time();
	}// time()

	public static inline function uname()
	{
		var r = Sys.systemName();
		return r;
	}// time()

	public static inline function pwd()
	{
		return Sys.getCwd();
	}// pwd()
	
	public static inline function cd(path:String)
	{
		if(path.dir('cd: $path'))Sys.setCwd(path);
	}// cd()
	
	public static inline function zip(path:String,file:String,opt="r")
	{
		if(path.good('zip: $path'))echo('zip: $path $opt');
	}// zip()
	
	public static function execute(script:String)
	{
		var cmd = ["TP","json","Math","ls","mkdir","rm","pwd","cd","mv","cp","echo","clear",
		"compile","read","exec","export","ds","cat","shell",
		"date","time","uname","ln","zip"];
		var parser = new hscript.Parser();
		parser.allowJSON = true;
		parser.allowTypes = true;
		var program = parser.parseString(script);
		var ip = new hscript.Interp();
		for(c in cmd){ //trace(c);
			if(ip.variables.get(c) != null)continue; 
			switch(c){
				case "TP": ip.variables.set("TP",TP);
				case "Math": ip.variables.set("Math",Math);
				case "json": ip.variables.set("json",Tools.json);
//
				case "ls": ip.variables.set("ls",ls);
				case "mkdir": ip.variables.set("mkdir",mkdir);
				case "rm": ip.variables.set("rm",rm);
				case "pwd": ip.variables.set("pwd",pwd);
				case "cd": ip.variables.set("cd",cd);
				case "mv": ip.variables.set("mv",mv);
				case "cp": ip.variables.set("cp",cp);
				case "echo": ip.variables.set("echo",echo);
				case "clear": ip.variables.set("clear",clear);
				case "compile": ip.variables.set("compile",compile);
				case "read": ip.variables.set("read",read);
				case "exec": ip.variables.set("exec",exec);
				case "export": ip.variables.set("export",export);
				case "ds": ip.variables.set("ds",ds);
				case "cat": ip.variables.set("cat",cat);
				case "shell": ip.variables.set("shell",shell);
				case "date": ip.variables.set("date",date);
				case "time": ip.variables.set("time",time);
				case "uname": ip.variables.set("uname",uname);
				case "ln": ip.variables.set("ln",ln);
				case "zip": ip.variables.set("zip",zip);
			}
		}
		
		var t = ip.execute(program) ;
//		var f = ip.variables.get("update"); 
//		if(f != null)f();
	}// execute() 

}// abv.io.SH

