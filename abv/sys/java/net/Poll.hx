package abv.sys.java.net;

import haxe.Int64;

import java.nio.channels.Selector;
import java.nio.channels.SelectionKey;

import abv.net.Socket;

class Poll {
	
//	var pool;
	var selector:Selector;
	
	public function new( n : Int ) 
	{
		selector = Selector.open();
	}

	public function poll( a: Array<Socket>, ?t : Float ) : Array<Socket> 
	{// TODO: Map sockets register
		var r: Array<Socket> = [];
		var key:SelectionKey;
		
		for (it in a){ 
			key = it.register(selector, SelectionKey.OP_READ 
				| SelectionKey.OP_WRITE);
			key.attach(it);
		}

  		var ready = selector.select(1);
		if(ready == 0) return r;

		
		var selectedKeys = selector.selectedKeys();    
		var keyIterator = selectedKeys.iterator();

		for(it in selectedKeys) {
			if (it.isReadable() || it.isWritable()) {
					r.push(it.attachment());
			}
		}
			
		return r;
	}

}// abv.sys.java.net.Poll
