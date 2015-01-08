package abv.io;

import sys.io.Process;

import abv.AM;
import abv.lib.Timer;
import abv.sys.ST;
import abv.cpu.Boss;


using abv.CT;
using abv.lib.TP;
using abv.sys.ST;

/**
 * This class mimics Bash Shell 
 **/
class SH{

	public static var ds:Dynamic = null;
	public static var ctx:Array<String> = null;
	static var files = new List<String>();
	static var platform = "";
	public static var output = ""; 

	public static function ln(path:Null<String>,link:String,opt="s")
	{
		print('ln: $path $link $opt');
	}// ln()
	
	public static inline function ls(path=".",opt="")
	{
		var r:Array<String> = [];

		if (path.dir('ls: $path')) {
			if (opt.indexOf("R") != -1) {
				files.clear();
				ls_R(path);
				for(f in files)r.push(f);
			}else r = path.get();
		}

		return r;
	}// ls()
	
	static function ls_R(path:Null<String>)
	{
		var c = ""; 
		var f:Array<String> = path.dir('ls_R: $path')?path.get():[];
		for(i in f){ 
			c = '$path/$i';
			files.push(c);
			if(c.dir("ls_R"))ls_R(c);
		}
	}// ls_R()
	
	public static function cp(src:String,dst:String,opt="")
	{
		src.copy(dst);
	}// cp()
	
	public static function rm(path="")
	{
		if(!path.good("rm")) return;
		else if(!path.exists('rm: $path')) return;
		else if(!path.dirname().abs().starts(pwd()))
			throw "rm: Not permitted outside current directory!";

		if(path.dir()){
			files.clear();
			ls_R(path);
			for(f in files)f.del();
			path.del();	
		}else if(path.exists('rm: $path'))path.del();
	}// rm()
	
	public static inline function mkdir(path:Null<String>,opt="p")
	{
		ST.mkdir(path,opt);
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
		if(!msg.good('echo $msg'))msg = "";
		if(!AM.silent){
			if(!path.dir('echo $path'))path.save(msg + " ");
			else CT.print(msg,CT.WARN); 
		}else output += msg;
	}//echo()
	
	public static inline function print(msg="")
	{ 
		var end = !AM.silent?"\r\n":"<br>\n"; 
		echo(msg + end);
	}// print()
	
	public static inline function compile(target:String,opt:Array<String>,compiler="haxe")
	{
		print('compile: $compiler $target ${opt}');
	}// compile()
	
	public static inline function clear(lines=25)
	{
		if(AM.silent)output = "";
		else{
			if(lines < 0)lines = 25;
			for(i in 0...lines)print("");
		}
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

	public static inline function exec(cmd:String, args:Array<String>=null,background=false,input="")
	{ 
		var r = "-1";

		if(cmd.good()){
			if(!background){
					var p:Process = null;
					if((args == null)||(args.length == 0))args = [""];
					try{
						p = new Process(cmd,args);
						if(input.good()){
							p.stdin.writeString(input+"\n");
							p.stdin.flush();
						}
						r = p.stdout.readAll() + ""; 
					}catch(m:Dynamic){ print(m);}
			}else if(!AM.silent)r = Boss.exec(cmd,args,input) + "";
		}
		return r;
	}//exec()

	public static inline function bg(id:String)
	{ 
		var r:Array<String> = [];
		var i = Std.parseInt(id);
		if(!AM.silent) r = Boss.read(i);
		return r;
	}//bg()

	public static inline function cat(path:Null<String>)
	{
		var r:Null<String> = "";
		var s = 'cat: $path';
		if(path.exists(s) && !path.dir(s)){
			try r = path.open()
			catch(m:Dynamic){CT.print(s + " "+m);}
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
		return Timer.stamp();
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
	
	public static inline function cd(path:Null<String>)
	{
		if(path.dir('cd: $path'))Sys.setCwd(path);
	}// cd()
	
	public static inline function zip(path:Null<String>,file:String,opt="r")
	{
		if(path.good('zip: $path'))echo('zip: $path $opt');
	}// zip()
	
	public static function execute(script:String)
	{
		var cmd = ["ds","ctx","TP","Math","json","good","fields","ls","mkdir","rm","pwd","cd",
		"mv","cp","echo","print","clear","compile","read","exec","export",
		"cat","date","time","uname","ln","zip","sleep","bg"];
		var parser = new hscript.Parser();
		parser.allowJSON = true;
		parser.allowTypes = true;
		var program = parser.parseString(script);
		var ip = new hscript.Interp();
		for(c in cmd){ //trace(c);
			if(ip.variables.get(c) != null)continue; 
			switch(c){
				case "ds": ip.variables.set("ds",ds);
				case "ctx": ip.variables.set("ctx",ctx);
//
				case "TP": ip.variables.set("TP",TP);
				case "Math": ip.variables.set("Math",Math);
				case "json": ip.variables.set("json",CT.json);
				case "good": ip.variables.set("good",good);
				case "fields": ip.variables.set("fields",CT.fields);
//
				case "ls": ip.variables.set("ls",ls);
				case "mkdir": ip.variables.set("mkdir",mkdir);
				case "rm": ip.variables.set("rm",rm);
				case "pwd": ip.variables.set("pwd",pwd);
				case "cd": ip.variables.set("cd",cd);
				case "mv": ip.variables.set("mv",mv);
				case "cp": ip.variables.set("cp",cp);
				case "echo": ip.variables.set("echo",echo);
				case "print": ip.variables.set("print",print);
				case "clear": ip.variables.set("clear",clear);
				case "compile": ip.variables.set("compile",compile);
				case "read": ip.variables.set("read",read);
				case "exec": ip.variables.set("exec",exec);
				case "export": ip.variables.set("export",export);
				case "cat": ip.variables.set("cat",cat);
				case "date": ip.variables.set("date",date);
				case "time": ip.variables.set("time",time);
				case "uname": ip.variables.set("uname",uname);
				case "ln": ip.variables.set("ln",ln);
				case "zip": ip.variables.set("zip",zip);
				case "sleep": ip.variables.set("sleep",sleep);
				case "bg": ip.variables.set("bg",bg);
			}
		}
		
		var t = ip.execute(program) ;
//		var f = ip.variables.get("update"); 
//		if(f != null)f();
	}// execute() 

	public static function good(v:Dynamic)
	{
		return Reflect.isObject(v);
	}// good()
	
	public static inline function sleep(seconds:Float)
	{
		ST.sleep(seconds);
	}// sleep()


}// abv.io.SH

