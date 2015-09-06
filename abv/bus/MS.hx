package abv.bus;

import abv.cpu.Timer;
import abv.interfaces.*;
import abv.ds.AMap;

using abv.lib.CC;

typedef MsgProp = { accept:Int, action:Map<Int,MD> }

/**
 * Message System
 **/
@:dce
class MS{

//
	static var msgMap = setMsgMap();
// custom messages
	static var cmMap:Array<String> = [];
// inbox
	static var inbox = setInbox();
	static var subscribers = new AMap<Int,IComm>();
	static var subscribersID = new AMap<String,IComm>();
	static var slots = new AMap<Int,List<IComm>>();
	static var trash = new List<MD>();
	
	inline function new(){ }

	public static inline function cmName(c:Int)
	{
		var r = "";
		if(cmMap[c].good())r = cmMap[c];
		return r;
	}// cmName()
	
	public static inline function cmCode(s:String)
	{
		var r = -1;
		var ix = cmMap.indexOf(s);
		if(ix != -1)r = ix;
		else{
			cmMap.push(s);
			r = cmMap.indexOf(s);
		}
		return r;
	}// cmCode()
	
	public static inline function msgName(m:Int)return msgMap.find(m);

	public static inline function msgCode(n:String)return msgMap[n];

	public static inline function subscribe(obj:IComm)
	{ 
#if debug var m = "";
		if (obj == null)m += "Null Subscriber! ";
		else if(!obj.id.good())m += "No subscriber ID! ";
		else if(subscribers.exists(obj.sign))m += "Subscriber ("+obj.id+") exist! ";
		if(m != "")trace(ERROR+m); 
#end		
		var ts = Timer.stamp()- Std.int(Timer.stamp());
		var sign = Std.int(1000000*(ts + Math.random())); 
		subscribers.set(sign,obj);  
		subscribersID.set(obj.id,obj);  

		return sign;
	}// subscribe()

	public static inline function unsubscribe(sign:Int)
	{
		var o = subscribers[sign];
		subscribersID.remove(o.id);
		subscribers.remove(sign);
	}// unsubscribe()
	
	public static inline function send(md:MD)setBox(md);

	public static inline function exec(md:MD)setBox(md, true); 

	static inline function emptyTrash(md:MD)
	{
		trash.add(md);
		if(trash.length < 1000)return;
		for(m in trash){
			m.free();
			m = null;
		}
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
		try o.exec(md) catch (d:Dynamic)trace(ERROR+o.id+": "+d);
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
				checkBox(to);
				if (exec) { 
					md.sign = subscribersID[to].sign; 
					objExec(subscribersID[to],md);
				}else inbox[to].add(md.clone());  
			} 
		}
	}// setBox()
	
	public static inline function isSender(md:MD)
	{
		var r = true;
		if(md == null){
			trace(FATAL+"Null data?!"); 
			r = false;
		}else if(!subscribers.exists(md.sign)){ 
			trace(ERROR+"Fake sign!"); 
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
		inbox.add(id,new List<MD>());
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
	
	static inline function setMsgMap()
	{
		var m = new AMap<String,Int>();
		m.set("NONE" , MD.NONE);
		m.set("MSG" , MD.MSG);
		m.set("KEY_UP" , MD.KEY_UP);
		m.set("KEY_DOWN" , MD.KEY_DOWN);
		m.set("CLICK" , MD.CLICK);
		m.set("DOUBLE_CLICK" , MD.DOUBLE_CLICK);
		m.set("MOUSE_UP" , MD.MOUSE_UP);
		m.set("MOUSE_DOWN" , MD.MOUSE_DOWN);
		m.set("MOUSE_MOVE" , MD.MOUSE_MOVE);
		m.set("MOUSE_WHEEL" , MD.MOUSE_WHEEL);
		m.set("MOUSE_OVER" , MD.MOUSE_OVER);  
		m.set("MOUSE_OUT" , MD.MOUSE_OUT);
		m.set("NEW" , MD.NEW);
		m.set("OPEN" , MD.OPEN);   
		m.set("SAVE" , MD.SAVE);
		m.set("STATE" , MD.STATE);
		m.set("CLOSE" , MD.CLOSE);
		m.set("DESTROY" , MD.DESTROY);
		m.set("RESIZE" , MD.RESIZE);
		m.set("DRAW" , MD.DRAW);
		m.set("START" , MD.START);
		m.set("STOP" , MD.STOP);
		m.set("PAUSE" , MD.PAUSE);  
		m.set("MOVE" , MD.MOVE);
		m.set("TWEEN" , MD.TWEEN);
		m.set("EXIT" , MD.EXIT);
		return m;
	}
	static inline function setInbox()
	{
		var m = new AMap();
		m.set("*",new List<MD>());
		return m;
	}//
	
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

