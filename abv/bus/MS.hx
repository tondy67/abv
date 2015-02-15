package abv.bus;

import abv.lib.Timer;
using abv.CR;

typedef Subscriber = {obj:IComm,sign:Int}
/**
 * Message System
 **/
@:dce
class MS{

//
	static var msgMap:Map<String,Int> = ["NONE" => MD.NONE,   
		"MSG" => MD.MSG,"KeyUp" => MD.KUP,"KDOWN" => MD.KDOWN,   
		"CLICK" => MD.CLICK,"CLICK2" => MD.CLICK2,"MUP" => MD.MUP,   
		"MDOWN" => MD.MDOWN,"MMOVE" => MD.MMOVE,
		"MWHEEL" => MD.MWHEEL,"MOVER" => MD.MOVER,   
		"MOUT" => MD.MOUT,"NEW" => MD.NEW,"OPEN" => MD.OPEN,   
		"SAVE" => MD.SAVE,"STATE" => MD.STATE,"CLOSE" => MD.CLOSE,
		"DESTROY" => MD.DESTROY,"RESIZE" => MD.RESIZE,"DRAW" => MD.DRAW,
		"START" => MD.START, "STOP" => MD.STOP,"PAUSE" => MD.PAUSE,  
		"MOVE" => MD.MOVE,"TWEEN" => MD.TWEEN,"EXIT" => MD.EXIT
	];
// custom message codes
	static var cmMap = new Map<String,Int>();
// inbox
	static var inbox = ["*" => new List<MD>()];
	static var subscribers = new Map<String,Subscriber>();
	static var trash = new List<MD>();
	
	public static inline function cmName(m:Int)
	{
		var r = "";
		for(k in cmMap.keys())if(cmMap[k] == m){r = k;break;}
		return r;
	}
	public static inline function cmCode(n:String)
	{
		if(!cmMap.exists(n))cmMap.set(n,Lambda.count(cmMap)+1);
		return cmMap[n];
	}
	public static inline function msgName(m:Int)
	{
		var r = "";
		for(k in msgMap.keys())if(msgMap[k] == m){r = k;break;}
		return r;
	}
	public static inline function msgCode(n:String)
	{
		return msgMap[n];
	}
	public static inline function subscribe(obj:IComm,?p:haxe.PosInfos)
	{ 
#if debug var inf = "[" + p.fileName + ":" + p.lineNumber + "] "; 
		var m = "";
		if (obj == null)m += "Null Subscriber! ";
		else if(!obj.id.good())m += "No subscriber ID! ";
		else if(subscribers.exists(obj.id))m += "Subscriber ("+obj.id+") exist! ";
		if(m != "")LG.log(m+inf); 
#end		
		var ts = Timer.stamp()- Std.int(Timer.stamp());
		var sgn = Std.int(100000*(ts +Math.random())); 
		subscribers.set(obj.id,{obj:obj,sign:sgn}); //trace(obj.id+":"+sgn);

		return sgn;
	}// register()

	public static inline function unsubscribe(id:String)
	{
		subscribers.remove(id);
	}// unsubscribe()
	
	public static inline function send(md:MD)
	{
		setBox(md);
	}// send()

	public static inline function exec(md:MD)
	{
		setBox(md, true); 
	}// exec()

	static inline function emptyTrash(md:MD)
	{
		trash.add(md);
		if(trash.length < 1000)return;
		for(m in trash){	m.free();m = null;}
		trash.clear();
	}// emptyTrash()
	
	static inline function setBox(md:MD,exec=false)
	{ //trace(md.to+":"+subscribers[md.to]);
		if(!isMsg(md,subscribers[md.from].sign))return;
		var to = md.to;
		if(check(to)){
			if(to != "*"){
					checkBox(to);
					if (exec) { 
						md.signin(subscribers[to].sign); //trace(subscribers[to]);
						try subscribers[to].obj.exec(md)
						catch (d:Dynamic){LG.log(to+": "+d);}
//						emptyTrash(md);
						md.free(); 
						md = null;
					}else inbox[to].add(md.clone());  
			}else{
				for(k in inbox.keys()){
					if(k != "*")inbox[k].add(md.clone());
				}
			}; 
		} 
	}// setBox()
	
	public static inline function isMsg(md:MD,sign:Int)
	{
		var r = true;
		if(md == null){
			LG.log("Null data?!"); 
			r = false;
		}else if(sign != md.sign){ 
			LG.log('Fake ${md.from} sign!'); 
			r = false;
		}
		return r;
	}// isMsg()
	
	public static inline function check(id:String)
	{
		return (subscribers.exists(id))&&(subscribers[id] != null);
	}// check()
	
	public static inline function accept(id:String,cmd:Int)
	{
		var r = false; 
		if((check(id))&&(subscribers[id].obj.msg.accept & cmd  != 0))r = true;
		return r;
	}// accept()
	
	static inline function checkBox(id:String)
	{
		if(!inbox.exists(id))inbox.set(id,new List<MD>());
	}// checkBox()
	
/**
	to => "*" = all, "." = ab, "-" = app
 **/	
	public static inline function recv(to:String)
	{
		var r = new List<MD>();
		if(check(to)){
			checkBox(to);
			if(!inbox[to].isEmpty()){ //trace(inbox);
				for(m in inbox[to]){
					r.add(m.clone());
					m.free();
					m = null;
				}
				inbox[to].clear();
			}; 
		}
		return r;
	}// recv()

	public static function show() 
	{ 
		var s = "Msg(inbox: ";
		for(k in inbox.keys())s += k+",";
		s += "\nsubscribers: ";
		for(k in subscribers.keys())s += k+",";
		s += '\ncmMap: $cmMap';
		s += ")";
        return s;
    }// show() 

}// abv.bus.MS

