package abv.bus;

import abv.cpu.Timer;
using abv.lib.CR;

/**
 * Message System
 **/
@:dce
class MS{

//
	static var msgMap:Map<String,Int> = ["NONE" => MD.NONE,"MSG" => MD.MSG,
		"KEY_UP" => MD.KEY_UP,"KEY_DOWN" => MD.KEY_DOWN,"CLICK" => MD.CLICK,
		"DOUBLE_CLICK" => MD.DOUBLE_CLICK,"MOUSE_UP" => MD.MOUSE_UP,   
		"MOUSE_DOWN" => MD.MOUSE_DOWN,"MOUSE_MOVE" => MD.MOUSE_MOVE,
		"MOUSE_WHEEL" => MD.MOUSE_WHEEL,"MOUSE_OVER" => MD.MOUSE_OVER,   
		"MOUSE_OUT" => MD.MOUSE_OUT,"NEW" => MD.NEW,"OPEN" => MD.OPEN,   
		"SAVE" => MD.SAVE,"STATE" => MD.STATE,"CLOSE" => MD.CLOSE,
		"DESTROY" => MD.DESTROY,"RESIZE" => MD.RESIZE,"DRAW" => MD.DRAW,
		"START" => MD.START, "STOP" => MD.STOP,"PAUSE" => MD.PAUSE,  
		"MOVE" => MD.MOVE,"TWEEN" => MD.TWEEN,"EXIT" => MD.EXIT
	];
// custom messages
	static var cmMap = new Map<String,Int>();
// inbox
	static var inbox = ["*" => new List<MD>()];
	static var subscribers = new Map<Int,IComm>();
	static var subscribersID = new Map<String,IComm>();
	static var slots = new Map<Int,List<IComm>>();
	static var trash = new List<MD>();
	
	inline function new(){ }

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
	public static inline function subscribe(obj:IComm)
	{ 
#if debug var m = "";
		if (obj == null)m += "Null Subscriber! ";
		else if(!obj.id.good())m += "No subscriber ID! ";
		else if(subscribers.exists(obj.sign))m += "Subscriber ("+obj.id+") exist! ";
		if(m != "")trace(CR.ERROR+m); 
#end		
		var ts = Timer.stamp()- Std.int(Timer.stamp());
		var sign = Std.int(1000000*(ts + Math.random())); 
		subscribers.set(sign,obj);  
		subscribersID.set(obj.id,obj);  

		return sign;
	}// register()

	public static inline function unsubscribe(sign:Int)
	{
		var o = subscribers[sign];
		subscribersID.remove(o.id);
		subscribers.remove(sign);
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
	
	static inline function getSlot(msg:Int)
	{
		var l = new List<IComm>();
		if(slots.exists(msg)) l = slots[msg];
		return l;
	}// getSlot()
	
	public static inline function setSlot(o:IComm,msg:Int)
	{
		if(slots.exists(msg)){
			slots[msg].add(o);
		}else{
			var l = new List<IComm>();
			l.add(o);
			slots.set(msg,l);
		}
	}// setSlot()
	
	static inline function objExec(o:IComm,md:MD)
	{
		try o.exec(md) catch (d:Dynamic){trace(CR.ERROR+o.id+": "+d);}
		md.free(); 
		md = null;
	}// objExec()
	
	static inline function setBox(md:MD,exec=false)
	{ 
		if(isSender(md)){ 
			var to = md.to;
			if(to == ""){
				for(o in getSlot(md.msg)){ 
					objExec(o,md);
				}
			}else if(isSubscriber(to)){
				if(to != "*"){
						checkBox(to);
						if (exec) { 
							md.sign = subscribersID[to].sign; 
							objExec(subscribersID[to],md);
						}else inbox[to].add(md.clone());  
				}else{
					for(k in inbox.keys()){
						if(k != "*")inbox[k].add(md.clone());
					}
				}; 
			} 
		}
	}// setBox()
	
	public static inline function isSender(md:MD)
	{
		var r = true;
		if(md == null){
			trace(CR.FATAL+"Null data?!"); 
			r = false;
		}else if(!subscribers.exists(md.sign)){ 
			trace(CR.ERROR+"Fake sign!"); 
			r = false;
		}
		return r;
	}// isSender()
	
	public static inline function isSubscriber(id:String)
	{
		return subscribersID.exists(id) && (subscribersID[id] != null);
	}// isSubscriber()
	
	public static inline function accept(id:String,cmd:Int)
	{
		var r = false; 
		if((isSubscriber(id))&&(subscribersID[id].msg.accept & cmd  != 0))r = true;
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
		if(isSubscriber(to)){
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

	public static function info() 
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

