(function e(t, r, i) {
    function n(s, f) {
        if (!r[s]) {
            if (!t[s]) {
                var o = typeof require == "function" && require;
                if (!f && o) return o(s, !0);
                if (a) return a(s, !0);
                var c = new Error("Cannot find module '" + s + "'");
                throw c.code = "MODULE_NOT_FOUND", c;
            }
            var h = r[s] = {
                exports: {}
            };
            t[s][0].call(h.exports, function(e) {
                var r = t[s][1][e];
                return n(r ? r : e);
            }, h, h.exports, e, t, r, i);
        }
        return r[s].exports;
    }
    var a = typeof require == "function" && require;
    for (var s = 0; s < i.length; s++) n(i[s]);
    return n;
})({
    1: [ function(e, t, r) {
        "use strict";
        const i = e("abv-ts")("abv:core.Agent");
        const n = e("abv-socket");
        class a extends n.CSocket {
            constructor(e, t) {
                super(e, t);
                const r = this;
            }
        }
        t.exports = a;
    }, {
        "abv-socket": 2,
        "abv-ts": 8
    } ],
    2: [ function(e, t, r) {
        "use strict";
        const i = e("./lib/Pack.js");
        const n = e("./lib/Socket.js");
        const a = e("./lib/CSocket.js");
        const s = e("./lib/SSocket.js");
        const f = e("./lib/Conn.js");
        t.exports = {
            CSocket: a,
            SSocket: s,
            Socket: n,
            Pack: i,
            Conn: f
        };
    }, {
        "./lib/CSocket.js": 3,
        "./lib/Conn.js": 4,
        "./lib/Pack.js": 5,
        "./lib/SSocket.js": 6,
        "./lib/Socket.js": 7
    } ],
    3: [ function(e, t, r) {
        (function(r) {
            "use strict";
            const i = e("abv-ts")("abv:socket.CSocket");
            const n = e("./Pack.js");
            const a = e("./Socket.js");
            class s extends a {
                constructor(e, t) {
                    super();
                    const r = this;
                    this.queue = new Map();
                    this.mid = 1;
                    this.connect(e, t);
                    this.on("echo", e => {
                        var t = Date.now() + "";
                        return t;
                    });
                    this.on("msg", e => {
                        return r.out(e);
                    });
                    this.on("id", e => {
                        r.id = e.t;
                    });
                    this.on("online", e => {
                        r.out(e.b);
                    });
                    this.on("file", e => {
                        r.file(e);
                    });
                    this.on("error", e => {
                        i.error(46, e);
                    });
                }
                connect(e, t) {
                    if (t.name == "Socket") {} else if (!e || !e.startsWith("http")) {
                        i.error(78, "No url: " + e);
                        return;
                    }
                    const r = this;
                    const n = e.replace("http", "ws") + "/abv";
                    console.log(n);
                    if (this.sock) this.sock.close();
                    if (i.isBrowser) {
                        this.sock = new t(n);
                    } else if (t.name == "WebSocket") {
                        this.sock = new t(n, {
                            origin: e
                        });
                    } else {
                        this.sock = new t();
                        this.sock.send = r.sock.write;
                        this.sock.connect(8080, "localhost");
                    }
                    this.sock.binaryType = "arraybuffer";
                    if (i.isBrowser) {
                        this.sock.onopen = (() => r.opened());
                        this.sock.onmessage = (e => r.process(e.data));
                        this.sock.onclose = (() => r.closed());
                        this.sock.onerror = (() => r.log("Socket error"));
                    } else if (r.sock.url) {
                        this.sock.on("open", () => r.opened());
                        this.sock.on("message", e => r.process(e));
                        this.sock.on("close", () => r.closed());
                        this.sock.on("error", e => {
                            if (e.code === "ECONNREFUSED") {
                                i.debug("no connection");
                            } else {}
                        });
                    } else {
                        r.sock.on("connect", () => r.opened());
                        r.sock.on("data", e => r.process(e));
                        r.sock.on("close", () => r.closed());
                        r.sock.on("error", () => r.log("Socket error"));
                    }
                }
                opened() {
                    this.log("Connection established");
                    this.send("id", "", "");
                }
                closed() {
                    this.log("Connection closed");
                }
                call(e, t, r, n = 0) {
                    const a = this;
                    let s = this.c2m(e, t, r);
                    i.debug(53, s);
                    const f = this.listeners(s.c)[0];
                    if (typeof f !== i.fn) s.c = "err"; else if (!s.t.startsWith("@")) {} else if (n > 0) s.m = this.mid++;
                    return new Promise((t, r) => {
                        if (a.id === "") return r("Not ready");
                        if (s.c === "err") return r($no + "cmd: " + e);
                        if (s.t === a.id) return r("Selfcall: " + e);
                        a.echo(s, e => {
                            if (e) return r(e);
                            if (s.m) {
                                a.queue.set(s.m, {
                                    resolve: t,
                                    reject: r,
                                    end: Date.now() + n
                                });
                            } else {
                                t("");
                            }
                        });
                    });
                }
                process(e) {
                    const t = this;
                    const r = this.decode(e);
                    if (r && r.c) {
                        const e = this.listeners(r.c)[0];
                        if (typeof e !== i.fn) return i.error(158, $no + "cmd: " + r.c);
                        if (r.t === t.id && r.m) {
                            if (this.queue.has(r.m)) {
                                const e = this.queue.get(r.m);
                                const t = Date.now() - e.end;
                                if (t > 0) {
                                    r.b = "Timeout: +" + t + "ms";
                                    r.e = true;
                                }
                                if (!r.e) e.resolve(r); else e.reject(r);
                                this.queue.delete(r.m);
                                i.error(this.queue.size);
                            } else {
                                r.t = r.f;
                                try {
                                    r.b = e();
                                } catch (e) {
                                    r.b = e;
                                    r.e = true;
                                }
                                this.send(r);
                            }
                        } else {
                            this.emit(r.c, r);
                        }
                    } else {
                        i.error(110, $no + "msg[" + -1 + "]");
                    }
                }
                file(e) {
                    this.log(e.name);
                }
                out(e) {
                    this.log(e);
                }
                log(e) {}
            }
            t.exports = s;
        }).call(this, e("_process"));
    }, {
        "./Pack.js": 5,
        "./Socket.js": 7,
        _process: 132,
        "abv-ts": 8
    } ],
    4: [ function(e, t, r) {
        (function(r) {
            "use strict";
            const i = e("abv-ts")("abv:socket.Conn");
            const n = e("events");
            const a = e("./Pack.js");
            class s extends n {
                constructor() {
                    super();
                }
                process(e) {
                    const t = this.decode(e);
                    if (t && t.c) {
                        this.emit(t.c, t);
                    } else {
                        i.error(25, i.uk + " msg[" + -1 + "]");
                    }
                }
                encode(e) {
                    return a.encode(e);
                }
                decode(e) {
                    return a.decode(e);
                }
            }
            t.exports = s;
        }).call(this, e("_process"));
    }, {
        "./Pack.js": 5,
        _process: 132,
        "abv-ts": 8,
        events: 97
    } ],
    5: [ function(e, t, r) {
        (function(r) {
            "use strict";
            const i = e("abv-ts")("abv:socket.Pack");
            const n = console.log.bind(console);
            class a {
                constructor() {
                    throw new Error("Static class!");
                }
                static encode(e) {
                    let t = null;
                    if (!e) return t;
                    const n = [];
                    const a = [];
                    Object.keys(e).forEach((t, s) => {
                        if (i.is(e[t], r)) e[t] = e[t].buffer;
                        if (i.is(e[t], ArrayBuffer)) {
                            a.push(t);
                            n.push(e[t]);
                            delete e[t];
                        }
                    });
                    let s = i.str2ab(a.join(","));
                    n.unshift(s);
                    s = i.str2ab(i.toString(e));
                    n.unshift(s);
                    const f = [];
                    for (let e of n) f.push(e.byteLength);
                    const o = f.reduce(function(e, t) {
                        return e + t;
                    }, 0);
                    f.unshift(f.length);
                    const c = o + (f.length + 1) * 4;
                    const h = new ArrayBuffer(c);
                    const u = new DataView(h);
                    u.setUint32(0, c);
                    let d = 4;
                    for (let e of f) {
                        u.setUint32(d, e);
                        d += 4;
                    }
                    const l = new Uint8Array(h);
                    f.shift();
                    for (let e of n) {
                        l.set(new Uint8Array(e), d);
                        d += f.shift();
                    }
                    t = h;
                    return t;
                }
                static decode(e) {
                    let t = null;
                    if (!e) return t;
                    if (i.is(e, r)) e = s(e);
                    if (!i.is(e, ArrayBuffer)) return t;
                    let n = e.byteLength;
                    if (n < 8) return t;
                    const a = new DataView(e);
                    const f = a.getUint32(0);
                    if (f != n) return t;
                    try {
                        const r = [];
                        const s = [];
                        n = a.getUint32(4) + 2;
                        for (let e = 2; e < n; e++) {
                            s.push(a.getUint32(e * 4));
                        }
                        let f = n * 4;
                        t = i.fromString(i.ab2str(e.slice(f, f + s[0])));
                        f += s[0];
                        const o = i.ab2str(e.slice(f, f + s[1])).split(",");
                        f += s[1];
                        for (let t = 2; t < s.length; t++) {
                            r.push(e.slice(f, f + s[t]));
                            f += s[t];
                        }
                        for (let e in o) {
                            if (o[e]) t[o[e]] = r[e];
                        }
                    } catch (e) {
                        i.error(e);
                    }
                    return t;
                }
            }
            const s = e => {
                var t = new ArrayBuffer(e.length);
                var r = new Uint8Array(t);
                for (let t = 0, i = e.length; t < i; t++) r[t] = e[t];
                return t;
            };
            t.exports = a;
        }).call(this, e("buffer").Buffer);
    }, {
        "abv-ts": 8,
        buffer: 61
    } ],
    6: [ function(e, t, r) {
        "use strict";
        const i = e("abv-ts")("abv:socket.SSocket");
        const n = e("./Pack.js");
        const a = e("./Socket.js");
        const s = e("crypto");
        const f = s.createHash("sha256");
        const o = "BAAuTRrAyDIh6WquBij3qZaoaAbkVz/87Zw1gjg8DUkIKMZlPXZQ3vNt3GHv62EQ1dSH2V5ZMeFdus3lsLxsluxO5wEyniA7FWC/lgLY/bqF9hCU+F6lF51SBqHbINbFx4TH1s5gNxDfd9x/6t++2rqvh+W0UydWBnyIOZPiugrrnsvpcw==";
        const c = "AZUxoeIHsHmbWwKr3VsQ94yRDQWKfAyoqUu95586H+ikIhsgIUqkRKEoC7/o74b40KM1KDDp5OHfZS3orWoUNIjr";
        const h = a.clients;
        const u = a.rooms;
        class d extends a {
            constructor(e) {
                super(e);
                const t = this;
                this.on("echo", e => t.send(e));
                this.on("msg", e => t.send(e));
                this.on("join", e => t.join(e.t));
                this.on("leave", e => t.leave(e.t));
                this.on("file", e => t.send(e));
                this.on("online", e => {
                    e.b = h.size;
                    t.echo(e);
                });
                this.on("id", e => {
                    e.f = e.t = t.id;
                    t.echo(e);
                    i.debug(41, e);
                });
                this.on("auth", e => {});
                this.on("error", e => {
                    i.error(44, e);
                });
            }
            msg2srv(e) {
                i.error(45, e);
            }
            send(e) {
                const t = this;
                let r = null;
                if (!i.is(e.t, String)) e.t = "";
                if (e.t === "") {
                    r = h;
                } else if (e.t === "@0") {
                    this.msg2srv(this.encode(e));
                    return;
                } else if (e.t.startsWith("@")) {
                    r = [ h.get(e.t) ];
                } else if (u.has(e.t)) {
                    r = u.get(e.t);
                } else {
                    i.debug(70, "no room: " + e.t);
                    return;
                }
                e.f = t.id;
                i.debug(e);
                const n = this.encode(e);
                r.forEach(e => {
                    if (e && t.sock !== e.sock) {
                        e.sock.send(n, t => {
                            if (t) {
                                i.error(t);
                                e.close();
                            }
                        });
                    }
                });
            }
            auth(e) {}
        }
        t.exports = d;
    }, {
        "./Pack.js": 5,
        "./Socket.js": 7,
        "abv-ts": 8,
        crypto: 70
    } ],
    7: [ function(e, t, r) {
        "use strict";
        const i = e("abv-ts")("abv:socket.Socket");
        const n = e("./Conn.js");
        let a = 1 | 0;
        const s = new Map();
        const f = new Map();
        const o = (e, t, r, n) => {
            if (!i.is(n, String)) n = "";
            const a = {
                c: e,
                f: r,
                t: n
            };
            if (typeof t === i.o) {
                if (!t.hasOwnProperty("body")) t.body = "";
                Object.keys(t).forEach((e, r) => {
                    if (e == "body") a.b = t[e]; else a[e] = t[e];
                });
            } else if (i.is(t, String)) {
                a.b = t;
            } else {
                a.b = String(t);
            }
            return a;
        };
        class c extends n {
            constructor(e) {
                super();
                this.sock = e;
                this.id = e ? "@" + a++ : "";
                s.set(this.id, this);
                this.rooms = new Set();
                this.rooms.add(this.id);
            }
            c2m(e, t, r) {
                return o(e, t, this.id, r);
            }
            log(e) {
                i.log(e);
            }
            join(e) {
                if (e == this.id) return;
                this.rooms.add(e);
                if (!f.has(e)) f.set(e, new Set());
                f.get(e).add(this);
            }
            leave(e) {
                if (e == this.id) return;
                this.rooms.delete(e);
                if (f.has(e)) {
                    f.get(e).delete(this);
                    if (f.get(e).size == 0) f.delete(e);
                }
            }
            echo(e, t) {
                const r = this;
                const n = this.encode(e);
                const a = r.id + " closed";
                if (i.isBrowser) {
                    let e = false;
                    try {
                        this.sock.send(n);
                    } catch (t) {
                        e = t;
                    }
                    if (e) {
                        i.error(182, a);
                        this.close();
                    }
                    if (typeof t === i.fn) return t(e);
                } else {
                    this.sock.send(n, e => {
                        if (e) {
                            i.error(188, a);
                            r.close();
                        }
                        if (typeof t === i.fn) return t(e);
                    });
                }
            }
            send(e, t, r) {
                if (typeof e === i.o) return this.echo(e);
                this.echo(o(e, t, this.id, r));
            }
            close() {
                const e = this;
                if (this.sock) {
                    if (this.sock.url) this.sock.close(); else this.sock.close();
                }
                s.delete(e.id);
                f.forEach(t => t.delete(e.id));
            }
            static get clients() {
                return s;
            }
            static get rooms() {
                return f;
            }
        }
        t.exports = c;
    }, {
        "./Conn.js": 4,
        "abv-ts": 8
    } ],
    8: [ function(e, t, r) {
        (function(e, r) {
            "use strict";
            const i = console.log.bind(console);
            const n = "function";
            const a = "object";
            const s = "string";
            const f = "undefined";
            const o = "Unknown";
            const c = typeof window !== f && window;
            const h = c ? false : e.execArgv.indexOf("--inspect") !== -1;
            const u = "no";
            const d = "error";
            const l = "warn";
            const p = "log";
            const b = "info";
            const v = "debug";
            const m = [ u, d, l, p, b, v ];
            Object.freeze(m);
            const y = "red";
            const g = "blue";
            const w = "green";
            const _ = "yellow";
            const S = "orange";
            const M = "magenta";
            const k = "cyan";
            const E = "gray";
            const x = "black";
            const A = "white";
            const B = [ y, g, w, S, M, k, E ];
            Object.freeze(B);
            const I = "[0m";
            const j = "[1m";
            const C = "[2m";
            const R = "[4m";
            const P = "[5m";
            const T = "[7m";
            const D = "[8m";
            const L = "[30m";
            const q = "[31m";
            const N = "[32m";
            const O = "[33m";
            const z = "[34m";
            const U = "[35m";
            const K = "[36m";
            const F = "[37m";
            const H = "[40m";
            const W = "[41m";
            const V = "[42m";
            const X = "[43m";
            const Z = "[44m";
            const J = "[45m";
            const Y = "[46m";
            const G = "[47m";
            let $ = 0 | 0;
            const Q = e => {
                return e.reduce((e, t) => {
                    const r = new Set(t);
                    return e.filter(e => r.has(e));
                });
            };
            const ee = e => {
                const t = e.reduce((e, t) => e.concat(t), []);
                return Array.from(new Set(t));
            };
            const te = e => {
                const t = new Set(Q(e));
                const r = ee(e);
                return r.filter(e => !t.has(e));
            };
            const re = (e, t = false) => {
                let r = e;
                if (c || h) return r;
                if (!e) r = I; else if (e === y) r = t ? W : q; else if (e === g) r = t ? Z : z; else if (e === w) r = t ? V : N; else if (e === S) r = t ? X : O; else if (e === _) r = t ? X : O; else if (e === M) r = t ? J : U; else if (e === k) r = t ? Y : K; else if (e === E) r = t ? G : C; else if (e === x) r = t ? H : L; else if (e === A) r = t ? G : F;
                return r;
            };
            const ie = e => {
                let t = "[" + a + "]";
                try {
                    t = JSON.stringify(e);
                } catch (e) {}
                return t;
            };
            const ne = e => {
                let t = {};
                try {
                    t = JSON.parse(e);
                } catch (e) {}
                return t;
            };
            const ae = e => {
                let t = "-1";
                try {
                    const r = new DataView(e);
                    const i = e.byteLength / 2;
                    const n = new Uint16Array(i);
                    for (let e = 0; e < i; e++) {
                        n[e] = r.getUint16(e * 2);
                    }
                    t = String.fromCharCode.apply(null, n);
                } catch (e) {}
                return t;
            };
            const se = e => {
                if (!he(e, String)) e = "-1";
                const t = new ArrayBuffer(e.length * 2);
                const r = new DataView(t);
                for (let t = 0, i = e.length; t < i; t++) {
                    r.setUint16(t * 2, e.charCodeAt(t));
                }
                return t;
            };
            const fe = (t, r, n) => {
                t = he(t, String) ? t : String(t);
                if (c) {
                    i(t);
                } else {
                    if (r) {
                        t = re(r) + t + I;
                        if (n) t = re(n, true) + t;
                    }
                    e.stdout.write(t);
                }
            };
            const oe = (e, t, r, n, a) => {
                let s = "";
                let f = ye.time ? " +" + a : "";
                if (!a) f = "";
                if (!ye.color) {
                    s = t + ": " + e + f;
                    if (!ye.test) i(s);
                } else if (c || h || ye.browser) {
                    s = "%c " + t + " %c " + e + f;
                    if (!ye.test) i(s, "background: " + re(n, true) + "; color: white", "color: " + re(r));
                } else {
                    if (ye.test) n = y;
                    s = re(n, true) + F + j + " " + t + " " + I + " " + re(r) + e + f + I;
                    if (!ye.test) i(s);
                }
                return s;
            };
            const ce = (e, t) => {
                let r;
                if (he(e, t)) {
                    r = e;
                } else {
                    throw new TypeError("Cast error");
                }
                return r;
            };
            const he = (e, t) => {
                let i = false;
                if (typeof e === f || typeof t === f) return i;
                if (t === String) {
                    i = typeof e === s || e instanceof String;
                } else if (t === ArrayBuffer) {
                    i = e instanceof ArrayBuffer;
                } else if (t === r) {
                    i = e instanceof r;
                } else if (t instanceof Array) {
                    if (t.length !== 1) {} else if (e instanceof Array) {
                        let r = true;
                        for (let i = 0, n = e.length; i < n; i++) {
                            if (!he(e[i], t[0])) {
                                r = false;
                                break;
                            }
                        }
                        if (r) i = true;
                    }
                } else if (t === "Int") {
                    i = Number.isInteger(e);
                } else if (t === "Float") {
                    i = Number.isFinite(e) && !Number.isInteger(e);
                } else if (t === Number) {
                    i = typeof e === "number";
                } else if (t === Boolean) {
                    i = typeof e === "boolean" || e instanceof Boolean;
                } else if (e instanceof t) {
                    i = true;
                } else {
                    i = de([ e, t, 215 ]) === "";
                }
                return i;
            };
            const ue = e => {
                let t = "";
                const r = [];
                const i = e.length % 2 === 0 ? e.length : e.length - 1;
                for (let t = 0; t < i; t += 2) {
                    if (!he(e[t], e[t + 1])) {
                        r.push("arg" + Math.round((t + 1) / 2));
                    }
                }
                const n = e.length > i ? e[i] + " " : "";
                if (r.length > 0) t = n + "TypeError: " + r.join(", ");
                return t;
            };
            const de = e => {
                let t = "";
                const r = [];
                const i = n;
                let a = typeof e[0] === i ? new e[0]() : e[0];
                const s = Array.from(Object.keys(a));
                const f = a.constructor.name + "{}";
                let o = [];
                do {
                    o = o.concat(Object.getOwnPropertyNames(a));
                } while (a = Object.getPrototypeOf(a));
                let c, h, u, d, l;
                const p = he(e[e.length - 1], "Int") ? e.length - 1 : e.length;
                for (let t = 1; t < p; t++) {
                    c = typeof e[t] === i ? new e[t]() : e[t];
                    l = c.constructor.name;
                    h = Object.getOwnPropertyNames(Object.getPrototypeOf(c));
                    u = Array.from(Object.keys(c));
                    d = Q([ s, u ]);
                    d = te([ d, u ]);
                    if (d.length > 0) r.push(l + "{" + d + "}");
                    d = Q([ o, h ]);
                    d = te([ d, h ]);
                    if (d.length > 0) r.push(l + "(" + d + ")");
                }
                const b = e.length > p ? e[p] + " " : "";
                if (r.length > 0) t = b + f + " missing: " + r.join(", ");
                return t;
            };
            const le = e => {
                for (let t in e) e[t] = e[t].trim();
            };
            const pe = e => {
                const t = {};
                if (!e) e = "";
                let r = [];
                try {
                    r = e.split(",");
                    le(r);
                } catch (e) {}
                let i = r[0] ? r[0] : "";
                const n = r[1] ? r[1] : v;
                try {
                    r = i.split(":");
                    le(r);
                } catch (e) {}
                t.proj = r[0] ? r[0] : "";
                t.mod = r[1] ? r[1] : "";
                t.bg = B[$ % B.length];
                i = m.indexOf(n);
                t.level = i === -1 ? 0 : i;
                return t;
            };
            const be = e => {
                let t = [];
                let r = "";
                for (let r = 0, i = e.length; r < i; r++) {
                    if (typeof e[r] !== a) {
                        t.push(e[r]);
                    } else {
                        t.push(ie(e[r]));
                    }
                }
                return t.join(", ");
            };
            const ve = e => {
                if (e < 1e3) return e + "ms";
                let t = e / 1e3;
                if (t < 60) return t.toFixed(2) + "s";
                t = Math.floor(e % 6e4 / 1e3);
                let r = Math.floor(e / 6e4);
                if (r < 60) return r + ":" + (t < 10 ? "0" : "") + t + "m";
                r = Math.floor(e % 36e5 / 6e4);
                let i = Math.floor(e / 36e5);
                return i + ":" + (r < 10 ? "0" : "") + r + "h";
            };
            const me = e => {
                if (!he(e, String)) e = "";
                let t = 5381 | 0;
                for (let r in e) {
                    t = (t << 5) + t + e.charCodeAt(r);
                }
                return t;
            };
            const ye = pe((c ? localStorage.debug : e.env.DEBUG) || "");
            ye.color = true;
            ye.time = true;
            ye.test = false;
            ye.browser = false;
            class ge {
                constructor(e) {
                    const t = pe(e);
                    this.level = ye.level < t.level ? ye.level : t.level;
                    if (ye.proj !== t.proj) this.level = 0; else if (ye.mod === "" || ye.mod === "*") {} else if (ye.mod !== t.mod) this.level = 0;
                    this.name = t.proj + (t.mod ? ":" + t.mod : "");
                    if (this.name == "") this.name = "ts:" + this.rand;
                    this.bg = t.bg;
                    $++;
                    if ($ > B.length) $ = 0;
                    this.now = Date.now();
                }
                get fn() {
                    return n;
                }
                get o() {
                    return a;
                }
                get s() {
                    return s;
                }
                get ud() {
                    return f;
                }
                get uk() {
                    return o;
                }
                get colors() {
                    return B;
                }
                get levels() {
                    return m;
                }
                get isBrowser() {
                    return c;
                }
                get isInspector() {
                    return h;
                }
                time(e) {
                    return ve(e);
                }
                trim(e) {
                    le(e);
                }
                toString(e) {
                    return ie(e);
                }
                fromString(e) {
                    return ne(e);
                }
                ab2str(e) {
                    return ae(e);
                }
                str2ab(e) {
                    return se(e);
                }
                djb2(e) {
                    return me(e);
                }
                clear(e) {
                    e.length = 0;
                }
                clr2c(e, t = false) {
                    return re(e, t);
                }
                toJson(e) {
                    return JSON.stringify(e, null, 2);
                }
                print(e, t, r) {
                    fe(e, t, r);
                }
                println(e, t, r) {
                    fe(e + "\n", t, r);
                }
                rand() {
                    const e = me(Date.now() + this.name);
                    return Math.random().toString(36).slice(2) + e;
                }
                set(e) {
                    if (typeof e !== a) return;
                    if (e.level) {
                        const t = m.indexOf(e.level);
                        if (t !== -1) e.level = this.level = t;
                    }
                    Object.keys(e).forEach(t => {
                        if (ye.hasOwnProperty(t)) ye[t] = e[t];
                    });
                }
                dt() {
                    const e = Date.now();
                    const t = e - this.now;
                    this.now = e;
                    return ve(t);
                }
                error(e) {
                    if (this.level < 1) return "";
                    return oe(be(arguments), this.name, y, this.bg, this.dt());
                }
                warn(e) {
                    if (this.level < 2) return "";
                    return oe(be(arguments), this.name, S, this.bg, this.dt());
                }
                log(e) {
                    if (this.level < 3) return "";
                    return oe(be(arguments), this.name, E, this.bg, this.dt());
                }
                info(e) {
                    if (this.level < 4) return "";
                    return oe(be(arguments), this.name, g, this.bg, this.dt());
                }
                debug(e) {
                    if (this.level < 5) return "";
                    return oe(be(arguments), this.name, w, this.bg, this.dt());
                }
                type(e, t) {
                    if (this.level < 5) return "";
                    var r = "";
                    if (e === null) r = "null"; else if (e && e.constructor) r = e.constructor.name; else r = typeof e;
                    oe([ r ], this.name, y, this.bg, this.dt());
                    if (t) throw new Error(String(t));
                }
                cast(e, t) {
                    return ce(e, t);
                }
                is(e, t) {
                    return he(e, t);
                }
                params(e, t, r) {
                    if (this.level < 5) return true;
                    const i = ue(Array.from(arguments));
                    if (i !== "") {
                        this.error(i);
                        return false;
                    }
                    return true;
                }
                implements(e, t, r) {
                    if (this.level < 5) return true;
                    const i = de(Array.from(arguments));
                    if (i !== "") {
                        this.error(i);
                        return false;
                    }
                    return true;
                }
                intersec(e, t) {
                    const r = Array.from(arguments);
                    if (r.length < 2) {
                        this.error("arg2..?");
                        return [];
                    }
                    return Q(r);
                }
                diff(e, t) {
                    const r = Array.from(arguments);
                    if (r.length < 2) {
                        this.error("arg2..?");
                        return [];
                    }
                    return te(r);
                }
                union(e, t) {
                    const r = Array.from(arguments);
                    if (r.length < 2) {
                        this.error("arg2..?");
                        return [];
                    }
                    return ee(r);
                }
            }
            t.exports = (e => {
                return new ge(e);
            });
        }).call(this, e("_process"), e("buffer").Buffer);
    }, {
        _process: 132,
        buffer: 61
    } ],
    9: [ function(e, t, r) {
        "use strict";
        const i = e("abv-ts")("abv:AM");
        const n = e("./ATerm");
        let a = null;
        class s {
            constructor() {
                this.term = null;
                this.create();
            }
            create() {}
            update() {
                this.render();
            }
            output(e) {}
            intput(e) {}
            render() {
                this.term.render();
                this.output();
            }
            addLayer(e) {
                this.term.addLayer(e);
            }
            run(e = 30) {
                if (a != null) return;
                if (e > 0) a = setInterval(this.update.bind(this), 1e3 / e); else this.update(this);
            }
            stop() {
                clearInterval(a);
            }
            exit(e) {}
        }
        t.exports = s;
    }, {
        "./ATerm": 10,
        "abv-ts": 8
    } ],
    10: [ function(e, t, r) {
        "use strict";
        const i = e("abv-ts")("abv:ATerm");
        const n = e => {
            let t = [];
            for (let r of e) t.push(a(r));
            t = a(t);
            return t;
        };
        const a = e => {
            let t = [], r;
            for (let i of e) {
                r = i.length;
                i.unshift(r);
                t = t.concat(i);
            }
            return t;
        };
        const s = e => {
            let t = f(e);
            for (let e = 0, r = t.length; e < r; e++) t[e] = f(t[e]);
            return t;
        };
        const f = e => {
            let t = [], r = 0, i;
            while (r < e.length) {
                i = e[r] + r + 1;
                t.push(e.slice(r + 1, i));
                r = i;
            }
            return t;
        };
        class o {
            constructor() {
                this.layers = [];
            }
            toArray() {
                return n(this.layers);
            }
            fromArray(e) {
                this.layers = s(e);
            }
            render() {
                this.clear();
                for (let e of this.layers) this.draw(e);
            }
            clear() {}
            draw(e) {
                for (let t of e) {
                    switch (t[1]) {
                      case 0:
                        this.rect(t[0], t[2], t[3], t[4], t[5], t[6], t[7]);
                        break;

                      default:
                        i.error(29, "kind: " + t[1]);
                    }
                }
            }
            rect(e, t, r, n, a, s, f) {
                i.debug("rect", e, t, r, n, a, s, f);
            }
            addLayer(e) {
                this.layers.push(e);
            }
            onKeyUp(e) {}
            onKeyDown(e) {}
            onWheel(e) {}
            onMouseMove(e) {}
            onMouseUp(e) {}
            onMouseDown(e) {}
            onClick(e) {}
            dispose() {}
        }
        t.exports = o;
    }, {
        "abv-ts": 8
    } ],
    11: [ function(e, t, r) {
        "use strict";
        class i {
            constructor() {
                throw new Error("Static class!");
            }
            static rgba(e, t, r, i) {
                return (e & 255) << 24 | (t & 255) << 16 | (r & 255) << 8 | i & 255;
            }
            static toRgba(e) {
                return [ e >> 24 & 255, e >> 16 & 255, e >> 8 & 255, e & 255 ];
            }
            static to2B(e) {
                return [ e >> 16 & 65535, e & 65535 ];
            }
            static from2B(e, t) {
                return (e & 65535) << 16 | t & 65535;
            }
            static toRgbaCss(e) {
                const t = i.toRgba(e);
                return "rgba(" + t[0] + "," + t[1] + "," + t[2] + "," + t[3] / 255 + ")";
            }
            static toHex(e) {
                const t = i.toRgba(e);
                return "#" + t[0].toString(16) + t[1].toString(16) + t[2].toString(16);
            }
            static name(e) {
                e = e.toLowerCase();
                let t;
                switch (e) {
                  case "white":
                    t = 4294967295;
                    break;

                  case "silver":
                    t = 3233857791;
                    break;

                  case "gray":
                    t = 2155905279;
                    break;

                  case "red":
                    t = 4278190335;
                    break;

                  case "maroon":
                    t = 2147483903;
                    break;

                  case "yellow":
                    t = 4294902015;
                    break;

                  case "orange":
                    t = 4289003775;
                    break;

                  case "olive":
                    t = 2155872511;
                    break;

                  case "lime":
                    t = 16711935;
                    break;

                  case "green":
                    t = 8388863;
                    break;

                  case "cyan":
                    t = 16777215;
                    break;

                  case "teal":
                    t = 8421631;
                    break;

                  case "blue":
                    t = 65535;
                    break;

                  case "navy":
                    t = 33023;
                    break;

                  case "fuchsia":
                    t = 4278255615;
                    break;

                  case "purple":
                    t = 2147516671;
                    break;

                  case "black":
                    t = 255;
                    break;

                  default:
                    t = 0;
                }
                return t;
            }
            static toName(e) {
                e = e >> 8 & 16777215;
                let t;
                switch (e) {
                  case 16777215:
                    t = "white";
                    break;

                  case 12632256:
                    t = "silver";
                    break;

                  case 8421504:
                    t = "gray";
                    break;

                  case 16711680:
                    t = "red";
                    break;

                  case 8388608:
                    t = "maroon";
                    break;

                  case 16776960:
                    t = "yellow";
                    break;

                  case 16753920:
                    t = "orange";
                    break;

                  case 8421376:
                    t = "olive";
                    break;

                  case 65280:
                    t = "lime";
                    break;

                  case 32768:
                    t = "green";
                    break;

                  case 65535:
                    t = "cyan";
                    break;

                  case 32896:
                    t = "teal";
                    break;

                  case 255:
                    t = "blue";
                    break;

                  case 128:
                    t = "navy";
                    break;

                  case 16711935:
                    t = "fuchsia";
                    break;

                  case 8388736:
                    t = "purple";
                    break;

                  case 0:
                    t = "black";
                    break;

                  default:
                    t = "white";
                }
                return t;
            }
        }
        t.exports = i;
    }, {} ],
    12: [ function(e, t, r) {
        "use strict";
        const i = e("abv-ts")("abv:Node");
        const n = new Map();
        const a = [];
        class s {
            constructor(e, t = 0, r = 0, i = 0, s = 0, f = 0) {
                if (n.has(e)) throw Error("ID exists: " + e);
                a.push(e);
                this.id = e;
                n.set(e, this);
                this._x = t;
                this._y = r;
                this.w = i;
                this.h = s;
                this.color = f;
                this.kind = 0;
                this.children = new Map();
                this.parent = null;
            }
            get x() {
                return this._x;
            }
            set x(e) {
                let t = e - this.x;
                for (let [e, r] of this.children) if (r) r.x += t;
                this._x = e;
            }
            get y() {
                return this._y;
            }
            set y(e) {
                let t = e - this.y;
                for (let [e, r] of this.children) if (r) r.y += t;
                this._y = e;
            }
            addChild(e) {
                if (!e) return;
                if (this.children.has(e.id)) return;
                if (e.parent) e.parent.delChild(e);
                this.children.set(e.id, e);
                e.parent = this;
            }
            delChild(e) {
                if (!e) return;
                e.parent = null;
                this.children.delete(e.id);
            }
            static get(e) {
                let t = null;
                if (n.has(e)) t = n.get(e);
                return t;
            }
            static id(e) {
                return a.indexOf(e);
            }
        }
        t.exports = s;
    }, {
        "abv-ts": 8
    } ],
    13: [ function(e, t, r) {
        "use strict";
        const i = e("abv-ts")("abv:Term1D");
        const n = e("./ATerm");
        const a = e("./Color");
        class s extends n {
            constructor() {
                super();
                this.doc = window.document;
                this.elms = new Map();
                this.addListeners();
            }
            addListeners() {
                window.addEventListener("keydown", this.onKeyDown_.bind(this), false);
                window.addEventListener("keyup", this.onKeyUp_.bind(this), false);
                window.addEventListener("mouseup", this.onMouseUp_.bind(this), false);
                window.addEventListener("mousedown", this.onMouseDown_.bind(this), false);
                window.addEventListener("mousemove", this.onMouseMove_.bind(this), false);
                window.addEventListener("DOMMouseScroll", this.onWheel_.bind(this), false);
                window.onmousewheel = this.doc.onmousewheel = this.onWheel_.bind(this);
            }
            delListeners() {
                window.removeEventListener("keydown", this.onKeyDown_, false);
                window.removeEventListener("keyup", this.onKeyUp_, false);
                window.removeEventListener("mouseup", this.onMouseUp_, false);
                window.removeEventListener("mousedown", this.onMouseDown_, false);
                window.removeEventListener("mousemove", this.onMouseMove_, false);
                window.removeEventListener("DOMMouseScroll", this.onWheel_, false);
                window.onmousewheel = this.doc.onmousewheel = null;
            }
            clear() {}
            shape(e, t) {
                let r = this.elms.get(e);
                if (!r) {
                    r = this.doc.createElement("div");
                    r.id = e;
                    r.style.backgroundColor = a.toRgbaCss(t);
                    r.style.border = "1px solid #0000FF";
                    this.doc.body.appendChild(r);
                    this.elms.set(e, r);
                }
                return r;
            }
            rect(e, t, r, i, n, s, f) {
                const o = a.from2B(s, f);
                const c = this.shape(e, o);
                c.style.left = t + "px";
                c.style.top = r + "px";
                c.style.width = i + "px";
                c.style.height = n + "px";
                c.style.margin = "0px";
                c.style.position = "fixed";
            }
            onKeyUp_(e) {
                e.preventDefault();
                this.onKeyUp(e);
            }
            onKeyDown_(e) {
                e.preventDefault();
                this.onKeyDown(e);
            }
            onMouseMove_(e) {
                e.preventDefault();
                this.onMouseMove(e);
            }
            onWheel_(e) {
                let t = 0;
                if (!e) e = window.event;
                if (e.wheelDelta) {
                    t = e.wheelDelta / 120;
                } else if (e.detail) {
                    t = -e.detail / 3;
                }
                if (t) this.onWheel(t);
                e.preventDefault();
                e.returnValue = false;
            }
            onMouseUp_(e) {
                e.preventDefault();
                this.onMouseUp(e);
            }
            onMouseDown_(e) {
                e.preventDefault();
                this.onMouseDown(e);
            }
            dispose() {
                this.delListeners();
            }
        }
        t.exports = s;
    }, {
        "./ATerm": 10,
        "./Color": 11,
        "abv-ts": 8
    } ],
    14: [ function(e, t, r) {
        "use strict";
        const i = e("abv-ts")("abv:Term2D");
        const n = e("./Term1D");
        const a = e("./Color");
        class s extends n {
            constructor() {
                super();
                const e = "canvas";
                const t = document.createElement(e);
                t.id = e;
                t.style.left = "0px";
                t.style.top = "0px";
                t.width = 1024;
                t.height = 624;
                t.style.margin = "0px";
                t.style.position = "fixed";
                document.body.appendChild(t);
                this.init(t);
            }
            init(e) {
                this.ctx = e.getContext("2d");
            }
            clear() {
                this.ctx.clearRect(0, 0, this.ctx.canvas.width, this.ctx.canvas.height);
            }
            rect(e, t, r, i, n, s, f) {
                const o = a.from2B(s, f);
                this.ctx.beginPath();
                this.ctx.rect(t, r, i, n);
                this.ctx.strokeStyle = "blue";
                this.ctx.fillStyle = a.toRgbaCss(o);
                this.ctx.fill();
                this.ctx.stroke();
            }
        }
        t.exports = s;
    }, {
        "./Color": 11,
        "./Term1D": 13,
        "abv-ts": 8
    } ],
    15: [ function(e, t, r) {
        "use strict";
        const i = e("abv-ts")("abv:VTerm");
        const n = e("./ATerm");
        const a = e("./Node");
        const s = e("./Color");
        class f extends n {
            constructor() {
                super();
                this.roots = [];
            }
            render() {
                this.clear();
                this.layers.length = 0;
                let e;
                for (let t of this.roots) {
                    e = [];
                    this.draw(t, e);
                    this.layers.push(e);
                }
            }
            draw(e, t) {
                const r = s.to2B(e.color);
                switch (e.kind) {
                  case 0:
                    t.push([ a.id(e.id), 0, e.x, e.y, e.w, e.h, r[0], r[1] ]);
                    break;

                  default:
                    i.error(29, "kind: " + e.kind);
                }
                if (e.children.size > 0) {
                    for (let [r, i] of e.children) if (i) this.draw(i, t);
                }
            }
            addLayer(e) {
                this.roots.push(e);
            }
        }
        t.exports = f;
    }, {
        "./ATerm": 10,
        "./Color": 11,
        "./Node": 12,
        "abv-ts": 8
    } ],
    16: [ function(e, t, r) {
        "use strict";
        const i = e("abv-ts")("abv:Basic");
        const n = e("../../lib/VTerm");
        const a = e("../../lib/Node");
        const s = e("../../lib/AM");
        const f = e("../../lib/Term1D");
        const o = e("../../lib/Term2D");
        const c = e("../../lib/Color");
        const h = e("abv-core/lib/Agent");
        window.ts = i;
        window.abv = {
            Color: c,
            VTerm: n,
            Node: a,
            AM: s,
            Term1D: f,
            Term2D: o,
            Agent: h
        };
    }, {
        "../../lib/AM": 9,
        "../../lib/Color": 11,
        "../../lib/Node": 12,
        "../../lib/Term1D": 13,
        "../../lib/Term2D": 14,
        "../../lib/VTerm": 15,
        "abv-core/lib/Agent": 1,
        "abv-ts": 8
    } ],
    17: [ function(e, t, r) {
        var i = r;
        i.bignum = e("bn.js");
        i.define = e("./asn1/api").define;
        i.base = e("./asn1/base");
        i.constants = e("./asn1/constants");
        i.decoders = e("./asn1/decoders");
        i.encoders = e("./asn1/encoders");
    }, {
        "./asn1/api": 18,
        "./asn1/base": 20,
        "./asn1/constants": 24,
        "./asn1/decoders": 26,
        "./asn1/encoders": 29,
        "bn.js": 32
    } ],
    18: [ function(e, t, r) {
        var i = e("../asn1");
        var n = e("inherits");
        var a = r;
        a.define = function e(t, r) {
            return new s(t, r);
        };
        function s(e, t) {
            this.name = e;
            this.body = t;
            this.decoders = {};
            this.encoders = {};
        }
        s.prototype._createNamed = function t(r) {
            var i;
            try {
                i = e("vm").runInThisContext("(function " + this.name + "(entity) {\n" + "  this._initNamed(entity);\n" + "})");
            } catch (e) {
                i = function(e) {
                    this._initNamed(e);
                };
            }
            n(i, r);
            i.prototype._initNamed = function e(t) {
                r.call(this, t);
            };
            return new i(this);
        };
        s.prototype._getDecoder = function e(t) {
            t = t || "der";
            if (!this.decoders.hasOwnProperty(t)) this.decoders[t] = this._createNamed(i.decoders[t]);
            return this.decoders[t];
        };
        s.prototype.decode = function e(t, r, i) {
            return this._getDecoder(r).decode(t, i);
        };
        s.prototype._getEncoder = function e(t) {
            t = t || "der";
            if (!this.encoders.hasOwnProperty(t)) this.encoders[t] = this._createNamed(i.encoders[t]);
            return this.encoders[t];
        };
        s.prototype.encode = function e(t, r, i) {
            return this._getEncoder(r).encode(t, i);
        };
    }, {
        "../asn1": 17,
        inherits: 115,
        vm: 166
    } ],
    19: [ function(e, t, r) {
        var i = e("inherits");
        var n = e("../base").Reporter;
        var a = e("buffer").Buffer;
        function s(e, t) {
            n.call(this, t);
            if (!a.isBuffer(e)) {
                this.error("Input not Buffer");
                return;
            }
            this.base = e;
            this.offset = 0;
            this.length = e.length;
        }
        i(s, n);
        r.DecoderBuffer = s;
        s.prototype.save = function e() {
            return {
                offset: this.offset,
                reporter: n.prototype.save.call(this)
            };
        };
        s.prototype.restore = function e(t) {
            var r = new s(this.base);
            r.offset = t.offset;
            r.length = this.offset;
            this.offset = t.offset;
            n.prototype.restore.call(this, t.reporter);
            return r;
        };
        s.prototype.isEmpty = function e() {
            return this.offset === this.length;
        };
        s.prototype.readUInt8 = function e(t) {
            if (this.offset + 1 <= this.length) return this.base.readUInt8(this.offset++, true); else return this.error(t || "DecoderBuffer overrun");
        };
        s.prototype.skip = function e(t, r) {
            if (!(this.offset + t <= this.length)) return this.error(r || "DecoderBuffer overrun");
            var i = new s(this.base);
            i._reporterState = this._reporterState;
            i.offset = this.offset;
            i.length = this.offset + t;
            this.offset += t;
            return i;
        };
        s.prototype.raw = function e(t) {
            return this.base.slice(t ? t.offset : this.offset, this.length);
        };
        function f(e, t) {
            if (Array.isArray(e)) {
                this.length = 0;
                this.value = e.map(function(e) {
                    if (!(e instanceof f)) e = new f(e, t);
                    this.length += e.length;
                    return e;
                }, this);
            } else if (typeof e === "number") {
                if (!(0 <= e && e <= 255)) return t.error("non-byte EncoderBuffer value");
                this.value = e;
                this.length = 1;
            } else if (typeof e === "string") {
                this.value = e;
                this.length = a.byteLength(e);
            } else if (a.isBuffer(e)) {
                this.value = e;
                this.length = e.length;
            } else {
                return t.error("Unsupported type: " + typeof e);
            }
        }
        r.EncoderBuffer = f;
        f.prototype.join = function e(t, r) {
            if (!t) t = new a(this.length);
            if (!r) r = 0;
            if (this.length === 0) return t;
            if (Array.isArray(this.value)) {
                this.value.forEach(function(e) {
                    e.join(t, r);
                    r += e.length;
                });
            } else {
                if (typeof this.value === "number") t[r] = this.value; else if (typeof this.value === "string") t.write(this.value, r); else if (a.isBuffer(this.value)) this.value.copy(t, r);
                r += this.length;
            }
            return t;
        };
    }, {
        "../base": 20,
        buffer: 61,
        inherits: 115
    } ],
    20: [ function(e, t, r) {
        var i = r;
        i.Reporter = e("./reporter").Reporter;
        i.DecoderBuffer = e("./buffer").DecoderBuffer;
        i.EncoderBuffer = e("./buffer").EncoderBuffer;
        i.Node = e("./node");
    }, {
        "./buffer": 19,
        "./node": 21,
        "./reporter": 22
    } ],
    21: [ function(e, t, r) {
        var i = e("../base").Reporter;
        var n = e("../base").EncoderBuffer;
        var a = e("../base").DecoderBuffer;
        var s = e("minimalistic-assert");
        var f = [ "seq", "seqof", "set", "setof", "objid", "bool", "gentime", "utctime", "null_", "enum", "int", "objDesc", "bitstr", "bmpstr", "charstr", "genstr", "graphstr", "ia5str", "iso646str", "numstr", "octstr", "printstr", "t61str", "unistr", "utf8str", "videostr" ];
        var o = [ "key", "obj", "use", "optional", "explicit", "implicit", "def", "choice", "any", "contains" ].concat(f);
        var c = [ "_peekTag", "_decodeTag", "_use", "_decodeStr", "_decodeObjid", "_decodeTime", "_decodeNull", "_decodeInt", "_decodeBool", "_decodeList", "_encodeComposite", "_encodeStr", "_encodeObjid", "_encodeTime", "_encodeNull", "_encodeInt", "_encodeBool" ];
        function h(e, t) {
            var r = {};
            this._baseState = r;
            r.enc = e;
            r.parent = t || null;
            r.children = null;
            r.tag = null;
            r.args = null;
            r.reverseArgs = null;
            r.choice = null;
            r.optional = false;
            r.any = false;
            r.obj = false;
            r.use = null;
            r.useDecoder = null;
            r.key = null;
            r["default"] = null;
            r.explicit = null;
            r.implicit = null;
            r.contains = null;
            if (!r.parent) {
                r.children = [];
                this._wrap();
            }
        }
        t.exports = h;
        var u = [ "enc", "parent", "children", "tag", "args", "reverseArgs", "choice", "optional", "any", "obj", "use", "alteredUse", "key", "default", "explicit", "implicit", "contains" ];
        h.prototype.clone = function e() {
            var t = this._baseState;
            var r = {};
            u.forEach(function(e) {
                r[e] = t[e];
            });
            var i = new this.constructor(r.parent);
            i._baseState = r;
            return i;
        };
        h.prototype._wrap = function e() {
            var t = this._baseState;
            o.forEach(function(e) {
                this[e] = function r() {
                    var i = new this.constructor(this);
                    t.children.push(i);
                    return i[e].apply(i, arguments);
                };
            }, this);
        };
        h.prototype._init = function e(t) {
            var r = this._baseState;
            s(r.parent === null);
            t.call(this);
            r.children = r.children.filter(function(e) {
                return e._baseState.parent === this;
            }, this);
            s.equal(r.children.length, 1, "Root node can have only one child");
        };
        h.prototype._useArgs = function e(t) {
            var r = this._baseState;
            var i = t.filter(function(e) {
                return e instanceof this.constructor;
            }, this);
            t = t.filter(function(e) {
                return !(e instanceof this.constructor);
            }, this);
            if (i.length !== 0) {
                s(r.children === null);
                r.children = i;
                i.forEach(function(e) {
                    e._baseState.parent = this;
                }, this);
            }
            if (t.length !== 0) {
                s(r.args === null);
                r.args = t;
                r.reverseArgs = t.map(function(e) {
                    if (typeof e !== "object" || e.constructor !== Object) return e;
                    var t = {};
                    Object.keys(e).forEach(function(r) {
                        if (r == (r | 0)) r |= 0;
                        var i = e[r];
                        t[i] = r;
                    });
                    return t;
                });
            }
        };
        c.forEach(function(e) {
            h.prototype[e] = function t() {
                var r = this._baseState;
                throw new Error(e + " not implemented for encoding: " + r.enc);
            };
        });
        f.forEach(function(e) {
            h.prototype[e] = function t() {
                var r = this._baseState;
                var i = Array.prototype.slice.call(arguments);
                s(r.tag === null);
                r.tag = e;
                this._useArgs(i);
                return this;
            };
        });
        h.prototype.use = function e(t) {
            s(t);
            var r = this._baseState;
            s(r.use === null);
            r.use = t;
            return this;
        };
        h.prototype.optional = function e() {
            var t = this._baseState;
            t.optional = true;
            return this;
        };
        h.prototype.def = function e(t) {
            var r = this._baseState;
            s(r["default"] === null);
            r["default"] = t;
            r.optional = true;
            return this;
        };
        h.prototype.explicit = function e(t) {
            var r = this._baseState;
            s(r.explicit === null && r.implicit === null);
            r.explicit = t;
            return this;
        };
        h.prototype.implicit = function e(t) {
            var r = this._baseState;
            s(r.explicit === null && r.implicit === null);
            r.implicit = t;
            return this;
        };
        h.prototype.obj = function e() {
            var t = this._baseState;
            var r = Array.prototype.slice.call(arguments);
            t.obj = true;
            if (r.length !== 0) this._useArgs(r);
            return this;
        };
        h.prototype.key = function e(t) {
            var r = this._baseState;
            s(r.key === null);
            r.key = t;
            return this;
        };
        h.prototype.any = function e() {
            var t = this._baseState;
            t.any = true;
            return this;
        };
        h.prototype.choice = function e(t) {
            var r = this._baseState;
            s(r.choice === null);
            r.choice = t;
            this._useArgs(Object.keys(t).map(function(e) {
                return t[e];
            }));
            return this;
        };
        h.prototype.contains = function e(t) {
            var r = this._baseState;
            s(r.use === null);
            r.contains = t;
            return this;
        };
        h.prototype._decode = function e(t, r) {
            var i = this._baseState;
            if (i.parent === null) return t.wrapResult(i.children[0]._decode(t, r));
            var n = i["default"];
            var s = true;
            var f = null;
            if (i.key !== null) f = t.enterKey(i.key);
            if (i.optional) {
                var o = null;
                if (i.explicit !== null) o = i.explicit; else if (i.implicit !== null) o = i.implicit; else if (i.tag !== null) o = i.tag;
                if (o === null && !i.any) {
                    var c = t.save();
                    try {
                        if (i.choice === null) this._decodeGeneric(i.tag, t, r); else this._decodeChoice(t, r);
                        s = true;
                    } catch (e) {
                        s = false;
                    }
                    t.restore(c);
                } else {
                    s = this._peekTag(t, o, i.any);
                    if (t.isError(s)) return s;
                }
            }
            var h;
            if (i.obj && s) h = t.enterObject();
            if (s) {
                if (i.explicit !== null) {
                    var u = this._decodeTag(t, i.explicit);
                    if (t.isError(u)) return u;
                    t = u;
                }
                var d = t.offset;
                if (i.use === null && i.choice === null) {
                    if (i.any) var c = t.save();
                    var l = this._decodeTag(t, i.implicit !== null ? i.implicit : i.tag, i.any);
                    if (t.isError(l)) return l;
                    if (i.any) n = t.raw(c); else t = l;
                }
                if (r && r.track && i.tag !== null) r.track(t.path(), d, t.length, "tagged");
                if (r && r.track && i.tag !== null) r.track(t.path(), t.offset, t.length, "content");
                if (i.any) n = n; else if (i.choice === null) n = this._decodeGeneric(i.tag, t, r); else n = this._decodeChoice(t, r);
                if (t.isError(n)) return n;
                if (!i.any && i.choice === null && i.children !== null) {
                    i.children.forEach(function e(i) {
                        i._decode(t, r);
                    });
                }
                if (i.contains && (i.tag === "octstr" || i.tag === "bitstr")) {
                    var p = new a(n);
                    n = this._getUse(i.contains, t._reporterState.obj)._decode(p, r);
                }
            }
            if (i.obj && s) n = t.leaveObject(h);
            if (i.key !== null && (n !== null || s === true)) t.leaveKey(f, i.key, n); else if (f !== null) t.exitKey(f);
            return n;
        };
        h.prototype._decodeGeneric = function e(t, r, i) {
            var n = this._baseState;
            if (t === "seq" || t === "set") return null;
            if (t === "seqof" || t === "setof") return this._decodeList(r, t, n.args[0], i); else if (/str$/.test(t)) return this._decodeStr(r, t, i); else if (t === "objid" && n.args) return this._decodeObjid(r, n.args[0], n.args[1], i); else if (t === "objid") return this._decodeObjid(r, null, null, i); else if (t === "gentime" || t === "utctime") return this._decodeTime(r, t, i); else if (t === "null_") return this._decodeNull(r, i); else if (t === "bool") return this._decodeBool(r, i); else if (t === "objDesc") return this._decodeStr(r, t, i); else if (t === "int" || t === "enum") return this._decodeInt(r, n.args && n.args[0], i);
            if (n.use !== null) {
                return this._getUse(n.use, r._reporterState.obj)._decode(r, i);
            } else {
                return r.error("unknown tag: " + t);
            }
        };
        h.prototype._getUse = function e(t, r) {
            var i = this._baseState;
            i.useDecoder = this._use(t, r);
            s(i.useDecoder._baseState.parent === null);
            i.useDecoder = i.useDecoder._baseState.children[0];
            if (i.implicit !== i.useDecoder._baseState.implicit) {
                i.useDecoder = i.useDecoder.clone();
                i.useDecoder._baseState.implicit = i.implicit;
            }
            return i.useDecoder;
        };
        h.prototype._decodeChoice = function e(t, r) {
            var i = this._baseState;
            var n = null;
            var a = false;
            Object.keys(i.choice).some(function(e) {
                var s = t.save();
                var f = i.choice[e];
                try {
                    var o = f._decode(t, r);
                    if (t.isError(o)) return false;
                    n = {
                        type: e,
                        value: o
                    };
                    a = true;
                } catch (e) {
                    t.restore(s);
                    return false;
                }
                return true;
            }, this);
            if (!a) return t.error("Choice not matched");
            return n;
        };
        h.prototype._createEncoderBuffer = function e(t) {
            return new n(t, this.reporter);
        };
        h.prototype._encode = function e(t, r, i) {
            var n = this._baseState;
            if (n["default"] !== null && n["default"] === t) return;
            var a = this._encodeValue(t, r, i);
            if (a === undefined) return;
            if (this._skipDefault(a, r, i)) return;
            return a;
        };
        h.prototype._encodeValue = function e(t, r, n) {
            var a = this._baseState;
            if (a.parent === null) return a.children[0]._encode(t, r || new i());
            var s = null;
            this.reporter = r;
            if (a.optional && t === undefined) {
                if (a["default"] !== null) t = a["default"]; else return;
            }
            var f = null;
            var o = false;
            if (a.any) {
                s = this._createEncoderBuffer(t);
            } else if (a.choice) {
                s = this._encodeChoice(t, r);
            } else if (a.contains) {
                f = this._getUse(a.contains, n)._encode(t, r);
                o = true;
            } else if (a.children) {
                f = a.children.map(function(e) {
                    if (e._baseState.tag === "null_") return e._encode(null, r, t);
                    if (e._baseState.key === null) return r.error("Child should have a key");
                    var i = r.enterKey(e._baseState.key);
                    if (typeof t !== "object") return r.error("Child expected, but input is not object");
                    var n = e._encode(t[e._baseState.key], r, t);
                    r.leaveKey(i);
                    return n;
                }, this).filter(function(e) {
                    return e;
                });
                f = this._createEncoderBuffer(f);
            } else {
                if (a.tag === "seqof" || a.tag === "setof") {
                    if (!(a.args && a.args.length === 1)) return r.error("Too many args for : " + a.tag);
                    if (!Array.isArray(t)) return r.error("seqof/setof, but data is not Array");
                    var c = this.clone();
                    c._baseState.implicit = null;
                    f = this._createEncoderBuffer(t.map(function(e) {
                        var i = this._baseState;
                        return this._getUse(i.args[0], t)._encode(e, r);
                    }, c));
                } else if (a.use !== null) {
                    s = this._getUse(a.use, n)._encode(t, r);
                } else {
                    f = this._encodePrimitive(a.tag, t);
                    o = true;
                }
            }
            var s;
            if (!a.any && a.choice === null) {
                var h = a.implicit !== null ? a.implicit : a.tag;
                var u = a.implicit === null ? "universal" : "context";
                if (h === null) {
                    if (a.use === null) r.error("Tag could be ommited only for .use()");
                } else {
                    if (a.use === null) s = this._encodeComposite(h, o, u, f);
                }
            }
            if (a.explicit !== null) s = this._encodeComposite(a.explicit, false, "context", s);
            return s;
        };
        h.prototype._encodeChoice = function e(t, r) {
            var i = this._baseState;
            var n = i.choice[t.type];
            if (!n) {
                s(false, t.type + " not found in " + JSON.stringify(Object.keys(i.choice)));
            }
            return n._encode(t.value, r);
        };
        h.prototype._encodePrimitive = function e(t, r) {
            var i = this._baseState;
            if (/str$/.test(t)) return this._encodeStr(r, t); else if (t === "objid" && i.args) return this._encodeObjid(r, i.reverseArgs[0], i.args[1]); else if (t === "objid") return this._encodeObjid(r, null, null); else if (t === "gentime" || t === "utctime") return this._encodeTime(r, t); else if (t === "null_") return this._encodeNull(); else if (t === "int" || t === "enum") return this._encodeInt(r, i.args && i.reverseArgs[0]); else if (t === "bool") return this._encodeBool(r); else if (t === "objDesc") return this._encodeStr(r, t); else throw new Error("Unsupported tag: " + t);
        };
        h.prototype._isNumstr = function e(t) {
            return /^[0-9 ]*$/.test(t);
        };
        h.prototype._isPrintstr = function e(t) {
            return /^[A-Za-z0-9 '\(\)\+,\-\.\/:=\?]*$/.test(t);
        };
    }, {
        "../base": 20,
        "minimalistic-assert": 119
    } ],
    22: [ function(e, t, r) {
        var i = e("inherits");
        function n(e) {
            this._reporterState = {
                obj: null,
                path: [],
                options: e || {},
                errors: []
            };
        }
        r.Reporter = n;
        n.prototype.isError = function e(t) {
            return t instanceof a;
        };
        n.prototype.save = function e() {
            var t = this._reporterState;
            return {
                obj: t.obj,
                pathLen: t.path.length
            };
        };
        n.prototype.restore = function e(t) {
            var r = this._reporterState;
            r.obj = t.obj;
            r.path = r.path.slice(0, t.pathLen);
        };
        n.prototype.enterKey = function e(t) {
            return this._reporterState.path.push(t);
        };
        n.prototype.exitKey = function e(t) {
            var r = this._reporterState;
            r.path = r.path.slice(0, t - 1);
        };
        n.prototype.leaveKey = function e(t, r, i) {
            var n = this._reporterState;
            this.exitKey(t);
            if (n.obj !== null) n.obj[r] = i;
        };
        n.prototype.path = function e() {
            return this._reporterState.path.join("/");
        };
        n.prototype.enterObject = function e() {
            var t = this._reporterState;
            var r = t.obj;
            t.obj = {};
            return r;
        };
        n.prototype.leaveObject = function e(t) {
            var r = this._reporterState;
            var i = r.obj;
            r.obj = t;
            return i;
        };
        n.prototype.error = function e(t) {
            var r;
            var i = this._reporterState;
            var n = t instanceof a;
            if (n) {
                r = t;
            } else {
                r = new a(i.path.map(function(e) {
                    return "[" + JSON.stringify(e) + "]";
                }).join(""), t.message || t, t.stack);
            }
            if (!i.options.partial) throw r;
            if (!n) i.errors.push(r);
            return r;
        };
        n.prototype.wrapResult = function e(t) {
            var r = this._reporterState;
            if (!r.options.partial) return t;
            return {
                result: this.isError(t) ? null : t,
                errors: r.errors
            };
        };
        function a(e, t) {
            this.path = e;
            this.rethrow(t);
        }
        i(a, Error);
        a.prototype.rethrow = function e(t) {
            this.message = t + " at: " + (this.path || "(shallow)");
            if (Error.captureStackTrace) Error.captureStackTrace(this, a);
            if (!this.stack) {
                try {
                    throw new Error(this.message);
                } catch (e) {
                    this.stack = e.stack;
                }
            }
            return this;
        };
    }, {
        inherits: 115
    } ],
    23: [ function(e, t, r) {
        var i = e("../constants");
        r.tagClass = {
            0: "universal",
            1: "application",
            2: "context",
            3: "private"
        };
        r.tagClassByName = i._reverse(r.tagClass);
        r.tag = {
            0: "end",
            1: "bool",
            2: "int",
            3: "bitstr",
            4: "octstr",
            5: "null_",
            6: "objid",
            7: "objDesc",
            8: "external",
            9: "real",
            10: "enum",
            11: "embed",
            12: "utf8str",
            13: "relativeOid",
            16: "seq",
            17: "set",
            18: "numstr",
            19: "printstr",
            20: "t61str",
            21: "videostr",
            22: "ia5str",
            23: "utctime",
            24: "gentime",
            25: "graphstr",
            26: "iso646str",
            27: "genstr",
            28: "unistr",
            29: "charstr",
            30: "bmpstr"
        };
        r.tagByName = i._reverse(r.tag);
    }, {
        "../constants": 24
    } ],
    24: [ function(e, t, r) {
        var i = r;
        i._reverse = function e(t) {
            var r = {};
            Object.keys(t).forEach(function(e) {
                if ((e | 0) == e) e = e | 0;
                var i = t[e];
                r[i] = e;
            });
            return r;
        };
        i.der = e("./der");
    }, {
        "./der": 23
    } ],
    25: [ function(e, t, r) {
        var i = e("inherits");
        var n = e("../../asn1");
        var a = n.base;
        var s = n.bignum;
        var f = n.constants.der;
        function o(e) {
            this.enc = "der";
            this.name = e.name;
            this.entity = e;
            this.tree = new c();
            this.tree._init(e.body);
        }
        t.exports = o;
        o.prototype.decode = function e(t, r) {
            if (!(t instanceof a.DecoderBuffer)) t = new a.DecoderBuffer(t, r);
            return this.tree._decode(t, r);
        };
        function c(e) {
            a.Node.call(this, "der", e);
        }
        i(c, a.Node);
        c.prototype._peekTag = function e(t, r, i) {
            if (t.isEmpty()) return false;
            var n = t.save();
            var a = h(t, 'Failed to peek tag: "' + r + '"');
            if (t.isError(a)) return a;
            t.restore(n);
            return a.tag === r || a.tagStr === r || a.tagStr + "of" === r || i;
        };
        c.prototype._decodeTag = function e(t, r, i) {
            var n = h(t, 'Failed to decode tag of "' + r + '"');
            if (t.isError(n)) return n;
            var a = u(t, n.primitive, 'Failed to get length of "' + r + '"');
            if (t.isError(a)) return a;
            if (!i && n.tag !== r && n.tagStr !== r && n.tagStr + "of" !== r) {
                return t.error('Failed to match tag: "' + r + '"');
            }
            if (n.primitive || a !== null) return t.skip(a, 'Failed to match body of: "' + r + '"');
            var s = t.save();
            var f = this._skipUntilEnd(t, 'Failed to skip indefinite length body: "' + this.tag + '"');
            if (t.isError(f)) return f;
            a = t.offset - s.offset;
            t.restore(s);
            return t.skip(a, 'Failed to match body of: "' + r + '"');
        };
        c.prototype._skipUntilEnd = function e(t, r) {
            while (true) {
                var i = h(t, r);
                if (t.isError(i)) return i;
                var n = u(t, i.primitive, r);
                if (t.isError(n)) return n;
                var a;
                if (i.primitive || n !== null) a = t.skip(n); else a = this._skipUntilEnd(t, r);
                if (t.isError(a)) return a;
                if (i.tagStr === "end") break;
            }
        };
        c.prototype._decodeList = function e(t, r, i, n) {
            var a = [];
            while (!t.isEmpty()) {
                var s = this._peekTag(t, "end");
                if (t.isError(s)) return s;
                var f = i.decode(t, "der", n);
                if (t.isError(f) && s) break;
                a.push(f);
            }
            return a;
        };
        c.prototype._decodeStr = function e(t, r) {
            if (r === "bitstr") {
                var i = t.readUInt8();
                if (t.isError(i)) return i;
                return {
                    unused: i,
                    data: t.raw()
                };
            } else if (r === "bmpstr") {
                var n = t.raw();
                if (n.length % 2 === 1) return t.error("Decoding of string type: bmpstr length mismatch");
                var a = "";
                for (var s = 0; s < n.length / 2; s++) {
                    a += String.fromCharCode(n.readUInt16BE(s * 2));
                }
                return a;
            } else if (r === "numstr") {
                var f = t.raw().toString("ascii");
                if (!this._isNumstr(f)) {
                    return t.error("Decoding of string type: " + "numstr unsupported characters");
                }
                return f;
            } else if (r === "octstr") {
                return t.raw();
            } else if (r === "objDesc") {
                return t.raw();
            } else if (r === "printstr") {
                var o = t.raw().toString("ascii");
                if (!this._isPrintstr(o)) {
                    return t.error("Decoding of string type: " + "printstr unsupported characters");
                }
                return o;
            } else if (/str$/.test(r)) {
                return t.raw().toString();
            } else {
                return t.error("Decoding of string type: " + r + " unsupported");
            }
        };
        c.prototype._decodeObjid = function e(t, r, i) {
            var n;
            var a = [];
            var s = 0;
            while (!t.isEmpty()) {
                var f = t.readUInt8();
                s <<= 7;
                s |= f & 127;
                if ((f & 128) === 0) {
                    a.push(s);
                    s = 0;
                }
            }
            if (f & 128) a.push(s);
            var o = a[0] / 40 | 0;
            var c = a[0] % 40;
            if (i) n = a; else n = [ o, c ].concat(a.slice(1));
            if (r) {
                var h = r[n.join(" ")];
                if (h === undefined) h = r[n.join(".")];
                if (h !== undefined) n = h;
            }
            return n;
        };
        c.prototype._decodeTime = function e(t, r) {
            var i = t.raw().toString();
            if (r === "gentime") {
                var n = i.slice(0, 4) | 0;
                var a = i.slice(4, 6) | 0;
                var s = i.slice(6, 8) | 0;
                var f = i.slice(8, 10) | 0;
                var o = i.slice(10, 12) | 0;
                var c = i.slice(12, 14) | 0;
            } else if (r === "utctime") {
                var n = i.slice(0, 2) | 0;
                var a = i.slice(2, 4) | 0;
                var s = i.slice(4, 6) | 0;
                var f = i.slice(6, 8) | 0;
                var o = i.slice(8, 10) | 0;
                var c = i.slice(10, 12) | 0;
                if (n < 70) n = 2e3 + n; else n = 1900 + n;
            } else {
                return t.error("Decoding " + r + " time is not supported yet");
            }
            return Date.UTC(n, a - 1, s, f, o, c, 0);
        };
        c.prototype._decodeNull = function e(t) {
            return null;
        };
        c.prototype._decodeBool = function e(t) {
            var r = t.readUInt8();
            if (t.isError(r)) return r; else return r !== 0;
        };
        c.prototype._decodeInt = function e(t, r) {
            var i = t.raw();
            var n = new s(i);
            if (r) n = r[n.toString(10)] || n;
            return n;
        };
        c.prototype._use = function e(t, r) {
            if (typeof t === "function") t = t(r);
            return t._getDecoder("der").tree;
        };
        function h(e, t) {
            var r = e.readUInt8(t);
            if (e.isError(r)) return r;
            var i = f.tagClass[r >> 6];
            var n = (r & 32) === 0;
            if ((r & 31) === 31) {
                var a = r;
                r = 0;
                while ((a & 128) === 128) {
                    a = e.readUInt8(t);
                    if (e.isError(a)) return a;
                    r <<= 7;
                    r |= a & 127;
                }
            } else {
                r &= 31;
            }
            var s = f.tag[r];
            return {
                cls: i,
                primitive: n,
                tag: r,
                tagStr: s
            };
        }
        function u(e, t, r) {
            var i = e.readUInt8(r);
            if (e.isError(i)) return i;
            if (!t && i === 128) return null;
            if ((i & 128) === 0) {
                return i;
            }
            var n = i & 127;
            if (n > 4) return e.error("length octect is too long");
            i = 0;
            for (var a = 0; a < n; a++) {
                i <<= 8;
                var s = e.readUInt8(r);
                if (e.isError(s)) return s;
                i |= s;
            }
            return i;
        }
    }, {
        "../../asn1": 17,
        inherits: 115
    } ],
    26: [ function(e, t, r) {
        var i = r;
        i.der = e("./der");
        i.pem = e("./pem");
    }, {
        "./der": 25,
        "./pem": 27
    } ],
    27: [ function(e, t, r) {
        var i = e("inherits");
        var n = e("buffer").Buffer;
        var a = e("./der");
        function s(e) {
            a.call(this, e);
            this.enc = "pem";
        }
        i(s, a);
        t.exports = s;
        s.prototype.decode = function e(t, r) {
            var i = t.toString().split(/[\r\n]+/g);
            var s = r.label.toUpperCase();
            var f = /^-----(BEGIN|END) ([^-]+)-----$/;
            var o = -1;
            var c = -1;
            for (var h = 0; h < i.length; h++) {
                var u = i[h].match(f);
                if (u === null) continue;
                if (u[2] !== s) continue;
                if (o === -1) {
                    if (u[1] !== "BEGIN") break;
                    o = h;
                } else {
                    if (u[1] !== "END") break;
                    c = h;
                    break;
                }
            }
            if (o === -1 || c === -1) throw new Error("PEM section not found for: " + s);
            var d = i.slice(o + 1, c).join("");
            d.replace(/[^a-z0-9\+\/=]+/gi, "");
            var l = new n(d, "base64");
            return a.prototype.decode.call(this, l, r);
        };
    }, {
        "./der": 25,
        buffer: 61,
        inherits: 115
    } ],
    28: [ function(e, t, r) {
        var i = e("inherits");
        var n = e("buffer").Buffer;
        var a = e("../../asn1");
        var s = a.base;
        var f = a.constants.der;
        function o(e) {
            this.enc = "der";
            this.name = e.name;
            this.entity = e;
            this.tree = new c();
            this.tree._init(e.body);
        }
        t.exports = o;
        o.prototype.encode = function e(t, r) {
            return this.tree._encode(t, r).join();
        };
        function c(e) {
            s.Node.call(this, "der", e);
        }
        i(c, s.Node);
        c.prototype._encodeComposite = function e(t, r, i, a) {
            var s = u(t, r, i, this.reporter);
            if (a.length < 128) {
                var f = new n(2);
                f[0] = s;
                f[1] = a.length;
                return this._createEncoderBuffer([ f, a ]);
            }
            var o = 1;
            for (var c = a.length; c >= 256; c >>= 8) o++;
            var f = new n(1 + 1 + o);
            f[0] = s;
            f[1] = 128 | o;
            for (var c = 1 + o, h = a.length; h > 0; c--, h >>= 8) f[c] = h & 255;
            return this._createEncoderBuffer([ f, a ]);
        };
        c.prototype._encodeStr = function e(t, r) {
            if (r === "bitstr") {
                return this._createEncoderBuffer([ t.unused | 0, t.data ]);
            } else if (r === "bmpstr") {
                var i = new n(t.length * 2);
                for (var a = 0; a < t.length; a++) {
                    i.writeUInt16BE(t.charCodeAt(a), a * 2);
                }
                return this._createEncoderBuffer(i);
            } else if (r === "numstr") {
                if (!this._isNumstr(t)) {
                    return this.reporter.error("Encoding of string type: numstr supports " + "only digits and space");
                }
                return this._createEncoderBuffer(t);
            } else if (r === "printstr") {
                if (!this._isPrintstr(t)) {
                    return this.reporter.error("Encoding of string type: printstr supports " + "only latin upper and lower case letters, " + "digits, space, apostrophe, left and rigth " + "parenthesis, plus sign, comma, hyphen, " + "dot, slash, colon, equal sign, " + "question mark");
                }
                return this._createEncoderBuffer(t);
            } else if (/str$/.test(r)) {
                return this._createEncoderBuffer(t);
            } else if (r === "objDesc") {
                return this._createEncoderBuffer(t);
            } else {
                return this.reporter.error("Encoding of string type: " + r + " unsupported");
            }
        };
        c.prototype._encodeObjid = function e(t, r, i) {
            if (typeof t === "string") {
                if (!r) return this.reporter.error("string objid given, but no values map found");
                if (!r.hasOwnProperty(t)) return this.reporter.error("objid not found in values map");
                t = r[t].split(/[\s\.]+/g);
                for (var a = 0; a < t.length; a++) t[a] |= 0;
            } else if (Array.isArray(t)) {
                t = t.slice();
                for (var a = 0; a < t.length; a++) t[a] |= 0;
            }
            if (!Array.isArray(t)) {
                return this.reporter.error("objid() should be either array or string, " + "got: " + JSON.stringify(t));
            }
            if (!i) {
                if (t[1] >= 40) return this.reporter.error("Second objid identifier OOB");
                t.splice(0, 2, t[0] * 40 + t[1]);
            }
            var s = 0;
            for (var a = 0; a < t.length; a++) {
                var f = t[a];
                for (s++; f >= 128; f >>= 7) s++;
            }
            var o = new n(s);
            var c = o.length - 1;
            for (var a = t.length - 1; a >= 0; a--) {
                var f = t[a];
                o[c--] = f & 127;
                while ((f >>= 7) > 0) o[c--] = 128 | f & 127;
            }
            return this._createEncoderBuffer(o);
        };
        function h(e) {
            if (e < 10) return "0" + e; else return e;
        }
        c.prototype._encodeTime = function e(t, r) {
            var i;
            var n = new Date(t);
            if (r === "gentime") {
                i = [ h(n.getFullYear()), h(n.getUTCMonth() + 1), h(n.getUTCDate()), h(n.getUTCHours()), h(n.getUTCMinutes()), h(n.getUTCSeconds()), "Z" ].join("");
            } else if (r === "utctime") {
                i = [ h(n.getFullYear() % 100), h(n.getUTCMonth() + 1), h(n.getUTCDate()), h(n.getUTCHours()), h(n.getUTCMinutes()), h(n.getUTCSeconds()), "Z" ].join("");
            } else {
                this.reporter.error("Encoding " + r + " time is not supported yet");
            }
            return this._encodeStr(i, "octstr");
        };
        c.prototype._encodeNull = function e() {
            return this._createEncoderBuffer("");
        };
        c.prototype._encodeInt = function e(t, r) {
            if (typeof t === "string") {
                if (!r) return this.reporter.error("String int or enum given, but no values map");
                if (!r.hasOwnProperty(t)) {
                    return this.reporter.error("Values map doesn't contain: " + JSON.stringify(t));
                }
                t = r[t];
            }
            if (typeof t !== "number" && !n.isBuffer(t)) {
                var i = t.toArray();
                if (!t.sign && i[0] & 128) {
                    i.unshift(0);
                }
                t = new n(i);
            }
            if (n.isBuffer(t)) {
                var a = t.length;
                if (t.length === 0) a++;
                var s = new n(a);
                t.copy(s);
                if (t.length === 0) s[0] = 0;
                return this._createEncoderBuffer(s);
            }
            if (t < 128) return this._createEncoderBuffer(t);
            if (t < 256) return this._createEncoderBuffer([ 0, t ]);
            var a = 1;
            for (var f = t; f >= 256; f >>= 8) a++;
            var s = new Array(a);
            for (var f = s.length - 1; f >= 0; f--) {
                s[f] = t & 255;
                t >>= 8;
            }
            if (s[0] & 128) {
                s.unshift(0);
            }
            return this._createEncoderBuffer(new n(s));
        };
        c.prototype._encodeBool = function e(t) {
            return this._createEncoderBuffer(t ? 255 : 0);
        };
        c.prototype._use = function e(t, r) {
            if (typeof t === "function") t = t(r);
            return t._getEncoder("der").tree;
        };
        c.prototype._skipDefault = function e(t, r, i) {
            var n = this._baseState;
            var a;
            if (n["default"] === null) return false;
            var s = t.join();
            if (n.defaultBuffer === undefined) n.defaultBuffer = this._encodeValue(n["default"], r, i).join();
            if (s.length !== n.defaultBuffer.length) return false;
            for (a = 0; a < s.length; a++) if (s[a] !== n.defaultBuffer[a]) return false;
            return true;
        };
        function u(e, t, r, i) {
            var n;
            if (e === "seqof") e = "seq"; else if (e === "setof") e = "set";
            if (f.tagByName.hasOwnProperty(e)) n = f.tagByName[e]; else if (typeof e === "number" && (e | 0) === e) n = e; else return i.error("Unknown tag: " + e);
            if (n >= 31) return i.error("Multi-octet tag encoding unsupported");
            if (!t) n |= 32;
            n |= f.tagClassByName[r || "universal"] << 6;
            return n;
        }
    }, {
        "../../asn1": 17,
        buffer: 61,
        inherits: 115
    } ],
    29: [ function(e, t, r) {
        var i = r;
        i.der = e("./der");
        i.pem = e("./pem");
    }, {
        "./der": 28,
        "./pem": 30
    } ],
    30: [ function(e, t, r) {
        var i = e("inherits");
        var n = e("./der");
        function a(e) {
            n.call(this, e);
            this.enc = "pem";
        }
        i(a, n);
        t.exports = a;
        a.prototype.encode = function e(t, r) {
            var i = n.prototype.encode.call(this, t);
            var a = i.toString("base64");
            var s = [ "-----BEGIN " + r.label + "-----" ];
            for (var f = 0; f < a.length; f += 64) s.push(a.slice(f, f + 64));
            s.push("-----END " + r.label + "-----");
            return s.join("\n");
        };
    }, {
        "./der": 28,
        inherits: 115
    } ],
    31: [ function(e, t, r) {
        "use strict";
        r.byteLength = h;
        r.toByteArray = u;
        r.fromByteArray = p;
        var i = [];
        var n = [];
        var a = typeof Uint8Array !== "undefined" ? Uint8Array : Array;
        var s = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        for (var f = 0, o = s.length; f < o; ++f) {
            i[f] = s[f];
            n[s.charCodeAt(f)] = f;
        }
        n["-".charCodeAt(0)] = 62;
        n["_".charCodeAt(0)] = 63;
        function c(e) {
            var t = e.length;
            if (t % 4 > 0) {
                throw new Error("Invalid string. Length must be a multiple of 4");
            }
            return e[t - 2] === "=" ? 2 : e[t - 1] === "=" ? 1 : 0;
        }
        function h(e) {
            return e.length * 3 / 4 - c(e);
        }
        function u(e) {
            var t, r, i, s, f;
            var o = e.length;
            s = c(e);
            f = new a(o * 3 / 4 - s);
            r = s > 0 ? o - 4 : o;
            var h = 0;
            for (t = 0; t < r; t += 4) {
                i = n[e.charCodeAt(t)] << 18 | n[e.charCodeAt(t + 1)] << 12 | n[e.charCodeAt(t + 2)] << 6 | n[e.charCodeAt(t + 3)];
                f[h++] = i >> 16 & 255;
                f[h++] = i >> 8 & 255;
                f[h++] = i & 255;
            }
            if (s === 2) {
                i = n[e.charCodeAt(t)] << 2 | n[e.charCodeAt(t + 1)] >> 4;
                f[h++] = i & 255;
            } else if (s === 1) {
                i = n[e.charCodeAt(t)] << 10 | n[e.charCodeAt(t + 1)] << 4 | n[e.charCodeAt(t + 2)] >> 2;
                f[h++] = i >> 8 & 255;
                f[h++] = i & 255;
            }
            return f;
        }
        function d(e) {
            return i[e >> 18 & 63] + i[e >> 12 & 63] + i[e >> 6 & 63] + i[e & 63];
        }
        function l(e, t, r) {
            var i;
            var n = [];
            for (var a = t; a < r; a += 3) {
                i = (e[a] << 16) + (e[a + 1] << 8) + e[a + 2];
                n.push(d(i));
            }
            return n.join("");
        }
        function p(e) {
            var t;
            var r = e.length;
            var n = r % 3;
            var a = "";
            var s = [];
            var f = 16383;
            for (var o = 0, c = r - n; o < c; o += f) {
                s.push(l(e, o, o + f > c ? c : o + f));
            }
            if (n === 1) {
                t = e[r - 1];
                a += i[t >> 2];
                a += i[t << 4 & 63];
                a += "==";
            } else if (n === 2) {
                t = (e[r - 2] << 8) + e[r - 1];
                a += i[t >> 10];
                a += i[t >> 4 & 63];
                a += i[t << 2 & 63];
                a += "=";
            }
            s.push(a);
            return s.join("");
        }
    }, {} ],
    32: [ function(e, t, r) {
        (function(t, r) {
            "use strict";
            function i(e, t) {
                if (!e) throw new Error(t || "Assertion failed");
            }
            function n(e, t) {
                e.super_ = t;
                var r = function() {};
                r.prototype = t.prototype;
                e.prototype = new r();
                e.prototype.constructor = e;
            }
            function a(e, t, r) {
                if (a.isBN(e)) {
                    return e;
                }
                this.negative = 0;
                this.words = null;
                this.length = 0;
                this.red = null;
                if (e !== null) {
                    if (t === "le" || t === "be") {
                        r = t;
                        t = 10;
                    }
                    this._init(e || 0, t || 10, r || "be");
                }
            }
            if (typeof t === "object") {
                t.exports = a;
            } else {
                r.BN = a;
            }
            a.BN = a;
            a.wordSize = 26;
            var s;
            try {
                s = e("buf" + "fer").Buffer;
            } catch (e) {}
            a.isBN = function e(t) {
                if (t instanceof a) {
                    return true;
                }
                return t !== null && typeof t === "object" && t.constructor.wordSize === a.wordSize && Array.isArray(t.words);
            };
            a.max = function e(t, r) {
                if (t.cmp(r) > 0) return t;
                return r;
            };
            a.min = function e(t, r) {
                if (t.cmp(r) < 0) return t;
                return r;
            };
            a.prototype._init = function e(t, r, n) {
                if (typeof t === "number") {
                    return this._initNumber(t, r, n);
                }
                if (typeof t === "object") {
                    return this._initArray(t, r, n);
                }
                if (r === "hex") {
                    r = 16;
                }
                i(r === (r | 0) && r >= 2 && r <= 36);
                t = t.toString().replace(/\s+/g, "");
                var a = 0;
                if (t[0] === "-") {
                    a++;
                }
                if (r === 16) {
                    this._parseHex(t, a);
                } else {
                    this._parseBase(t, r, a);
                }
                if (t[0] === "-") {
                    this.negative = 1;
                }
                this.strip();
                if (n !== "le") return;
                this._initArray(this.toArray(), r, n);
            };
            a.prototype._initNumber = function e(t, r, n) {
                if (t < 0) {
                    this.negative = 1;
                    t = -t;
                }
                if (t < 67108864) {
                    this.words = [ t & 67108863 ];
                    this.length = 1;
                } else if (t < 4503599627370496) {
                    this.words = [ t & 67108863, t / 67108864 & 67108863 ];
                    this.length = 2;
                } else {
                    i(t < 9007199254740992);
                    this.words = [ t & 67108863, t / 67108864 & 67108863, 1 ];
                    this.length = 3;
                }
                if (n !== "le") return;
                this._initArray(this.toArray(), r, n);
            };
            a.prototype._initArray = function e(t, r, n) {
                i(typeof t.length === "number");
                if (t.length <= 0) {
                    this.words = [ 0 ];
                    this.length = 1;
                    return this;
                }
                this.length = Math.ceil(t.length / 3);
                this.words = new Array(this.length);
                for (var a = 0; a < this.length; a++) {
                    this.words[a] = 0;
                }
                var s, f;
                var o = 0;
                if (n === "be") {
                    for (a = t.length - 1, s = 0; a >= 0; a -= 3) {
                        f = t[a] | t[a - 1] << 8 | t[a - 2] << 16;
                        this.words[s] |= f << o & 67108863;
                        this.words[s + 1] = f >>> 26 - o & 67108863;
                        o += 24;
                        if (o >= 26) {
                            o -= 26;
                            s++;
                        }
                    }
                } else if (n === "le") {
                    for (a = 0, s = 0; a < t.length; a += 3) {
                        f = t[a] | t[a + 1] << 8 | t[a + 2] << 16;
                        this.words[s] |= f << o & 67108863;
                        this.words[s + 1] = f >>> 26 - o & 67108863;
                        o += 24;
                        if (o >= 26) {
                            o -= 26;
                            s++;
                        }
                    }
                }
                return this.strip();
            };
            function f(e, t, r) {
                var i = 0;
                var n = Math.min(e.length, r);
                for (var a = t; a < n; a++) {
                    var s = e.charCodeAt(a) - 48;
                    i <<= 4;
                    if (s >= 49 && s <= 54) {
                        i |= s - 49 + 10;
                    } else if (s >= 17 && s <= 22) {
                        i |= s - 17 + 10;
                    } else {
                        i |= s & 15;
                    }
                }
                return i;
            }
            a.prototype._parseHex = function e(t, r) {
                this.length = Math.ceil((t.length - r) / 6);
                this.words = new Array(this.length);
                for (var i = 0; i < this.length; i++) {
                    this.words[i] = 0;
                }
                var n, a;
                var s = 0;
                for (i = t.length - 6, n = 0; i >= r; i -= 6) {
                    a = f(t, i, i + 6);
                    this.words[n] |= a << s & 67108863;
                    this.words[n + 1] |= a >>> 26 - s & 4194303;
                    s += 24;
                    if (s >= 26) {
                        s -= 26;
                        n++;
                    }
                }
                if (i + 6 !== r) {
                    a = f(t, r, i + 6);
                    this.words[n] |= a << s & 67108863;
                    this.words[n + 1] |= a >>> 26 - s & 4194303;
                }
                this.strip();
            };
            function o(e, t, r, i) {
                var n = 0;
                var a = Math.min(e.length, r);
                for (var s = t; s < a; s++) {
                    var f = e.charCodeAt(s) - 48;
                    n *= i;
                    if (f >= 49) {
                        n += f - 49 + 10;
                    } else if (f >= 17) {
                        n += f - 17 + 10;
                    } else {
                        n += f;
                    }
                }
                return n;
            }
            a.prototype._parseBase = function e(t, r, i) {
                this.words = [ 0 ];
                this.length = 1;
                for (var n = 0, a = 1; a <= 67108863; a *= r) {
                    n++;
                }
                n--;
                a = a / r | 0;
                var s = t.length - i;
                var f = s % n;
                var c = Math.min(s, s - f) + i;
                var h = 0;
                for (var u = i; u < c; u += n) {
                    h = o(t, u, u + n, r);
                    this.imuln(a);
                    if (this.words[0] + h < 67108864) {
                        this.words[0] += h;
                    } else {
                        this._iaddn(h);
                    }
                }
                if (f !== 0) {
                    var d = 1;
                    h = o(t, u, t.length, r);
                    for (u = 0; u < f; u++) {
                        d *= r;
                    }
                    this.imuln(d);
                    if (this.words[0] + h < 67108864) {
                        this.words[0] += h;
                    } else {
                        this._iaddn(h);
                    }
                }
            };
            a.prototype.copy = function e(t) {
                t.words = new Array(this.length);
                for (var r = 0; r < this.length; r++) {
                    t.words[r] = this.words[r];
                }
                t.length = this.length;
                t.negative = this.negative;
                t.red = this.red;
            };
            a.prototype.clone = function e() {
                var t = new a(null);
                this.copy(t);
                return t;
            };
            a.prototype._expand = function e(t) {
                while (this.length < t) {
                    this.words[this.length++] = 0;
                }
                return this;
            };
            a.prototype.strip = function e() {
                while (this.length > 1 && this.words[this.length - 1] === 0) {
                    this.length--;
                }
                return this._normSign();
            };
            a.prototype._normSign = function e() {
                if (this.length === 1 && this.words[0] === 0) {
                    this.negative = 0;
                }
                return this;
            };
            a.prototype.inspect = function e() {
                return (this.red ? "<BN-R: " : "<BN: ") + this.toString(16) + ">";
            };
            var c = [ "", "0", "00", "000", "0000", "00000", "000000", "0000000", "00000000", "000000000", "0000000000", "00000000000", "000000000000", "0000000000000", "00000000000000", "000000000000000", "0000000000000000", "00000000000000000", "000000000000000000", "0000000000000000000", "00000000000000000000", "000000000000000000000", "0000000000000000000000", "00000000000000000000000", "000000000000000000000000", "0000000000000000000000000" ];
            var h = [ 0, 0, 25, 16, 12, 11, 10, 9, 8, 8, 7, 7, 7, 7, 6, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 ];
            var u = [ 0, 0, 33554432, 43046721, 16777216, 48828125, 60466176, 40353607, 16777216, 43046721, 1e7, 19487171, 35831808, 62748517, 7529536, 11390625, 16777216, 24137569, 34012224, 47045881, 64e6, 4084101, 5153632, 6436343, 7962624, 9765625, 11881376, 14348907, 17210368, 20511149, 243e5, 28629151, 33554432, 39135393, 45435424, 52521875, 60466176 ];
            a.prototype.toString = function e(t, r) {
                t = t || 10;
                r = r | 0 || 1;
                var n;
                if (t === 16 || t === "hex") {
                    n = "";
                    var a = 0;
                    var s = 0;
                    for (var f = 0; f < this.length; f++) {
                        var o = this.words[f];
                        var d = ((o << a | s) & 16777215).toString(16);
                        s = o >>> 24 - a & 16777215;
                        if (s !== 0 || f !== this.length - 1) {
                            n = c[6 - d.length] + d + n;
                        } else {
                            n = d + n;
                        }
                        a += 2;
                        if (a >= 26) {
                            a -= 26;
                            f--;
                        }
                    }
                    if (s !== 0) {
                        n = s.toString(16) + n;
                    }
                    while (n.length % r !== 0) {
                        n = "0" + n;
                    }
                    if (this.negative !== 0) {
                        n = "-" + n;
                    }
                    return n;
                }
                if (t === (t | 0) && t >= 2 && t <= 36) {
                    var l = h[t];
                    var p = u[t];
                    n = "";
                    var b = this.clone();
                    b.negative = 0;
                    while (!b.isZero()) {
                        var v = b.modn(p).toString(t);
                        b = b.idivn(p);
                        if (!b.isZero()) {
                            n = c[l - v.length] + v + n;
                        } else {
                            n = v + n;
                        }
                    }
                    if (this.isZero()) {
                        n = "0" + n;
                    }
                    while (n.length % r !== 0) {
                        n = "0" + n;
                    }
                    if (this.negative !== 0) {
                        n = "-" + n;
                    }
                    return n;
                }
                i(false, "Base should be between 2 and 36");
            };
            a.prototype.toNumber = function e() {
                var t = this.words[0];
                if (this.length === 2) {
                    t += this.words[1] * 67108864;
                } else if (this.length === 3 && this.words[2] === 1) {
                    t += 4503599627370496 + this.words[1] * 67108864;
                } else if (this.length > 2) {
                    i(false, "Number can only safely store up to 53 bits");
                }
                return this.negative !== 0 ? -t : t;
            };
            a.prototype.toJSON = function e() {
                return this.toString(16);
            };
            a.prototype.toBuffer = function e(t, r) {
                i(typeof s !== "undefined");
                return this.toArrayLike(s, t, r);
            };
            a.prototype.toArray = function e(t, r) {
                return this.toArrayLike(Array, t, r);
            };
            a.prototype.toArrayLike = function e(t, r, n) {
                var a = this.byteLength();
                var s = n || Math.max(1, a);
                i(a <= s, "byte array longer than desired length");
                i(s > 0, "Requested array length <= 0");
                this.strip();
                var f = r === "le";
                var o = new t(s);
                var c, h;
                var u = this.clone();
                if (!f) {
                    for (h = 0; h < s - a; h++) {
                        o[h] = 0;
                    }
                    for (h = 0; !u.isZero(); h++) {
                        c = u.andln(255);
                        u.iushrn(8);
                        o[s - h - 1] = c;
                    }
                } else {
                    for (h = 0; !u.isZero(); h++) {
                        c = u.andln(255);
                        u.iushrn(8);
                        o[h] = c;
                    }
                    for (;h < s; h++) {
                        o[h] = 0;
                    }
                }
                return o;
            };
            if (Math.clz32) {
                a.prototype._countBits = function e(t) {
                    return 32 - Math.clz32(t);
                };
            } else {
                a.prototype._countBits = function e(t) {
                    var r = t;
                    var i = 0;
                    if (r >= 4096) {
                        i += 13;
                        r >>>= 13;
                    }
                    if (r >= 64) {
                        i += 7;
                        r >>>= 7;
                    }
                    if (r >= 8) {
                        i += 4;
                        r >>>= 4;
                    }
                    if (r >= 2) {
                        i += 2;
                        r >>>= 2;
                    }
                    return i + r;
                };
            }
            a.prototype._zeroBits = function e(t) {
                if (t === 0) return 26;
                var r = t;
                var i = 0;
                if ((r & 8191) === 0) {
                    i += 13;
                    r >>>= 13;
                }
                if ((r & 127) === 0) {
                    i += 7;
                    r >>>= 7;
                }
                if ((r & 15) === 0) {
                    i += 4;
                    r >>>= 4;
                }
                if ((r & 3) === 0) {
                    i += 2;
                    r >>>= 2;
                }
                if ((r & 1) === 0) {
                    i++;
                }
                return i;
            };
            a.prototype.bitLength = function e() {
                var t = this.words[this.length - 1];
                var r = this._countBits(t);
                return (this.length - 1) * 26 + r;
            };
            function d(e) {
                var t = new Array(e.bitLength());
                for (var r = 0; r < t.length; r++) {
                    var i = r / 26 | 0;
                    var n = r % 26;
                    t[r] = (e.words[i] & 1 << n) >>> n;
                }
                return t;
            }
            a.prototype.zeroBits = function e() {
                if (this.isZero()) return 0;
                var t = 0;
                for (var r = 0; r < this.length; r++) {
                    var i = this._zeroBits(this.words[r]);
                    t += i;
                    if (i !== 26) break;
                }
                return t;
            };
            a.prototype.byteLength = function e() {
                return Math.ceil(this.bitLength() / 8);
            };
            a.prototype.toTwos = function e(t) {
                if (this.negative !== 0) {
                    return this.abs().inotn(t).iaddn(1);
                }
                return this.clone();
            };
            a.prototype.fromTwos = function e(t) {
                if (this.testn(t - 1)) {
                    return this.notn(t).iaddn(1).ineg();
                }
                return this.clone();
            };
            a.prototype.isNeg = function e() {
                return this.negative !== 0;
            };
            a.prototype.neg = function e() {
                return this.clone().ineg();
            };
            a.prototype.ineg = function e() {
                if (!this.isZero()) {
                    this.negative ^= 1;
                }
                return this;
            };
            a.prototype.iuor = function e(t) {
                while (this.length < t.length) {
                    this.words[this.length++] = 0;
                }
                for (var r = 0; r < t.length; r++) {
                    this.words[r] = this.words[r] | t.words[r];
                }
                return this.strip();
            };
            a.prototype.ior = function e(t) {
                i((this.negative | t.negative) === 0);
                return this.iuor(t);
            };
            a.prototype.or = function e(t) {
                if (this.length > t.length) return this.clone().ior(t);
                return t.clone().ior(this);
            };
            a.prototype.uor = function e(t) {
                if (this.length > t.length) return this.clone().iuor(t);
                return t.clone().iuor(this);
            };
            a.prototype.iuand = function e(t) {
                var r;
                if (this.length > t.length) {
                    r = t;
                } else {
                    r = this;
                }
                for (var i = 0; i < r.length; i++) {
                    this.words[i] = this.words[i] & t.words[i];
                }
                this.length = r.length;
                return this.strip();
            };
            a.prototype.iand = function e(t) {
                i((this.negative | t.negative) === 0);
                return this.iuand(t);
            };
            a.prototype.and = function e(t) {
                if (this.length > t.length) return this.clone().iand(t);
                return t.clone().iand(this);
            };
            a.prototype.uand = function e(t) {
                if (this.length > t.length) return this.clone().iuand(t);
                return t.clone().iuand(this);
            };
            a.prototype.iuxor = function e(t) {
                var r;
                var i;
                if (this.length > t.length) {
                    r = this;
                    i = t;
                } else {
                    r = t;
                    i = this;
                }
                for (var n = 0; n < i.length; n++) {
                    this.words[n] = r.words[n] ^ i.words[n];
                }
                if (this !== r) {
                    for (;n < r.length; n++) {
                        this.words[n] = r.words[n];
                    }
                }
                this.length = r.length;
                return this.strip();
            };
            a.prototype.ixor = function e(t) {
                i((this.negative | t.negative) === 0);
                return this.iuxor(t);
            };
            a.prototype.xor = function e(t) {
                if (this.length > t.length) return this.clone().ixor(t);
                return t.clone().ixor(this);
            };
            a.prototype.uxor = function e(t) {
                if (this.length > t.length) return this.clone().iuxor(t);
                return t.clone().iuxor(this);
            };
            a.prototype.inotn = function e(t) {
                i(typeof t === "number" && t >= 0);
                var r = Math.ceil(t / 26) | 0;
                var n = t % 26;
                this._expand(r);
                if (n > 0) {
                    r--;
                }
                for (var a = 0; a < r; a++) {
                    this.words[a] = ~this.words[a] & 67108863;
                }
                if (n > 0) {
                    this.words[a] = ~this.words[a] & 67108863 >> 26 - n;
                }
                return this.strip();
            };
            a.prototype.notn = function e(t) {
                return this.clone().inotn(t);
            };
            a.prototype.setn = function e(t, r) {
                i(typeof t === "number" && t >= 0);
                var n = t / 26 | 0;
                var a = t % 26;
                this._expand(n + 1);
                if (r) {
                    this.words[n] = this.words[n] | 1 << a;
                } else {
                    this.words[n] = this.words[n] & ~(1 << a);
                }
                return this.strip();
            };
            a.prototype.iadd = function e(t) {
                var r;
                if (this.negative !== 0 && t.negative === 0) {
                    this.negative = 0;
                    r = this.isub(t);
                    this.negative ^= 1;
                    return this._normSign();
                } else if (this.negative === 0 && t.negative !== 0) {
                    t.negative = 0;
                    r = this.isub(t);
                    t.negative = 1;
                    return r._normSign();
                }
                var i, n;
                if (this.length > t.length) {
                    i = this;
                    n = t;
                } else {
                    i = t;
                    n = this;
                }
                var a = 0;
                for (var s = 0; s < n.length; s++) {
                    r = (i.words[s] | 0) + (n.words[s] | 0) + a;
                    this.words[s] = r & 67108863;
                    a = r >>> 26;
                }
                for (;a !== 0 && s < i.length; s++) {
                    r = (i.words[s] | 0) + a;
                    this.words[s] = r & 67108863;
                    a = r >>> 26;
                }
                this.length = i.length;
                if (a !== 0) {
                    this.words[this.length] = a;
                    this.length++;
                } else if (i !== this) {
                    for (;s < i.length; s++) {
                        this.words[s] = i.words[s];
                    }
                }
                return this;
            };
            a.prototype.add = function e(t) {
                var r;
                if (t.negative !== 0 && this.negative === 0) {
                    t.negative = 0;
                    r = this.sub(t);
                    t.negative ^= 1;
                    return r;
                } else if (t.negative === 0 && this.negative !== 0) {
                    this.negative = 0;
                    r = t.sub(this);
                    this.negative = 1;
                    return r;
                }
                if (this.length > t.length) return this.clone().iadd(t);
                return t.clone().iadd(this);
            };
            a.prototype.isub = function e(t) {
                if (t.negative !== 0) {
                    t.negative = 0;
                    var r = this.iadd(t);
                    t.negative = 1;
                    return r._normSign();
                } else if (this.negative !== 0) {
                    this.negative = 0;
                    this.iadd(t);
                    this.negative = 1;
                    return this._normSign();
                }
                var i = this.cmp(t);
                if (i === 0) {
                    this.negative = 0;
                    this.length = 1;
                    this.words[0] = 0;
                    return this;
                }
                var n, a;
                if (i > 0) {
                    n = this;
                    a = t;
                } else {
                    n = t;
                    a = this;
                }
                var s = 0;
                for (var f = 0; f < a.length; f++) {
                    r = (n.words[f] | 0) - (a.words[f] | 0) + s;
                    s = r >> 26;
                    this.words[f] = r & 67108863;
                }
                for (;s !== 0 && f < n.length; f++) {
                    r = (n.words[f] | 0) + s;
                    s = r >> 26;
                    this.words[f] = r & 67108863;
                }
                if (s === 0 && f < n.length && n !== this) {
                    for (;f < n.length; f++) {
                        this.words[f] = n.words[f];
                    }
                }
                this.length = Math.max(this.length, f);
                if (n !== this) {
                    this.negative = 1;
                }
                return this.strip();
            };
            a.prototype.sub = function e(t) {
                return this.clone().isub(t);
            };
            function l(e, t, r) {
                r.negative = t.negative ^ e.negative;
                var i = e.length + t.length | 0;
                r.length = i;
                i = i - 1 | 0;
                var n = e.words[0] | 0;
                var a = t.words[0] | 0;
                var s = n * a;
                var f = s & 67108863;
                var o = s / 67108864 | 0;
                r.words[0] = f;
                for (var c = 1; c < i; c++) {
                    var h = o >>> 26;
                    var u = o & 67108863;
                    var d = Math.min(c, t.length - 1);
                    for (var l = Math.max(0, c - e.length + 1); l <= d; l++) {
                        var p = c - l | 0;
                        n = e.words[p] | 0;
                        a = t.words[l] | 0;
                        s = n * a + u;
                        h += s / 67108864 | 0;
                        u = s & 67108863;
                    }
                    r.words[c] = u | 0;
                    o = h | 0;
                }
                if (o !== 0) {
                    r.words[c] = o | 0;
                } else {
                    r.length--;
                }
                return r.strip();
            }
            var p = function e(t, r, i) {
                var n = t.words;
                var a = r.words;
                var s = i.words;
                var f = 0;
                var o;
                var c;
                var h;
                var u = n[0] | 0;
                var d = u & 8191;
                var l = u >>> 13;
                var p = n[1] | 0;
                var b = p & 8191;
                var v = p >>> 13;
                var m = n[2] | 0;
                var y = m & 8191;
                var g = m >>> 13;
                var w = n[3] | 0;
                var _ = w & 8191;
                var S = w >>> 13;
                var M = n[4] | 0;
                var k = M & 8191;
                var E = M >>> 13;
                var x = n[5] | 0;
                var A = x & 8191;
                var B = x >>> 13;
                var I = n[6] | 0;
                var j = I & 8191;
                var C = I >>> 13;
                var R = n[7] | 0;
                var P = R & 8191;
                var T = R >>> 13;
                var D = n[8] | 0;
                var L = D & 8191;
                var q = D >>> 13;
                var N = n[9] | 0;
                var O = N & 8191;
                var z = N >>> 13;
                var U = a[0] | 0;
                var K = U & 8191;
                var F = U >>> 13;
                var H = a[1] | 0;
                var W = H & 8191;
                var V = H >>> 13;
                var X = a[2] | 0;
                var Z = X & 8191;
                var J = X >>> 13;
                var Y = a[3] | 0;
                var G = Y & 8191;
                var $ = Y >>> 13;
                var Q = a[4] | 0;
                var ee = Q & 8191;
                var te = Q >>> 13;
                var re = a[5] | 0;
                var ie = re & 8191;
                var ne = re >>> 13;
                var ae = a[6] | 0;
                var se = ae & 8191;
                var fe = ae >>> 13;
                var oe = a[7] | 0;
                var ce = oe & 8191;
                var he = oe >>> 13;
                var ue = a[8] | 0;
                var de = ue & 8191;
                var le = ue >>> 13;
                var pe = a[9] | 0;
                var be = pe & 8191;
                var ve = pe >>> 13;
                i.negative = t.negative ^ r.negative;
                i.length = 19;
                o = Math.imul(d, K);
                c = Math.imul(d, F);
                c = c + Math.imul(l, K) | 0;
                h = Math.imul(l, F);
                var me = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (me >>> 26) | 0;
                me &= 67108863;
                o = Math.imul(b, K);
                c = Math.imul(b, F);
                c = c + Math.imul(v, K) | 0;
                h = Math.imul(v, F);
                o = o + Math.imul(d, W) | 0;
                c = c + Math.imul(d, V) | 0;
                c = c + Math.imul(l, W) | 0;
                h = h + Math.imul(l, V) | 0;
                var ye = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (ye >>> 26) | 0;
                ye &= 67108863;
                o = Math.imul(y, K);
                c = Math.imul(y, F);
                c = c + Math.imul(g, K) | 0;
                h = Math.imul(g, F);
                o = o + Math.imul(b, W) | 0;
                c = c + Math.imul(b, V) | 0;
                c = c + Math.imul(v, W) | 0;
                h = h + Math.imul(v, V) | 0;
                o = o + Math.imul(d, Z) | 0;
                c = c + Math.imul(d, J) | 0;
                c = c + Math.imul(l, Z) | 0;
                h = h + Math.imul(l, J) | 0;
                var ge = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (ge >>> 26) | 0;
                ge &= 67108863;
                o = Math.imul(_, K);
                c = Math.imul(_, F);
                c = c + Math.imul(S, K) | 0;
                h = Math.imul(S, F);
                o = o + Math.imul(y, W) | 0;
                c = c + Math.imul(y, V) | 0;
                c = c + Math.imul(g, W) | 0;
                h = h + Math.imul(g, V) | 0;
                o = o + Math.imul(b, Z) | 0;
                c = c + Math.imul(b, J) | 0;
                c = c + Math.imul(v, Z) | 0;
                h = h + Math.imul(v, J) | 0;
                o = o + Math.imul(d, G) | 0;
                c = c + Math.imul(d, $) | 0;
                c = c + Math.imul(l, G) | 0;
                h = h + Math.imul(l, $) | 0;
                var we = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (we >>> 26) | 0;
                we &= 67108863;
                o = Math.imul(k, K);
                c = Math.imul(k, F);
                c = c + Math.imul(E, K) | 0;
                h = Math.imul(E, F);
                o = o + Math.imul(_, W) | 0;
                c = c + Math.imul(_, V) | 0;
                c = c + Math.imul(S, W) | 0;
                h = h + Math.imul(S, V) | 0;
                o = o + Math.imul(y, Z) | 0;
                c = c + Math.imul(y, J) | 0;
                c = c + Math.imul(g, Z) | 0;
                h = h + Math.imul(g, J) | 0;
                o = o + Math.imul(b, G) | 0;
                c = c + Math.imul(b, $) | 0;
                c = c + Math.imul(v, G) | 0;
                h = h + Math.imul(v, $) | 0;
                o = o + Math.imul(d, ee) | 0;
                c = c + Math.imul(d, te) | 0;
                c = c + Math.imul(l, ee) | 0;
                h = h + Math.imul(l, te) | 0;
                var _e = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (_e >>> 26) | 0;
                _e &= 67108863;
                o = Math.imul(A, K);
                c = Math.imul(A, F);
                c = c + Math.imul(B, K) | 0;
                h = Math.imul(B, F);
                o = o + Math.imul(k, W) | 0;
                c = c + Math.imul(k, V) | 0;
                c = c + Math.imul(E, W) | 0;
                h = h + Math.imul(E, V) | 0;
                o = o + Math.imul(_, Z) | 0;
                c = c + Math.imul(_, J) | 0;
                c = c + Math.imul(S, Z) | 0;
                h = h + Math.imul(S, J) | 0;
                o = o + Math.imul(y, G) | 0;
                c = c + Math.imul(y, $) | 0;
                c = c + Math.imul(g, G) | 0;
                h = h + Math.imul(g, $) | 0;
                o = o + Math.imul(b, ee) | 0;
                c = c + Math.imul(b, te) | 0;
                c = c + Math.imul(v, ee) | 0;
                h = h + Math.imul(v, te) | 0;
                o = o + Math.imul(d, ie) | 0;
                c = c + Math.imul(d, ne) | 0;
                c = c + Math.imul(l, ie) | 0;
                h = h + Math.imul(l, ne) | 0;
                var Se = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (Se >>> 26) | 0;
                Se &= 67108863;
                o = Math.imul(j, K);
                c = Math.imul(j, F);
                c = c + Math.imul(C, K) | 0;
                h = Math.imul(C, F);
                o = o + Math.imul(A, W) | 0;
                c = c + Math.imul(A, V) | 0;
                c = c + Math.imul(B, W) | 0;
                h = h + Math.imul(B, V) | 0;
                o = o + Math.imul(k, Z) | 0;
                c = c + Math.imul(k, J) | 0;
                c = c + Math.imul(E, Z) | 0;
                h = h + Math.imul(E, J) | 0;
                o = o + Math.imul(_, G) | 0;
                c = c + Math.imul(_, $) | 0;
                c = c + Math.imul(S, G) | 0;
                h = h + Math.imul(S, $) | 0;
                o = o + Math.imul(y, ee) | 0;
                c = c + Math.imul(y, te) | 0;
                c = c + Math.imul(g, ee) | 0;
                h = h + Math.imul(g, te) | 0;
                o = o + Math.imul(b, ie) | 0;
                c = c + Math.imul(b, ne) | 0;
                c = c + Math.imul(v, ie) | 0;
                h = h + Math.imul(v, ne) | 0;
                o = o + Math.imul(d, se) | 0;
                c = c + Math.imul(d, fe) | 0;
                c = c + Math.imul(l, se) | 0;
                h = h + Math.imul(l, fe) | 0;
                var Me = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (Me >>> 26) | 0;
                Me &= 67108863;
                o = Math.imul(P, K);
                c = Math.imul(P, F);
                c = c + Math.imul(T, K) | 0;
                h = Math.imul(T, F);
                o = o + Math.imul(j, W) | 0;
                c = c + Math.imul(j, V) | 0;
                c = c + Math.imul(C, W) | 0;
                h = h + Math.imul(C, V) | 0;
                o = o + Math.imul(A, Z) | 0;
                c = c + Math.imul(A, J) | 0;
                c = c + Math.imul(B, Z) | 0;
                h = h + Math.imul(B, J) | 0;
                o = o + Math.imul(k, G) | 0;
                c = c + Math.imul(k, $) | 0;
                c = c + Math.imul(E, G) | 0;
                h = h + Math.imul(E, $) | 0;
                o = o + Math.imul(_, ee) | 0;
                c = c + Math.imul(_, te) | 0;
                c = c + Math.imul(S, ee) | 0;
                h = h + Math.imul(S, te) | 0;
                o = o + Math.imul(y, ie) | 0;
                c = c + Math.imul(y, ne) | 0;
                c = c + Math.imul(g, ie) | 0;
                h = h + Math.imul(g, ne) | 0;
                o = o + Math.imul(b, se) | 0;
                c = c + Math.imul(b, fe) | 0;
                c = c + Math.imul(v, se) | 0;
                h = h + Math.imul(v, fe) | 0;
                o = o + Math.imul(d, ce) | 0;
                c = c + Math.imul(d, he) | 0;
                c = c + Math.imul(l, ce) | 0;
                h = h + Math.imul(l, he) | 0;
                var ke = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (ke >>> 26) | 0;
                ke &= 67108863;
                o = Math.imul(L, K);
                c = Math.imul(L, F);
                c = c + Math.imul(q, K) | 0;
                h = Math.imul(q, F);
                o = o + Math.imul(P, W) | 0;
                c = c + Math.imul(P, V) | 0;
                c = c + Math.imul(T, W) | 0;
                h = h + Math.imul(T, V) | 0;
                o = o + Math.imul(j, Z) | 0;
                c = c + Math.imul(j, J) | 0;
                c = c + Math.imul(C, Z) | 0;
                h = h + Math.imul(C, J) | 0;
                o = o + Math.imul(A, G) | 0;
                c = c + Math.imul(A, $) | 0;
                c = c + Math.imul(B, G) | 0;
                h = h + Math.imul(B, $) | 0;
                o = o + Math.imul(k, ee) | 0;
                c = c + Math.imul(k, te) | 0;
                c = c + Math.imul(E, ee) | 0;
                h = h + Math.imul(E, te) | 0;
                o = o + Math.imul(_, ie) | 0;
                c = c + Math.imul(_, ne) | 0;
                c = c + Math.imul(S, ie) | 0;
                h = h + Math.imul(S, ne) | 0;
                o = o + Math.imul(y, se) | 0;
                c = c + Math.imul(y, fe) | 0;
                c = c + Math.imul(g, se) | 0;
                h = h + Math.imul(g, fe) | 0;
                o = o + Math.imul(b, ce) | 0;
                c = c + Math.imul(b, he) | 0;
                c = c + Math.imul(v, ce) | 0;
                h = h + Math.imul(v, he) | 0;
                o = o + Math.imul(d, de) | 0;
                c = c + Math.imul(d, le) | 0;
                c = c + Math.imul(l, de) | 0;
                h = h + Math.imul(l, le) | 0;
                var Ee = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (Ee >>> 26) | 0;
                Ee &= 67108863;
                o = Math.imul(O, K);
                c = Math.imul(O, F);
                c = c + Math.imul(z, K) | 0;
                h = Math.imul(z, F);
                o = o + Math.imul(L, W) | 0;
                c = c + Math.imul(L, V) | 0;
                c = c + Math.imul(q, W) | 0;
                h = h + Math.imul(q, V) | 0;
                o = o + Math.imul(P, Z) | 0;
                c = c + Math.imul(P, J) | 0;
                c = c + Math.imul(T, Z) | 0;
                h = h + Math.imul(T, J) | 0;
                o = o + Math.imul(j, G) | 0;
                c = c + Math.imul(j, $) | 0;
                c = c + Math.imul(C, G) | 0;
                h = h + Math.imul(C, $) | 0;
                o = o + Math.imul(A, ee) | 0;
                c = c + Math.imul(A, te) | 0;
                c = c + Math.imul(B, ee) | 0;
                h = h + Math.imul(B, te) | 0;
                o = o + Math.imul(k, ie) | 0;
                c = c + Math.imul(k, ne) | 0;
                c = c + Math.imul(E, ie) | 0;
                h = h + Math.imul(E, ne) | 0;
                o = o + Math.imul(_, se) | 0;
                c = c + Math.imul(_, fe) | 0;
                c = c + Math.imul(S, se) | 0;
                h = h + Math.imul(S, fe) | 0;
                o = o + Math.imul(y, ce) | 0;
                c = c + Math.imul(y, he) | 0;
                c = c + Math.imul(g, ce) | 0;
                h = h + Math.imul(g, he) | 0;
                o = o + Math.imul(b, de) | 0;
                c = c + Math.imul(b, le) | 0;
                c = c + Math.imul(v, de) | 0;
                h = h + Math.imul(v, le) | 0;
                o = o + Math.imul(d, be) | 0;
                c = c + Math.imul(d, ve) | 0;
                c = c + Math.imul(l, be) | 0;
                h = h + Math.imul(l, ve) | 0;
                var xe = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (xe >>> 26) | 0;
                xe &= 67108863;
                o = Math.imul(O, W);
                c = Math.imul(O, V);
                c = c + Math.imul(z, W) | 0;
                h = Math.imul(z, V);
                o = o + Math.imul(L, Z) | 0;
                c = c + Math.imul(L, J) | 0;
                c = c + Math.imul(q, Z) | 0;
                h = h + Math.imul(q, J) | 0;
                o = o + Math.imul(P, G) | 0;
                c = c + Math.imul(P, $) | 0;
                c = c + Math.imul(T, G) | 0;
                h = h + Math.imul(T, $) | 0;
                o = o + Math.imul(j, ee) | 0;
                c = c + Math.imul(j, te) | 0;
                c = c + Math.imul(C, ee) | 0;
                h = h + Math.imul(C, te) | 0;
                o = o + Math.imul(A, ie) | 0;
                c = c + Math.imul(A, ne) | 0;
                c = c + Math.imul(B, ie) | 0;
                h = h + Math.imul(B, ne) | 0;
                o = o + Math.imul(k, se) | 0;
                c = c + Math.imul(k, fe) | 0;
                c = c + Math.imul(E, se) | 0;
                h = h + Math.imul(E, fe) | 0;
                o = o + Math.imul(_, ce) | 0;
                c = c + Math.imul(_, he) | 0;
                c = c + Math.imul(S, ce) | 0;
                h = h + Math.imul(S, he) | 0;
                o = o + Math.imul(y, de) | 0;
                c = c + Math.imul(y, le) | 0;
                c = c + Math.imul(g, de) | 0;
                h = h + Math.imul(g, le) | 0;
                o = o + Math.imul(b, be) | 0;
                c = c + Math.imul(b, ve) | 0;
                c = c + Math.imul(v, be) | 0;
                h = h + Math.imul(v, ve) | 0;
                var Ae = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (Ae >>> 26) | 0;
                Ae &= 67108863;
                o = Math.imul(O, Z);
                c = Math.imul(O, J);
                c = c + Math.imul(z, Z) | 0;
                h = Math.imul(z, J);
                o = o + Math.imul(L, G) | 0;
                c = c + Math.imul(L, $) | 0;
                c = c + Math.imul(q, G) | 0;
                h = h + Math.imul(q, $) | 0;
                o = o + Math.imul(P, ee) | 0;
                c = c + Math.imul(P, te) | 0;
                c = c + Math.imul(T, ee) | 0;
                h = h + Math.imul(T, te) | 0;
                o = o + Math.imul(j, ie) | 0;
                c = c + Math.imul(j, ne) | 0;
                c = c + Math.imul(C, ie) | 0;
                h = h + Math.imul(C, ne) | 0;
                o = o + Math.imul(A, se) | 0;
                c = c + Math.imul(A, fe) | 0;
                c = c + Math.imul(B, se) | 0;
                h = h + Math.imul(B, fe) | 0;
                o = o + Math.imul(k, ce) | 0;
                c = c + Math.imul(k, he) | 0;
                c = c + Math.imul(E, ce) | 0;
                h = h + Math.imul(E, he) | 0;
                o = o + Math.imul(_, de) | 0;
                c = c + Math.imul(_, le) | 0;
                c = c + Math.imul(S, de) | 0;
                h = h + Math.imul(S, le) | 0;
                o = o + Math.imul(y, be) | 0;
                c = c + Math.imul(y, ve) | 0;
                c = c + Math.imul(g, be) | 0;
                h = h + Math.imul(g, ve) | 0;
                var Be = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (Be >>> 26) | 0;
                Be &= 67108863;
                o = Math.imul(O, G);
                c = Math.imul(O, $);
                c = c + Math.imul(z, G) | 0;
                h = Math.imul(z, $);
                o = o + Math.imul(L, ee) | 0;
                c = c + Math.imul(L, te) | 0;
                c = c + Math.imul(q, ee) | 0;
                h = h + Math.imul(q, te) | 0;
                o = o + Math.imul(P, ie) | 0;
                c = c + Math.imul(P, ne) | 0;
                c = c + Math.imul(T, ie) | 0;
                h = h + Math.imul(T, ne) | 0;
                o = o + Math.imul(j, se) | 0;
                c = c + Math.imul(j, fe) | 0;
                c = c + Math.imul(C, se) | 0;
                h = h + Math.imul(C, fe) | 0;
                o = o + Math.imul(A, ce) | 0;
                c = c + Math.imul(A, he) | 0;
                c = c + Math.imul(B, ce) | 0;
                h = h + Math.imul(B, he) | 0;
                o = o + Math.imul(k, de) | 0;
                c = c + Math.imul(k, le) | 0;
                c = c + Math.imul(E, de) | 0;
                h = h + Math.imul(E, le) | 0;
                o = o + Math.imul(_, be) | 0;
                c = c + Math.imul(_, ve) | 0;
                c = c + Math.imul(S, be) | 0;
                h = h + Math.imul(S, ve) | 0;
                var Ie = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (Ie >>> 26) | 0;
                Ie &= 67108863;
                o = Math.imul(O, ee);
                c = Math.imul(O, te);
                c = c + Math.imul(z, ee) | 0;
                h = Math.imul(z, te);
                o = o + Math.imul(L, ie) | 0;
                c = c + Math.imul(L, ne) | 0;
                c = c + Math.imul(q, ie) | 0;
                h = h + Math.imul(q, ne) | 0;
                o = o + Math.imul(P, se) | 0;
                c = c + Math.imul(P, fe) | 0;
                c = c + Math.imul(T, se) | 0;
                h = h + Math.imul(T, fe) | 0;
                o = o + Math.imul(j, ce) | 0;
                c = c + Math.imul(j, he) | 0;
                c = c + Math.imul(C, ce) | 0;
                h = h + Math.imul(C, he) | 0;
                o = o + Math.imul(A, de) | 0;
                c = c + Math.imul(A, le) | 0;
                c = c + Math.imul(B, de) | 0;
                h = h + Math.imul(B, le) | 0;
                o = o + Math.imul(k, be) | 0;
                c = c + Math.imul(k, ve) | 0;
                c = c + Math.imul(E, be) | 0;
                h = h + Math.imul(E, ve) | 0;
                var je = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (je >>> 26) | 0;
                je &= 67108863;
                o = Math.imul(O, ie);
                c = Math.imul(O, ne);
                c = c + Math.imul(z, ie) | 0;
                h = Math.imul(z, ne);
                o = o + Math.imul(L, se) | 0;
                c = c + Math.imul(L, fe) | 0;
                c = c + Math.imul(q, se) | 0;
                h = h + Math.imul(q, fe) | 0;
                o = o + Math.imul(P, ce) | 0;
                c = c + Math.imul(P, he) | 0;
                c = c + Math.imul(T, ce) | 0;
                h = h + Math.imul(T, he) | 0;
                o = o + Math.imul(j, de) | 0;
                c = c + Math.imul(j, le) | 0;
                c = c + Math.imul(C, de) | 0;
                h = h + Math.imul(C, le) | 0;
                o = o + Math.imul(A, be) | 0;
                c = c + Math.imul(A, ve) | 0;
                c = c + Math.imul(B, be) | 0;
                h = h + Math.imul(B, ve) | 0;
                var Ce = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (Ce >>> 26) | 0;
                Ce &= 67108863;
                o = Math.imul(O, se);
                c = Math.imul(O, fe);
                c = c + Math.imul(z, se) | 0;
                h = Math.imul(z, fe);
                o = o + Math.imul(L, ce) | 0;
                c = c + Math.imul(L, he) | 0;
                c = c + Math.imul(q, ce) | 0;
                h = h + Math.imul(q, he) | 0;
                o = o + Math.imul(P, de) | 0;
                c = c + Math.imul(P, le) | 0;
                c = c + Math.imul(T, de) | 0;
                h = h + Math.imul(T, le) | 0;
                o = o + Math.imul(j, be) | 0;
                c = c + Math.imul(j, ve) | 0;
                c = c + Math.imul(C, be) | 0;
                h = h + Math.imul(C, ve) | 0;
                var Re = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (Re >>> 26) | 0;
                Re &= 67108863;
                o = Math.imul(O, ce);
                c = Math.imul(O, he);
                c = c + Math.imul(z, ce) | 0;
                h = Math.imul(z, he);
                o = o + Math.imul(L, de) | 0;
                c = c + Math.imul(L, le) | 0;
                c = c + Math.imul(q, de) | 0;
                h = h + Math.imul(q, le) | 0;
                o = o + Math.imul(P, be) | 0;
                c = c + Math.imul(P, ve) | 0;
                c = c + Math.imul(T, be) | 0;
                h = h + Math.imul(T, ve) | 0;
                var Pe = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (Pe >>> 26) | 0;
                Pe &= 67108863;
                o = Math.imul(O, de);
                c = Math.imul(O, le);
                c = c + Math.imul(z, de) | 0;
                h = Math.imul(z, le);
                o = o + Math.imul(L, be) | 0;
                c = c + Math.imul(L, ve) | 0;
                c = c + Math.imul(q, be) | 0;
                h = h + Math.imul(q, ve) | 0;
                var Te = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (Te >>> 26) | 0;
                Te &= 67108863;
                o = Math.imul(O, be);
                c = Math.imul(O, ve);
                c = c + Math.imul(z, be) | 0;
                h = Math.imul(z, ve);
                var De = (f + o | 0) + ((c & 8191) << 13) | 0;
                f = (h + (c >>> 13) | 0) + (De >>> 26) | 0;
                De &= 67108863;
                s[0] = me;
                s[1] = ye;
                s[2] = ge;
                s[3] = we;
                s[4] = _e;
                s[5] = Se;
                s[6] = Me;
                s[7] = ke;
                s[8] = Ee;
                s[9] = xe;
                s[10] = Ae;
                s[11] = Be;
                s[12] = Ie;
                s[13] = je;
                s[14] = Ce;
                s[15] = Re;
                s[16] = Pe;
                s[17] = Te;
                s[18] = De;
                if (f !== 0) {
                    s[19] = f;
                    i.length++;
                }
                return i;
            };
            if (!Math.imul) {
                p = l;
            }
            function b(e, t, r) {
                r.negative = t.negative ^ e.negative;
                r.length = e.length + t.length;
                var i = 0;
                var n = 0;
                for (var a = 0; a < r.length - 1; a++) {
                    var s = n;
                    n = 0;
                    var f = i & 67108863;
                    var o = Math.min(a, t.length - 1);
                    for (var c = Math.max(0, a - e.length + 1); c <= o; c++) {
                        var h = a - c;
                        var u = e.words[h] | 0;
                        var d = t.words[c] | 0;
                        var l = u * d;
                        var p = l & 67108863;
                        s = s + (l / 67108864 | 0) | 0;
                        p = p + f | 0;
                        f = p & 67108863;
                        s = s + (p >>> 26) | 0;
                        n += s >>> 26;
                        s &= 67108863;
                    }
                    r.words[a] = f;
                    i = s;
                    s = n;
                }
                if (i !== 0) {
                    r.words[a] = i;
                } else {
                    r.length--;
                }
                return r.strip();
            }
            function v(e, t, r) {
                var i = new m();
                return i.mulp(e, t, r);
            }
            a.prototype.mulTo = function e(t, r) {
                var i;
                var n = this.length + t.length;
                if (this.length === 10 && t.length === 10) {
                    i = p(this, t, r);
                } else if (n < 63) {
                    i = l(this, t, r);
                } else if (n < 1024) {
                    i = b(this, t, r);
                } else {
                    i = v(this, t, r);
                }
                return i;
            };
            function m(e, t) {
                this.x = e;
                this.y = t;
            }
            m.prototype.makeRBT = function e(t) {
                var r = new Array(t);
                var i = a.prototype._countBits(t) - 1;
                for (var n = 0; n < t; n++) {
                    r[n] = this.revBin(n, i, t);
                }
                return r;
            };
            m.prototype.revBin = function e(t, r, i) {
                if (t === 0 || t === i - 1) return t;
                var n = 0;
                for (var a = 0; a < r; a++) {
                    n |= (t & 1) << r - a - 1;
                    t >>= 1;
                }
                return n;
            };
            m.prototype.permute = function e(t, r, i, n, a, s) {
                for (var f = 0; f < s; f++) {
                    n[f] = r[t[f]];
                    a[f] = i[t[f]];
                }
            };
            m.prototype.transform = function e(t, r, i, n, a, s) {
                this.permute(s, t, r, i, n, a);
                for (var f = 1; f < a; f <<= 1) {
                    var o = f << 1;
                    var c = Math.cos(2 * Math.PI / o);
                    var h = Math.sin(2 * Math.PI / o);
                    for (var u = 0; u < a; u += o) {
                        var d = c;
                        var l = h;
                        for (var p = 0; p < f; p++) {
                            var b = i[u + p];
                            var v = n[u + p];
                            var m = i[u + p + f];
                            var y = n[u + p + f];
                            var g = d * m - l * y;
                            y = d * y + l * m;
                            m = g;
                            i[u + p] = b + m;
                            n[u + p] = v + y;
                            i[u + p + f] = b - m;
                            n[u + p + f] = v - y;
                            if (p !== o) {
                                g = c * d - h * l;
                                l = c * l + h * d;
                                d = g;
                            }
                        }
                    }
                }
            };
            m.prototype.guessLen13b = function e(t, r) {
                var i = Math.max(r, t) | 1;
                var n = i & 1;
                var a = 0;
                for (i = i / 2 | 0; i; i = i >>> 1) {
                    a++;
                }
                return 1 << a + 1 + n;
            };
            m.prototype.conjugate = function e(t, r, i) {
                if (i <= 1) return;
                for (var n = 0; n < i / 2; n++) {
                    var a = t[n];
                    t[n] = t[i - n - 1];
                    t[i - n - 1] = a;
                    a = r[n];
                    r[n] = -r[i - n - 1];
                    r[i - n - 1] = -a;
                }
            };
            m.prototype.normalize13b = function e(t, r) {
                var i = 0;
                for (var n = 0; n < r / 2; n++) {
                    var a = Math.round(t[2 * n + 1] / r) * 8192 + Math.round(t[2 * n] / r) + i;
                    t[n] = a & 67108863;
                    if (a < 67108864) {
                        i = 0;
                    } else {
                        i = a / 67108864 | 0;
                    }
                }
                return t;
            };
            m.prototype.convert13b = function e(t, r, n, a) {
                var s = 0;
                for (var f = 0; f < r; f++) {
                    s = s + (t[f] | 0);
                    n[2 * f] = s & 8191;
                    s = s >>> 13;
                    n[2 * f + 1] = s & 8191;
                    s = s >>> 13;
                }
                for (f = 2 * r; f < a; ++f) {
                    n[f] = 0;
                }
                i(s === 0);
                i((s & ~8191) === 0);
            };
            m.prototype.stub = function e(t) {
                var r = new Array(t);
                for (var i = 0; i < t; i++) {
                    r[i] = 0;
                }
                return r;
            };
            m.prototype.mulp = function e(t, r, i) {
                var n = 2 * this.guessLen13b(t.length, r.length);
                var a = this.makeRBT(n);
                var s = this.stub(n);
                var f = new Array(n);
                var o = new Array(n);
                var c = new Array(n);
                var h = new Array(n);
                var u = new Array(n);
                var d = new Array(n);
                var l = i.words;
                l.length = n;
                this.convert13b(t.words, t.length, f, n);
                this.convert13b(r.words, r.length, h, n);
                this.transform(f, s, o, c, n, a);
                this.transform(h, s, u, d, n, a);
                for (var p = 0; p < n; p++) {
                    var b = o[p] * u[p] - c[p] * d[p];
                    c[p] = o[p] * d[p] + c[p] * u[p];
                    o[p] = b;
                }
                this.conjugate(o, c, n);
                this.transform(o, c, l, s, n, a);
                this.conjugate(l, s, n);
                this.normalize13b(l, n);
                i.negative = t.negative ^ r.negative;
                i.length = t.length + r.length;
                return i.strip();
            };
            a.prototype.mul = function e(t) {
                var r = new a(null);
                r.words = new Array(this.length + t.length);
                return this.mulTo(t, r);
            };
            a.prototype.mulf = function e(t) {
                var r = new a(null);
                r.words = new Array(this.length + t.length);
                return v(this, t, r);
            };
            a.prototype.imul = function e(t) {
                return this.clone().mulTo(t, this);
            };
            a.prototype.imuln = function e(t) {
                i(typeof t === "number");
                i(t < 67108864);
                var r = 0;
                for (var n = 0; n < this.length; n++) {
                    var a = (this.words[n] | 0) * t;
                    var s = (a & 67108863) + (r & 67108863);
                    r >>= 26;
                    r += a / 67108864 | 0;
                    r += s >>> 26;
                    this.words[n] = s & 67108863;
                }
                if (r !== 0) {
                    this.words[n] = r;
                    this.length++;
                }
                return this;
            };
            a.prototype.muln = function e(t) {
                return this.clone().imuln(t);
            };
            a.prototype.sqr = function e() {
                return this.mul(this);
            };
            a.prototype.isqr = function e() {
                return this.imul(this.clone());
            };
            a.prototype.pow = function e(t) {
                var r = d(t);
                if (r.length === 0) return new a(1);
                var i = this;
                for (var n = 0; n < r.length; n++, i = i.sqr()) {
                    if (r[n] !== 0) break;
                }
                if (++n < r.length) {
                    for (var s = i.sqr(); n < r.length; n++, s = s.sqr()) {
                        if (r[n] === 0) continue;
                        i = i.mul(s);
                    }
                }
                return i;
            };
            a.prototype.iushln = function e(t) {
                i(typeof t === "number" && t >= 0);
                var r = t % 26;
                var n = (t - r) / 26;
                var a = 67108863 >>> 26 - r << 26 - r;
                var s;
                if (r !== 0) {
                    var f = 0;
                    for (s = 0; s < this.length; s++) {
                        var o = this.words[s] & a;
                        var c = (this.words[s] | 0) - o << r;
                        this.words[s] = c | f;
                        f = o >>> 26 - r;
                    }
                    if (f) {
                        this.words[s] = f;
                        this.length++;
                    }
                }
                if (n !== 0) {
                    for (s = this.length - 1; s >= 0; s--) {
                        this.words[s + n] = this.words[s];
                    }
                    for (s = 0; s < n; s++) {
                        this.words[s] = 0;
                    }
                    this.length += n;
                }
                return this.strip();
            };
            a.prototype.ishln = function e(t) {
                i(this.negative === 0);
                return this.iushln(t);
            };
            a.prototype.iushrn = function e(t, r, n) {
                i(typeof t === "number" && t >= 0);
                var a;
                if (r) {
                    a = (r - r % 26) / 26;
                } else {
                    a = 0;
                }
                var s = t % 26;
                var f = Math.min((t - s) / 26, this.length);
                var o = 67108863 ^ 67108863 >>> s << s;
                var c = n;
                a -= f;
                a = Math.max(0, a);
                if (c) {
                    for (var h = 0; h < f; h++) {
                        c.words[h] = this.words[h];
                    }
                    c.length = f;
                }
                if (f === 0) {} else if (this.length > f) {
                    this.length -= f;
                    for (h = 0; h < this.length; h++) {
                        this.words[h] = this.words[h + f];
                    }
                } else {
                    this.words[0] = 0;
                    this.length = 1;
                }
                var u = 0;
                for (h = this.length - 1; h >= 0 && (u !== 0 || h >= a); h--) {
                    var d = this.words[h] | 0;
                    this.words[h] = u << 26 - s | d >>> s;
                    u = d & o;
                }
                if (c && u !== 0) {
                    c.words[c.length++] = u;
                }
                if (this.length === 0) {
                    this.words[0] = 0;
                    this.length = 1;
                }
                return this.strip();
            };
            a.prototype.ishrn = function e(t, r, n) {
                i(this.negative === 0);
                return this.iushrn(t, r, n);
            };
            a.prototype.shln = function e(t) {
                return this.clone().ishln(t);
            };
            a.prototype.ushln = function e(t) {
                return this.clone().iushln(t);
            };
            a.prototype.shrn = function e(t) {
                return this.clone().ishrn(t);
            };
            a.prototype.ushrn = function e(t) {
                return this.clone().iushrn(t);
            };
            a.prototype.testn = function e(t) {
                i(typeof t === "number" && t >= 0);
                var r = t % 26;
                var n = (t - r) / 26;
                var a = 1 << r;
                if (this.length <= n) return false;
                var s = this.words[n];
                return !!(s & a);
            };
            a.prototype.imaskn = function e(t) {
                i(typeof t === "number" && t >= 0);
                var r = t % 26;
                var n = (t - r) / 26;
                i(this.negative === 0, "imaskn works only with positive numbers");
                if (this.length <= n) {
                    return this;
                }
                if (r !== 0) {
                    n++;
                }
                this.length = Math.min(n, this.length);
                if (r !== 0) {
                    var a = 67108863 ^ 67108863 >>> r << r;
                    this.words[this.length - 1] &= a;
                }
                return this.strip();
            };
            a.prototype.maskn = function e(t) {
                return this.clone().imaskn(t);
            };
            a.prototype.iaddn = function e(t) {
                i(typeof t === "number");
                i(t < 67108864);
                if (t < 0) return this.isubn(-t);
                if (this.negative !== 0) {
                    if (this.length === 1 && (this.words[0] | 0) < t) {
                        this.words[0] = t - (this.words[0] | 0);
                        this.negative = 0;
                        return this;
                    }
                    this.negative = 0;
                    this.isubn(t);
                    this.negative = 1;
                    return this;
                }
                return this._iaddn(t);
            };
            a.prototype._iaddn = function e(t) {
                this.words[0] += t;
                for (var r = 0; r < this.length && this.words[r] >= 67108864; r++) {
                    this.words[r] -= 67108864;
                    if (r === this.length - 1) {
                        this.words[r + 1] = 1;
                    } else {
                        this.words[r + 1]++;
                    }
                }
                this.length = Math.max(this.length, r + 1);
                return this;
            };
            a.prototype.isubn = function e(t) {
                i(typeof t === "number");
                i(t < 67108864);
                if (t < 0) return this.iaddn(-t);
                if (this.negative !== 0) {
                    this.negative = 0;
                    this.iaddn(t);
                    this.negative = 1;
                    return this;
                }
                this.words[0] -= t;
                if (this.length === 1 && this.words[0] < 0) {
                    this.words[0] = -this.words[0];
                    this.negative = 1;
                } else {
                    for (var r = 0; r < this.length && this.words[r] < 0; r++) {
                        this.words[r] += 67108864;
                        this.words[r + 1] -= 1;
                    }
                }
                return this.strip();
            };
            a.prototype.addn = function e(t) {
                return this.clone().iaddn(t);
            };
            a.prototype.subn = function e(t) {
                return this.clone().isubn(t);
            };
            a.prototype.iabs = function e() {
                this.negative = 0;
                return this;
            };
            a.prototype.abs = function e() {
                return this.clone().iabs();
            };
            a.prototype._ishlnsubmul = function e(t, r, n) {
                var a = t.length + n;
                var s;
                this._expand(a);
                var f;
                var o = 0;
                for (s = 0; s < t.length; s++) {
                    f = (this.words[s + n] | 0) + o;
                    var c = (t.words[s] | 0) * r;
                    f -= c & 67108863;
                    o = (f >> 26) - (c / 67108864 | 0);
                    this.words[s + n] = f & 67108863;
                }
                for (;s < this.length - n; s++) {
                    f = (this.words[s + n] | 0) + o;
                    o = f >> 26;
                    this.words[s + n] = f & 67108863;
                }
                if (o === 0) return this.strip();
                i(o === -1);
                o = 0;
                for (s = 0; s < this.length; s++) {
                    f = -(this.words[s] | 0) + o;
                    o = f >> 26;
                    this.words[s] = f & 67108863;
                }
                this.negative = 1;
                return this.strip();
            };
            a.prototype._wordDiv = function e(t, r) {
                var i = this.length - t.length;
                var n = this.clone();
                var s = t;
                var f = s.words[s.length - 1] | 0;
                var o = this._countBits(f);
                i = 26 - o;
                if (i !== 0) {
                    s = s.ushln(i);
                    n.iushln(i);
                    f = s.words[s.length - 1] | 0;
                }
                var c = n.length - s.length;
                var h;
                if (r !== "mod") {
                    h = new a(null);
                    h.length = c + 1;
                    h.words = new Array(h.length);
                    for (var u = 0; u < h.length; u++) {
                        h.words[u] = 0;
                    }
                }
                var d = n.clone()._ishlnsubmul(s, 1, c);
                if (d.negative === 0) {
                    n = d;
                    if (h) {
                        h.words[c] = 1;
                    }
                }
                for (var l = c - 1; l >= 0; l--) {
                    var p = (n.words[s.length + l] | 0) * 67108864 + (n.words[s.length + l - 1] | 0);
                    p = Math.min(p / f | 0, 67108863);
                    n._ishlnsubmul(s, p, l);
                    while (n.negative !== 0) {
                        p--;
                        n.negative = 0;
                        n._ishlnsubmul(s, 1, l);
                        if (!n.isZero()) {
                            n.negative ^= 1;
                        }
                    }
                    if (h) {
                        h.words[l] = p;
                    }
                }
                if (h) {
                    h.strip();
                }
                n.strip();
                if (r !== "div" && i !== 0) {
                    n.iushrn(i);
                }
                return {
                    div: h || null,
                    mod: n
                };
            };
            a.prototype.divmod = function e(t, r, n) {
                i(!t.isZero());
                if (this.isZero()) {
                    return {
                        div: new a(0),
                        mod: new a(0)
                    };
                }
                var s, f, o;
                if (this.negative !== 0 && t.negative === 0) {
                    o = this.neg().divmod(t, r);
                    if (r !== "mod") {
                        s = o.div.neg();
                    }
                    if (r !== "div") {
                        f = o.mod.neg();
                        if (n && f.negative !== 0) {
                            f.iadd(t);
                        }
                    }
                    return {
                        div: s,
                        mod: f
                    };
                }
                if (this.negative === 0 && t.negative !== 0) {
                    o = this.divmod(t.neg(), r);
                    if (r !== "mod") {
                        s = o.div.neg();
                    }
                    return {
                        div: s,
                        mod: o.mod
                    };
                }
                if ((this.negative & t.negative) !== 0) {
                    o = this.neg().divmod(t.neg(), r);
                    if (r !== "div") {
                        f = o.mod.neg();
                        if (n && f.negative !== 0) {
                            f.isub(t);
                        }
                    }
                    return {
                        div: o.div,
                        mod: f
                    };
                }
                if (t.length > this.length || this.cmp(t) < 0) {
                    return {
                        div: new a(0),
                        mod: this
                    };
                }
                if (t.length === 1) {
                    if (r === "div") {
                        return {
                            div: this.divn(t.words[0]),
                            mod: null
                        };
                    }
                    if (r === "mod") {
                        return {
                            div: null,
                            mod: new a(this.modn(t.words[0]))
                        };
                    }
                    return {
                        div: this.divn(t.words[0]),
                        mod: new a(this.modn(t.words[0]))
                    };
                }
                return this._wordDiv(t, r);
            };
            a.prototype.div = function e(t) {
                return this.divmod(t, "div", false).div;
            };
            a.prototype.mod = function e(t) {
                return this.divmod(t, "mod", false).mod;
            };
            a.prototype.umod = function e(t) {
                return this.divmod(t, "mod", true).mod;
            };
            a.prototype.divRound = function e(t) {
                var r = this.divmod(t);
                if (r.mod.isZero()) return r.div;
                var i = r.div.negative !== 0 ? r.mod.isub(t) : r.mod;
                var n = t.ushrn(1);
                var a = t.andln(1);
                var s = i.cmp(n);
                if (s < 0 || a === 1 && s === 0) return r.div;
                return r.div.negative !== 0 ? r.div.isubn(1) : r.div.iaddn(1);
            };
            a.prototype.modn = function e(t) {
                i(t <= 67108863);
                var r = (1 << 26) % t;
                var n = 0;
                for (var a = this.length - 1; a >= 0; a--) {
                    n = (r * n + (this.words[a] | 0)) % t;
                }
                return n;
            };
            a.prototype.idivn = function e(t) {
                i(t <= 67108863);
                var r = 0;
                for (var n = this.length - 1; n >= 0; n--) {
                    var a = (this.words[n] | 0) + r * 67108864;
                    this.words[n] = a / t | 0;
                    r = a % t;
                }
                return this.strip();
            };
            a.prototype.divn = function e(t) {
                return this.clone().idivn(t);
            };
            a.prototype.egcd = function e(t) {
                i(t.negative === 0);
                i(!t.isZero());
                var r = this;
                var n = t.clone();
                if (r.negative !== 0) {
                    r = r.umod(t);
                } else {
                    r = r.clone();
                }
                var s = new a(1);
                var f = new a(0);
                var o = new a(0);
                var c = new a(1);
                var h = 0;
                while (r.isEven() && n.isEven()) {
                    r.iushrn(1);
                    n.iushrn(1);
                    ++h;
                }
                var u = n.clone();
                var d = r.clone();
                while (!r.isZero()) {
                    for (var l = 0, p = 1; (r.words[0] & p) === 0 && l < 26; ++l, p <<= 1) ;
                    if (l > 0) {
                        r.iushrn(l);
                        while (l-- > 0) {
                            if (s.isOdd() || f.isOdd()) {
                                s.iadd(u);
                                f.isub(d);
                            }
                            s.iushrn(1);
                            f.iushrn(1);
                        }
                    }
                    for (var b = 0, v = 1; (n.words[0] & v) === 0 && b < 26; ++b, v <<= 1) ;
                    if (b > 0) {
                        n.iushrn(b);
                        while (b-- > 0) {
                            if (o.isOdd() || c.isOdd()) {
                                o.iadd(u);
                                c.isub(d);
                            }
                            o.iushrn(1);
                            c.iushrn(1);
                        }
                    }
                    if (r.cmp(n) >= 0) {
                        r.isub(n);
                        s.isub(o);
                        f.isub(c);
                    } else {
                        n.isub(r);
                        o.isub(s);
                        c.isub(f);
                    }
                }
                return {
                    a: o,
                    b: c,
                    gcd: n.iushln(h)
                };
            };
            a.prototype._invmp = function e(t) {
                i(t.negative === 0);
                i(!t.isZero());
                var r = this;
                var n = t.clone();
                if (r.negative !== 0) {
                    r = r.umod(t);
                } else {
                    r = r.clone();
                }
                var s = new a(1);
                var f = new a(0);
                var o = n.clone();
                while (r.cmpn(1) > 0 && n.cmpn(1) > 0) {
                    for (var c = 0, h = 1; (r.words[0] & h) === 0 && c < 26; ++c, h <<= 1) ;
                    if (c > 0) {
                        r.iushrn(c);
                        while (c-- > 0) {
                            if (s.isOdd()) {
                                s.iadd(o);
                            }
                            s.iushrn(1);
                        }
                    }
                    for (var u = 0, d = 1; (n.words[0] & d) === 0 && u < 26; ++u, d <<= 1) ;
                    if (u > 0) {
                        n.iushrn(u);
                        while (u-- > 0) {
                            if (f.isOdd()) {
                                f.iadd(o);
                            }
                            f.iushrn(1);
                        }
                    }
                    if (r.cmp(n) >= 0) {
                        r.isub(n);
                        s.isub(f);
                    } else {
                        n.isub(r);
                        f.isub(s);
                    }
                }
                var l;
                if (r.cmpn(1) === 0) {
                    l = s;
                } else {
                    l = f;
                }
                if (l.cmpn(0) < 0) {
                    l.iadd(t);
                }
                return l;
            };
            a.prototype.gcd = function e(t) {
                if (this.isZero()) return t.abs();
                if (t.isZero()) return this.abs();
                var r = this.clone();
                var i = t.clone();
                r.negative = 0;
                i.negative = 0;
                for (var n = 0; r.isEven() && i.isEven(); n++) {
                    r.iushrn(1);
                    i.iushrn(1);
                }
                do {
                    while (r.isEven()) {
                        r.iushrn(1);
                    }
                    while (i.isEven()) {
                        i.iushrn(1);
                    }
                    var a = r.cmp(i);
                    if (a < 0) {
                        var s = r;
                        r = i;
                        i = s;
                    } else if (a === 0 || i.cmpn(1) === 0) {
                        break;
                    }
                    r.isub(i);
                } while (true);
                return i.iushln(n);
            };
            a.prototype.invm = function e(t) {
                return this.egcd(t).a.umod(t);
            };
            a.prototype.isEven = function e() {
                return (this.words[0] & 1) === 0;
            };
            a.prototype.isOdd = function e() {
                return (this.words[0] & 1) === 1;
            };
            a.prototype.andln = function e(t) {
                return this.words[0] & t;
            };
            a.prototype.bincn = function e(t) {
                i(typeof t === "number");
                var r = t % 26;
                var n = (t - r) / 26;
                var a = 1 << r;
                if (this.length <= n) {
                    this._expand(n + 1);
                    this.words[n] |= a;
                    return this;
                }
                var s = a;
                for (var f = n; s !== 0 && f < this.length; f++) {
                    var o = this.words[f] | 0;
                    o += s;
                    s = o >>> 26;
                    o &= 67108863;
                    this.words[f] = o;
                }
                if (s !== 0) {
                    this.words[f] = s;
                    this.length++;
                }
                return this;
            };
            a.prototype.isZero = function e() {
                return this.length === 1 && this.words[0] === 0;
            };
            a.prototype.cmpn = function e(t) {
                var r = t < 0;
                if (this.negative !== 0 && !r) return -1;
                if (this.negative === 0 && r) return 1;
                this.strip();
                var n;
                if (this.length > 1) {
                    n = 1;
                } else {
                    if (r) {
                        t = -t;
                    }
                    i(t <= 67108863, "Number is too big");
                    var a = this.words[0] | 0;
                    n = a === t ? 0 : a < t ? -1 : 1;
                }
                if (this.negative !== 0) return -n | 0;
                return n;
            };
            a.prototype.cmp = function e(t) {
                if (this.negative !== 0 && t.negative === 0) return -1;
                if (this.negative === 0 && t.negative !== 0) return 1;
                var r = this.ucmp(t);
                if (this.negative !== 0) return -r | 0;
                return r;
            };
            a.prototype.ucmp = function e(t) {
                if (this.length > t.length) return 1;
                if (this.length < t.length) return -1;
                var r = 0;
                for (var i = this.length - 1; i >= 0; i--) {
                    var n = this.words[i] | 0;
                    var a = t.words[i] | 0;
                    if (n === a) continue;
                    if (n < a) {
                        r = -1;
                    } else if (n > a) {
                        r = 1;
                    }
                    break;
                }
                return r;
            };
            a.prototype.gtn = function e(t) {
                return this.cmpn(t) === 1;
            };
            a.prototype.gt = function e(t) {
                return this.cmp(t) === 1;
            };
            a.prototype.gten = function e(t) {
                return this.cmpn(t) >= 0;
            };
            a.prototype.gte = function e(t) {
                return this.cmp(t) >= 0;
            };
            a.prototype.ltn = function e(t) {
                return this.cmpn(t) === -1;
            };
            a.prototype.lt = function e(t) {
                return this.cmp(t) === -1;
            };
            a.prototype.lten = function e(t) {
                return this.cmpn(t) <= 0;
            };
            a.prototype.lte = function e(t) {
                return this.cmp(t) <= 0;
            };
            a.prototype.eqn = function e(t) {
                return this.cmpn(t) === 0;
            };
            a.prototype.eq = function e(t) {
                return this.cmp(t) === 0;
            };
            a.red = function e(t) {
                return new k(t);
            };
            a.prototype.toRed = function e(t) {
                i(!this.red, "Already a number in reduction context");
                i(this.negative === 0, "red works only with positives");
                return t.convertTo(this)._forceRed(t);
            };
            a.prototype.fromRed = function e() {
                i(this.red, "fromRed works only with numbers in reduction context");
                return this.red.convertFrom(this);
            };
            a.prototype._forceRed = function e(t) {
                this.red = t;
                return this;
            };
            a.prototype.forceRed = function e(t) {
                i(!this.red, "Already a number in reduction context");
                return this._forceRed(t);
            };
            a.prototype.redAdd = function e(t) {
                i(this.red, "redAdd works only with red numbers");
                return this.red.add(this, t);
            };
            a.prototype.redIAdd = function e(t) {
                i(this.red, "redIAdd works only with red numbers");
                return this.red.iadd(this, t);
            };
            a.prototype.redSub = function e(t) {
                i(this.red, "redSub works only with red numbers");
                return this.red.sub(this, t);
            };
            a.prototype.redISub = function e(t) {
                i(this.red, "redISub works only with red numbers");
                return this.red.isub(this, t);
            };
            a.prototype.redShl = function e(t) {
                i(this.red, "redShl works only with red numbers");
                return this.red.shl(this, t);
            };
            a.prototype.redMul = function e(t) {
                i(this.red, "redMul works only with red numbers");
                this.red._verify2(this, t);
                return this.red.mul(this, t);
            };
            a.prototype.redIMul = function e(t) {
                i(this.red, "redMul works only with red numbers");
                this.red._verify2(this, t);
                return this.red.imul(this, t);
            };
            a.prototype.redSqr = function e() {
                i(this.red, "redSqr works only with red numbers");
                this.red._verify1(this);
                return this.red.sqr(this);
            };
            a.prototype.redISqr = function e() {
                i(this.red, "redISqr works only with red numbers");
                this.red._verify1(this);
                return this.red.isqr(this);
            };
            a.prototype.redSqrt = function e() {
                i(this.red, "redSqrt works only with red numbers");
                this.red._verify1(this);
                return this.red.sqrt(this);
            };
            a.prototype.redInvm = function e() {
                i(this.red, "redInvm works only with red numbers");
                this.red._verify1(this);
                return this.red.invm(this);
            };
            a.prototype.redNeg = function e() {
                i(this.red, "redNeg works only with red numbers");
                this.red._verify1(this);
                return this.red.neg(this);
            };
            a.prototype.redPow = function e(t) {
                i(this.red && !t.red, "redPow(normalNum)");
                this.red._verify1(this);
                return this.red.pow(this, t);
            };
            var y = {
                k256: null,
                p224: null,
                p192: null,
                p25519: null
            };
            function g(e, t) {
                this.name = e;
                this.p = new a(t, 16);
                this.n = this.p.bitLength();
                this.k = new a(1).iushln(this.n).isub(this.p);
                this.tmp = this._tmp();
            }
            g.prototype._tmp = function e() {
                var t = new a(null);
                t.words = new Array(Math.ceil(this.n / 13));
                return t;
            };
            g.prototype.ireduce = function e(t) {
                var r = t;
                var i;
                do {
                    this.split(r, this.tmp);
                    r = this.imulK(r);
                    r = r.iadd(this.tmp);
                    i = r.bitLength();
                } while (i > this.n);
                var n = i < this.n ? -1 : r.ucmp(this.p);
                if (n === 0) {
                    r.words[0] = 0;
                    r.length = 1;
                } else if (n > 0) {
                    r.isub(this.p);
                } else {
                    r.strip();
                }
                return r;
            };
            g.prototype.split = function e(t, r) {
                t.iushrn(this.n, 0, r);
            };
            g.prototype.imulK = function e(t) {
                return t.imul(this.k);
            };
            function w() {
                g.call(this, "k256", "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe fffffc2f");
            }
            n(w, g);
            w.prototype.split = function e(t, r) {
                var i = 4194303;
                var n = Math.min(t.length, 9);
                for (var a = 0; a < n; a++) {
                    r.words[a] = t.words[a];
                }
                r.length = n;
                if (t.length <= 9) {
                    t.words[0] = 0;
                    t.length = 1;
                    return;
                }
                var s = t.words[9];
                r.words[r.length++] = s & i;
                for (a = 10; a < t.length; a++) {
                    var f = t.words[a] | 0;
                    t.words[a - 10] = (f & i) << 4 | s >>> 22;
                    s = f;
                }
                s >>>= 22;
                t.words[a - 10] = s;
                if (s === 0 && t.length > 10) {
                    t.length -= 10;
                } else {
                    t.length -= 9;
                }
            };
            w.prototype.imulK = function e(t) {
                t.words[t.length] = 0;
                t.words[t.length + 1] = 0;
                t.length += 2;
                var r = 0;
                for (var i = 0; i < t.length; i++) {
                    var n = t.words[i] | 0;
                    r += n * 977;
                    t.words[i] = r & 67108863;
                    r = n * 64 + (r / 67108864 | 0);
                }
                if (t.words[t.length - 1] === 0) {
                    t.length--;
                    if (t.words[t.length - 1] === 0) {
                        t.length--;
                    }
                }
                return t;
            };
            function _() {
                g.call(this, "p224", "ffffffff ffffffff ffffffff ffffffff 00000000 00000000 00000001");
            }
            n(_, g);
            function S() {
                g.call(this, "p192", "ffffffff ffffffff ffffffff fffffffe ffffffff ffffffff");
            }
            n(S, g);
            function M() {
                g.call(this, "25519", "7fffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffed");
            }
            n(M, g);
            M.prototype.imulK = function e(t) {
                var r = 0;
                for (var i = 0; i < t.length; i++) {
                    var n = (t.words[i] | 0) * 19 + r;
                    var a = n & 67108863;
                    n >>>= 26;
                    t.words[i] = a;
                    r = n;
                }
                if (r !== 0) {
                    t.words[t.length++] = r;
                }
                return t;
            };
            a._prime = function e(t) {
                if (y[t]) return y[t];
                var e;
                if (t === "k256") {
                    e = new w();
                } else if (t === "p224") {
                    e = new _();
                } else if (t === "p192") {
                    e = new S();
                } else if (t === "p25519") {
                    e = new M();
                } else {
                    throw new Error("Unknown prime " + t);
                }
                y[t] = e;
                return e;
            };
            function k(e) {
                if (typeof e === "string") {
                    var t = a._prime(e);
                    this.m = t.p;
                    this.prime = t;
                } else {
                    i(e.gtn(1), "modulus must be greater than 1");
                    this.m = e;
                    this.prime = null;
                }
            }
            k.prototype._verify1 = function e(t) {
                i(t.negative === 0, "red works only with positives");
                i(t.red, "red works only with red numbers");
            };
            k.prototype._verify2 = function e(t, r) {
                i((t.negative | r.negative) === 0, "red works only with positives");
                i(t.red && t.red === r.red, "red works only with red numbers");
            };
            k.prototype.imod = function e(t) {
                if (this.prime) return this.prime.ireduce(t)._forceRed(this);
                return t.umod(this.m)._forceRed(this);
            };
            k.prototype.neg = function e(t) {
                if (t.isZero()) {
                    return t.clone();
                }
                return this.m.sub(t)._forceRed(this);
            };
            k.prototype.add = function e(t, r) {
                this._verify2(t, r);
                var i = t.add(r);
                if (i.cmp(this.m) >= 0) {
                    i.isub(this.m);
                }
                return i._forceRed(this);
            };
            k.prototype.iadd = function e(t, r) {
                this._verify2(t, r);
                var i = t.iadd(r);
                if (i.cmp(this.m) >= 0) {
                    i.isub(this.m);
                }
                return i;
            };
            k.prototype.sub = function e(t, r) {
                this._verify2(t, r);
                var i = t.sub(r);
                if (i.cmpn(0) < 0) {
                    i.iadd(this.m);
                }
                return i._forceRed(this);
            };
            k.prototype.isub = function e(t, r) {
                this._verify2(t, r);
                var i = t.isub(r);
                if (i.cmpn(0) < 0) {
                    i.iadd(this.m);
                }
                return i;
            };
            k.prototype.shl = function e(t, r) {
                this._verify1(t);
                return this.imod(t.ushln(r));
            };
            k.prototype.imul = function e(t, r) {
                this._verify2(t, r);
                return this.imod(t.imul(r));
            };
            k.prototype.mul = function e(t, r) {
                this._verify2(t, r);
                return this.imod(t.mul(r));
            };
            k.prototype.isqr = function e(t) {
                return this.imul(t, t.clone());
            };
            k.prototype.sqr = function e(t) {
                return this.mul(t, t);
            };
            k.prototype.sqrt = function e(t) {
                if (t.isZero()) return t.clone();
                var r = this.m.andln(3);
                i(r % 2 === 1);
                if (r === 3) {
                    var n = this.m.add(new a(1)).iushrn(2);
                    return this.pow(t, n);
                }
                var s = this.m.subn(1);
                var f = 0;
                while (!s.isZero() && s.andln(1) === 0) {
                    f++;
                    s.iushrn(1);
                }
                i(!s.isZero());
                var o = new a(1).toRed(this);
                var c = o.redNeg();
                var h = this.m.subn(1).iushrn(1);
                var u = this.m.bitLength();
                u = new a(2 * u * u).toRed(this);
                while (this.pow(u, h).cmp(c) !== 0) {
                    u.redIAdd(c);
                }
                var d = this.pow(u, s);
                var l = this.pow(t, s.addn(1).iushrn(1));
                var p = this.pow(t, s);
                var b = f;
                while (p.cmp(o) !== 0) {
                    var v = p;
                    for (var m = 0; v.cmp(o) !== 0; m++) {
                        v = v.redSqr();
                    }
                    i(m < b);
                    var y = this.pow(d, new a(1).iushln(b - m - 1));
                    l = l.redMul(y);
                    d = y.redSqr();
                    p = p.redMul(d);
                    b = m;
                }
                return l;
            };
            k.prototype.invm = function e(t) {
                var r = t._invmp(this.m);
                if (r.negative !== 0) {
                    r.negative = 0;
                    return this.imod(r).redNeg();
                } else {
                    return this.imod(r);
                }
            };
            k.prototype.pow = function e(t, r) {
                if (r.isZero()) return new a(1).toRed(this);
                if (r.cmpn(1) === 0) return t.clone();
                var i = 4;
                var n = new Array(1 << i);
                n[0] = new a(1).toRed(this);
                n[1] = t;
                for (var s = 2; s < n.length; s++) {
                    n[s] = this.mul(n[s - 1], t);
                }
                var f = n[0];
                var o = 0;
                var c = 0;
                var h = r.bitLength() % 26;
                if (h === 0) {
                    h = 26;
                }
                for (s = r.length - 1; s >= 0; s--) {
                    var u = r.words[s];
                    for (var d = h - 1; d >= 0; d--) {
                        var l = u >> d & 1;
                        if (f !== n[0]) {
                            f = this.sqr(f);
                        }
                        if (l === 0 && o === 0) {
                            c = 0;
                            continue;
                        }
                        o <<= 1;
                        o |= l;
                        c++;
                        if (c !== i && (s !== 0 || d !== 0)) continue;
                        f = this.mul(f, n[o]);
                        c = 0;
                        o = 0;
                    }
                    h = 26;
                }
                return f;
            };
            k.prototype.convertTo = function e(t) {
                var r = t.umod(this.m);
                return r === t ? r.clone() : r;
            };
            k.prototype.convertFrom = function e(t) {
                var r = t.clone();
                r.red = null;
                return r;
            };
            a.mont = function e(t) {
                return new E(t);
            };
            function E(e) {
                k.call(this, e);
                this.shift = this.m.bitLength();
                if (this.shift % 26 !== 0) {
                    this.shift += 26 - this.shift % 26;
                }
                this.r = new a(1).iushln(this.shift);
                this.r2 = this.imod(this.r.sqr());
                this.rinv = this.r._invmp(this.m);
                this.minv = this.rinv.mul(this.r).isubn(1).div(this.m);
                this.minv = this.minv.umod(this.r);
                this.minv = this.r.sub(this.minv);
            }
            n(E, k);
            E.prototype.convertTo = function e(t) {
                return this.imod(t.ushln(this.shift));
            };
            E.prototype.convertFrom = function e(t) {
                var r = this.imod(t.mul(this.rinv));
                r.red = null;
                return r;
            };
            E.prototype.imul = function e(t, r) {
                if (t.isZero() || r.isZero()) {
                    t.words[0] = 0;
                    t.length = 1;
                    return t;
                }
                var i = t.imul(r);
                var n = i.maskn(this.shift).mul(this.minv).imaskn(this.shift).mul(this.m);
                var a = i.isub(n).iushrn(this.shift);
                var s = a;
                if (a.cmp(this.m) >= 0) {
                    s = a.isub(this.m);
                } else if (a.cmpn(0) < 0) {
                    s = a.iadd(this.m);
                }
                return s._forceRed(this);
            };
            E.prototype.mul = function e(t, r) {
                if (t.isZero() || r.isZero()) return new a(0)._forceRed(this);
                var i = t.mul(r);
                var n = i.maskn(this.shift).mul(this.minv).imaskn(this.shift).mul(this.m);
                var s = i.isub(n).iushrn(this.shift);
                var f = s;
                if (s.cmp(this.m) >= 0) {
                    f = s.isub(this.m);
                } else if (s.cmpn(0) < 0) {
                    f = s.iadd(this.m);
                }
                return f._forceRed(this);
            };
            E.prototype.invm = function e(t) {
                var r = this.imod(t._invmp(this.m).mul(this.r2));
                return r._forceRed(this);
            };
        })(typeof t === "undefined" || t, this);
    }, {} ],
    33: [ function(e, t, r) {
        var i;
        t.exports = function e(t) {
            if (!i) i = new n(null);
            return i.generate(t);
        };
        function n(e) {
            this.rand = e;
        }
        t.exports.Rand = n;
        n.prototype.generate = function e(t) {
            return this._rand(t);
        };
        n.prototype._rand = function e(t) {
            if (this.rand.getBytes) return this.rand.getBytes(t);
            var r = new Uint8Array(t);
            for (var i = 0; i < r.length; i++) r[i] = this.rand.getByte();
            return r;
        };
        if (typeof self === "object") {
            if (self.crypto && self.crypto.getRandomValues) {
                n.prototype._rand = function e(t) {
                    var r = new Uint8Array(t);
                    self.crypto.getRandomValues(r);
                    return r;
                };
            } else if (self.msCrypto && self.msCrypto.getRandomValues) {
                n.prototype._rand = function e(t) {
                    var r = new Uint8Array(t);
                    self.msCrypto.getRandomValues(r);
                    return r;
                };
            } else if (typeof window === "object") {
                n.prototype._rand = function() {
                    throw new Error("Not implemented yet");
                };
            }
        } else {
            try {
                var a = e("crypto");
                if (typeof a.randomBytes !== "function") throw new Error("Not supported");
                n.prototype._rand = function e(t) {
                    return a.randomBytes(t);
                };
            } catch (e) {}
        }
    }, {
        crypto: 34
    } ],
    34: [ function(e, t, r) {}, {} ],
    35: [ function(e, t, r) {
        (function(e) {
            var t = Math.pow(2, 32);
            function i(e) {
                var r, i;
                r = e > t || e < 0 ? (i = Math.abs(e) % t, e < 0 ? t - i : i) : e;
                return r;
            }
            function n(e) {
                for (var t = 0; t < e.length; e++) {
                    e[t] = 0;
                }
                return false;
            }
            function a() {
                this.SBOX = [];
                this.INV_SBOX = [];
                this.SUB_MIX = [ [], [], [], [] ];
                this.INV_SUB_MIX = [ [], [], [], [] ];
                this.init();
                this.RCON = [ 0, 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 ];
            }
            a.prototype.init = function() {
                var e, t, r, i, n, a, s, f, o, c;
                e = function() {
                    var e, r;
                    r = [];
                    for (t = e = 0; e < 256; t = ++e) {
                        if (t < 128) {
                            r.push(t << 1);
                        } else {
                            r.push(t << 1 ^ 283);
                        }
                    }
                    return r;
                }();
                n = 0;
                o = 0;
                for (t = c = 0; c < 256; t = ++c) {
                    r = o ^ o << 1 ^ o << 2 ^ o << 3 ^ o << 4;
                    r = r >>> 8 ^ r & 255 ^ 99;
                    this.SBOX[n] = r;
                    this.INV_SBOX[r] = n;
                    a = e[n];
                    s = e[a];
                    f = e[s];
                    i = e[r] * 257 ^ r * 16843008;
                    this.SUB_MIX[0][n] = i << 24 | i >>> 8;
                    this.SUB_MIX[1][n] = i << 16 | i >>> 16;
                    this.SUB_MIX[2][n] = i << 8 | i >>> 24;
                    this.SUB_MIX[3][n] = i;
                    i = f * 16843009 ^ s * 65537 ^ a * 257 ^ n * 16843008;
                    this.INV_SUB_MIX[0][r] = i << 24 | i >>> 8;
                    this.INV_SUB_MIX[1][r] = i << 16 | i >>> 16;
                    this.INV_SUB_MIX[2][r] = i << 8 | i >>> 24;
                    this.INV_SUB_MIX[3][r] = i;
                    if (n === 0) {
                        n = o = 1;
                    } else {
                        n = a ^ e[e[e[f ^ a]]];
                        o ^= e[e[o]];
                    }
                }
                return true;
            };
            var s = new a();
            o.blockSize = 4 * 4;
            o.prototype.blockSize = o.blockSize;
            o.keySize = 256 / 8;
            o.prototype.keySize = o.keySize;
            function f(e) {
                var t = e.length / 4;
                var r = new Array(t);
                var i = -1;
                while (++i < t) {
                    r[i] = e.readUInt32BE(i * 4);
                }
                return r;
            }
            function o(e) {
                this._key = f(e);
                this._doReset();
            }
            o.prototype._doReset = function() {
                var e, t, r, i, n, a;
                r = this._key;
                t = r.length;
                this._nRounds = t + 6;
                n = (this._nRounds + 1) * 4;
                this._keySchedule = [];
                for (i = 0; i < n; i++) {
                    this._keySchedule[i] = i < t ? r[i] : (a = this._keySchedule[i - 1], i % t === 0 ? (a = a << 8 | a >>> 24, 
                    a = s.SBOX[a >>> 24] << 24 | s.SBOX[a >>> 16 & 255] << 16 | s.SBOX[a >>> 8 & 255] << 8 | s.SBOX[a & 255], 
                    a ^= s.RCON[i / t | 0] << 24) : t > 6 && i % t === 4 ? a = s.SBOX[a >>> 24] << 24 | s.SBOX[a >>> 16 & 255] << 16 | s.SBOX[a >>> 8 & 255] << 8 | s.SBOX[a & 255] : void 0, 
                    this._keySchedule[i - t] ^ a);
                }
                this._invKeySchedule = [];
                for (e = 0; e < n; e++) {
                    i = n - e;
                    a = this._keySchedule[i - (e % 4 ? 0 : 4)];
                    this._invKeySchedule[e] = e < 4 || i <= 4 ? a : s.INV_SUB_MIX[0][s.SBOX[a >>> 24]] ^ s.INV_SUB_MIX[1][s.SBOX[a >>> 16 & 255]] ^ s.INV_SUB_MIX[2][s.SBOX[a >>> 8 & 255]] ^ s.INV_SUB_MIX[3][s.SBOX[a & 255]];
                }
                return true;
            };
            o.prototype.encryptBlock = function(t) {
                t = f(new e(t));
                var r = this._doCryptBlock(t, this._keySchedule, s.SUB_MIX, s.SBOX);
                var i = new e(16);
                i.writeUInt32BE(r[0], 0);
                i.writeUInt32BE(r[1], 4);
                i.writeUInt32BE(r[2], 8);
                i.writeUInt32BE(r[3], 12);
                return i;
            };
            o.prototype.decryptBlock = function(t) {
                t = f(new e(t));
                var r = [ t[3], t[1] ];
                t[1] = r[0];
                t[3] = r[1];
                var i = this._doCryptBlock(t, this._invKeySchedule, s.INV_SUB_MIX, s.INV_SBOX);
                var n = new e(16);
                n.writeUInt32BE(i[0], 0);
                n.writeUInt32BE(i[3], 4);
                n.writeUInt32BE(i[2], 8);
                n.writeUInt32BE(i[1], 12);
                return n;
            };
            o.prototype.scrub = function() {
                n(this._keySchedule);
                n(this._invKeySchedule);
                n(this._key);
            };
            o.prototype._doCryptBlock = function(e, t, r, n) {
                var a, s, f, o, c, h, u, d, l;
                s = e[0] ^ t[0];
                f = e[1] ^ t[1];
                o = e[2] ^ t[2];
                c = e[3] ^ t[3];
                a = 4;
                for (var p = 1; p < this._nRounds; p++) {
                    h = r[0][s >>> 24] ^ r[1][f >>> 16 & 255] ^ r[2][o >>> 8 & 255] ^ r[3][c & 255] ^ t[a++];
                    u = r[0][f >>> 24] ^ r[1][o >>> 16 & 255] ^ r[2][c >>> 8 & 255] ^ r[3][s & 255] ^ t[a++];
                    d = r[0][o >>> 24] ^ r[1][c >>> 16 & 255] ^ r[2][s >>> 8 & 255] ^ r[3][f & 255] ^ t[a++];
                    l = r[0][c >>> 24] ^ r[1][s >>> 16 & 255] ^ r[2][f >>> 8 & 255] ^ r[3][o & 255] ^ t[a++];
                    s = h;
                    f = u;
                    o = d;
                    c = l;
                }
                h = (n[s >>> 24] << 24 | n[f >>> 16 & 255] << 16 | n[o >>> 8 & 255] << 8 | n[c & 255]) ^ t[a++];
                u = (n[f >>> 24] << 24 | n[o >>> 16 & 255] << 16 | n[c >>> 8 & 255] << 8 | n[s & 255]) ^ t[a++];
                d = (n[o >>> 24] << 24 | n[c >>> 16 & 255] << 16 | n[s >>> 8 & 255] << 8 | n[f & 255]) ^ t[a++];
                l = (n[c >>> 24] << 24 | n[s >>> 16 & 255] << 16 | n[f >>> 8 & 255] << 8 | n[o & 255]) ^ t[a++];
                return [ i(h), i(u), i(d), i(l) ];
            };
            r.AES = o;
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61
    } ],
    36: [ function(e, t, r) {
        (function(r) {
            var i = e("./aes");
            var n = e("cipher-base");
            var a = e("inherits");
            var s = e("./ghash");
            var f = e("buffer-xor");
            a(o, n);
            t.exports = o;
            function o(e, t, a, f) {
                if (!(this instanceof o)) {
                    return new o(e, t, a);
                }
                n.call(this);
                this._finID = r.concat([ a, new r([ 0, 0, 0, 1 ]) ]);
                a = r.concat([ a, new r([ 0, 0, 0, 2 ]) ]);
                this._cipher = new i.AES(t);
                this._prev = new r(a.length);
                this._cache = new r("");
                this._secCache = new r("");
                this._decrypt = f;
                this._alen = 0;
                this._len = 0;
                a.copy(this._prev);
                this._mode = e;
                var c = new r(4);
                c.fill(0);
                this._ghash = new s(this._cipher.encryptBlock(c));
                this._authTag = null;
                this._called = false;
            }
            o.prototype._update = function(e) {
                if (!this._called && this._alen) {
                    var t = 16 - this._alen % 16;
                    if (t < 16) {
                        t = new r(t);
                        t.fill(0);
                        this._ghash.update(t);
                    }
                }
                this._called = true;
                var i = this._mode.encrypt(this, e);
                if (this._decrypt) {
                    this._ghash.update(e);
                } else {
                    this._ghash.update(i);
                }
                this._len += e.length;
                return i;
            };
            o.prototype._final = function() {
                if (this._decrypt && !this._authTag) {
                    throw new Error("Unsupported state or unable to authenticate data");
                }
                var e = f(this._ghash.final(this._alen * 8, this._len * 8), this._cipher.encryptBlock(this._finID));
                if (this._decrypt) {
                    if (c(e, this._authTag)) {
                        throw new Error("Unsupported state or unable to authenticate data");
                    }
                } else {
                    this._authTag = e;
                }
                this._cipher.scrub();
            };
            o.prototype.getAuthTag = function e() {
                if (!this._decrypt && r.isBuffer(this._authTag)) {
                    return this._authTag;
                } else {
                    throw new Error("Attempting to get auth tag in unsupported state");
                }
            };
            o.prototype.setAuthTag = function e(t) {
                if (this._decrypt) {
                    this._authTag = t;
                } else {
                    throw new Error("Attempting to set auth tag in unsupported state");
                }
            };
            o.prototype.setAAD = function e(t) {
                if (!this._called) {
                    this._ghash.update(t);
                    this._alen += t.length;
                } else {
                    throw new Error("Attempting to set AAD in unsupported state");
                }
            };
            function c(e, t) {
                var r = 0;
                if (e.length !== t.length) {
                    r++;
                }
                var i = Math.min(e.length, t.length);
                var n = -1;
                while (++n < i) {
                    r += e[n] ^ t[n];
                }
                return r;
            }
        }).call(this, e("buffer").Buffer);
    }, {
        "./aes": 35,
        "./ghash": 40,
        buffer: 61,
        "buffer-xor": 60,
        "cipher-base": 62,
        inherits: 115
    } ],
    37: [ function(e, t, r) {
        var i = e("./encrypter");
        r.createCipher = r.Cipher = i.createCipher;
        r.createCipheriv = r.Cipheriv = i.createCipheriv;
        var n = e("./decrypter");
        r.createDecipher = r.Decipher = n.createDecipher;
        r.createDecipheriv = r.Decipheriv = n.createDecipheriv;
        var a = e("./modes");
        function s() {
            return Object.keys(a);
        }
        r.listCiphers = r.getCiphers = s;
    }, {
        "./decrypter": 38,
        "./encrypter": 39,
        "./modes": 41
    } ],
    38: [ function(e, t, r) {
        (function(t) {
            var i = e("./aes");
            var n = e("cipher-base");
            var a = e("inherits");
            var s = e("./modes");
            var f = e("./streamCipher");
            var o = e("./authCipher");
            var c = e("evp_bytestokey");
            a(h, n);
            function h(e, r, a) {
                if (!(this instanceof h)) {
                    return new h(e, r, a);
                }
                n.call(this);
                this._cache = new u();
                this._last = void 0;
                this._cipher = new i.AES(r);
                this._prev = new t(a.length);
                a.copy(this._prev);
                this._mode = e;
                this._autopadding = true;
            }
            h.prototype._update = function(e) {
                this._cache.add(e);
                var r;
                var i;
                var n = [];
                while (r = this._cache.get(this._autopadding)) {
                    i = this._mode.decrypt(this, r);
                    n.push(i);
                }
                return t.concat(n);
            };
            h.prototype._final = function() {
                var e = this._cache.flush();
                if (this._autopadding) {
                    return d(this._mode.decrypt(this, e));
                } else if (e) {
                    throw new Error("data not multiple of block length");
                }
            };
            h.prototype.setAutoPadding = function(e) {
                this._autopadding = !!e;
                return this;
            };
            function u() {
                if (!(this instanceof u)) {
                    return new u();
                }
                this.cache = new t("");
            }
            u.prototype.add = function(e) {
                this.cache = t.concat([ this.cache, e ]);
            };
            u.prototype.get = function(e) {
                var t;
                if (e) {
                    if (this.cache.length > 16) {
                        t = this.cache.slice(0, 16);
                        this.cache = this.cache.slice(16);
                        return t;
                    }
                } else {
                    if (this.cache.length >= 16) {
                        t = this.cache.slice(0, 16);
                        this.cache = this.cache.slice(16);
                        return t;
                    }
                }
                return null;
            };
            u.prototype.flush = function() {
                if (this.cache.length) {
                    return this.cache;
                }
            };
            function d(e) {
                var t = e[15];
                var r = -1;
                while (++r < t) {
                    if (e[r + (16 - t)] !== t) {
                        throw new Error("unable to decrypt data");
                    }
                }
                if (t === 16) {
                    return;
                }
                return e.slice(0, 16 - t);
            }
            var l = {
                ECB: e("./modes/ecb"),
                CBC: e("./modes/cbc"),
                CFB: e("./modes/cfb"),
                CFB8: e("./modes/cfb8"),
                CFB1: e("./modes/cfb1"),
                OFB: e("./modes/ofb"),
                CTR: e("./modes/ctr"),
                GCM: e("./modes/ctr")
            };
            function p(e, r, i) {
                var n = s[e.toLowerCase()];
                if (!n) {
                    throw new TypeError("invalid suite type");
                }
                if (typeof i === "string") {
                    i = new t(i);
                }
                if (typeof r === "string") {
                    r = new t(r);
                }
                if (r.length !== n.key / 8) {
                    throw new TypeError("invalid key length " + r.length);
                }
                if (i.length !== n.iv) {
                    throw new TypeError("invalid iv length " + i.length);
                }
                if (n.type === "stream") {
                    return new f(l[n.mode], r, i, true);
                } else if (n.type === "auth") {
                    return new o(l[n.mode], r, i, true);
                }
                return new h(l[n.mode], r, i);
            }
            function b(e, t) {
                var r = s[e.toLowerCase()];
                if (!r) {
                    throw new TypeError("invalid suite type");
                }
                var i = c(t, false, r.key, r.iv);
                return p(e, i.key, i.iv);
            }
            r.createDecipher = b;
            r.createDecipheriv = p;
        }).call(this, e("buffer").Buffer);
    }, {
        "./aes": 35,
        "./authCipher": 36,
        "./modes": 41,
        "./modes/cbc": 42,
        "./modes/cfb": 43,
        "./modes/cfb1": 44,
        "./modes/cfb8": 45,
        "./modes/ctr": 46,
        "./modes/ecb": 47,
        "./modes/ofb": 48,
        "./streamCipher": 49,
        buffer: 61,
        "cipher-base": 62,
        evp_bytestokey: 98,
        inherits: 115
    } ],
    39: [ function(e, t, r) {
        (function(t) {
            var i = e("./aes");
            var n = e("cipher-base");
            var a = e("inherits");
            var s = e("./modes");
            var f = e("evp_bytestokey");
            var o = e("./streamCipher");
            var c = e("./authCipher");
            a(h, n);
            function h(e, r, a) {
                if (!(this instanceof h)) {
                    return new h(e, r, a);
                }
                n.call(this);
                this._cache = new u();
                this._cipher = new i.AES(r);
                this._prev = new t(a.length);
                a.copy(this._prev);
                this._mode = e;
                this._autopadding = true;
            }
            h.prototype._update = function(e) {
                this._cache.add(e);
                var r;
                var i;
                var n = [];
                while (r = this._cache.get()) {
                    i = this._mode.encrypt(this, r);
                    n.push(i);
                }
                return t.concat(n);
            };
            h.prototype._final = function() {
                var e = this._cache.flush();
                if (this._autopadding) {
                    e = this._mode.encrypt(this, e);
                    this._cipher.scrub();
                    return e;
                } else if (e.toString("hex") !== "10101010101010101010101010101010") {
                    this._cipher.scrub();
                    throw new Error("data not multiple of block length");
                }
            };
            h.prototype.setAutoPadding = function(e) {
                this._autopadding = !!e;
                return this;
            };
            function u() {
                if (!(this instanceof u)) {
                    return new u();
                }
                this.cache = new t("");
            }
            u.prototype.add = function(e) {
                this.cache = t.concat([ this.cache, e ]);
            };
            u.prototype.get = function() {
                if (this.cache.length > 15) {
                    var e = this.cache.slice(0, 16);
                    this.cache = this.cache.slice(16);
                    return e;
                }
                return null;
            };
            u.prototype.flush = function() {
                var e = 16 - this.cache.length;
                var r = new t(e);
                var i = -1;
                while (++i < e) {
                    r.writeUInt8(e, i);
                }
                var n = t.concat([ this.cache, r ]);
                return n;
            };
            var d = {
                ECB: e("./modes/ecb"),
                CBC: e("./modes/cbc"),
                CFB: e("./modes/cfb"),
                CFB8: e("./modes/cfb8"),
                CFB1: e("./modes/cfb1"),
                OFB: e("./modes/ofb"),
                CTR: e("./modes/ctr"),
                GCM: e("./modes/ctr")
            };
            function l(e, r, i) {
                var n = s[e.toLowerCase()];
                if (!n) {
                    throw new TypeError("invalid suite type");
                }
                if (typeof i === "string") {
                    i = new t(i);
                }
                if (typeof r === "string") {
                    r = new t(r);
                }
                if (r.length !== n.key / 8) {
                    throw new TypeError("invalid key length " + r.length);
                }
                if (i.length !== n.iv) {
                    throw new TypeError("invalid iv length " + i.length);
                }
                if (n.type === "stream") {
                    return new o(d[n.mode], r, i);
                } else if (n.type === "auth") {
                    return new c(d[n.mode], r, i);
                }
                return new h(d[n.mode], r, i);
            }
            function p(e, t) {
                var r = s[e.toLowerCase()];
                if (!r) {
                    throw new TypeError("invalid suite type");
                }
                var i = f(t, false, r.key, r.iv);
                return l(e, i.key, i.iv);
            }
            r.createCipheriv = l;
            r.createCipher = p;
        }).call(this, e("buffer").Buffer);
    }, {
        "./aes": 35,
        "./authCipher": 36,
        "./modes": 41,
        "./modes/cbc": 42,
        "./modes/cfb": 43,
        "./modes/cfb1": 44,
        "./modes/cfb8": 45,
        "./modes/ctr": 46,
        "./modes/ecb": 47,
        "./modes/ofb": 48,
        "./streamCipher": 49,
        buffer: 61,
        "cipher-base": 62,
        evp_bytestokey: 98,
        inherits: 115
    } ],
    40: [ function(e, t, r) {
        (function(e) {
            var r = new e(16);
            r.fill(0);
            t.exports = i;
            function i(t) {
                this.h = t;
                this.state = new e(16);
                this.state.fill(0);
                this.cache = new e("");
            }
            i.prototype.ghash = function(e) {
                var t = -1;
                while (++t < e.length) {
                    this.state[t] ^= e[t];
                }
                this._multiply();
            };
            i.prototype._multiply = function() {
                var e = n(this.h);
                var t = [ 0, 0, 0, 0 ];
                var r, i, s;
                var f = -1;
                while (++f < 128) {
                    i = (this.state[~~(f / 8)] & 1 << 7 - f % 8) !== 0;
                    if (i) {
                        t = o(t, e);
                    }
                    s = (e[3] & 1) !== 0;
                    for (r = 3; r > 0; r--) {
                        e[r] = e[r] >>> 1 | (e[r - 1] & 1) << 31;
                    }
                    e[0] = e[0] >>> 1;
                    if (s) {
                        e[0] = e[0] ^ 225 << 24;
                    }
                }
                this.state = a(t);
            };
            i.prototype.update = function(t) {
                this.cache = e.concat([ this.cache, t ]);
                var r;
                while (this.cache.length >= 16) {
                    r = this.cache.slice(0, 16);
                    this.cache = this.cache.slice(16);
                    this.ghash(r);
                }
            };
            i.prototype.final = function(t, i) {
                if (this.cache.length) {
                    this.ghash(e.concat([ this.cache, r ], 16));
                }
                this.ghash(a([ 0, t, 0, i ]));
                return this.state;
            };
            function n(e) {
                return [ e.readUInt32BE(0), e.readUInt32BE(4), e.readUInt32BE(8), e.readUInt32BE(12) ];
            }
            function a(t) {
                t = t.map(f);
                var r = new e(16);
                r.writeUInt32BE(t[0], 0);
                r.writeUInt32BE(t[1], 4);
                r.writeUInt32BE(t[2], 8);
                r.writeUInt32BE(t[3], 12);
                return r;
            }
            var s = Math.pow(2, 32);
            function f(e) {
                var t, r;
                t = e > s || e < 0 ? (r = Math.abs(e) % s, e < 0 ? s - r : r) : e;
                return t;
            }
            function o(e, t) {
                return [ e[0] ^ t[0], e[1] ^ t[1], e[2] ^ t[2], e[3] ^ t[3] ];
            }
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61
    } ],
    41: [ function(e, t, r) {
        r["aes-128-ecb"] = {
            cipher: "AES",
            key: 128,
            iv: 0,
            mode: "ECB",
            type: "block"
        };
        r["aes-192-ecb"] = {
            cipher: "AES",
            key: 192,
            iv: 0,
            mode: "ECB",
            type: "block"
        };
        r["aes-256-ecb"] = {
            cipher: "AES",
            key: 256,
            iv: 0,
            mode: "ECB",
            type: "block"
        };
        r["aes-128-cbc"] = {
            cipher: "AES",
            key: 128,
            iv: 16,
            mode: "CBC",
            type: "block"
        };
        r["aes-192-cbc"] = {
            cipher: "AES",
            key: 192,
            iv: 16,
            mode: "CBC",
            type: "block"
        };
        r["aes-256-cbc"] = {
            cipher: "AES",
            key: 256,
            iv: 16,
            mode: "CBC",
            type: "block"
        };
        r["aes128"] = r["aes-128-cbc"];
        r["aes192"] = r["aes-192-cbc"];
        r["aes256"] = r["aes-256-cbc"];
        r["aes-128-cfb"] = {
            cipher: "AES",
            key: 128,
            iv: 16,
            mode: "CFB",
            type: "stream"
        };
        r["aes-192-cfb"] = {
            cipher: "AES",
            key: 192,
            iv: 16,
            mode: "CFB",
            type: "stream"
        };
        r["aes-256-cfb"] = {
            cipher: "AES",
            key: 256,
            iv: 16,
            mode: "CFB",
            type: "stream"
        };
        r["aes-128-cfb8"] = {
            cipher: "AES",
            key: 128,
            iv: 16,
            mode: "CFB8",
            type: "stream"
        };
        r["aes-192-cfb8"] = {
            cipher: "AES",
            key: 192,
            iv: 16,
            mode: "CFB8",
            type: "stream"
        };
        r["aes-256-cfb8"] = {
            cipher: "AES",
            key: 256,
            iv: 16,
            mode: "CFB8",
            type: "stream"
        };
        r["aes-128-cfb1"] = {
            cipher: "AES",
            key: 128,
            iv: 16,
            mode: "CFB1",
            type: "stream"
        };
        r["aes-192-cfb1"] = {
            cipher: "AES",
            key: 192,
            iv: 16,
            mode: "CFB1",
            type: "stream"
        };
        r["aes-256-cfb1"] = {
            cipher: "AES",
            key: 256,
            iv: 16,
            mode: "CFB1",
            type: "stream"
        };
        r["aes-128-ofb"] = {
            cipher: "AES",
            key: 128,
            iv: 16,
            mode: "OFB",
            type: "stream"
        };
        r["aes-192-ofb"] = {
            cipher: "AES",
            key: 192,
            iv: 16,
            mode: "OFB",
            type: "stream"
        };
        r["aes-256-ofb"] = {
            cipher: "AES",
            key: 256,
            iv: 16,
            mode: "OFB",
            type: "stream"
        };
        r["aes-128-ctr"] = {
            cipher: "AES",
            key: 128,
            iv: 16,
            mode: "CTR",
            type: "stream"
        };
        r["aes-192-ctr"] = {
            cipher: "AES",
            key: 192,
            iv: 16,
            mode: "CTR",
            type: "stream"
        };
        r["aes-256-ctr"] = {
            cipher: "AES",
            key: 256,
            iv: 16,
            mode: "CTR",
            type: "stream"
        };
        r["aes-128-gcm"] = {
            cipher: "AES",
            key: 128,
            iv: 12,
            mode: "GCM",
            type: "auth"
        };
        r["aes-192-gcm"] = {
            cipher: "AES",
            key: 192,
            iv: 12,
            mode: "GCM",
            type: "auth"
        };
        r["aes-256-gcm"] = {
            cipher: "AES",
            key: 256,
            iv: 12,
            mode: "GCM",
            type: "auth"
        };
    }, {} ],
    42: [ function(e, t, r) {
        var i = e("buffer-xor");
        r.encrypt = function(e, t) {
            var r = i(t, e._prev);
            e._prev = e._cipher.encryptBlock(r);
            return e._prev;
        };
        r.decrypt = function(e, t) {
            var r = e._prev;
            e._prev = t;
            var n = e._cipher.decryptBlock(t);
            return i(n, r);
        };
    }, {
        "buffer-xor": 60
    } ],
    43: [ function(e, t, r) {
        (function(t) {
            var i = e("buffer-xor");
            r.encrypt = function(e, r, i) {
                var a = new t("");
                var s;
                while (r.length) {
                    if (e._cache.length === 0) {
                        e._cache = e._cipher.encryptBlock(e._prev);
                        e._prev = new t("");
                    }
                    if (e._cache.length <= r.length) {
                        s = e._cache.length;
                        a = t.concat([ a, n(e, r.slice(0, s), i) ]);
                        r = r.slice(s);
                    } else {
                        a = t.concat([ a, n(e, r, i) ]);
                        break;
                    }
                }
                return a;
            };
            function n(e, r, n) {
                var a = r.length;
                var s = i(r, e._cache);
                e._cache = e._cache.slice(a);
                e._prev = t.concat([ e._prev, n ? r : s ]);
                return s;
            }
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61,
        "buffer-xor": 60
    } ],
    44: [ function(e, t, r) {
        (function(e) {
            function t(e, t, r) {
                var n;
                var a = -1;
                var s = 8;
                var f = 0;
                var o, c;
                while (++a < s) {
                    n = e._cipher.encryptBlock(e._prev);
                    o = t & 1 << 7 - a ? 128 : 0;
                    c = n[0] ^ o;
                    f += (c & 128) >> a % 8;
                    e._prev = i(e._prev, r ? o : c);
                }
                return f;
            }
            r.encrypt = function(r, i, n) {
                var a = i.length;
                var s = new e(a);
                var f = -1;
                while (++f < a) {
                    s[f] = t(r, i[f], n);
                }
                return s;
            };
            function i(t, r) {
                var i = t.length;
                var n = -1;
                var a = new e(t.length);
                t = e.concat([ t, new e([ r ]) ]);
                while (++n < i) {
                    a[n] = t[n] << 1 | t[n + 1] >> 7;
                }
                return a;
            }
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61
    } ],
    45: [ function(e, t, r) {
        (function(e) {
            function t(t, r, i) {
                var n = t._cipher.encryptBlock(t._prev);
                var a = n[0] ^ r;
                t._prev = e.concat([ t._prev.slice(1), new e([ i ? r : a ]) ]);
                return a;
            }
            r.encrypt = function(r, i, n) {
                var a = i.length;
                var s = new e(a);
                var f = -1;
                while (++f < a) {
                    s[f] = t(r, i[f], n);
                }
                return s;
            };
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61
    } ],
    46: [ function(e, t, r) {
        (function(t) {
            var i = e("buffer-xor");
            function n(e) {
                var t = e.length;
                var r;
                while (t--) {
                    r = e.readUInt8(t);
                    if (r === 255) {
                        e.writeUInt8(0, t);
                    } else {
                        r++;
                        e.writeUInt8(r, t);
                        break;
                    }
                }
            }
            function a(e) {
                var t = e._cipher.encryptBlock(e._prev);
                n(e._prev);
                return t;
            }
            r.encrypt = function(e, r) {
                while (e._cache.length < r.length) {
                    e._cache = t.concat([ e._cache, a(e) ]);
                }
                var n = e._cache.slice(0, r.length);
                e._cache = e._cache.slice(r.length);
                return i(r, n);
            };
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61,
        "buffer-xor": 60
    } ],
    47: [ function(e, t, r) {
        r.encrypt = function(e, t) {
            return e._cipher.encryptBlock(t);
        };
        r.decrypt = function(e, t) {
            return e._cipher.decryptBlock(t);
        };
    }, {} ],
    48: [ function(e, t, r) {
        (function(t) {
            var i = e("buffer-xor");
            function n(e) {
                e._prev = e._cipher.encryptBlock(e._prev);
                return e._prev;
            }
            r.encrypt = function(e, r) {
                while (e._cache.length < r.length) {
                    e._cache = t.concat([ e._cache, n(e) ]);
                }
                var a = e._cache.slice(0, r.length);
                e._cache = e._cache.slice(r.length);
                return i(r, a);
            };
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61,
        "buffer-xor": 60
    } ],
    49: [ function(e, t, r) {
        (function(r) {
            var i = e("./aes");
            var n = e("cipher-base");
            var a = e("inherits");
            a(s, n);
            t.exports = s;
            function s(e, t, a, f) {
                if (!(this instanceof s)) {
                    return new s(e, t, a);
                }
                n.call(this);
                this._cipher = new i.AES(t);
                this._prev = new r(a.length);
                this._cache = new r("");
                this._secCache = new r("");
                this._decrypt = f;
                a.copy(this._prev);
                this._mode = e;
            }
            s.prototype._update = function(e) {
                return this._mode.encrypt(this, e, this._decrypt);
            };
            s.prototype._final = function() {
                this._cipher.scrub();
            };
        }).call(this, e("buffer").Buffer);
    }, {
        "./aes": 35,
        buffer: 61,
        "cipher-base": 62,
        inherits: 115
    } ],
    50: [ function(e, t, r) {
        var i = e("evp_bytestokey");
        var n = e("browserify-aes/browser");
        var a = e("browserify-des");
        var s = e("browserify-des/modes");
        var f = e("browserify-aes/modes");
        function o(e, t) {
            var r, n;
            e = e.toLowerCase();
            if (f[e]) {
                r = f[e].key;
                n = f[e].iv;
            } else if (s[e]) {
                r = s[e].key * 8;
                n = s[e].iv;
            } else {
                throw new TypeError("invalid suite type");
            }
            var a = i(t, false, r, n);
            return h(e, a.key, a.iv);
        }
        function c(e, t) {
            var r, n;
            e = e.toLowerCase();
            if (f[e]) {
                r = f[e].key;
                n = f[e].iv;
            } else if (s[e]) {
                r = s[e].key * 8;
                n = s[e].iv;
            } else {
                throw new TypeError("invalid suite type");
            }
            var a = i(t, false, r, n);
            return u(e, a.key, a.iv);
        }
        function h(e, t, r) {
            e = e.toLowerCase();
            if (f[e]) {
                return n.createCipheriv(e, t, r);
            } else if (s[e]) {
                return new a({
                    key: t,
                    iv: r,
                    mode: e
                });
            } else {
                throw new TypeError("invalid suite type");
            }
        }
        function u(e, t, r) {
            e = e.toLowerCase();
            if (f[e]) {
                return n.createDecipheriv(e, t, r);
            } else if (s[e]) {
                return new a({
                    key: t,
                    iv: r,
                    mode: e,
                    decrypt: true
                });
            } else {
                throw new TypeError("invalid suite type");
            }
        }
        r.createCipher = r.Cipher = o;
        r.createCipheriv = r.Cipheriv = h;
        r.createDecipher = r.Decipher = c;
        r.createDecipheriv = r.Decipheriv = u;
        function d() {
            return Object.keys(s).concat(n.getCiphers());
        }
        r.listCiphers = r.getCiphers = d;
    }, {
        "browserify-aes/browser": 37,
        "browserify-aes/modes": 41,
        "browserify-des": 51,
        "browserify-des/modes": 52,
        evp_bytestokey: 98
    } ],
    51: [ function(e, t, r) {
        (function(r) {
            var i = e("cipher-base");
            var n = e("des.js");
            var a = e("inherits");
            var s = {
                "des-ede3-cbc": n.CBC.instantiate(n.EDE),
                "des-ede3": n.EDE,
                "des-ede-cbc": n.CBC.instantiate(n.EDE),
                "des-ede": n.EDE,
                "des-cbc": n.CBC.instantiate(n.DES),
                "des-ecb": n.DES
            };
            s.des = s["des-cbc"];
            s.des3 = s["des-ede3-cbc"];
            t.exports = f;
            a(f, i);
            function f(e) {
                i.call(this);
                var t = e.mode.toLowerCase();
                var n = s[t];
                var a;
                if (e.decrypt) {
                    a = "decrypt";
                } else {
                    a = "encrypt";
                }
                var f = e.key;
                if (t === "des-ede" || t === "des-ede-cbc") {
                    f = r.concat([ f, f.slice(0, 8) ]);
                }
                var o = e.iv;
                this._des = n.create({
                    key: f,
                    iv: o,
                    type: a
                });
            }
            f.prototype._update = function(e) {
                return new r(this._des.update(e));
            };
            f.prototype._final = function() {
                return new r(this._des.final());
            };
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61,
        "cipher-base": 62,
        "des.js": 71,
        inherits: 115
    } ],
    52: [ function(e, t, r) {
        r["des-ecb"] = {
            key: 8,
            iv: 0
        };
        r["des-cbc"] = r.des = {
            key: 8,
            iv: 8
        };
        r["des-ede3-cbc"] = r.des3 = {
            key: 24,
            iv: 8
        };
        r["des-ede3"] = {
            key: 24,
            iv: 0
        };
        r["des-ede-cbc"] = {
            key: 16,
            iv: 8
        };
        r["des-ede"] = {
            key: 16,
            iv: 0
        };
    }, {} ],
    53: [ function(e, t, r) {
        (function(r) {
            var i = e("bn.js");
            var n = e("randombytes");
            t.exports = s;
            function a(e) {
                var t = f(e);
                var r = t.toRed(i.mont(e.modulus)).redPow(new i(e.publicExponent)).fromRed();
                return {
                    blinder: r,
                    unblinder: t.invm(e.modulus)
                };
            }
            function s(e, t) {
                var n = a(t);
                var s = t.modulus.byteLength();
                var f = i.mont(t.modulus);
                var o = new i(e).mul(n.blinder).umod(t.modulus);
                var c = o.toRed(i.mont(t.prime1));
                var h = o.toRed(i.mont(t.prime2));
                var u = t.coefficient;
                var d = t.prime1;
                var l = t.prime2;
                var p = c.redPow(t.exponent1);
                var b = h.redPow(t.exponent2);
                p = p.fromRed();
                b = b.fromRed();
                var v = p.isub(b).imul(u).umod(d);
                v.imul(l);
                b.iadd(v);
                return new r(b.imul(n.unblinder).umod(t.modulus).toArray(false, s));
            }
            s.getr = f;
            function f(e) {
                var t = e.modulus.byteLength();
                var r = new i(n(t));
                while (r.cmp(e.modulus) >= 0 || !r.umod(e.prime1) || !r.umod(e.prime2)) {
                    r = new i(n(t));
                }
                return r;
            }
        }).call(this, e("buffer").Buffer);
    }, {
        "bn.js": 32,
        buffer: 61,
        randombytes: 139
    } ],
    54: [ function(e, t, r) {
        t.exports = e("./browser/algorithms.json");
    }, {
        "./browser/algorithms.json": 55
    } ],
    55: [ function(e, t, r) {
        t.exports = {
            sha224WithRSAEncryption: {
                sign: "rsa",
                hash: "sha224",
                id: "302d300d06096086480165030402040500041c"
            },
            "RSA-SHA224": {
                sign: "ecdsa/rsa",
                hash: "sha224",
                id: "302d300d06096086480165030402040500041c"
            },
            sha256WithRSAEncryption: {
                sign: "rsa",
                hash: "sha256",
                id: "3031300d060960864801650304020105000420"
            },
            "RSA-SHA256": {
                sign: "ecdsa/rsa",
                hash: "sha256",
                id: "3031300d060960864801650304020105000420"
            },
            sha384WithRSAEncryption: {
                sign: "rsa",
                hash: "sha384",
                id: "3041300d060960864801650304020205000430"
            },
            "RSA-SHA384": {
                sign: "ecdsa/rsa",
                hash: "sha384",
                id: "3041300d060960864801650304020205000430"
            },
            sha512WithRSAEncryption: {
                sign: "rsa",
                hash: "sha512",
                id: "3051300d060960864801650304020305000440"
            },
            "RSA-SHA512": {
                sign: "ecdsa/rsa",
                hash: "sha512",
                id: "3051300d060960864801650304020305000440"
            },
            "RSA-SHA1": {
                sign: "rsa",
                hash: "sha1",
                id: "3021300906052b0e03021a05000414"
            },
            "ecdsa-with-SHA1": {
                sign: "ecdsa",
                hash: "sha1",
                id: ""
            },
            sha256: {
                sign: "ecdsa",
                hash: "sha256",
                id: ""
            },
            sha224: {
                sign: "ecdsa",
                hash: "sha224",
                id: ""
            },
            sha384: {
                sign: "ecdsa",
                hash: "sha384",
                id: ""
            },
            sha512: {
                sign: "ecdsa",
                hash: "sha512",
                id: ""
            },
            "DSA-SHA": {
                sign: "dsa",
                hash: "sha1",
                id: ""
            },
            "DSA-SHA1": {
                sign: "dsa",
                hash: "sha1",
                id: ""
            },
            DSA: {
                sign: "dsa",
                hash: "sha1",
                id: ""
            },
            "DSA-WITH-SHA224": {
                sign: "dsa",
                hash: "sha224",
                id: ""
            },
            "DSA-SHA224": {
                sign: "dsa",
                hash: "sha224",
                id: ""
            },
            "DSA-WITH-SHA256": {
                sign: "dsa",
                hash: "sha256",
                id: ""
            },
            "DSA-SHA256": {
                sign: "dsa",
                hash: "sha256",
                id: ""
            },
            "DSA-WITH-SHA384": {
                sign: "dsa",
                hash: "sha384",
                id: ""
            },
            "DSA-SHA384": {
                sign: "dsa",
                hash: "sha384",
                id: ""
            },
            "DSA-WITH-SHA512": {
                sign: "dsa",
                hash: "sha512",
                id: ""
            },
            "DSA-SHA512": {
                sign: "dsa",
                hash: "sha512",
                id: ""
            },
            "DSA-RIPEMD160": {
                sign: "dsa",
                hash: "rmd160",
                id: ""
            },
            ripemd160WithRSA: {
                sign: "rsa",
                hash: "rmd160",
                id: "3021300906052b2403020105000414"
            },
            "RSA-RIPEMD160": {
                sign: "rsa",
                hash: "rmd160",
                id: "3021300906052b2403020105000414"
            },
            md5WithRSAEncryption: {
                sign: "rsa",
                hash: "md5",
                id: "3020300c06082a864886f70d020505000410"
            },
            "RSA-MD5": {
                sign: "rsa",
                hash: "md5",
                id: "3020300c06082a864886f70d020505000410"
            }
        };
    }, {} ],
    56: [ function(e, t, r) {
        t.exports = {
            "1.3.132.0.10": "secp256k1",
            "1.3.132.0.33": "p224",
            "1.2.840.10045.3.1.1": "p192",
            "1.2.840.10045.3.1.7": "p256",
            "1.3.132.0.34": "p384",
            "1.3.132.0.35": "p521"
        };
    }, {} ],
    57: [ function(e, t, r) {
        (function(r) {
            var i = e("create-hash");
            var n = e("stream");
            var a = e("inherits");
            var s = e("./sign");
            var f = e("./verify");
            var o = e("./algorithms.json");
            Object.keys(o).forEach(function(e) {
                o[e].id = new r(o[e].id, "hex");
                o[e.toLowerCase()] = o[e];
            });
            function c(e) {
                n.Writable.call(this);
                var t = o[e];
                if (!t) throw new Error("Unknown message digest");
                this._hashType = t.hash;
                this._hash = i(t.hash);
                this._tag = t.id;
                this._signType = t.sign;
            }
            a(c, n.Writable);
            c.prototype._write = function e(t, r, i) {
                this._hash.update(t);
                i();
            };
            c.prototype.update = function e(t, i) {
                if (typeof t === "string") t = new r(t, i);
                this._hash.update(t);
                return this;
            };
            c.prototype.sign = function e(t, r) {
                this.end();
                var i = this._hash.digest();
                var n = s(i, t, this._hashType, this._signType, this._tag);
                return r ? n.toString(r) : n;
            };
            function h(e) {
                n.Writable.call(this);
                var t = o[e];
                if (!t) throw new Error("Unknown message digest");
                this._hash = i(t.hash);
                this._tag = t.id;
                this._signType = t.sign;
            }
            a(h, n.Writable);
            h.prototype._write = function e(t, r, i) {
                this._hash.update(t);
                i();
            };
            h.prototype.update = function e(t, i) {
                if (typeof t === "string") t = new r(t, i);
                this._hash.update(t);
                return this;
            };
            h.prototype.verify = function e(t, i, n) {
                if (typeof i === "string") i = new r(i, n);
                this.end();
                var a = this._hash.digest();
                return f(i, a, t, this._signType, this._tag);
            };
            function u(e) {
                return new c(e);
            }
            function d(e) {
                return new h(e);
            }
            t.exports = {
                Sign: u,
                Verify: d,
                createSign: u,
                createVerify: d
            };
        }).call(this, e("buffer").Buffer);
    }, {
        "./algorithms.json": 55,
        "./sign": 58,
        "./verify": 59,
        buffer: 61,
        "create-hash": 65,
        inherits: 115,
        stream: 163
    } ],
    58: [ function(e, t, r) {
        (function(r) {
            var i = e("create-hmac");
            var n = e("browserify-rsa");
            var a = e("elliptic").ec;
            var s = e("bn.js");
            var f = e("parse-asn1");
            var o = e("./curves.json");
            function c(e, t, i, a, s) {
                var o = f(t);
                if (o.curve) {
                    if (a !== "ecdsa" && a !== "ecdsa/rsa") throw new Error("wrong private key type");
                    return h(e, o);
                } else if (o.type === "dsa") {
                    if (a !== "dsa") throw new Error("wrong private key type");
                    return u(e, o, i);
                } else {
                    if (a !== "rsa" && a !== "ecdsa/rsa") throw new Error("wrong private key type");
                }
                e = r.concat([ s, e ]);
                var c = o.modulus.byteLength();
                var d = [ 0, 1 ];
                while (e.length + d.length + 1 < c) d.push(255);
                d.push(0);
                var l = -1;
                while (++l < e.length) d.push(e[l]);
                var p = n(d, o);
                return p;
            }
            function h(e, t) {
                var i = o[t.curve.join(".")];
                if (!i) throw new Error("unknown curve " + t.curve.join("."));
                var n = new a(i);
                var s = n.keyFromPrivate(t.privateKey);
                var f = s.sign(e);
                return new r(f.toDER());
            }
            function u(e, t, r) {
                var i = t.params.priv_key;
                var n = t.params.p;
                var a = t.params.q;
                var f = t.params.g;
                var o = new s(0);
                var c;
                var h = p(e, a).mod(a);
                var u = false;
                var b = l(i, a, e, r);
                while (u === false) {
                    c = v(a, b, r);
                    o = m(f, c, n, a);
                    u = c.invm(a).imul(h.add(i.mul(o))).mod(a);
                    if (u.cmpn(0) === 0) {
                        u = false;
                        o = new s(0);
                    }
                }
                return d(o, u);
            }
            function d(e, t) {
                e = e.toArray();
                t = t.toArray();
                if (e[0] & 128) e = [ 0 ].concat(e);
                if (t[0] & 128) t = [ 0 ].concat(t);
                var i = e.length + t.length + 4;
                var n = [ 48, i, 2, e.length ];
                n = n.concat(e, [ 2, t.length ], t);
                return new r(n);
            }
            function l(e, t, n, a) {
                e = new r(e.toArray());
                if (e.length < t.byteLength()) {
                    var s = new r(t.byteLength() - e.length);
                    s.fill(0);
                    e = r.concat([ s, e ]);
                }
                var f = n.length;
                var o = b(n, t);
                var c = new r(f);
                c.fill(1);
                var h = new r(f);
                h.fill(0);
                h = i(a, h).update(c).update(new r([ 0 ])).update(e).update(o).digest();
                c = i(a, h).update(c).digest();
                h = i(a, h).update(c).update(new r([ 1 ])).update(e).update(o).digest();
                c = i(a, h).update(c).digest();
                return {
                    k: h,
                    v: c
                };
            }
            function p(e, t) {
                var r = new s(e);
                var i = (e.length << 3) - t.bitLength();
                if (i > 0) r.ishrn(i);
                return r;
            }
            function b(e, t) {
                e = p(e, t);
                e = e.mod(t);
                var i = new r(e.toArray());
                if (i.length < t.byteLength()) {
                    var n = new r(t.byteLength() - i.length);
                    n.fill(0);
                    i = r.concat([ n, i ]);
                }
                return i;
            }
            function v(e, t, n) {
                var a;
                var s;
                do {
                    a = new r(0);
                    while (a.length * 8 < e.bitLength()) {
                        t.v = i(n, t.k).update(t.v).digest();
                        a = r.concat([ a, t.v ]);
                    }
                    s = p(a, e);
                    t.k = i(n, t.k).update(t.v).update(new r([ 0 ])).digest();
                    t.v = i(n, t.k).update(t.v).digest();
                } while (s.cmp(e) !== -1);
                return s;
            }
            function m(e, t, r, i) {
                return e.toRed(s.mont(r)).redPow(t).fromRed().mod(i);
            }
            t.exports = c;
            t.exports.getKey = l;
            t.exports.makeKey = v;
        }).call(this, e("buffer").Buffer);
    }, {
        "./curves.json": 56,
        "bn.js": 32,
        "browserify-rsa": 53,
        buffer: 61,
        "create-hmac": 68,
        elliptic: 81,
        "parse-asn1": 125
    } ],
    59: [ function(e, t, r) {
        (function(r) {
            var i = e("bn.js");
            var n = e("elliptic").ec;
            var a = e("parse-asn1");
            var s = e("./curves.json");
            function f(e, t, n, s, f) {
                var h = a(n);
                if (h.type === "ec") {
                    if (s !== "ecdsa" && s !== "ecdsa/rsa") throw new Error("wrong public key type");
                    return o(e, t, h);
                } else if (h.type === "dsa") {
                    if (s !== "dsa") throw new Error("wrong public key type");
                    return c(e, t, h);
                } else {
                    if (s !== "rsa" && s !== "ecdsa/rsa") throw new Error("wrong public key type");
                }
                t = r.concat([ f, t ]);
                var u = h.modulus.byteLength();
                var d = [ 1 ];
                var l = 0;
                while (t.length + d.length + 2 < u) {
                    d.push(255);
                    l++;
                }
                d.push(0);
                var p = -1;
                while (++p < t.length) {
                    d.push(t[p]);
                }
                d = new r(d);
                var b = i.mont(h.modulus);
                e = new i(e).toRed(b);
                e = e.redPow(new i(h.publicExponent));
                e = new r(e.fromRed().toArray());
                var v = l < 8 ? 1 : 0;
                u = Math.min(e.length, d.length);
                if (e.length !== d.length) v = 1;
                p = -1;
                while (++p < u) v |= e[p] ^ d[p];
                return v === 0;
            }
            function o(e, t, r) {
                var i = s[r.data.algorithm.curve.join(".")];
                if (!i) throw new Error("unknown curve " + r.data.algorithm.curve.join("."));
                var a = new n(i);
                var f = r.data.subjectPrivateKey.data;
                return a.verify(t, e, f);
            }
            function c(e, t, r) {
                var n = r.data.p;
                var s = r.data.q;
                var f = r.data.g;
                var o = r.data.pub_key;
                var c = a.signature.decode(e, "der");
                var u = c.s;
                var d = c.r;
                h(u, s);
                h(d, s);
                var l = i.mont(n);
                var p = u.invm(s);
                var b = f.toRed(l).redPow(new i(t).mul(p).mod(s)).fromRed().mul(o.toRed(l).redPow(d.mul(p).mod(s)).fromRed()).mod(n).mod(s);
                return b.cmp(d) === 0;
            }
            function h(e, t) {
                if (e.cmpn(0) <= 0) throw new Error("invalid sig");
                if (e.cmp(t) >= t) throw new Error("invalid sig");
            }
            t.exports = f;
        }).call(this, e("buffer").Buffer);
    }, {
        "./curves.json": 56,
        "bn.js": 32,
        buffer: 61,
        elliptic: 81,
        "parse-asn1": 125
    } ],
    60: [ function(e, t, r) {
        (function(e) {
            t.exports = function t(r, i) {
                var n = Math.min(r.length, i.length);
                var a = new e(n);
                for (var s = 0; s < n; ++s) {
                    a[s] = r[s] ^ i[s];
                }
                return a;
            };
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61
    } ],
    61: [ function(e, t, r) {
        "use strict";
        var i = e("base64-js");
        var n = e("ieee754");
        r.Buffer = o;
        r.SlowBuffer = y;
        r.INSPECT_MAX_BYTES = 50;
        var a = 2147483647;
        r.kMaxLength = a;
        o.TYPED_ARRAY_SUPPORT = s();
        if (!o.TYPED_ARRAY_SUPPORT && typeof console !== "undefined" && typeof console.error === "function") {
            console.error("This browser lacks typed array (Uint8Array) support which is required by " + "`buffer` v5.x. Use `buffer` v4.x if you require old browser support.");
        }
        function s() {
            try {
                var e = new Uint8Array(1);
                e.__proto__ = {
                    __proto__: Uint8Array.prototype,
                    foo: function() {
                        return 42;
                    }
                };
                return e.foo() === 42;
            } catch (e) {
                return false;
            }
        }
        function f(e) {
            if (e > a) {
                throw new RangeError("Invalid typed array length");
            }
            var t = new Uint8Array(e);
            t.__proto__ = o.prototype;
            return t;
        }
        function o(e, t, r) {
            if (typeof e === "number") {
                if (typeof t === "string") {
                    throw new Error("If encoding is specified then the first argument must be a string");
                }
                return d(e);
            }
            return c(e, t, r);
        }
        if (typeof Symbol !== "undefined" && Symbol.species && o[Symbol.species] === o) {
            Object.defineProperty(o, Symbol.species, {
                value: null,
                configurable: true,
                enumerable: false,
                writable: false
            });
        }
        o.poolSize = 8192;
        function c(e, t, r) {
            if (typeof e === "number") {
                throw new TypeError('"value" argument must not be a number');
            }
            if (e instanceof ArrayBuffer) {
                return b(e, t, r);
            }
            if (typeof e === "string") {
                return l(e, t);
            }
            return v(e);
        }
        o.from = function(e, t, r) {
            return c(e, t, r);
        };
        o.prototype.__proto__ = Uint8Array.prototype;
        o.__proto__ = Uint8Array;
        function h(e) {
            if (typeof e !== "number") {
                throw new TypeError('"size" argument must be a number');
            } else if (e < 0) {
                throw new RangeError('"size" argument must not be negative');
            }
        }
        function u(e, t, r) {
            h(e);
            if (e <= 0) {
                return f(e);
            }
            if (t !== undefined) {
                return typeof r === "string" ? f(e).fill(t, r) : f(e).fill(t);
            }
            return f(e);
        }
        o.alloc = function(e, t, r) {
            return u(e, t, r);
        };
        function d(e) {
            h(e);
            return f(e < 0 ? 0 : m(e) | 0);
        }
        o.allocUnsafe = function(e) {
            return d(e);
        };
        o.allocUnsafeSlow = function(e) {
            return d(e);
        };
        function l(e, t) {
            if (typeof t !== "string" || t === "") {
                t = "utf8";
            }
            if (!o.isEncoding(t)) {
                throw new TypeError('"encoding" must be a valid string encoding');
            }
            var r = g(e, t) | 0;
            var i = f(r);
            var n = i.write(e, t);
            if (n !== r) {
                i = i.slice(0, n);
            }
            return i;
        }
        function p(e) {
            var t = e.length < 0 ? 0 : m(e.length) | 0;
            var r = f(t);
            for (var i = 0; i < t; i += 1) {
                r[i] = e[i] & 255;
            }
            return r;
        }
        function b(e, t, r) {
            if (t < 0 || e.byteLength < t) {
                throw new RangeError("'offset' is out of bounds");
            }
            if (e.byteLength < t + (r || 0)) {
                throw new RangeError("'length' is out of bounds");
            }
            var i;
            if (t === undefined && r === undefined) {
                i = new Uint8Array(e);
            } else if (r === undefined) {
                i = new Uint8Array(e, t);
            } else {
                i = new Uint8Array(e, t, r);
            }
            i.__proto__ = o.prototype;
            return i;
        }
        function v(e) {
            if (o.isBuffer(e)) {
                var t = m(e.length) | 0;
                var r = f(t);
                if (r.length === 0) {
                    return r;
                }
                e.copy(r, 0, 0, t);
                return r;
            }
            if (e) {
                if (G(e) || "length" in e) {
                    if (typeof e.length !== "number" || $(e.length)) {
                        return f(0);
                    }
                    return p(e);
                }
                if (e.type === "Buffer" && Array.isArray(e.data)) {
                    return p(e.data);
                }
            }
            throw new TypeError("First argument must be a string, Buffer, ArrayBuffer, Array, or array-like object.");
        }
        function m(e) {
            if (e >= a) {
                throw new RangeError("Attempt to allocate Buffer larger than maximum " + "size: 0x" + a.toString(16) + " bytes");
            }
            return e | 0;
        }
        function y(e) {
            if (+e != e) {
                e = 0;
            }
            return o.alloc(+e);
        }
        o.isBuffer = function e(t) {
            return t != null && t._isBuffer === true;
        };
        o.compare = function e(t, r) {
            if (!o.isBuffer(t) || !o.isBuffer(r)) {
                throw new TypeError("Arguments must be Buffers");
            }
            if (t === r) return 0;
            var i = t.length;
            var n = r.length;
            for (var a = 0, s = Math.min(i, n); a < s; ++a) {
                if (t[a] !== r[a]) {
                    i = t[a];
                    n = r[a];
                    break;
                }
            }
            if (i < n) return -1;
            if (n < i) return 1;
            return 0;
        };
        o.isEncoding = function e(t) {
            switch (String(t).toLowerCase()) {
              case "hex":
              case "utf8":
              case "utf-8":
              case "ascii":
              case "latin1":
              case "binary":
              case "base64":
              case "ucs2":
              case "ucs-2":
              case "utf16le":
              case "utf-16le":
                return true;

              default:
                return false;
            }
        };
        o.concat = function e(t, r) {
            if (!Array.isArray(t)) {
                throw new TypeError('"list" argument must be an Array of Buffers');
            }
            if (t.length === 0) {
                return o.alloc(0);
            }
            var i;
            if (r === undefined) {
                r = 0;
                for (i = 0; i < t.length; ++i) {
                    r += t[i].length;
                }
            }
            var n = o.allocUnsafe(r);
            var a = 0;
            for (i = 0; i < t.length; ++i) {
                var s = t[i];
                if (!o.isBuffer(s)) {
                    throw new TypeError('"list" argument must be an Array of Buffers');
                }
                s.copy(n, a);
                a += s.length;
            }
            return n;
        };
        function g(e, t) {
            if (o.isBuffer(e)) {
                return e.length;
            }
            if (G(e) || e instanceof ArrayBuffer) {
                return e.byteLength;
            }
            if (typeof e !== "string") {
                e = "" + e;
            }
            var r = e.length;
            if (r === 0) return 0;
            var i = false;
            for (;;) {
                switch (t) {
                  case "ascii":
                  case "latin1":
                  case "binary":
                    return r;

                  case "utf8":
                  case "utf-8":
                  case undefined:
                    return V(e).length;

                  case "ucs2":
                  case "ucs-2":
                  case "utf16le":
                  case "utf-16le":
                    return r * 2;

                  case "hex":
                    return r >>> 1;

                  case "base64":
                    return J(e).length;

                  default:
                    if (i) return V(e).length;
                    t = ("" + t).toLowerCase();
                    i = true;
                }
            }
        }
        o.byteLength = g;
        function w(e, t, r) {
            var i = false;
            if (t === undefined || t < 0) {
                t = 0;
            }
            if (t > this.length) {
                return "";
            }
            if (r === undefined || r > this.length) {
                r = this.length;
            }
            if (r <= 0) {
                return "";
            }
            r >>>= 0;
            t >>>= 0;
            if (r <= t) {
                return "";
            }
            if (!e) e = "utf8";
            while (true) {
                switch (e) {
                  case "hex":
                    return L(this, t, r);

                  case "utf8":
                  case "utf-8":
                    return C(this, t, r);

                  case "ascii":
                    return T(this, t, r);

                  case "latin1":
                  case "binary":
                    return D(this, t, r);

                  case "base64":
                    return j(this, t, r);

                  case "ucs2":
                  case "ucs-2":
                  case "utf16le":
                  case "utf-16le":
                    return q(this, t, r);

                  default:
                    if (i) throw new TypeError("Unknown encoding: " + e);
                    e = (e + "").toLowerCase();
                    i = true;
                }
            }
        }
        o.prototype._isBuffer = true;
        function _(e, t, r) {
            var i = e[t];
            e[t] = e[r];
            e[r] = i;
        }
        o.prototype.swap16 = function e() {
            var t = this.length;
            if (t % 2 !== 0) {
                throw new RangeError("Buffer size must be a multiple of 16-bits");
            }
            for (var r = 0; r < t; r += 2) {
                _(this, r, r + 1);
            }
            return this;
        };
        o.prototype.swap32 = function e() {
            var t = this.length;
            if (t % 4 !== 0) {
                throw new RangeError("Buffer size must be a multiple of 32-bits");
            }
            for (var r = 0; r < t; r += 4) {
                _(this, r, r + 3);
                _(this, r + 1, r + 2);
            }
            return this;
        };
        o.prototype.swap64 = function e() {
            var t = this.length;
            if (t % 8 !== 0) {
                throw new RangeError("Buffer size must be a multiple of 64-bits");
            }
            for (var r = 0; r < t; r += 8) {
                _(this, r, r + 7);
                _(this, r + 1, r + 6);
                _(this, r + 2, r + 5);
                _(this, r + 3, r + 4);
            }
            return this;
        };
        o.prototype.toString = function e() {
            var t = this.length;
            if (t === 0) return "";
            if (arguments.length === 0) return C(this, 0, t);
            return w.apply(this, arguments);
        };
        o.prototype.equals = function e(t) {
            if (!o.isBuffer(t)) throw new TypeError("Argument must be a Buffer");
            if (this === t) return true;
            return o.compare(this, t) === 0;
        };
        o.prototype.inspect = function e() {
            var t = "";
            var i = r.INSPECT_MAX_BYTES;
            if (this.length > 0) {
                t = this.toString("hex", 0, i).match(/.{2}/g).join(" ");
                if (this.length > i) t += " ... ";
            }
            return "<Buffer " + t + ">";
        };
        o.prototype.compare = function e(t, r, i, n, a) {
            if (!o.isBuffer(t)) {
                throw new TypeError("Argument must be a Buffer");
            }
            if (r === undefined) {
                r = 0;
            }
            if (i === undefined) {
                i = t ? t.length : 0;
            }
            if (n === undefined) {
                n = 0;
            }
            if (a === undefined) {
                a = this.length;
            }
            if (r < 0 || i > t.length || n < 0 || a > this.length) {
                throw new RangeError("out of range index");
            }
            if (n >= a && r >= i) {
                return 0;
            }
            if (n >= a) {
                return -1;
            }
            if (r >= i) {
                return 1;
            }
            r >>>= 0;
            i >>>= 0;
            n >>>= 0;
            a >>>= 0;
            if (this === t) return 0;
            var s = a - n;
            var f = i - r;
            var c = Math.min(s, f);
            var h = this.slice(n, a);
            var u = t.slice(r, i);
            for (var d = 0; d < c; ++d) {
                if (h[d] !== u[d]) {
                    s = h[d];
                    f = u[d];
                    break;
                }
            }
            if (s < f) return -1;
            if (f < s) return 1;
            return 0;
        };
        function S(e, t, r, i, n) {
            if (e.length === 0) return -1;
            if (typeof r === "string") {
                i = r;
                r = 0;
            } else if (r > 2147483647) {
                r = 2147483647;
            } else if (r < -2147483648) {
                r = -2147483648;
            }
            r = +r;
            if ($(r)) {
                r = n ? 0 : e.length - 1;
            }
            if (r < 0) r = e.length + r;
            if (r >= e.length) {
                if (n) return -1; else r = e.length - 1;
            } else if (r < 0) {
                if (n) r = 0; else return -1;
            }
            if (typeof t === "string") {
                t = o.from(t, i);
            }
            if (o.isBuffer(t)) {
                if (t.length === 0) {
                    return -1;
                }
                return M(e, t, r, i, n);
            } else if (typeof t === "number") {
                t = t & 255;
                if (typeof Uint8Array.prototype.indexOf === "function") {
                    if (n) {
                        return Uint8Array.prototype.indexOf.call(e, t, r);
                    } else {
                        return Uint8Array.prototype.lastIndexOf.call(e, t, r);
                    }
                }
                return M(e, [ t ], r, i, n);
            }
            throw new TypeError("val must be string, number or Buffer");
        }
        function M(e, t, r, i, n) {
            var a = 1;
            var s = e.length;
            var f = t.length;
            if (i !== undefined) {
                i = String(i).toLowerCase();
                if (i === "ucs2" || i === "ucs-2" || i === "utf16le" || i === "utf-16le") {
                    if (e.length < 2 || t.length < 2) {
                        return -1;
                    }
                    a = 2;
                    s /= 2;
                    f /= 2;
                    r /= 2;
                }
            }
            function o(e, t) {
                if (a === 1) {
                    return e[t];
                } else {
                    return e.readUInt16BE(t * a);
                }
            }
            var c;
            if (n) {
                var h = -1;
                for (c = r; c < s; c++) {
                    if (o(e, c) === o(t, h === -1 ? 0 : c - h)) {
                        if (h === -1) h = c;
                        if (c - h + 1 === f) return h * a;
                    } else {
                        if (h !== -1) c -= c - h;
                        h = -1;
                    }
                }
            } else {
                if (r + f > s) r = s - f;
                for (c = r; c >= 0; c--) {
                    var u = true;
                    for (var d = 0; d < f; d++) {
                        if (o(e, c + d) !== o(t, d)) {
                            u = false;
                            break;
                        }
                    }
                    if (u) return c;
                }
            }
            return -1;
        }
        o.prototype.includes = function e(t, r, i) {
            return this.indexOf(t, r, i) !== -1;
        };
        o.prototype.indexOf = function e(t, r, i) {
            return S(this, t, r, i, true);
        };
        o.prototype.lastIndexOf = function e(t, r, i) {
            return S(this, t, r, i, false);
        };
        function k(e, t, r, i) {
            r = Number(r) || 0;
            var n = e.length - r;
            if (!i) {
                i = n;
            } else {
                i = Number(i);
                if (i > n) {
                    i = n;
                }
            }
            var a = t.length;
            if (a % 2 !== 0) throw new TypeError("Invalid hex string");
            if (i > a / 2) {
                i = a / 2;
            }
            for (var s = 0; s < i; ++s) {
                var f = parseInt(t.substr(s * 2, 2), 16);
                if ($(f)) return s;
                e[r + s] = f;
            }
            return s;
        }
        function E(e, t, r, i) {
            return Y(V(t, e.length - r), e, r, i);
        }
        function x(e, t, r, i) {
            return Y(X(t), e, r, i);
        }
        function A(e, t, r, i) {
            return x(e, t, r, i);
        }
        function B(e, t, r, i) {
            return Y(J(t), e, r, i);
        }
        function I(e, t, r, i) {
            return Y(Z(t, e.length - r), e, r, i);
        }
        o.prototype.write = function e(t, r, i, n) {
            if (r === undefined) {
                n = "utf8";
                i = this.length;
                r = 0;
            } else if (i === undefined && typeof r === "string") {
                n = r;
                i = this.length;
                r = 0;
            } else if (isFinite(r)) {
                r = r >>> 0;
                if (isFinite(i)) {
                    i = i >>> 0;
                    if (n === undefined) n = "utf8";
                } else {
                    n = i;
                    i = undefined;
                }
            } else {
                throw new Error("Buffer.write(string, encoding, offset[, length]) is no longer supported");
            }
            var a = this.length - r;
            if (i === undefined || i > a) i = a;
            if (t.length > 0 && (i < 0 || r < 0) || r > this.length) {
                throw new RangeError("Attempt to write outside buffer bounds");
            }
            if (!n) n = "utf8";
            var s = false;
            for (;;) {
                switch (n) {
                  case "hex":
                    return k(this, t, r, i);

                  case "utf8":
                  case "utf-8":
                    return E(this, t, r, i);

                  case "ascii":
                    return x(this, t, r, i);

                  case "latin1":
                  case "binary":
                    return A(this, t, r, i);

                  case "base64":
                    return B(this, t, r, i);

                  case "ucs2":
                  case "ucs-2":
                  case "utf16le":
                  case "utf-16le":
                    return I(this, t, r, i);

                  default:
                    if (s) throw new TypeError("Unknown encoding: " + n);
                    n = ("" + n).toLowerCase();
                    s = true;
                }
            }
        };
        o.prototype.toJSON = function e() {
            return {
                type: "Buffer",
                data: Array.prototype.slice.call(this._arr || this, 0)
            };
        };
        function j(e, t, r) {
            if (t === 0 && r === e.length) {
                return i.fromByteArray(e);
            } else {
                return i.fromByteArray(e.slice(t, r));
            }
        }
        function C(e, t, r) {
            r = Math.min(e.length, r);
            var i = [];
            var n = t;
            while (n < r) {
                var a = e[n];
                var s = null;
                var f = a > 239 ? 4 : a > 223 ? 3 : a > 191 ? 2 : 1;
                if (n + f <= r) {
                    var o, c, h, u;
                    switch (f) {
                      case 1:
                        if (a < 128) {
                            s = a;
                        }
                        break;

                      case 2:
                        o = e[n + 1];
                        if ((o & 192) === 128) {
                            u = (a & 31) << 6 | o & 63;
                            if (u > 127) {
                                s = u;
                            }
                        }
                        break;

                      case 3:
                        o = e[n + 1];
                        c = e[n + 2];
                        if ((o & 192) === 128 && (c & 192) === 128) {
                            u = (a & 15) << 12 | (o & 63) << 6 | c & 63;
                            if (u > 2047 && (u < 55296 || u > 57343)) {
                                s = u;
                            }
                        }
                        break;

                      case 4:
                        o = e[n + 1];
                        c = e[n + 2];
                        h = e[n + 3];
                        if ((o & 192) === 128 && (c & 192) === 128 && (h & 192) === 128) {
                            u = (a & 15) << 18 | (o & 63) << 12 | (c & 63) << 6 | h & 63;
                            if (u > 65535 && u < 1114112) {
                                s = u;
                            }
                        }
                    }
                }
                if (s === null) {
                    s = 65533;
                    f = 1;
                } else if (s > 65535) {
                    s -= 65536;
                    i.push(s >>> 10 & 1023 | 55296);
                    s = 56320 | s & 1023;
                }
                i.push(s);
                n += f;
            }
            return P(i);
        }
        var R = 4096;
        function P(e) {
            var t = e.length;
            if (t <= R) {
                return String.fromCharCode.apply(String, e);
            }
            var r = "";
            var i = 0;
            while (i < t) {
                r += String.fromCharCode.apply(String, e.slice(i, i += R));
            }
            return r;
        }
        function T(e, t, r) {
            var i = "";
            r = Math.min(e.length, r);
            for (var n = t; n < r; ++n) {
                i += String.fromCharCode(e[n] & 127);
            }
            return i;
        }
        function D(e, t, r) {
            var i = "";
            r = Math.min(e.length, r);
            for (var n = t; n < r; ++n) {
                i += String.fromCharCode(e[n]);
            }
            return i;
        }
        function L(e, t, r) {
            var i = e.length;
            if (!t || t < 0) t = 0;
            if (!r || r < 0 || r > i) r = i;
            var n = "";
            for (var a = t; a < r; ++a) {
                n += W(e[a]);
            }
            return n;
        }
        function q(e, t, r) {
            var i = e.slice(t, r);
            var n = "";
            for (var a = 0; a < i.length; a += 2) {
                n += String.fromCharCode(i[a] + i[a + 1] * 256);
            }
            return n;
        }
        o.prototype.slice = function e(t, r) {
            var i = this.length;
            t = ~~t;
            r = r === undefined ? i : ~~r;
            if (t < 0) {
                t += i;
                if (t < 0) t = 0;
            } else if (t > i) {
                t = i;
            }
            if (r < 0) {
                r += i;
                if (r < 0) r = 0;
            } else if (r > i) {
                r = i;
            }
            if (r < t) r = t;
            var n = this.subarray(t, r);
            n.__proto__ = o.prototype;
            return n;
        };
        function N(e, t, r) {
            if (e % 1 !== 0 || e < 0) throw new RangeError("offset is not uint");
            if (e + t > r) throw new RangeError("Trying to access beyond buffer length");
        }
        o.prototype.readUIntLE = function e(t, r, i) {
            t = t >>> 0;
            r = r >>> 0;
            if (!i) N(t, r, this.length);
            var n = this[t];
            var a = 1;
            var s = 0;
            while (++s < r && (a *= 256)) {
                n += this[t + s] * a;
            }
            return n;
        };
        o.prototype.readUIntBE = function e(t, r, i) {
            t = t >>> 0;
            r = r >>> 0;
            if (!i) {
                N(t, r, this.length);
            }
            var n = this[t + --r];
            var a = 1;
            while (r > 0 && (a *= 256)) {
                n += this[t + --r] * a;
            }
            return n;
        };
        o.prototype.readUInt8 = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 1, this.length);
            return this[t];
        };
        o.prototype.readUInt16LE = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 2, this.length);
            return this[t] | this[t + 1] << 8;
        };
        o.prototype.readUInt16BE = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 2, this.length);
            return this[t] << 8 | this[t + 1];
        };
        o.prototype.readUInt32LE = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 4, this.length);
            return (this[t] | this[t + 1] << 8 | this[t + 2] << 16) + this[t + 3] * 16777216;
        };
        o.prototype.readUInt32BE = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 4, this.length);
            return this[t] * 16777216 + (this[t + 1] << 16 | this[t + 2] << 8 | this[t + 3]);
        };
        o.prototype.readIntLE = function e(t, r, i) {
            t = t >>> 0;
            r = r >>> 0;
            if (!i) N(t, r, this.length);
            var n = this[t];
            var a = 1;
            var s = 0;
            while (++s < r && (a *= 256)) {
                n += this[t + s] * a;
            }
            a *= 128;
            if (n >= a) n -= Math.pow(2, 8 * r);
            return n;
        };
        o.prototype.readIntBE = function e(t, r, i) {
            t = t >>> 0;
            r = r >>> 0;
            if (!i) N(t, r, this.length);
            var n = r;
            var a = 1;
            var s = this[t + --n];
            while (n > 0 && (a *= 256)) {
                s += this[t + --n] * a;
            }
            a *= 128;
            if (s >= a) s -= Math.pow(2, 8 * r);
            return s;
        };
        o.prototype.readInt8 = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 1, this.length);
            if (!(this[t] & 128)) return this[t];
            return (255 - this[t] + 1) * -1;
        };
        o.prototype.readInt16LE = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 2, this.length);
            var i = this[t] | this[t + 1] << 8;
            return i & 32768 ? i | 4294901760 : i;
        };
        o.prototype.readInt16BE = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 2, this.length);
            var i = this[t + 1] | this[t] << 8;
            return i & 32768 ? i | 4294901760 : i;
        };
        o.prototype.readInt32LE = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 4, this.length);
            return this[t] | this[t + 1] << 8 | this[t + 2] << 16 | this[t + 3] << 24;
        };
        o.prototype.readInt32BE = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 4, this.length);
            return this[t] << 24 | this[t + 1] << 16 | this[t + 2] << 8 | this[t + 3];
        };
        o.prototype.readFloatLE = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 4, this.length);
            return n.read(this, t, true, 23, 4);
        };
        o.prototype.readFloatBE = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 4, this.length);
            return n.read(this, t, false, 23, 4);
        };
        o.prototype.readDoubleLE = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 8, this.length);
            return n.read(this, t, true, 52, 8);
        };
        o.prototype.readDoubleBE = function e(t, r) {
            t = t >>> 0;
            if (!r) N(t, 8, this.length);
            return n.read(this, t, false, 52, 8);
        };
        function O(e, t, r, i, n, a) {
            if (!o.isBuffer(e)) throw new TypeError('"buffer" argument must be a Buffer instance');
            if (t > n || t < a) throw new RangeError('"value" argument is out of bounds');
            if (r + i > e.length) throw new RangeError("Index out of range");
        }
        o.prototype.writeUIntLE = function e(t, r, i, n) {
            t = +t;
            r = r >>> 0;
            i = i >>> 0;
            if (!n) {
                var a = Math.pow(2, 8 * i) - 1;
                O(this, t, r, i, a, 0);
            }
            var s = 1;
            var f = 0;
            this[r] = t & 255;
            while (++f < i && (s *= 256)) {
                this[r + f] = t / s & 255;
            }
            return r + i;
        };
        o.prototype.writeUIntBE = function e(t, r, i, n) {
            t = +t;
            r = r >>> 0;
            i = i >>> 0;
            if (!n) {
                var a = Math.pow(2, 8 * i) - 1;
                O(this, t, r, i, a, 0);
            }
            var s = i - 1;
            var f = 1;
            this[r + s] = t & 255;
            while (--s >= 0 && (f *= 256)) {
                this[r + s] = t / f & 255;
            }
            return r + i;
        };
        o.prototype.writeUInt8 = function e(t, r, i) {
            t = +t;
            r = r >>> 0;
            if (!i) O(this, t, r, 1, 255, 0);
            this[r] = t & 255;
            return r + 1;
        };
        o.prototype.writeUInt16LE = function e(t, r, i) {
            t = +t;
            r = r >>> 0;
            if (!i) O(this, t, r, 2, 65535, 0);
            this[r] = t & 255;
            this[r + 1] = t >>> 8;
            return r + 2;
        };
        o.prototype.writeUInt16BE = function e(t, r, i) {
            t = +t;
            r = r >>> 0;
            if (!i) O(this, t, r, 2, 65535, 0);
            this[r] = t >>> 8;
            this[r + 1] = t & 255;
            return r + 2;
        };
        o.prototype.writeUInt32LE = function e(t, r, i) {
            t = +t;
            r = r >>> 0;
            if (!i) O(this, t, r, 4, 4294967295, 0);
            this[r + 3] = t >>> 24;
            this[r + 2] = t >>> 16;
            this[r + 1] = t >>> 8;
            this[r] = t & 255;
            return r + 4;
        };
        o.prototype.writeUInt32BE = function e(t, r, i) {
            t = +t;
            r = r >>> 0;
            if (!i) O(this, t, r, 4, 4294967295, 0);
            this[r] = t >>> 24;
            this[r + 1] = t >>> 16;
            this[r + 2] = t >>> 8;
            this[r + 3] = t & 255;
            return r + 4;
        };
        o.prototype.writeIntLE = function e(t, r, i, n) {
            t = +t;
            r = r >>> 0;
            if (!n) {
                var a = Math.pow(2, 8 * i - 1);
                O(this, t, r, i, a - 1, -a);
            }
            var s = 0;
            var f = 1;
            var o = 0;
            this[r] = t & 255;
            while (++s < i && (f *= 256)) {
                if (t < 0 && o === 0 && this[r + s - 1] !== 0) {
                    o = 1;
                }
                this[r + s] = (t / f >> 0) - o & 255;
            }
            return r + i;
        };
        o.prototype.writeIntBE = function e(t, r, i, n) {
            t = +t;
            r = r >>> 0;
            if (!n) {
                var a = Math.pow(2, 8 * i - 1);
                O(this, t, r, i, a - 1, -a);
            }
            var s = i - 1;
            var f = 1;
            var o = 0;
            this[r + s] = t & 255;
            while (--s >= 0 && (f *= 256)) {
                if (t < 0 && o === 0 && this[r + s + 1] !== 0) {
                    o = 1;
                }
                this[r + s] = (t / f >> 0) - o & 255;
            }
            return r + i;
        };
        o.prototype.writeInt8 = function e(t, r, i) {
            t = +t;
            r = r >>> 0;
            if (!i) O(this, t, r, 1, 127, -128);
            if (t < 0) t = 255 + t + 1;
            this[r] = t & 255;
            return r + 1;
        };
        o.prototype.writeInt16LE = function e(t, r, i) {
            t = +t;
            r = r >>> 0;
            if (!i) O(this, t, r, 2, 32767, -32768);
            this[r] = t & 255;
            this[r + 1] = t >>> 8;
            return r + 2;
        };
        o.prototype.writeInt16BE = function e(t, r, i) {
            t = +t;
            r = r >>> 0;
            if (!i) O(this, t, r, 2, 32767, -32768);
            this[r] = t >>> 8;
            this[r + 1] = t & 255;
            return r + 2;
        };
        o.prototype.writeInt32LE = function e(t, r, i) {
            t = +t;
            r = r >>> 0;
            if (!i) O(this, t, r, 4, 2147483647, -2147483648);
            this[r] = t & 255;
            this[r + 1] = t >>> 8;
            this[r + 2] = t >>> 16;
            this[r + 3] = t >>> 24;
            return r + 4;
        };
        o.prototype.writeInt32BE = function e(t, r, i) {
            t = +t;
            r = r >>> 0;
            if (!i) O(this, t, r, 4, 2147483647, -2147483648);
            if (t < 0) t = 4294967295 + t + 1;
            this[r] = t >>> 24;
            this[r + 1] = t >>> 16;
            this[r + 2] = t >>> 8;
            this[r + 3] = t & 255;
            return r + 4;
        };
        function z(e, t, r, i, n, a) {
            if (r + i > e.length) throw new RangeError("Index out of range");
            if (r < 0) throw new RangeError("Index out of range");
        }
        function U(e, t, r, i, a) {
            t = +t;
            r = r >>> 0;
            if (!a) {
                z(e, t, r, 4, 3.4028234663852886e38, -3.4028234663852886e38);
            }
            n.write(e, t, r, i, 23, 4);
            return r + 4;
        }
        o.prototype.writeFloatLE = function e(t, r, i) {
            return U(this, t, r, true, i);
        };
        o.prototype.writeFloatBE = function e(t, r, i) {
            return U(this, t, r, false, i);
        };
        function K(e, t, r, i, a) {
            t = +t;
            r = r >>> 0;
            if (!a) {
                z(e, t, r, 8, 1.7976931348623157e308, -1.7976931348623157e308);
            }
            n.write(e, t, r, i, 52, 8);
            return r + 8;
        }
        o.prototype.writeDoubleLE = function e(t, r, i) {
            return K(this, t, r, true, i);
        };
        o.prototype.writeDoubleBE = function e(t, r, i) {
            return K(this, t, r, false, i);
        };
        o.prototype.copy = function e(t, r, i, n) {
            if (!i) i = 0;
            if (!n && n !== 0) n = this.length;
            if (r >= t.length) r = t.length;
            if (!r) r = 0;
            if (n > 0 && n < i) n = i;
            if (n === i) return 0;
            if (t.length === 0 || this.length === 0) return 0;
            if (r < 0) {
                throw new RangeError("targetStart out of bounds");
            }
            if (i < 0 || i >= this.length) throw new RangeError("sourceStart out of bounds");
            if (n < 0) throw new RangeError("sourceEnd out of bounds");
            if (n > this.length) n = this.length;
            if (t.length - r < n - i) {
                n = t.length - r + i;
            }
            var a = n - i;
            var s;
            if (this === t && i < r && r < n) {
                for (s = a - 1; s >= 0; --s) {
                    t[s + r] = this[s + i];
                }
            } else if (a < 1e3) {
                for (s = 0; s < a; ++s) {
                    t[s + r] = this[s + i];
                }
            } else {
                Uint8Array.prototype.set.call(t, this.subarray(i, i + a), r);
            }
            return a;
        };
        o.prototype.fill = function e(t, r, i, n) {
            if (typeof t === "string") {
                if (typeof r === "string") {
                    n = r;
                    r = 0;
                    i = this.length;
                } else if (typeof i === "string") {
                    n = i;
                    i = this.length;
                }
                if (t.length === 1) {
                    var a = t.charCodeAt(0);
                    if (a < 256) {
                        t = a;
                    }
                }
                if (n !== undefined && typeof n !== "string") {
                    throw new TypeError("encoding must be a string");
                }
                if (typeof n === "string" && !o.isEncoding(n)) {
                    throw new TypeError("Unknown encoding: " + n);
                }
            } else if (typeof t === "number") {
                t = t & 255;
            }
            if (r < 0 || this.length < r || this.length < i) {
                throw new RangeError("Out of range index");
            }
            if (i <= r) {
                return this;
            }
            r = r >>> 0;
            i = i === undefined ? this.length : i >>> 0;
            if (!t) t = 0;
            var s;
            if (typeof t === "number") {
                for (s = r; s < i; ++s) {
                    this[s] = t;
                }
            } else {
                var f = o.isBuffer(t) ? t : new o(t, n);
                var c = f.length;
                for (s = 0; s < i - r; ++s) {
                    this[s + r] = f[s % c];
                }
            }
            return this;
        };
        var F = /[^+/0-9A-Za-z-_]/g;
        function H(e) {
            e = e.trim().replace(F, "");
            if (e.length < 2) return "";
            while (e.length % 4 !== 0) {
                e = e + "=";
            }
            return e;
        }
        function W(e) {
            if (e < 16) return "0" + e.toString(16);
            return e.toString(16);
        }
        function V(e, t) {
            t = t || Infinity;
            var r;
            var i = e.length;
            var n = null;
            var a = [];
            for (var s = 0; s < i; ++s) {
                r = e.charCodeAt(s);
                if (r > 55295 && r < 57344) {
                    if (!n) {
                        if (r > 56319) {
                            if ((t -= 3) > -1) a.push(239, 191, 189);
                            continue;
                        } else if (s + 1 === i) {
                            if ((t -= 3) > -1) a.push(239, 191, 189);
                            continue;
                        }
                        n = r;
                        continue;
                    }
                    if (r < 56320) {
                        if ((t -= 3) > -1) a.push(239, 191, 189);
                        n = r;
                        continue;
                    }
                    r = (n - 55296 << 10 | r - 56320) + 65536;
                } else if (n) {
                    if ((t -= 3) > -1) a.push(239, 191, 189);
                }
                n = null;
                if (r < 128) {
                    if ((t -= 1) < 0) break;
                    a.push(r);
                } else if (r < 2048) {
                    if ((t -= 2) < 0) break;
                    a.push(r >> 6 | 192, r & 63 | 128);
                } else if (r < 65536) {
                    if ((t -= 3) < 0) break;
                    a.push(r >> 12 | 224, r >> 6 & 63 | 128, r & 63 | 128);
                } else if (r < 1114112) {
                    if ((t -= 4) < 0) break;
                    a.push(r >> 18 | 240, r >> 12 & 63 | 128, r >> 6 & 63 | 128, r & 63 | 128);
                } else {
                    throw new Error("Invalid code point");
                }
            }
            return a;
        }
        function X(e) {
            var t = [];
            for (var r = 0; r < e.length; ++r) {
                t.push(e.charCodeAt(r) & 255);
            }
            return t;
        }
        function Z(e, t) {
            var r, i, n;
            var a = [];
            for (var s = 0; s < e.length; ++s) {
                if ((t -= 2) < 0) break;
                r = e.charCodeAt(s);
                i = r >> 8;
                n = r % 256;
                a.push(n);
                a.push(i);
            }
            return a;
        }
        function J(e) {
            return i.toByteArray(H(e));
        }
        function Y(e, t, r, i) {
            for (var n = 0; n < i; ++n) {
                if (n + r >= t.length || n >= e.length) break;
                t[n + r] = e[n];
            }
            return n;
        }
        function G(e) {
            return typeof ArrayBuffer.isView === "function" && ArrayBuffer.isView(e);
        }
        function $(e) {
            return e !== e;
        }
    }, {
        "base64-js": 31,
        ieee754: 113
    } ],
    62: [ function(e, t, r) {
        var i = e("safe-buffer").Buffer;
        var n = e("stream").Transform;
        var a = e("string_decoder").StringDecoder;
        var s = e("inherits");
        function f(e) {
            n.call(this);
            this.hashMode = typeof e === "string";
            if (this.hashMode) {
                this[e] = this._finalOrDigest;
            } else {
                this.final = this._finalOrDigest;
            }
            if (this._final) {
                this.__final = this._final;
                this._final = null;
            }
            this._decoder = null;
            this._encoding = null;
        }
        s(f, n);
        f.prototype.update = function(e, t, r) {
            if (typeof e === "string") {
                e = i.from(e, t);
            }
            var n = this._update(e);
            if (this.hashMode) return this;
            if (r) {
                n = this._toString(n, r);
            }
            return n;
        };
        f.prototype.setAutoPadding = function() {};
        f.prototype.getAuthTag = function() {
            throw new Error("trying to get auth tag in unsupported state");
        };
        f.prototype.setAuthTag = function() {
            throw new Error("trying to set auth tag in unsupported state");
        };
        f.prototype.setAAD = function() {
            throw new Error("trying to set aad in unsupported state");
        };
        f.prototype._transform = function(e, t, r) {
            var i;
            try {
                if (this.hashMode) {
                    this._update(e);
                } else {
                    this.push(this._update(e));
                }
            } catch (e) {
                i = e;
            } finally {
                r(i);
            }
        };
        f.prototype._flush = function(e) {
            var t;
            try {
                this.push(this.__final());
            } catch (e) {
                t = e;
            }
            e(t);
        };
        f.prototype._finalOrDigest = function(e) {
            var t = this.__final() || i.alloc(0);
            if (e) {
                t = this._toString(t, e, true);
            }
            return t;
        };
        f.prototype._toString = function(e, t, r) {
            if (!this._decoder) {
                this._decoder = new a(t);
                this._encoding = t;
            }
            if (this._encoding !== t) throw new Error("can't switch encodings");
            var i = this._decoder.write(e);
            if (r) {
                i += this._decoder.end();
            }
            return i;
        };
        t.exports = f;
    }, {
        inherits: 115,
        "safe-buffer": 154,
        stream: 163,
        string_decoder: 164
    } ],
    63: [ function(e, t, r) {
        (function(e) {
            function t(e) {
                if (Array.isArray) {
                    return Array.isArray(e);
                }
                return v(e) === "[object Array]";
            }
            r.isArray = t;
            function i(e) {
                return typeof e === "boolean";
            }
            r.isBoolean = i;
            function n(e) {
                return e === null;
            }
            r.isNull = n;
            function a(e) {
                return e == null;
            }
            r.isNullOrUndefined = a;
            function s(e) {
                return typeof e === "number";
            }
            r.isNumber = s;
            function f(e) {
                return typeof e === "string";
            }
            r.isString = f;
            function o(e) {
                return typeof e === "symbol";
            }
            r.isSymbol = o;
            function c(e) {
                return e === void 0;
            }
            r.isUndefined = c;
            function h(e) {
                return v(e) === "[object RegExp]";
            }
            r.isRegExp = h;
            function u(e) {
                return typeof e === "object" && e !== null;
            }
            r.isObject = u;
            function d(e) {
                return v(e) === "[object Date]";
            }
            r.isDate = d;
            function l(e) {
                return v(e) === "[object Error]" || e instanceof Error;
            }
            r.isError = l;
            function p(e) {
                return typeof e === "function";
            }
            r.isFunction = p;
            function b(e) {
                return e === null || typeof e === "boolean" || typeof e === "number" || typeof e === "string" || typeof e === "symbol" || typeof e === "undefined";
            }
            r.isPrimitive = b;
            r.isBuffer = e.isBuffer;
            function v(e) {
                return Object.prototype.toString.call(e);
            }
        }).call(this, {
            isBuffer: e("../../is-buffer/index.js")
        });
    }, {
        "../../is-buffer/index.js": 116
    } ],
    64: [ function(e, t, r) {
        (function(r) {
            var i = e("elliptic");
            var n = e("bn.js");
            t.exports = function e(t) {
                return new s(t);
            };
            var a = {
                secp256k1: {
                    name: "secp256k1",
                    byteLength: 32
                },
                secp224r1: {
                    name: "p224",
                    byteLength: 28
                },
                prime256v1: {
                    name: "p256",
                    byteLength: 32
                },
                prime192v1: {
                    name: "p192",
                    byteLength: 24
                },
                ed25519: {
                    name: "ed25519",
                    byteLength: 32
                },
                secp384r1: {
                    name: "p384",
                    byteLength: 48
                },
                secp521r1: {
                    name: "p521",
                    byteLength: 66
                }
            };
            a.p224 = a.secp224r1;
            a.p256 = a.secp256r1 = a.prime256v1;
            a.p192 = a.secp192r1 = a.prime192v1;
            a.p384 = a.secp384r1;
            a.p521 = a.secp521r1;
            function s(e) {
                this.curveType = a[e];
                if (!this.curveType) {
                    this.curveType = {
                        name: e
                    };
                }
                this.curve = new i.ec(this.curveType.name);
                this.keys = void 0;
            }
            s.prototype.generateKeys = function(e, t) {
                this.keys = this.curve.genKeyPair();
                return this.getPublicKey(e, t);
            };
            s.prototype.computeSecret = function(e, t, i) {
                t = t || "utf8";
                if (!r.isBuffer(e)) {
                    e = new r(e, t);
                }
                var n = this.curve.keyFromPublic(e).getPublic();
                var a = n.mul(this.keys.getPrivate()).getX();
                return f(a, i, this.curveType.byteLength);
            };
            s.prototype.getPublicKey = function(e, t) {
                var r = this.keys.getPublic(t === "compressed", true);
                if (t === "hybrid") {
                    if (r[r.length - 1] % 2) {
                        r[0] = 7;
                    } else {
                        r[0] = 6;
                    }
                }
                return f(r, e);
            };
            s.prototype.getPrivateKey = function(e) {
                return f(this.keys.getPrivate(), e);
            };
            s.prototype.setPublicKey = function(e, t) {
                t = t || "utf8";
                if (!r.isBuffer(e)) {
                    e = new r(e, t);
                }
                this.keys._importPublic(e);
                return this;
            };
            s.prototype.setPrivateKey = function(e, t) {
                t = t || "utf8";
                if (!r.isBuffer(e)) {
                    e = new r(e, t);
                }
                var i = new n(e);
                i = i.toString(16);
                this.keys._importPrivate(i);
                return this;
            };
            function f(e, t, i) {
                if (!Array.isArray(e)) {
                    e = e.toArray();
                }
                var n = new r(e);
                if (i && n.length < i) {
                    var a = new r(i - n.length);
                    a.fill(0);
                    n = r.concat([ a, n ]);
                }
                if (!t) {
                    return n;
                } else {
                    return n.toString(t);
                }
            }
        }).call(this, e("buffer").Buffer);
    }, {
        "bn.js": 32,
        buffer: 61,
        elliptic: 81
    } ],
    65: [ function(e, t, r) {
        (function(r) {
            "use strict";
            var i = e("inherits");
            var n = e("./md5");
            var a = e("ripemd160");
            var s = e("sha.js");
            var f = e("cipher-base");
            function o(e) {
                f.call(this, "digest");
                this._hash = e;
                this.buffers = [];
            }
            i(o, f);
            o.prototype._update = function(e) {
                this.buffers.push(e);
            };
            o.prototype._final = function() {
                var e = r.concat(this.buffers);
                var t = this._hash(e);
                this.buffers = null;
                return t;
            };
            function c(e) {
                f.call(this, "digest");
                this._hash = e;
            }
            i(c, f);
            c.prototype._update = function(e) {
                this._hash.update(e);
            };
            c.prototype._final = function() {
                return this._hash.digest();
            };
            t.exports = function e(t) {
                t = t.toLowerCase();
                if (t === "md5") return new o(n);
                if (t === "rmd160" || t === "ripemd160") return new c(new a());
                return new c(s(t));
            };
        }).call(this, e("buffer").Buffer);
    }, {
        "./md5": 67,
        buffer: 61,
        "cipher-base": 62,
        inherits: 115,
        ripemd160: 153,
        "sha.js": 156
    } ],
    66: [ function(e, t, r) {
        (function(e) {
            "use strict";
            var r = 4;
            var i = new e(r);
            i.fill(0);
            var n = 8;
            var a = 16;
            function s(t) {
                if (t.length % r !== 0) {
                    var n = t.length + (r - t.length % r);
                    t = e.concat([ t, i ], n);
                }
                var a = new Array(t.length >>> 2);
                for (var s = 0, f = 0; s < t.length; s += r, f++) {
                    a[f] = t.readInt32LE(s);
                }
                return a;
            }
            t.exports = function t(r, i) {
                var f = i(s(r), r.length * n);
                r = new e(a);
                for (var o = 0; o < f.length; o++) {
                    r.writeInt32LE(f[o], o << 2, true);
                }
                return r;
            };
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61
    } ],
    67: [ function(e, t, r) {
        "use strict";
        var i = e("./make-hash");
        function n(e, t) {
            e[t >> 5] |= 128 << t % 32;
            e[(t + 64 >>> 9 << 4) + 14] = t;
            var r = 1732584193;
            var i = -271733879;
            var n = -1732584194;
            var a = 271733878;
            for (var u = 0; u < e.length; u += 16) {
                var d = r;
                var l = i;
                var p = n;
                var b = a;
                r = s(r, i, n, a, e[u + 0], 7, -680876936);
                a = s(a, r, i, n, e[u + 1], 12, -389564586);
                n = s(n, a, r, i, e[u + 2], 17, 606105819);
                i = s(i, n, a, r, e[u + 3], 22, -1044525330);
                r = s(r, i, n, a, e[u + 4], 7, -176418897);
                a = s(a, r, i, n, e[u + 5], 12, 1200080426);
                n = s(n, a, r, i, e[u + 6], 17, -1473231341);
                i = s(i, n, a, r, e[u + 7], 22, -45705983);
                r = s(r, i, n, a, e[u + 8], 7, 1770035416);
                a = s(a, r, i, n, e[u + 9], 12, -1958414417);
                n = s(n, a, r, i, e[u + 10], 17, -42063);
                i = s(i, n, a, r, e[u + 11], 22, -1990404162);
                r = s(r, i, n, a, e[u + 12], 7, 1804603682);
                a = s(a, r, i, n, e[u + 13], 12, -40341101);
                n = s(n, a, r, i, e[u + 14], 17, -1502002290);
                i = s(i, n, a, r, e[u + 15], 22, 1236535329);
                r = f(r, i, n, a, e[u + 1], 5, -165796510);
                a = f(a, r, i, n, e[u + 6], 9, -1069501632);
                n = f(n, a, r, i, e[u + 11], 14, 643717713);
                i = f(i, n, a, r, e[u + 0], 20, -373897302);
                r = f(r, i, n, a, e[u + 5], 5, -701558691);
                a = f(a, r, i, n, e[u + 10], 9, 38016083);
                n = f(n, a, r, i, e[u + 15], 14, -660478335);
                i = f(i, n, a, r, e[u + 4], 20, -405537848);
                r = f(r, i, n, a, e[u + 9], 5, 568446438);
                a = f(a, r, i, n, e[u + 14], 9, -1019803690);
                n = f(n, a, r, i, e[u + 3], 14, -187363961);
                i = f(i, n, a, r, e[u + 8], 20, 1163531501);
                r = f(r, i, n, a, e[u + 13], 5, -1444681467);
                a = f(a, r, i, n, e[u + 2], 9, -51403784);
                n = f(n, a, r, i, e[u + 7], 14, 1735328473);
                i = f(i, n, a, r, e[u + 12], 20, -1926607734);
                r = o(r, i, n, a, e[u + 5], 4, -378558);
                a = o(a, r, i, n, e[u + 8], 11, -2022574463);
                n = o(n, a, r, i, e[u + 11], 16, 1839030562);
                i = o(i, n, a, r, e[u + 14], 23, -35309556);
                r = o(r, i, n, a, e[u + 1], 4, -1530992060);
                a = o(a, r, i, n, e[u + 4], 11, 1272893353);
                n = o(n, a, r, i, e[u + 7], 16, -155497632);
                i = o(i, n, a, r, e[u + 10], 23, -1094730640);
                r = o(r, i, n, a, e[u + 13], 4, 681279174);
                a = o(a, r, i, n, e[u + 0], 11, -358537222);
                n = o(n, a, r, i, e[u + 3], 16, -722521979);
                i = o(i, n, a, r, e[u + 6], 23, 76029189);
                r = o(r, i, n, a, e[u + 9], 4, -640364487);
                a = o(a, r, i, n, e[u + 12], 11, -421815835);
                n = o(n, a, r, i, e[u + 15], 16, 530742520);
                i = o(i, n, a, r, e[u + 2], 23, -995338651);
                r = c(r, i, n, a, e[u + 0], 6, -198630844);
                a = c(a, r, i, n, e[u + 7], 10, 1126891415);
                n = c(n, a, r, i, e[u + 14], 15, -1416354905);
                i = c(i, n, a, r, e[u + 5], 21, -57434055);
                r = c(r, i, n, a, e[u + 12], 6, 1700485571);
                a = c(a, r, i, n, e[u + 3], 10, -1894986606);
                n = c(n, a, r, i, e[u + 10], 15, -1051523);
                i = c(i, n, a, r, e[u + 1], 21, -2054922799);
                r = c(r, i, n, a, e[u + 8], 6, 1873313359);
                a = c(a, r, i, n, e[u + 15], 10, -30611744);
                n = c(n, a, r, i, e[u + 6], 15, -1560198380);
                i = c(i, n, a, r, e[u + 13], 21, 1309151649);
                r = c(r, i, n, a, e[u + 4], 6, -145523070);
                a = c(a, r, i, n, e[u + 11], 10, -1120210379);
                n = c(n, a, r, i, e[u + 2], 15, 718787259);
                i = c(i, n, a, r, e[u + 9], 21, -343485551);
                r = h(r, d);
                i = h(i, l);
                n = h(n, p);
                a = h(a, b);
            }
            return [ r, i, n, a ];
        }
        function a(e, t, r, i, n, a) {
            return h(u(h(h(t, e), h(i, a)), n), r);
        }
        function s(e, t, r, i, n, s, f) {
            return a(t & r | ~t & i, e, t, n, s, f);
        }
        function f(e, t, r, i, n, s, f) {
            return a(t & i | r & ~i, e, t, n, s, f);
        }
        function o(e, t, r, i, n, s, f) {
            return a(t ^ r ^ i, e, t, n, s, f);
        }
        function c(e, t, r, i, n, s, f) {
            return a(r ^ (t | ~i), e, t, n, s, f);
        }
        function h(e, t) {
            var r = (e & 65535) + (t & 65535);
            var i = (e >> 16) + (t >> 16) + (r >> 16);
            return i << 16 | r & 65535;
        }
        function u(e, t) {
            return e << t | e >>> 32 - t;
        }
        t.exports = function e(t) {
            return i(t, n);
        };
    }, {
        "./make-hash": 66
    } ],
    68: [ function(e, t, r) {
        "use strict";
        var i = e("inherits");
        var n = e("./legacy");
        var a = e("cipher-base");
        var s = e("safe-buffer").Buffer;
        var f = e("create-hash/md5");
        var o = e("ripemd160");
        var c = e("sha.js");
        var h = s.alloc(128);
        function u(e, t) {
            a.call(this, "digest");
            if (typeof t === "string") {
                t = s.from(t);
            }
            var r = e === "sha512" || e === "sha384" ? 128 : 64;
            this._alg = e;
            this._key = t;
            if (t.length > r) {
                var i = e === "rmd160" ? new o() : c(e);
                t = i.update(t).digest();
            } else if (t.length < r) {
                t = s.concat([ t, h ], r);
            }
            var n = this._ipad = s.allocUnsafe(r);
            var f = this._opad = s.allocUnsafe(r);
            for (var u = 0; u < r; u++) {
                n[u] = t[u] ^ 54;
                f[u] = t[u] ^ 92;
            }
            this._hash = e === "rmd160" ? new o() : c(e);
            this._hash.update(n);
        }
        i(u, a);
        u.prototype._update = function(e) {
            this._hash.update(e);
        };
        u.prototype._final = function() {
            var e = this._hash.digest();
            var t = this._alg === "rmd160" ? new o() : c(this._alg);
            return t.update(this._opad).update(e).digest();
        };
        t.exports = function e(t, r) {
            t = t.toLowerCase();
            if (t === "rmd160" || t === "ripemd160") {
                return new u("rmd160", r);
            }
            if (t === "md5") {
                return new n(f, r);
            }
            return new u(t, r);
        };
    }, {
        "./legacy": 69,
        "cipher-base": 62,
        "create-hash/md5": 67,
        inherits: 115,
        ripemd160: 153,
        "safe-buffer": 154,
        "sha.js": 156
    } ],
    69: [ function(e, t, r) {
        "use strict";
        var i = e("inherits");
        var n = e("safe-buffer").Buffer;
        var a = e("cipher-base");
        var s = n.alloc(128);
        var f = 64;
        function o(e, t) {
            a.call(this, "digest");
            if (typeof t === "string") {
                t = n.from(t);
            }
            this._alg = e;
            this._key = t;
            if (t.length > f) {
                t = e(t);
            } else if (t.length < f) {
                t = n.concat([ t, s ], f);
            }
            var r = this._ipad = n.allocUnsafe(f);
            var i = this._opad = n.allocUnsafe(f);
            for (var o = 0; o < f; o++) {
                r[o] = t[o] ^ 54;
                i[o] = t[o] ^ 92;
            }
            this._hash = [ r ];
        }
        i(o, a);
        o.prototype._update = function(e) {
            this._hash.push(e);
        };
        o.prototype._final = function() {
            var e = this._alg(n.concat(this._hash));
            return this._alg(n.concat([ this._opad, e ]));
        };
        t.exports = o;
    }, {
        "cipher-base": 62,
        inherits: 115,
        "safe-buffer": 154
    } ],
    70: [ function(e, t, r) {
        "use strict";
        r.randomBytes = r.rng = r.pseudoRandomBytes = r.prng = e("randombytes");
        r.createHash = r.Hash = e("create-hash");
        r.createHmac = r.Hmac = e("create-hmac");
        var i = [ "sha1", "sha224", "sha256", "sha384", "sha512", "md5", "rmd160" ].concat(Object.keys(e("browserify-sign/algos")));
        r.getHashes = function() {
            return i;
        };
        var n = e("pbkdf2");
        r.pbkdf2 = n.pbkdf2;
        r.pbkdf2Sync = n.pbkdf2Sync;
        var a = e("browserify-cipher");
        [ "Cipher", "createCipher", "Cipheriv", "createCipheriv", "Decipher", "createDecipher", "Decipheriv", "createDecipheriv", "getCiphers", "listCiphers" ].forEach(function(e) {
            r[e] = a[e];
        });
        var s = e("diffie-hellman");
        [ "DiffieHellmanGroup", "createDiffieHellmanGroup", "getDiffieHellman", "createDiffieHellman", "DiffieHellman" ].forEach(function(e) {
            r[e] = s[e];
        });
        var f = e("browserify-sign");
        [ "createSign", "Sign", "createVerify", "Verify" ].forEach(function(e) {
            r[e] = f[e];
        });
        r.createECDH = e("create-ecdh");
        var o = e("public-encrypt");
        [ "publicEncrypt", "privateEncrypt", "publicDecrypt", "privateDecrypt" ].forEach(function(e) {
            r[e] = o[e];
        });
        [ "createCredentials" ].forEach(function(e) {
            r[e] = function() {
                throw new Error([ "sorry, " + e + " is not implemented yet", "we accept pull requests", "https://github.com/crypto-browserify/crypto-browserify" ].join("\n"));
            };
        });
    }, {
        "browserify-cipher": 50,
        "browserify-sign": 57,
        "browserify-sign/algos": 54,
        "create-ecdh": 64,
        "create-hash": 65,
        "create-hmac": 68,
        "diffie-hellman": 77,
        pbkdf2: 126,
        "public-encrypt": 133,
        randombytes: 139
    } ],
    71: [ function(e, t, r) {
        "use strict";
        r.utils = e("./des/utils");
        r.Cipher = e("./des/cipher");
        r.DES = e("./des/des");
        r.CBC = e("./des/cbc");
        r.EDE = e("./des/ede");
    }, {
        "./des/cbc": 72,
        "./des/cipher": 73,
        "./des/des": 74,
        "./des/ede": 75,
        "./des/utils": 76
    } ],
    72: [ function(e, t, r) {
        "use strict";
        var i = e("minimalistic-assert");
        var n = e("inherits");
        var a = {};
        function s(e) {
            i.equal(e.length, 8, "Invalid IV length");
            this.iv = new Array(8);
            for (var t = 0; t < this.iv.length; t++) this.iv[t] = e[t];
        }
        function f(e) {
            function t(t) {
                e.call(this, t);
                this._cbcInit();
            }
            n(t, e);
            var r = Object.keys(a);
            for (var i = 0; i < r.length; i++) {
                var s = r[i];
                t.prototype[s] = a[s];
            }
            t.create = function e(r) {
                return new t(r);
            };
            return t;
        }
        r.instantiate = f;
        a._cbcInit = function e() {
            var t = new s(this.options.iv);
            this._cbcState = t;
        };
        a._update = function e(t, r, i, n) {
            var a = this._cbcState;
            var s = this.constructor.super_.prototype;
            var f = a.iv;
            if (this.type === "encrypt") {
                for (var o = 0; o < this.blockSize; o++) f[o] ^= t[r + o];
                s._update.call(this, f, 0, i, n);
                for (var o = 0; o < this.blockSize; o++) f[o] = i[n + o];
            } else {
                s._update.call(this, t, r, i, n);
                for (var o = 0; o < this.blockSize; o++) i[n + o] ^= f[o];
                for (var o = 0; o < this.blockSize; o++) f[o] = t[r + o];
            }
        };
    }, {
        inherits: 115,
        "minimalistic-assert": 119
    } ],
    73: [ function(e, t, r) {
        "use strict";
        var i = e("minimalistic-assert");
        function n(e) {
            this.options = e;
            this.type = this.options.type;
            this.blockSize = 8;
            this._init();
            this.buffer = new Array(this.blockSize);
            this.bufferOff = 0;
        }
        t.exports = n;
        n.prototype._init = function e() {};
        n.prototype.update = function e(t) {
            if (t.length === 0) return [];
            if (this.type === "decrypt") return this._updateDecrypt(t); else return this._updateEncrypt(t);
        };
        n.prototype._buffer = function e(t, r) {
            var i = Math.min(this.buffer.length - this.bufferOff, t.length - r);
            for (var n = 0; n < i; n++) this.buffer[this.bufferOff + n] = t[r + n];
            this.bufferOff += i;
            return i;
        };
        n.prototype._flushBuffer = function e(t, r) {
            this._update(this.buffer, 0, t, r);
            this.bufferOff = 0;
            return this.blockSize;
        };
        n.prototype._updateEncrypt = function e(t) {
            var r = 0;
            var i = 0;
            var n = (this.bufferOff + t.length) / this.blockSize | 0;
            var a = new Array(n * this.blockSize);
            if (this.bufferOff !== 0) {
                r += this._buffer(t, r);
                if (this.bufferOff === this.buffer.length) i += this._flushBuffer(a, i);
            }
            var s = t.length - (t.length - r) % this.blockSize;
            for (;r < s; r += this.blockSize) {
                this._update(t, r, a, i);
                i += this.blockSize;
            }
            for (;r < t.length; r++, this.bufferOff++) this.buffer[this.bufferOff] = t[r];
            return a;
        };
        n.prototype._updateDecrypt = function e(t) {
            var r = 0;
            var i = 0;
            var n = Math.ceil((this.bufferOff + t.length) / this.blockSize) - 1;
            var a = new Array(n * this.blockSize);
            for (;n > 0; n--) {
                r += this._buffer(t, r);
                i += this._flushBuffer(a, i);
            }
            r += this._buffer(t, r);
            return a;
        };
        n.prototype.final = function e(t) {
            var r;
            if (t) r = this.update(t);
            var i;
            if (this.type === "encrypt") i = this._finalEncrypt(); else i = this._finalDecrypt();
            if (r) return r.concat(i); else return i;
        };
        n.prototype._pad = function e(t, r) {
            if (r === 0) return false;
            while (r < t.length) t[r++] = 0;
            return true;
        };
        n.prototype._finalEncrypt = function e() {
            if (!this._pad(this.buffer, this.bufferOff)) return [];
            var t = new Array(this.blockSize);
            this._update(this.buffer, 0, t, 0);
            return t;
        };
        n.prototype._unpad = function e(t) {
            return t;
        };
        n.prototype._finalDecrypt = function e() {
            i.equal(this.bufferOff, this.blockSize, "Not enough data to decrypt");
            var t = new Array(this.blockSize);
            this._flushBuffer(t, 0);
            return this._unpad(t);
        };
    }, {
        "minimalistic-assert": 119
    } ],
    74: [ function(e, t, r) {
        "use strict";
        var i = e("minimalistic-assert");
        var n = e("inherits");
        var a = e("../des");
        var s = a.utils;
        var f = a.Cipher;
        function o() {
            this.tmp = new Array(2);
            this.keys = null;
        }
        function c(e) {
            f.call(this, e);
            var t = new o();
            this._desState = t;
            this.deriveKeys(t, e.key);
        }
        n(c, f);
        t.exports = c;
        c.create = function e(t) {
            return new c(t);
        };
        var h = [ 1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1 ];
        c.prototype.deriveKeys = function e(t, r) {
            t.keys = new Array(16 * 2);
            i.equal(r.length, this.blockSize, "Invalid key length");
            var n = s.readUInt32BE(r, 0);
            var a = s.readUInt32BE(r, 4);
            s.pc1(n, a, t.tmp, 0);
            n = t.tmp[0];
            a = t.tmp[1];
            for (var f = 0; f < t.keys.length; f += 2) {
                var o = h[f >>> 1];
                n = s.r28shl(n, o);
                a = s.r28shl(a, o);
                s.pc2(n, a, t.keys, f);
            }
        };
        c.prototype._update = function e(t, r, i, n) {
            var a = this._desState;
            var f = s.readUInt32BE(t, r);
            var o = s.readUInt32BE(t, r + 4);
            s.ip(f, o, a.tmp, 0);
            f = a.tmp[0];
            o = a.tmp[1];
            if (this.type === "encrypt") this._encrypt(a, f, o, a.tmp, 0); else this._decrypt(a, f, o, a.tmp, 0);
            f = a.tmp[0];
            o = a.tmp[1];
            s.writeUInt32BE(i, f, n);
            s.writeUInt32BE(i, o, n + 4);
        };
        c.prototype._pad = function e(t, r) {
            var i = t.length - r;
            for (var n = r; n < t.length; n++) t[n] = i;
            return true;
        };
        c.prototype._unpad = function e(t) {
            var r = t[t.length - 1];
            for (var n = t.length - r; n < t.length; n++) i.equal(t[n], r);
            return t.slice(0, t.length - r);
        };
        c.prototype._encrypt = function e(t, r, i, n, a) {
            var f = r;
            var o = i;
            for (var c = 0; c < t.keys.length; c += 2) {
                var h = t.keys[c];
                var u = t.keys[c + 1];
                s.expand(o, t.tmp, 0);
                h ^= t.tmp[0];
                u ^= t.tmp[1];
                var d = s.substitute(h, u);
                var l = s.permute(d);
                var p = o;
                o = (f ^ l) >>> 0;
                f = p;
            }
            s.rip(o, f, n, a);
        };
        c.prototype._decrypt = function e(t, r, i, n, a) {
            var f = i;
            var o = r;
            for (var c = t.keys.length - 2; c >= 0; c -= 2) {
                var h = t.keys[c];
                var u = t.keys[c + 1];
                s.expand(f, t.tmp, 0);
                h ^= t.tmp[0];
                u ^= t.tmp[1];
                var d = s.substitute(h, u);
                var l = s.permute(d);
                var p = f;
                f = (o ^ l) >>> 0;
                o = p;
            }
            s.rip(f, o, n, a);
        };
    }, {
        "../des": 71,
        inherits: 115,
        "minimalistic-assert": 119
    } ],
    75: [ function(e, t, r) {
        "use strict";
        var i = e("minimalistic-assert");
        var n = e("inherits");
        var a = e("../des");
        var s = a.Cipher;
        var f = a.DES;
        function o(e, t) {
            i.equal(t.length, 24, "Invalid key length");
            var r = t.slice(0, 8);
            var n = t.slice(8, 16);
            var a = t.slice(16, 24);
            if (e === "encrypt") {
                this.ciphers = [ f.create({
                    type: "encrypt",
                    key: r
                }), f.create({
                    type: "decrypt",
                    key: n
                }), f.create({
                    type: "encrypt",
                    key: a
                }) ];
            } else {
                this.ciphers = [ f.create({
                    type: "decrypt",
                    key: a
                }), f.create({
                    type: "encrypt",
                    key: n
                }), f.create({
                    type: "decrypt",
                    key: r
                }) ];
            }
        }
        function c(e) {
            s.call(this, e);
            var t = new o(this.type, this.options.key);
            this._edeState = t;
        }
        n(c, s);
        t.exports = c;
        c.create = function e(t) {
            return new c(t);
        };
        c.prototype._update = function e(t, r, i, n) {
            var a = this._edeState;
            a.ciphers[0]._update(t, r, i, n);
            a.ciphers[1]._update(i, n, i, n);
            a.ciphers[2]._update(i, n, i, n);
        };
        c.prototype._pad = f.prototype._pad;
        c.prototype._unpad = f.prototype._unpad;
    }, {
        "../des": 71,
        inherits: 115,
        "minimalistic-assert": 119
    } ],
    76: [ function(e, t, r) {
        "use strict";
        r.readUInt32BE = function e(t, r) {
            var i = t[0 + r] << 24 | t[1 + r] << 16 | t[2 + r] << 8 | t[3 + r];
            return i >>> 0;
        };
        r.writeUInt32BE = function e(t, r, i) {
            t[0 + i] = r >>> 24;
            t[1 + i] = r >>> 16 & 255;
            t[2 + i] = r >>> 8 & 255;
            t[3 + i] = r & 255;
        };
        r.ip = function e(t, r, i, n) {
            var a = 0;
            var s = 0;
            for (var f = 6; f >= 0; f -= 2) {
                for (var o = 0; o <= 24; o += 8) {
                    a <<= 1;
                    a |= r >>> o + f & 1;
                }
                for (var o = 0; o <= 24; o += 8) {
                    a <<= 1;
                    a |= t >>> o + f & 1;
                }
            }
            for (var f = 6; f >= 0; f -= 2) {
                for (var o = 1; o <= 25; o += 8) {
                    s <<= 1;
                    s |= r >>> o + f & 1;
                }
                for (var o = 1; o <= 25; o += 8) {
                    s <<= 1;
                    s |= t >>> o + f & 1;
                }
            }
            i[n + 0] = a >>> 0;
            i[n + 1] = s >>> 0;
        };
        r.rip = function e(t, r, i, n) {
            var a = 0;
            var s = 0;
            for (var f = 0; f < 4; f++) {
                for (var o = 24; o >= 0; o -= 8) {
                    a <<= 1;
                    a |= r >>> o + f & 1;
                    a <<= 1;
                    a |= t >>> o + f & 1;
                }
            }
            for (var f = 4; f < 8; f++) {
                for (var o = 24; o >= 0; o -= 8) {
                    s <<= 1;
                    s |= r >>> o + f & 1;
                    s <<= 1;
                    s |= t >>> o + f & 1;
                }
            }
            i[n + 0] = a >>> 0;
            i[n + 1] = s >>> 0;
        };
        r.pc1 = function e(t, r, i, n) {
            var a = 0;
            var s = 0;
            for (var f = 7; f >= 5; f--) {
                for (var o = 0; o <= 24; o += 8) {
                    a <<= 1;
                    a |= r >> o + f & 1;
                }
                for (var o = 0; o <= 24; o += 8) {
                    a <<= 1;
                    a |= t >> o + f & 1;
                }
            }
            for (var o = 0; o <= 24; o += 8) {
                a <<= 1;
                a |= r >> o + f & 1;
            }
            for (var f = 1; f <= 3; f++) {
                for (var o = 0; o <= 24; o += 8) {
                    s <<= 1;
                    s |= r >> o + f & 1;
                }
                for (var o = 0; o <= 24; o += 8) {
                    s <<= 1;
                    s |= t >> o + f & 1;
                }
            }
            for (var o = 0; o <= 24; o += 8) {
                s <<= 1;
                s |= t >> o + f & 1;
            }
            i[n + 0] = a >>> 0;
            i[n + 1] = s >>> 0;
        };
        r.r28shl = function e(t, r) {
            return t << r & 268435455 | t >>> 28 - r;
        };
        var i = [ 14, 11, 17, 4, 27, 23, 25, 0, 13, 22, 7, 18, 5, 9, 16, 24, 2, 20, 12, 21, 1, 8, 15, 26, 15, 4, 25, 19, 9, 1, 26, 16, 5, 11, 23, 8, 12, 7, 17, 0, 22, 3, 10, 14, 6, 20, 27, 24 ];
        r.pc2 = function e(t, r, n, a) {
            var s = 0;
            var f = 0;
            var o = i.length >>> 1;
            for (var c = 0; c < o; c++) {
                s <<= 1;
                s |= t >>> i[c] & 1;
            }
            for (var c = o; c < i.length; c++) {
                f <<= 1;
                f |= r >>> i[c] & 1;
            }
            n[a + 0] = s >>> 0;
            n[a + 1] = f >>> 0;
        };
        r.expand = function e(t, r, i) {
            var n = 0;
            var a = 0;
            n = (t & 1) << 5 | t >>> 27;
            for (var s = 23; s >= 15; s -= 4) {
                n <<= 6;
                n |= t >>> s & 63;
            }
            for (var s = 11; s >= 3; s -= 4) {
                a |= t >>> s & 63;
                a <<= 6;
            }
            a |= (t & 31) << 1 | t >>> 31;
            r[i + 0] = n >>> 0;
            r[i + 1] = a >>> 0;
        };
        var n = [ 14, 0, 4, 15, 13, 7, 1, 4, 2, 14, 15, 2, 11, 13, 8, 1, 3, 10, 10, 6, 6, 12, 12, 11, 5, 9, 9, 5, 0, 3, 7, 8, 4, 15, 1, 12, 14, 8, 8, 2, 13, 4, 6, 9, 2, 1, 11, 7, 15, 5, 12, 11, 9, 3, 7, 14, 3, 10, 10, 0, 5, 6, 0, 13, 15, 3, 1, 13, 8, 4, 14, 7, 6, 15, 11, 2, 3, 8, 4, 14, 9, 12, 7, 0, 2, 1, 13, 10, 12, 6, 0, 9, 5, 11, 10, 5, 0, 13, 14, 8, 7, 10, 11, 1, 10, 3, 4, 15, 13, 4, 1, 2, 5, 11, 8, 6, 12, 7, 6, 12, 9, 0, 3, 5, 2, 14, 15, 9, 10, 13, 0, 7, 9, 0, 14, 9, 6, 3, 3, 4, 15, 6, 5, 10, 1, 2, 13, 8, 12, 5, 7, 14, 11, 12, 4, 11, 2, 15, 8, 1, 13, 1, 6, 10, 4, 13, 9, 0, 8, 6, 15, 9, 3, 8, 0, 7, 11, 4, 1, 15, 2, 14, 12, 3, 5, 11, 10, 5, 14, 2, 7, 12, 7, 13, 13, 8, 14, 11, 3, 5, 0, 6, 6, 15, 9, 0, 10, 3, 1, 4, 2, 7, 8, 2, 5, 12, 11, 1, 12, 10, 4, 14, 15, 9, 10, 3, 6, 15, 9, 0, 0, 6, 12, 10, 11, 1, 7, 13, 13, 8, 15, 9, 1, 4, 3, 5, 14, 11, 5, 12, 2, 7, 8, 2, 4, 14, 2, 14, 12, 11, 4, 2, 1, 12, 7, 4, 10, 7, 11, 13, 6, 1, 8, 5, 5, 0, 3, 15, 15, 10, 13, 3, 0, 9, 14, 8, 9, 6, 4, 11, 2, 8, 1, 12, 11, 7, 10, 1, 13, 14, 7, 2, 8, 13, 15, 6, 9, 15, 12, 0, 5, 9, 6, 10, 3, 4, 0, 5, 14, 3, 12, 10, 1, 15, 10, 4, 15, 2, 9, 7, 2, 12, 6, 9, 8, 5, 0, 6, 13, 1, 3, 13, 4, 14, 14, 0, 7, 11, 5, 3, 11, 8, 9, 4, 14, 3, 15, 2, 5, 12, 2, 9, 8, 5, 12, 15, 3, 10, 7, 11, 0, 14, 4, 1, 10, 7, 1, 6, 13, 0, 11, 8, 6, 13, 4, 13, 11, 0, 2, 11, 14, 7, 15, 4, 0, 9, 8, 1, 13, 10, 3, 14, 12, 3, 9, 5, 7, 12, 5, 2, 10, 15, 6, 8, 1, 6, 1, 6, 4, 11, 11, 13, 13, 8, 12, 1, 3, 4, 7, 10, 14, 7, 10, 9, 15, 5, 6, 0, 8, 15, 0, 14, 5, 2, 9, 3, 2, 12, 13, 1, 2, 15, 8, 13, 4, 8, 6, 10, 15, 3, 11, 7, 1, 4, 10, 12, 9, 5, 3, 6, 14, 11, 5, 0, 0, 14, 12, 9, 7, 2, 7, 2, 11, 1, 4, 14, 1, 7, 9, 4, 12, 10, 14, 8, 2, 13, 0, 15, 6, 12, 10, 9, 13, 0, 15, 3, 3, 5, 5, 6, 8, 11 ];
        r.substitute = function e(t, r) {
            var i = 0;
            for (var a = 0; a < 4; a++) {
                var s = t >>> 18 - a * 6 & 63;
                var f = n[a * 64 + s];
                i <<= 4;
                i |= f;
            }
            for (var a = 0; a < 4; a++) {
                var s = r >>> 18 - a * 6 & 63;
                var f = n[4 * 64 + a * 64 + s];
                i <<= 4;
                i |= f;
            }
            return i >>> 0;
        };
        var a = [ 16, 25, 12, 11, 3, 20, 4, 15, 31, 17, 9, 6, 27, 14, 1, 22, 30, 24, 8, 18, 0, 5, 29, 23, 13, 19, 2, 26, 10, 21, 28, 7 ];
        r.permute = function e(t) {
            var r = 0;
            for (var i = 0; i < a.length; i++) {
                r <<= 1;
                r |= t >>> a[i] & 1;
            }
            return r >>> 0;
        };
        r.padSplit = function e(t, r, i) {
            var n = t.toString(2);
            while (n.length < r) n = "0" + n;
            var a = [];
            for (var s = 0; s < r; s += i) a.push(n.slice(s, s + i));
            return a.join(" ");
        };
    }, {} ],
    77: [ function(e, t, r) {
        (function(t) {
            var i = e("./lib/generatePrime");
            var n = e("./lib/primes.json");
            var a = e("./lib/dh");
            function s(e) {
                var r = new t(n[e].prime, "hex");
                var i = new t(n[e].gen, "hex");
                return new a(r, i);
            }
            var f = {
                binary: true,
                hex: true,
                base64: true
            };
            function o(e, r, n, s) {
                if (t.isBuffer(r) || f[r] === undefined) {
                    return o(e, "binary", r, n);
                }
                r = r || "binary";
                s = s || "binary";
                n = n || new t([ 2 ]);
                if (!t.isBuffer(n)) {
                    n = new t(n, s);
                }
                if (typeof e === "number") {
                    return new a(i(e, n), n, true);
                }
                if (!t.isBuffer(e)) {
                    e = new t(e, r);
                }
                return new a(e, n, true);
            }
            r.DiffieHellmanGroup = r.createDiffieHellmanGroup = r.getDiffieHellman = s;
            r.createDiffieHellman = r.DiffieHellman = o;
        }).call(this, e("buffer").Buffer);
    }, {
        "./lib/dh": 78,
        "./lib/generatePrime": 79,
        "./lib/primes.json": 80,
        buffer: 61
    } ],
    78: [ function(e, t, r) {
        (function(r) {
            var i = e("bn.js");
            var n = e("miller-rabin");
            var a = new n();
            var s = new i(24);
            var f = new i(11);
            var o = new i(10);
            var c = new i(3);
            var h = new i(7);
            var u = e("./generatePrime");
            var d = e("randombytes");
            t.exports = m;
            function l(e, t) {
                t = t || "utf8";
                if (!r.isBuffer(e)) {
                    e = new r(e, t);
                }
                this._pub = new i(e);
                return this;
            }
            function p(e, t) {
                t = t || "utf8";
                if (!r.isBuffer(e)) {
                    e = new r(e, t);
                }
                this._priv = new i(e);
                return this;
            }
            var b = {};
            function v(e, t) {
                var r = t.toString("hex");
                var i = [ r, e.toString(16) ].join("_");
                if (i in b) {
                    return b[i];
                }
                var n = 0;
                if (e.isEven() || !u.simpleSieve || !u.fermatTest(e) || !a.test(e)) {
                    n += 1;
                    if (r === "02" || r === "05") {
                        n += 8;
                    } else {
                        n += 4;
                    }
                    b[i] = n;
                    return n;
                }
                if (!a.test(e.shrn(1))) {
                    n += 2;
                }
                var d;
                switch (r) {
                  case "02":
                    if (e.mod(s).cmp(f)) {
                        n += 8;
                    }
                    break;

                  case "05":
                    d = e.mod(o);
                    if (d.cmp(c) && d.cmp(h)) {
                        n += 8;
                    }
                    break;

                  default:
                    n += 4;
                }
                b[i] = n;
                return n;
            }
            function m(e, t, r) {
                this.setGenerator(t);
                this.__prime = new i(e);
                this._prime = i.mont(this.__prime);
                this._primeLen = e.length;
                this._pub = undefined;
                this._priv = undefined;
                this._primeCode = undefined;
                if (r) {
                    this.setPublicKey = l;
                    this.setPrivateKey = p;
                } else {
                    this._primeCode = 8;
                }
            }
            Object.defineProperty(m.prototype, "verifyError", {
                enumerable: true,
                get: function() {
                    if (typeof this._primeCode !== "number") {
                        this._primeCode = v(this.__prime, this.__gen);
                    }
                    return this._primeCode;
                }
            });
            m.prototype.generateKeys = function() {
                if (!this._priv) {
                    this._priv = new i(d(this._primeLen));
                }
                this._pub = this._gen.toRed(this._prime).redPow(this._priv).fromRed();
                return this.getPublicKey();
            };
            m.prototype.computeSecret = function(e) {
                e = new i(e);
                e = e.toRed(this._prime);
                var t = e.redPow(this._priv).fromRed();
                var n = new r(t.toArray());
                var a = this.getPrime();
                if (n.length < a.length) {
                    var s = new r(a.length - n.length);
                    s.fill(0);
                    n = r.concat([ s, n ]);
                }
                return n;
            };
            m.prototype.getPublicKey = function e(t) {
                return y(this._pub, t);
            };
            m.prototype.getPrivateKey = function e(t) {
                return y(this._priv, t);
            };
            m.prototype.getPrime = function(e) {
                return y(this.__prime, e);
            };
            m.prototype.getGenerator = function(e) {
                return y(this._gen, e);
            };
            m.prototype.setGenerator = function(e, t) {
                t = t || "utf8";
                if (!r.isBuffer(e)) {
                    e = new r(e, t);
                }
                this.__gen = e;
                this._gen = new i(e);
                return this;
            };
            function y(e, t) {
                var i = new r(e.toArray());
                if (!t) {
                    return i;
                } else {
                    return i.toString(t);
                }
            }
        }).call(this, e("buffer").Buffer);
    }, {
        "./generatePrime": 79,
        "bn.js": 32,
        buffer: 61,
        "miller-rabin": 118,
        randombytes: 139
    } ],
    79: [ function(e, t, r) {
        var i = e("randombytes");
        t.exports = M;
        M.simpleSieve = _;
        M.fermatTest = S;
        var n = e("bn.js");
        var a = new n(24);
        var s = e("miller-rabin");
        var f = new s();
        var o = new n(1);
        var c = new n(2);
        var h = new n(5);
        var u = new n(16);
        var d = new n(8);
        var l = new n(10);
        var p = new n(3);
        var b = new n(7);
        var v = new n(11);
        var m = new n(4);
        var y = new n(12);
        var g = null;
        function w() {
            if (g !== null) return g;
            var e = 1048576;
            var t = [];
            t[0] = 2;
            for (var r = 1, i = 3; i < e; i += 2) {
                var n = Math.ceil(Math.sqrt(i));
                for (var a = 0; a < r && t[a] <= n; a++) if (i % t[a] === 0) break;
                if (r !== a && t[a] <= n) continue;
                t[r++] = i;
            }
            g = t;
            return t;
        }
        function _(e) {
            var t = w();
            for (var r = 0; r < t.length; r++) if (e.modn(t[r]) === 0) {
                if (e.cmpn(t[r]) === 0) {
                    return true;
                } else {
                    return false;
                }
            }
            return true;
        }
        function S(e) {
            var t = n.mont(e);
            return c.toRed(t).redPow(e.subn(1)).fromRed().cmpn(1) === 0;
        }
        function M(e, t) {
            if (e < 16) {
                if (t === 2 || t === 5) {
                    return new n([ 140, 123 ]);
                } else {
                    return new n([ 140, 39 ]);
                }
            }
            t = new n(t);
            var r, s;
            while (true) {
                r = new n(i(Math.ceil(e / 8)));
                while (r.bitLength() > e) {
                    r.ishrn(1);
                }
                if (r.isEven()) {
                    r.iadd(o);
                }
                if (!r.testn(1)) {
                    r.iadd(c);
                }
                if (!t.cmp(c)) {
                    while (r.mod(a).cmp(v)) {
                        r.iadd(m);
                    }
                } else if (!t.cmp(h)) {
                    while (r.mod(l).cmp(p)) {
                        r.iadd(m);
                    }
                }
                s = r.shrn(1);
                if (_(s) && _(r) && S(s) && S(r) && f.test(s) && f.test(r)) {
                    return r;
                }
            }
        }
    }, {
        "bn.js": 32,
        "miller-rabin": 118,
        randombytes: 139
    } ],
    80: [ function(e, t, r) {
        t.exports = {
            modp1: {
                gen: "02",
                prime: "ffffffffffffffffc90fdaa22168c234c4c6628b80dc1cd129024e088a67cc74020bbea63b139b22514a08798e3404ddef9519b3cd3a431b302b0a6df25f14374fe1356d6d51c245e485b576625e7ec6f44c42e9a63a3620ffffffffffffffff"
            },
            modp2: {
                gen: "02",
                prime: "ffffffffffffffffc90fdaa22168c234c4c6628b80dc1cd129024e088a67cc74020bbea63b139b22514a08798e3404ddef9519b3cd3a431b302b0a6df25f14374fe1356d6d51c245e485b576625e7ec6f44c42e9a637ed6b0bff5cb6f406b7edee386bfb5a899fa5ae9f24117c4b1fe649286651ece65381ffffffffffffffff"
            },
            modp5: {
                gen: "02",
                prime: "ffffffffffffffffc90fdaa22168c234c4c6628b80dc1cd129024e088a67cc74020bbea63b139b22514a08798e3404ddef9519b3cd3a431b302b0a6df25f14374fe1356d6d51c245e485b576625e7ec6f44c42e9a637ed6b0bff5cb6f406b7edee386bfb5a899fa5ae9f24117c4b1fe649286651ece45b3dc2007cb8a163bf0598da48361c55d39a69163fa8fd24cf5f83655d23dca3ad961c62f356208552bb9ed529077096966d670c354e4abc9804f1746c08ca237327ffffffffffffffff"
            },
            modp14: {
                gen: "02",
                prime: "ffffffffffffffffc90fdaa22168c234c4c6628b80dc1cd129024e088a67cc74020bbea63b139b22514a08798e3404ddef9519b3cd3a431b302b0a6df25f14374fe1356d6d51c245e485b576625e7ec6f44c42e9a637ed6b0bff5cb6f406b7edee386bfb5a899fa5ae9f24117c4b1fe649286651ece45b3dc2007cb8a163bf0598da48361c55d39a69163fa8fd24cf5f83655d23dca3ad961c62f356208552bb9ed529077096966d670c354e4abc9804f1746c08ca18217c32905e462e36ce3be39e772c180e86039b2783a2ec07a28fb5c55df06f4c52c9de2bcbf6955817183995497cea956ae515d2261898fa051015728e5a8aacaa68ffffffffffffffff"
            },
            modp15: {
                gen: "02",
                prime: "ffffffffffffffffc90fdaa22168c234c4c6628b80dc1cd129024e088a67cc74020bbea63b139b22514a08798e3404ddef9519b3cd3a431b302b0a6df25f14374fe1356d6d51c245e485b576625e7ec6f44c42e9a637ed6b0bff5cb6f406b7edee386bfb5a899fa5ae9f24117c4b1fe649286651ece45b3dc2007cb8a163bf0598da48361c55d39a69163fa8fd24cf5f83655d23dca3ad961c62f356208552bb9ed529077096966d670c354e4abc9804f1746c08ca18217c32905e462e36ce3be39e772c180e86039b2783a2ec07a28fb5c55df06f4c52c9de2bcbf6955817183995497cea956ae515d2261898fa051015728e5a8aaac42dad33170d04507a33a85521abdf1cba64ecfb850458dbef0a8aea71575d060c7db3970f85a6e1e4c7abf5ae8cdb0933d71e8c94e04a25619dcee3d2261ad2ee6bf12ffa06d98a0864d87602733ec86a64521f2b18177b200cbbe117577a615d6c770988c0bad946e208e24fa074e5ab3143db5bfce0fd108e4b82d120a93ad2caffffffffffffffff"
            },
            modp16: {
                gen: "02",
                prime: "ffffffffffffffffc90fdaa22168c234c4c6628b80dc1cd129024e088a67cc74020bbea63b139b22514a08798e3404ddef9519b3cd3a431b302b0a6df25f14374fe1356d6d51c245e485b576625e7ec6f44c42e9a637ed6b0bff5cb6f406b7edee386bfb5a899fa5ae9f24117c4b1fe649286651ece45b3dc2007cb8a163bf0598da48361c55d39a69163fa8fd24cf5f83655d23dca3ad961c62f356208552bb9ed529077096966d670c354e4abc9804f1746c08ca18217c32905e462e36ce3be39e772c180e86039b2783a2ec07a28fb5c55df06f4c52c9de2bcbf6955817183995497cea956ae515d2261898fa051015728e5a8aaac42dad33170d04507a33a85521abdf1cba64ecfb850458dbef0a8aea71575d060c7db3970f85a6e1e4c7abf5ae8cdb0933d71e8c94e04a25619dcee3d2261ad2ee6bf12ffa06d98a0864d87602733ec86a64521f2b18177b200cbbe117577a615d6c770988c0bad946e208e24fa074e5ab3143db5bfce0fd108e4b82d120a92108011a723c12a787e6d788719a10bdba5b2699c327186af4e23c1a946834b6150bda2583e9ca2ad44ce8dbbbc2db04de8ef92e8efc141fbecaa6287c59474e6bc05d99b2964fa090c3a2233ba186515be7ed1f612970cee2d7afb81bdd762170481cd0069127d5b05aa993b4ea988d8fddc186ffb7dc90a6c08f4df435c934063199ffffffffffffffff"
            },
            modp17: {
                gen: "02",
                prime: "ffffffffffffffffc90fdaa22168c234c4c6628b80dc1cd129024e088a67cc74020bbea63b139b22514a08798e3404ddef9519b3cd3a431b302b0a6df25f14374fe1356d6d51c245e485b576625e7ec6f44c42e9a637ed6b0bff5cb6f406b7edee386bfb5a899fa5ae9f24117c4b1fe649286651ece45b3dc2007cb8a163bf0598da48361c55d39a69163fa8fd24cf5f83655d23dca3ad961c62f356208552bb9ed529077096966d670c354e4abc9804f1746c08ca18217c32905e462e36ce3be39e772c180e86039b2783a2ec07a28fb5c55df06f4c52c9de2bcbf6955817183995497cea956ae515d2261898fa051015728e5a8aaac42dad33170d04507a33a85521abdf1cba64ecfb850458dbef0a8aea71575d060c7db3970f85a6e1e4c7abf5ae8cdb0933d71e8c94e04a25619dcee3d2261ad2ee6bf12ffa06d98a0864d87602733ec86a64521f2b18177b200cbbe117577a615d6c770988c0bad946e208e24fa074e5ab3143db5bfce0fd108e4b82d120a92108011a723c12a787e6d788719a10bdba5b2699c327186af4e23c1a946834b6150bda2583e9ca2ad44ce8dbbbc2db04de8ef92e8efc141fbecaa6287c59474e6bc05d99b2964fa090c3a2233ba186515be7ed1f612970cee2d7afb81bdd762170481cd0069127d5b05aa993b4ea988d8fddc186ffb7dc90a6c08f4df435c93402849236c3fab4d27c7026c1d4dcb2602646dec9751e763dba37bdf8ff9406ad9e530ee5db382f413001aeb06a53ed9027d831179727b0865a8918da3edbebcf9b14ed44ce6cbaced4bb1bdb7f1447e6cc254b332051512bd7af426fb8f401378cd2bf5983ca01c64b92ecf032ea15d1721d03f482d7ce6e74fef6d55e702f46980c82b5a84031900b1c9e59e7c97fbec7e8f323a97a7e36cc88be0f1d45b7ff585ac54bd407b22b4154aacc8f6d7ebf48e1d814cc5ed20f8037e0a79715eef29be32806a1d58bb7c5da76f550aa3d8a1fbff0eb19ccb1a313d55cda56c9ec2ef29632387fe8d76e3c0468043e8f663f4860ee12bf2d5b0b7474d6e694f91e6dcc4024ffffffffffffffff"
            },
            modp18: {
                gen: "02",
                prime: "ffffffffffffffffc90fdaa22168c234c4c6628b80dc1cd129024e088a67cc74020bbea63b139b22514a08798e3404ddef9519b3cd3a431b302b0a6df25f14374fe1356d6d51c245e485b576625e7ec6f44c42e9a637ed6b0bff5cb6f406b7edee386bfb5a899fa5ae9f24117c4b1fe649286651ece45b3dc2007cb8a163bf0598da48361c55d39a69163fa8fd24cf5f83655d23dca3ad961c62f356208552bb9ed529077096966d670c354e4abc9804f1746c08ca18217c32905e462e36ce3be39e772c180e86039b2783a2ec07a28fb5c55df06f4c52c9de2bcbf6955817183995497cea956ae515d2261898fa051015728e5a8aaac42dad33170d04507a33a85521abdf1cba64ecfb850458dbef0a8aea71575d060c7db3970f85a6e1e4c7abf5ae8cdb0933d71e8c94e04a25619dcee3d2261ad2ee6bf12ffa06d98a0864d87602733ec86a64521f2b18177b200cbbe117577a615d6c770988c0bad946e208e24fa074e5ab3143db5bfce0fd108e4b82d120a92108011a723c12a787e6d788719a10bdba5b2699c327186af4e23c1a946834b6150bda2583e9ca2ad44ce8dbbbc2db04de8ef92e8efc141fbecaa6287c59474e6bc05d99b2964fa090c3a2233ba186515be7ed1f612970cee2d7afb81bdd762170481cd0069127d5b05aa993b4ea988d8fddc186ffb7dc90a6c08f4df435c93402849236c3fab4d27c7026c1d4dcb2602646dec9751e763dba37bdf8ff9406ad9e530ee5db382f413001aeb06a53ed9027d831179727b0865a8918da3edbebcf9b14ed44ce6cbaced4bb1bdb7f1447e6cc254b332051512bd7af426fb8f401378cd2bf5983ca01c64b92ecf032ea15d1721d03f482d7ce6e74fef6d55e702f46980c82b5a84031900b1c9e59e7c97fbec7e8f323a97a7e36cc88be0f1d45b7ff585ac54bd407b22b4154aacc8f6d7ebf48e1d814cc5ed20f8037e0a79715eef29be32806a1d58bb7c5da76f550aa3d8a1fbff0eb19ccb1a313d55cda56c9ec2ef29632387fe8d76e3c0468043e8f663f4860ee12bf2d5b0b7474d6e694f91e6dbe115974a3926f12fee5e438777cb6a932df8cd8bec4d073b931ba3bc832b68d9dd300741fa7bf8afc47ed2576f6936ba424663aab639c5ae4f5683423b4742bf1c978238f16cbe39d652de3fdb8befc848ad922222e04a4037c0713eb57a81a23f0c73473fc646cea306b4bcbc8862f8385ddfa9d4b7fa2c087e879683303ed5bdd3a062b3cf5b3a278a66d2a13f83f44f82ddf310ee074ab6a364597e899a0255dc164f31cc50846851df9ab48195ded7ea1b1d510bd7ee74d73faf36bc31ecfa268359046f4eb879f924009438b481c6cd7889a002ed5ee382bc9190da6fc026e479558e4475677e9aa9e3050e2765694dfc81f56e880b96e7160c980dd98edd3dfffffffffffffffff"
            }
        };
    }, {} ],
    81: [ function(e, t, r) {
        "use strict";
        var i = r;
        i.version = e("../package.json").version;
        i.utils = e("./elliptic/utils");
        i.rand = e("brorand");
        i.curve = e("./elliptic/curve");
        i.curves = e("./elliptic/curves");
        i.ec = e("./elliptic/ec");
        i.eddsa = e("./elliptic/eddsa");
    }, {
        "../package.json": 96,
        "./elliptic/curve": 84,
        "./elliptic/curves": 87,
        "./elliptic/ec": 88,
        "./elliptic/eddsa": 91,
        "./elliptic/utils": 95,
        brorand: 33
    } ],
    82: [ function(e, t, r) {
        "use strict";
        var i = e("bn.js");
        var n = e("../../elliptic");
        var a = n.utils;
        var s = a.getNAF;
        var f = a.getJSF;
        var o = a.assert;
        function c(e, t) {
            this.type = e;
            this.p = new i(t.p, 16);
            this.red = t.prime ? i.red(t.prime) : i.mont(this.p);
            this.zero = new i(0).toRed(this.red);
            this.one = new i(1).toRed(this.red);
            this.two = new i(2).toRed(this.red);
            this.n = t.n && new i(t.n, 16);
            this.g = t.g && this.pointFromJSON(t.g, t.gRed);
            this._wnafT1 = new Array(4);
            this._wnafT2 = new Array(4);
            this._wnafT3 = new Array(4);
            this._wnafT4 = new Array(4);
            var r = this.n && this.p.div(this.n);
            if (!r || r.cmpn(100) > 0) {
                this.redN = null;
            } else {
                this._maxwellTrick = true;
                this.redN = this.n.toRed(this.red);
            }
        }
        t.exports = c;
        c.prototype.point = function e() {
            throw new Error("Not implemented");
        };
        c.prototype.validate = function e() {
            throw new Error("Not implemented");
        };
        c.prototype._fixedNafMul = function e(t, r) {
            o(t.precomputed);
            var i = t._getDoubles();
            var n = s(r, 1);
            var a = (1 << i.step + 1) - (i.step % 2 === 0 ? 2 : 1);
            a /= 3;
            var f = [];
            for (var c = 0; c < n.length; c += i.step) {
                var h = 0;
                for (var r = c + i.step - 1; r >= c; r--) h = (h << 1) + n[r];
                f.push(h);
            }
            var u = this.jpoint(null, null, null);
            var d = this.jpoint(null, null, null);
            for (var l = a; l > 0; l--) {
                for (var c = 0; c < f.length; c++) {
                    var h = f[c];
                    if (h === l) d = d.mixedAdd(i.points[c]); else if (h === -l) d = d.mixedAdd(i.points[c].neg());
                }
                u = u.add(d);
            }
            return u.toP();
        };
        c.prototype._wnafMul = function e(t, r) {
            var i = 4;
            var n = t._getNAFPoints(i);
            i = n.wnd;
            var a = n.points;
            var f = s(r, i);
            var c = this.jpoint(null, null, null);
            for (var h = f.length - 1; h >= 0; h--) {
                for (var r = 0; h >= 0 && f[h] === 0; h--) r++;
                if (h >= 0) r++;
                c = c.dblp(r);
                if (h < 0) break;
                var u = f[h];
                o(u !== 0);
                if (t.type === "affine") {
                    if (u > 0) c = c.mixedAdd(a[u - 1 >> 1]); else c = c.mixedAdd(a[-u - 1 >> 1].neg());
                } else {
                    if (u > 0) c = c.add(a[u - 1 >> 1]); else c = c.add(a[-u - 1 >> 1].neg());
                }
            }
            return t.type === "affine" ? c.toP() : c;
        };
        c.prototype._wnafMulAdd = function e(t, r, i, n, a) {
            var o = this._wnafT1;
            var c = this._wnafT2;
            var h = this._wnafT3;
            var u = 0;
            for (var d = 0; d < n; d++) {
                var l = r[d];
                var p = l._getNAFPoints(t);
                o[d] = p.wnd;
                c[d] = p.points;
            }
            for (var d = n - 1; d >= 1; d -= 2) {
                var b = d - 1;
                var v = d;
                if (o[b] !== 1 || o[v] !== 1) {
                    h[b] = s(i[b], o[b]);
                    h[v] = s(i[v], o[v]);
                    u = Math.max(h[b].length, u);
                    u = Math.max(h[v].length, u);
                    continue;
                }
                var m = [ r[b], null, null, r[v] ];
                if (r[b].y.cmp(r[v].y) === 0) {
                    m[1] = r[b].add(r[v]);
                    m[2] = r[b].toJ().mixedAdd(r[v].neg());
                } else if (r[b].y.cmp(r[v].y.redNeg()) === 0) {
                    m[1] = r[b].toJ().mixedAdd(r[v]);
                    m[2] = r[b].add(r[v].neg());
                } else {
                    m[1] = r[b].toJ().mixedAdd(r[v]);
                    m[2] = r[b].toJ().mixedAdd(r[v].neg());
                }
                var y = [ -3, -1, -5, -7, 0, 7, 5, 1, 3 ];
                var g = f(i[b], i[v]);
                u = Math.max(g[0].length, u);
                h[b] = new Array(u);
                h[v] = new Array(u);
                for (var w = 0; w < u; w++) {
                    var _ = g[0][w] | 0;
                    var S = g[1][w] | 0;
                    h[b][w] = y[(_ + 1) * 3 + (S + 1)];
                    h[v][w] = 0;
                    c[b] = m;
                }
            }
            var M = this.jpoint(null, null, null);
            var k = this._wnafT4;
            for (var d = u; d >= 0; d--) {
                var E = 0;
                while (d >= 0) {
                    var x = true;
                    for (var w = 0; w < n; w++) {
                        k[w] = h[w][d] | 0;
                        if (k[w] !== 0) x = false;
                    }
                    if (!x) break;
                    E++;
                    d--;
                }
                if (d >= 0) E++;
                M = M.dblp(E);
                if (d < 0) break;
                for (var w = 0; w < n; w++) {
                    var A = k[w];
                    var l;
                    if (A === 0) continue; else if (A > 0) l = c[w][A - 1 >> 1]; else if (A < 0) l = c[w][-A - 1 >> 1].neg();
                    if (l.type === "affine") M = M.mixedAdd(l); else M = M.add(l);
                }
            }
            for (var d = 0; d < n; d++) c[d] = null;
            if (a) return M; else return M.toP();
        };
        function h(e, t) {
            this.curve = e;
            this.type = t;
            this.precomputed = null;
        }
        c.BasePoint = h;
        h.prototype.eq = function e() {
            throw new Error("Not implemented");
        };
        h.prototype.validate = function e() {
            return this.curve.validate(this);
        };
        c.prototype.decodePoint = function e(t, r) {
            t = a.toArray(t, r);
            var i = this.p.byteLength();
            if ((t[0] === 4 || t[0] === 6 || t[0] === 7) && t.length - 1 === 2 * i) {
                if (t[0] === 6) o(t[t.length - 1] % 2 === 0); else if (t[0] === 7) o(t[t.length - 1] % 2 === 1);
                var n = this.point(t.slice(1, 1 + i), t.slice(1 + i, 1 + 2 * i));
                return n;
            } else if ((t[0] === 2 || t[0] === 3) && t.length - 1 === i) {
                return this.pointFromX(t.slice(1, 1 + i), t[0] === 3);
            }
            throw new Error("Unknown point format");
        };
        h.prototype.encodeCompressed = function e(t) {
            return this.encode(t, true);
        };
        h.prototype._encode = function e(t) {
            var r = this.curve.p.byteLength();
            var i = this.getX().toArray("be", r);
            if (t) return [ this.getY().isEven() ? 2 : 3 ].concat(i);
            return [ 4 ].concat(i, this.getY().toArray("be", r));
        };
        h.prototype.encode = function e(t, r) {
            return a.encode(this._encode(r), t);
        };
        h.prototype.precompute = function e(t) {
            if (this.precomputed) return this;
            var r = {
                doubles: null,
                naf: null,
                beta: null
            };
            r.naf = this._getNAFPoints(8);
            r.doubles = this._getDoubles(4, t);
            r.beta = this._getBeta();
            this.precomputed = r;
            return this;
        };
        h.prototype._hasDoubles = function e(t) {
            if (!this.precomputed) return false;
            var r = this.precomputed.doubles;
            if (!r) return false;
            return r.points.length >= Math.ceil((t.bitLength() + 1) / r.step);
        };
        h.prototype._getDoubles = function e(t, r) {
            if (this.precomputed && this.precomputed.doubles) return this.precomputed.doubles;
            var i = [ this ];
            var n = this;
            for (var a = 0; a < r; a += t) {
                for (var s = 0; s < t; s++) n = n.dbl();
                i.push(n);
            }
            return {
                step: t,
                points: i
            };
        };
        h.prototype._getNAFPoints = function e(t) {
            if (this.precomputed && this.precomputed.naf) return this.precomputed.naf;
            var r = [ this ];
            var i = (1 << t) - 1;
            var n = i === 1 ? null : this.dbl();
            for (var a = 1; a < i; a++) r[a] = r[a - 1].add(n);
            return {
                wnd: t,
                points: r
            };
        };
        h.prototype._getBeta = function e() {
            return null;
        };
        h.prototype.dblp = function e(t) {
            var r = this;
            for (var i = 0; i < t; i++) r = r.dbl();
            return r;
        };
    }, {
        "../../elliptic": 81,
        "bn.js": 32
    } ],
    83: [ function(e, t, r) {
        "use strict";
        var i = e("../curve");
        var n = e("../../elliptic");
        var a = e("bn.js");
        var s = e("inherits");
        var f = i.base;
        var o = n.utils.assert;
        function c(e) {
            this.twisted = (e.a | 0) !== 1;
            this.mOneA = this.twisted && (e.a | 0) === -1;
            this.extended = this.mOneA;
            f.call(this, "edwards", e);
            this.a = new a(e.a, 16).umod(this.red.m);
            this.a = this.a.toRed(this.red);
            this.c = new a(e.c, 16).toRed(this.red);
            this.c2 = this.c.redSqr();
            this.d = new a(e.d, 16).toRed(this.red);
            this.dd = this.d.redAdd(this.d);
            o(!this.twisted || this.c.fromRed().cmpn(1) === 0);
            this.oneC = (e.c | 0) === 1;
        }
        s(c, f);
        t.exports = c;
        c.prototype._mulA = function e(t) {
            if (this.mOneA) return t.redNeg(); else return this.a.redMul(t);
        };
        c.prototype._mulC = function e(t) {
            if (this.oneC) return t; else return this.c.redMul(t);
        };
        c.prototype.jpoint = function e(t, r, i, n) {
            return this.point(t, r, i, n);
        };
        c.prototype.pointFromX = function e(t, r) {
            t = new a(t, 16);
            if (!t.red) t = t.toRed(this.red);
            var i = t.redSqr();
            var n = this.c2.redSub(this.a.redMul(i));
            var s = this.one.redSub(this.c2.redMul(this.d).redMul(i));
            var f = n.redMul(s.redInvm());
            var o = f.redSqrt();
            if (o.redSqr().redSub(f).cmp(this.zero) !== 0) throw new Error("invalid point");
            var c = o.fromRed().isOdd();
            if (r && !c || !r && c) o = o.redNeg();
            return this.point(t, o);
        };
        c.prototype.pointFromY = function e(t, r) {
            t = new a(t, 16);
            if (!t.red) t = t.toRed(this.red);
            var i = t.redSqr();
            var n = i.redSub(this.one);
            var s = i.redMul(this.d).redAdd(this.one);
            var f = n.redMul(s.redInvm());
            if (f.cmp(this.zero) === 0) {
                if (r) throw new Error("invalid point"); else return this.point(this.zero, t);
            }
            var o = f.redSqrt();
            if (o.redSqr().redSub(f).cmp(this.zero) !== 0) throw new Error("invalid point");
            if (o.isOdd() !== r) o = o.redNeg();
            return this.point(o, t);
        };
        c.prototype.validate = function e(t) {
            if (t.isInfinity()) return true;
            t.normalize();
            var r = t.x.redSqr();
            var i = t.y.redSqr();
            var n = r.redMul(this.a).redAdd(i);
            var a = this.c2.redMul(this.one.redAdd(this.d.redMul(r).redMul(i)));
            return n.cmp(a) === 0;
        };
        function h(e, t, r, i, n) {
            f.BasePoint.call(this, e, "projective");
            if (t === null && r === null && i === null) {
                this.x = this.curve.zero;
                this.y = this.curve.one;
                this.z = this.curve.one;
                this.t = this.curve.zero;
                this.zOne = true;
            } else {
                this.x = new a(t, 16);
                this.y = new a(r, 16);
                this.z = i ? new a(i, 16) : this.curve.one;
                this.t = n && new a(n, 16);
                if (!this.x.red) this.x = this.x.toRed(this.curve.red);
                if (!this.y.red) this.y = this.y.toRed(this.curve.red);
                if (!this.z.red) this.z = this.z.toRed(this.curve.red);
                if (this.t && !this.t.red) this.t = this.t.toRed(this.curve.red);
                this.zOne = this.z === this.curve.one;
                if (this.curve.extended && !this.t) {
                    this.t = this.x.redMul(this.y);
                    if (!this.zOne) this.t = this.t.redMul(this.z.redInvm());
                }
            }
        }
        s(h, f.BasePoint);
        c.prototype.pointFromJSON = function e(t) {
            return h.fromJSON(this, t);
        };
        c.prototype.point = function e(t, r, i, n) {
            return new h(this, t, r, i, n);
        };
        h.fromJSON = function e(t, r) {
            return new h(t, r[0], r[1], r[2]);
        };
        h.prototype.inspect = function e() {
            if (this.isInfinity()) return "<EC Point Infinity>";
            return "<EC Point x: " + this.x.fromRed().toString(16, 2) + " y: " + this.y.fromRed().toString(16, 2) + " z: " + this.z.fromRed().toString(16, 2) + ">";
        };
        h.prototype.isInfinity = function e() {
            return this.x.cmpn(0) === 0 && this.y.cmp(this.z) === 0;
        };
        h.prototype._extDbl = function e() {
            var t = this.x.redSqr();
            var r = this.y.redSqr();
            var i = this.z.redSqr();
            i = i.redIAdd(i);
            var n = this.curve._mulA(t);
            var a = this.x.redAdd(this.y).redSqr().redISub(t).redISub(r);
            var s = n.redAdd(r);
            var f = s.redSub(i);
            var o = n.redSub(r);
            var c = a.redMul(f);
            var h = s.redMul(o);
            var u = a.redMul(o);
            var d = f.redMul(s);
            return this.curve.point(c, h, d, u);
        };
        h.prototype._projDbl = function e() {
            var t = this.x.redAdd(this.y).redSqr();
            var r = this.x.redSqr();
            var i = this.y.redSqr();
            var n;
            var a;
            var s;
            if (this.curve.twisted) {
                var f = this.curve._mulA(r);
                var o = f.redAdd(i);
                if (this.zOne) {
                    n = t.redSub(r).redSub(i).redMul(o.redSub(this.curve.two));
                    a = o.redMul(f.redSub(i));
                    s = o.redSqr().redSub(o).redSub(o);
                } else {
                    var c = this.z.redSqr();
                    var h = o.redSub(c).redISub(c);
                    n = t.redSub(r).redISub(i).redMul(h);
                    a = o.redMul(f.redSub(i));
                    s = o.redMul(h);
                }
            } else {
                var f = r.redAdd(i);
                var c = this.curve._mulC(this.c.redMul(this.z)).redSqr();
                var h = f.redSub(c).redSub(c);
                n = this.curve._mulC(t.redISub(f)).redMul(h);
                a = this.curve._mulC(f).redMul(r.redISub(i));
                s = f.redMul(h);
            }
            return this.curve.point(n, a, s);
        };
        h.prototype.dbl = function e() {
            if (this.isInfinity()) return this;
            if (this.curve.extended) return this._extDbl(); else return this._projDbl();
        };
        h.prototype._extAdd = function e(t) {
            var r = this.y.redSub(this.x).redMul(t.y.redSub(t.x));
            var i = this.y.redAdd(this.x).redMul(t.y.redAdd(t.x));
            var n = this.t.redMul(this.curve.dd).redMul(t.t);
            var a = this.z.redMul(t.z.redAdd(t.z));
            var s = i.redSub(r);
            var f = a.redSub(n);
            var o = a.redAdd(n);
            var c = i.redAdd(r);
            var h = s.redMul(f);
            var u = o.redMul(c);
            var d = s.redMul(c);
            var l = f.redMul(o);
            return this.curve.point(h, u, l, d);
        };
        h.prototype._projAdd = function e(t) {
            var r = this.z.redMul(t.z);
            var i = r.redSqr();
            var n = this.x.redMul(t.x);
            var a = this.y.redMul(t.y);
            var s = this.curve.d.redMul(n).redMul(a);
            var f = i.redSub(s);
            var o = i.redAdd(s);
            var c = this.x.redAdd(this.y).redMul(t.x.redAdd(t.y)).redISub(n).redISub(a);
            var h = r.redMul(f).redMul(c);
            var u;
            var d;
            if (this.curve.twisted) {
                u = r.redMul(o).redMul(a.redSub(this.curve._mulA(n)));
                d = f.redMul(o);
            } else {
                u = r.redMul(o).redMul(a.redSub(n));
                d = this.curve._mulC(f).redMul(o);
            }
            return this.curve.point(h, u, d);
        };
        h.prototype.add = function e(t) {
            if (this.isInfinity()) return t;
            if (t.isInfinity()) return this;
            if (this.curve.extended) return this._extAdd(t); else return this._projAdd(t);
        };
        h.prototype.mul = function e(t) {
            if (this._hasDoubles(t)) return this.curve._fixedNafMul(this, t); else return this.curve._wnafMul(this, t);
        };
        h.prototype.mulAdd = function e(t, r, i) {
            return this.curve._wnafMulAdd(1, [ this, r ], [ t, i ], 2, false);
        };
        h.prototype.jmulAdd = function e(t, r, i) {
            return this.curve._wnafMulAdd(1, [ this, r ], [ t, i ], 2, true);
        };
        h.prototype.normalize = function e() {
            if (this.zOne) return this;
            var t = this.z.redInvm();
            this.x = this.x.redMul(t);
            this.y = this.y.redMul(t);
            if (this.t) this.t = this.t.redMul(t);
            this.z = this.curve.one;
            this.zOne = true;
            return this;
        };
        h.prototype.neg = function e() {
            return this.curve.point(this.x.redNeg(), this.y, this.z, this.t && this.t.redNeg());
        };
        h.prototype.getX = function e() {
            this.normalize();
            return this.x.fromRed();
        };
        h.prototype.getY = function e() {
            this.normalize();
            return this.y.fromRed();
        };
        h.prototype.eq = function e(t) {
            return this === t || this.getX().cmp(t.getX()) === 0 && this.getY().cmp(t.getY()) === 0;
        };
        h.prototype.eqXToP = function e(t) {
            var r = t.toRed(this.curve.red).redMul(this.z);
            if (this.x.cmp(r) === 0) return true;
            var i = t.clone();
            var n = this.curve.redN.redMul(this.z);
            for (;;) {
                i.iadd(this.curve.n);
                if (i.cmp(this.curve.p) >= 0) return false;
                r.redIAdd(n);
                if (this.x.cmp(r) === 0) return true;
            }
            return false;
        };
        h.prototype.toP = h.prototype.normalize;
        h.prototype.mixedAdd = h.prototype.add;
    }, {
        "../../elliptic": 81,
        "../curve": 84,
        "bn.js": 32,
        inherits: 115
    } ],
    84: [ function(e, t, r) {
        "use strict";
        var i = r;
        i.base = e("./base");
        i.short = e("./short");
        i.mont = e("./mont");
        i.edwards = e("./edwards");
    }, {
        "./base": 82,
        "./edwards": 83,
        "./mont": 85,
        "./short": 86
    } ],
    85: [ function(e, t, r) {
        "use strict";
        var i = e("../curve");
        var n = e("bn.js");
        var a = e("inherits");
        var s = i.base;
        var f = e("../../elliptic");
        var o = f.utils;
        function c(e) {
            s.call(this, "mont", e);
            this.a = new n(e.a, 16).toRed(this.red);
            this.b = new n(e.b, 16).toRed(this.red);
            this.i4 = new n(4).toRed(this.red).redInvm();
            this.two = new n(2).toRed(this.red);
            this.a24 = this.i4.redMul(this.a.redAdd(this.two));
        }
        a(c, s);
        t.exports = c;
        c.prototype.validate = function e(t) {
            var r = t.normalize().x;
            var i = r.redSqr();
            var n = i.redMul(r).redAdd(i.redMul(this.a)).redAdd(r);
            var a = n.redSqrt();
            return a.redSqr().cmp(n) === 0;
        };
        function h(e, t, r) {
            s.BasePoint.call(this, e, "projective");
            if (t === null && r === null) {
                this.x = this.curve.one;
                this.z = this.curve.zero;
            } else {
                this.x = new n(t, 16);
                this.z = new n(r, 16);
                if (!this.x.red) this.x = this.x.toRed(this.curve.red);
                if (!this.z.red) this.z = this.z.toRed(this.curve.red);
            }
        }
        a(h, s.BasePoint);
        c.prototype.decodePoint = function e(t, r) {
            return this.point(o.toArray(t, r), 1);
        };
        c.prototype.point = function e(t, r) {
            return new h(this, t, r);
        };
        c.prototype.pointFromJSON = function e(t) {
            return h.fromJSON(this, t);
        };
        h.prototype.precompute = function e() {};
        h.prototype._encode = function e() {
            return this.getX().toArray("be", this.curve.p.byteLength());
        };
        h.fromJSON = function e(t, r) {
            return new h(t, r[0], r[1] || t.one);
        };
        h.prototype.inspect = function e() {
            if (this.isInfinity()) return "<EC Point Infinity>";
            return "<EC Point x: " + this.x.fromRed().toString(16, 2) + " z: " + this.z.fromRed().toString(16, 2) + ">";
        };
        h.prototype.isInfinity = function e() {
            return this.z.cmpn(0) === 0;
        };
        h.prototype.dbl = function e() {
            var t = this.x.redAdd(this.z);
            var r = t.redSqr();
            var i = this.x.redSub(this.z);
            var n = i.redSqr();
            var a = r.redSub(n);
            var s = r.redMul(n);
            var f = a.redMul(n.redAdd(this.curve.a24.redMul(a)));
            return this.curve.point(s, f);
        };
        h.prototype.add = function e() {
            throw new Error("Not supported on Montgomery curve");
        };
        h.prototype.diffAdd = function e(t, r) {
            var i = this.x.redAdd(this.z);
            var n = this.x.redSub(this.z);
            var a = t.x.redAdd(t.z);
            var s = t.x.redSub(t.z);
            var f = s.redMul(i);
            var o = a.redMul(n);
            var c = r.z.redMul(f.redAdd(o).redSqr());
            var h = r.x.redMul(f.redISub(o).redSqr());
            return this.curve.point(c, h);
        };
        h.prototype.mul = function e(t) {
            var r = t.clone();
            var i = this;
            var n = this.curve.point(null, null);
            var a = this;
            for (var s = []; r.cmpn(0) !== 0; r.iushrn(1)) s.push(r.andln(1));
            for (var f = s.length - 1; f >= 0; f--) {
                if (s[f] === 0) {
                    i = i.diffAdd(n, a);
                    n = n.dbl();
                } else {
                    n = i.diffAdd(n, a);
                    i = i.dbl();
                }
            }
            return n;
        };
        h.prototype.mulAdd = function e() {
            throw new Error("Not supported on Montgomery curve");
        };
        h.prototype.jumlAdd = function e() {
            throw new Error("Not supported on Montgomery curve");
        };
        h.prototype.eq = function e(t) {
            return this.getX().cmp(t.getX()) === 0;
        };
        h.prototype.normalize = function e() {
            this.x = this.x.redMul(this.z.redInvm());
            this.z = this.curve.one;
            return this;
        };
        h.prototype.getX = function e() {
            this.normalize();
            return this.x.fromRed();
        };
    }, {
        "../../elliptic": 81,
        "../curve": 84,
        "bn.js": 32,
        inherits: 115
    } ],
    86: [ function(e, t, r) {
        "use strict";
        var i = e("../curve");
        var n = e("../../elliptic");
        var a = e("bn.js");
        var s = e("inherits");
        var f = i.base;
        var o = n.utils.assert;
        function c(e) {
            f.call(this, "short", e);
            this.a = new a(e.a, 16).toRed(this.red);
            this.b = new a(e.b, 16).toRed(this.red);
            this.tinv = this.two.redInvm();
            this.zeroA = this.a.fromRed().cmpn(0) === 0;
            this.threeA = this.a.fromRed().sub(this.p).cmpn(-3) === 0;
            this.endo = this._getEndomorphism(e);
            this._endoWnafT1 = new Array(4);
            this._endoWnafT2 = new Array(4);
        }
        s(c, f);
        t.exports = c;
        c.prototype._getEndomorphism = function e(t) {
            if (!this.zeroA || !this.g || !this.n || this.p.modn(3) !== 1) return;
            var r;
            var i;
            if (t.beta) {
                r = new a(t.beta, 16).toRed(this.red);
            } else {
                var n = this._getEndoRoots(this.p);
                r = n[0].cmp(n[1]) < 0 ? n[0] : n[1];
                r = r.toRed(this.red);
            }
            if (t.lambda) {
                i = new a(t.lambda, 16);
            } else {
                var s = this._getEndoRoots(this.n);
                if (this.g.mul(s[0]).x.cmp(this.g.x.redMul(r)) === 0) {
                    i = s[0];
                } else {
                    i = s[1];
                    o(this.g.mul(i).x.cmp(this.g.x.redMul(r)) === 0);
                }
            }
            var f;
            if (t.basis) {
                f = t.basis.map(function(e) {
                    return {
                        a: new a(e.a, 16),
                        b: new a(e.b, 16)
                    };
                });
            } else {
                f = this._getEndoBasis(i);
            }
            return {
                beta: r,
                lambda: i,
                basis: f
            };
        };
        c.prototype._getEndoRoots = function e(t) {
            var r = t === this.p ? this.red : a.mont(t);
            var i = new a(2).toRed(r).redInvm();
            var n = i.redNeg();
            var s = new a(3).toRed(r).redNeg().redSqrt().redMul(i);
            var f = n.redAdd(s).fromRed();
            var o = n.redSub(s).fromRed();
            return [ f, o ];
        };
        c.prototype._getEndoBasis = function e(t) {
            var r = this.n.ushrn(Math.floor(this.n.bitLength() / 2));
            var i = t;
            var n = this.n.clone();
            var s = new a(1);
            var f = new a(0);
            var o = new a(0);
            var c = new a(1);
            var h;
            var u;
            var d;
            var l;
            var p;
            var b;
            var v;
            var m = 0;
            var y;
            var g;
            while (i.cmpn(0) !== 0) {
                var w = n.div(i);
                y = n.sub(w.mul(i));
                g = o.sub(w.mul(s));
                var _ = c.sub(w.mul(f));
                if (!d && y.cmp(r) < 0) {
                    h = v.neg();
                    u = s;
                    d = y.neg();
                    l = g;
                } else if (d && ++m === 2) {
                    break;
                }
                v = y;
                n = i;
                i = y;
                o = s;
                s = g;
                c = f;
                f = _;
            }
            p = y.neg();
            b = g;
            var S = d.sqr().add(l.sqr());
            var M = p.sqr().add(b.sqr());
            if (M.cmp(S) >= 0) {
                p = h;
                b = u;
            }
            if (d.negative) {
                d = d.neg();
                l = l.neg();
            }
            if (p.negative) {
                p = p.neg();
                b = b.neg();
            }
            return [ {
                a: d,
                b: l
            }, {
                a: p,
                b: b
            } ];
        };
        c.prototype._endoSplit = function e(t) {
            var r = this.endo.basis;
            var i = r[0];
            var n = r[1];
            var a = n.b.mul(t).divRound(this.n);
            var s = i.b.neg().mul(t).divRound(this.n);
            var f = a.mul(i.a);
            var o = s.mul(n.a);
            var c = a.mul(i.b);
            var h = s.mul(n.b);
            var u = t.sub(f).sub(o);
            var d = c.add(h).neg();
            return {
                k1: u,
                k2: d
            };
        };
        c.prototype.pointFromX = function e(t, r) {
            t = new a(t, 16);
            if (!t.red) t = t.toRed(this.red);
            var i = t.redSqr().redMul(t).redIAdd(t.redMul(this.a)).redIAdd(this.b);
            var n = i.redSqrt();
            if (n.redSqr().redSub(i).cmp(this.zero) !== 0) throw new Error("invalid point");
            var s = n.fromRed().isOdd();
            if (r && !s || !r && s) n = n.redNeg();
            return this.point(t, n);
        };
        c.prototype.validate = function e(t) {
            if (t.inf) return true;
            var r = t.x;
            var i = t.y;
            var n = this.a.redMul(r);
            var a = r.redSqr().redMul(r).redIAdd(n).redIAdd(this.b);
            return i.redSqr().redISub(a).cmpn(0) === 0;
        };
        c.prototype._endoWnafMulAdd = function e(t, r, i) {
            var n = this._endoWnafT1;
            var a = this._endoWnafT2;
            for (var s = 0; s < t.length; s++) {
                var f = this._endoSplit(r[s]);
                var o = t[s];
                var c = o._getBeta();
                if (f.k1.negative) {
                    f.k1.ineg();
                    o = o.neg(true);
                }
                if (f.k2.negative) {
                    f.k2.ineg();
                    c = c.neg(true);
                }
                n[s * 2] = o;
                n[s * 2 + 1] = c;
                a[s * 2] = f.k1;
                a[s * 2 + 1] = f.k2;
            }
            var h = this._wnafMulAdd(1, n, a, s * 2, i);
            for (var u = 0; u < s * 2; u++) {
                n[u] = null;
                a[u] = null;
            }
            return h;
        };
        function h(e, t, r, i) {
            f.BasePoint.call(this, e, "affine");
            if (t === null && r === null) {
                this.x = null;
                this.y = null;
                this.inf = true;
            } else {
                this.x = new a(t, 16);
                this.y = new a(r, 16);
                if (i) {
                    this.x.forceRed(this.curve.red);
                    this.y.forceRed(this.curve.red);
                }
                if (!this.x.red) this.x = this.x.toRed(this.curve.red);
                if (!this.y.red) this.y = this.y.toRed(this.curve.red);
                this.inf = false;
            }
        }
        s(h, f.BasePoint);
        c.prototype.point = function e(t, r, i) {
            return new h(this, t, r, i);
        };
        c.prototype.pointFromJSON = function e(t, r) {
            return h.fromJSON(this, t, r);
        };
        h.prototype._getBeta = function e() {
            if (!this.curve.endo) return;
            var t = this.precomputed;
            if (t && t.beta) return t.beta;
            var r = this.curve.point(this.x.redMul(this.curve.endo.beta), this.y);
            if (t) {
                var i = this.curve;
                var n = function(e) {
                    return i.point(e.x.redMul(i.endo.beta), e.y);
                };
                t.beta = r;
                r.precomputed = {
                    beta: null,
                    naf: t.naf && {
                        wnd: t.naf.wnd,
                        points: t.naf.points.map(n)
                    },
                    doubles: t.doubles && {
                        step: t.doubles.step,
                        points: t.doubles.points.map(n)
                    }
                };
            }
            return r;
        };
        h.prototype.toJSON = function e() {
            if (!this.precomputed) return [ this.x, this.y ];
            return [ this.x, this.y, this.precomputed && {
                doubles: this.precomputed.doubles && {
                    step: this.precomputed.doubles.step,
                    points: this.precomputed.doubles.points.slice(1)
                },
                naf: this.precomputed.naf && {
                    wnd: this.precomputed.naf.wnd,
                    points: this.precomputed.naf.points.slice(1)
                }
            } ];
        };
        h.fromJSON = function e(t, r, i) {
            if (typeof r === "string") r = JSON.parse(r);
            var n = t.point(r[0], r[1], i);
            if (!r[2]) return n;
            function a(e) {
                return t.point(e[0], e[1], i);
            }
            var s = r[2];
            n.precomputed = {
                beta: null,
                doubles: s.doubles && {
                    step: s.doubles.step,
                    points: [ n ].concat(s.doubles.points.map(a))
                },
                naf: s.naf && {
                    wnd: s.naf.wnd,
                    points: [ n ].concat(s.naf.points.map(a))
                }
            };
            return n;
        };
        h.prototype.inspect = function e() {
            if (this.isInfinity()) return "<EC Point Infinity>";
            return "<EC Point x: " + this.x.fromRed().toString(16, 2) + " y: " + this.y.fromRed().toString(16, 2) + ">";
        };
        h.prototype.isInfinity = function e() {
            return this.inf;
        };
        h.prototype.add = function e(t) {
            if (this.inf) return t;
            if (t.inf) return this;
            if (this.eq(t)) return this.dbl();
            if (this.neg().eq(t)) return this.curve.point(null, null);
            if (this.x.cmp(t.x) === 0) return this.curve.point(null, null);
            var r = this.y.redSub(t.y);
            if (r.cmpn(0) !== 0) r = r.redMul(this.x.redSub(t.x).redInvm());
            var i = r.redSqr().redISub(this.x).redISub(t.x);
            var n = r.redMul(this.x.redSub(i)).redISub(this.y);
            return this.curve.point(i, n);
        };
        h.prototype.dbl = function e() {
            if (this.inf) return this;
            var t = this.y.redAdd(this.y);
            if (t.cmpn(0) === 0) return this.curve.point(null, null);
            var r = this.curve.a;
            var i = this.x.redSqr();
            var n = t.redInvm();
            var a = i.redAdd(i).redIAdd(i).redIAdd(r).redMul(n);
            var s = a.redSqr().redISub(this.x.redAdd(this.x));
            var f = a.redMul(this.x.redSub(s)).redISub(this.y);
            return this.curve.point(s, f);
        };
        h.prototype.getX = function e() {
            return this.x.fromRed();
        };
        h.prototype.getY = function e() {
            return this.y.fromRed();
        };
        h.prototype.mul = function e(t) {
            t = new a(t, 16);
            if (this._hasDoubles(t)) return this.curve._fixedNafMul(this, t); else if (this.curve.endo) return this.curve._endoWnafMulAdd([ this ], [ t ]); else return this.curve._wnafMul(this, t);
        };
        h.prototype.mulAdd = function e(t, r, i) {
            var n = [ this, r ];
            var a = [ t, i ];
            if (this.curve.endo) return this.curve._endoWnafMulAdd(n, a); else return this.curve._wnafMulAdd(1, n, a, 2);
        };
        h.prototype.jmulAdd = function e(t, r, i) {
            var n = [ this, r ];
            var a = [ t, i ];
            if (this.curve.endo) return this.curve._endoWnafMulAdd(n, a, true); else return this.curve._wnafMulAdd(1, n, a, 2, true);
        };
        h.prototype.eq = function e(t) {
            return this === t || this.inf === t.inf && (this.inf || this.x.cmp(t.x) === 0 && this.y.cmp(t.y) === 0);
        };
        h.prototype.neg = function e(t) {
            if (this.inf) return this;
            var r = this.curve.point(this.x, this.y.redNeg());
            if (t && this.precomputed) {
                var i = this.precomputed;
                var n = function(e) {
                    return e.neg();
                };
                r.precomputed = {
                    naf: i.naf && {
                        wnd: i.naf.wnd,
                        points: i.naf.points.map(n)
                    },
                    doubles: i.doubles && {
                        step: i.doubles.step,
                        points: i.doubles.points.map(n)
                    }
                };
            }
            return r;
        };
        h.prototype.toJ = function e() {
            if (this.inf) return this.curve.jpoint(null, null, null);
            var t = this.curve.jpoint(this.x, this.y, this.curve.one);
            return t;
        };
        function u(e, t, r, i) {
            f.BasePoint.call(this, e, "jacobian");
            if (t === null && r === null && i === null) {
                this.x = this.curve.one;
                this.y = this.curve.one;
                this.z = new a(0);
            } else {
                this.x = new a(t, 16);
                this.y = new a(r, 16);
                this.z = new a(i, 16);
            }
            if (!this.x.red) this.x = this.x.toRed(this.curve.red);
            if (!this.y.red) this.y = this.y.toRed(this.curve.red);
            if (!this.z.red) this.z = this.z.toRed(this.curve.red);
            this.zOne = this.z === this.curve.one;
        }
        s(u, f.BasePoint);
        c.prototype.jpoint = function e(t, r, i) {
            return new u(this, t, r, i);
        };
        u.prototype.toP = function e() {
            if (this.isInfinity()) return this.curve.point(null, null);
            var t = this.z.redInvm();
            var r = t.redSqr();
            var i = this.x.redMul(r);
            var n = this.y.redMul(r).redMul(t);
            return this.curve.point(i, n);
        };
        u.prototype.neg = function e() {
            return this.curve.jpoint(this.x, this.y.redNeg(), this.z);
        };
        u.prototype.add = function e(t) {
            if (this.isInfinity()) return t;
            if (t.isInfinity()) return this;
            var r = t.z.redSqr();
            var i = this.z.redSqr();
            var n = this.x.redMul(r);
            var a = t.x.redMul(i);
            var s = this.y.redMul(r.redMul(t.z));
            var f = t.y.redMul(i.redMul(this.z));
            var o = n.redSub(a);
            var c = s.redSub(f);
            if (o.cmpn(0) === 0) {
                if (c.cmpn(0) !== 0) return this.curve.jpoint(null, null, null); else return this.dbl();
            }
            var h = o.redSqr();
            var u = h.redMul(o);
            var d = n.redMul(h);
            var l = c.redSqr().redIAdd(u).redISub(d).redISub(d);
            var p = c.redMul(d.redISub(l)).redISub(s.redMul(u));
            var b = this.z.redMul(t.z).redMul(o);
            return this.curve.jpoint(l, p, b);
        };
        u.prototype.mixedAdd = function e(t) {
            if (this.isInfinity()) return t.toJ();
            if (t.isInfinity()) return this;
            var r = this.z.redSqr();
            var i = this.x;
            var n = t.x.redMul(r);
            var a = this.y;
            var s = t.y.redMul(r).redMul(this.z);
            var f = i.redSub(n);
            var o = a.redSub(s);
            if (f.cmpn(0) === 0) {
                if (o.cmpn(0) !== 0) return this.curve.jpoint(null, null, null); else return this.dbl();
            }
            var c = f.redSqr();
            var h = c.redMul(f);
            var u = i.redMul(c);
            var d = o.redSqr().redIAdd(h).redISub(u).redISub(u);
            var l = o.redMul(u.redISub(d)).redISub(a.redMul(h));
            var p = this.z.redMul(f);
            return this.curve.jpoint(d, l, p);
        };
        u.prototype.dblp = function e(t) {
            if (t === 0) return this;
            if (this.isInfinity()) return this;
            if (!t) return this.dbl();
            if (this.curve.zeroA || this.curve.threeA) {
                var r = this;
                for (var i = 0; i < t; i++) r = r.dbl();
                return r;
            }
            var n = this.curve.a;
            var a = this.curve.tinv;
            var s = this.x;
            var f = this.y;
            var o = this.z;
            var c = o.redSqr().redSqr();
            var h = f.redAdd(f);
            for (var i = 0; i < t; i++) {
                var u = s.redSqr();
                var d = h.redSqr();
                var l = d.redSqr();
                var p = u.redAdd(u).redIAdd(u).redIAdd(n.redMul(c));
                var b = s.redMul(d);
                var v = p.redSqr().redISub(b.redAdd(b));
                var m = b.redISub(v);
                var y = p.redMul(m);
                y = y.redIAdd(y).redISub(l);
                var g = h.redMul(o);
                if (i + 1 < t) c = c.redMul(l);
                s = v;
                o = g;
                h = y;
            }
            return this.curve.jpoint(s, h.redMul(a), o);
        };
        u.prototype.dbl = function e() {
            if (this.isInfinity()) return this;
            if (this.curve.zeroA) return this._zeroDbl(); else if (this.curve.threeA) return this._threeDbl(); else return this._dbl();
        };
        u.prototype._zeroDbl = function e() {
            var t;
            var r;
            var i;
            if (this.zOne) {
                var n = this.x.redSqr();
                var a = this.y.redSqr();
                var s = a.redSqr();
                var f = this.x.redAdd(a).redSqr().redISub(n).redISub(s);
                f = f.redIAdd(f);
                var o = n.redAdd(n).redIAdd(n);
                var c = o.redSqr().redISub(f).redISub(f);
                var h = s.redIAdd(s);
                h = h.redIAdd(h);
                h = h.redIAdd(h);
                t = c;
                r = o.redMul(f.redISub(c)).redISub(h);
                i = this.y.redAdd(this.y);
            } else {
                var u = this.x.redSqr();
                var d = this.y.redSqr();
                var l = d.redSqr();
                var p = this.x.redAdd(d).redSqr().redISub(u).redISub(l);
                p = p.redIAdd(p);
                var b = u.redAdd(u).redIAdd(u);
                var v = b.redSqr();
                var m = l.redIAdd(l);
                m = m.redIAdd(m);
                m = m.redIAdd(m);
                t = v.redISub(p).redISub(p);
                r = b.redMul(p.redISub(t)).redISub(m);
                i = this.y.redMul(this.z);
                i = i.redIAdd(i);
            }
            return this.curve.jpoint(t, r, i);
        };
        u.prototype._threeDbl = function e() {
            var t;
            var r;
            var i;
            if (this.zOne) {
                var n = this.x.redSqr();
                var a = this.y.redSqr();
                var s = a.redSqr();
                var f = this.x.redAdd(a).redSqr().redISub(n).redISub(s);
                f = f.redIAdd(f);
                var o = n.redAdd(n).redIAdd(n).redIAdd(this.curve.a);
                var c = o.redSqr().redISub(f).redISub(f);
                t = c;
                var h = s.redIAdd(s);
                h = h.redIAdd(h);
                h = h.redIAdd(h);
                r = o.redMul(f.redISub(c)).redISub(h);
                i = this.y.redAdd(this.y);
            } else {
                var u = this.z.redSqr();
                var d = this.y.redSqr();
                var l = this.x.redMul(d);
                var p = this.x.redSub(u).redMul(this.x.redAdd(u));
                p = p.redAdd(p).redIAdd(p);
                var b = l.redIAdd(l);
                b = b.redIAdd(b);
                var v = b.redAdd(b);
                t = p.redSqr().redISub(v);
                i = this.y.redAdd(this.z).redSqr().redISub(d).redISub(u);
                var m = d.redSqr();
                m = m.redIAdd(m);
                m = m.redIAdd(m);
                m = m.redIAdd(m);
                r = p.redMul(b.redISub(t)).redISub(m);
            }
            return this.curve.jpoint(t, r, i);
        };
        u.prototype._dbl = function e() {
            var t = this.curve.a;
            var r = this.x;
            var i = this.y;
            var n = this.z;
            var a = n.redSqr().redSqr();
            var s = r.redSqr();
            var f = i.redSqr();
            var o = s.redAdd(s).redIAdd(s).redIAdd(t.redMul(a));
            var c = r.redAdd(r);
            c = c.redIAdd(c);
            var h = c.redMul(f);
            var u = o.redSqr().redISub(h.redAdd(h));
            var d = h.redISub(u);
            var l = f.redSqr();
            l = l.redIAdd(l);
            l = l.redIAdd(l);
            l = l.redIAdd(l);
            var p = o.redMul(d).redISub(l);
            var b = i.redAdd(i).redMul(n);
            return this.curve.jpoint(u, p, b);
        };
        u.prototype.trpl = function e() {
            if (!this.curve.zeroA) return this.dbl().add(this);
            var t = this.x.redSqr();
            var r = this.y.redSqr();
            var i = this.z.redSqr();
            var n = r.redSqr();
            var a = t.redAdd(t).redIAdd(t);
            var s = a.redSqr();
            var f = this.x.redAdd(r).redSqr().redISub(t).redISub(n);
            f = f.redIAdd(f);
            f = f.redAdd(f).redIAdd(f);
            f = f.redISub(s);
            var o = f.redSqr();
            var c = n.redIAdd(n);
            c = c.redIAdd(c);
            c = c.redIAdd(c);
            c = c.redIAdd(c);
            var h = a.redIAdd(f).redSqr().redISub(s).redISub(o).redISub(c);
            var u = r.redMul(h);
            u = u.redIAdd(u);
            u = u.redIAdd(u);
            var d = this.x.redMul(o).redISub(u);
            d = d.redIAdd(d);
            d = d.redIAdd(d);
            var l = this.y.redMul(h.redMul(c.redISub(h)).redISub(f.redMul(o)));
            l = l.redIAdd(l);
            l = l.redIAdd(l);
            l = l.redIAdd(l);
            var p = this.z.redAdd(f).redSqr().redISub(i).redISub(o);
            return this.curve.jpoint(d, l, p);
        };
        u.prototype.mul = function e(t, r) {
            t = new a(t, r);
            return this.curve._wnafMul(this, t);
        };
        u.prototype.eq = function e(t) {
            if (t.type === "affine") return this.eq(t.toJ());
            if (this === t) return true;
            var r = this.z.redSqr();
            var i = t.z.redSqr();
            if (this.x.redMul(i).redISub(t.x.redMul(r)).cmpn(0) !== 0) return false;
            var n = r.redMul(this.z);
            var a = i.redMul(t.z);
            return this.y.redMul(a).redISub(t.y.redMul(n)).cmpn(0) === 0;
        };
        u.prototype.eqXToP = function e(t) {
            var r = this.z.redSqr();
            var i = t.toRed(this.curve.red).redMul(r);
            if (this.x.cmp(i) === 0) return true;
            var n = t.clone();
            var a = this.curve.redN.redMul(r);
            for (;;) {
                n.iadd(this.curve.n);
                if (n.cmp(this.curve.p) >= 0) return false;
                i.redIAdd(a);
                if (this.x.cmp(i) === 0) return true;
            }
            return false;
        };
        u.prototype.inspect = function e() {
            if (this.isInfinity()) return "<EC JPoint Infinity>";
            return "<EC JPoint x: " + this.x.toString(16, 2) + " y: " + this.y.toString(16, 2) + " z: " + this.z.toString(16, 2) + ">";
        };
        u.prototype.isInfinity = function e() {
            return this.z.cmpn(0) === 0;
        };
    }, {
        "../../elliptic": 81,
        "../curve": 84,
        "bn.js": 32,
        inherits: 115
    } ],
    87: [ function(e, t, r) {
        "use strict";
        var i = r;
        var n = e("hash.js");
        var a = e("../elliptic");
        var s = a.utils.assert;
        function f(e) {
            if (e.type === "short") this.curve = new a.curve.short(e); else if (e.type === "edwards") this.curve = new a.curve.edwards(e); else this.curve = new a.curve.mont(e);
            this.g = this.curve.g;
            this.n = this.curve.n;
            this.hash = e.hash;
            s(this.g.validate(), "Invalid curve");
            s(this.g.mul(this.n).isInfinity(), "Invalid curve, G*N != O");
        }
        i.PresetCurve = f;
        function o(e, t) {
            Object.defineProperty(i, e, {
                configurable: true,
                enumerable: true,
                get: function() {
                    var r = new f(t);
                    Object.defineProperty(i, e, {
                        configurable: true,
                        enumerable: true,
                        value: r
                    });
                    return r;
                }
            });
        }
        o("p192", {
            type: "short",
            prime: "p192",
            p: "ffffffff ffffffff ffffffff fffffffe ffffffff ffffffff",
            a: "ffffffff ffffffff ffffffff fffffffe ffffffff fffffffc",
            b: "64210519 e59c80e7 0fa7e9ab 72243049 feb8deec c146b9b1",
            n: "ffffffff ffffffff ffffffff 99def836 146bc9b1 b4d22831",
            hash: n.sha256,
            gRed: false,
            g: [ "188da80e b03090f6 7cbf20eb 43a18800 f4ff0afd 82ff1012", "07192b95 ffc8da78 631011ed 6b24cdd5 73f977a1 1e794811" ]
        });
        o("p224", {
            type: "short",
            prime: "p224",
            p: "ffffffff ffffffff ffffffff ffffffff 00000000 00000000 00000001",
            a: "ffffffff ffffffff ffffffff fffffffe ffffffff ffffffff fffffffe",
            b: "b4050a85 0c04b3ab f5413256 5044b0b7 d7bfd8ba 270b3943 2355ffb4",
            n: "ffffffff ffffffff ffffffff ffff16a2 e0b8f03e 13dd2945 5c5c2a3d",
            hash: n.sha256,
            gRed: false,
            g: [ "b70e0cbd 6bb4bf7f 321390b9 4a03c1d3 56c21122 343280d6 115c1d21", "bd376388 b5f723fb 4c22dfe6 cd4375a0 5a074764 44d58199 85007e34" ]
        });
        o("p256", {
            type: "short",
            prime: null,
            p: "ffffffff 00000001 00000000 00000000 00000000 ffffffff ffffffff ffffffff",
            a: "ffffffff 00000001 00000000 00000000 00000000 ffffffff ffffffff fffffffc",
            b: "5ac635d8 aa3a93e7 b3ebbd55 769886bc 651d06b0 cc53b0f6 3bce3c3e 27d2604b",
            n: "ffffffff 00000000 ffffffff ffffffff bce6faad a7179e84 f3b9cac2 fc632551",
            hash: n.sha256,
            gRed: false,
            g: [ "6b17d1f2 e12c4247 f8bce6e5 63a440f2 77037d81 2deb33a0 f4a13945 d898c296", "4fe342e2 fe1a7f9b 8ee7eb4a 7c0f9e16 2bce3357 6b315ece cbb64068 37bf51f5" ]
        });
        o("p384", {
            type: "short",
            prime: null,
            p: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff " + "fffffffe ffffffff 00000000 00000000 ffffffff",
            a: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff " + "fffffffe ffffffff 00000000 00000000 fffffffc",
            b: "b3312fa7 e23ee7e4 988e056b e3f82d19 181d9c6e fe814112 0314088f " + "5013875a c656398d 8a2ed19d 2a85c8ed d3ec2aef",
            n: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff c7634d81 " + "f4372ddf 581a0db2 48b0a77a ecec196a ccc52973",
            hash: n.sha384,
            gRed: false,
            g: [ "aa87ca22 be8b0537 8eb1c71e f320ad74 6e1d3b62 8ba79b98 59f741e0 82542a38 " + "5502f25d bf55296c 3a545e38 72760ab7", "3617de4a 96262c6f 5d9e98bf 9292dc29 f8f41dbd 289a147c e9da3113 b5f0b8c0 " + "0a60b1ce 1d7e819d 7a431d7c 90ea0e5f" ]
        });
        o("p521", {
            type: "short",
            prime: null,
            p: "000001ff ffffffff ffffffff ffffffff ffffffff ffffffff " + "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff " + "ffffffff ffffffff ffffffff ffffffff ffffffff",
            a: "000001ff ffffffff ffffffff ffffffff ffffffff ffffffff " + "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff " + "ffffffff ffffffff ffffffff ffffffff fffffffc",
            b: "00000051 953eb961 8e1c9a1f 929a21a0 b68540ee a2da725b " + "99b315f3 b8b48991 8ef109e1 56193951 ec7e937b 1652c0bd " + "3bb1bf07 3573df88 3d2c34f1 ef451fd4 6b503f00",
            n: "000001ff ffffffff ffffffff ffffffff ffffffff ffffffff " + "ffffffff ffffffff fffffffa 51868783 bf2f966b 7fcc0148 " + "f709a5d0 3bb5c9b8 899c47ae bb6fb71e 91386409",
            hash: n.sha512,
            gRed: false,
            g: [ "000000c6 858e06b7 0404e9cd 9e3ecb66 2395b442 9c648139 " + "053fb521 f828af60 6b4d3dba a14b5e77 efe75928 fe1dc127 " + "a2ffa8de 3348b3c1 856a429b f97e7e31 c2e5bd66", "00000118 39296a78 9a3bc004 5c8a5fb4 2c7d1bd9 98f54449 " + "579b4468 17afbd17 273e662c 97ee7299 5ef42640 c550b901 " + "3fad0761 353c7086 a272c240 88be9476 9fd16650" ]
        });
        o("curve25519", {
            type: "mont",
            prime: "p25519",
            p: "7fffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffed",
            a: "76d06",
            b: "1",
            n: "1000000000000000 0000000000000000 14def9dea2f79cd6 5812631a5cf5d3ed",
            hash: n.sha256,
            gRed: false,
            g: [ "9" ]
        });
        o("ed25519", {
            type: "edwards",
            prime: "p25519",
            p: "7fffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffed",
            a: "-1",
            c: "1",
            d: "52036cee2b6ffe73 8cc740797779e898 00700a4d4141d8ab 75eb4dca135978a3",
            n: "1000000000000000 0000000000000000 14def9dea2f79cd6 5812631a5cf5d3ed",
            hash: n.sha256,
            gRed: false,
            g: [ "216936d3cd6e53fec0a4e231fdd6dc5c692cc7609525a7b2c9562d608f25d51a", "6666666666666666666666666666666666666666666666666666666666666658" ]
        });
        var c;
        try {
            c = e("./precomputed/secp256k1");
        } catch (e) {
            c = undefined;
        }
        o("secp256k1", {
            type: "short",
            prime: "k256",
            p: "ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff fffffffe fffffc2f",
            a: "0",
            b: "7",
            n: "ffffffff ffffffff ffffffff fffffffe baaedce6 af48a03b bfd25e8c d0364141",
            h: "1",
            hash: n.sha256,
            beta: "7ae96a2b657c07106e64479eac3434e99cf0497512f58995c1396c28719501ee",
            lambda: "5363ad4cc05c30e0a5261c028812645a122e22ea20816678df02967c1b23bd72",
            basis: [ {
                a: "3086d221a7d46bcde86c90e49284eb15",
                b: "-e4437ed6010e88286f547fa90abfe4c3"
            }, {
                a: "114ca50f7a8e2f3f657c1108d9d44cfd8",
                b: "3086d221a7d46bcde86c90e49284eb15"
            } ],
            gRed: false,
            g: [ "79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798", "483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8", c ]
        });
    }, {
        "../elliptic": 81,
        "./precomputed/secp256k1": 94,
        "hash.js": 100
    } ],
    88: [ function(e, t, r) {
        "use strict";
        var i = e("bn.js");
        var n = e("hmac-drbg");
        var a = e("../../elliptic");
        var s = a.utils;
        var f = s.assert;
        var o = e("./key");
        var c = e("./signature");
        function h(e) {
            if (!(this instanceof h)) return new h(e);
            if (typeof e === "string") {
                f(a.curves.hasOwnProperty(e), "Unknown curve " + e);
                e = a.curves[e];
            }
            if (e instanceof a.curves.PresetCurve) e = {
                curve: e
            };
            this.curve = e.curve.curve;
            this.n = this.curve.n;
            this.nh = this.n.ushrn(1);
            this.g = this.curve.g;
            this.g = e.curve.g;
            this.g.precompute(e.curve.n.bitLength() + 1);
            this.hash = e.hash || e.curve.hash;
        }
        t.exports = h;
        h.prototype.keyPair = function e(t) {
            return new o(this, t);
        };
        h.prototype.keyFromPrivate = function e(t, r) {
            return o.fromPrivate(this, t, r);
        };
        h.prototype.keyFromPublic = function e(t, r) {
            return o.fromPublic(this, t, r);
        };
        h.prototype.genKeyPair = function e(t) {
            if (!t) t = {};
            var r = new n({
                hash: this.hash,
                pers: t.pers,
                persEnc: t.persEnc || "utf8",
                entropy: t.entropy || a.rand(this.hash.hmacStrength),
                entropyEnc: t.entropy && t.entropyEnc || "utf8",
                nonce: this.n.toArray()
            });
            var s = this.n.byteLength();
            var f = this.n.sub(new i(2));
            do {
                var o = new i(r.generate(s));
                if (o.cmp(f) > 0) continue;
                o.iaddn(1);
                return this.keyFromPrivate(o);
            } while (true);
        };
        h.prototype._truncateToN = function e(t, r) {
            var i = t.byteLength() * 8 - this.n.bitLength();
            if (i > 0) t = t.ushrn(i);
            if (!r && t.cmp(this.n) >= 0) return t.sub(this.n); else return t;
        };
        h.prototype.sign = function e(t, r, a, s) {
            if (typeof a === "object") {
                s = a;
                a = null;
            }
            if (!s) s = {};
            r = this.keyFromPrivate(r, a);
            t = this._truncateToN(new i(t, 16));
            var f = this.n.byteLength();
            var o = r.getPrivate().toArray("be", f);
            var h = t.toArray("be", f);
            var u = new n({
                hash: this.hash,
                entropy: o,
                nonce: h,
                pers: s.pers,
                persEnc: s.persEnc || "utf8"
            });
            var d = this.n.sub(new i(1));
            for (var l = 0; true; l++) {
                var p = s.k ? s.k(l) : new i(u.generate(this.n.byteLength()));
                p = this._truncateToN(p, true);
                if (p.cmpn(1) <= 0 || p.cmp(d) >= 0) continue;
                var b = this.g.mul(p);
                if (b.isInfinity()) continue;
                var v = b.getX();
                var m = v.umod(this.n);
                if (m.cmpn(0) === 0) continue;
                var y = p.invm(this.n).mul(m.mul(r.getPrivate()).iadd(t));
                y = y.umod(this.n);
                if (y.cmpn(0) === 0) continue;
                var g = (b.getY().isOdd() ? 1 : 0) | (v.cmp(m) !== 0 ? 2 : 0);
                if (s.canonical && y.cmp(this.nh) > 0) {
                    y = this.n.sub(y);
                    g ^= 1;
                }
                return new c({
                    r: m,
                    s: y,
                    recoveryParam: g
                });
            }
        };
        h.prototype.verify = function e(t, r, n, a) {
            t = this._truncateToN(new i(t, 16));
            n = this.keyFromPublic(n, a);
            r = new c(r, "hex");
            var s = r.r;
            var f = r.s;
            if (s.cmpn(1) < 0 || s.cmp(this.n) >= 0) return false;
            if (f.cmpn(1) < 0 || f.cmp(this.n) >= 0) return false;
            var o = f.invm(this.n);
            var h = o.mul(t).umod(this.n);
            var u = o.mul(s).umod(this.n);
            if (!this.curve._maxwellTrick) {
                var d = this.g.mulAdd(h, n.getPublic(), u);
                if (d.isInfinity()) return false;
                return d.getX().umod(this.n).cmp(s) === 0;
            }
            var d = this.g.jmulAdd(h, n.getPublic(), u);
            if (d.isInfinity()) return false;
            return d.eqXToP(s);
        };
        h.prototype.recoverPubKey = function(e, t, r, n) {
            f((3 & r) === r, "The recovery param is more than two bits");
            t = new c(t, n);
            var a = this.n;
            var s = new i(e);
            var o = t.r;
            var h = t.s;
            var u = r & 1;
            var d = r >> 1;
            if (o.cmp(this.curve.p.umod(this.curve.n)) >= 0 && d) throw new Error("Unable to find sencond key candinate");
            if (d) o = this.curve.pointFromX(o.add(this.curve.n), u); else o = this.curve.pointFromX(o, u);
            var l = t.r.invm(a);
            var p = a.sub(s).mul(l).umod(a);
            var b = h.mul(l).umod(a);
            return this.g.mulAdd(p, o, b);
        };
        h.prototype.getKeyRecoveryParam = function(e, t, r, i) {
            t = new c(t, i);
            if (t.recoveryParam !== null) return t.recoveryParam;
            for (var n = 0; n < 4; n++) {
                var a;
                try {
                    a = this.recoverPubKey(e, t, n);
                } catch (e) {
                    continue;
                }
                if (a.eq(r)) return n;
            }
            throw new Error("Unable to find valid recovery factor");
        };
    }, {
        "../../elliptic": 81,
        "./key": 89,
        "./signature": 90,
        "bn.js": 32,
        "hmac-drbg": 112
    } ],
    89: [ function(e, t, r) {
        "use strict";
        var i = e("bn.js");
        var n = e("../../elliptic");
        var a = n.utils;
        var s = a.assert;
        function f(e, t) {
            this.ec = e;
            this.priv = null;
            this.pub = null;
            if (t.priv) this._importPrivate(t.priv, t.privEnc);
            if (t.pub) this._importPublic(t.pub, t.pubEnc);
        }
        t.exports = f;
        f.fromPublic = function e(t, r, i) {
            if (r instanceof f) return r;
            return new f(t, {
                pub: r,
                pubEnc: i
            });
        };
        f.fromPrivate = function e(t, r, i) {
            if (r instanceof f) return r;
            return new f(t, {
                priv: r,
                privEnc: i
            });
        };
        f.prototype.validate = function e() {
            var t = this.getPublic();
            if (t.isInfinity()) return {
                result: false,
                reason: "Invalid public key"
            };
            if (!t.validate()) return {
                result: false,
                reason: "Public key is not a point"
            };
            if (!t.mul(this.ec.curve.n).isInfinity()) return {
                result: false,
                reason: "Public key * N != O"
            };
            return {
                result: true,
                reason: null
            };
        };
        f.prototype.getPublic = function e(t, r) {
            if (typeof t === "string") {
                r = t;
                t = null;
            }
            if (!this.pub) this.pub = this.ec.g.mul(this.priv);
            if (!r) return this.pub;
            return this.pub.encode(r, t);
        };
        f.prototype.getPrivate = function e(t) {
            if (t === "hex") return this.priv.toString(16, 2); else return this.priv;
        };
        f.prototype._importPrivate = function e(t, r) {
            this.priv = new i(t, r || 16);
            this.priv = this.priv.umod(this.ec.curve.n);
        };
        f.prototype._importPublic = function e(t, r) {
            if (t.x || t.y) {
                if (this.ec.curve.type === "mont") {
                    s(t.x, "Need x coordinate");
                } else if (this.ec.curve.type === "short" || this.ec.curve.type === "edwards") {
                    s(t.x && t.y, "Need both x and y coordinate");
                }
                this.pub = this.ec.curve.point(t.x, t.y);
                return;
            }
            this.pub = this.ec.curve.decodePoint(t, r);
        };
        f.prototype.derive = function e(t) {
            return t.mul(this.priv).getX();
        };
        f.prototype.sign = function e(t, r, i) {
            return this.ec.sign(t, this, r, i);
        };
        f.prototype.verify = function e(t, r) {
            return this.ec.verify(t, r, this);
        };
        f.prototype.inspect = function e() {
            return "<Key priv: " + (this.priv && this.priv.toString(16, 2)) + " pub: " + (this.pub && this.pub.inspect()) + " >";
        };
    }, {
        "../../elliptic": 81,
        "bn.js": 32
    } ],
    90: [ function(e, t, r) {
        "use strict";
        var i = e("bn.js");
        var n = e("../../elliptic");
        var a = n.utils;
        var s = a.assert;
        function f(e, t) {
            if (e instanceof f) return e;
            if (this._importDER(e, t)) return;
            s(e.r && e.s, "Signature without r or s");
            this.r = new i(e.r, 16);
            this.s = new i(e.s, 16);
            if (e.recoveryParam === undefined) this.recoveryParam = null; else this.recoveryParam = e.recoveryParam;
        }
        t.exports = f;
        function o() {
            this.place = 0;
        }
        function c(e, t) {
            var r = e[t.place++];
            if (!(r & 128)) {
                return r;
            }
            var i = r & 15;
            var n = 0;
            for (var a = 0, s = t.place; a < i; a++, s++) {
                n <<= 8;
                n |= e[s];
            }
            t.place = s;
            return n;
        }
        function h(e) {
            var t = 0;
            var r = e.length - 1;
            while (!e[t] && !(e[t + 1] & 128) && t < r) {
                t++;
            }
            if (t === 0) {
                return e;
            }
            return e.slice(t);
        }
        f.prototype._importDER = function e(t, r) {
            t = a.toArray(t, r);
            var n = new o();
            if (t[n.place++] !== 48) {
                return false;
            }
            var s = c(t, n);
            if (s + n.place !== t.length) {
                return false;
            }
            if (t[n.place++] !== 2) {
                return false;
            }
            var f = c(t, n);
            var h = t.slice(n.place, f + n.place);
            n.place += f;
            if (t[n.place++] !== 2) {
                return false;
            }
            var u = c(t, n);
            if (t.length !== u + n.place) {
                return false;
            }
            var d = t.slice(n.place, u + n.place);
            if (h[0] === 0 && h[1] & 128) {
                h = h.slice(1);
            }
            if (d[0] === 0 && d[1] & 128) {
                d = d.slice(1);
            }
            this.r = new i(h);
            this.s = new i(d);
            this.recoveryParam = null;
            return true;
        };
        function u(e, t) {
            if (t < 128) {
                e.push(t);
                return;
            }
            var r = 1 + (Math.log(t) / Math.LN2 >>> 3);
            e.push(r | 128);
            while (--r) {
                e.push(t >>> (r << 3) & 255);
            }
            e.push(t);
        }
        f.prototype.toDER = function e(t) {
            var r = this.r.toArray();
            var i = this.s.toArray();
            if (r[0] & 128) r = [ 0 ].concat(r);
            if (i[0] & 128) i = [ 0 ].concat(i);
            r = h(r);
            i = h(i);
            while (!i[0] && !(i[1] & 128)) {
                i = i.slice(1);
            }
            var n = [ 2 ];
            u(n, r.length);
            n = n.concat(r);
            n.push(2);
            u(n, i.length);
            var s = n.concat(i);
            var f = [ 48 ];
            u(f, s.length);
            f = f.concat(s);
            return a.encode(f, t);
        };
    }, {
        "../../elliptic": 81,
        "bn.js": 32
    } ],
    91: [ function(e, t, r) {
        "use strict";
        var i = e("hash.js");
        var n = e("../../elliptic");
        var a = n.utils;
        var s = a.assert;
        var f = a.parseBytes;
        var o = e("./key");
        var c = e("./signature");
        function h(e) {
            s(e === "ed25519", "only tested with ed25519 so far");
            if (!(this instanceof h)) return new h(e);
            var e = n.curves[e].curve;
            this.curve = e;
            this.g = e.g;
            this.g.precompute(e.n.bitLength() + 1);
            this.pointClass = e.point().constructor;
            this.encodingLength = Math.ceil(e.n.bitLength() / 8);
            this.hash = i.sha512;
        }
        t.exports = h;
        h.prototype.sign = function e(t, r) {
            t = f(t);
            var i = this.keyFromSecret(r);
            var n = this.hashInt(i.messagePrefix(), t);
            var a = this.g.mul(n);
            var s = this.encodePoint(a);
            var o = this.hashInt(s, i.pubBytes(), t).mul(i.priv());
            var c = n.add(o).umod(this.curve.n);
            return this.makeSignature({
                R: a,
                S: c,
                Rencoded: s
            });
        };
        h.prototype.verify = function e(t, r, i) {
            t = f(t);
            r = this.makeSignature(r);
            var n = this.keyFromPublic(i);
            var a = this.hashInt(r.Rencoded(), n.pubBytes(), t);
            var s = this.g.mul(r.S());
            var o = r.R().add(n.pub().mul(a));
            return o.eq(s);
        };
        h.prototype.hashInt = function e() {
            var t = this.hash();
            for (var r = 0; r < arguments.length; r++) t.update(arguments[r]);
            return a.intFromLE(t.digest()).umod(this.curve.n);
        };
        h.prototype.keyFromPublic = function e(t) {
            return o.fromPublic(this, t);
        };
        h.prototype.keyFromSecret = function e(t) {
            return o.fromSecret(this, t);
        };
        h.prototype.makeSignature = function e(t) {
            if (t instanceof c) return t;
            return new c(this, t);
        };
        h.prototype.encodePoint = function e(t) {
            var r = t.getY().toArray("le", this.encodingLength);
            r[this.encodingLength - 1] |= t.getX().isOdd() ? 128 : 0;
            return r;
        };
        h.prototype.decodePoint = function e(t) {
            t = a.parseBytes(t);
            var r = t.length - 1;
            var i = t.slice(0, r).concat(t[r] & ~128);
            var n = (t[r] & 128) !== 0;
            var s = a.intFromLE(i);
            return this.curve.pointFromY(s, n);
        };
        h.prototype.encodeInt = function e(t) {
            return t.toArray("le", this.encodingLength);
        };
        h.prototype.decodeInt = function e(t) {
            return a.intFromLE(t);
        };
        h.prototype.isPoint = function e(t) {
            return t instanceof this.pointClass;
        };
    }, {
        "../../elliptic": 81,
        "./key": 92,
        "./signature": 93,
        "hash.js": 100
    } ],
    92: [ function(e, t, r) {
        "use strict";
        var i = e("../../elliptic");
        var n = i.utils;
        var a = n.assert;
        var s = n.parseBytes;
        var f = n.cachedProperty;
        function o(e, t) {
            this.eddsa = e;
            this._secret = s(t.secret);
            if (e.isPoint(t.pub)) this._pub = t.pub; else this._pubBytes = s(t.pub);
        }
        o.fromPublic = function e(t, r) {
            if (r instanceof o) return r;
            return new o(t, {
                pub: r
            });
        };
        o.fromSecret = function e(t, r) {
            if (r instanceof o) return r;
            return new o(t, {
                secret: r
            });
        };
        o.prototype.secret = function e() {
            return this._secret;
        };
        f(o, "pubBytes", function e() {
            return this.eddsa.encodePoint(this.pub());
        });
        f(o, "pub", function e() {
            if (this._pubBytes) return this.eddsa.decodePoint(this._pubBytes);
            return this.eddsa.g.mul(this.priv());
        });
        f(o, "privBytes", function e() {
            var t = this.eddsa;
            var r = this.hash();
            var i = t.encodingLength - 1;
            var n = r.slice(0, t.encodingLength);
            n[0] &= 248;
            n[i] &= 127;
            n[i] |= 64;
            return n;
        });
        f(o, "priv", function e() {
            return this.eddsa.decodeInt(this.privBytes());
        });
        f(o, "hash", function e() {
            return this.eddsa.hash().update(this.secret()).digest();
        });
        f(o, "messagePrefix", function e() {
            return this.hash().slice(this.eddsa.encodingLength);
        });
        o.prototype.sign = function e(t) {
            a(this._secret, "KeyPair can only verify");
            return this.eddsa.sign(t, this);
        };
        o.prototype.verify = function e(t, r) {
            return this.eddsa.verify(t, r, this);
        };
        o.prototype.getSecret = function e(t) {
            a(this._secret, "KeyPair is public only");
            return n.encode(this.secret(), t);
        };
        o.prototype.getPublic = function e(t) {
            return n.encode(this.pubBytes(), t);
        };
        t.exports = o;
    }, {
        "../../elliptic": 81
    } ],
    93: [ function(e, t, r) {
        "use strict";
        var i = e("bn.js");
        var n = e("../../elliptic");
        var a = n.utils;
        var s = a.assert;
        var f = a.cachedProperty;
        var o = a.parseBytes;
        function c(e, t) {
            this.eddsa = e;
            if (typeof t !== "object") t = o(t);
            if (Array.isArray(t)) {
                t = {
                    R: t.slice(0, e.encodingLength),
                    S: t.slice(e.encodingLength)
                };
            }
            s(t.R && t.S, "Signature without R or S");
            if (e.isPoint(t.R)) this._R = t.R;
            if (t.S instanceof i) this._S = t.S;
            this._Rencoded = Array.isArray(t.R) ? t.R : t.Rencoded;
            this._Sencoded = Array.isArray(t.S) ? t.S : t.Sencoded;
        }
        f(c, "S", function e() {
            return this.eddsa.decodeInt(this.Sencoded());
        });
        f(c, "R", function e() {
            return this.eddsa.decodePoint(this.Rencoded());
        });
        f(c, "Rencoded", function e() {
            return this.eddsa.encodePoint(this.R());
        });
        f(c, "Sencoded", function e() {
            return this.eddsa.encodeInt(this.S());
        });
        c.prototype.toBytes = function e() {
            return this.Rencoded().concat(this.Sencoded());
        };
        c.prototype.toHex = function e() {
            return a.encode(this.toBytes(), "hex").toUpperCase();
        };
        t.exports = c;
    }, {
        "../../elliptic": 81,
        "bn.js": 32
    } ],
    94: [ function(e, t, r) {
        t.exports = {
            doubles: {
                step: 4,
                points: [ [ "e60fce93b59e9ec53011aabc21c23e97b2a31369b87a5ae9c44ee89e2a6dec0a", "f7e3507399e595929db99f34f57937101296891e44d23f0be1f32cce69616821" ], [ "8282263212c609d9ea2a6e3e172de238d8c39cabd5ac1ca10646e23fd5f51508", "11f8a8098557dfe45e8256e830b60ace62d613ac2f7b17bed31b6eaff6e26caf" ], [ "175e159f728b865a72f99cc6c6fc846de0b93833fd2222ed73fce5b551e5b739", "d3506e0d9e3c79eba4ef97a51ff71f5eacb5955add24345c6efa6ffee9fed695" ], [ "363d90d447b00c9c99ceac05b6262ee053441c7e55552ffe526bad8f83ff4640", "4e273adfc732221953b445397f3363145b9a89008199ecb62003c7f3bee9de9" ], [ "8b4b5f165df3c2be8c6244b5b745638843e4a781a15bcd1b69f79a55dffdf80c", "4aad0a6f68d308b4b3fbd7813ab0da04f9e336546162ee56b3eff0c65fd4fd36" ], [ "723cbaa6e5db996d6bf771c00bd548c7b700dbffa6c0e77bcb6115925232fcda", "96e867b5595cc498a921137488824d6e2660a0653779494801dc069d9eb39f5f" ], [ "eebfa4d493bebf98ba5feec812c2d3b50947961237a919839a533eca0e7dd7fa", "5d9a8ca3970ef0f269ee7edaf178089d9ae4cdc3a711f712ddfd4fdae1de8999" ], [ "100f44da696e71672791d0a09b7bde459f1215a29b3c03bfefd7835b39a48db0", "cdd9e13192a00b772ec8f3300c090666b7ff4a18ff5195ac0fbd5cd62bc65a09" ], [ "e1031be262c7ed1b1dc9227a4a04c017a77f8d4464f3b3852c8acde6e534fd2d", "9d7061928940405e6bb6a4176597535af292dd419e1ced79a44f18f29456a00d" ], [ "feea6cae46d55b530ac2839f143bd7ec5cf8b266a41d6af52d5e688d9094696d", "e57c6b6c97dce1bab06e4e12bf3ecd5c981c8957cc41442d3155debf18090088" ], [ "da67a91d91049cdcb367be4be6ffca3cfeed657d808583de33fa978bc1ec6cb1", "9bacaa35481642bc41f463f7ec9780e5dec7adc508f740a17e9ea8e27a68be1d" ], [ "53904faa0b334cdda6e000935ef22151ec08d0f7bb11069f57545ccc1a37b7c0", "5bc087d0bc80106d88c9eccac20d3c1c13999981e14434699dcb096b022771c8" ], [ "8e7bcd0bd35983a7719cca7764ca906779b53a043a9b8bcaeff959f43ad86047", "10b7770b2a3da4b3940310420ca9514579e88e2e47fd68b3ea10047e8460372a" ], [ "385eed34c1cdff21e6d0818689b81bde71a7f4f18397e6690a841e1599c43862", "283bebc3e8ea23f56701de19e9ebf4576b304eec2086dc8cc0458fe5542e5453" ], [ "6f9d9b803ecf191637c73a4413dfa180fddf84a5947fbc9c606ed86c3fac3a7", "7c80c68e603059ba69b8e2a30e45c4d47ea4dd2f5c281002d86890603a842160" ], [ "3322d401243c4e2582a2147c104d6ecbf774d163db0f5e5313b7e0e742d0e6bd", "56e70797e9664ef5bfb019bc4ddaf9b72805f63ea2873af624f3a2e96c28b2a0" ], [ "85672c7d2de0b7da2bd1770d89665868741b3f9af7643397721d74d28134ab83", "7c481b9b5b43b2eb6374049bfa62c2e5e77f17fcc5298f44c8e3094f790313a6" ], [ "948bf809b1988a46b06c9f1919413b10f9226c60f668832ffd959af60c82a0a", "53a562856dcb6646dc6b74c5d1c3418c6d4dff08c97cd2bed4cb7f88d8c8e589" ], [ "6260ce7f461801c34f067ce0f02873a8f1b0e44dfc69752accecd819f38fd8e8", "bc2da82b6fa5b571a7f09049776a1ef7ecd292238051c198c1a84e95b2b4ae17" ], [ "e5037de0afc1d8d43d8348414bbf4103043ec8f575bfdc432953cc8d2037fa2d", "4571534baa94d3b5f9f98d09fb990bddbd5f5b03ec481f10e0e5dc841d755bda" ], [ "e06372b0f4a207adf5ea905e8f1771b4e7e8dbd1c6a6c5b725866a0ae4fce725", "7a908974bce18cfe12a27bb2ad5a488cd7484a7787104870b27034f94eee31dd" ], [ "213c7a715cd5d45358d0bbf9dc0ce02204b10bdde2a3f58540ad6908d0559754", "4b6dad0b5ae462507013ad06245ba190bb4850f5f36a7eeddff2c27534b458f2" ], [ "4e7c272a7af4b34e8dbb9352a5419a87e2838c70adc62cddf0cc3a3b08fbd53c", "17749c766c9d0b18e16fd09f6def681b530b9614bff7dd33e0b3941817dcaae6" ], [ "fea74e3dbe778b1b10f238ad61686aa5c76e3db2be43057632427e2840fb27b6", "6e0568db9b0b13297cf674deccb6af93126b596b973f7b77701d3db7f23cb96f" ], [ "76e64113f677cf0e10a2570d599968d31544e179b760432952c02a4417bdde39", "c90ddf8dee4e95cf577066d70681f0d35e2a33d2b56d2032b4b1752d1901ac01" ], [ "c738c56b03b2abe1e8281baa743f8f9a8f7cc643df26cbee3ab150242bcbb891", "893fb578951ad2537f718f2eacbfbbbb82314eef7880cfe917e735d9699a84c3" ], [ "d895626548b65b81e264c7637c972877d1d72e5f3a925014372e9f6588f6c14b", "febfaa38f2bc7eae728ec60818c340eb03428d632bb067e179363ed75d7d991f" ], [ "b8da94032a957518eb0f6433571e8761ceffc73693e84edd49150a564f676e03", "2804dfa44805a1e4d7c99cc9762808b092cc584d95ff3b511488e4e74efdf6e7" ], [ "e80fea14441fb33a7d8adab9475d7fab2019effb5156a792f1a11778e3c0df5d", "eed1de7f638e00771e89768ca3ca94472d155e80af322ea9fcb4291b6ac9ec78" ], [ "a301697bdfcd704313ba48e51d567543f2a182031efd6915ddc07bbcc4e16070", "7370f91cfb67e4f5081809fa25d40f9b1735dbf7c0a11a130c0d1a041e177ea1" ], [ "90ad85b389d6b936463f9d0512678de208cc330b11307fffab7ac63e3fb04ed4", "e507a3620a38261affdcbd9427222b839aefabe1582894d991d4d48cb6ef150" ], [ "8f68b9d2f63b5f339239c1ad981f162ee88c5678723ea3351b7b444c9ec4c0da", "662a9f2dba063986de1d90c2b6be215dbbea2cfe95510bfdf23cbf79501fff82" ], [ "e4f3fb0176af85d65ff99ff9198c36091f48e86503681e3e6686fd5053231e11", "1e63633ad0ef4f1c1661a6d0ea02b7286cc7e74ec951d1c9822c38576feb73bc" ], [ "8c00fa9b18ebf331eb961537a45a4266c7034f2f0d4e1d0716fb6eae20eae29e", "efa47267fea521a1a9dc343a3736c974c2fadafa81e36c54e7d2a4c66702414b" ], [ "e7a26ce69dd4829f3e10cec0a9e98ed3143d084f308b92c0997fddfc60cb3e41", "2a758e300fa7984b471b006a1aafbb18d0a6b2c0420e83e20e8a9421cf2cfd51" ], [ "b6459e0ee3662ec8d23540c223bcbdc571cbcb967d79424f3cf29eb3de6b80ef", "67c876d06f3e06de1dadf16e5661db3c4b3ae6d48e35b2ff30bf0b61a71ba45" ], [ "d68a80c8280bb840793234aa118f06231d6f1fc67e73c5a5deda0f5b496943e8", "db8ba9fff4b586d00c4b1f9177b0e28b5b0e7b8f7845295a294c84266b133120" ], [ "324aed7df65c804252dc0270907a30b09612aeb973449cea4095980fc28d3d5d", "648a365774b61f2ff130c0c35aec1f4f19213b0c7e332843967224af96ab7c84" ], [ "4df9c14919cde61f6d51dfdbe5fee5dceec4143ba8d1ca888e8bd373fd054c96", "35ec51092d8728050974c23a1d85d4b5d506cdc288490192ebac06cad10d5d" ], [ "9c3919a84a474870faed8a9c1cc66021523489054d7f0308cbfc99c8ac1f98cd", "ddb84f0f4a4ddd57584f044bf260e641905326f76c64c8e6be7e5e03d4fc599d" ], [ "6057170b1dd12fdf8de05f281d8e06bb91e1493a8b91d4cc5a21382120a959e5", "9a1af0b26a6a4807add9a2daf71df262465152bc3ee24c65e899be932385a2a8" ], [ "a576df8e23a08411421439a4518da31880cef0fba7d4df12b1a6973eecb94266", "40a6bf20e76640b2c92b97afe58cd82c432e10a7f514d9f3ee8be11ae1b28ec8" ], [ "7778a78c28dec3e30a05fe9629de8c38bb30d1f5cf9a3a208f763889be58ad71", "34626d9ab5a5b22ff7098e12f2ff580087b38411ff24ac563b513fc1fd9f43ac" ], [ "928955ee637a84463729fd30e7afd2ed5f96274e5ad7e5cb09eda9c06d903ac", "c25621003d3f42a827b78a13093a95eeac3d26efa8a8d83fc5180e935bcd091f" ], [ "85d0fef3ec6db109399064f3a0e3b2855645b4a907ad354527aae75163d82751", "1f03648413a38c0be29d496e582cf5663e8751e96877331582c237a24eb1f962" ], [ "ff2b0dce97eece97c1c9b6041798b85dfdfb6d8882da20308f5404824526087e", "493d13fef524ba188af4c4dc54d07936c7b7ed6fb90e2ceb2c951e01f0c29907" ], [ "827fbbe4b1e880ea9ed2b2e6301b212b57f1ee148cd6dd28780e5e2cf856e241", "c60f9c923c727b0b71bef2c67d1d12687ff7a63186903166d605b68baec293ec" ], [ "eaa649f21f51bdbae7be4ae34ce6e5217a58fdce7f47f9aa7f3b58fa2120e2b3", "be3279ed5bbbb03ac69a80f89879aa5a01a6b965f13f7e59d47a5305ba5ad93d" ], [ "e4a42d43c5cf169d9391df6decf42ee541b6d8f0c9a137401e23632dda34d24f", "4d9f92e716d1c73526fc99ccfb8ad34ce886eedfa8d8e4f13a7f7131deba9414" ], [ "1ec80fef360cbdd954160fadab352b6b92b53576a88fea4947173b9d4300bf19", "aeefe93756b5340d2f3a4958a7abbf5e0146e77f6295a07b671cdc1cc107cefd" ], [ "146a778c04670c2f91b00af4680dfa8bce3490717d58ba889ddb5928366642be", "b318e0ec3354028add669827f9d4b2870aaa971d2f7e5ed1d0b297483d83efd0" ], [ "fa50c0f61d22e5f07e3acebb1aa07b128d0012209a28b9776d76a8793180eef9", "6b84c6922397eba9b72cd2872281a68a5e683293a57a213b38cd8d7d3f4f2811" ], [ "da1d61d0ca721a11b1a5bf6b7d88e8421a288ab5d5bba5220e53d32b5f067ec2", "8157f55a7c99306c79c0766161c91e2966a73899d279b48a655fba0f1ad836f1" ], [ "a8e282ff0c9706907215ff98e8fd416615311de0446f1e062a73b0610d064e13", "7f97355b8db81c09abfb7f3c5b2515888b679a3e50dd6bd6cef7c73111f4cc0c" ], [ "174a53b9c9a285872d39e56e6913cab15d59b1fa512508c022f382de8319497c", "ccc9dc37abfc9c1657b4155f2c47f9e6646b3a1d8cb9854383da13ac079afa73" ], [ "959396981943785c3d3e57edf5018cdbe039e730e4918b3d884fdff09475b7ba", "2e7e552888c331dd8ba0386a4b9cd6849c653f64c8709385e9b8abf87524f2fd" ], [ "d2a63a50ae401e56d645a1153b109a8fcca0a43d561fba2dbb51340c9d82b151", "e82d86fb6443fcb7565aee58b2948220a70f750af484ca52d4142174dcf89405" ], [ "64587e2335471eb890ee7896d7cfdc866bacbdbd3839317b3436f9b45617e073", "d99fcdd5bf6902e2ae96dd6447c299a185b90a39133aeab358299e5e9faf6589" ], [ "8481bde0e4e4d885b3a546d3e549de042f0aa6cea250e7fd358d6c86dd45e458", "38ee7b8cba5404dd84a25bf39cecb2ca900a79c42b262e556d64b1b59779057e" ], [ "13464a57a78102aa62b6979ae817f4637ffcfed3c4b1ce30bcd6303f6caf666b", "69be159004614580ef7e433453ccb0ca48f300a81d0942e13f495a907f6ecc27" ], [ "bc4a9df5b713fe2e9aef430bcc1dc97a0cd9ccede2f28588cada3a0d2d83f366", "d3a81ca6e785c06383937adf4b798caa6e8a9fbfa547b16d758d666581f33c1" ], [ "8c28a97bf8298bc0d23d8c749452a32e694b65e30a9472a3954ab30fe5324caa", "40a30463a3305193378fedf31f7cc0eb7ae784f0451cb9459e71dc73cbef9482" ], [ "8ea9666139527a8c1dd94ce4f071fd23c8b350c5a4bb33748c4ba111faccae0", "620efabbc8ee2782e24e7c0cfb95c5d735b783be9cf0f8e955af34a30e62b945" ], [ "dd3625faef5ba06074669716bbd3788d89bdde815959968092f76cc4eb9a9787", "7a188fa3520e30d461da2501045731ca941461982883395937f68d00c644a573" ], [ "f710d79d9eb962297e4f6232b40e8f7feb2bc63814614d692c12de752408221e", "ea98e67232d3b3295d3b535532115ccac8612c721851617526ae47a9c77bfc82" ] ]
            },
            naf: {
                wnd: 7,
                points: [ [ "f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f9", "388f7b0f632de8140fe337e62a37f3566500a99934c2231b6cb9fd7584b8e672" ], [ "2f8bde4d1a07209355b4a7250a5c5128e88b84bddc619ab7cba8d569b240efe4", "d8ac222636e5e3d6d4dba9dda6c9c426f788271bab0d6840dca87d3aa6ac62d6" ], [ "5cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc", "6aebca40ba255960a3178d6d861a54dba813d0b813fde7b5a5082628087264da" ], [ "acd484e2f0c7f65309ad178a9f559abde09796974c57e714c35f110dfc27ccbe", "cc338921b0a7d9fd64380971763b61e9add888a4375f8e0f05cc262ac64f9c37" ], [ "774ae7f858a9411e5ef4246b70c65aac5649980be5c17891bbec17895da008cb", "d984a032eb6b5e190243dd56d7b7b365372db1e2dff9d6a8301d74c9c953c61b" ], [ "f28773c2d975288bc7d1d205c3748651b075fbc6610e58cddeeddf8f19405aa8", "ab0902e8d880a89758212eb65cdaf473a1a06da521fa91f29b5cb52db03ed81" ], [ "d7924d4f7d43ea965a465ae3095ff41131e5946f3c85f79e44adbcf8e27e080e", "581e2872a86c72a683842ec228cc6defea40af2bd896d3a5c504dc9ff6a26b58" ], [ "defdea4cdb677750a420fee807eacf21eb9898ae79b9768766e4faa04a2d4a34", "4211ab0694635168e997b0ead2a93daeced1f4a04a95c0f6cfb199f69e56eb77" ], [ "2b4ea0a797a443d293ef5cff444f4979f06acfebd7e86d277475656138385b6c", "85e89bc037945d93b343083b5a1c86131a01f60c50269763b570c854e5c09b7a" ], [ "352bbf4a4cdd12564f93fa332ce333301d9ad40271f8107181340aef25be59d5", "321eb4075348f534d59c18259dda3e1f4a1b3b2e71b1039c67bd3d8bcf81998c" ], [ "2fa2104d6b38d11b0230010559879124e42ab8dfeff5ff29dc9cdadd4ecacc3f", "2de1068295dd865b64569335bd5dd80181d70ecfc882648423ba76b532b7d67" ], [ "9248279b09b4d68dab21a9b066edda83263c3d84e09572e269ca0cd7f5453714", "73016f7bf234aade5d1aa71bdea2b1ff3fc0de2a887912ffe54a32ce97cb3402" ], [ "daed4f2be3a8bf278e70132fb0beb7522f570e144bf615c07e996d443dee8729", "a69dce4a7d6c98e8d4a1aca87ef8d7003f83c230f3afa726ab40e52290be1c55" ], [ "c44d12c7065d812e8acf28d7cbb19f9011ecd9e9fdf281b0e6a3b5e87d22e7db", "2119a460ce326cdc76c45926c982fdac0e106e861edf61c5a039063f0e0e6482" ], [ "6a245bf6dc698504c89a20cfded60853152b695336c28063b61c65cbd269e6b4", "e022cf42c2bd4a708b3f5126f16a24ad8b33ba48d0423b6efd5e6348100d8a82" ], [ "1697ffa6fd9de627c077e3d2fe541084ce13300b0bec1146f95ae57f0d0bd6a5", "b9c398f186806f5d27561506e4557433a2cf15009e498ae7adee9d63d01b2396" ], [ "605bdb019981718b986d0f07e834cb0d9deb8360ffb7f61df982345ef27a7479", "2972d2de4f8d20681a78d93ec96fe23c26bfae84fb14db43b01e1e9056b8c49" ], [ "62d14dab4150bf497402fdc45a215e10dcb01c354959b10cfe31c7e9d87ff33d", "80fc06bd8cc5b01098088a1950eed0db01aa132967ab472235f5642483b25eaf" ], [ "80c60ad0040f27dade5b4b06c408e56b2c50e9f56b9b8b425e555c2f86308b6f", "1c38303f1cc5c30f26e66bad7fe72f70a65eed4cbe7024eb1aa01f56430bd57a" ], [ "7a9375ad6167ad54aa74c6348cc54d344cc5dc9487d847049d5eabb0fa03c8fb", "d0e3fa9eca8726909559e0d79269046bdc59ea10c70ce2b02d499ec224dc7f7" ], [ "d528ecd9b696b54c907a9ed045447a79bb408ec39b68df504bb51f459bc3ffc9", "eecf41253136e5f99966f21881fd656ebc4345405c520dbc063465b521409933" ], [ "49370a4b5f43412ea25f514e8ecdad05266115e4a7ecb1387231808f8b45963", "758f3f41afd6ed428b3081b0512fd62a54c3f3afbb5b6764b653052a12949c9a" ], [ "77f230936ee88cbbd73df930d64702ef881d811e0e1498e2f1c13eb1fc345d74", "958ef42a7886b6400a08266e9ba1b37896c95330d97077cbbe8eb3c7671c60d6" ], [ "f2dac991cc4ce4b9ea44887e5c7c0bce58c80074ab9d4dbaeb28531b7739f530", "e0dedc9b3b2f8dad4da1f32dec2531df9eb5fbeb0598e4fd1a117dba703a3c37" ], [ "463b3d9f662621fb1b4be8fbbe2520125a216cdfc9dae3debcba4850c690d45b", "5ed430d78c296c3543114306dd8622d7c622e27c970a1de31cb377b01af7307e" ], [ "f16f804244e46e2a09232d4aff3b59976b98fac14328a2d1a32496b49998f247", "cedabd9b82203f7e13d206fcdf4e33d92a6c53c26e5cce26d6579962c4e31df6" ], [ "caf754272dc84563b0352b7a14311af55d245315ace27c65369e15f7151d41d1", "cb474660ef35f5f2a41b643fa5e460575f4fa9b7962232a5c32f908318a04476" ], [ "2600ca4b282cb986f85d0f1709979d8b44a09c07cb86d7c124497bc86f082120", "4119b88753c15bd6a693b03fcddbb45d5ac6be74ab5f0ef44b0be9475a7e4b40" ], [ "7635ca72d7e8432c338ec53cd12220bc01c48685e24f7dc8c602a7746998e435", "91b649609489d613d1d5e590f78e6d74ecfc061d57048bad9e76f302c5b9c61" ], [ "754e3239f325570cdbbf4a87deee8a66b7f2b33479d468fbc1a50743bf56cc18", "673fb86e5bda30fb3cd0ed304ea49a023ee33d0197a695d0c5d98093c536683" ], [ "e3e6bd1071a1e96aff57859c82d570f0330800661d1c952f9fe2694691d9b9e8", "59c9e0bba394e76f40c0aa58379a3cb6a5a2283993e90c4167002af4920e37f5" ], [ "186b483d056a033826ae73d88f732985c4ccb1f32ba35f4b4cc47fdcf04aa6eb", "3b952d32c67cf77e2e17446e204180ab21fb8090895138b4a4a797f86e80888b" ], [ "df9d70a6b9876ce544c98561f4be4f725442e6d2b737d9c91a8321724ce0963f", "55eb2dafd84d6ccd5f862b785dc39d4ab157222720ef9da217b8c45cf2ba2417" ], [ "5edd5cc23c51e87a497ca815d5dce0f8ab52554f849ed8995de64c5f34ce7143", "efae9c8dbc14130661e8cec030c89ad0c13c66c0d17a2905cdc706ab7399a868" ], [ "290798c2b6476830da12fe02287e9e777aa3fba1c355b17a722d362f84614fba", "e38da76dcd440621988d00bcf79af25d5b29c094db2a23146d003afd41943e7a" ], [ "af3c423a95d9f5b3054754efa150ac39cd29552fe360257362dfdecef4053b45", "f98a3fd831eb2b749a93b0e6f35cfb40c8cd5aa667a15581bc2feded498fd9c6" ], [ "766dbb24d134e745cccaa28c99bf274906bb66b26dcf98df8d2fed50d884249a", "744b1152eacbe5e38dcc887980da38b897584a65fa06cedd2c924f97cbac5996" ], [ "59dbf46f8c94759ba21277c33784f41645f7b44f6c596a58ce92e666191abe3e", "c534ad44175fbc300f4ea6ce648309a042ce739a7919798cd85e216c4a307f6e" ], [ "f13ada95103c4537305e691e74e9a4a8dd647e711a95e73cb62dc6018cfd87b8", "e13817b44ee14de663bf4bc808341f326949e21a6a75c2570778419bdaf5733d" ], [ "7754b4fa0e8aced06d4167a2c59cca4cda1869c06ebadfb6488550015a88522c", "30e93e864e669d82224b967c3020b8fa8d1e4e350b6cbcc537a48b57841163a2" ], [ "948dcadf5990e048aa3874d46abef9d701858f95de8041d2a6828c99e2262519", "e491a42537f6e597d5d28a3224b1bc25df9154efbd2ef1d2cbba2cae5347d57e" ], [ "7962414450c76c1689c7b48f8202ec37fb224cf5ac0bfa1570328a8a3d7c77ab", "100b610ec4ffb4760d5c1fc133ef6f6b12507a051f04ac5760afa5b29db83437" ], [ "3514087834964b54b15b160644d915485a16977225b8847bb0dd085137ec47ca", "ef0afbb2056205448e1652c48e8127fc6039e77c15c2378b7e7d15a0de293311" ], [ "d3cc30ad6b483e4bc79ce2c9dd8bc54993e947eb8df787b442943d3f7b527eaf", "8b378a22d827278d89c5e9be8f9508ae3c2ad46290358630afb34db04eede0a4" ], [ "1624d84780732860ce1c78fcbfefe08b2b29823db913f6493975ba0ff4847610", "68651cf9b6da903e0914448c6cd9d4ca896878f5282be4c8cc06e2a404078575" ], [ "733ce80da955a8a26902c95633e62a985192474b5af207da6df7b4fd5fc61cd4", "f5435a2bd2badf7d485a4d8b8db9fcce3e1ef8e0201e4578c54673bc1dc5ea1d" ], [ "15d9441254945064cf1a1c33bbd3b49f8966c5092171e699ef258dfab81c045c", "d56eb30b69463e7234f5137b73b84177434800bacebfc685fc37bbe9efe4070d" ], [ "a1d0fcf2ec9de675b612136e5ce70d271c21417c9d2b8aaaac138599d0717940", "edd77f50bcb5a3cab2e90737309667f2641462a54070f3d519212d39c197a629" ], [ "e22fbe15c0af8ccc5780c0735f84dbe9a790badee8245c06c7ca37331cb36980", "a855babad5cd60c88b430a69f53a1a7a38289154964799be43d06d77d31da06" ], [ "311091dd9860e8e20ee13473c1155f5f69635e394704eaa74009452246cfa9b3", "66db656f87d1f04fffd1f04788c06830871ec5a64feee685bd80f0b1286d8374" ], [ "34c1fd04d301be89b31c0442d3e6ac24883928b45a9340781867d4232ec2dbdf", "9414685e97b1b5954bd46f730174136d57f1ceeb487443dc5321857ba73abee" ], [ "f219ea5d6b54701c1c14de5b557eb42a8d13f3abbcd08affcc2a5e6b049b8d63", "4cb95957e83d40b0f73af4544cccf6b1f4b08d3c07b27fb8d8c2962a400766d1" ], [ "d7b8740f74a8fbaab1f683db8f45de26543a5490bca627087236912469a0b448", "fa77968128d9c92ee1010f337ad4717eff15db5ed3c049b3411e0315eaa4593b" ], [ "32d31c222f8f6f0ef86f7c98d3a3335ead5bcd32abdd94289fe4d3091aa824bf", "5f3032f5892156e39ccd3d7915b9e1da2e6dac9e6f26e961118d14b8462e1661" ], [ "7461f371914ab32671045a155d9831ea8793d77cd59592c4340f86cbc18347b5", "8ec0ba238b96bec0cbdddcae0aa442542eee1ff50c986ea6b39847b3cc092ff6" ], [ "ee079adb1df1860074356a25aa38206a6d716b2c3e67453d287698bad7b2b2d6", "8dc2412aafe3be5c4c5f37e0ecc5f9f6a446989af04c4e25ebaac479ec1c8c1e" ], [ "16ec93e447ec83f0467b18302ee620f7e65de331874c9dc72bfd8616ba9da6b5", "5e4631150e62fb40d0e8c2a7ca5804a39d58186a50e497139626778e25b0674d" ], [ "eaa5f980c245f6f038978290afa70b6bd8855897f98b6aa485b96065d537bd99", "f65f5d3e292c2e0819a528391c994624d784869d7e6ea67fb18041024edc07dc" ], [ "78c9407544ac132692ee1910a02439958ae04877151342ea96c4b6b35a49f51", "f3e0319169eb9b85d5404795539a5e68fa1fbd583c064d2462b675f194a3ddb4" ], [ "494f4be219a1a77016dcd838431aea0001cdc8ae7a6fc688726578d9702857a5", "42242a969283a5f339ba7f075e36ba2af925ce30d767ed6e55f4b031880d562c" ], [ "a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5", "204b5d6f84822c307e4b4a7140737aec23fc63b65b35f86a10026dbd2d864e6b" ], [ "c41916365abb2b5d09192f5f2dbeafec208f020f12570a184dbadc3e58595997", "4f14351d0087efa49d245b328984989d5caf9450f34bfc0ed16e96b58fa9913" ], [ "841d6063a586fa475a724604da03bc5b92a2e0d2e0a36acfe4c73a5514742881", "73867f59c0659e81904f9a1c7543698e62562d6744c169ce7a36de01a8d6154" ], [ "5e95bb399a6971d376026947f89bde2f282b33810928be4ded112ac4d70e20d5", "39f23f366809085beebfc71181313775a99c9aed7d8ba38b161384c746012865" ], [ "36e4641a53948fd476c39f8a99fd974e5ec07564b5315d8bf99471bca0ef2f66", "d2424b1b1abe4eb8164227b085c9aa9456ea13493fd563e06fd51cf5694c78fc" ], [ "336581ea7bfbbb290c191a2f507a41cf5643842170e914faeab27c2c579f726", "ead12168595fe1be99252129b6e56b3391f7ab1410cd1e0ef3dcdcabd2fda224" ], [ "8ab89816dadfd6b6a1f2634fcf00ec8403781025ed6890c4849742706bd43ede", "6fdcef09f2f6d0a044e654aef624136f503d459c3e89845858a47a9129cdd24e" ], [ "1e33f1a746c9c5778133344d9299fcaa20b0938e8acff2544bb40284b8c5fb94", "60660257dd11b3aa9c8ed618d24edff2306d320f1d03010e33a7d2057f3b3b6" ], [ "85b7c1dcb3cec1b7ee7f30ded79dd20a0ed1f4cc18cbcfcfa410361fd8f08f31", "3d98a9cdd026dd43f39048f25a8847f4fcafad1895d7a633c6fed3c35e999511" ], [ "29df9fbd8d9e46509275f4b125d6d45d7fbe9a3b878a7af872a2800661ac5f51", "b4c4fe99c775a606e2d8862179139ffda61dc861c019e55cd2876eb2a27d84b" ], [ "a0b1cae06b0a847a3fea6e671aaf8adfdfe58ca2f768105c8082b2e449fce252", "ae434102edde0958ec4b19d917a6a28e6b72da1834aff0e650f049503a296cf2" ], [ "4e8ceafb9b3e9a136dc7ff67e840295b499dfb3b2133e4ba113f2e4c0e121e5", "cf2174118c8b6d7a4b48f6d534ce5c79422c086a63460502b827ce62a326683c" ], [ "d24a44e047e19b6f5afb81c7ca2f69080a5076689a010919f42725c2b789a33b", "6fb8d5591b466f8fc63db50f1c0f1c69013f996887b8244d2cdec417afea8fa3" ], [ "ea01606a7a6c9cdd249fdfcfacb99584001edd28abbab77b5104e98e8e3b35d4", "322af4908c7312b0cfbfe369f7a7b3cdb7d4494bc2823700cfd652188a3ea98d" ], [ "af8addbf2b661c8a6c6328655eb96651252007d8c5ea31be4ad196de8ce2131f", "6749e67c029b85f52a034eafd096836b2520818680e26ac8f3dfbcdb71749700" ], [ "e3ae1974566ca06cc516d47e0fb165a674a3dabcfca15e722f0e3450f45889", "2aeabe7e4531510116217f07bf4d07300de97e4874f81f533420a72eeb0bd6a4" ], [ "591ee355313d99721cf6993ffed1e3e301993ff3ed258802075ea8ced397e246", "b0ea558a113c30bea60fc4775460c7901ff0b053d25ca2bdeee98f1a4be5d196" ], [ "11396d55fda54c49f19aa97318d8da61fa8584e47b084945077cf03255b52984", "998c74a8cd45ac01289d5833a7beb4744ff536b01b257be4c5767bea93ea57a4" ], [ "3c5d2a1ba39c5a1790000738c9e0c40b8dcdfd5468754b6405540157e017aa7a", "b2284279995a34e2f9d4de7396fc18b80f9b8b9fdd270f6661f79ca4c81bd257" ], [ "cc8704b8a60a0defa3a99a7299f2e9c3fbc395afb04ac078425ef8a1793cc030", "bdd46039feed17881d1e0862db347f8cf395b74fc4bcdc4e940b74e3ac1f1b13" ], [ "c533e4f7ea8555aacd9777ac5cad29b97dd4defccc53ee7ea204119b2889b197", "6f0a256bc5efdf429a2fb6242f1a43a2d9b925bb4a4b3a26bb8e0f45eb596096" ], [ "c14f8f2ccb27d6f109f6d08d03cc96a69ba8c34eec07bbcf566d48e33da6593", "c359d6923bb398f7fd4473e16fe1c28475b740dd098075e6c0e8649113dc3a38" ], [ "a6cbc3046bc6a450bac24789fa17115a4c9739ed75f8f21ce441f72e0b90e6ef", "21ae7f4680e889bb130619e2c0f95a360ceb573c70603139862afd617fa9b9f" ], [ "347d6d9a02c48927ebfb86c1359b1caf130a3c0267d11ce6344b39f99d43cc38", "60ea7f61a353524d1c987f6ecec92f086d565ab687870cb12689ff1e31c74448" ], [ "da6545d2181db8d983f7dcb375ef5866d47c67b1bf31c8cf855ef7437b72656a", "49b96715ab6878a79e78f07ce5680c5d6673051b4935bd897fea824b77dc208a" ], [ "c40747cc9d012cb1a13b8148309c6de7ec25d6945d657146b9d5994b8feb1111", "5ca560753be2a12fc6de6caf2cb489565db936156b9514e1bb5e83037e0fa2d4" ], [ "4e42c8ec82c99798ccf3a610be870e78338c7f713348bd34c8203ef4037f3502", "7571d74ee5e0fb92a7a8b33a07783341a5492144cc54bcc40a94473693606437" ], [ "3775ab7089bc6af823aba2e1af70b236d251cadb0c86743287522a1b3b0dedea", "be52d107bcfa09d8bcb9736a828cfa7fac8db17bf7a76a2c42ad961409018cf7" ], [ "cee31cbf7e34ec379d94fb814d3d775ad954595d1314ba8846959e3e82f74e26", "8fd64a14c06b589c26b947ae2bcf6bfa0149ef0be14ed4d80f448a01c43b1c6d" ], [ "b4f9eaea09b6917619f6ea6a4eb5464efddb58fd45b1ebefcdc1a01d08b47986", "39e5c9925b5a54b07433a4f18c61726f8bb131c012ca542eb24a8ac07200682a" ], [ "d4263dfc3d2df923a0179a48966d30ce84e2515afc3dccc1b77907792ebcc60e", "62dfaf07a0f78feb30e30d6295853ce189e127760ad6cf7fae164e122a208d54" ], [ "48457524820fa65a4f8d35eb6930857c0032acc0a4a2de422233eeda897612c4", "25a748ab367979d98733c38a1fa1c2e7dc6cc07db2d60a9ae7a76aaa49bd0f77" ], [ "dfeeef1881101f2cb11644f3a2afdfc2045e19919152923f367a1767c11cceda", "ecfb7056cf1de042f9420bab396793c0c390bde74b4bbdff16a83ae09a9a7517" ], [ "6d7ef6b17543f8373c573f44e1f389835d89bcbc6062ced36c82df83b8fae859", "cd450ec335438986dfefa10c57fea9bcc521a0959b2d80bbf74b190dca712d10" ], [ "e75605d59102a5a2684500d3b991f2e3f3c88b93225547035af25af66e04541f", "f5c54754a8f71ee540b9b48728473e314f729ac5308b06938360990e2bfad125" ], [ "eb98660f4c4dfaa06a2be453d5020bc99a0c2e60abe388457dd43fefb1ed620c", "6cb9a8876d9cb8520609af3add26cd20a0a7cd8a9411131ce85f44100099223e" ], [ "13e87b027d8514d35939f2e6892b19922154596941888336dc3563e3b8dba942", "fef5a3c68059a6dec5d624114bf1e91aac2b9da568d6abeb2570d55646b8adf1" ], [ "ee163026e9fd6fe017c38f06a5be6fc125424b371ce2708e7bf4491691e5764a", "1acb250f255dd61c43d94ccc670d0f58f49ae3fa15b96623e5430da0ad6c62b2" ], [ "b268f5ef9ad51e4d78de3a750c2dc89b1e626d43505867999932e5db33af3d80", "5f310d4b3c99b9ebb19f77d41c1dee018cf0d34fd4191614003e945a1216e423" ], [ "ff07f3118a9df035e9fad85eb6c7bfe42b02f01ca99ceea3bf7ffdba93c4750d", "438136d603e858a3a5c440c38eccbaddc1d2942114e2eddd4740d098ced1f0d8" ], [ "8d8b9855c7c052a34146fd20ffb658bea4b9f69e0d825ebec16e8c3ce2b526a1", "cdb559eedc2d79f926baf44fb84ea4d44bcf50fee51d7ceb30e2e7f463036758" ], [ "52db0b5384dfbf05bfa9d472d7ae26dfe4b851ceca91b1eba54263180da32b63", "c3b997d050ee5d423ebaf66a6db9f57b3180c902875679de924b69d84a7b375" ], [ "e62f9490d3d51da6395efd24e80919cc7d0f29c3f3fa48c6fff543becbd43352", "6d89ad7ba4876b0b22c2ca280c682862f342c8591f1daf5170e07bfd9ccafa7d" ], [ "7f30ea2476b399b4957509c88f77d0191afa2ff5cb7b14fd6d8e7d65aaab1193", "ca5ef7d4b231c94c3b15389a5f6311e9daff7bb67b103e9880ef4bff637acaec" ], [ "5098ff1e1d9f14fb46a210fada6c903fef0fb7b4a1dd1d9ac60a0361800b7a00", "9731141d81fc8f8084d37c6e7542006b3ee1b40d60dfe5362a5b132fd17ddc0" ], [ "32b78c7de9ee512a72895be6b9cbefa6e2f3c4ccce445c96b9f2c81e2778ad58", "ee1849f513df71e32efc3896ee28260c73bb80547ae2275ba497237794c8753c" ], [ "e2cb74fddc8e9fbcd076eef2a7c72b0ce37d50f08269dfc074b581550547a4f7", "d3aa2ed71c9dd2247a62df062736eb0baddea9e36122d2be8641abcb005cc4a4" ], [ "8438447566d4d7bedadc299496ab357426009a35f235cb141be0d99cd10ae3a8", "c4e1020916980a4da5d01ac5e6ad330734ef0d7906631c4f2390426b2edd791f" ], [ "4162d488b89402039b584c6fc6c308870587d9c46f660b878ab65c82c711d67e", "67163e903236289f776f22c25fb8a3afc1732f2b84b4e95dbda47ae5a0852649" ], [ "3fad3fa84caf0f34f0f89bfd2dcf54fc175d767aec3e50684f3ba4a4bf5f683d", "cd1bc7cb6cc407bb2f0ca647c718a730cf71872e7d0d2a53fa20efcdfe61826" ], [ "674f2600a3007a00568c1a7ce05d0816c1fb84bf1370798f1c69532faeb1a86b", "299d21f9413f33b3edf43b257004580b70db57da0b182259e09eecc69e0d38a5" ], [ "d32f4da54ade74abb81b815ad1fb3b263d82d6c692714bcff87d29bd5ee9f08f", "f9429e738b8e53b968e99016c059707782e14f4535359d582fc416910b3eea87" ], [ "30e4e670435385556e593657135845d36fbb6931f72b08cb1ed954f1e3ce3ff6", "462f9bce619898638499350113bbc9b10a878d35da70740dc695a559eb88db7b" ], [ "be2062003c51cc3004682904330e4dee7f3dcd10b01e580bf1971b04d4cad297", "62188bc49d61e5428573d48a74e1c655b1c61090905682a0d5558ed72dccb9bc" ], [ "93144423ace3451ed29e0fb9ac2af211cb6e84a601df5993c419859fff5df04a", "7c10dfb164c3425f5c71a3f9d7992038f1065224f72bb9d1d902a6d13037b47c" ], [ "b015f8044f5fcbdcf21ca26d6c34fb8197829205c7b7d2a7cb66418c157b112c", "ab8c1e086d04e813744a655b2df8d5f83b3cdc6faa3088c1d3aea1454e3a1d5f" ], [ "d5e9e1da649d97d89e4868117a465a3a4f8a18de57a140d36b3f2af341a21b52", "4cb04437f391ed73111a13cc1d4dd0db1693465c2240480d8955e8592f27447a" ], [ "d3ae41047dd7ca065dbf8ed77b992439983005cd72e16d6f996a5316d36966bb", "bd1aeb21ad22ebb22a10f0303417c6d964f8cdd7df0aca614b10dc14d125ac46" ], [ "463e2763d885f958fc66cdd22800f0a487197d0a82e377b49f80af87c897b065", "bfefacdb0e5d0fd7df3a311a94de062b26b80c61fbc97508b79992671ef7ca7f" ], [ "7985fdfd127c0567c6f53ec1bb63ec3158e597c40bfe747c83cddfc910641917", "603c12daf3d9862ef2b25fe1de289aed24ed291e0ec6708703a5bd567f32ed03" ], [ "74a1ad6b5f76e39db2dd249410eac7f99e74c59cb83d2d0ed5ff1543da7703e9", "cc6157ef18c9c63cd6193d83631bbea0093e0968942e8c33d5737fd790e0db08" ], [ "30682a50703375f602d416664ba19b7fc9bab42c72747463a71d0896b22f6da3", "553e04f6b018b4fa6c8f39e7f311d3176290d0e0f19ca73f17714d9977a22ff8" ], [ "9e2158f0d7c0d5f26c3791efefa79597654e7a2b2464f52b1ee6c1347769ef57", "712fcdd1b9053f09003a3481fa7762e9ffd7c8ef35a38509e2fbf2629008373" ], [ "176e26989a43c9cfeba4029c202538c28172e566e3c4fce7322857f3be327d66", "ed8cc9d04b29eb877d270b4878dc43c19aefd31f4eee09ee7b47834c1fa4b1c3" ], [ "75d46efea3771e6e68abb89a13ad747ecf1892393dfc4f1b7004788c50374da8", "9852390a99507679fd0b86fd2b39a868d7efc22151346e1a3ca4726586a6bed8" ], [ "809a20c67d64900ffb698c4c825f6d5f2310fb0451c869345b7319f645605721", "9e994980d9917e22b76b061927fa04143d096ccc54963e6a5ebfa5f3f8e286c1" ], [ "1b38903a43f7f114ed4500b4eac7083fdefece1cf29c63528d563446f972c180", "4036edc931a60ae889353f77fd53de4a2708b26b6f5da72ad3394119daf408f9" ] ]
            }
        };
    }, {} ],
    95: [ function(e, t, r) {
        "use strict";
        var i = r;
        var n = e("bn.js");
        var a = e("minimalistic-assert");
        var s = e("minimalistic-crypto-utils");
        i.assert = a;
        i.toArray = s.toArray;
        i.zero2 = s.zero2;
        i.toHex = s.toHex;
        i.encode = s.encode;
        function f(e, t) {
            var r = [];
            var i = 1 << t + 1;
            var n = e.clone();
            while (n.cmpn(1) >= 0) {
                var a;
                if (n.isOdd()) {
                    var s = n.andln(i - 1);
                    if (s > (i >> 1) - 1) a = (i >> 1) - s; else a = s;
                    n.isubn(a);
                } else {
                    a = 0;
                }
                r.push(a);
                var f = n.cmpn(0) !== 0 && n.andln(i - 1) === 0 ? t + 1 : 1;
                for (var o = 1; o < f; o++) r.push(0);
                n.iushrn(f);
            }
            return r;
        }
        i.getNAF = f;
        function o(e, t) {
            var r = [ [], [] ];
            e = e.clone();
            t = t.clone();
            var i = 0;
            var n = 0;
            while (e.cmpn(-i) > 0 || t.cmpn(-n) > 0) {
                var a = e.andln(3) + i & 3;
                var s = t.andln(3) + n & 3;
                if (a === 3) a = -1;
                if (s === 3) s = -1;
                var f;
                if ((a & 1) === 0) {
                    f = 0;
                } else {
                    var o = e.andln(7) + i & 7;
                    if ((o === 3 || o === 5) && s === 2) f = -a; else f = a;
                }
                r[0].push(f);
                var c;
                if ((s & 1) === 0) {
                    c = 0;
                } else {
                    var o = t.andln(7) + n & 7;
                    if ((o === 3 || o === 5) && a === 2) c = -s; else c = s;
                }
                r[1].push(c);
                if (2 * i === f + 1) i = 1 - i;
                if (2 * n === c + 1) n = 1 - n;
                e.iushrn(1);
                t.iushrn(1);
            }
            return r;
        }
        i.getJSF = o;
        function c(e, t, r) {
            var i = "_" + t;
            e.prototype[t] = function e() {
                return this[i] !== undefined ? this[i] : this[i] = r.call(this);
            };
        }
        i.cachedProperty = c;
        function h(e) {
            return typeof e === "string" ? i.toArray(e, "hex") : e;
        }
        i.parseBytes = h;
        function u(e) {
            return new n(e, "hex", "le");
        }
        i.intFromLE = u;
    }, {
        "bn.js": 32,
        "minimalistic-assert": 119,
        "minimalistic-crypto-utils": 120
    } ],
    96: [ function(e, t, r) {
        t.exports = {
            _args: [ [ {
                raw: "elliptic@^6.0.0",
                scope: null,
                escapedName: "elliptic",
                name: "elliptic",
                rawSpec: "^6.0.0",
                spec: ">=6.0.0 <7.0.0",
                type: "range"
            }, "/data/data/com.termux/files/usr/lib/node_modules/browserify/node_modules/browserify-sign" ] ],
            _from: "elliptic@>=6.0.0 <7.0.0",
            _id: "elliptic@6.4.0",
            _inCache: true,
            _location: "/browserify/elliptic",
            _nodeVersion: "7.0.0",
            _npmOperationalInternal: {
                host: "packages-18-east.internal.npmjs.com",
                tmp: "tmp/elliptic-6.4.0.tgz_1487798866428_0.30510620190761983"
            },
            _npmUser: {
                name: "indutny",
                email: "fedor@indutny.com"
            },
            _npmVersion: "3.10.8",
            _phantomChildren: {},
            _requested: {
                raw: "elliptic@^6.0.0",
                scope: null,
                escapedName: "elliptic",
                name: "elliptic",
                rawSpec: "^6.0.0",
                spec: ">=6.0.0 <7.0.0",
                type: "range"
            },
            _requiredBy: [ "/browserify/browserify-sign", "/browserify/create-ecdh" ],
            _resolved: "https://registry.npmjs.org/elliptic/-/elliptic-6.4.0.tgz",
            _shasum: "cac9af8762c85836187003c8dfe193e5e2eae5df",
            _shrinkwrap: null,
            _spec: "elliptic@^6.0.0",
            _where: "/data/data/com.termux/files/usr/lib/node_modules/browserify/node_modules/browserify-sign",
            author: {
                name: "Fedor Indutny",
                email: "fedor@indutny.com"
            },
            bugs: {
                url: "https://github.com/indutny/elliptic/issues"
            },
            dependencies: {
                "bn.js": "^4.4.0",
                brorand: "^1.0.1",
                "hash.js": "^1.0.0",
                "hmac-drbg": "^1.0.0",
                inherits: "^2.0.1",
                "minimalistic-assert": "^1.0.0",
                "minimalistic-crypto-utils": "^1.0.0"
            },
            description: "EC cryptography",
            devDependencies: {
                brfs: "^1.4.3",
                coveralls: "^2.11.3",
                grunt: "^0.4.5",
                "grunt-browserify": "^5.0.0",
                "grunt-cli": "^1.2.0",
                "grunt-contrib-connect": "^1.0.0",
                "grunt-contrib-copy": "^1.0.0",
                "grunt-contrib-uglify": "^1.0.1",
                "grunt-mocha-istanbul": "^3.0.1",
                "grunt-saucelabs": "^8.6.2",
                istanbul: "^0.4.2",
                jscs: "^2.9.0",
                jshint: "^2.6.0",
                mocha: "^2.1.0"
            },
            directories: {},
            dist: {
                shasum: "cac9af8762c85836187003c8dfe193e5e2eae5df",
                tarball: "https://registry.npmjs.org/elliptic/-/elliptic-6.4.0.tgz"
            },
            files: [ "lib" ],
            gitHead: "6b0d2b76caae91471649c8e21f0b1d3ba0f96090",
            homepage: "https://github.com/indutny/elliptic",
            keywords: [ "EC", "Elliptic", "curve", "Cryptography" ],
            license: "MIT",
            main: "lib/elliptic.js",
            maintainers: [ {
                name: "indutny",
                email: "fedor@indutny.com"
            } ],
            name: "elliptic",
            optionalDependencies: {},
            readme: "ERROR: No README data found!",
            repository: {
                type: "git",
                url: "git+ssh://git@github.com/indutny/elliptic.git"
            },
            scripts: {
                jscs: "jscs benchmarks/*.js lib/*.js lib/**/*.js lib/**/**/*.js test/index.js",
                jshint: "jscs benchmarks/*.js lib/*.js lib/**/*.js lib/**/**/*.js test/index.js",
                lint: "npm run jscs && npm run jshint",
                test: "npm run lint && npm run unit",
                unit: "istanbul test _mocha --reporter=spec test/index.js",
                version: "grunt dist && git add dist/"
            },
            version: "6.4.0"
        };
    }, {} ],
    97: [ function(e, t, r) {
        function i() {
            this._events = this._events || {};
            this._maxListeners = this._maxListeners || undefined;
        }
        t.exports = i;
        i.EventEmitter = i;
        i.prototype._events = undefined;
        i.prototype._maxListeners = undefined;
        i.defaultMaxListeners = 10;
        i.prototype.setMaxListeners = function(e) {
            if (!a(e) || e < 0 || isNaN(e)) throw TypeError("n must be a positive number");
            this._maxListeners = e;
            return this;
        };
        i.prototype.emit = function(e) {
            var t, r, i, a, o, c;
            if (!this._events) this._events = {};
            if (e === "error") {
                if (!this._events.error || s(this._events.error) && !this._events.error.length) {
                    t = arguments[1];
                    if (t instanceof Error) {
                        throw t;
                    } else {
                        var h = new Error('Uncaught, unspecified "error" event. (' + t + ")");
                        h.context = t;
                        throw h;
                    }
                }
            }
            r = this._events[e];
            if (f(r)) return false;
            if (n(r)) {
                switch (arguments.length) {
                  case 1:
                    r.call(this);
                    break;

                  case 2:
                    r.call(this, arguments[1]);
                    break;

                  case 3:
                    r.call(this, arguments[1], arguments[2]);
                    break;

                  default:
                    a = Array.prototype.slice.call(arguments, 1);
                    r.apply(this, a);
                }
            } else if (s(r)) {
                a = Array.prototype.slice.call(arguments, 1);
                c = r.slice();
                i = c.length;
                for (o = 0; o < i; o++) c[o].apply(this, a);
            }
            return true;
        };
        i.prototype.addListener = function(e, t) {
            var r;
            if (!n(t)) throw TypeError("listener must be a function");
            if (!this._events) this._events = {};
            if (this._events.newListener) this.emit("newListener", e, n(t.listener) ? t.listener : t);
            if (!this._events[e]) this._events[e] = t; else if (s(this._events[e])) this._events[e].push(t); else this._events[e] = [ this._events[e], t ];
            if (s(this._events[e]) && !this._events[e].warned) {
                if (!f(this._maxListeners)) {
                    r = this._maxListeners;
                } else {
                    r = i.defaultMaxListeners;
                }
                if (r && r > 0 && this._events[e].length > r) {
                    this._events[e].warned = true;
                    console.error("(node) warning: possible EventEmitter memory " + "leak detected. %d listeners added. " + "Use emitter.setMaxListeners() to increase limit.", this._events[e].length);
                    if (typeof console.trace === "function") {
                        console.trace();
                    }
                }
            }
            return this;
        };
        i.prototype.on = i.prototype.addListener;
        i.prototype.once = function(e, t) {
            if (!n(t)) throw TypeError("listener must be a function");
            var r = false;
            function i() {
                this.removeListener(e, i);
                if (!r) {
                    r = true;
                    t.apply(this, arguments);
                }
            }
            i.listener = t;
            this.on(e, i);
            return this;
        };
        i.prototype.removeListener = function(e, t) {
            var r, i, a, f;
            if (!n(t)) throw TypeError("listener must be a function");
            if (!this._events || !this._events[e]) return this;
            r = this._events[e];
            a = r.length;
            i = -1;
            if (r === t || n(r.listener) && r.listener === t) {
                delete this._events[e];
                if (this._events.removeListener) this.emit("removeListener", e, t);
            } else if (s(r)) {
                for (f = a; f-- > 0; ) {
                    if (r[f] === t || r[f].listener && r[f].listener === t) {
                        i = f;
                        break;
                    }
                }
                if (i < 0) return this;
                if (r.length === 1) {
                    r.length = 0;
                    delete this._events[e];
                } else {
                    r.splice(i, 1);
                }
                if (this._events.removeListener) this.emit("removeListener", e, t);
            }
            return this;
        };
        i.prototype.removeAllListeners = function(e) {
            var t, r;
            if (!this._events) return this;
            if (!this._events.removeListener) {
                if (arguments.length === 0) this._events = {}; else if (this._events[e]) delete this._events[e];
                return this;
            }
            if (arguments.length === 0) {
                for (t in this._events) {
                    if (t === "removeListener") continue;
                    this.removeAllListeners(t);
                }
                this.removeAllListeners("removeListener");
                this._events = {};
                return this;
            }
            r = this._events[e];
            if (n(r)) {
                this.removeListener(e, r);
            } else if (r) {
                while (r.length) this.removeListener(e, r[r.length - 1]);
            }
            delete this._events[e];
            return this;
        };
        i.prototype.listeners = function(e) {
            var t;
            if (!this._events || !this._events[e]) t = []; else if (n(this._events[e])) t = [ this._events[e] ]; else t = this._events[e].slice();
            return t;
        };
        i.prototype.listenerCount = function(e) {
            if (this._events) {
                var t = this._events[e];
                if (n(t)) return 1; else if (t) return t.length;
            }
            return 0;
        };
        i.listenerCount = function(e, t) {
            return e.listenerCount(t);
        };
        function n(e) {
            return typeof e === "function";
        }
        function a(e) {
            return typeof e === "number";
        }
        function s(e) {
            return typeof e === "object" && e !== null;
        }
        function f(e) {
            return e === void 0;
        }
    }, {} ],
    98: [ function(e, t, r) {
        (function(r) {
            var i = e("create-hash/md5");
            t.exports = n;
            function n(e, t, n, a) {
                if (!r.isBuffer(e)) {
                    e = new r(e, "binary");
                }
                if (t && !r.isBuffer(t)) {
                    t = new r(t, "binary");
                }
                n = n / 8;
                a = a || 0;
                var s = 0;
                var f = 0;
                var o = new r(n);
                var c = new r(a);
                var h = 0;
                var u;
                var d;
                var l = [];
                while (true) {
                    if (h++ > 0) {
                        l.push(u);
                    }
                    l.push(e);
                    if (t) {
                        l.push(t);
                    }
                    u = i(r.concat(l));
                    l = [];
                    d = 0;
                    if (n > 0) {
                        while (true) {
                            if (n === 0) {
                                break;
                            }
                            if (d === u.length) {
                                break;
                            }
                            o[s++] = u[d];
                            n--;
                            d++;
                        }
                    }
                    if (a > 0 && d !== u.length) {
                        while (true) {
                            if (a === 0) {
                                break;
                            }
                            if (d === u.length) {
                                break;
                            }
                            c[f++] = u[d];
                            a--;
                            d++;
                        }
                    }
                    if (n === 0 && a === 0) {
                        break;
                    }
                }
                for (d = 0; d < u.length; d++) {
                    u[d] = 0;
                }
                return {
                    key: o,
                    iv: c
                };
            }
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61,
        "create-hash/md5": 67
    } ],
    99: [ function(e, t, r) {
        (function(r) {
            "use strict";
            var i = e("stream").Transform;
            var n = e("inherits");
            function a(e) {
                i.call(this);
                this._block = new r(e);
                this._blockSize = e;
                this._blockOffset = 0;
                this._length = [ 0, 0, 0, 0 ];
                this._finalized = false;
            }
            n(a, i);
            a.prototype._transform = function(e, t, i) {
                var n = null;
                try {
                    if (t !== "buffer") e = new r(e, t);
                    this.update(e);
                } catch (e) {
                    n = e;
                }
                i(n);
            };
            a.prototype._flush = function(e) {
                var t = null;
                try {
                    this.push(this._digest());
                } catch (e) {
                    t = e;
                }
                e(t);
            };
            a.prototype.update = function(e, t) {
                if (!r.isBuffer(e) && typeof e !== "string") throw new TypeError("Data must be a string or a buffer");
                if (this._finalized) throw new Error("Digest already called");
                if (!r.isBuffer(e)) e = new r(e, t || "binary");
                var i = this._block;
                var n = 0;
                while (this._blockOffset + e.length - n >= this._blockSize) {
                    for (var a = this._blockOffset; a < this._blockSize; ) i[a++] = e[n++];
                    this._update();
                    this._blockOffset = 0;
                }
                while (n < e.length) i[this._blockOffset++] = e[n++];
                for (var s = 0, f = e.length * 8; f > 0; ++s) {
                    this._length[s] += f;
                    f = this._length[s] / 4294967296 | 0;
                    if (f > 0) this._length[s] -= 4294967296 * f;
                }
                return this;
            };
            a.prototype._update = function(e) {
                throw new Error("_update is not implemented");
            };
            a.prototype.digest = function(e) {
                if (this._finalized) throw new Error("Digest already called");
                this._finalized = true;
                var t = this._digest();
                if (e !== undefined) t = t.toString(e);
                return t;
            };
            a.prototype._digest = function() {
                throw new Error("_digest is not implemented");
            };
            t.exports = a;
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61,
        inherits: 115,
        stream: 163
    } ],
    100: [ function(e, t, r) {
        var i = r;
        i.utils = e("./hash/utils");
        i.common = e("./hash/common");
        i.sha = e("./hash/sha");
        i.ripemd = e("./hash/ripemd");
        i.hmac = e("./hash/hmac");
        i.sha1 = i.sha.sha1;
        i.sha256 = i.sha.sha256;
        i.sha224 = i.sha.sha224;
        i.sha384 = i.sha.sha384;
        i.sha512 = i.sha.sha512;
        i.ripemd160 = i.ripemd.ripemd160;
    }, {
        "./hash/common": 101,
        "./hash/hmac": 102,
        "./hash/ripemd": 103,
        "./hash/sha": 104,
        "./hash/utils": 111
    } ],
    101: [ function(e, t, r) {
        "use strict";
        var i = e("./utils");
        var n = e("minimalistic-assert");
        function a() {
            this.pending = null;
            this.pendingTotal = 0;
            this.blockSize = this.constructor.blockSize;
            this.outSize = this.constructor.outSize;
            this.hmacStrength = this.constructor.hmacStrength;
            this.padLength = this.constructor.padLength / 8;
            this.endian = "big";
            this._delta8 = this.blockSize / 8;
            this._delta32 = this.blockSize / 32;
        }
        r.BlockHash = a;
        a.prototype.update = function e(t, r) {
            t = i.toArray(t, r);
            if (!this.pending) this.pending = t; else this.pending = this.pending.concat(t);
            this.pendingTotal += t.length;
            if (this.pending.length >= this._delta8) {
                t = this.pending;
                var n = t.length % this._delta8;
                this.pending = t.slice(t.length - n, t.length);
                if (this.pending.length === 0) this.pending = null;
                t = i.join32(t, 0, t.length - n, this.endian);
                for (var a = 0; a < t.length; a += this._delta32) this._update(t, a, a + this._delta32);
            }
            return this;
        };
        a.prototype.digest = function e(t) {
            this.update(this._pad());
            n(this.pending === null);
            return this._digest(t);
        };
        a.prototype._pad = function e() {
            var t = this.pendingTotal;
            var r = this._delta8;
            var i = r - (t + this.padLength) % r;
            var n = new Array(i + this.padLength);
            n[0] = 128;
            for (var a = 1; a < i; a++) n[a] = 0;
            t <<= 3;
            if (this.endian === "big") {
                for (var s = 8; s < this.padLength; s++) n[a++] = 0;
                n[a++] = 0;
                n[a++] = 0;
                n[a++] = 0;
                n[a++] = 0;
                n[a++] = t >>> 24 & 255;
                n[a++] = t >>> 16 & 255;
                n[a++] = t >>> 8 & 255;
                n[a++] = t & 255;
            } else {
                n[a++] = t & 255;
                n[a++] = t >>> 8 & 255;
                n[a++] = t >>> 16 & 255;
                n[a++] = t >>> 24 & 255;
                n[a++] = 0;
                n[a++] = 0;
                n[a++] = 0;
                n[a++] = 0;
                for (s = 8; s < this.padLength; s++) n[a++] = 0;
            }
            return n;
        };
    }, {
        "./utils": 111,
        "minimalistic-assert": 119
    } ],
    102: [ function(e, t, r) {
        "use strict";
        var i = e("./utils");
        var n = e("minimalistic-assert");
        function a(e, t, r) {
            if (!(this instanceof a)) return new a(e, t, r);
            this.Hash = e;
            this.blockSize = e.blockSize / 8;
            this.outSize = e.outSize / 8;
            this.inner = null;
            this.outer = null;
            this._init(i.toArray(t, r));
        }
        t.exports = a;
        a.prototype._init = function e(t) {
            if (t.length > this.blockSize) t = new this.Hash().update(t).digest();
            n(t.length <= this.blockSize);
            for (var r = t.length; r < this.blockSize; r++) t.push(0);
            for (r = 0; r < t.length; r++) t[r] ^= 54;
            this.inner = new this.Hash().update(t);
            for (r = 0; r < t.length; r++) t[r] ^= 106;
            this.outer = new this.Hash().update(t);
        };
        a.prototype.update = function e(t, r) {
            this.inner.update(t, r);
            return this;
        };
        a.prototype.digest = function e(t) {
            this.outer.update(this.inner.digest());
            return this.outer.digest(t);
        };
    }, {
        "./utils": 111,
        "minimalistic-assert": 119
    } ],
    103: [ function(e, t, r) {
        "use strict";
        var i = e("./utils");
        var n = e("./common");
        var a = i.rotl32;
        var s = i.sum32;
        var f = i.sum32_3;
        var o = i.sum32_4;
        var c = n.BlockHash;
        function h() {
            if (!(this instanceof h)) return new h();
            c.call(this);
            this.h = [ 1732584193, 4023233417, 2562383102, 271733878, 3285377520 ];
            this.endian = "little";
        }
        i.inherits(h, c);
        r.ripemd160 = h;
        h.blockSize = 512;
        h.outSize = 160;
        h.hmacStrength = 192;
        h.padLength = 64;
        h.prototype._update = function e(t, r) {
            var i = this.h[0];
            var n = this.h[1];
            var c = this.h[2];
            var h = this.h[3];
            var y = this.h[4];
            var g = i;
            var w = n;
            var _ = c;
            var S = h;
            var M = y;
            for (var k = 0; k < 80; k++) {
                var E = s(a(o(i, u(k, n, c, h), t[p[k] + r], d(k)), v[k]), y);
                i = y;
                y = h;
                h = a(c, 10);
                c = n;
                n = E;
                E = s(a(o(g, u(79 - k, w, _, S), t[b[k] + r], l(k)), m[k]), M);
                g = M;
                M = S;
                S = a(_, 10);
                _ = w;
                w = E;
            }
            E = f(this.h[1], c, S);
            this.h[1] = f(this.h[2], h, M);
            this.h[2] = f(this.h[3], y, g);
            this.h[3] = f(this.h[4], i, w);
            this.h[4] = f(this.h[0], n, _);
            this.h[0] = E;
        };
        h.prototype._digest = function e(t) {
            if (t === "hex") return i.toHex32(this.h, "little"); else return i.split32(this.h, "little");
        };
        function u(e, t, r, i) {
            if (e <= 15) return t ^ r ^ i; else if (e <= 31) return t & r | ~t & i; else if (e <= 47) return (t | ~r) ^ i; else if (e <= 63) return t & i | r & ~i; else return t ^ (r | ~i);
        }
        function d(e) {
            if (e <= 15) return 0; else if (e <= 31) return 1518500249; else if (e <= 47) return 1859775393; else if (e <= 63) return 2400959708; else return 2840853838;
        }
        function l(e) {
            if (e <= 15) return 1352829926; else if (e <= 31) return 1548603684; else if (e <= 47) return 1836072691; else if (e <= 63) return 2053994217; else return 0;
        }
        var p = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 7, 4, 13, 1, 10, 6, 15, 3, 12, 0, 9, 5, 2, 14, 11, 8, 3, 10, 14, 4, 9, 15, 8, 1, 2, 7, 0, 6, 13, 11, 5, 12, 1, 9, 11, 10, 0, 8, 12, 4, 13, 3, 7, 15, 14, 5, 6, 2, 4, 0, 5, 9, 7, 12, 2, 10, 14, 1, 3, 8, 11, 6, 15, 13 ];
        var b = [ 5, 14, 7, 0, 9, 2, 11, 4, 13, 6, 15, 8, 1, 10, 3, 12, 6, 11, 3, 7, 0, 13, 5, 10, 14, 15, 8, 12, 4, 9, 1, 2, 15, 5, 1, 3, 7, 14, 6, 9, 11, 8, 12, 2, 10, 0, 4, 13, 8, 6, 4, 1, 3, 11, 15, 0, 5, 12, 2, 13, 9, 7, 10, 14, 12, 15, 10, 4, 1, 5, 8, 7, 6, 2, 13, 14, 0, 3, 9, 11 ];
        var v = [ 11, 14, 15, 12, 5, 8, 7, 9, 11, 13, 14, 15, 6, 7, 9, 8, 7, 6, 8, 13, 11, 9, 7, 15, 7, 12, 15, 9, 11, 7, 13, 12, 11, 13, 6, 7, 14, 9, 13, 15, 14, 8, 13, 6, 5, 12, 7, 5, 11, 12, 14, 15, 14, 15, 9, 8, 9, 14, 5, 6, 8, 6, 5, 12, 9, 15, 5, 11, 6, 8, 13, 12, 5, 12, 13, 14, 11, 8, 5, 6 ];
        var m = [ 8, 9, 9, 11, 13, 15, 15, 5, 7, 7, 8, 11, 14, 14, 12, 6, 9, 13, 15, 7, 12, 8, 9, 11, 7, 7, 12, 7, 6, 15, 13, 11, 9, 7, 15, 11, 8, 6, 6, 14, 12, 13, 5, 14, 13, 13, 7, 5, 15, 5, 8, 11, 14, 14, 6, 14, 6, 9, 12, 9, 12, 5, 15, 8, 8, 5, 12, 9, 12, 5, 14, 6, 8, 13, 6, 5, 15, 13, 11, 11 ];
    }, {
        "./common": 101,
        "./utils": 111
    } ],
    104: [ function(e, t, r) {
        "use strict";
        r.sha1 = e("./sha/1");
        r.sha224 = e("./sha/224");
        r.sha256 = e("./sha/256");
        r.sha384 = e("./sha/384");
        r.sha512 = e("./sha/512");
    }, {
        "./sha/1": 105,
        "./sha/224": 106,
        "./sha/256": 107,
        "./sha/384": 108,
        "./sha/512": 109
    } ],
    105: [ function(e, t, r) {
        "use strict";
        var i = e("../utils");
        var n = e("../common");
        var a = e("./common");
        var s = i.rotl32;
        var f = i.sum32;
        var o = i.sum32_5;
        var c = a.ft_1;
        var h = n.BlockHash;
        var u = [ 1518500249, 1859775393, 2400959708, 3395469782 ];
        function d() {
            if (!(this instanceof d)) return new d();
            h.call(this);
            this.h = [ 1732584193, 4023233417, 2562383102, 271733878, 3285377520 ];
            this.W = new Array(80);
        }
        i.inherits(d, h);
        t.exports = d;
        d.blockSize = 512;
        d.outSize = 160;
        d.hmacStrength = 80;
        d.padLength = 64;
        d.prototype._update = function e(t, r) {
            var i = this.W;
            for (var n = 0; n < 16; n++) i[n] = t[r + n];
            for (;n < i.length; n++) i[n] = s(i[n - 3] ^ i[n - 8] ^ i[n - 14] ^ i[n - 16], 1);
            var a = this.h[0];
            var h = this.h[1];
            var d = this.h[2];
            var l = this.h[3];
            var p = this.h[4];
            for (n = 0; n < i.length; n++) {
                var b = ~~(n / 20);
                var v = o(s(a, 5), c(b, h, d, l), p, i[n], u[b]);
                p = l;
                l = d;
                d = s(h, 30);
                h = a;
                a = v;
            }
            this.h[0] = f(this.h[0], a);
            this.h[1] = f(this.h[1], h);
            this.h[2] = f(this.h[2], d);
            this.h[3] = f(this.h[3], l);
            this.h[4] = f(this.h[4], p);
        };
        d.prototype._digest = function e(t) {
            if (t === "hex") return i.toHex32(this.h, "big"); else return i.split32(this.h, "big");
        };
    }, {
        "../common": 101,
        "../utils": 111,
        "./common": 110
    } ],
    106: [ function(e, t, r) {
        "use strict";
        var i = e("../utils");
        var n = e("./256");
        function a() {
            if (!(this instanceof a)) return new a();
            n.call(this);
            this.h = [ 3238371032, 914150663, 812702999, 4144912697, 4290775857, 1750603025, 1694076839, 3204075428 ];
        }
        i.inherits(a, n);
        t.exports = a;
        a.blockSize = 512;
        a.outSize = 224;
        a.hmacStrength = 192;
        a.padLength = 64;
        a.prototype._digest = function e(t) {
            if (t === "hex") return i.toHex32(this.h.slice(0, 7), "big"); else return i.split32(this.h.slice(0, 7), "big");
        };
    }, {
        "../utils": 111,
        "./256": 107
    } ],
    107: [ function(e, t, r) {
        "use strict";
        var i = e("../utils");
        var n = e("../common");
        var a = e("./common");
        var s = e("minimalistic-assert");
        var f = i.sum32;
        var o = i.sum32_4;
        var c = i.sum32_5;
        var h = a.ch32;
        var u = a.maj32;
        var d = a.s0_256;
        var l = a.s1_256;
        var p = a.g0_256;
        var b = a.g1_256;
        var v = n.BlockHash;
        var m = [ 1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298 ];
        function y() {
            if (!(this instanceof y)) return new y();
            v.call(this);
            this.h = [ 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225 ];
            this.k = m;
            this.W = new Array(64);
        }
        i.inherits(y, v);
        t.exports = y;
        y.blockSize = 512;
        y.outSize = 256;
        y.hmacStrength = 192;
        y.padLength = 64;
        y.prototype._update = function e(t, r) {
            var i = this.W;
            for (var n = 0; n < 16; n++) i[n] = t[r + n];
            for (;n < i.length; n++) i[n] = o(b(i[n - 2]), i[n - 7], p(i[n - 15]), i[n - 16]);
            var a = this.h[0];
            var v = this.h[1];
            var m = this.h[2];
            var y = this.h[3];
            var g = this.h[4];
            var w = this.h[5];
            var _ = this.h[6];
            var S = this.h[7];
            s(this.k.length === i.length);
            for (n = 0; n < i.length; n++) {
                var M = c(S, l(g), h(g, w, _), this.k[n], i[n]);
                var k = f(d(a), u(a, v, m));
                S = _;
                _ = w;
                w = g;
                g = f(y, M);
                y = m;
                m = v;
                v = a;
                a = f(M, k);
            }
            this.h[0] = f(this.h[0], a);
            this.h[1] = f(this.h[1], v);
            this.h[2] = f(this.h[2], m);
            this.h[3] = f(this.h[3], y);
            this.h[4] = f(this.h[4], g);
            this.h[5] = f(this.h[5], w);
            this.h[6] = f(this.h[6], _);
            this.h[7] = f(this.h[7], S);
        };
        y.prototype._digest = function e(t) {
            if (t === "hex") return i.toHex32(this.h, "big"); else return i.split32(this.h, "big");
        };
    }, {
        "../common": 101,
        "../utils": 111,
        "./common": 110,
        "minimalistic-assert": 119
    } ],
    108: [ function(e, t, r) {
        "use strict";
        var i = e("../utils");
        var n = e("./512");
        function a() {
            if (!(this instanceof a)) return new a();
            n.call(this);
            this.h = [ 3418070365, 3238371032, 1654270250, 914150663, 2438529370, 812702999, 355462360, 4144912697, 1731405415, 4290775857, 2394180231, 1750603025, 3675008525, 1694076839, 1203062813, 3204075428 ];
        }
        i.inherits(a, n);
        t.exports = a;
        a.blockSize = 1024;
        a.outSize = 384;
        a.hmacStrength = 192;
        a.padLength = 128;
        a.prototype._digest = function e(t) {
            if (t === "hex") return i.toHex32(this.h.slice(0, 12), "big"); else return i.split32(this.h.slice(0, 12), "big");
        };
    }, {
        "../utils": 111,
        "./512": 109
    } ],
    109: [ function(e, t, r) {
        "use strict";
        var i = e("../utils");
        var n = e("../common");
        var a = e("minimalistic-assert");
        var s = i.rotr64_hi;
        var f = i.rotr64_lo;
        var o = i.shr64_hi;
        var c = i.shr64_lo;
        var h = i.sum64;
        var u = i.sum64_hi;
        var d = i.sum64_lo;
        var l = i.sum64_4_hi;
        var p = i.sum64_4_lo;
        var b = i.sum64_5_hi;
        var v = i.sum64_5_lo;
        var m = n.BlockHash;
        var y = [ 1116352408, 3609767458, 1899447441, 602891725, 3049323471, 3964484399, 3921009573, 2173295548, 961987163, 4081628472, 1508970993, 3053834265, 2453635748, 2937671579, 2870763221, 3664609560, 3624381080, 2734883394, 310598401, 1164996542, 607225278, 1323610764, 1426881987, 3590304994, 1925078388, 4068182383, 2162078206, 991336113, 2614888103, 633803317, 3248222580, 3479774868, 3835390401, 2666613458, 4022224774, 944711139, 264347078, 2341262773, 604807628, 2007800933, 770255983, 1495990901, 1249150122, 1856431235, 1555081692, 3175218132, 1996064986, 2198950837, 2554220882, 3999719339, 2821834349, 766784016, 2952996808, 2566594879, 3210313671, 3203337956, 3336571891, 1034457026, 3584528711, 2466948901, 113926993, 3758326383, 338241895, 168717936, 666307205, 1188179964, 773529912, 1546045734, 1294757372, 1522805485, 1396182291, 2643833823, 1695183700, 2343527390, 1986661051, 1014477480, 2177026350, 1206759142, 2456956037, 344077627, 2730485921, 1290863460, 2820302411, 3158454273, 3259730800, 3505952657, 3345764771, 106217008, 3516065817, 3606008344, 3600352804, 1432725776, 4094571909, 1467031594, 275423344, 851169720, 430227734, 3100823752, 506948616, 1363258195, 659060556, 3750685593, 883997877, 3785050280, 958139571, 3318307427, 1322822218, 3812723403, 1537002063, 2003034995, 1747873779, 3602036899, 1955562222, 1575990012, 2024104815, 1125592928, 2227730452, 2716904306, 2361852424, 442776044, 2428436474, 593698344, 2756734187, 3733110249, 3204031479, 2999351573, 3329325298, 3815920427, 3391569614, 3928383900, 3515267271, 566280711, 3940187606, 3454069534, 4118630271, 4000239992, 116418474, 1914138554, 174292421, 2731055270, 289380356, 3203993006, 460393269, 320620315, 685471733, 587496836, 852142971, 1086792851, 1017036298, 365543100, 1126000580, 2618297676, 1288033470, 3409855158, 1501505948, 4234509866, 1607167915, 987167468, 1816402316, 1246189591 ];
        function g() {
            if (!(this instanceof g)) return new g();
            m.call(this);
            this.h = [ 1779033703, 4089235720, 3144134277, 2227873595, 1013904242, 4271175723, 2773480762, 1595750129, 1359893119, 2917565137, 2600822924, 725511199, 528734635, 4215389547, 1541459225, 327033209 ];
            this.k = y;
            this.W = new Array(160);
        }
        i.inherits(g, m);
        t.exports = g;
        g.blockSize = 1024;
        g.outSize = 512;
        g.hmacStrength = 192;
        g.padLength = 128;
        g.prototype._prepareBlock = function e(t, r) {
            var i = this.W;
            for (var n = 0; n < 32; n++) i[n] = t[r + n];
            for (;n < i.length; n += 2) {
                var a = j(i[n - 4], i[n - 3]);
                var s = C(i[n - 4], i[n - 3]);
                var f = i[n - 14];
                var o = i[n - 13];
                var c = B(i[n - 30], i[n - 29]);
                var h = I(i[n - 30], i[n - 29]);
                var u = i[n - 32];
                var d = i[n - 31];
                i[n] = l(a, s, f, o, c, h, u, d);
                i[n + 1] = p(a, s, f, o, c, h, u, d);
            }
        };
        g.prototype._update = function e(t, r) {
            this._prepareBlock(t, r);
            var i = this.W;
            var n = this.h[0];
            var s = this.h[1];
            var f = this.h[2];
            var o = this.h[3];
            var c = this.h[4];
            var l = this.h[5];
            var p = this.h[6];
            var m = this.h[7];
            var y = this.h[8];
            var g = this.h[9];
            var B = this.h[10];
            var I = this.h[11];
            var j = this.h[12];
            var C = this.h[13];
            var R = this.h[14];
            var P = this.h[15];
            a(this.k.length === i.length);
            for (var T = 0; T < i.length; T += 2) {
                var D = R;
                var L = P;
                var q = x(y, g);
                var N = A(y, g);
                var O = w(y, g, B, I, j, C);
                var z = _(y, g, B, I, j, C);
                var U = this.k[T];
                var K = this.k[T + 1];
                var F = i[T];
                var H = i[T + 1];
                var W = b(D, L, q, N, O, z, U, K, F, H);
                var V = v(D, L, q, N, O, z, U, K, F, H);
                D = k(n, s);
                L = E(n, s);
                q = S(n, s, f, o, c, l);
                N = M(n, s, f, o, c, l);
                var X = u(D, L, q, N);
                var Z = d(D, L, q, N);
                R = j;
                P = C;
                j = B;
                C = I;
                B = y;
                I = g;
                y = u(p, m, W, V);
                g = d(m, m, W, V);
                p = c;
                m = l;
                c = f;
                l = o;
                f = n;
                o = s;
                n = u(W, V, X, Z);
                s = d(W, V, X, Z);
            }
            h(this.h, 0, n, s);
            h(this.h, 2, f, o);
            h(this.h, 4, c, l);
            h(this.h, 6, p, m);
            h(this.h, 8, y, g);
            h(this.h, 10, B, I);
            h(this.h, 12, j, C);
            h(this.h, 14, R, P);
        };
        g.prototype._digest = function e(t) {
            if (t === "hex") return i.toHex32(this.h, "big"); else return i.split32(this.h, "big");
        };
        function w(e, t, r, i, n) {
            var a = e & r ^ ~e & n;
            if (a < 0) a += 4294967296;
            return a;
        }
        function _(e, t, r, i, n, a) {
            var s = t & i ^ ~t & a;
            if (s < 0) s += 4294967296;
            return s;
        }
        function S(e, t, r, i, n) {
            var a = e & r ^ e & n ^ r & n;
            if (a < 0) a += 4294967296;
            return a;
        }
        function M(e, t, r, i, n, a) {
            var s = t & i ^ t & a ^ i & a;
            if (s < 0) s += 4294967296;
            return s;
        }
        function k(e, t) {
            var r = s(e, t, 28);
            var i = s(t, e, 2);
            var n = s(t, e, 7);
            var a = r ^ i ^ n;
            if (a < 0) a += 4294967296;
            return a;
        }
        function E(e, t) {
            var r = f(e, t, 28);
            var i = f(t, e, 2);
            var n = f(t, e, 7);
            var a = r ^ i ^ n;
            if (a < 0) a += 4294967296;
            return a;
        }
        function x(e, t) {
            var r = s(e, t, 14);
            var i = s(e, t, 18);
            var n = s(t, e, 9);
            var a = r ^ i ^ n;
            if (a < 0) a += 4294967296;
            return a;
        }
        function A(e, t) {
            var r = f(e, t, 14);
            var i = f(e, t, 18);
            var n = f(t, e, 9);
            var a = r ^ i ^ n;
            if (a < 0) a += 4294967296;
            return a;
        }
        function B(e, t) {
            var r = s(e, t, 1);
            var i = s(e, t, 8);
            var n = o(e, t, 7);
            var a = r ^ i ^ n;
            if (a < 0) a += 4294967296;
            return a;
        }
        function I(e, t) {
            var r = f(e, t, 1);
            var i = f(e, t, 8);
            var n = c(e, t, 7);
            var a = r ^ i ^ n;
            if (a < 0) a += 4294967296;
            return a;
        }
        function j(e, t) {
            var r = s(e, t, 19);
            var i = s(t, e, 29);
            var n = o(e, t, 6);
            var a = r ^ i ^ n;
            if (a < 0) a += 4294967296;
            return a;
        }
        function C(e, t) {
            var r = f(e, t, 19);
            var i = f(t, e, 29);
            var n = c(e, t, 6);
            var a = r ^ i ^ n;
            if (a < 0) a += 4294967296;
            return a;
        }
    }, {
        "../common": 101,
        "../utils": 111,
        "minimalistic-assert": 119
    } ],
    110: [ function(e, t, r) {
        "use strict";
        var i = e("../utils");
        var n = i.rotr32;
        function a(e, t, r, i) {
            if (e === 0) return s(t, r, i);
            if (e === 1 || e === 3) return o(t, r, i);
            if (e === 2) return f(t, r, i);
        }
        r.ft_1 = a;
        function s(e, t, r) {
            return e & t ^ ~e & r;
        }
        r.ch32 = s;
        function f(e, t, r) {
            return e & t ^ e & r ^ t & r;
        }
        r.maj32 = f;
        function o(e, t, r) {
            return e ^ t ^ r;
        }
        r.p32 = o;
        function c(e) {
            return n(e, 2) ^ n(e, 13) ^ n(e, 22);
        }
        r.s0_256 = c;
        function h(e) {
            return n(e, 6) ^ n(e, 11) ^ n(e, 25);
        }
        r.s1_256 = h;
        function u(e) {
            return n(e, 7) ^ n(e, 18) ^ e >>> 3;
        }
        r.g0_256 = u;
        function d(e) {
            return n(e, 17) ^ n(e, 19) ^ e >>> 10;
        }
        r.g1_256 = d;
    }, {
        "../utils": 111
    } ],
    111: [ function(e, t, r) {
        "use strict";
        var i = e("minimalistic-assert");
        var n = e("inherits");
        r.inherits = n;
        function a(e, t) {
            if (Array.isArray(e)) return e.slice();
            if (!e) return [];
            var r = [];
            if (typeof e === "string") {
                if (!t) {
                    for (var i = 0; i < e.length; i++) {
                        var n = e.charCodeAt(i);
                        var a = n >> 8;
                        var s = n & 255;
                        if (a) r.push(a, s); else r.push(s);
                    }
                } else if (t === "hex") {
                    e = e.replace(/[^a-z0-9]+/gi, "");
                    if (e.length % 2 !== 0) e = "0" + e;
                    for (i = 0; i < e.length; i += 2) r.push(parseInt(e[i] + e[i + 1], 16));
                }
            } else {
                for (i = 0; i < e.length; i++) r[i] = e[i] | 0;
            }
            return r;
        }
        r.toArray = a;
        function s(e) {
            var t = "";
            for (var r = 0; r < e.length; r++) t += c(e[r].toString(16));
            return t;
        }
        r.toHex = s;
        function f(e) {
            var t = e >>> 24 | e >>> 8 & 65280 | e << 8 & 16711680 | (e & 255) << 24;
            return t >>> 0;
        }
        r.htonl = f;
        function o(e, t) {
            var r = "";
            for (var i = 0; i < e.length; i++) {
                var n = e[i];
                if (t === "little") n = f(n);
                r += h(n.toString(16));
            }
            return r;
        }
        r.toHex32 = o;
        function c(e) {
            if (e.length === 1) return "0" + e; else return e;
        }
        r.zero2 = c;
        function h(e) {
            if (e.length === 7) return "0" + e; else if (e.length === 6) return "00" + e; else if (e.length === 5) return "000" + e; else if (e.length === 4) return "0000" + e; else if (e.length === 3) return "00000" + e; else if (e.length === 2) return "000000" + e; else if (e.length === 1) return "0000000" + e; else return e;
        }
        r.zero8 = h;
        function u(e, t, r, n) {
            var a = r - t;
            i(a % 4 === 0);
            var s = new Array(a / 4);
            for (var f = 0, o = t; f < s.length; f++, o += 4) {
                var c;
                if (n === "big") c = e[o] << 24 | e[o + 1] << 16 | e[o + 2] << 8 | e[o + 3]; else c = e[o + 3] << 24 | e[o + 2] << 16 | e[o + 1] << 8 | e[o];
                s[f] = c >>> 0;
            }
            return s;
        }
        r.join32 = u;
        function d(e, t) {
            var r = new Array(e.length * 4);
            for (var i = 0, n = 0; i < e.length; i++, n += 4) {
                var a = e[i];
                if (t === "big") {
                    r[n] = a >>> 24;
                    r[n + 1] = a >>> 16 & 255;
                    r[n + 2] = a >>> 8 & 255;
                    r[n + 3] = a & 255;
                } else {
                    r[n + 3] = a >>> 24;
                    r[n + 2] = a >>> 16 & 255;
                    r[n + 1] = a >>> 8 & 255;
                    r[n] = a & 255;
                }
            }
            return r;
        }
        r.split32 = d;
        function l(e, t) {
            return e >>> t | e << 32 - t;
        }
        r.rotr32 = l;
        function p(e, t) {
            return e << t | e >>> 32 - t;
        }
        r.rotl32 = p;
        function b(e, t) {
            return e + t >>> 0;
        }
        r.sum32 = b;
        function v(e, t, r) {
            return e + t + r >>> 0;
        }
        r.sum32_3 = v;
        function m(e, t, r, i) {
            return e + t + r + i >>> 0;
        }
        r.sum32_4 = m;
        function y(e, t, r, i, n) {
            return e + t + r + i + n >>> 0;
        }
        r.sum32_5 = y;
        function g(e, t, r, i) {
            var n = e[t];
            var a = e[t + 1];
            var s = i + a >>> 0;
            var f = (s < i ? 1 : 0) + r + n;
            e[t] = f >>> 0;
            e[t + 1] = s;
        }
        r.sum64 = g;
        function w(e, t, r, i) {
            var n = t + i >>> 0;
            var a = (n < t ? 1 : 0) + e + r;
            return a >>> 0;
        }
        r.sum64_hi = w;
        function _(e, t, r, i) {
            var n = t + i;
            return n >>> 0;
        }
        r.sum64_lo = _;
        function S(e, t, r, i, n, a, s, f) {
            var o = 0;
            var c = t;
            c = c + i >>> 0;
            o += c < t ? 1 : 0;
            c = c + a >>> 0;
            o += c < a ? 1 : 0;
            c = c + f >>> 0;
            o += c < f ? 1 : 0;
            var h = e + r + n + s + o;
            return h >>> 0;
        }
        r.sum64_4_hi = S;
        function M(e, t, r, i, n, a, s, f) {
            var o = t + i + a + f;
            return o >>> 0;
        }
        r.sum64_4_lo = M;
        function k(e, t, r, i, n, a, s, f, o, c) {
            var h = 0;
            var u = t;
            u = u + i >>> 0;
            h += u < t ? 1 : 0;
            u = u + a >>> 0;
            h += u < a ? 1 : 0;
            u = u + f >>> 0;
            h += u < f ? 1 : 0;
            u = u + c >>> 0;
            h += u < c ? 1 : 0;
            var d = e + r + n + s + o + h;
            return d >>> 0;
        }
        r.sum64_5_hi = k;
        function E(e, t, r, i, n, a, s, f, o, c) {
            var h = t + i + a + f + c;
            return h >>> 0;
        }
        r.sum64_5_lo = E;
        function x(e, t, r) {
            var i = t << 32 - r | e >>> r;
            return i >>> 0;
        }
        r.rotr64_hi = x;
        function A(e, t, r) {
            var i = e << 32 - r | t >>> r;
            return i >>> 0;
        }
        r.rotr64_lo = A;
        function B(e, t, r) {
            return e >>> r;
        }
        r.shr64_hi = B;
        function I(e, t, r) {
            var i = e << 32 - r | t >>> r;
            return i >>> 0;
        }
        r.shr64_lo = I;
    }, {
        inherits: 115,
        "minimalistic-assert": 119
    } ],
    112: [ function(e, t, r) {
        "use strict";
        var i = e("hash.js");
        var n = e("minimalistic-crypto-utils");
        var a = e("minimalistic-assert");
        function s(e) {
            if (!(this instanceof s)) return new s(e);
            this.hash = e.hash;
            this.predResist = !!e.predResist;
            this.outLen = this.hash.outSize;
            this.minEntropy = e.minEntropy || this.hash.hmacStrength;
            this._reseed = null;
            this.reseedInterval = null;
            this.K = null;
            this.V = null;
            var t = n.toArray(e.entropy, e.entropyEnc || "hex");
            var r = n.toArray(e.nonce, e.nonceEnc || "hex");
            var i = n.toArray(e.pers, e.persEnc || "hex");
            a(t.length >= this.minEntropy / 8, "Not enough entropy. Minimum is: " + this.minEntropy + " bits");
            this._init(t, r, i);
        }
        t.exports = s;
        s.prototype._init = function e(t, r, i) {
            var n = t.concat(r).concat(i);
            this.K = new Array(this.outLen / 8);
            this.V = new Array(this.outLen / 8);
            for (var a = 0; a < this.V.length; a++) {
                this.K[a] = 0;
                this.V[a] = 1;
            }
            this._update(n);
            this._reseed = 1;
            this.reseedInterval = 281474976710656;
        };
        s.prototype._hmac = function e() {
            return new i.hmac(this.hash, this.K);
        };
        s.prototype._update = function e(t) {
            var r = this._hmac().update(this.V).update([ 0 ]);
            if (t) r = r.update(t);
            this.K = r.digest();
            this.V = this._hmac().update(this.V).digest();
            if (!t) return;
            this.K = this._hmac().update(this.V).update([ 1 ]).update(t).digest();
            this.V = this._hmac().update(this.V).digest();
        };
        s.prototype.reseed = function e(t, r, i, s) {
            if (typeof r !== "string") {
                s = i;
                i = r;
                r = null;
            }
            t = n.toArray(t, r);
            i = n.toArray(i, s);
            a(t.length >= this.minEntropy / 8, "Not enough entropy. Minimum is: " + this.minEntropy + " bits");
            this._update(t.concat(i || []));
            this._reseed = 1;
        };
        s.prototype.generate = function e(t, r, i, a) {
            if (this._reseed > this.reseedInterval) throw new Error("Reseed is required");
            if (typeof r !== "string") {
                a = i;
                i = r;
                r = null;
            }
            if (i) {
                i = n.toArray(i, a || "hex");
                this._update(i);
            }
            var s = [];
            while (s.length < t) {
                this.V = this._hmac().update(this.V).digest();
                s = s.concat(this.V);
            }
            var f = s.slice(0, t);
            this._update(i);
            this._reseed++;
            return n.encode(f, r);
        };
    }, {
        "hash.js": 100,
        "minimalistic-assert": 119,
        "minimalistic-crypto-utils": 120
    } ],
    113: [ function(e, t, r) {
        r.read = function(e, t, r, i, n) {
            var a, s;
            var f = n * 8 - i - 1;
            var o = (1 << f) - 1;
            var c = o >> 1;
            var h = -7;
            var u = r ? n - 1 : 0;
            var d = r ? -1 : 1;
            var l = e[t + u];
            u += d;
            a = l & (1 << -h) - 1;
            l >>= -h;
            h += f;
            for (;h > 0; a = a * 256 + e[t + u], u += d, h -= 8) {}
            s = a & (1 << -h) - 1;
            a >>= -h;
            h += i;
            for (;h > 0; s = s * 256 + e[t + u], u += d, h -= 8) {}
            if (a === 0) {
                a = 1 - c;
            } else if (a === o) {
                return s ? NaN : (l ? -1 : 1) * Infinity;
            } else {
                s = s + Math.pow(2, i);
                a = a - c;
            }
            return (l ? -1 : 1) * s * Math.pow(2, a - i);
        };
        r.write = function(e, t, r, i, n, a) {
            var s, f, o;
            var c = a * 8 - n - 1;
            var h = (1 << c) - 1;
            var u = h >> 1;
            var d = n === 23 ? Math.pow(2, -24) - Math.pow(2, -77) : 0;
            var l = i ? 0 : a - 1;
            var p = i ? 1 : -1;
            var b = t < 0 || t === 0 && 1 / t < 0 ? 1 : 0;
            t = Math.abs(t);
            if (isNaN(t) || t === Infinity) {
                f = isNaN(t) ? 1 : 0;
                s = h;
            } else {
                s = Math.floor(Math.log(t) / Math.LN2);
                if (t * (o = Math.pow(2, -s)) < 1) {
                    s--;
                    o *= 2;
                }
                if (s + u >= 1) {
                    t += d / o;
                } else {
                    t += d * Math.pow(2, 1 - u);
                }
                if (t * o >= 2) {
                    s++;
                    o /= 2;
                }
                if (s + u >= h) {
                    f = 0;
                    s = h;
                } else if (s + u >= 1) {
                    f = (t * o - 1) * Math.pow(2, n);
                    s = s + u;
                } else {
                    f = t * Math.pow(2, u - 1) * Math.pow(2, n);
                    s = 0;
                }
            }
            for (;n >= 8; e[r + l] = f & 255, l += p, f /= 256, n -= 8) {}
            s = s << n | f;
            c += n;
            for (;c > 0; e[r + l] = s & 255, l += p, s /= 256, c -= 8) {}
            e[r + l - p] |= b * 128;
        };
    }, {} ],
    114: [ function(e, t, r) {
        var i = [].indexOf;
        t.exports = function(e, t) {
            if (i) return e.indexOf(t);
            for (var r = 0; r < e.length; ++r) {
                if (e[r] === t) return r;
            }
            return -1;
        };
    }, {} ],
    115: [ function(e, t, r) {
        if (typeof Object.create === "function") {
            t.exports = function e(t, r) {
                t.super_ = r;
                t.prototype = Object.create(r.prototype, {
                    constructor: {
                        value: t,
                        enumerable: false,
                        writable: true,
                        configurable: true
                    }
                });
            };
        } else {
            t.exports = function e(t, r) {
                t.super_ = r;
                var i = function() {};
                i.prototype = r.prototype;
                t.prototype = new i();
                t.prototype.constructor = t;
            };
        }
    }, {} ],
    116: [ function(e, t, r) {
        t.exports = function(e) {
            return e != null && (i(e) || n(e) || !!e._isBuffer);
        };
        function i(e) {
            return !!e.constructor && typeof e.constructor.isBuffer === "function" && e.constructor.isBuffer(e);
        }
        function n(e) {
            return typeof e.readFloatLE === "function" && typeof e.slice === "function" && i(e.slice(0, 0));
        }
    }, {} ],
    117: [ function(e, t, r) {
        var i = {}.toString;
        t.exports = Array.isArray || function(e) {
            return i.call(e) == "[object Array]";
        };
    }, {} ],
    118: [ function(e, t, r) {
        var i = e("bn.js");
        var n = e("brorand");
        function a(e) {
            this.rand = e || new n.Rand();
        }
        t.exports = a;
        a.create = function e(t) {
            return new a(t);
        };
        a.prototype._rand = function e(t) {
            var r = t.bitLength();
            var n = this.rand.generate(Math.ceil(r / 8));
            n[0] |= 3;
            var a = r & 7;
            if (a !== 0) n[n.length - 1] >>= 7 - a;
            return new i(n);
        };
        a.prototype.test = function e(t, r, n) {
            var a = t.bitLength();
            var s = i.mont(t);
            var f = new i(1).toRed(s);
            if (!r) r = Math.max(1, a / 48 | 0);
            var o = t.subn(1);
            var c = o.subn(1);
            for (var h = 0; !o.testn(h); h++) {}
            var u = t.shrn(h);
            var d = o.toRed(s);
            var l = true;
            for (;r > 0; r--) {
                var p = this._rand(c);
                if (n) n(p);
                var b = p.toRed(s).redPow(u);
                if (b.cmp(f) === 0 || b.cmp(d) === 0) continue;
                for (var v = 1; v < h; v++) {
                    b = b.redSqr();
                    if (b.cmp(f) === 0) return false;
                    if (b.cmp(d) === 0) break;
                }
                if (v === h) return false;
            }
            return l;
        };
        a.prototype.getDivisor = function e(t, r) {
            var n = t.bitLength();
            var a = i.mont(t);
            var s = new i(1).toRed(a);
            if (!r) r = Math.max(1, n / 48 | 0);
            var f = t.subn(1);
            var o = f.subn(1);
            for (var c = 0; !f.testn(c); c++) {}
            var h = t.shrn(c);
            var u = f.toRed(a);
            for (;r > 0; r--) {
                var d = this._rand(o);
                var l = t.gcd(d);
                if (l.cmpn(1) !== 0) return l;
                var p = d.toRed(a).redPow(h);
                if (p.cmp(s) === 0 || p.cmp(u) === 0) continue;
                for (var b = 1; b < c; b++) {
                    p = p.redSqr();
                    if (p.cmp(s) === 0) return p.fromRed().subn(1).gcd(t);
                    if (p.cmp(u) === 0) break;
                }
                if (b === c) {
                    p = p.redSqr();
                    return p.fromRed().subn(1).gcd(t);
                }
            }
            return false;
        };
    }, {
        "bn.js": 32,
        brorand: 33
    } ],
    119: [ function(e, t, r) {
        t.exports = i;
        function i(e, t) {
            if (!e) throw new Error(t || "Assertion failed");
        }
        i.equal = function e(t, r, i) {
            if (t != r) throw new Error(i || "Assertion failed: " + t + " != " + r);
        };
    }, {} ],
    120: [ function(e, t, r) {
        "use strict";
        var i = r;
        function n(e, t) {
            if (Array.isArray(e)) return e.slice();
            if (!e) return [];
            var r = [];
            if (typeof e !== "string") {
                for (var i = 0; i < e.length; i++) r[i] = e[i] | 0;
                return r;
            }
            if (t === "hex") {
                e = e.replace(/[^a-z0-9]+/gi, "");
                if (e.length % 2 !== 0) e = "0" + e;
                for (var i = 0; i < e.length; i += 2) r.push(parseInt(e[i] + e[i + 1], 16));
            } else {
                for (var i = 0; i < e.length; i++) {
                    var n = e.charCodeAt(i);
                    var a = n >> 8;
                    var s = n & 255;
                    if (a) r.push(a, s); else r.push(s);
                }
            }
            return r;
        }
        i.toArray = n;
        function a(e) {
            if (e.length === 1) return "0" + e; else return e;
        }
        i.zero2 = a;
        function s(e) {
            var t = "";
            for (var r = 0; r < e.length; r++) t += a(e[r].toString(16));
            return t;
        }
        i.toHex = s;
        i.encode = function e(t, r) {
            if (r === "hex") return s(t); else return t;
        };
    }, {} ],
    121: [ function(e, t, r) {
        t.exports = {
            "2.16.840.1.101.3.4.1.1": "aes-128-ecb",
            "2.16.840.1.101.3.4.1.2": "aes-128-cbc",
            "2.16.840.1.101.3.4.1.3": "aes-128-ofb",
            "2.16.840.1.101.3.4.1.4": "aes-128-cfb",
            "2.16.840.1.101.3.4.1.21": "aes-192-ecb",
            "2.16.840.1.101.3.4.1.22": "aes-192-cbc",
            "2.16.840.1.101.3.4.1.23": "aes-192-ofb",
            "2.16.840.1.101.3.4.1.24": "aes-192-cfb",
            "2.16.840.1.101.3.4.1.41": "aes-256-ecb",
            "2.16.840.1.101.3.4.1.42": "aes-256-cbc",
            "2.16.840.1.101.3.4.1.43": "aes-256-ofb",
            "2.16.840.1.101.3.4.1.44": "aes-256-cfb"
        };
    }, {} ],
    122: [ function(e, t, r) {
        "use strict";
        var i = e("asn1.js");
        r.certificate = e("./certificate");
        var n = i.define("RSAPrivateKey", function() {
            this.seq().obj(this.key("version").int(), this.key("modulus").int(), this.key("publicExponent").int(), this.key("privateExponent").int(), this.key("prime1").int(), this.key("prime2").int(), this.key("exponent1").int(), this.key("exponent2").int(), this.key("coefficient").int());
        });
        r.RSAPrivateKey = n;
        var a = i.define("RSAPublicKey", function() {
            this.seq().obj(this.key("modulus").int(), this.key("publicExponent").int());
        });
        r.RSAPublicKey = a;
        var s = i.define("SubjectPublicKeyInfo", function() {
            this.seq().obj(this.key("algorithm").use(f), this.key("subjectPublicKey").bitstr());
        });
        r.PublicKey = s;
        var f = i.define("AlgorithmIdentifier", function() {
            this.seq().obj(this.key("algorithm").objid(), this.key("none").null_().optional(), this.key("curve").objid().optional(), this.key("params").seq().obj(this.key("p").int(), this.key("q").int(), this.key("g").int()).optional());
        });
        var o = i.define("PrivateKeyInfo", function() {
            this.seq().obj(this.key("version").int(), this.key("algorithm").use(f), this.key("subjectPrivateKey").octstr());
        });
        r.PrivateKey = o;
        var c = i.define("EncryptedPrivateKeyInfo", function() {
            this.seq().obj(this.key("algorithm").seq().obj(this.key("id").objid(), this.key("decrypt").seq().obj(this.key("kde").seq().obj(this.key("id").objid(), this.key("kdeparams").seq().obj(this.key("salt").octstr(), this.key("iters").int())), this.key("cipher").seq().obj(this.key("algo").objid(), this.key("iv").octstr()))), this.key("subjectPrivateKey").octstr());
        });
        r.EncryptedPrivateKey = c;
        var h = i.define("DSAPrivateKey", function() {
            this.seq().obj(this.key("version").int(), this.key("p").int(), this.key("q").int(), this.key("g").int(), this.key("pub_key").int(), this.key("priv_key").int());
        });
        r.DSAPrivateKey = h;
        r.DSAparam = i.define("DSAparam", function() {
            this.int();
        });
        var u = i.define("ECPrivateKey", function() {
            this.seq().obj(this.key("version").int(), this.key("privateKey").octstr(), this.key("parameters").optional().explicit(0).use(d), this.key("publicKey").optional().explicit(1).bitstr());
        });
        r.ECPrivateKey = u;
        var d = i.define("ECParameters", function() {
            this.choice({
                namedCurve: this.objid()
            });
        });
        r.signature = i.define("signature", function() {
            this.seq().obj(this.key("r").int(), this.key("s").int());
        });
    }, {
        "./certificate": 123,
        "asn1.js": 17
    } ],
    123: [ function(e, t, r) {
        "use strict";
        var i = e("asn1.js");
        var n = i.define("Time", function() {
            this.choice({
                utcTime: this.utctime(),
                generalTime: this.gentime()
            });
        });
        var a = i.define("AttributeTypeValue", function() {
            this.seq().obj(this.key("type").objid(), this.key("value").any());
        });
        var s = i.define("AlgorithmIdentifier", function() {
            this.seq().obj(this.key("algorithm").objid(), this.key("parameters").optional());
        });
        var f = i.define("SubjectPublicKeyInfo", function() {
            this.seq().obj(this.key("algorithm").use(s), this.key("subjectPublicKey").bitstr());
        });
        var o = i.define("RelativeDistinguishedName", function() {
            this.setof(a);
        });
        var c = i.define("RDNSequence", function() {
            this.seqof(o);
        });
        var h = i.define("Name", function() {
            this.choice({
                rdnSequence: this.use(c)
            });
        });
        var u = i.define("Validity", function() {
            this.seq().obj(this.key("notBefore").use(n), this.key("notAfter").use(n));
        });
        var d = i.define("Extension", function() {
            this.seq().obj(this.key("extnID").objid(), this.key("critical").bool().def(false), this.key("extnValue").octstr());
        });
        var l = i.define("TBSCertificate", function() {
            this.seq().obj(this.key("version").explicit(0).int(), this.key("serialNumber").int(), this.key("signature").use(s), this.key("issuer").use(h), this.key("validity").use(u), this.key("subject").use(h), this.key("subjectPublicKeyInfo").use(f), this.key("issuerUniqueID").implicit(1).bitstr().optional(), this.key("subjectUniqueID").implicit(2).bitstr().optional(), this.key("extensions").explicit(3).seqof(d).optional());
        });
        var p = i.define("X509Certificate", function() {
            this.seq().obj(this.key("tbsCertificate").use(l), this.key("signatureAlgorithm").use(s), this.key("signatureValue").bitstr());
        });
        t.exports = p;
    }, {
        "asn1.js": 17
    } ],
    124: [ function(e, t, r) {
        (function(r) {
            var i = /Proc-Type: 4,ENCRYPTED\n\r?DEK-Info: AES-((?:128)|(?:192)|(?:256))-CBC,([0-9A-H]+)\n\r?\n\r?([0-9A-z\n\r\+\/\=]+)\n\r?/m;
            var n = /^-----BEGIN ((?:.* KEY)|CERTIFICATE)-----\n/m;
            var a = /^-----BEGIN ((?:.* KEY)|CERTIFICATE)-----\n\r?([0-9A-z\n\r\+\/\=]+)\n\r?-----END \1-----$/m;
            var s = e("evp_bytestokey");
            var f = e("browserify-aes");
            t.exports = function(e, t) {
                var o = e.toString();
                var c = o.match(i);
                var h;
                if (!c) {
                    var u = o.match(a);
                    h = new r(u[2].replace(/\r?\n/g, ""), "base64");
                } else {
                    var d = "aes" + c[1];
                    var l = new r(c[2], "hex");
                    var p = new r(c[3].replace(/\r?\n/g, ""), "base64");
                    var b = s(t, l.slice(0, 8), parseInt(c[1], 10)).key;
                    var v = [];
                    var m = f.createDecipheriv(d, b, l);
                    v.push(m.update(p));
                    v.push(m.final());
                    h = r.concat(v);
                }
                var y = o.match(n)[1];
                return {
                    tag: y,
                    data: h
                };
            };
        }).call(this, e("buffer").Buffer);
    }, {
        "browserify-aes": 37,
        buffer: 61,
        evp_bytestokey: 98
    } ],
    125: [ function(e, t, r) {
        (function(r) {
            var i = e("./asn1");
            var n = e("./aesid.json");
            var a = e("./fixProc");
            var s = e("browserify-aes");
            var f = e("pbkdf2");
            t.exports = o;
            function o(e) {
                var t;
                if (typeof e === "object" && !r.isBuffer(e)) {
                    t = e.passphrase;
                    e = e.key;
                }
                if (typeof e === "string") {
                    e = new r(e);
                }
                var n = a(e, t);
                var s = n.tag;
                var f = n.data;
                var o, h;
                switch (s) {
                  case "CERTIFICATE":
                    h = i.certificate.decode(f, "der").tbsCertificate.subjectPublicKeyInfo;

                  case "PUBLIC KEY":
                    if (!h) {
                        h = i.PublicKey.decode(f, "der");
                    }
                    o = h.algorithm.algorithm.join(".");
                    switch (o) {
                      case "1.2.840.113549.1.1.1":
                        return i.RSAPublicKey.decode(h.subjectPublicKey.data, "der");

                      case "1.2.840.10045.2.1":
                        h.subjectPrivateKey = h.subjectPublicKey;
                        return {
                            type: "ec",
                            data: h
                        };

                      case "1.2.840.10040.4.1":
                        h.algorithm.params.pub_key = i.DSAparam.decode(h.subjectPublicKey.data, "der");
                        return {
                            type: "dsa",
                            data: h.algorithm.params
                        };

                      default:
                        throw new Error("unknown key id " + o);
                    }
                    throw new Error("unknown key type " + s);

                  case "ENCRYPTED PRIVATE KEY":
                    f = i.EncryptedPrivateKey.decode(f, "der");
                    f = c(f, t);

                  case "PRIVATE KEY":
                    h = i.PrivateKey.decode(f, "der");
                    o = h.algorithm.algorithm.join(".");
                    switch (o) {
                      case "1.2.840.113549.1.1.1":
                        return i.RSAPrivateKey.decode(h.subjectPrivateKey, "der");

                      case "1.2.840.10045.2.1":
                        return {
                            curve: h.algorithm.curve,
                            privateKey: i.ECPrivateKey.decode(h.subjectPrivateKey, "der").privateKey
                        };

                      case "1.2.840.10040.4.1":
                        h.algorithm.params.priv_key = i.DSAparam.decode(h.subjectPrivateKey, "der");
                        return {
                            type: "dsa",
                            params: h.algorithm.params
                        };

                      default:
                        throw new Error("unknown key id " + o);
                    }
                    throw new Error("unknown key type " + s);

                  case "RSA PUBLIC KEY":
                    return i.RSAPublicKey.decode(f, "der");

                  case "RSA PRIVATE KEY":
                    return i.RSAPrivateKey.decode(f, "der");

                  case "DSA PRIVATE KEY":
                    return {
                        type: "dsa",
                        params: i.DSAPrivateKey.decode(f, "der")
                    };

                  case "EC PRIVATE KEY":
                    f = i.ECPrivateKey.decode(f, "der");
                    return {
                        curve: f.parameters.value,
                        privateKey: f.privateKey
                    };

                  default:
                    throw new Error("unknown key type " + s);
                }
            }
            o.signature = i.signature;
            function c(e, t) {
                var i = e.algorithm.decrypt.kde.kdeparams.salt;
                var a = parseInt(e.algorithm.decrypt.kde.kdeparams.iters.toString(), 10);
                var o = n[e.algorithm.decrypt.cipher.algo.join(".")];
                var c = e.algorithm.decrypt.cipher.iv;
                var h = e.subjectPrivateKey;
                var u = parseInt(o.split("-")[1], 10) / 8;
                var d = f.pbkdf2Sync(t, i, a, u);
                var l = s.createDecipheriv(o, d, c);
                var p = [];
                p.push(l.update(h));
                p.push(l.final());
                return r.concat(p);
            }
        }).call(this, e("buffer").Buffer);
    }, {
        "./aesid.json": 121,
        "./asn1": 122,
        "./fixProc": 124,
        "browserify-aes": 37,
        buffer: 61,
        pbkdf2: 126
    } ],
    126: [ function(e, t, r) {
        r.pbkdf2 = e("./lib/async");
        r.pbkdf2Sync = e("./lib/sync");
    }, {
        "./lib/async": 127,
        "./lib/sync": 130
    } ],
    127: [ function(e, t, r) {
        (function(r, i) {
            var n = e("./precondition");
            var a = e("./default-encoding");
            var s = e("./sync");
            var f = e("safe-buffer").Buffer;
            var o;
            var c = i.crypto && i.crypto.subtle;
            var h = {
                sha: "SHA-1",
                "sha-1": "SHA-1",
                sha1: "SHA-1",
                sha256: "SHA-256",
                "sha-256": "SHA-256",
                sha384: "SHA-384",
                "sha-384": "SHA-384",
                "sha-512": "SHA-512",
                sha512: "SHA-512"
            };
            var u = [];
            function d(e) {
                if (i.process && !i.process.browser) {
                    return Promise.resolve(false);
                }
                if (!c || !c.importKey || !c.deriveBits) {
                    return Promise.resolve(false);
                }
                if (u[e] !== undefined) {
                    return u[e];
                }
                o = o || f.alloc(8);
                var t = l(o, o, 10, 128, e).then(function() {
                    return true;
                }).catch(function() {
                    return false;
                });
                u[e] = t;
                return t;
            }
            function l(e, t, r, i, n) {
                return c.importKey("raw", e, {
                    name: "PBKDF2"
                }, false, [ "deriveBits" ]).then(function(e) {
                    return c.deriveBits({
                        name: "PBKDF2",
                        salt: t,
                        iterations: r,
                        hash: {
                            name: n
                        }
                    }, e, i << 3);
                }).then(function(e) {
                    return f.from(e);
                });
            }
            function p(e, t) {
                e.then(function(e) {
                    r.nextTick(function() {
                        t(null, e);
                    });
                }, function(e) {
                    r.nextTick(function() {
                        t(e);
                    });
                });
            }
            t.exports = function(e, t, o, c, u, b) {
                if (!f.isBuffer(e)) e = f.from(e, a);
                if (!f.isBuffer(t)) t = f.from(t, a);
                n(o, c);
                if (typeof u === "function") {
                    b = u;
                    u = undefined;
                }
                if (typeof b !== "function") throw new Error("No callback provided to pbkdf2");
                u = u || "sha1";
                var v = h[u.toLowerCase()];
                if (!v || typeof i.Promise !== "function") {
                    return r.nextTick(function() {
                        var r;
                        try {
                            r = s(e, t, o, c, u);
                        } catch (e) {
                            return b(e);
                        }
                        b(null, r);
                    });
                }
                p(d(v).then(function(r) {
                    if (r) {
                        return l(e, t, o, c, v);
                    } else {
                        return s(e, t, o, c, u);
                    }
                }), b);
            };
        }).call(this, e("_process"), typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {});
    }, {
        "./default-encoding": 128,
        "./precondition": 129,
        "./sync": 130,
        _process: 132,
        "safe-buffer": 154
    } ],
    128: [ function(e, t, r) {
        (function(e) {
            var r;
            if (e.browser) {
                r = "utf-8";
            } else {
                var i = parseInt(e.version.split(".")[0].slice(1), 10);
                r = i >= 6 ? "utf-8" : "binary";
            }
            t.exports = r;
        }).call(this, e("_process"));
    }, {
        _process: 132
    } ],
    129: [ function(e, t, r) {
        var i = Math.pow(2, 30) - 1;
        t.exports = function(e, t) {
            if (typeof e !== "number") {
                throw new TypeError("Iterations not a number");
            }
            if (e < 0) {
                throw new TypeError("Bad iterations");
            }
            if (typeof t !== "number") {
                throw new TypeError("Key length not a number");
            }
            if (t < 0 || t > i || t !== t) {
                throw new TypeError("Bad key length");
            }
        };
    }, {} ],
    130: [ function(e, t, r) {
        var i = e("create-hash/md5");
        var n = e("ripemd160");
        var a = e("sha.js");
        var s = e("./precondition");
        var f = e("./default-encoding");
        var o = e("safe-buffer").Buffer;
        var c = o.alloc(128);
        var h = {
            md5: 16,
            sha1: 20,
            sha224: 28,
            sha256: 32,
            sha384: 48,
            sha512: 64,
            rmd160: 20,
            ripemd160: 20
        };
        function u(e, t, r) {
            var i = d(e);
            var n = e === "sha512" || e === "sha384" ? 128 : 64;
            if (t.length > n) {
                t = i(t);
            } else if (t.length < n) {
                t = o.concat([ t, c ], n);
            }
            var a = o.allocUnsafe(n + h[e]);
            var s = o.allocUnsafe(n + h[e]);
            for (var f = 0; f < n; f++) {
                a[f] = t[f] ^ 54;
                s[f] = t[f] ^ 92;
            }
            var u = o.allocUnsafe(n + r + 4);
            a.copy(u, 0, 0, n);
            this.ipad1 = u;
            this.ipad2 = a;
            this.opad = s;
            this.alg = e;
            this.blocksize = n;
            this.hash = i;
            this.size = h[e];
        }
        u.prototype.run = function(e, t) {
            e.copy(t, this.blocksize);
            var r = this.hash(t);
            r.copy(this.opad, this.blocksize);
            return this.hash(this.opad);
        };
        function d(e) {
            if (e === "rmd160" || e === "ripemd160") return n;
            if (e === "md5") return i;
            return t;
            function t(t) {
                return a(e).update(t).digest();
            }
        }
        t.exports = function(e, t, r, i, n) {
            if (!o.isBuffer(e)) e = o.from(e, f);
            if (!o.isBuffer(t)) t = o.from(t, f);
            s(r, i);
            n = n || "sha1";
            var a = new u(n, e, t.length);
            var c = o.allocUnsafe(i);
            var h = o.allocUnsafe(t.length + 4);
            t.copy(h, 0, 0, t.length);
            var d, l, p, b;
            var v = a.size;
            var m = o.allocUnsafe(v);
            var y = Math.ceil(i / v);
            var g = i - (y - 1) * v;
            for (var w = 1; w <= y; w++) {
                h.writeUInt32BE(w, t.length);
                d = a.run(h, a.ipad1);
                d.copy(m, 0, 0, v);
                for (l = 1; l < r; l++) {
                    d = a.run(d, a.ipad2);
                    for (var _ = 0; _ < v; _++) m[_] ^= d[_];
                }
                p = (w - 1) * v;
                b = w === y ? g : v;
                m.copy(c, p, 0, b);
            }
            return c;
        };
    }, {
        "./default-encoding": 128,
        "./precondition": 129,
        "create-hash/md5": 67,
        ripemd160: 153,
        "safe-buffer": 154,
        "sha.js": 156
    } ],
    131: [ function(e, t, r) {
        (function(e) {
            "use strict";
            if (!e.version || e.version.indexOf("v0.") === 0 || e.version.indexOf("v1.") === 0 && e.version.indexOf("v1.8.") !== 0) {
                t.exports = r;
            } else {
                t.exports = e.nextTick;
            }
            function r(t, r, i, n) {
                if (typeof t !== "function") {
                    throw new TypeError('"callback" argument must be a function');
                }
                var a = arguments.length;
                var s, f;
                switch (a) {
                  case 0:
                  case 1:
                    return e.nextTick(t);

                  case 2:
                    return e.nextTick(function e() {
                        t.call(null, r);
                    });

                  case 3:
                    return e.nextTick(function e() {
                        t.call(null, r, i);
                    });

                  case 4:
                    return e.nextTick(function e() {
                        t.call(null, r, i, n);
                    });

                  default:
                    s = new Array(a - 1);
                    f = 0;
                    while (f < s.length) {
                        s[f++] = arguments[f];
                    }
                    return e.nextTick(function e() {
                        t.apply(null, s);
                    });
                }
            }
        }).call(this, e("_process"));
    }, {
        _process: 132
    } ],
    132: [ function(e, t, r) {
        var i = t.exports = {};
        var n;
        var a;
        function s() {
            throw new Error("setTimeout has not been defined");
        }
        function f() {
            throw new Error("clearTimeout has not been defined");
        }
        (function() {
            try {
                if (typeof setTimeout === "function") {
                    n = setTimeout;
                } else {
                    n = s;
                }
            } catch (e) {
                n = s;
            }
            try {
                if (typeof clearTimeout === "function") {
                    a = clearTimeout;
                } else {
                    a = f;
                }
            } catch (e) {
                a = f;
            }
        })();
        function o(e) {
            if (n === setTimeout) {
                return setTimeout(e, 0);
            }
            if ((n === s || !n) && setTimeout) {
                n = setTimeout;
                return setTimeout(e, 0);
            }
            try {
                return n(e, 0);
            } catch (t) {
                try {
                    return n.call(null, e, 0);
                } catch (t) {
                    return n.call(this, e, 0);
                }
            }
        }
        function c(e) {
            if (a === clearTimeout) {
                return clearTimeout(e);
            }
            if ((a === f || !a) && clearTimeout) {
                a = clearTimeout;
                return clearTimeout(e);
            }
            try {
                return a(e);
            } catch (t) {
                try {
                    return a.call(null, e);
                } catch (t) {
                    return a.call(this, e);
                }
            }
        }
        var h = [];
        var u = false;
        var d;
        var l = -1;
        function p() {
            if (!u || !d) {
                return;
            }
            u = false;
            if (d.length) {
                h = d.concat(h);
            } else {
                l = -1;
            }
            if (h.length) {
                b();
            }
        }
        function b() {
            if (u) {
                return;
            }
            var e = o(p);
            u = true;
            var t = h.length;
            while (t) {
                d = h;
                h = [];
                while (++l < t) {
                    if (d) {
                        d[l].run();
                    }
                }
                l = -1;
                t = h.length;
            }
            d = null;
            u = false;
            c(e);
        }
        i.nextTick = function(e) {
            var t = new Array(arguments.length - 1);
            if (arguments.length > 1) {
                for (var r = 1; r < arguments.length; r++) {
                    t[r - 1] = arguments[r];
                }
            }
            h.push(new v(e, t));
            if (h.length === 1 && !u) {
                o(b);
            }
        };
        function v(e, t) {
            this.fun = e;
            this.array = t;
        }
        v.prototype.run = function() {
            this.fun.apply(null, this.array);
        };
        i.title = "browser";
        i.browser = true;
        i.env = {};
        i.argv = [];
        i.version = "";
        i.versions = {};
        function m() {}
        i.on = m;
        i.addListener = m;
        i.once = m;
        i.off = m;
        i.removeListener = m;
        i.removeAllListeners = m;
        i.emit = m;
        i.prependListener = m;
        i.prependOnceListener = m;
        i.listeners = function(e) {
            return [];
        };
        i.binding = function(e) {
            throw new Error("process.binding is not supported");
        };
        i.cwd = function() {
            return "/";
        };
        i.chdir = function(e) {
            throw new Error("process.chdir is not supported");
        };
        i.umask = function() {
            return 0;
        };
    }, {} ],
    133: [ function(e, t, r) {
        r.publicEncrypt = e("./publicEncrypt");
        r.privateDecrypt = e("./privateDecrypt");
        r.privateEncrypt = function e(t, i) {
            return r.publicEncrypt(t, i, true);
        };
        r.publicDecrypt = function e(t, i) {
            return r.privateDecrypt(t, i, true);
        };
    }, {
        "./privateDecrypt": 135,
        "./publicEncrypt": 136
    } ],
    134: [ function(e, t, r) {
        (function(r) {
            var i = e("create-hash");
            t.exports = function(e, t) {
                var a = new r("");
                var s = 0, f;
                while (a.length < t) {
                    f = n(s++);
                    a = r.concat([ a, i("sha1").update(e).update(f).digest() ]);
                }
                return a.slice(0, t);
            };
            function n(e) {
                var t = new r(4);
                t.writeUInt32BE(e, 0);
                return t;
            }
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61,
        "create-hash": 65
    } ],
    135: [ function(e, t, r) {
        (function(r) {
            var i = e("parse-asn1");
            var n = e("./mgf");
            var a = e("./xor");
            var s = e("bn.js");
            var f = e("browserify-rsa");
            var o = e("create-hash");
            var c = e("./withPublic");
            t.exports = function e(t, n, a) {
                var o;
                if (t.padding) {
                    o = t.padding;
                } else if (a) {
                    o = 1;
                } else {
                    o = 4;
                }
                var d = i(t);
                var l = d.modulus.byteLength();
                if (n.length > l || new s(n).cmp(d.modulus) >= 0) {
                    throw new Error("decryption error");
                }
                var p;
                if (a) {
                    p = c(new s(n), d);
                } else {
                    p = f(n, d);
                }
                var b = new r(l - p.length);
                b.fill(0);
                p = r.concat([ b, p ], l);
                if (o === 4) {
                    return h(d, p);
                } else if (o === 1) {
                    return u(d, p, a);
                } else if (o === 3) {
                    return p;
                } else {
                    throw new Error("unknown padding");
                }
            };
            function h(e, t) {
                var i = e.modulus;
                var s = e.modulus.byteLength();
                var f = t.length;
                var c = o("sha1").update(new r("")).digest();
                var h = c.length;
                var u = 2 * h;
                if (t[0] !== 0) {
                    throw new Error("decryption error");
                }
                var l = t.slice(1, h + 1);
                var p = t.slice(h + 1);
                var b = a(l, n(p, h));
                var v = a(p, n(b, s - h - 1));
                if (d(c, v.slice(0, h))) {
                    throw new Error("decryption error");
                }
                var m = h;
                while (v[m] === 0) {
                    m++;
                }
                if (v[m++] !== 1) {
                    throw new Error("decryption error");
                }
                return v.slice(m);
            }
            function u(e, t, r) {
                var i = t.slice(0, 2);
                var n = 2;
                var a = 0;
                while (t[n++] !== 0) {
                    if (n >= t.length) {
                        a++;
                        break;
                    }
                }
                var s = t.slice(2, n - 1);
                var f = t.slice(n - 1, n);
                if (i.toString("hex") !== "0002" && !r || i.toString("hex") !== "0001" && r) {
                    a++;
                }
                if (s.length < 8) {
                    a++;
                }
                if (a) {
                    throw new Error("decryption error");
                }
                return t.slice(n);
            }
            function d(e, t) {
                e = new r(e);
                t = new r(t);
                var i = 0;
                var n = e.length;
                if (e.length !== t.length) {
                    i++;
                    n = Math.min(e.length, t.length);
                }
                var a = -1;
                while (++a < n) {
                    i += e[a] ^ t[a];
                }
                return i;
            }
        }).call(this, e("buffer").Buffer);
    }, {
        "./mgf": 134,
        "./withPublic": 137,
        "./xor": 138,
        "bn.js": 32,
        "browserify-rsa": 53,
        buffer: 61,
        "create-hash": 65,
        "parse-asn1": 125
    } ],
    136: [ function(e, t, r) {
        (function(r) {
            var i = e("parse-asn1");
            var n = e("randombytes");
            var a = e("create-hash");
            var s = e("./mgf");
            var f = e("./xor");
            var o = e("bn.js");
            var c = e("./withPublic");
            var h = e("browserify-rsa");
            var u = {
                RSA_PKCS1_OAEP_PADDING: 4,
                RSA_PKCS1_PADDIN: 1,
                RSA_NO_PADDING: 3
            };
            t.exports = function e(t, r, n) {
                var a;
                if (t.padding) {
                    a = t.padding;
                } else if (n) {
                    a = 1;
                } else {
                    a = 4;
                }
                var s = i(t);
                var f;
                if (a === 4) {
                    f = d(s, r);
                } else if (a === 1) {
                    f = l(s, r, n);
                } else if (a === 3) {
                    f = new o(r);
                    if (f.cmp(s.modulus) >= 0) {
                        throw new Error("data too long for modulus");
                    }
                } else {
                    throw new Error("unknown padding");
                }
                if (n) {
                    return h(f, s);
                } else {
                    return c(f, s);
                }
            };
            function d(e, t) {
                var i = e.modulus.byteLength();
                var c = t.length;
                var h = a("sha1").update(new r("")).digest();
                var u = h.length;
                var d = 2 * u;
                if (c > i - d - 2) {
                    throw new Error("message too long");
                }
                var l = new r(i - c - d - 2);
                l.fill(0);
                var p = i - u - 1;
                var b = n(u);
                var v = f(r.concat([ h, l, new r([ 1 ]), t ], p), s(b, p));
                var m = f(b, s(v, u));
                return new o(r.concat([ new r([ 0 ]), m, v ], i));
            }
            function l(e, t, i) {
                var n = t.length;
                var a = e.modulus.byteLength();
                if (n > a - 11) {
                    throw new Error("message too long");
                }
                var s;
                if (i) {
                    s = new r(a - n - 3);
                    s.fill(255);
                } else {
                    s = p(a - n - 3);
                }
                return new o(r.concat([ new r([ 0, i ? 1 : 2 ]), s, new r([ 0 ]), t ], a));
            }
            function p(e, t) {
                var i = new r(e);
                var a = 0;
                var s = n(e * 2);
                var f = 0;
                var o;
                while (a < e) {
                    if (f === s.length) {
                        s = n(e * 2);
                        f = 0;
                    }
                    o = s[f++];
                    if (o) {
                        i[a++] = o;
                    }
                }
                return i;
            }
        }).call(this, e("buffer").Buffer);
    }, {
        "./mgf": 134,
        "./withPublic": 137,
        "./xor": 138,
        "bn.js": 32,
        "browserify-rsa": 53,
        buffer: 61,
        "create-hash": 65,
        "parse-asn1": 125,
        randombytes: 139
    } ],
    137: [ function(e, t, r) {
        (function(r) {
            var i = e("bn.js");
            function n(e, t) {
                return new r(e.toRed(i.mont(t.modulus)).redPow(new i(t.publicExponent)).fromRed().toArray());
            }
            t.exports = n;
        }).call(this, e("buffer").Buffer);
    }, {
        "bn.js": 32,
        buffer: 61
    } ],
    138: [ function(e, t, r) {
        t.exports = function e(t, r) {
            var i = t.length;
            var n = -1;
            while (++n < i) {
                t[n] ^= r[n];
            }
            return t;
        };
    }, {} ],
    139: [ function(e, t, r) {
        (function(r, i) {
            "use strict";
            function n() {
                throw new Error("secure random number generation not supported by this browser\nuse chrome, FireFox or Internet Explorer 11");
            }
            var a = e("safe-buffer").Buffer;
            var s = i.crypto || i.msCrypto;
            if (s && s.getRandomValues) {
                t.exports = f;
            } else {
                t.exports = n;
            }
            function f(e, t) {
                if (e > 65536) throw new Error("requested too many random bytes");
                var n = new i.Uint8Array(e);
                if (e > 0) {
                    s.getRandomValues(n);
                }
                var f = a.from(n.buffer);
                if (typeof t === "function") {
                    return r.nextTick(function() {
                        t(null, f);
                    });
                }
                return f;
            }
        }).call(this, e("_process"), typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {});
    }, {
        _process: 132,
        "safe-buffer": 154
    } ],
    140: [ function(e, t, r) {
        t.exports = e("./lib/_stream_duplex.js");
    }, {
        "./lib/_stream_duplex.js": 141
    } ],
    141: [ function(e, t, r) {
        "use strict";
        var i = e("process-nextick-args");
        var n = Object.keys || function(e) {
            var t = [];
            for (var r in e) {
                t.push(r);
            }
            return t;
        };
        t.exports = u;
        var a = e("core-util-is");
        a.inherits = e("inherits");
        var s = e("./_stream_readable");
        var f = e("./_stream_writable");
        a.inherits(u, s);
        var o = n(f.prototype);
        for (var c = 0; c < o.length; c++) {
            var h = o[c];
            if (!u.prototype[h]) u.prototype[h] = f.prototype[h];
        }
        function u(e) {
            if (!(this instanceof u)) return new u(e);
            s.call(this, e);
            f.call(this, e);
            if (e && e.readable === false) this.readable = false;
            if (e && e.writable === false) this.writable = false;
            this.allowHalfOpen = true;
            if (e && e.allowHalfOpen === false) this.allowHalfOpen = false;
            this.once("end", d);
        }
        function d() {
            if (this.allowHalfOpen || this._writableState.ended) return;
            i(l, this);
        }
        function l(e) {
            e.end();
        }
        Object.defineProperty(u.prototype, "destroyed", {
            get: function() {
                if (this._readableState === undefined || this._writableState === undefined) {
                    return false;
                }
                return this._readableState.destroyed && this._writableState.destroyed;
            },
            set: function(e) {
                if (this._readableState === undefined || this._writableState === undefined) {
                    return;
                }
                this._readableState.destroyed = e;
                this._writableState.destroyed = e;
            }
        });
        u.prototype._destroy = function(e, t) {
            this.push(null);
            this.end();
            i(t, e);
        };
        function p(e, t) {
            for (var r = 0, i = e.length; r < i; r++) {
                t(e[r], r);
            }
        }
    }, {
        "./_stream_readable": 143,
        "./_stream_writable": 145,
        "core-util-is": 63,
        inherits: 115,
        "process-nextick-args": 131
    } ],
    142: [ function(e, t, r) {
        "use strict";
        t.exports = a;
        var i = e("./_stream_transform");
        var n = e("core-util-is");
        n.inherits = e("inherits");
        n.inherits(a, i);
        function a(e) {
            if (!(this instanceof a)) return new a(e);
            i.call(this, e);
        }
        a.prototype._transform = function(e, t, r) {
            r(null, e);
        };
    }, {
        "./_stream_transform": 144,
        "core-util-is": 63,
        inherits: 115
    } ],
    143: [ function(e, t, r) {
        (function(r, i) {
            "use strict";
            var n = e("process-nextick-args");
            t.exports = M;
            var a = e("isarray");
            var s;
            M.ReadableState = S;
            var f = e("events").EventEmitter;
            var o = function(e, t) {
                return e.listeners(t).length;
            };
            var c = e("./internal/streams/stream");
            var h = e("safe-buffer").Buffer;
            var u = i.Uint8Array || function() {};
            function d(e) {
                return h.from(e);
            }
            function l(e) {
                return h.isBuffer(e) || e instanceof u;
            }
            var p = e("core-util-is");
            p.inherits = e("inherits");
            var b = e("util");
            var v = void 0;
            if (b && b.debuglog) {
                v = b.debuglog("stream");
            } else {
                v = function() {};
            }
            var m = e("./internal/streams/BufferList");
            var y = e("./internal/streams/destroy");
            var g;
            p.inherits(M, c);
            var w = [ "error", "close", "destroy", "pause", "resume" ];
            function _(e, t, r) {
                if (typeof e.prependListener === "function") {
                    return e.prependListener(t, r);
                } else {
                    if (!e._events || !e._events[t]) e.on(t, r); else if (a(e._events[t])) e._events[t].unshift(r); else e._events[t] = [ r, e._events[t] ];
                }
            }
            function S(t, r) {
                s = s || e("./_stream_duplex");
                t = t || {};
                this.objectMode = !!t.objectMode;
                if (r instanceof s) this.objectMode = this.objectMode || !!t.readableObjectMode;
                var i = t.highWaterMark;
                var n = this.objectMode ? 16 : 16 * 1024;
                this.highWaterMark = i || i === 0 ? i : n;
                this.highWaterMark = Math.floor(this.highWaterMark);
                this.buffer = new m();
                this.length = 0;
                this.pipes = null;
                this.pipesCount = 0;
                this.flowing = null;
                this.ended = false;
                this.endEmitted = false;
                this.reading = false;
                this.sync = true;
                this.needReadable = false;
                this.emittedReadable = false;
                this.readableListening = false;
                this.resumeScheduled = false;
                this.destroyed = false;
                this.defaultEncoding = t.defaultEncoding || "utf8";
                this.awaitDrain = 0;
                this.readingMore = false;
                this.decoder = null;
                this.encoding = null;
                if (t.encoding) {
                    if (!g) g = e("string_decoder/").StringDecoder;
                    this.decoder = new g(t.encoding);
                    this.encoding = t.encoding;
                }
            }
            function M(t) {
                s = s || e("./_stream_duplex");
                if (!(this instanceof M)) return new M(t);
                this._readableState = new S(t, this);
                this.readable = true;
                if (t) {
                    if (typeof t.read === "function") this._read = t.read;
                    if (typeof t.destroy === "function") this._destroy = t.destroy;
                }
                c.call(this);
            }
            Object.defineProperty(M.prototype, "destroyed", {
                get: function() {
                    if (this._readableState === undefined) {
                        return false;
                    }
                    return this._readableState.destroyed;
                },
                set: function(e) {
                    if (!this._readableState) {
                        return;
                    }
                    this._readableState.destroyed = e;
                }
            });
            M.prototype.destroy = y.destroy;
            M.prototype._undestroy = y.undestroy;
            M.prototype._destroy = function(e, t) {
                this.push(null);
                t(e);
            };
            M.prototype.push = function(e, t) {
                var r = this._readableState;
                var i;
                if (!r.objectMode) {
                    if (typeof e === "string") {
                        t = t || r.defaultEncoding;
                        if (t !== r.encoding) {
                            e = h.from(e, t);
                            t = "";
                        }
                        i = true;
                    }
                } else {
                    i = true;
                }
                return k(this, e, t, false, i);
            };
            M.prototype.unshift = function(e) {
                return k(this, e, null, true, false);
            };
            function k(e, t, r, i, n) {
                var a = e._readableState;
                if (t === null) {
                    a.reading = false;
                    C(e, a);
                } else {
                    var s;
                    if (!n) s = x(a, t);
                    if (s) {
                        e.emit("error", s);
                    } else if (a.objectMode || t && t.length > 0) {
                        if (typeof t !== "string" && !a.objectMode && Object.getPrototypeOf(t) !== h.prototype) {
                            t = d(t);
                        }
                        if (i) {
                            if (a.endEmitted) e.emit("error", new Error("stream.unshift() after end event")); else E(e, a, t, true);
                        } else if (a.ended) {
                            e.emit("error", new Error("stream.push() after EOF"));
                        } else {
                            a.reading = false;
                            if (a.decoder && !r) {
                                t = a.decoder.write(t);
                                if (a.objectMode || t.length !== 0) E(e, a, t, false); else T(e, a);
                            } else {
                                E(e, a, t, false);
                            }
                        }
                    } else if (!i) {
                        a.reading = false;
                    }
                }
                return A(a);
            }
            function E(e, t, r, i) {
                if (t.flowing && t.length === 0 && !t.sync) {
                    e.emit("data", r);
                    e.read(0);
                } else {
                    t.length += t.objectMode ? 1 : r.length;
                    if (i) t.buffer.unshift(r); else t.buffer.push(r);
                    if (t.needReadable) R(e);
                }
                T(e, t);
            }
            function x(e, t) {
                var r;
                if (!l(t) && typeof t !== "string" && t !== undefined && !e.objectMode) {
                    r = new TypeError("Invalid non-string/buffer chunk");
                }
                return r;
            }
            function A(e) {
                return !e.ended && (e.needReadable || e.length < e.highWaterMark || e.length === 0);
            }
            M.prototype.isPaused = function() {
                return this._readableState.flowing === false;
            };
            M.prototype.setEncoding = function(t) {
                if (!g) g = e("string_decoder/").StringDecoder;
                this._readableState.decoder = new g(t);
                this._readableState.encoding = t;
                return this;
            };
            var B = 8388608;
            function I(e) {
                if (e >= B) {
                    e = B;
                } else {
                    e--;
                    e |= e >>> 1;
                    e |= e >>> 2;
                    e |= e >>> 4;
                    e |= e >>> 8;
                    e |= e >>> 16;
                    e++;
                }
                return e;
            }
            function j(e, t) {
                if (e <= 0 || t.length === 0 && t.ended) return 0;
                if (t.objectMode) return 1;
                if (e !== e) {
                    if (t.flowing && t.length) return t.buffer.head.data.length; else return t.length;
                }
                if (e > t.highWaterMark) t.highWaterMark = I(e);
                if (e <= t.length) return e;
                if (!t.ended) {
                    t.needReadable = true;
                    return 0;
                }
                return t.length;
            }
            M.prototype.read = function(e) {
                v("read", e);
                e = parseInt(e, 10);
                var t = this._readableState;
                var r = e;
                if (e !== 0) t.emittedReadable = false;
                if (e === 0 && t.needReadable && (t.length >= t.highWaterMark || t.ended)) {
                    v("read: emitReadable", t.length, t.ended);
                    if (t.length === 0 && t.ended) W(this); else R(this);
                    return null;
                }
                e = j(e, t);
                if (e === 0 && t.ended) {
                    if (t.length === 0) W(this);
                    return null;
                }
                var i = t.needReadable;
                v("need readable", i);
                if (t.length === 0 || t.length - e < t.highWaterMark) {
                    i = true;
                    v("length less than watermark", i);
                }
                if (t.ended || t.reading) {
                    i = false;
                    v("reading or ended", i);
                } else if (i) {
                    v("do read");
                    t.reading = true;
                    t.sync = true;
                    if (t.length === 0) t.needReadable = true;
                    this._read(t.highWaterMark);
                    t.sync = false;
                    if (!t.reading) e = j(r, t);
                }
                var n;
                if (e > 0) n = U(e, t); else n = null;
                if (n === null) {
                    t.needReadable = true;
                    e = 0;
                } else {
                    t.length -= e;
                }
                if (t.length === 0) {
                    if (!t.ended) t.needReadable = true;
                    if (r !== e && t.ended) W(this);
                }
                if (n !== null) this.emit("data", n);
                return n;
            };
            function C(e, t) {
                if (t.ended) return;
                if (t.decoder) {
                    var r = t.decoder.end();
                    if (r && r.length) {
                        t.buffer.push(r);
                        t.length += t.objectMode ? 1 : r.length;
                    }
                }
                t.ended = true;
                R(e);
            }
            function R(e) {
                var t = e._readableState;
                t.needReadable = false;
                if (!t.emittedReadable) {
                    v("emitReadable", t.flowing);
                    t.emittedReadable = true;
                    if (t.sync) n(P, e); else P(e);
                }
            }
            function P(e) {
                v("emit readable");
                e.emit("readable");
                z(e);
            }
            function T(e, t) {
                if (!t.readingMore) {
                    t.readingMore = true;
                    n(D, e, t);
                }
            }
            function D(e, t) {
                var r = t.length;
                while (!t.reading && !t.flowing && !t.ended && t.length < t.highWaterMark) {
                    v("maybeReadMore read 0");
                    e.read(0);
                    if (r === t.length) break; else r = t.length;
                }
                t.readingMore = false;
            }
            M.prototype._read = function(e) {
                this.emit("error", new Error("_read() is not implemented"));
            };
            M.prototype.pipe = function(e, t) {
                var i = this;
                var a = this._readableState;
                switch (a.pipesCount) {
                  case 0:
                    a.pipes = e;
                    break;

                  case 1:
                    a.pipes = [ a.pipes, e ];
                    break;

                  default:
                    a.pipes.push(e);
                    break;
                }
                a.pipesCount += 1;
                v("pipe count=%d opts=%j", a.pipesCount, t);
                var s = (!t || t.end !== false) && e !== r.stdout && e !== r.stderr;
                var f = s ? h : w;
                if (a.endEmitted) n(f); else i.once("end", f);
                e.on("unpipe", c);
                function c(e, t) {
                    v("onunpipe");
                    if (e === i) {
                        if (t && t.hasUnpiped === false) {
                            t.hasUnpiped = true;
                            l();
                        }
                    }
                }
                function h() {
                    v("onend");
                    e.end();
                }
                var u = L(i);
                e.on("drain", u);
                var d = false;
                function l() {
                    v("cleanup");
                    e.removeListener("close", y);
                    e.removeListener("finish", g);
                    e.removeListener("drain", u);
                    e.removeListener("error", m);
                    e.removeListener("unpipe", c);
                    i.removeListener("end", h);
                    i.removeListener("end", w);
                    i.removeListener("data", b);
                    d = true;
                    if (a.awaitDrain && (!e._writableState || e._writableState.needDrain)) u();
                }
                var p = false;
                i.on("data", b);
                function b(t) {
                    v("ondata");
                    p = false;
                    var r = e.write(t);
                    if (false === r && !p) {
                        if ((a.pipesCount === 1 && a.pipes === e || a.pipesCount > 1 && Z(a.pipes, e) !== -1) && !d) {
                            v("false write response, pause", i._readableState.awaitDrain);
                            i._readableState.awaitDrain++;
                            p = true;
                        }
                        i.pause();
                    }
                }
                function m(t) {
                    v("onerror", t);
                    w();
                    e.removeListener("error", m);
                    if (o(e, "error") === 0) e.emit("error", t);
                }
                _(e, "error", m);
                function y() {
                    e.removeListener("finish", g);
                    w();
                }
                e.once("close", y);
                function g() {
                    v("onfinish");
                    e.removeListener("close", y);
                    w();
                }
                e.once("finish", g);
                function w() {
                    v("unpipe");
                    i.unpipe(e);
                }
                e.emit("pipe", i);
                if (!a.flowing) {
                    v("pipe resume");
                    i.resume();
                }
                return e;
            };
            function L(e) {
                return function() {
                    var t = e._readableState;
                    v("pipeOnDrain", t.awaitDrain);
                    if (t.awaitDrain) t.awaitDrain--;
                    if (t.awaitDrain === 0 && o(e, "data")) {
                        t.flowing = true;
                        z(e);
                    }
                };
            }
            M.prototype.unpipe = function(e) {
                var t = this._readableState;
                var r = {
                    hasUnpiped: false
                };
                if (t.pipesCount === 0) return this;
                if (t.pipesCount === 1) {
                    if (e && e !== t.pipes) return this;
                    if (!e) e = t.pipes;
                    t.pipes = null;
                    t.pipesCount = 0;
                    t.flowing = false;
                    if (e) e.emit("unpipe", this, r);
                    return this;
                }
                if (!e) {
                    var i = t.pipes;
                    var n = t.pipesCount;
                    t.pipes = null;
                    t.pipesCount = 0;
                    t.flowing = false;
                    for (var a = 0; a < n; a++) {
                        i[a].emit("unpipe", this, r);
                    }
                    return this;
                }
                var s = Z(t.pipes, e);
                if (s === -1) return this;
                t.pipes.splice(s, 1);
                t.pipesCount -= 1;
                if (t.pipesCount === 1) t.pipes = t.pipes[0];
                e.emit("unpipe", this, r);
                return this;
            };
            M.prototype.on = function(e, t) {
                var r = c.prototype.on.call(this, e, t);
                if (e === "data") {
                    if (this._readableState.flowing !== false) this.resume();
                } else if (e === "readable") {
                    var i = this._readableState;
                    if (!i.endEmitted && !i.readableListening) {
                        i.readableListening = i.needReadable = true;
                        i.emittedReadable = false;
                        if (!i.reading) {
                            n(q, this);
                        } else if (i.length) {
                            R(this);
                        }
                    }
                }
                return r;
            };
            M.prototype.addListener = M.prototype.on;
            function q(e) {
                v("readable nexttick read 0");
                e.read(0);
            }
            M.prototype.resume = function() {
                var e = this._readableState;
                if (!e.flowing) {
                    v("resume");
                    e.flowing = true;
                    N(this, e);
                }
                return this;
            };
            function N(e, t) {
                if (!t.resumeScheduled) {
                    t.resumeScheduled = true;
                    n(O, e, t);
                }
            }
            function O(e, t) {
                if (!t.reading) {
                    v("resume read 0");
                    e.read(0);
                }
                t.resumeScheduled = false;
                t.awaitDrain = 0;
                e.emit("resume");
                z(e);
                if (t.flowing && !t.reading) e.read(0);
            }
            M.prototype.pause = function() {
                v("call pause flowing=%j", this._readableState.flowing);
                if (false !== this._readableState.flowing) {
                    v("pause");
                    this._readableState.flowing = false;
                    this.emit("pause");
                }
                return this;
            };
            function z(e) {
                var t = e._readableState;
                v("flow", t.flowing);
                while (t.flowing && e.read() !== null) {}
            }
            M.prototype.wrap = function(e) {
                var t = this._readableState;
                var r = false;
                var i = this;
                e.on("end", function() {
                    v("wrapped end");
                    if (t.decoder && !t.ended) {
                        var e = t.decoder.end();
                        if (e && e.length) i.push(e);
                    }
                    i.push(null);
                });
                e.on("data", function(n) {
                    v("wrapped data");
                    if (t.decoder) n = t.decoder.write(n);
                    if (t.objectMode && (n === null || n === undefined)) return; else if (!t.objectMode && (!n || !n.length)) return;
                    var a = i.push(n);
                    if (!a) {
                        r = true;
                        e.pause();
                    }
                });
                for (var n in e) {
                    if (this[n] === undefined && typeof e[n] === "function") {
                        this[n] = function(t) {
                            return function() {
                                return e[t].apply(e, arguments);
                            };
                        }(n);
                    }
                }
                for (var a = 0; a < w.length; a++) {
                    e.on(w[a], i.emit.bind(i, w[a]));
                }
                i._read = function(t) {
                    v("wrapped _read", t);
                    if (r) {
                        r = false;
                        e.resume();
                    }
                };
                return i;
            };
            M._fromList = U;
            function U(e, t) {
                if (t.length === 0) return null;
                var r;
                if (t.objectMode) r = t.buffer.shift(); else if (!e || e >= t.length) {
                    if (t.decoder) r = t.buffer.join(""); else if (t.buffer.length === 1) r = t.buffer.head.data; else r = t.buffer.concat(t.length);
                    t.buffer.clear();
                } else {
                    r = K(e, t.buffer, t.decoder);
                }
                return r;
            }
            function K(e, t, r) {
                var i;
                if (e < t.head.data.length) {
                    i = t.head.data.slice(0, e);
                    t.head.data = t.head.data.slice(e);
                } else if (e === t.head.data.length) {
                    i = t.shift();
                } else {
                    i = r ? F(e, t) : H(e, t);
                }
                return i;
            }
            function F(e, t) {
                var r = t.head;
                var i = 1;
                var n = r.data;
                e -= n.length;
                while (r = r.next) {
                    var a = r.data;
                    var s = e > a.length ? a.length : e;
                    if (s === a.length) n += a; else n += a.slice(0, e);
                    e -= s;
                    if (e === 0) {
                        if (s === a.length) {
                            ++i;
                            if (r.next) t.head = r.next; else t.head = t.tail = null;
                        } else {
                            t.head = r;
                            r.data = a.slice(s);
                        }
                        break;
                    }
                    ++i;
                }
                t.length -= i;
                return n;
            }
            function H(e, t) {
                var r = h.allocUnsafe(e);
                var i = t.head;
                var n = 1;
                i.data.copy(r);
                e -= i.data.length;
                while (i = i.next) {
                    var a = i.data;
                    var s = e > a.length ? a.length : e;
                    a.copy(r, r.length - e, 0, s);
                    e -= s;
                    if (e === 0) {
                        if (s === a.length) {
                            ++n;
                            if (i.next) t.head = i.next; else t.head = t.tail = null;
                        } else {
                            t.head = i;
                            i.data = a.slice(s);
                        }
                        break;
                    }
                    ++n;
                }
                t.length -= n;
                return r;
            }
            function W(e) {
                var t = e._readableState;
                if (t.length > 0) throw new Error('"endReadable()" called on non-empty stream');
                if (!t.endEmitted) {
                    t.ended = true;
                    n(V, t, e);
                }
            }
            function V(e, t) {
                if (!e.endEmitted && e.length === 0) {
                    e.endEmitted = true;
                    t.readable = false;
                    t.emit("end");
                }
            }
            function X(e, t) {
                for (var r = 0, i = e.length; r < i; r++) {
                    t(e[r], r);
                }
            }
            function Z(e, t) {
                for (var r = 0, i = e.length; r < i; r++) {
                    if (e[r] === t) return r;
                }
                return -1;
            }
        }).call(this, e("_process"), typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {});
    }, {
        "./_stream_duplex": 141,
        "./internal/streams/BufferList": 146,
        "./internal/streams/destroy": 147,
        "./internal/streams/stream": 148,
        _process: 132,
        "core-util-is": 63,
        events: 97,
        inherits: 115,
        isarray: 117,
        "process-nextick-args": 131,
        "safe-buffer": 154,
        "string_decoder/": 164,
        util: 34
    } ],
    144: [ function(e, t, r) {
        "use strict";
        t.exports = f;
        var i = e("./_stream_duplex");
        var n = e("core-util-is");
        n.inherits = e("inherits");
        n.inherits(f, i);
        function a(e) {
            this.afterTransform = function(t, r) {
                return s(e, t, r);
            };
            this.needTransform = false;
            this.transforming = false;
            this.writecb = null;
            this.writechunk = null;
            this.writeencoding = null;
        }
        function s(e, t, r) {
            var i = e._transformState;
            i.transforming = false;
            var n = i.writecb;
            if (!n) {
                return e.emit("error", new Error("write callback called multiple times"));
            }
            i.writechunk = null;
            i.writecb = null;
            if (r !== null && r !== undefined) e.push(r);
            n(t);
            var a = e._readableState;
            a.reading = false;
            if (a.needReadable || a.length < a.highWaterMark) {
                e._read(a.highWaterMark);
            }
        }
        function f(e) {
            if (!(this instanceof f)) return new f(e);
            i.call(this, e);
            this._transformState = new a(this);
            var t = this;
            this._readableState.needReadable = true;
            this._readableState.sync = false;
            if (e) {
                if (typeof e.transform === "function") this._transform = e.transform;
                if (typeof e.flush === "function") this._flush = e.flush;
            }
            this.once("prefinish", function() {
                if (typeof this._flush === "function") this._flush(function(e, r) {
                    o(t, e, r);
                }); else o(t);
            });
        }
        f.prototype.push = function(e, t) {
            this._transformState.needTransform = false;
            return i.prototype.push.call(this, e, t);
        };
        f.prototype._transform = function(e, t, r) {
            throw new Error("_transform() is not implemented");
        };
        f.prototype._write = function(e, t, r) {
            var i = this._transformState;
            i.writecb = r;
            i.writechunk = e;
            i.writeencoding = t;
            if (!i.transforming) {
                var n = this._readableState;
                if (i.needTransform || n.needReadable || n.length < n.highWaterMark) this._read(n.highWaterMark);
            }
        };
        f.prototype._read = function(e) {
            var t = this._transformState;
            if (t.writechunk !== null && t.writecb && !t.transforming) {
                t.transforming = true;
                this._transform(t.writechunk, t.writeencoding, t.afterTransform);
            } else {
                t.needTransform = true;
            }
        };
        f.prototype._destroy = function(e, t) {
            var r = this;
            i.prototype._destroy.call(this, e, function(e) {
                t(e);
                r.emit("close");
            });
        };
        function o(e, t, r) {
            if (t) return e.emit("error", t);
            if (r !== null && r !== undefined) e.push(r);
            var i = e._writableState;
            var n = e._transformState;
            if (i.length) throw new Error("Calling transform done when ws.length != 0");
            if (n.transforming) throw new Error("Calling transform done when still transforming");
            return e.push(null);
        }
    }, {
        "./_stream_duplex": 141,
        "core-util-is": 63,
        inherits: 115
    } ],
    145: [ function(e, t, r) {
        (function(r, i) {
            "use strict";
            var n = e("process-nextick-args");
            t.exports = w;
            function a(e, t, r) {
                this.chunk = e;
                this.encoding = t;
                this.callback = r;
                this.next = null;
            }
            function s(e) {
                var t = this;
                this.next = null;
                this.entry = null;
                this.finish = function() {
                    q(t, e);
                };
            }
            var f = !r.browser && [ "v0.10", "v0.9." ].indexOf(r.version.slice(0, 5)) > -1 ? setImmediate : n;
            var o;
            w.WritableState = y;
            var c = e("core-util-is");
            c.inherits = e("inherits");
            var h = {
                deprecate: e("util-deprecate")
            };
            var u = e("./internal/streams/stream");
            var d = e("safe-buffer").Buffer;
            var l = i.Uint8Array || function() {};
            function p(e) {
                return d.from(e);
            }
            function b(e) {
                return d.isBuffer(e) || e instanceof l;
            }
            var v = e("./internal/streams/destroy");
            c.inherits(w, u);
            function m() {}
            function y(t, r) {
                o = o || e("./_stream_duplex");
                t = t || {};
                this.objectMode = !!t.objectMode;
                if (r instanceof o) this.objectMode = this.objectMode || !!t.writableObjectMode;
                var i = t.highWaterMark;
                var n = this.objectMode ? 16 : 16 * 1024;
                this.highWaterMark = i || i === 0 ? i : n;
                this.highWaterMark = Math.floor(this.highWaterMark);
                this.finalCalled = false;
                this.needDrain = false;
                this.ending = false;
                this.ended = false;
                this.finished = false;
                this.destroyed = false;
                var a = t.decodeStrings === false;
                this.decodeStrings = !a;
                this.defaultEncoding = t.defaultEncoding || "utf8";
                this.length = 0;
                this.writing = false;
                this.corked = 0;
                this.sync = true;
                this.bufferProcessing = false;
                this.onwrite = function(e) {
                    B(r, e);
                };
                this.writecb = null;
                this.writelen = 0;
                this.bufferedRequest = null;
                this.lastBufferedRequest = null;
                this.pendingcb = 0;
                this.prefinished = false;
                this.errorEmitted = false;
                this.bufferedRequestCount = 0;
                this.corkedRequestsFree = new s(this);
            }
            y.prototype.getBuffer = function e() {
                var t = this.bufferedRequest;
                var r = [];
                while (t) {
                    r.push(t);
                    t = t.next;
                }
                return r;
            };
            (function() {
                try {
                    Object.defineProperty(y.prototype, "buffer", {
                        get: h.deprecate(function() {
                            return this.getBuffer();
                        }, "_writableState.buffer is deprecated. Use _writableState.getBuffer " + "instead.", "DEP0003")
                    });
                } catch (e) {}
            })();
            var g;
            if (typeof Symbol === "function" && Symbol.hasInstance && typeof Function.prototype[Symbol.hasInstance] === "function") {
                g = Function.prototype[Symbol.hasInstance];
                Object.defineProperty(w, Symbol.hasInstance, {
                    value: function(e) {
                        if (g.call(this, e)) return true;
                        return e && e._writableState instanceof y;
                    }
                });
            } else {
                g = function(e) {
                    return e instanceof this;
                };
            }
            function w(t) {
                o = o || e("./_stream_duplex");
                if (!g.call(w, this) && !(this instanceof o)) {
                    return new w(t);
                }
                this._writableState = new y(t, this);
                this.writable = true;
                if (t) {
                    if (typeof t.write === "function") this._write = t.write;
                    if (typeof t.writev === "function") this._writev = t.writev;
                    if (typeof t.destroy === "function") this._destroy = t.destroy;
                    if (typeof t.final === "function") this._final = t.final;
                }
                u.call(this);
            }
            w.prototype.pipe = function() {
                this.emit("error", new Error("Cannot pipe, not readable"));
            };
            function _(e, t) {
                var r = new Error("write after end");
                e.emit("error", r);
                n(t, r);
            }
            function S(e, t, r, i) {
                var a = true;
                var s = false;
                if (r === null) {
                    s = new TypeError("May not write null values to stream");
                } else if (typeof r !== "string" && r !== undefined && !t.objectMode) {
                    s = new TypeError("Invalid non-string/buffer chunk");
                }
                if (s) {
                    e.emit("error", s);
                    n(i, s);
                    a = false;
                }
                return a;
            }
            w.prototype.write = function(e, t, r) {
                var i = this._writableState;
                var n = false;
                var a = b(e) && !i.objectMode;
                if (a && !d.isBuffer(e)) {
                    e = p(e);
                }
                if (typeof t === "function") {
                    r = t;
                    t = null;
                }
                if (a) t = "buffer"; else if (!t) t = i.defaultEncoding;
                if (typeof r !== "function") r = m;
                if (i.ended) _(this, r); else if (a || S(this, i, e, r)) {
                    i.pendingcb++;
                    n = k(this, i, a, e, t, r);
                }
                return n;
            };
            w.prototype.cork = function() {
                var e = this._writableState;
                e.corked++;
            };
            w.prototype.uncork = function() {
                var e = this._writableState;
                if (e.corked) {
                    e.corked--;
                    if (!e.writing && !e.corked && !e.finished && !e.bufferProcessing && e.bufferedRequest) C(this, e);
                }
            };
            w.prototype.setDefaultEncoding = function e(t) {
                if (typeof t === "string") t = t.toLowerCase();
                if (!([ "hex", "utf8", "utf-8", "ascii", "binary", "base64", "ucs2", "ucs-2", "utf16le", "utf-16le", "raw" ].indexOf((t + "").toLowerCase()) > -1)) throw new TypeError("Unknown encoding: " + t);
                this._writableState.defaultEncoding = t;
                return this;
            };
            function M(e, t, r) {
                if (!e.objectMode && e.decodeStrings !== false && typeof t === "string") {
                    t = d.from(t, r);
                }
                return t;
            }
            function k(e, t, r, i, n, a) {
                if (!r) {
                    var s = M(t, i, n);
                    if (i !== s) {
                        r = true;
                        n = "buffer";
                        i = s;
                    }
                }
                var f = t.objectMode ? 1 : i.length;
                t.length += f;
                var o = t.length < t.highWaterMark;
                if (!o) t.needDrain = true;
                if (t.writing || t.corked) {
                    var c = t.lastBufferedRequest;
                    t.lastBufferedRequest = {
                        chunk: i,
                        encoding: n,
                        isBuf: r,
                        callback: a,
                        next: null
                    };
                    if (c) {
                        c.next = t.lastBufferedRequest;
                    } else {
                        t.bufferedRequest = t.lastBufferedRequest;
                    }
                    t.bufferedRequestCount += 1;
                } else {
                    E(e, t, false, f, i, n, a);
                }
                return o;
            }
            function E(e, t, r, i, n, a, s) {
                t.writelen = i;
                t.writecb = s;
                t.writing = true;
                t.sync = true;
                if (r) e._writev(n, t.onwrite); else e._write(n, a, t.onwrite);
                t.sync = false;
            }
            function x(e, t, r, i, a) {
                --t.pendingcb;
                if (r) {
                    n(a, i);
                    n(D, e, t);
                    e._writableState.errorEmitted = true;
                    e.emit("error", i);
                } else {
                    a(i);
                    e._writableState.errorEmitted = true;
                    e.emit("error", i);
                    D(e, t);
                }
            }
            function A(e) {
                e.writing = false;
                e.writecb = null;
                e.length -= e.writelen;
                e.writelen = 0;
            }
            function B(e, t) {
                var r = e._writableState;
                var i = r.sync;
                var n = r.writecb;
                A(r);
                if (t) x(e, r, i, t, n); else {
                    var a = R(r);
                    if (!a && !r.corked && !r.bufferProcessing && r.bufferedRequest) {
                        C(e, r);
                    }
                    if (i) {
                        f(I, e, r, a, n);
                    } else {
                        I(e, r, a, n);
                    }
                }
            }
            function I(e, t, r, i) {
                if (!r) j(e, t);
                t.pendingcb--;
                i();
                D(e, t);
            }
            function j(e, t) {
                if (t.length === 0 && t.needDrain) {
                    t.needDrain = false;
                    e.emit("drain");
                }
            }
            function C(e, t) {
                t.bufferProcessing = true;
                var r = t.bufferedRequest;
                if (e._writev && r && r.next) {
                    var i = t.bufferedRequestCount;
                    var n = new Array(i);
                    var a = t.corkedRequestsFree;
                    a.entry = r;
                    var f = 0;
                    var o = true;
                    while (r) {
                        n[f] = r;
                        if (!r.isBuf) o = false;
                        r = r.next;
                        f += 1;
                    }
                    n.allBuffers = o;
                    E(e, t, true, t.length, n, "", a.finish);
                    t.pendingcb++;
                    t.lastBufferedRequest = null;
                    if (a.next) {
                        t.corkedRequestsFree = a.next;
                        a.next = null;
                    } else {
                        t.corkedRequestsFree = new s(t);
                    }
                } else {
                    while (r) {
                        var c = r.chunk;
                        var h = r.encoding;
                        var u = r.callback;
                        var d = t.objectMode ? 1 : c.length;
                        E(e, t, false, d, c, h, u);
                        r = r.next;
                        if (t.writing) {
                            break;
                        }
                    }
                    if (r === null) t.lastBufferedRequest = null;
                }
                t.bufferedRequestCount = 0;
                t.bufferedRequest = r;
                t.bufferProcessing = false;
            }
            w.prototype._write = function(e, t, r) {
                r(new Error("_write() is not implemented"));
            };
            w.prototype._writev = null;
            w.prototype.end = function(e, t, r) {
                var i = this._writableState;
                if (typeof e === "function") {
                    r = e;
                    e = null;
                    t = null;
                } else if (typeof t === "function") {
                    r = t;
                    t = null;
                }
                if (e !== null && e !== undefined) this.write(e, t);
                if (i.corked) {
                    i.corked = 1;
                    this.uncork();
                }
                if (!i.ending && !i.finished) L(this, i, r);
            };
            function R(e) {
                return e.ending && e.length === 0 && e.bufferedRequest === null && !e.finished && !e.writing;
            }
            function P(e, t) {
                e._final(function(r) {
                    t.pendingcb--;
                    if (r) {
                        e.emit("error", r);
                    }
                    t.prefinished = true;
                    e.emit("prefinish");
                    D(e, t);
                });
            }
            function T(e, t) {
                if (!t.prefinished && !t.finalCalled) {
                    if (typeof e._final === "function") {
                        t.pendingcb++;
                        t.finalCalled = true;
                        n(P, e, t);
                    } else {
                        t.prefinished = true;
                        e.emit("prefinish");
                    }
                }
            }
            function D(e, t) {
                var r = R(t);
                if (r) {
                    T(e, t);
                    if (t.pendingcb === 0) {
                        t.finished = true;
                        e.emit("finish");
                    }
                }
                return r;
            }
            function L(e, t, r) {
                t.ending = true;
                D(e, t);
                if (r) {
                    if (t.finished) n(r); else e.once("finish", r);
                }
                t.ended = true;
                e.writable = false;
            }
            function q(e, t, r) {
                var i = e.entry;
                e.entry = null;
                while (i) {
                    var n = i.callback;
                    t.pendingcb--;
                    n(r);
                    i = i.next;
                }
                if (t.corkedRequestsFree) {
                    t.corkedRequestsFree.next = e;
                } else {
                    t.corkedRequestsFree = e;
                }
            }
            Object.defineProperty(w.prototype, "destroyed", {
                get: function() {
                    if (this._writableState === undefined) {
                        return false;
                    }
                    return this._writableState.destroyed;
                },
                set: function(e) {
                    if (!this._writableState) {
                        return;
                    }
                    this._writableState.destroyed = e;
                }
            });
            w.prototype.destroy = v.destroy;
            w.prototype._undestroy = v.undestroy;
            w.prototype._destroy = function(e, t) {
                this.end();
                t(e);
            };
        }).call(this, e("_process"), typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {});
    }, {
        "./_stream_duplex": 141,
        "./internal/streams/destroy": 147,
        "./internal/streams/stream": 148,
        _process: 132,
        "core-util-is": 63,
        inherits: 115,
        "process-nextick-args": 131,
        "safe-buffer": 154,
        "util-deprecate": 165
    } ],
    146: [ function(e, t, r) {
        "use strict";
        function i(e, t) {
            if (!(e instanceof t)) {
                throw new TypeError("Cannot call a class as a function");
            }
        }
        var n = e("safe-buffer").Buffer;
        function a(e, t, r) {
            e.copy(t, r);
        }
        t.exports = function() {
            function e() {
                i(this, e);
                this.head = null;
                this.tail = null;
                this.length = 0;
            }
            e.prototype.push = function e(t) {
                var r = {
                    data: t,
                    next: null
                };
                if (this.length > 0) this.tail.next = r; else this.head = r;
                this.tail = r;
                ++this.length;
            };
            e.prototype.unshift = function e(t) {
                var r = {
                    data: t,
                    next: this.head
                };
                if (this.length === 0) this.tail = r;
                this.head = r;
                ++this.length;
            };
            e.prototype.shift = function e() {
                if (this.length === 0) return;
                var t = this.head.data;
                if (this.length === 1) this.head = this.tail = null; else this.head = this.head.next;
                --this.length;
                return t;
            };
            e.prototype.clear = function e() {
                this.head = this.tail = null;
                this.length = 0;
            };
            e.prototype.join = function e(t) {
                if (this.length === 0) return "";
                var r = this.head;
                var i = "" + r.data;
                while (r = r.next) {
                    i += t + r.data;
                }
                return i;
            };
            e.prototype.concat = function e(t) {
                if (this.length === 0) return n.alloc(0);
                if (this.length === 1) return this.head.data;
                var r = n.allocUnsafe(t >>> 0);
                var i = this.head;
                var s = 0;
                while (i) {
                    a(i.data, r, s);
                    s += i.data.length;
                    i = i.next;
                }
                return r;
            };
            return e;
        }();
    }, {
        "safe-buffer": 154
    } ],
    147: [ function(e, t, r) {
        "use strict";
        var i = e("process-nextick-args");
        function n(e, t) {
            var r = this;
            var n = this._readableState && this._readableState.destroyed;
            var a = this._writableState && this._writableState.destroyed;
            if (n || a) {
                if (t) {
                    t(e);
                } else if (e && (!this._writableState || !this._writableState.errorEmitted)) {
                    i(s, this, e);
                }
                return;
            }
            if (this._readableState) {
                this._readableState.destroyed = true;
            }
            if (this._writableState) {
                this._writableState.destroyed = true;
            }
            this._destroy(e || null, function(e) {
                if (!t && e) {
                    i(s, r, e);
                    if (r._writableState) {
                        r._writableState.errorEmitted = true;
                    }
                } else if (t) {
                    t(e);
                }
            });
        }
        function a() {
            if (this._readableState) {
                this._readableState.destroyed = false;
                this._readableState.reading = false;
                this._readableState.ended = false;
                this._readableState.endEmitted = false;
            }
            if (this._writableState) {
                this._writableState.destroyed = false;
                this._writableState.ended = false;
                this._writableState.ending = false;
                this._writableState.finished = false;
                this._writableState.errorEmitted = false;
            }
        }
        function s(e, t) {
            e.emit("error", t);
        }
        t.exports = {
            destroy: n,
            undestroy: a
        };
    }, {
        "process-nextick-args": 131
    } ],
    148: [ function(e, t, r) {
        t.exports = e("events").EventEmitter;
    }, {
        events: 97
    } ],
    149: [ function(e, t, r) {
        t.exports = e("./readable").PassThrough;
    }, {
        "./readable": 150
    } ],
    150: [ function(e, t, r) {
        r = t.exports = e("./lib/_stream_readable.js");
        r.Stream = r;
        r.Readable = r;
        r.Writable = e("./lib/_stream_writable.js");
        r.Duplex = e("./lib/_stream_duplex.js");
        r.Transform = e("./lib/_stream_transform.js");
        r.PassThrough = e("./lib/_stream_passthrough.js");
    }, {
        "./lib/_stream_duplex.js": 141,
        "./lib/_stream_passthrough.js": 142,
        "./lib/_stream_readable.js": 143,
        "./lib/_stream_transform.js": 144,
        "./lib/_stream_writable.js": 145
    } ],
    151: [ function(e, t, r) {
        t.exports = e("./readable").Transform;
    }, {
        "./readable": 150
    } ],
    152: [ function(e, t, r) {
        t.exports = e("./lib/_stream_writable.js");
    }, {
        "./lib/_stream_writable.js": 145
    } ],
    153: [ function(e, t, r) {
        (function(r) {
            "use strict";
            var i = e("inherits");
            var n = e("hash-base");
            function a() {
                n.call(this, 64);
                this._a = 1732584193;
                this._b = 4023233417;
                this._c = 2562383102;
                this._d = 271733878;
                this._e = 3285377520;
            }
            i(a, n);
            a.prototype._update = function() {
                var e = new Array(16);
                for (var t = 0; t < 16; ++t) e[t] = this._block.readInt32LE(t * 4);
                var r = this._a;
                var i = this._b;
                var n = this._c;
                var a = this._d;
                var d = this._e;
                r = f(r, i, n, a, d, e[0], 0, 11);
                n = s(n, 10);
                d = f(d, r, i, n, a, e[1], 0, 14);
                i = s(i, 10);
                a = f(a, d, r, i, n, e[2], 0, 15);
                r = s(r, 10);
                n = f(n, a, d, r, i, e[3], 0, 12);
                d = s(d, 10);
                i = f(i, n, a, d, r, e[4], 0, 5);
                a = s(a, 10);
                r = f(r, i, n, a, d, e[5], 0, 8);
                n = s(n, 10);
                d = f(d, r, i, n, a, e[6], 0, 7);
                i = s(i, 10);
                a = f(a, d, r, i, n, e[7], 0, 9);
                r = s(r, 10);
                n = f(n, a, d, r, i, e[8], 0, 11);
                d = s(d, 10);
                i = f(i, n, a, d, r, e[9], 0, 13);
                a = s(a, 10);
                r = f(r, i, n, a, d, e[10], 0, 14);
                n = s(n, 10);
                d = f(d, r, i, n, a, e[11], 0, 15);
                i = s(i, 10);
                a = f(a, d, r, i, n, e[12], 0, 6);
                r = s(r, 10);
                n = f(n, a, d, r, i, e[13], 0, 7);
                d = s(d, 10);
                i = f(i, n, a, d, r, e[14], 0, 9);
                a = s(a, 10);
                r = f(r, i, n, a, d, e[15], 0, 8);
                n = s(n, 10);
                d = o(d, r, i, n, a, e[7], 1518500249, 7);
                i = s(i, 10);
                a = o(a, d, r, i, n, e[4], 1518500249, 6);
                r = s(r, 10);
                n = o(n, a, d, r, i, e[13], 1518500249, 8);
                d = s(d, 10);
                i = o(i, n, a, d, r, e[1], 1518500249, 13);
                a = s(a, 10);
                r = o(r, i, n, a, d, e[10], 1518500249, 11);
                n = s(n, 10);
                d = o(d, r, i, n, a, e[6], 1518500249, 9);
                i = s(i, 10);
                a = o(a, d, r, i, n, e[15], 1518500249, 7);
                r = s(r, 10);
                n = o(n, a, d, r, i, e[3], 1518500249, 15);
                d = s(d, 10);
                i = o(i, n, a, d, r, e[12], 1518500249, 7);
                a = s(a, 10);
                r = o(r, i, n, a, d, e[0], 1518500249, 12);
                n = s(n, 10);
                d = o(d, r, i, n, a, e[9], 1518500249, 15);
                i = s(i, 10);
                a = o(a, d, r, i, n, e[5], 1518500249, 9);
                r = s(r, 10);
                n = o(n, a, d, r, i, e[2], 1518500249, 11);
                d = s(d, 10);
                i = o(i, n, a, d, r, e[14], 1518500249, 7);
                a = s(a, 10);
                r = o(r, i, n, a, d, e[11], 1518500249, 13);
                n = s(n, 10);
                d = o(d, r, i, n, a, e[8], 1518500249, 12);
                i = s(i, 10);
                a = c(a, d, r, i, n, e[3], 1859775393, 11);
                r = s(r, 10);
                n = c(n, a, d, r, i, e[10], 1859775393, 13);
                d = s(d, 10);
                i = c(i, n, a, d, r, e[14], 1859775393, 6);
                a = s(a, 10);
                r = c(r, i, n, a, d, e[4], 1859775393, 7);
                n = s(n, 10);
                d = c(d, r, i, n, a, e[9], 1859775393, 14);
                i = s(i, 10);
                a = c(a, d, r, i, n, e[15], 1859775393, 9);
                r = s(r, 10);
                n = c(n, a, d, r, i, e[8], 1859775393, 13);
                d = s(d, 10);
                i = c(i, n, a, d, r, e[1], 1859775393, 15);
                a = s(a, 10);
                r = c(r, i, n, a, d, e[2], 1859775393, 14);
                n = s(n, 10);
                d = c(d, r, i, n, a, e[7], 1859775393, 8);
                i = s(i, 10);
                a = c(a, d, r, i, n, e[0], 1859775393, 13);
                r = s(r, 10);
                n = c(n, a, d, r, i, e[6], 1859775393, 6);
                d = s(d, 10);
                i = c(i, n, a, d, r, e[13], 1859775393, 5);
                a = s(a, 10);
                r = c(r, i, n, a, d, e[11], 1859775393, 12);
                n = s(n, 10);
                d = c(d, r, i, n, a, e[5], 1859775393, 7);
                i = s(i, 10);
                a = c(a, d, r, i, n, e[12], 1859775393, 5);
                r = s(r, 10);
                n = h(n, a, d, r, i, e[1], 2400959708, 11);
                d = s(d, 10);
                i = h(i, n, a, d, r, e[9], 2400959708, 12);
                a = s(a, 10);
                r = h(r, i, n, a, d, e[11], 2400959708, 14);
                n = s(n, 10);
                d = h(d, r, i, n, a, e[10], 2400959708, 15);
                i = s(i, 10);
                a = h(a, d, r, i, n, e[0], 2400959708, 14);
                r = s(r, 10);
                n = h(n, a, d, r, i, e[8], 2400959708, 15);
                d = s(d, 10);
                i = h(i, n, a, d, r, e[12], 2400959708, 9);
                a = s(a, 10);
                r = h(r, i, n, a, d, e[4], 2400959708, 8);
                n = s(n, 10);
                d = h(d, r, i, n, a, e[13], 2400959708, 9);
                i = s(i, 10);
                a = h(a, d, r, i, n, e[3], 2400959708, 14);
                r = s(r, 10);
                n = h(n, a, d, r, i, e[7], 2400959708, 5);
                d = s(d, 10);
                i = h(i, n, a, d, r, e[15], 2400959708, 6);
                a = s(a, 10);
                r = h(r, i, n, a, d, e[14], 2400959708, 8);
                n = s(n, 10);
                d = h(d, r, i, n, a, e[5], 2400959708, 6);
                i = s(i, 10);
                a = h(a, d, r, i, n, e[6], 2400959708, 5);
                r = s(r, 10);
                n = h(n, a, d, r, i, e[2], 2400959708, 12);
                d = s(d, 10);
                i = u(i, n, a, d, r, e[4], 2840853838, 9);
                a = s(a, 10);
                r = u(r, i, n, a, d, e[0], 2840853838, 15);
                n = s(n, 10);
                d = u(d, r, i, n, a, e[5], 2840853838, 5);
                i = s(i, 10);
                a = u(a, d, r, i, n, e[9], 2840853838, 11);
                r = s(r, 10);
                n = u(n, a, d, r, i, e[7], 2840853838, 6);
                d = s(d, 10);
                i = u(i, n, a, d, r, e[12], 2840853838, 8);
                a = s(a, 10);
                r = u(r, i, n, a, d, e[2], 2840853838, 13);
                n = s(n, 10);
                d = u(d, r, i, n, a, e[10], 2840853838, 12);
                i = s(i, 10);
                a = u(a, d, r, i, n, e[14], 2840853838, 5);
                r = s(r, 10);
                n = u(n, a, d, r, i, e[1], 2840853838, 12);
                d = s(d, 10);
                i = u(i, n, a, d, r, e[3], 2840853838, 13);
                a = s(a, 10);
                r = u(r, i, n, a, d, e[8], 2840853838, 14);
                n = s(n, 10);
                d = u(d, r, i, n, a, e[11], 2840853838, 11);
                i = s(i, 10);
                a = u(a, d, r, i, n, e[6], 2840853838, 8);
                r = s(r, 10);
                n = u(n, a, d, r, i, e[15], 2840853838, 5);
                d = s(d, 10);
                i = u(i, n, a, d, r, e[13], 2840853838, 6);
                a = s(a, 10);
                var l = this._a;
                var p = this._b;
                var b = this._c;
                var v = this._d;
                var m = this._e;
                l = u(l, p, b, v, m, e[5], 1352829926, 8);
                b = s(b, 10);
                m = u(m, l, p, b, v, e[14], 1352829926, 9);
                p = s(p, 10);
                v = u(v, m, l, p, b, e[7], 1352829926, 9);
                l = s(l, 10);
                b = u(b, v, m, l, p, e[0], 1352829926, 11);
                m = s(m, 10);
                p = u(p, b, v, m, l, e[9], 1352829926, 13);
                v = s(v, 10);
                l = u(l, p, b, v, m, e[2], 1352829926, 15);
                b = s(b, 10);
                m = u(m, l, p, b, v, e[11], 1352829926, 15);
                p = s(p, 10);
                v = u(v, m, l, p, b, e[4], 1352829926, 5);
                l = s(l, 10);
                b = u(b, v, m, l, p, e[13], 1352829926, 7);
                m = s(m, 10);
                p = u(p, b, v, m, l, e[6], 1352829926, 7);
                v = s(v, 10);
                l = u(l, p, b, v, m, e[15], 1352829926, 8);
                b = s(b, 10);
                m = u(m, l, p, b, v, e[8], 1352829926, 11);
                p = s(p, 10);
                v = u(v, m, l, p, b, e[1], 1352829926, 14);
                l = s(l, 10);
                b = u(b, v, m, l, p, e[10], 1352829926, 14);
                m = s(m, 10);
                p = u(p, b, v, m, l, e[3], 1352829926, 12);
                v = s(v, 10);
                l = u(l, p, b, v, m, e[12], 1352829926, 6);
                b = s(b, 10);
                m = h(m, l, p, b, v, e[6], 1548603684, 9);
                p = s(p, 10);
                v = h(v, m, l, p, b, e[11], 1548603684, 13);
                l = s(l, 10);
                b = h(b, v, m, l, p, e[3], 1548603684, 15);
                m = s(m, 10);
                p = h(p, b, v, m, l, e[7], 1548603684, 7);
                v = s(v, 10);
                l = h(l, p, b, v, m, e[0], 1548603684, 12);
                b = s(b, 10);
                m = h(m, l, p, b, v, e[13], 1548603684, 8);
                p = s(p, 10);
                v = h(v, m, l, p, b, e[5], 1548603684, 9);
                l = s(l, 10);
                b = h(b, v, m, l, p, e[10], 1548603684, 11);
                m = s(m, 10);
                p = h(p, b, v, m, l, e[14], 1548603684, 7);
                v = s(v, 10);
                l = h(l, p, b, v, m, e[15], 1548603684, 7);
                b = s(b, 10);
                m = h(m, l, p, b, v, e[8], 1548603684, 12);
                p = s(p, 10);
                v = h(v, m, l, p, b, e[12], 1548603684, 7);
                l = s(l, 10);
                b = h(b, v, m, l, p, e[4], 1548603684, 6);
                m = s(m, 10);
                p = h(p, b, v, m, l, e[9], 1548603684, 15);
                v = s(v, 10);
                l = h(l, p, b, v, m, e[1], 1548603684, 13);
                b = s(b, 10);
                m = h(m, l, p, b, v, e[2], 1548603684, 11);
                p = s(p, 10);
                v = c(v, m, l, p, b, e[15], 1836072691, 9);
                l = s(l, 10);
                b = c(b, v, m, l, p, e[5], 1836072691, 7);
                m = s(m, 10);
                p = c(p, b, v, m, l, e[1], 1836072691, 15);
                v = s(v, 10);
                l = c(l, p, b, v, m, e[3], 1836072691, 11);
                b = s(b, 10);
                m = c(m, l, p, b, v, e[7], 1836072691, 8);
                p = s(p, 10);
                v = c(v, m, l, p, b, e[14], 1836072691, 6);
                l = s(l, 10);
                b = c(b, v, m, l, p, e[6], 1836072691, 6);
                m = s(m, 10);
                p = c(p, b, v, m, l, e[9], 1836072691, 14);
                v = s(v, 10);
                l = c(l, p, b, v, m, e[11], 1836072691, 12);
                b = s(b, 10);
                m = c(m, l, p, b, v, e[8], 1836072691, 13);
                p = s(p, 10);
                v = c(v, m, l, p, b, e[12], 1836072691, 5);
                l = s(l, 10);
                b = c(b, v, m, l, p, e[2], 1836072691, 14);
                m = s(m, 10);
                p = c(p, b, v, m, l, e[10], 1836072691, 13);
                v = s(v, 10);
                l = c(l, p, b, v, m, e[0], 1836072691, 13);
                b = s(b, 10);
                m = c(m, l, p, b, v, e[4], 1836072691, 7);
                p = s(p, 10);
                v = c(v, m, l, p, b, e[13], 1836072691, 5);
                l = s(l, 10);
                b = o(b, v, m, l, p, e[8], 2053994217, 15);
                m = s(m, 10);
                p = o(p, b, v, m, l, e[6], 2053994217, 5);
                v = s(v, 10);
                l = o(l, p, b, v, m, e[4], 2053994217, 8);
                b = s(b, 10);
                m = o(m, l, p, b, v, e[1], 2053994217, 11);
                p = s(p, 10);
                v = o(v, m, l, p, b, e[3], 2053994217, 14);
                l = s(l, 10);
                b = o(b, v, m, l, p, e[11], 2053994217, 14);
                m = s(m, 10);
                p = o(p, b, v, m, l, e[15], 2053994217, 6);
                v = s(v, 10);
                l = o(l, p, b, v, m, e[0], 2053994217, 14);
                b = s(b, 10);
                m = o(m, l, p, b, v, e[5], 2053994217, 6);
                p = s(p, 10);
                v = o(v, m, l, p, b, e[12], 2053994217, 9);
                l = s(l, 10);
                b = o(b, v, m, l, p, e[2], 2053994217, 12);
                m = s(m, 10);
                p = o(p, b, v, m, l, e[13], 2053994217, 9);
                v = s(v, 10);
                l = o(l, p, b, v, m, e[9], 2053994217, 12);
                b = s(b, 10);
                m = o(m, l, p, b, v, e[7], 2053994217, 5);
                p = s(p, 10);
                v = o(v, m, l, p, b, e[10], 2053994217, 15);
                l = s(l, 10);
                b = o(b, v, m, l, p, e[14], 2053994217, 8);
                m = s(m, 10);
                p = f(p, b, v, m, l, e[12], 0, 8);
                v = s(v, 10);
                l = f(l, p, b, v, m, e[15], 0, 5);
                b = s(b, 10);
                m = f(m, l, p, b, v, e[10], 0, 12);
                p = s(p, 10);
                v = f(v, m, l, p, b, e[4], 0, 9);
                l = s(l, 10);
                b = f(b, v, m, l, p, e[1], 0, 12);
                m = s(m, 10);
                p = f(p, b, v, m, l, e[5], 0, 5);
                v = s(v, 10);
                l = f(l, p, b, v, m, e[8], 0, 14);
                b = s(b, 10);
                m = f(m, l, p, b, v, e[7], 0, 6);
                p = s(p, 10);
                v = f(v, m, l, p, b, e[6], 0, 8);
                l = s(l, 10);
                b = f(b, v, m, l, p, e[2], 0, 13);
                m = s(m, 10);
                p = f(p, b, v, m, l, e[13], 0, 6);
                v = s(v, 10);
                l = f(l, p, b, v, m, e[14], 0, 5);
                b = s(b, 10);
                m = f(m, l, p, b, v, e[0], 0, 15);
                p = s(p, 10);
                v = f(v, m, l, p, b, e[3], 0, 13);
                l = s(l, 10);
                b = f(b, v, m, l, p, e[9], 0, 11);
                m = s(m, 10);
                p = f(p, b, v, m, l, e[11], 0, 11);
                v = s(v, 10);
                var y = this._b + n + v | 0;
                this._b = this._c + a + m | 0;
                this._c = this._d + d + l | 0;
                this._d = this._e + r + p | 0;
                this._e = this._a + i + b | 0;
                this._a = y;
            };
            a.prototype._digest = function() {
                this._block[this._blockOffset++] = 128;
                if (this._blockOffset > 56) {
                    this._block.fill(0, this._blockOffset, 64);
                    this._update();
                    this._blockOffset = 0;
                }
                this._block.fill(0, this._blockOffset, 56);
                this._block.writeUInt32LE(this._length[0], 56);
                this._block.writeUInt32LE(this._length[1], 60);
                this._update();
                var e = new r(20);
                e.writeInt32LE(this._a, 0);
                e.writeInt32LE(this._b, 4);
                e.writeInt32LE(this._c, 8);
                e.writeInt32LE(this._d, 12);
                e.writeInt32LE(this._e, 16);
                return e;
            };
            function s(e, t) {
                return e << t | e >>> 32 - t;
            }
            function f(e, t, r, i, n, a, f, o) {
                return s(e + (t ^ r ^ i) + a + f | 0, o) + n | 0;
            }
            function o(e, t, r, i, n, a, f, o) {
                return s(e + (t & r | ~t & i) + a + f | 0, o) + n | 0;
            }
            function c(e, t, r, i, n, a, f, o) {
                return s(e + ((t | ~r) ^ i) + a + f | 0, o) + n | 0;
            }
            function h(e, t, r, i, n, a, f, o) {
                return s(e + (t & i | r & ~i) + a + f | 0, o) + n | 0;
            }
            function u(e, t, r, i, n, a, f, o) {
                return s(e + (t ^ (r | ~i)) + a + f | 0, o) + n | 0;
            }
            t.exports = a;
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61,
        "hash-base": 99,
        inherits: 115
    } ],
    154: [ function(e, t, r) {
        var i = e("buffer");
        var n = i.Buffer;
        function a(e, t) {
            for (var r in e) {
                t[r] = e[r];
            }
        }
        if (n.from && n.alloc && n.allocUnsafe && n.allocUnsafeSlow) {
            t.exports = i;
        } else {
            a(i, r);
            r.Buffer = s;
        }
        function s(e, t, r) {
            return n(e, t, r);
        }
        a(n, s);
        s.from = function(e, t, r) {
            if (typeof e === "number") {
                throw new TypeError("Argument must not be a number");
            }
            return n(e, t, r);
        };
        s.alloc = function(e, t, r) {
            if (typeof e !== "number") {
                throw new TypeError("Argument must be a number");
            }
            var i = n(e);
            if (t !== undefined) {
                if (typeof r === "string") {
                    i.fill(t, r);
                } else {
                    i.fill(t);
                }
            } else {
                i.fill(0);
            }
            return i;
        };
        s.allocUnsafe = function(e) {
            if (typeof e !== "number") {
                throw new TypeError("Argument must be a number");
            }
            return n(e);
        };
        s.allocUnsafeSlow = function(e) {
            if (typeof e !== "number") {
                throw new TypeError("Argument must be a number");
            }
            return i.SlowBuffer(e);
        };
    }, {
        buffer: 61
    } ],
    155: [ function(e, t, r) {
        (function(e) {
            function r(t, r) {
                this._block = new e(t);
                this._finalSize = r;
                this._blockSize = t;
                this._len = 0;
                this._s = 0;
            }
            r.prototype.update = function(t, r) {
                if (typeof t === "string") {
                    r = r || "utf8";
                    t = new e(t, r);
                }
                var i = this._len += t.length;
                var n = this._s || 0;
                var a = 0;
                var s = this._block;
                while (n < i) {
                    var f = Math.min(t.length, a + this._blockSize - n % this._blockSize);
                    var o = f - a;
                    for (var c = 0; c < o; c++) {
                        s[n % this._blockSize + c] = t[c + a];
                    }
                    n += o;
                    a += o;
                    if (n % this._blockSize === 0) {
                        this._update(s);
                    }
                }
                this._s = n;
                return this;
            };
            r.prototype.digest = function(e) {
                var t = this._len * 8;
                this._block[this._len % this._blockSize] = 128;
                this._block.fill(0, this._len % this._blockSize + 1);
                if (t % (this._blockSize * 8) >= this._finalSize * 8) {
                    this._update(this._block);
                    this._block.fill(0);
                }
                this._block.writeInt32BE(t, this._blockSize - 4);
                var r = this._update(this._block) || this._hash();
                return e ? r.toString(e) : r;
            };
            r.prototype._update = function() {
                throw new Error("_update must be implemented by subclass");
            };
            t.exports = r;
        }).call(this, e("buffer").Buffer);
    }, {
        buffer: 61
    } ],
    156: [ function(e, t, r) {
        var r = t.exports = function e(t) {
            t = t.toLowerCase();
            var i = r[t];
            if (!i) throw new Error(t + " is not supported (we accept pull requests)");
            return new i();
        };
        r.sha = e("./sha");
        r.sha1 = e("./sha1");
        r.sha224 = e("./sha224");
        r.sha256 = e("./sha256");
        r.sha384 = e("./sha384");
        r.sha512 = e("./sha512");
    }, {
        "./sha": 157,
        "./sha1": 158,
        "./sha224": 159,
        "./sha256": 160,
        "./sha384": 161,
        "./sha512": 162
    } ],
    157: [ function(e, t, r) {
        (function(r) {
            var i = e("inherits");
            var n = e("./hash");
            var a = [ 1518500249, 1859775393, 2400959708 | 0, 3395469782 | 0 ];
            var s = new Array(80);
            function f() {
                this.init();
                this._w = s;
                n.call(this, 64, 56);
            }
            i(f, n);
            f.prototype.init = function() {
                this._a = 1732584193;
                this._b = 4023233417;
                this._c = 2562383102;
                this._d = 271733878;
                this._e = 3285377520;
                return this;
            };
            function o(e) {
                return e << 5 | e >>> 27;
            }
            function c(e) {
                return e << 30 | e >>> 2;
            }
            function h(e, t, r, i) {
                if (e === 0) return t & r | ~t & i;
                if (e === 2) return t & r | t & i | r & i;
                return t ^ r ^ i;
            }
            f.prototype._update = function(e) {
                var t = this._w;
                var r = this._a | 0;
                var i = this._b | 0;
                var n = this._c | 0;
                var s = this._d | 0;
                var f = this._e | 0;
                for (var u = 0; u < 16; ++u) t[u] = e.readInt32BE(u * 4);
                for (;u < 80; ++u) t[u] = t[u - 3] ^ t[u - 8] ^ t[u - 14] ^ t[u - 16];
                for (var d = 0; d < 80; ++d) {
                    var l = ~~(d / 20);
                    var p = o(r) + h(l, i, n, s) + f + t[d] + a[l] | 0;
                    f = s;
                    s = n;
                    n = c(i);
                    i = r;
                    r = p;
                }
                this._a = r + this._a | 0;
                this._b = i + this._b | 0;
                this._c = n + this._c | 0;
                this._d = s + this._d | 0;
                this._e = f + this._e | 0;
            };
            f.prototype._hash = function() {
                var e = new r(20);
                e.writeInt32BE(this._a | 0, 0);
                e.writeInt32BE(this._b | 0, 4);
                e.writeInt32BE(this._c | 0, 8);
                e.writeInt32BE(this._d | 0, 12);
                e.writeInt32BE(this._e | 0, 16);
                return e;
            };
            t.exports = f;
        }).call(this, e("buffer").Buffer);
    }, {
        "./hash": 155,
        buffer: 61,
        inherits: 115
    } ],
    158: [ function(e, t, r) {
        (function(r) {
            var i = e("inherits");
            var n = e("./hash");
            var a = [ 1518500249, 1859775393, 2400959708 | 0, 3395469782 | 0 ];
            var s = new Array(80);
            function f() {
                this.init();
                this._w = s;
                n.call(this, 64, 56);
            }
            i(f, n);
            f.prototype.init = function() {
                this._a = 1732584193;
                this._b = 4023233417;
                this._c = 2562383102;
                this._d = 271733878;
                this._e = 3285377520;
                return this;
            };
            function o(e) {
                return e << 1 | e >>> 31;
            }
            function c(e) {
                return e << 5 | e >>> 27;
            }
            function h(e) {
                return e << 30 | e >>> 2;
            }
            function u(e, t, r, i) {
                if (e === 0) return t & r | ~t & i;
                if (e === 2) return t & r | t & i | r & i;
                return t ^ r ^ i;
            }
            f.prototype._update = function(e) {
                var t = this._w;
                var r = this._a | 0;
                var i = this._b | 0;
                var n = this._c | 0;
                var s = this._d | 0;
                var f = this._e | 0;
                for (var d = 0; d < 16; ++d) t[d] = e.readInt32BE(d * 4);
                for (;d < 80; ++d) t[d] = o(t[d - 3] ^ t[d - 8] ^ t[d - 14] ^ t[d - 16]);
                for (var l = 0; l < 80; ++l) {
                    var p = ~~(l / 20);
                    var b = c(r) + u(p, i, n, s) + f + t[l] + a[p] | 0;
                    f = s;
                    s = n;
                    n = h(i);
                    i = r;
                    r = b;
                }
                this._a = r + this._a | 0;
                this._b = i + this._b | 0;
                this._c = n + this._c | 0;
                this._d = s + this._d | 0;
                this._e = f + this._e | 0;
            };
            f.prototype._hash = function() {
                var e = new r(20);
                e.writeInt32BE(this._a | 0, 0);
                e.writeInt32BE(this._b | 0, 4);
                e.writeInt32BE(this._c | 0, 8);
                e.writeInt32BE(this._d | 0, 12);
                e.writeInt32BE(this._e | 0, 16);
                return e;
            };
            t.exports = f;
        }).call(this, e("buffer").Buffer);
    }, {
        "./hash": 155,
        buffer: 61,
        inherits: 115
    } ],
    159: [ function(e, t, r) {
        (function(r) {
            var i = e("inherits");
            var n = e("./sha256");
            var a = e("./hash");
            var s = new Array(64);
            function f() {
                this.init();
                this._w = s;
                a.call(this, 64, 56);
            }
            i(f, n);
            f.prototype.init = function() {
                this._a = 3238371032;
                this._b = 914150663;
                this._c = 812702999;
                this._d = 4144912697;
                this._e = 4290775857;
                this._f = 1750603025;
                this._g = 1694076839;
                this._h = 3204075428;
                return this;
            };
            f.prototype._hash = function() {
                var e = new r(28);
                e.writeInt32BE(this._a, 0);
                e.writeInt32BE(this._b, 4);
                e.writeInt32BE(this._c, 8);
                e.writeInt32BE(this._d, 12);
                e.writeInt32BE(this._e, 16);
                e.writeInt32BE(this._f, 20);
                e.writeInt32BE(this._g, 24);
                return e;
            };
            t.exports = f;
        }).call(this, e("buffer").Buffer);
    }, {
        "./hash": 155,
        "./sha256": 160,
        buffer: 61,
        inherits: 115
    } ],
    160: [ function(e, t, r) {
        (function(r) {
            var i = e("inherits");
            var n = e("./hash");
            var a = [ 1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298 ];
            var s = new Array(64);
            function f() {
                this.init();
                this._w = s;
                n.call(this, 64, 56);
            }
            i(f, n);
            f.prototype.init = function() {
                this._a = 1779033703;
                this._b = 3144134277;
                this._c = 1013904242;
                this._d = 2773480762;
                this._e = 1359893119;
                this._f = 2600822924;
                this._g = 528734635;
                this._h = 1541459225;
                return this;
            };
            function o(e, t, r) {
                return r ^ e & (t ^ r);
            }
            function c(e, t, r) {
                return e & t | r & (e | t);
            }
            function h(e) {
                return (e >>> 2 | e << 30) ^ (e >>> 13 | e << 19) ^ (e >>> 22 | e << 10);
            }
            function u(e) {
                return (e >>> 6 | e << 26) ^ (e >>> 11 | e << 21) ^ (e >>> 25 | e << 7);
            }
            function d(e) {
                return (e >>> 7 | e << 25) ^ (e >>> 18 | e << 14) ^ e >>> 3;
            }
            function l(e) {
                return (e >>> 17 | e << 15) ^ (e >>> 19 | e << 13) ^ e >>> 10;
            }
            f.prototype._update = function(e) {
                var t = this._w;
                var r = this._a | 0;
                var i = this._b | 0;
                var n = this._c | 0;
                var s = this._d | 0;
                var f = this._e | 0;
                var p = this._f | 0;
                var b = this._g | 0;
                var v = this._h | 0;
                for (var m = 0; m < 16; ++m) t[m] = e.readInt32BE(m * 4);
                for (;m < 64; ++m) t[m] = l(t[m - 2]) + t[m - 7] + d(t[m - 15]) + t[m - 16] | 0;
                for (var y = 0; y < 64; ++y) {
                    var g = v + u(f) + o(f, p, b) + a[y] + t[y] | 0;
                    var w = h(r) + c(r, i, n) | 0;
                    v = b;
                    b = p;
                    p = f;
                    f = s + g | 0;
                    s = n;
                    n = i;
                    i = r;
                    r = g + w | 0;
                }
                this._a = r + this._a | 0;
                this._b = i + this._b | 0;
                this._c = n + this._c | 0;
                this._d = s + this._d | 0;
                this._e = f + this._e | 0;
                this._f = p + this._f | 0;
                this._g = b + this._g | 0;
                this._h = v + this._h | 0;
            };
            f.prototype._hash = function() {
                var e = new r(32);
                e.writeInt32BE(this._a, 0);
                e.writeInt32BE(this._b, 4);
                e.writeInt32BE(this._c, 8);
                e.writeInt32BE(this._d, 12);
                e.writeInt32BE(this._e, 16);
                e.writeInt32BE(this._f, 20);
                e.writeInt32BE(this._g, 24);
                e.writeInt32BE(this._h, 28);
                return e;
            };
            t.exports = f;
        }).call(this, e("buffer").Buffer);
    }, {
        "./hash": 155,
        buffer: 61,
        inherits: 115
    } ],
    161: [ function(e, t, r) {
        (function(r) {
            var i = e("inherits");
            var n = e("./sha512");
            var a = e("./hash");
            var s = new Array(160);
            function f() {
                this.init();
                this._w = s;
                a.call(this, 128, 112);
            }
            i(f, n);
            f.prototype.init = function() {
                this._ah = 3418070365;
                this._bh = 1654270250;
                this._ch = 2438529370;
                this._dh = 355462360;
                this._eh = 1731405415;
                this._fh = 2394180231;
                this._gh = 3675008525;
                this._hh = 1203062813;
                this._al = 3238371032;
                this._bl = 914150663;
                this._cl = 812702999;
                this._dl = 4144912697;
                this._el = 4290775857;
                this._fl = 1750603025;
                this._gl = 1694076839;
                this._hl = 3204075428;
                return this;
            };
            f.prototype._hash = function() {
                var e = new r(48);
                function t(t, r, i) {
                    e.writeInt32BE(t, i);
                    e.writeInt32BE(r, i + 4);
                }
                t(this._ah, this._al, 0);
                t(this._bh, this._bl, 8);
                t(this._ch, this._cl, 16);
                t(this._dh, this._dl, 24);
                t(this._eh, this._el, 32);
                t(this._fh, this._fl, 40);
                return e;
            };
            t.exports = f;
        }).call(this, e("buffer").Buffer);
    }, {
        "./hash": 155,
        "./sha512": 162,
        buffer: 61,
        inherits: 115
    } ],
    162: [ function(e, t, r) {
        (function(r) {
            var i = e("inherits");
            var n = e("./hash");
            var a = [ 1116352408, 3609767458, 1899447441, 602891725, 3049323471, 3964484399, 3921009573, 2173295548, 961987163, 4081628472, 1508970993, 3053834265, 2453635748, 2937671579, 2870763221, 3664609560, 3624381080, 2734883394, 310598401, 1164996542, 607225278, 1323610764, 1426881987, 3590304994, 1925078388, 4068182383, 2162078206, 991336113, 2614888103, 633803317, 3248222580, 3479774868, 3835390401, 2666613458, 4022224774, 944711139, 264347078, 2341262773, 604807628, 2007800933, 770255983, 1495990901, 1249150122, 1856431235, 1555081692, 3175218132, 1996064986, 2198950837, 2554220882, 3999719339, 2821834349, 766784016, 2952996808, 2566594879, 3210313671, 3203337956, 3336571891, 1034457026, 3584528711, 2466948901, 113926993, 3758326383, 338241895, 168717936, 666307205, 1188179964, 773529912, 1546045734, 1294757372, 1522805485, 1396182291, 2643833823, 1695183700, 2343527390, 1986661051, 1014477480, 2177026350, 1206759142, 2456956037, 344077627, 2730485921, 1290863460, 2820302411, 3158454273, 3259730800, 3505952657, 3345764771, 106217008, 3516065817, 3606008344, 3600352804, 1432725776, 4094571909, 1467031594, 275423344, 851169720, 430227734, 3100823752, 506948616, 1363258195, 659060556, 3750685593, 883997877, 3785050280, 958139571, 3318307427, 1322822218, 3812723403, 1537002063, 2003034995, 1747873779, 3602036899, 1955562222, 1575990012, 2024104815, 1125592928, 2227730452, 2716904306, 2361852424, 442776044, 2428436474, 593698344, 2756734187, 3733110249, 3204031479, 2999351573, 3329325298, 3815920427, 3391569614, 3928383900, 3515267271, 566280711, 3940187606, 3454069534, 4118630271, 4000239992, 116418474, 1914138554, 174292421, 2731055270, 289380356, 3203993006, 460393269, 320620315, 685471733, 587496836, 852142971, 1086792851, 1017036298, 365543100, 1126000580, 2618297676, 1288033470, 3409855158, 1501505948, 4234509866, 1607167915, 987167468, 1816402316, 1246189591 ];
            var s = new Array(160);
            function f() {
                this.init();
                this._w = s;
                n.call(this, 128, 112);
            }
            i(f, n);
            f.prototype.init = function() {
                this._ah = 1779033703;
                this._bh = 3144134277;
                this._ch = 1013904242;
                this._dh = 2773480762;
                this._eh = 1359893119;
                this._fh = 2600822924;
                this._gh = 528734635;
                this._hh = 1541459225;
                this._al = 4089235720;
                this._bl = 2227873595;
                this._cl = 4271175723;
                this._dl = 1595750129;
                this._el = 2917565137;
                this._fl = 725511199;
                this._gl = 4215389547;
                this._hl = 327033209;
                return this;
            };
            function o(e, t, r) {
                return r ^ e & (t ^ r);
            }
            function c(e, t, r) {
                return e & t | r & (e | t);
            }
            function h(e, t) {
                return (e >>> 28 | t << 4) ^ (t >>> 2 | e << 30) ^ (t >>> 7 | e << 25);
            }
            function u(e, t) {
                return (e >>> 14 | t << 18) ^ (e >>> 18 | t << 14) ^ (t >>> 9 | e << 23);
            }
            function d(e, t) {
                return (e >>> 1 | t << 31) ^ (e >>> 8 | t << 24) ^ e >>> 7;
            }
            function l(e, t) {
                return (e >>> 1 | t << 31) ^ (e >>> 8 | t << 24) ^ (e >>> 7 | t << 25);
            }
            function p(e, t) {
                return (e >>> 19 | t << 13) ^ (t >>> 29 | e << 3) ^ e >>> 6;
            }
            function b(e, t) {
                return (e >>> 19 | t << 13) ^ (t >>> 29 | e << 3) ^ (e >>> 6 | t << 26);
            }
            function v(e, t) {
                return e >>> 0 < t >>> 0 ? 1 : 0;
            }
            f.prototype._update = function(e) {
                var t = this._w;
                var r = this._ah | 0;
                var i = this._bh | 0;
                var n = this._ch | 0;
                var s = this._dh | 0;
                var f = this._eh | 0;
                var m = this._fh | 0;
                var y = this._gh | 0;
                var g = this._hh | 0;
                var w = this._al | 0;
                var _ = this._bl | 0;
                var S = this._cl | 0;
                var M = this._dl | 0;
                var k = this._el | 0;
                var E = this._fl | 0;
                var x = this._gl | 0;
                var A = this._hl | 0;
                for (var B = 0; B < 32; B += 2) {
                    t[B] = e.readInt32BE(B * 4);
                    t[B + 1] = e.readInt32BE(B * 4 + 4);
                }
                for (;B < 160; B += 2) {
                    var I = t[B - 15 * 2];
                    var j = t[B - 15 * 2 + 1];
                    var C = d(I, j);
                    var R = l(j, I);
                    I = t[B - 2 * 2];
                    j = t[B - 2 * 2 + 1];
                    var P = p(I, j);
                    var T = b(j, I);
                    var D = t[B - 7 * 2];
                    var L = t[B - 7 * 2 + 1];
                    var q = t[B - 16 * 2];
                    var N = t[B - 16 * 2 + 1];
                    var O = R + L | 0;
                    var z = C + D + v(O, R) | 0;
                    O = O + T | 0;
                    z = z + P + v(O, T) | 0;
                    O = O + N | 0;
                    z = z + q + v(O, N) | 0;
                    t[B] = z;
                    t[B + 1] = O;
                }
                for (var U = 0; U < 160; U += 2) {
                    z = t[U];
                    O = t[U + 1];
                    var K = c(r, i, n);
                    var F = c(w, _, S);
                    var H = h(r, w);
                    var W = h(w, r);
                    var V = u(f, k);
                    var X = u(k, f);
                    var Z = a[U];
                    var J = a[U + 1];
                    var Y = o(f, m, y);
                    var G = o(k, E, x);
                    var $ = A + X | 0;
                    var Q = g + V + v($, A) | 0;
                    $ = $ + G | 0;
                    Q = Q + Y + v($, G) | 0;
                    $ = $ + J | 0;
                    Q = Q + Z + v($, J) | 0;
                    $ = $ + O | 0;
                    Q = Q + z + v($, O) | 0;
                    var ee = W + F | 0;
                    var te = H + K + v(ee, W) | 0;
                    g = y;
                    A = x;
                    y = m;
                    x = E;
                    m = f;
                    E = k;
                    k = M + $ | 0;
                    f = s + Q + v(k, M) | 0;
                    s = n;
                    M = S;
                    n = i;
                    S = _;
                    i = r;
                    _ = w;
                    w = $ + ee | 0;
                    r = Q + te + v(w, $) | 0;
                }
                this._al = this._al + w | 0;
                this._bl = this._bl + _ | 0;
                this._cl = this._cl + S | 0;
                this._dl = this._dl + M | 0;
                this._el = this._el + k | 0;
                this._fl = this._fl + E | 0;
                this._gl = this._gl + x | 0;
                this._hl = this._hl + A | 0;
                this._ah = this._ah + r + v(this._al, w) | 0;
                this._bh = this._bh + i + v(this._bl, _) | 0;
                this._ch = this._ch + n + v(this._cl, S) | 0;
                this._dh = this._dh + s + v(this._dl, M) | 0;
                this._eh = this._eh + f + v(this._el, k) | 0;
                this._fh = this._fh + m + v(this._fl, E) | 0;
                this._gh = this._gh + y + v(this._gl, x) | 0;
                this._hh = this._hh + g + v(this._hl, A) | 0;
            };
            f.prototype._hash = function() {
                var e = new r(64);
                function t(t, r, i) {
                    e.writeInt32BE(t, i);
                    e.writeInt32BE(r, i + 4);
                }
                t(this._ah, this._al, 0);
                t(this._bh, this._bl, 8);
                t(this._ch, this._cl, 16);
                t(this._dh, this._dl, 24);
                t(this._eh, this._el, 32);
                t(this._fh, this._fl, 40);
                t(this._gh, this._gl, 48);
                t(this._hh, this._hl, 56);
                return e;
            };
            t.exports = f;
        }).call(this, e("buffer").Buffer);
    }, {
        "./hash": 155,
        buffer: 61,
        inherits: 115
    } ],
    163: [ function(e, t, r) {
        t.exports = a;
        var i = e("events").EventEmitter;
        var n = e("inherits");
        n(a, i);
        a.Readable = e("readable-stream/readable.js");
        a.Writable = e("readable-stream/writable.js");
        a.Duplex = e("readable-stream/duplex.js");
        a.Transform = e("readable-stream/transform.js");
        a.PassThrough = e("readable-stream/passthrough.js");
        a.Stream = a;
        function a() {
            i.call(this);
        }
        a.prototype.pipe = function(e, t) {
            var r = this;
            function n(t) {
                if (e.writable) {
                    if (false === e.write(t) && r.pause) {
                        r.pause();
                    }
                }
            }
            r.on("data", n);
            function a() {
                if (r.readable && r.resume) {
                    r.resume();
                }
            }
            e.on("drain", a);
            if (!e._isStdio && (!t || t.end !== false)) {
                r.on("end", f);
                r.on("close", o);
            }
            var s = false;
            function f() {
                if (s) return;
                s = true;
                e.end();
            }
            function o() {
                if (s) return;
                s = true;
                if (typeof e.destroy === "function") e.destroy();
            }
            function c(e) {
                h();
                if (i.listenerCount(this, "error") === 0) {
                    throw e;
                }
            }
            r.on("error", c);
            e.on("error", c);
            function h() {
                r.removeListener("data", n);
                e.removeListener("drain", a);
                r.removeListener("end", f);
                r.removeListener("close", o);
                r.removeListener("error", c);
                e.removeListener("error", c);
                r.removeListener("end", h);
                r.removeListener("close", h);
                e.removeListener("close", h);
            }
            r.on("end", h);
            r.on("close", h);
            e.on("close", h);
            e.emit("pipe", r);
            return e;
        };
    }, {
        events: 97,
        inherits: 115,
        "readable-stream/duplex.js": 140,
        "readable-stream/passthrough.js": 149,
        "readable-stream/readable.js": 150,
        "readable-stream/transform.js": 151,
        "readable-stream/writable.js": 152
    } ],
    164: [ function(e, t, r) {
        "use strict";
        var i = e("safe-buffer").Buffer;
        var n = i.isEncoding || function(e) {
            e = "" + e;
            switch (e && e.toLowerCase()) {
              case "hex":
              case "utf8":
              case "utf-8":
              case "ascii":
              case "binary":
              case "base64":
              case "ucs2":
              case "ucs-2":
              case "utf16le":
              case "utf-16le":
              case "raw":
                return true;

              default:
                return false;
            }
        };
        function a(e) {
            if (!e) return "utf8";
            var t;
            while (true) {
                switch (e) {
                  case "utf8":
                  case "utf-8":
                    return "utf8";

                  case "ucs2":
                  case "ucs-2":
                  case "utf16le":
                  case "utf-16le":
                    return "utf16le";

                  case "latin1":
                  case "binary":
                    return "latin1";

                  case "base64":
                  case "ascii":
                  case "hex":
                    return e;

                  default:
                    if (t) return;
                    e = ("" + e).toLowerCase();
                    t = true;
                }
            }
        }
        function s(e) {
            var t = a(e);
            if (typeof t !== "string" && (i.isEncoding === n || !n(e))) throw new Error("Unknown encoding: " + e);
            return t || e;
        }
        r.StringDecoder = f;
        function f(e) {
            this.encoding = s(e);
            var t;
            switch (this.encoding) {
              case "utf16le":
                this.text = p;
                this.end = b;
                t = 4;
                break;

              case "utf8":
                this.fillLast = u;
                t = 4;
                break;

              case "base64":
                this.text = v;
                this.end = m;
                t = 3;
                break;

              default:
                this.write = y;
                this.end = g;
                return;
            }
            this.lastNeed = 0;
            this.lastTotal = 0;
            this.lastChar = i.allocUnsafe(t);
        }
        f.prototype.write = function(e) {
            if (e.length === 0) return "";
            var t;
            var r;
            if (this.lastNeed) {
                t = this.fillLast(e);
                if (t === undefined) return "";
                r = this.lastNeed;
                this.lastNeed = 0;
            } else {
                r = 0;
            }
            if (r < e.length) return t ? t + this.text(e, r) : this.text(e, r);
            return t || "";
        };
        f.prototype.end = l;
        f.prototype.text = d;
        f.prototype.fillLast = function(e) {
            if (this.lastNeed <= e.length) {
                e.copy(this.lastChar, this.lastTotal - this.lastNeed, 0, this.lastNeed);
                return this.lastChar.toString(this.encoding, 0, this.lastTotal);
            }
            e.copy(this.lastChar, this.lastTotal - this.lastNeed, 0, e.length);
            this.lastNeed -= e.length;
        };
        function o(e) {
            if (e <= 127) return 0; else if (e >> 5 === 6) return 2; else if (e >> 4 === 14) return 3; else if (e >> 3 === 30) return 4;
            return -1;
        }
        function c(e, t, r) {
            var i = t.length - 1;
            if (i < r) return 0;
            var n = o(t[i]);
            if (n >= 0) {
                if (n > 0) e.lastNeed = n - 1;
                return n;
            }
            if (--i < r) return 0;
            n = o(t[i]);
            if (n >= 0) {
                if (n > 0) e.lastNeed = n - 2;
                return n;
            }
            if (--i < r) return 0;
            n = o(t[i]);
            if (n >= 0) {
                if (n > 0) {
                    if (n === 2) n = 0; else e.lastNeed = n - 3;
                }
                return n;
            }
            return 0;
        }
        function h(e, t, r) {
            if ((t[0] & 192) !== 128) {
                e.lastNeed = 0;
                return "�".repeat(r);
            }
            if (e.lastNeed > 1 && t.length > 1) {
                if ((t[1] & 192) !== 128) {
                    e.lastNeed = 1;
                    return "�".repeat(r + 1);
                }
                if (e.lastNeed > 2 && t.length > 2) {
                    if ((t[2] & 192) !== 128) {
                        e.lastNeed = 2;
                        return "�".repeat(r + 2);
                    }
                }
            }
        }
        function u(e) {
            var t = this.lastTotal - this.lastNeed;
            var r = h(this, e, t);
            if (r !== undefined) return r;
            if (this.lastNeed <= e.length) {
                e.copy(this.lastChar, t, 0, this.lastNeed);
                return this.lastChar.toString(this.encoding, 0, this.lastTotal);
            }
            e.copy(this.lastChar, t, 0, e.length);
            this.lastNeed -= e.length;
        }
        function d(e, t) {
            var r = c(this, e, t);
            if (!this.lastNeed) return e.toString("utf8", t);
            this.lastTotal = r;
            var i = e.length - (r - this.lastNeed);
            e.copy(this.lastChar, 0, i);
            return e.toString("utf8", t, i);
        }
        function l(e) {
            var t = e && e.length ? this.write(e) : "";
            if (this.lastNeed) return t + "�".repeat(this.lastTotal - this.lastNeed);
            return t;
        }
        function p(e, t) {
            if ((e.length - t) % 2 === 0) {
                var r = e.toString("utf16le", t);
                if (r) {
                    var i = r.charCodeAt(r.length - 1);
                    if (i >= 55296 && i <= 56319) {
                        this.lastNeed = 2;
                        this.lastTotal = 4;
                        this.lastChar[0] = e[e.length - 2];
                        this.lastChar[1] = e[e.length - 1];
                        return r.slice(0, -1);
                    }
                }
                return r;
            }
            this.lastNeed = 1;
            this.lastTotal = 2;
            this.lastChar[0] = e[e.length - 1];
            return e.toString("utf16le", t, e.length - 1);
        }
        function b(e) {
            var t = e && e.length ? this.write(e) : "";
            if (this.lastNeed) {
                var r = this.lastTotal - this.lastNeed;
                return t + this.lastChar.toString("utf16le", 0, r);
            }
            return t;
        }
        function v(e, t) {
            var r = (e.length - t) % 3;
            if (r === 0) return e.toString("base64", t);
            this.lastNeed = 3 - r;
            this.lastTotal = 3;
            if (r === 1) {
                this.lastChar[0] = e[e.length - 1];
            } else {
                this.lastChar[0] = e[e.length - 2];
                this.lastChar[1] = e[e.length - 1];
            }
            return e.toString("base64", t, e.length - r);
        }
        function m(e) {
            var t = e && e.length ? this.write(e) : "";
            if (this.lastNeed) return t + this.lastChar.toString("base64", 0, 3 - this.lastNeed);
            return t;
        }
        function y(e) {
            return e.toString(this.encoding);
        }
        function g(e) {
            return e && e.length ? this.write(e) : "";
        }
    }, {
        "safe-buffer": 154
    } ],
    165: [ function(e, t, r) {
        (function(e) {
            t.exports = r;
            function r(e, t) {
                if (i("noDeprecation")) {
                    return e;
                }
                var r = false;
                function n() {
                    if (!r) {
                        if (i("throwDeprecation")) {
                            throw new Error(t);
                        } else if (i("traceDeprecation")) {
                            console.trace(t);
                        } else {
                            console.warn(t);
                        }
                        r = true;
                    }
                    return e.apply(this, arguments);
                }
                return n;
            }
            function i(t) {
                try {
                    if (!e.localStorage) return false;
                } catch (e) {
                    return false;
                }
                var r = e.localStorage[t];
                if (null == r) return false;
                return String(r).toLowerCase() === "true";
            }
        }).call(this, typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {});
    }, {} ],
    166: [ function(require, module, exports) {
        var indexOf = require("indexof");
        var Object_keys = function(e) {
            if (Object.keys) return Object.keys(e); else {
                var t = [];
                for (var r in e) t.push(r);
                return t;
            }
        };
        var forEach = function(e, t) {
            if (e.forEach) return e.forEach(t); else for (var r = 0; r < e.length; r++) {
                t(e[r], r, e);
            }
        };
        var defineProp = function() {
            try {
                Object.defineProperty({}, "_", {});
                return function(e, t, r) {
                    Object.defineProperty(e, t, {
                        writable: true,
                        enumerable: false,
                        configurable: true,
                        value: r
                    });
                };
            } catch (e) {
                return function(e, t, r) {
                    e[t] = r;
                };
            }
        }();
        var globals = [ "Array", "Boolean", "Date", "Error", "EvalError", "Function", "Infinity", "JSON", "Math", "NaN", "Number", "Object", "RangeError", "ReferenceError", "RegExp", "String", "SyntaxError", "TypeError", "URIError", "decodeURI", "decodeURIComponent", "encodeURI", "encodeURIComponent", "escape", "eval", "isFinite", "isNaN", "parseFloat", "parseInt", "undefined", "unescape" ];
        function Context() {}
        Context.prototype = {};
        var Script = exports.Script = function e(t) {
            if (!(this instanceof Script)) return new Script(t);
            this.code = t;
        };
        Script.prototype.runInContext = function(e) {
            if (!(e instanceof Context)) {
                throw new TypeError("needs a 'context' argument.");
            }
            var t = document.createElement("iframe");
            if (!t.style) t.style = {};
            t.style.display = "none";
            document.body.appendChild(t);
            var r = t.contentWindow;
            var i = r.eval, n = r.execScript;
            if (!i && n) {
                n.call(r, "null");
                i = r.eval;
            }
            forEach(Object_keys(e), function(t) {
                r[t] = e[t];
            });
            forEach(globals, function(t) {
                if (e[t]) {
                    r[t] = e[t];
                }
            });
            var a = Object_keys(r);
            var s = i.call(r, this.code);
            forEach(Object_keys(r), function(t) {
                if (t in e || indexOf(a, t) === -1) {
                    e[t] = r[t];
                }
            });
            forEach(globals, function(t) {
                if (!(t in e)) {
                    defineProp(e, t, r[t]);
                }
            });
            document.body.removeChild(t);
            return s;
        };
        Script.prototype.runInThisContext = function() {
            return eval(this.code);
        };
        Script.prototype.runInNewContext = function(e) {
            var t = Script.createContext(e);
            var r = this.runInContext(t);
            forEach(Object_keys(t), function(r) {
                e[r] = t[r];
            });
            return r;
        };
        forEach(Object_keys(Script.prototype), function(e) {
            exports[e] = Script[e] = function(t) {
                var r = Script(t);
                return r[e].apply(r, [].slice.call(arguments, 1));
            };
        });
        exports.createScript = function(e) {
            return exports.Script(e);
        };
        exports.createContext = Script.createContext = function(e) {
            var t = new Context();
            if (typeof e === "object") {
                forEach(Object_keys(e), function(r) {
                    t[r] = e[r];
                });
            }
            return t;
        };
    }, {
        indexof: 114
    } ]
}, {}, [ 16 ]);