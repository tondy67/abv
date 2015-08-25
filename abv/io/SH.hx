package abv.io;
/**
 * This class mimics Bash Shell 
 **/
import abv.AM;
import abv.cpu.Timer;
import abv.sys.ST;

using abv.lib.CC;
using abv.lib.TP;
using abv.sys.ST;
using abv.ds.DT;

@:dce
class SH{

	public static var ds:Dynamic = null;
	public static var ctx:Array<String> = null;
	public static var args:Array<String> = null;
	static var platform = "";
	public static var output = ""; 
	static var T = new TextProcessing();

	inline function new(){ }

	public static function ln(path:String,link:String,opt="s")
	{
		print('ln: $path $link $opt');
		// mklink
	}// ln()
	
	public static function hide(path:String)
	{
		print("hide");
		// attrib +h file
	}// hide()
	
	public static function unhide(path:String)
	{
		print("unhide");
		// attrib -h file
	}// unhide()
	
	public static inline function ls(path=".",opt="")
	{
		var r:Array<String>;

		if (opt.indexOf("R") != -1) r = path.getDir(true);
		else r = path.getDir();

		return r;
	}// ls()
	
	public static function cp(src:String,dst:String,opt="")
	{
		src.copy(dst);
	}// cp()
	
	public static function rm(path="")
	{
		if(!path.good("rm")) return;
		else if(!path.exists('rm: $path')) return;
		else if(!path.dirname().absPath().starts(pwd()))
			throw "rm: Not permitted outside current directory!";

		if(path.isDir()){
			var files = path.getDir(true);
			for(f in files)f.del();
		}else if(path.exists('rm: $path'))path.del();
	}// rm()
	
	public static inline function mkdir(path:String,opt="p")
	{
		if(!path.isDir())ST.mkdir(path,opt);
	}// mkdir()
	
