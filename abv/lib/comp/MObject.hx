package abv.lib.comp;

import abv.bus.*;
/**
 *
 **/
@:dce
class MObject extends Object implements IComm {

	public var sign(null,null):Int;
	public var msg(default,null):MsgProp;
	
//
	public function new(id:String)
	{
		super(id);
		msg = {accept:MD.NONE,action:new Map()};
		sign = MS.subscribe(this);
	}// new()


	function processExec(mdt:MD){}
	public inline function exec(mdt:MD)
	{ 
		if(!MS.isMsg(mdt,sign))return;
		var m = mdt.msg & msg.accept; //trace(MD.msgMap[msg]+":"+msg.action);
		
//		mdt.signin(); // reset sign
		processExec(mdt); 
		if(msg.action.exists(m) &&  (msg.action[m] != null))
			MS.exec(msg.action[m].clone());
	}// exec()
	
	public function action(act:Int,to:String,m:Int,customMsg:Int=MD.NONE)
	{
		var mdt = new MD(id,to,m,sign,[customMsg]);
		msg.action.set(act,mdt); //trace(msg.action);
	}
	
	public override function toString() 
	{
		var s = Object.traceInherited?super.toString() + "\n└>":""; // ─
		return '$s MObject<IComm>(id: $id)';
    }// toString() 

}// abv.lib.comp.MObject

