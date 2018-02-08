/**
 * 
 */
const ts = require('abv-ts')('abv:ws');
const fs = require('fs');
const AbvNode = require('abv-node');
const WebSocket = require('ws');

const $fps = 1;
const $m = 10;

const $port = 8080;
const $host = '0.0.0.0';
const $root = __dirname + '/';

const Aspa = require('abv-spa');
const aspa = new Aspa({root:$root, cache:10});


const server = aspa.listen($port, $host, (err) => {  
	if (err) return ts.error(err);
	ts.println('Aspa server is running on port ' + $port,'blue');
//	log('Abvos node is running on http://%s:%s', ip, app.get('port'));
});

const node = new AbvNode(server,WebSocket);

node.on('msg', (m) => {
		const n = Node.get('box2');
		if (m.b == 'up'){
			n.y -= $m;
		}else if (m.b == 'down'){
			n.y += $m;
		}else if (m.b == 'right'){
			n.x += $m;
		}else if (m.b == 'left'){
			n.x -= $m;
		}else{
		}
	});
//var arr = new Uint16Array([21,31]);
//setTimeout(send, 5000,arr.buffer);
//setInterval(send, 1000,ts.str2ab('ttt'));

const Node = require('../../lib/Node');
const AM = require('../../lib/AM');
const VTerm = require('../../lib/VTerm');
const Term0D = require('../../lib/Term0D');
const Color = require('../../lib/Color');

//let c = Color.rgba(0x00,0x00,0xFF,0x88);
//ts.debug(c.toString(16),Color.toName(c));

const App = require('./App');

const app = new App();
app.output = (v) => {
		const arr = app.term.toArray();
		var a = new Uint16Array(arr);
		node.send('msg',a.buffer,'@1');
	};
app.run($fps);