	public static function mv(src:String,dst:String)
	{
		if(!src.good("mv: src") && !src.exists('mv: $src') && !dst.good("mv: dst")) return;
// trace(ls(dst).length);	
		if(src.isDir()){
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

	public static inline function echo(msg:String,color="",path="",append=false)
	{
		if(!msg.good())msg = "";
		if(!AM.silent){ 
			if(path.good() && !path.isDir(path))path.save(msg + " ");
			else ST.print(msg,color); 
		}else output += msg;
	}//echo()
	
	public static inline function print(msg="",color="")
	{ 
		var end = !AM.silent?CC.LF:"<br>"+CC.LF; 
		echo(msg + end,color);
	}// print()
	
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

	public static inline function exit(msg="")
	{
		var code = 0;
		if(msg.good()){
			print(msg);
			code = -1;
		}
		Sys.exit(code);
	}//exit()

	public static inline function env(what="")
	{// TODO: MapString
		var r = new Map<String,String>();
		if(what.good('env $what')){
			r.set(what,Sys.getEnv(what));
		}else{
			r = Sys.environment();
		}
		return r;
	}//env()

	public static inline function cat(path:String)
	{
		var r:String = "";
		var s = 'cat: $path';
		if(path.exists(s) && !path.isDir(s)){
			try r = path.open()
			catch(m:Dynamic){trace(WARN+s + " "+m);}
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
	
	public static inline function cd(path:String)
	{
		if(path.isDir('cd: $path'))Sys.setCwd(path);
	}// cd()
	
	public static inline function zip(path:String,file:String,opt="r")
	{
		if(path.good('zip: $path'))echo('zip: $path $opt');
	}// zip()
	
	public static function execute(script:String)
	{
		var parser = new hscript.Parser();
		parser.allowJSON = true;
		parser.allowTypes = true;
		var program = parser.parseString(script); 
		var ip = new hscript.Interp(); 
 
		ip.variables.set("ds",ds);
		ip.variables.set("ctx",ctx);
		ip.variables.set("args",args);
//
		ip.variables.set("TP",TP);
		ip.variables.set("Math",Math);
		ip.variables.set("json",CC.json);
		ip.variables.set("good",good);
		ip.variables.set("fields",DT.fields);
//
		ip.variables.set("ls",ls);
		ip.variables.set("mkdir",mkdir);
		ip.variables.set("rm",rm);
		ip.variables.set("pwd",pwd);
		ip.variables.set("cd",cd);
		ip.variables.set("mv",mv);
		ip.variables.set("cp",cp);
		ip.variables.set("echo",echo);
		ip.variables.set("print",print);
		ip.variables.set("clear",clear);
		ip.variables.set("read",read);
		ip.variables.set("export",export);
		ip.variables.set("cat",cat);
		ip.variables.set("date",date);
		ip.variables.set("time",time);
		ip.variables.set("uname",uname);
		ip.variables.set("ln",ln);
		ip.variables.set("zip",zip);
		ip.variables.set("sleep",sleep);
		ip.variables.set("exec",ST.exec);
		ip.variables.set("bg",ST.bg);
		ip.variables.set("stat",ST.stat);
		ip.variables.set("T",T);
		ip.variables.set("command",ST.command);
		ip.variables.set("exit",exit);
		
		var t = ip.execute(program); 
//		var f = ip.variables.get("update"); 
//		if(f != null)f();
	}// execute() 

	public static function good(v:Dynamic)
	{
		return Reflect.isObject(v);
	}// good()
	
	public static inline function sleep(seconds:Float)
	{
		Sys.sleep(seconds);
	}// sleep()


}// abv.io.SH

class TextProcessing
{
	public inline function new(){}
	
	public inline function length(s:String){return TP.length(s);}
	public inline function order(a:Array<String>){return TP.order(a);}
	public inline function chr(code:Int){return TP.chr(code);}
	public inline function ord(char:String){return TP.ord(char);}
	public inline function split(v:String,sep=","){return TP.splitt(v,sep);}
	public inline function substr(s:String, pos:Int, len:Int){return TP.substr(s,pos,len);}
	public inline function reduceSpaces(s:String,sp=" "){return TP.reduceSpaces(s,sp);}
	public inline function toUtf8(s:String){return TP.toUtf8(s);}
	public inline function fromUtf8(s:String){return TP.fromUtf8(s);}
	public inline function lower(s:String){return TP.lower(s);}
	public inline function upper(s:String){return TP.upper(s);}
	public inline function trim(s:String){return TP.trim(s);}
	public inline function rtrim(v:String,s="/"){return TP.rtrim(v,s);}
	public inline function ltrim(s:String){return TP.ltrim(s);}
	public inline function starts(s:String, start:String){return TP.starts(s,start);}
	public inline function ends(s:String, end:String){return TP.ends(s,end);}
	public inline function hex(n:Int){return TP.hex(n);}
	public inline function eof(c:Int){return TP.eof(c);}
	public inline function space(s:String, pos:Int){return TP.space(s,pos);}
	public inline function lpad(s:String, c:String, l:Int){return TP.lpad(s,c,l);}
	public inline function rpad(s:String, c:String, l:Int){return TP.rpad(s,c,l);}
	public inline function replace(s:String, sub:String, by:String){return TP.replace(s,sub,by);}
	public inline function has(src:String,what:String,start=0){return TP.has(src,what,start);}
	public inline function search(src:String,what:String,start=0){return TP.search(src,what,start);}
	public inline function find(src:String,what:String,start=0,len=0){return TP.find(src,what,start);}
	public inline function extract(src:String,open="",close=""){return TP.extract(src,open,close);}
	public inline function map2str(m:Map<String,String>,sep1=CC.SEP1,sep3=CC.SEP3){return TP.map2str(m,sep1,sep3);}
	public inline function str2map(s:String,sep1=CC.SEP1,sep3=CC.SEP3){return TP.str2map(s,sep1,sep3);}
	public inline function urlEncode(s:String){return TP.urlEncode(s);}
	public inline function urlDecode(s:String){return TP.urlDecode(s);}   
}// abv.io.TextProcessing
