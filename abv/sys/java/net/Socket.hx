package abv.sys.java.net;
/*
 * 
 */ 
import haxe.io.Input;
import haxe.io.Output;
import haxe.io.Bytes;
import sys.net.Host;

import java.net.InetSocketAddress;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.channels.Selector;
import java.nio.channels.SelectionKey;
import java.nio.ByteBuffer; 
import java.nio.CharBuffer; 
import java.nio.charset.Charset;

class Socket {

	public var id(default,null): Int;
	static var _nextID = 0;

	public var input(default,null): Input;
	public var output(default,null): Output;

	public var custom : Dynamic;

	var sock:SocketChannel = null;
	var server:ServerSocketChannel = null;
	var boundAddr:java.net.SocketAddress;

	public inline function new() 
	{ 
		id = _nextID;
		_nextID++;
	}
	
	function createClient()
	{
		if (server != null) throw "is server socket";
		if (sock == null) sock = SocketChannel.open();		
	}
	
	function createServer()
	{
		if (sock != null) throw "is client socket";
		if (server == null) server = ServerSocketChannel.open();		
	}
	
	public function register( sel:Selector, ops:Int) 
	{
		var r:SelectionKey = null;
		try
		{
			if (sock != null) r = sock.register(sel,ops);
			else if (server != null) r = server.register(sel,ops);
		}
		catch(e:Dynamic) throw e;
		return r;
	}

	public function close() 
	{
		try
		{
			if (server != null) server.close();
			if (sock != null) sock.close();
		}
		catch(e:Dynamic) throw e;
	}

	public function readBytes( buf:Bytes, pos:Int, len:Int ):Int 
	{
		var r = 0;
		var b = ByteBuffer.allocate(len);	
		if (sock.read(b) > 0) { 
			b.flip(); 
			var out = Bytes.ofData(b.array());
			b.clear();
			r = out.length;
			buf.blit(pos,out,0,r);
		}
		
		return r;
	}
	
	public function read() : String
	{
		var r = "";
		if (sock.isBlocking()){
			input.readAll().toString();
		}else{
			var b = ByteBuffer.allocate(4096);		
			while (sock.read(b) > 0) {
				b.flip();
				r += Bytes.ofData(b.array()) + ""; 
				b.clear();
			}
		}
		return r;
	}

	public function write( buf: Bytes ) 
	{
		if (sock.isBlocking()){
			output.write(buf);
		}else{
			var b = ByteBuffer.wrap(buf.getData());
			while (b.hasRemaining()) sock.write(b); 
			b.clear();			
		}
	}

	public function connect( host : Host, port : Int ) 
	{
		createClient();
		try
		{
			sock.connect(new InetSocketAddress( host.reverse(), port));
			output = new java.io.NativeOutput(sock.socket().getOutputStream());
			input = new java.io.NativeInput(sock.socket().getInputStream());
		}
		catch(e:Dynamic) throw e;
	}

	public function listen( connections : Int ) 
	{
		if (boundAddr == null) throw "You must bind the Socket to an address!";
		createServer();
		try server.socket().bind(boundAddr,connections)
		catch(e:Dynamic) throw e;
	}

	public function shutdown( read : Bool, write : Bool ) 
	{
		if (sock == null) return;
		try
		{
			if (read) sock.socket().shutdownInput();
			if (write) sock.socket().shutdownOutput();
		}
		catch(e:Dynamic) throw e;
	}

	public function bind( host : Host, port : Int ) 
	{
		createServer();
		if (boundAddr != null)
		{
			if (server.socket().isBound()) throw "Already bound";
		}
		boundAddr = new InetSocketAddress(host.reverse(), port);
	}

	public function accept() : Socket
	{
		createServer();
		var ret = try server.accept() catch(e:Dynamic) throw e;

		var s = new Socket();
		s.sock = ret; 
		s.output = new java.io.NativeOutput(ret.socket().getOutputStream());
		s.input = new java.io.NativeInput(ret.socket().getInputStream());

		return s;
	}

	public function peer() : { host : Host, port : Int }
	{
		if (sock == null) return null;
		var rem = sock.socket().getInetAddress();
		if (rem == null) return null;

		var host = new Host(rem.getHostAddress());
		return { host: host, port: sock.socket().getPort() };
	}// peer()

	public function host() : { host : Host, port : Int }
	{
		if (sock == null) return null;
		var local = sock.socket().getLocalAddress().getHostName();
		var host = new Host(local);

		return { host: host, port: sock.socket().getLocalPort() };
	}// host()

	public function setTimeout( timeout : Float ) 
	{
		try sock.socket().setSoTimeout( Std.int(timeout * 1000) )
		catch(e:Dynamic) throw e;
	}

	public function waitForRead() 
	{
		throw "Not implemented";
	}

	public function setBlocking( b : Bool ) 
	{
		if (server != null) server.configureBlocking(b);
		else if (sock != null) sock.configureBlocking(b);
	}

	public function setFastSend( b : Bool ) 
	{
		try sock.socket().setTcpNoDelay(b)
		catch(e:Dynamic) throw e;
	}

	public static function select(read : Array<Socket>, write : Array<Socket>, others : Array<Socket>, ?timeout : Float) : { read: Array<Socket>,write: Array<Socket>,others: Array<Socket> }
	{
		throw "Not implemented";
		return null;
	}
}// abv.sys.java.net.Socket
