package abv.bus;
/**
 * Message System
 **/
import abv.cpu.Timer;
import abv.factory.*;
import haxe.PosInfos;

using abv.sys.ST;

@:dce
class MS{

//
	static var msgMap = setMsgMap();
// custom messages
	static var cmMap:Array<String> = [];
// inbox
	static var inbox = setInbox();
	static var subscribers     = new Map<String,IComm>();
	static var nameID   = ["" => -1, "abv" => 0];
	static var subscribersID = [-1 => "", 0 => "abv"];
	static var slots = new Map<Int,List<IComm>>();
	static var trash = new List<MD>();
	static var oid = 1;
	
	public static inline function getComm(id:Int,name="")
	{
		var r:IComm = null;
		if(!name.good()) name = getName(id);
		if(name.good())r = subscribers[name];
		return r;
	}// getComm()
	
	public static inline function getName(id:Int)
	{
		var r = "";
		if (subscribersID.exists(id)) r = subscribersID[id];
		return r;
	}// getName()
	
	public static inline function getID(name:String)
	{
		var r = -1; 
		if(nameID.exists(name)) r = nameID[name];
		return r;
	}// getID()
	
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
	
	public static inline function msgName(m:Int)
	{
		var r = "";
		for (k in msgMap.keys()) if (msgMap[k] == m) r = k;
		return r;
	}

	public static inline function msgCode(n:String)
	{
		return msgMap[n];
	}

	public static inline function add(obj:IComm,name:String)
	{ 
		var r = false;
		
		if(obj == null)ST.errNullObject();
		else if(!name.good())ST.errBadName();
		else if(subscribers.exists(name))ST.errObjectExists(name);
		else{
			subscribers.set(name,obj);
			nameID.set(name,oid);
			subscribersID.set(oid,name);
			oid++;
			r = true;  
		} 
		return r;
	}// add()

	public static inline function remove(name:String)
	{
		if(ST.good(name)){
			var id = nameID[name];
			subscribers.remove(name);
			nameID.remove(name);
			subscribersID.remove(id);
		}
	}// remove()
	
	public static inline function send(md:MD,?p:PosInfos)setBox(md,false, p);

	public static inline function call(md:MD,?p:PosInfos)setBox(md, true,p); 

	static inline function emptyTrash(md:MD)
	{
		trash.add(md);
		if(trash.length < 1000)return;
		for(m in trash){
			m.dispose();
			m = null;
		}
		trash.clear();
	}// emptyTrash()
	
	static inline function getSlot(msg:Int)
	{
		var l = new List<IComm>();
		if(slots.exists(msg)) l = slots.get(msg); 
		return l;
	}// getSlot()
	
	public static inline function setSlot(o:IComm,msg:Int)
	{
		if(slots.exists(msg)){
			slots.get(msg).add(o);
		}else{
			var l = new List<IComm>();
			l.add(o);
			slots.set(msg,l);
		}
	}// setSlot()
	
	static inline function objExec(md:MD,p:PosInfos)
	{ // trace(getName(md.from.id)+" -> "+md.to);
		var o = md.from; 
		try o.call(md) catch(e:Dynamic)ST.error(ST.getText(8),getName(o.id),p);
		md.dispose(); 
		md = null;
	}// objExec()
	
	static inline function setBox(md:MD,exec=false,p:PosInfos)
	{ 
		if(has(md.from.id)){ 
			var to = -1;  
			if(md.to.good()) to = getID(md.to);  
			if(to == -1){ 
				for(it in getSlot(md.msg)){
					md.from = it; 
					objExec(md,p);
				}
			}else{ 
				checkBox(to);
				if (exec) { 
					md.from = getComm(to); 
					objExec(md,p);
				}else inbox.get(to).add(md.clone());  
			} 
		}
	}// setBox()
	
	public static inline function has(id:Int)
	{
		var key = getName(id);
		return subscribers.get(key) != null;
	}// has()
	
	public static inline function accept(id:Int,cmd:Int)
	{
		var r = false; 
		if((has(id))&&(getComm(id).msg.accept & cmd  != 0))r = true;
		return r;
	}// accept()
	
	static inline function checkBox(id:Int)
	{
		inbox.set(id,new List<MD>());
	}// checkBox()
	
/**
	to => "*" = all, "." = ab, "-" = app
 **/	
	public static inline function recv(to:Int)
	{
		var r = new List<MD>();
		if(has(to)){
			checkBox(to);
			if(!inbox.get(to).isEmpty()){ //trace(inbox);
				for(m in inbox.get(to)){
					r.add(m.clone());
					m.dispose();
					m = null;
				}
				inbox.get(to).clear();
			}; 
		}
		return r;
	}// recv()
	
	static inline function setMsgMap()
	{
		var m = new Map<String,Int>();
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
		var m = new Map();
		m.set(0,new List<MD>());
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

