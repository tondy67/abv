package abv.net;
/*
 * TServer
 */
import haxe.io.Bytes;

import abv.net.Socket;
import abv.cpu.TPool;
import abv.net.Poll;
import abv.cpu.Lock;
import abv.cpu.Mutex;

private typedef SocketsInfo = {
	id: Int,
	p: Poll,
	socks: Array<Socket>,
}

private typedef ClientInfo<Client> = {
	client: Client,
	sock: Socket,
	task: SocketsInfo,
	buf: Bytes,
	bufpos: Int,
}

class TServer<Client,Message> extends TPool {

	var tasks: Array<SocketsInfo> = [];
	var sock: Socket;
	public var listen = 10;
	public var ntasks = 1;
	public var connectLag = .5;
	public var minBufferSize = 1 << 12;
	public var maxBufferSize = 1 << 16;
	public var msgHeaderSize = 1;
	public var maxSockPerThread = 64;

	public function new() 
	{
		super(ntasks + 1); 
	}

	function readClientData( c: ClientInfo<Client> ) 
	{ 
		var available = c.buf.length - c.bufpos;
		if( available == 0 ) {
			var newsize = c.buf.length * 2;
			if( newsize > maxBufferSize ) {
				newsize = maxBufferSize;
				if( c.buf.length == maxBufferSize )	throw "Max buffer size reached";
			}
			var newbuf = Bytes.alloc(newsize);
			newbuf.blit(0,c.buf,0,c.bufpos);
			c.buf = newbuf;
			available = newsize - c.bufpos;
		}
		var bytes = readBytes(c.sock, c.buf,c.bufpos,available);
		var pos = 0;
		var len = c.bufpos + bytes;
		while( len >= msgHeaderSize ) {
			var m = readClientMessage(c.client,c.buf,pos,len);
			if( m == null ) break;
			pos += m.bytes;
			len -= m.bytes; 
			clientMessage(c.client,m.msg); 
		}
		if( pos > 0 ) c.buf.blit(0,c.buf,pos,len);
		c.bufpos = len;
	}// readClientData()

	function taskClients( t: SocketsInfo ) 
	{
		var l = new Lock();
		while ( true ){
			if (t.socks.length == 0){
				l.wait(1.); 
				continue;
			}
			for( s in t.p.poll(t.socks,connectLag) ) { 
				var infos: ClientInfo<Client> = s.custom;
				try{
					readClientData(infos);
				}catch( e: Dynamic ) {
					t.socks.remove(s);
					if( !Std.is(e,haxe.io.Eof) && 
						!Std.is(e,haxe.io.Error) ) logError(e); 
					doClientDisconnected(s,infos.client);
				}
			}
		}
	}// taskClients()

	function doClientDisconnected(s,c) 
	{
		try s.close() catch( e: Dynamic ) {};
		clientDisconnected(c);
	}

	function addClient( sock: Socket ) 
	{ 
		var mutex = new Mutex();	
		sock.setBlocking(false); 
		var start = Std.random(ntasks);
		for( i in 0...ntasks ) {
			var t = tasks[(start + i)%ntasks];
			if( t.socks.length < maxSockPerThread ) {
				var infos: ClientInfo<Client> = {
					task: t,
					client: clientConnected(sock),
					sock: sock,
					buf: Bytes.alloc(minBufferSize),
					bufpos: 0,
				};
				mutex.acquire();
				sock.custom = infos;
				t.socks.push(sock);
				mutex.release();
				return;
			}
		}
		refuseClient(sock);
	}

	function refuseClient( sock: Socket) 
	{
	// we have reached maximum number of active clients
		sock.close();
	}

	function readBytes( s:Socket,b:Bytes, pos:Int, len:Int ):Int 
	{
#if java	
		return s.readBytes(b,pos,len);
#else		
		return s.input.readBytes(b,pos,len);
#end		
	}// readBytes

	function sendData( s: Socket, data: Bytes ) 
	{
		try 
#if java
		s.write(data) 
#else	
		s.write(data+"") 
#end		
		catch( e: Dynamic ) { trace(e);stopClient(s); }
	}

	function stopClient( s: Socket ) 
	{
		var infos: ClientInfo<Client> = s.custom;
		if( infos.task.socks.remove(s) ) doClientDisconnected(s,infos.client);
		try s.shutdown(true,true) catch( e: Dynamic ) { };
 	}

	public function start(host="0.0.0.0", port=80) 
	{
		run(taskServer.bind(host,port));
		for( i in 0...ntasks ) {
			var t = {
				id: i,
				socks: new Array(),
				p: new Poll(maxSockPerThread),
			};
			tasks.push(t); 
			run(taskClients.bind(t)); 
		}
	}// start()
	
	function taskServer(host:String,port:Int)
	{
		var sock = new Socket();
		try sock.bind(new sys.net.Host(host),port)
		catch(e:Dynamic) throw 'Another server is running at $host Port $port';
		sock.listen(listen);
		while( true ) {
			try addClient(sock.accept()) catch( e: Dynamic ) {logError(e);}
		}
		
	}//
	
// --- CUSTOMIZABLE API ---

	public dynamic function clientConnected( s: Socket ): Client 
	{
		return null;
	}

	public dynamic function clientDisconnected( c: Client ) { }

	public dynamic function readClientMessage( c: Client, buf: Bytes, pos: Int, len: Int ): { msg: Message, bytes: Int } 
	{
		return { msg: null, bytes: len };
	}

	public dynamic function clientMessage( c: Client, msg: Message ) { }

}
