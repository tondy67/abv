(function t(e, r, n) {
    function i(s, f) {
        if (!r[s]) {
            if (!e[s]) {
                var u = typeof require == "function" && require;
                if (!f && u) return u(s, !0);
                if (o) return o(s, !0);
                var a = new Error("Cannot find module '" + s + "'");
                throw a.code = "MODULE_NOT_FOUND", a;
            }
            var h = r[s] = {
                exports: {}
            };
            e[s][0].call(h.exports, function(t) {
                var r = e[s][1][t];
                return i(r ? r : t);
            }, h, h.exports, t, e, r, n);
        }
        return r[s].exports;
    }
    var o = typeof require == "function" && require;
    for (var s = 0; s < n.length; s++) i(n[s]);
    return i;
})({
    1: [ function(t, e, r) {
        (function(t, r) {
            "use strict";
            const n = console.log.bind(console);
            const i = "undefined";
            const o = typeof window !== i && window;
            const s = o ? false : t.execArgv.indexOf("--inspect") !== -1;
            const f = "no";
            const u = "error";
            const a = "warn";
            const h = "log";
            const c = "info";
            const l = "debug";
            const p = [ f, u, a, h, c, l ];
            Object.freeze(p);
            const g = "red";
            const d = "blue";
            const y = "green";
            const v = "yellow";
            const w = "orange";
            const m = "magenta";
            const b = "cyan";
            const E = "gray";
            const A = "black";
            const x = [ g, d, y, w, m, b, E ];
            Object.freeze(x);
            const T = "[0m";
            const B = "[1m";
            const I = "[2m";
            const _ = "[4m";
            const S = "[5m";
            const U = "[7m";
            const M = "[8m";
            const C = "[30m";
            const L = "[31m";
            const k = "[32m";
            const O = "[33m";
            const D = "[34m";
            const j = "[35m";
            const N = "[36m";
            const R = "[37m";
            const P = "[40m";
            const F = "[41m";
            const z = "[42m";
            const q = "[43m";
            const J = "[44m";
            const Y = "[45m";
            const V = "[46m";
            const X = "[47m";
            let G = 0 | 0;
            const H = t => {
                return t.reduce((t, e) => {
                    const r = new Set(e);
                    return t.filter(t => r.has(t));
                });
            };
            const Z = t => {
                const e = t.reduce((t, e) => t.concat(e), []);
                return Array.from(new Set(e));
            };
            const K = t => {
                const e = new Set(H(t));
                const r = Z(t);
                return r.filter(t => !e.has(t));
            };
            const Q = (t, e = false) => {
                let r = t;
                if (o || s) return r;
                if (!t) r = T; else if (t === g) r = e ? F : L; else if (t === d) r = e ? J : D; else if (t === y) r = e ? z : k; else if (t === w) r = e ? q : O; else if (t === v) r = e ? q : O; else if (t === m) r = e ? Y : j; else if (t === b) r = e ? V : N; else if (t === E) r = e ? X : I; else if (t === A) r = e ? P : C;
                return r;
            };
            const W = t => {
                let e = "[object]";
                try {
                    e = JSON.stringify(t);
                } catch (t) {}
                return e;
            };
            const $ = t => {
                let e = {};
                try {
                    e = JSON.parse(t);
                } catch (t) {}
                return e;
            };
            const tt = t => {
                let e = "-1";
                try {
                    const r = new DataView(t);
                    const n = t.byteLength / 2;
                    const i = new Uint16Array(n);
                    for (let t = 0; t < n; t++) {
                        i[t] = r.getUint16(t * 2);
                    }
                    e = String.fromCharCode.apply(null, i);
                } catch (t) {}
                return e;
            };
            const et = t => {
                if (!ot(t, String)) t = "-1";
                const e = new ArrayBuffer(t.length * 2);
                const r = new DataView(e);
                for (let e = 0, n = t.length; e < n; e++) {
                    r.setUint16(e * 2, t.charCodeAt(e));
                }
                return e;
            };
            const rt = (e, r, i) => {
                e = ot(e, String) ? e : String(e);
                if (o) {
                    n(e);
                } else {
                    if (r) {
                        e = Q(r) + e + T;
                        if (i) e = Q(i, true) + e;
                    }
                    t.stdout.write(e);
                }
            };
            const nt = (t, e, r, i, f) => {
                let u = "";
                let a = pt.time ? " +" + f : "";
                if (!f) a = "";
                if (!pt.color) {
                    u = e + ": " + t + a;
                    if (!pt.test) n(u);
                } else if (o || s || pt.browser) {
                    u = "%c " + e + " %c " + t + a;
                    if (!pt.test) n(u, "background: " + Q(i, true) + "; color: white", "color: " + Q(r));
                } else {
                    if (pt.test) i = g;
                    u = Q(i, true) + R + B + " " + e + " " + T + " " + Q(r) + t + a + T;
                    if (!pt.test) n(u);
                }
                return u;
            };
            const it = (t, e) => {
                let r;
                if (ot(t, e)) {
                    r = t;
                } else {
                    throw new TypeError("Cast error");
                }
                return r;
            };
            const ot = (t, e) => {
                let n = false;
                if (typeof t === i || typeof e === i) return n;
                if (e === String) {
                    n = typeof t === "string" || t instanceof String;
                } else if (e === ArrayBuffer) {
                    n = t instanceof ArrayBuffer;
                } else if (e === r) {
                    n = t instanceof r;
                } else if (e instanceof Array) {
                    if (e.length !== 1) {} else if (t instanceof Array) {
                        let r = true;
                        for (let n = 0, i = t.length; n < i; n++) {
                            if (!ot(t[n], e[0])) {
                                r = false;
                                break;
                            }
                        }
                        if (r) n = true;
                    }
                } else if (e === "Int") {
                    n = Number.isInteger(t);
                } else if (e === "Float") {
                    n = Number.isFinite(t) && !Number.isInteger(t);
                } else if (e === Number) {
                    n = typeof t === "number";
                } else if (e === Boolean) {
                    n = typeof t === "boolean" || t instanceof Boolean;
                } else if (t instanceof e) {
                    n = true;
                } else {
                    n = ft([ t, e, 215 ]) === "";
                }
                return n;
            };
            const st = t => {
                let e = "";
                const r = [];
                const n = t.length % 2 === 0 ? t.length : t.length - 1;
                for (let e = 0; e < n; e += 2) {
                    if (!ot(t[e], t[e + 1])) {
                        r.push("arg" + Math.round((e + 1) / 2));
                    }
                }
                const i = t.length > n ? t[n] + " " : "";
                if (r.length > 0) e = i + "TypeError: " + r.join(", ");
                return e;
            };
            const ft = t => {
                let e = "";
                const r = [];
                const n = "function";
                let i = typeof t[0] === n ? new t[0]() : t[0];
                const o = Array.from(Object.keys(i));
                const s = i.constructor.name + "{}";
                let f = [];
                do {
                    f = f.concat(Object.getOwnPropertyNames(i));
                } while (i = Object.getPrototypeOf(i));
                let u, a, h, c, l;
                const p = ot(t[t.length - 1], "Int") ? t.length - 1 : t.length;
                for (let e = 1; e < p; e++) {
                    u = typeof t[e] === n ? new t[e]() : t[e];
                    l = u.constructor.name;
                    a = Object.getOwnPropertyNames(Object.getPrototypeOf(u));
                    h = Array.from(Object.keys(u));
                    c = H([ o, h ]);
                    c = K([ c, h ]);
                    if (c.length > 0) r.push(l + "{" + c + "}");
                    c = H([ f, a ]);
                    c = K([ c, a ]);
                    if (c.length > 0) r.push(l + "(" + c + ")");
                }
                const g = t.length > p ? t[p] + " " : "";
                if (r.length > 0) e = g + s + " missing: " + r.join(", ");
                return e;
            };
            const ut = t => {
                for (let e in t) t[e] = t[e].trim();
            };
            const at = t => {
                const e = {};
                if (!t) t = "";
                let r = [];
                try {
                    r = t.split(",");
                    ut(r);
                } catch (t) {}
                let n = r[0] ? r[0] : "";
                const i = r[1] ? r[1] : l;
                try {
                    r = n.split(":");
                    ut(r);
                } catch (t) {}
                e.proj = r[0] ? r[0] : "";
                e.mod = r[1] ? r[1] : "";
                e.bg = x[G % x.length];
                n = p.indexOf(i);
                e.level = n === -1 ? 0 : n;
                return e;
            };
            const ht = t => {
                let e = [];
                let r = "";
                for (let r = 0, n = t.length; r < n; r++) {
                    if (typeof t[r] !== "object") {
                        e.push(t[r]);
                    } else {
                        e.push(W(t[r]));
                    }
                }
                return e.join(", ");
            };
            const ct = t => {
                if (t < 1e3) return t + "ms";
                let e = t / 1e3;
                if (e < 60) return e.toFixed(2) + "s";
                e = Math.floor(t % 6e4 / 1e3);
                let r = Math.floor(t / 6e4);
                if (r < 60) return r + ":" + (e < 10 ? "0" : "") + e + "m";
                r = Math.floor(t % 36e5 / 6e4);
                let n = Math.floor(t / 36e5);
                return n + ":" + (r < 10 ? "0" : "") + r + "h";
            };
            const lt = t => {
                if (!ot(t, String)) t = "";
                let e = 5381 | 0;
                for (let r in t) {
                    e = (e << 5) + e + t.charCodeAt(r);
                }
                return e;
            };
            const pt = at((o ? localStorage.debug : t.env.DEBUG) || "");
            pt.color = true;
            pt.time = true;
            pt.test = false;
            pt.browser = false;
            class gt {
                constructor(t) {
                    const e = at(t);
                    this.level = pt.level < e.level ? pt.level : e.level;
                    if (pt.proj !== e.proj) this.level = 0; else if (pt.mod === "" || pt.mod === "*") {} else if (pt.mod !== e.mod) this.level = 0;
                    this.name = e.proj + (e.mod ? ":" + e.mod : "");
                    if (this.name == "") this.name = "ts:" + this.rand;
                    this.bg = e.bg;
                    G++;
                    if (G > x.length) G = 0;
                    this.now = Date.now();
                }
                get colors() {
                    return x;
                }
                get levels() {
                    return p;
                }
                get isBrowser() {
                    return o;
                }
                get isInspector() {
                    return s;
                }
                time(t) {
                    return ct(t);
                }
                trim(t) {
                    ut(t);
                }
                toString(t) {
                    return W(t);
                }
                fromString(t) {
                    return $(t);
                }
                ab2str(t) {
                    return tt(t);
                }
                str2ab(t) {
                    return et(t);
                }
                djb2(t) {
                    return lt(t);
                }
                clear(t) {
                    t.length = 0;
                }
                clr2c(t, e = false) {
                    return Q(t, e);
                }
                toJson(t) {
                    return JSON.stringify(t, null, 2);
                }
                print(t, e, r) {
                    rt(t, e, r);
                }
                println(t, e, r) {
                    rt(t + "\n", e, r);
                }
                rand() {
                    const t = lt(Date.now() + this.name);
                    return Math.random().toString(36).slice(2) + t;
                }
                set(t) {
                    if (typeof t !== "object") return;
                    if (t.level) {
                        const e = p.indexOf(t.level);
                        if (e !== -1) t.level = this.level = e;
                    }
                    Object.keys(t).forEach(e => {
                        if (pt.hasOwnProperty(e)) pt[e] = t[e];
                    });
                }
                dt() {
                    const t = Date.now();
                    const e = t - this.now;
                    this.now = t;
                    return ct(e);
                }
                error(t) {
                    if (this.level < 1) return "";
                    return nt(ht(arguments), this.name, g, this.bg, this.dt());
                }
                warn(t) {
                    if (this.level < 2) return "";
                    return nt(ht(arguments), this.name, w, this.bg, this.dt());
                }
                log(t) {
                    if (this.level < 3) return "";
                    return nt(ht(arguments), this.name, E, this.bg, this.dt());
                }
                info(t) {
                    if (this.level < 4) return "";
                    return nt(ht(arguments), this.name, d, this.bg, this.dt());
                }
                debug(t) {
                    if (this.level < 5) return "";
                    return nt(ht(arguments), this.name, y, this.bg, this.dt());
                }
                type(t) {
                    if (this.level < 5) return "";
                    var e = "";
                    if (t === null) e = "null"; else if (t && t.constructor) e = t.constructor.name; else e = typeof t;
                    return nt([ e ], this.name, g, this.bg, this.dt());
                }
                cast(t, e) {
                    return it(t, e);
                }
                is(t, e) {
                    return ot(t, e);
                }
                params(t, e, r) {
                    if (this.level < 5) return true;
                    const n = st(Array.from(arguments));
                    if (n !== "") {
                        this.error(n);
                        return false;
                    }
                    return true;
                }
                implements(t, e, r) {
                    if (this.level < 5) return true;
                    const n = ft(Array.from(arguments));
                    if (n !== "") {
                        this.error(n);
                        return false;
                    }
                    return true;
                }
                intersec(t, e) {
                    const r = Array.from(arguments);
                    if (r.length < 2) {
                        ts.error("arg2..?");
                        return [];
                    }
                    return H(r);
                }
                diff(t, e) {
                    const r = Array.from(arguments);
                    if (r.length < 2) {
                        ts.error("arg2..?");
                        return [];
                    }
                    return K(r);
                }
                union(t, e) {
                    const r = Array.from(arguments);
                    if (r.length < 2) {
                        ts.error("arg2..?");
                        return [];
                    }
                    return Z(r);
                }
            }
            e.exports = (t => {
                return new gt(t);
            });
        }).call(this, t("_process"), t("buffer").Buffer);
    }, {
        _process: 13,
        buffer: 11
    } ],
    2: [ function(t, e, r) {
        "use strict";
        const n = t("abv-ts")("abv:AM");
        const i = t("./io/ATerm");
        class o {
            constructor(t = 32, e) {
                this.fps = t;
                this.term = [];
                this.opt = e;
                this.create(e);
                if (t > 0) setInterval(this.update, 1e3 / t, this); else this.update(this);
            }
            create(t) {
                this.addTerm(new i(t));
            }
            update(t) {
                t.render();
            }
            render() {
                for (let t of this.term) t.render();
            }
            addTerm(t) {
                if (t) this.term.push(t);
            }
            addLayer(t) {
                for (let e of this.term) e.addLayer(t);
            }
            getLayer(t) {
                let e = null;
                for (e of this.term[0].layer) if (e.name == t) break;
                return e;
            }
        }
        e.exports = o;
    }, {
        "./io/ATerm": 4,
        "abv-ts": 1
    } ],
    3: [ function(t, e, r) {
        "use strict";
        const n = t("abv-ts")("abv:Node");
        class i {
            constructor(t, e = 0, r = 0, n = 0, i = 0, o = "blue") {
                this.id = t;
                this._x = e;
                this._y = r;
                this.w = n;
                this.h = i;
                this.color = o;
                this.kind = 0;
                this.children = new Map();
            }
            get x() {
                return this._x;
            }
            set x(t) {
                let e = t - this.x;
                for (let [t, r] of this.children) if (r) r.x += e;
                this._x = t;
            }
            get y() {
                return this._y;
            }
            set y(t) {
                let e = t - this.y;
                for (let [t, r] of this.children) if (r) r.y += e;
                this._y = t;
            }
            addChild(t) {
                this.children.set(t.id, t);
            }
            getChild(t) {
                return this.children.get(t);
            }
        }
        e.exports = i;
    }, {
        "abv-ts": 1
    } ],
    4: [ function(t, e, r) {
        "use strict";
        const n = t("abv-ts")("abv:ATerm");
        class i {
            constructor() {
                this.layer = [];
            }
            render() {
                this.clear();
                for (let t of this.layer) this.draw(t);
            }
            clear() {}
            draw(t) {
                switch (t.kind) {
                  case 0:
                    this.rect(t.id, t.x, t.y, t.w, t.h, t.color);
                    break;

                  default:
                    n.error(29, "kind: " + t.kind);
                }
                if (t.children.size > 0) {
                    for (let [e, r] of t.children) if (r) this.draw(r);
                }
            }
            rect(t, e, r, i, o) {
                n.debug("rect: ", t, e, r, i, o);
            }
            addLayer(t) {
                if (t) this.layer.push(t);
            }
            dispose() {}
        }
        e.exports = i;
    }, {
        "abv-ts": 1
    } ],
    5: [ function(t, e, r) {
        "use strict";
        const n = t("abv-ts")("abv:Term0D");
        const i = t("./ATerm");
        const o = "┌";
        const s = "┐";
        const f = "└";
        const u = "┘";
        const a = "─";
        const h = "│";
        const c = (t, e) => {
            return "[" + e + ";" + t + "H";
        };
        const l = t => {
            let e = "";
            for (let r = 0; r < t - 2; r++) e += a;
            return o + e + s;
        };
        const p = t => {
            let e = "";
            for (let r = 0; r < t - 2; r++) e += a;
            return f + e + u;
        };
        const g = t => {
            let e = "";
            for (let r = 0; r < t - 2; r++) e += " ";
            return h + e + h;
        };
        const d = () => {
            return "[2J";
        };
        class y extends i {
            constructor() {
                super();
            }
            clear() {
                n.println(d());
            }
            rect(t, e, r, i, o, s) {
                const f = 10;
                e = Math.round(e / f);
                r = Math.round(r / f) + 1;
                i = Math.round(i / f);
                if (i < 3) i = 3;
                o = Math.round(o / f);
                if (o < 3) o = 3;
                n.println(n.clr2c(s, true) + c(e, r) + l(i));
                for (let t = 1; t < o - 2; t++) n.println(c(e, r + t) + g(i));
                n.println(c(e, r + o - 2) + p(i));
                n.println(n.clr2c());
            }
        }
        e.exports = y;
    }, {
        "./ATerm": 4,
        "abv-ts": 1
    } ],
    6: [ function(t, e, r) {
        "use strict";
        const n = t("abv-ts")("abv:Term1D");
        const i = t("./ATerm");
        class o extends i {
            constructor(t) {
                super();
                this.doc = t.document;
                this.elms = new Map();
            }
            clear() {}
            shape(t, e) {
                let r = this.elms.get(t);
                if (!r) {
                    r = this.doc.createElement("div");
                    r.id = t;
                    r.style.backgroundColor = e;
                    r.style.border = "1px solid #0000FF";
                    this.doc.body.appendChild(r);
                    this.elms.set(t, r);
                }
                return r;
            }
            rect(t, e, r, n, i, o) {
                const s = this.shape(t, o);
                s.style.left = e + "px";
                s.style.top = r + "px";
                s.style.width = n + "px";
                s.style.height = i + "px";
                s.style.margin = "0px";
                s.style.position = "fixed";
            }
        }
        e.exports = o;
    }, {
        "./ATerm": 4,
        "abv-ts": 1
    } ],
    7: [ function(t, e, r) {
        "use strict";
        const n = t("abv-ts")("abv:Term2D");
        const i = t("./Term1D");
        class o extends i {
            constructor(t) {
                super(t);
                this.ctx = t.ctx;
            }
            clear() {
                this.ctx.clearRect(0, 0, this.ctx.canvas.width, this.ctx.canvas.height);
            }
            rect(t, e, r, n, i, o) {
                this.ctx.beginPath();
                this.ctx.rect(e, r, n, i);
                this.ctx.strokeStyle = "blue";
                this.ctx.fillStyle = o;
                this.ctx.fill();
                this.ctx.stroke();
            }
        }
        e.exports = o;
    }, {
        "./Term1D": 6,
        "abv-ts": 1
    } ],
    8: [ function(t, e, r) {
        "use strict";
        const n = t("./Term0D");
        const i = t("./Term1D");
        const o = t("./Term2D");
        e.exports = {
            Term0D: n,
            Term1D: i,
            Term2D: o
        };
    }, {
        "./Term0D": 5,
        "./Term1D": 6,
        "./Term2D": 7
    } ],
    9: [ function(t, e, r) {
        "use strict";
        const n = typeof window !== "undefined" && window;
        const i = t("abv-ts")("abv:index");
        const o = t("./abv/AM");
        const s = t("./abv/Node");
        const f = t("./abv/io/index");
        const u = {
            AM: o,
            Node: s,
            io: f
        };
        if (n) {
            window.ts = i;
            window.abv = u;
        }
        e.exports = u;
    }, {
        "./abv/AM": 2,
        "./abv/Node": 3,
        "./abv/io/index": 8,
        "abv-ts": 1
    } ],
    10: [ function(t, e, r) {
        "use strict";
        r.byteLength = h;
        r.toByteArray = c;
        r.fromByteArray = g;
        var n = [];
        var i = [];
        var o = typeof Uint8Array !== "undefined" ? Uint8Array : Array;
        var s = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        for (var f = 0, u = s.length; f < u; ++f) {
            n[f] = s[f];
            i[s.charCodeAt(f)] = f;
        }
        i["-".charCodeAt(0)] = 62;
        i["_".charCodeAt(0)] = 63;
        function a(t) {
            var e = t.length;
            if (e % 4 > 0) {
                throw new Error("Invalid string. Length must be a multiple of 4");
            }
            return t[e - 2] === "=" ? 2 : t[e - 1] === "=" ? 1 : 0;
        }
        function h(t) {
            return t.length * 3 / 4 - a(t);
        }
        function c(t) {
            var e, r, n, s, f;
            var u = t.length;
            s = a(t);
            f = new o(u * 3 / 4 - s);
            r = s > 0 ? u - 4 : u;
            var h = 0;
            for (e = 0; e < r; e += 4) {
                n = i[t.charCodeAt(e)] << 18 | i[t.charCodeAt(e + 1)] << 12 | i[t.charCodeAt(e + 2)] << 6 | i[t.charCodeAt(e + 3)];
                f[h++] = n >> 16 & 255;
                f[h++] = n >> 8 & 255;
                f[h++] = n & 255;
            }
            if (s === 2) {
                n = i[t.charCodeAt(e)] << 2 | i[t.charCodeAt(e + 1)] >> 4;
                f[h++] = n & 255;
            } else if (s === 1) {
                n = i[t.charCodeAt(e)] << 10 | i[t.charCodeAt(e + 1)] << 4 | i[t.charCodeAt(e + 2)] >> 2;
                f[h++] = n >> 8 & 255;
                f[h++] = n & 255;
            }
            return f;
        }
        function l(t) {
            return n[t >> 18 & 63] + n[t >> 12 & 63] + n[t >> 6 & 63] + n[t & 63];
        }
        function p(t, e, r) {
            var n;
            var i = [];
            for (var o = e; o < r; o += 3) {
                n = (t[o] << 16) + (t[o + 1] << 8) + t[o + 2];
                i.push(l(n));
            }
            return i.join("");
        }
        function g(t) {
            var e;
            var r = t.length;
            var i = r % 3;
            var o = "";
            var s = [];
            var f = 16383;
            for (var u = 0, a = r - i; u < a; u += f) {
                s.push(p(t, u, u + f > a ? a : u + f));
            }
            if (i === 1) {
                e = t[r - 1];
                o += n[e >> 2];
                o += n[e << 4 & 63];
                o += "==";
            } else if (i === 2) {
                e = (t[r - 2] << 8) + t[r - 1];
                o += n[e >> 10];
                o += n[e >> 4 & 63];
                o += n[e << 2 & 63];
                o += "=";
            }
            s.push(o);
            return s.join("");
        }
    }, {} ],
    11: [ function(t, e, r) {
        "use strict";
        var n = t("base64-js");
        var i = t("ieee754");
        r.Buffer = u;
        r.SlowBuffer = w;
        r.INSPECT_MAX_BYTES = 50;
        var o = 2147483647;
        r.kMaxLength = o;
        u.TYPED_ARRAY_SUPPORT = s();
        if (!u.TYPED_ARRAY_SUPPORT && typeof console !== "undefined" && typeof console.error === "function") {
            console.error("This browser lacks typed array (Uint8Array) support which is required by " + "`buffer` v5.x. Use `buffer` v4.x if you require old browser support.");
        }
        function s() {
            try {
                var t = new Uint8Array(1);
                t.__proto__ = {
                    __proto__: Uint8Array.prototype,
                    foo: function() {
                        return 42;
                    }
                };
                return t.foo() === 42;
            } catch (t) {
                return false;
            }
        }
        function f(t) {
            if (t > o) {
                throw new RangeError("Invalid typed array length");
            }
            var e = new Uint8Array(t);
            e.__proto__ = u.prototype;
            return e;
        }
        function u(t, e, r) {
            if (typeof t === "number") {
                if (typeof e === "string") {
                    throw new Error("If encoding is specified then the first argument must be a string");
                }
                return l(t);
            }
            return a(t, e, r);
        }
        if (typeof Symbol !== "undefined" && Symbol.species && u[Symbol.species] === u) {
            Object.defineProperty(u, Symbol.species, {
                value: null,
                configurable: true,
                enumerable: false,
                writable: false
            });
        }
        u.poolSize = 8192;
        function a(t, e, r) {
            if (typeof t === "number") {
                throw new TypeError('"value" argument must not be a number');
            }
            if (Q(t)) {
                return d(t, e, r);
            }
            if (typeof t === "string") {
                return p(t, e);
            }
            return y(t);
        }
        u.from = function(t, e, r) {
            return a(t, e, r);
        };
        u.prototype.__proto__ = Uint8Array.prototype;
        u.__proto__ = Uint8Array;
        function h(t) {
            if (typeof t !== "number") {
                throw new TypeError('"size" argument must be a number');
            } else if (t < 0) {
                throw new RangeError('"size" argument must not be negative');
            }
        }
        function c(t, e, r) {
            h(t);
            if (t <= 0) {
                return f(t);
            }
            if (e !== undefined) {
                return typeof r === "string" ? f(t).fill(e, r) : f(t).fill(e);
            }
            return f(t);
        }
        u.alloc = function(t, e, r) {
            return c(t, e, r);
        };
        function l(t) {
            h(t);
            return f(t < 0 ? 0 : v(t) | 0);
        }
        u.allocUnsafe = function(t) {
            return l(t);
        };
        u.allocUnsafeSlow = function(t) {
            return l(t);
        };
        function p(t, e) {
            if (typeof e !== "string" || e === "") {
                e = "utf8";
            }
            if (!u.isEncoding(e)) {
                throw new TypeError('"encoding" must be a valid string encoding');
            }
            var r = m(t, e) | 0;
            var n = f(r);
            var i = n.write(t, e);
            if (i !== r) {
                n = n.slice(0, i);
            }
            return n;
        }
        function g(t) {
            var e = t.length < 0 ? 0 : v(t.length) | 0;
            var r = f(e);
            for (var n = 0; n < e; n += 1) {
                r[n] = t[n] & 255;
            }
            return r;
        }
        function d(t, e, r) {
            if (e < 0 || t.byteLength < e) {
                throw new RangeError("'offset' is out of bounds");
            }
            if (t.byteLength < e + (r || 0)) {
                throw new RangeError("'length' is out of bounds");
            }
            var n;
            if (e === undefined && r === undefined) {
                n = new Uint8Array(t);
            } else if (r === undefined) {
                n = new Uint8Array(t, e);
            } else {
                n = new Uint8Array(t, e, r);
            }
            n.__proto__ = u.prototype;
            return n;
        }
        function y(t) {
            if (u.isBuffer(t)) {
                var e = v(t.length) | 0;
                var r = f(e);
                if (r.length === 0) {
                    return r;
                }
                t.copy(r, 0, 0, e);
                return r;
            }
            if (t) {
                if (W(t) || "length" in t) {
                    if (typeof t.length !== "number" || $(t.length)) {
                        return f(0);
                    }
                    return g(t);
                }
                if (t.type === "Buffer" && Array.isArray(t.data)) {
                    return g(t.data);
                }
            }
            throw new TypeError("First argument must be a string, Buffer, ArrayBuffer, Array, or array-like object.");
        }
        function v(t) {
            if (t >= o) {
                throw new RangeError("Attempt to allocate Buffer larger than maximum " + "size: 0x" + o.toString(16) + " bytes");
            }
            return t | 0;
        }
        function w(t) {
            if (+t != t) {
                t = 0;
            }
            return u.alloc(+t);
        }
        u.isBuffer = function t(e) {
            return e != null && e._isBuffer === true;
        };
        u.compare = function t(e, r) {
            if (!u.isBuffer(e) || !u.isBuffer(r)) {
                throw new TypeError("Arguments must be Buffers");
            }
            if (e === r) return 0;
            var n = e.length;
            var i = r.length;
            for (var o = 0, s = Math.min(n, i); o < s; ++o) {
                if (e[o] !== r[o]) {
                    n = e[o];
                    i = r[o];
                    break;
                }
            }
            if (n < i) return -1;
            if (i < n) return 1;
            return 0;
        };
        u.isEncoding = function t(e) {
            switch (String(e).toLowerCase()) {
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
        u.concat = function t(e, r) {
            if (!Array.isArray(e)) {
                throw new TypeError('"list" argument must be an Array of Buffers');
            }
            if (e.length === 0) {
                return u.alloc(0);
            }
            var n;
            if (r === undefined) {
                r = 0;
                for (n = 0; n < e.length; ++n) {
                    r += e[n].length;
                }
            }
            var i = u.allocUnsafe(r);
            var o = 0;
            for (n = 0; n < e.length; ++n) {
                var s = e[n];
                if (!u.isBuffer(s)) {
                    throw new TypeError('"list" argument must be an Array of Buffers');
                }
                s.copy(i, o);
                o += s.length;
            }
            return i;
        };
        function m(t, e) {
            if (u.isBuffer(t)) {
                return t.length;
            }
            if (W(t) || Q(t)) {
                return t.byteLength;
            }
            if (typeof t !== "string") {
                t = "" + t;
            }
            var r = t.length;
            if (r === 0) return 0;
            var n = false;
            for (;;) {
                switch (e) {
                  case "ascii":
                  case "latin1":
                  case "binary":
                    return r;

                  case "utf8":
                  case "utf-8":
                  case undefined:
                    return X(t).length;

                  case "ucs2":
                  case "ucs-2":
                  case "utf16le":
                  case "utf-16le":
                    return r * 2;

                  case "hex":
                    return r >>> 1;

                  case "base64":
                    return Z(t).length;

                  default:
                    if (n) return X(t).length;
                    e = ("" + e).toLowerCase();
                    n = true;
                }
            }
        }
        u.byteLength = m;
        function b(t, e, r) {
            var n = false;
            if (e === undefined || e < 0) {
                e = 0;
            }
            if (e > this.length) {
                return "";
            }
            if (r === undefined || r > this.length) {
                r = this.length;
            }
            if (r <= 0) {
                return "";
            }
            r >>>= 0;
            e >>>= 0;
            if (r <= e) {
                return "";
            }
            if (!t) t = "utf8";
            while (true) {
                switch (t) {
                  case "hex":
                    return j(this, e, r);

                  case "utf8":
                  case "utf-8":
                    return C(this, e, r);

                  case "ascii":
                    return O(this, e, r);

                  case "latin1":
                  case "binary":
                    return D(this, e, r);

                  case "base64":
                    return M(this, e, r);

                  case "ucs2":
                  case "ucs-2":
                  case "utf16le":
                  case "utf-16le":
                    return N(this, e, r);

                  default:
                    if (n) throw new TypeError("Unknown encoding: " + t);
                    t = (t + "").toLowerCase();
                    n = true;
                }
            }
        }
        u.prototype._isBuffer = true;
        function E(t, e, r) {
            var n = t[e];
            t[e] = t[r];
            t[r] = n;
        }
        u.prototype.swap16 = function t() {
            var e = this.length;
            if (e % 2 !== 0) {
                throw new RangeError("Buffer size must be a multiple of 16-bits");
            }
            for (var r = 0; r < e; r += 2) {
                E(this, r, r + 1);
            }
            return this;
        };
        u.prototype.swap32 = function t() {
            var e = this.length;
            if (e % 4 !== 0) {
                throw new RangeError("Buffer size must be a multiple of 32-bits");
            }
            for (var r = 0; r < e; r += 4) {
                E(this, r, r + 3);
                E(this, r + 1, r + 2);
            }
            return this;
        };
        u.prototype.swap64 = function t() {
            var e = this.length;
            if (e % 8 !== 0) {
                throw new RangeError("Buffer size must be a multiple of 64-bits");
            }
            for (var r = 0; r < e; r += 8) {
                E(this, r, r + 7);
                E(this, r + 1, r + 6);
                E(this, r + 2, r + 5);
                E(this, r + 3, r + 4);
            }
            return this;
        };
        u.prototype.toString = function t() {
            var e = this.length;
            if (e === 0) return "";
            if (arguments.length === 0) return C(this, 0, e);
            return b.apply(this, arguments);
        };
        u.prototype.equals = function t(e) {
            if (!u.isBuffer(e)) throw new TypeError("Argument must be a Buffer");
            if (this === e) return true;
            return u.compare(this, e) === 0;
        };
        u.prototype.inspect = function t() {
            var e = "";
            var n = r.INSPECT_MAX_BYTES;
            if (this.length > 0) {
                e = this.toString("hex", 0, n).match(/.{2}/g).join(" ");
                if (this.length > n) e += " ... ";
            }
            return "<Buffer " + e + ">";
        };
        u.prototype.compare = function t(e, r, n, i, o) {
            if (!u.isBuffer(e)) {
                throw new TypeError("Argument must be a Buffer");
            }
            if (r === undefined) {
                r = 0;
            }
            if (n === undefined) {
                n = e ? e.length : 0;
            }
            if (i === undefined) {
                i = 0;
            }
            if (o === undefined) {
                o = this.length;
            }
            if (r < 0 || n > e.length || i < 0 || o > this.length) {
                throw new RangeError("out of range index");
            }
            if (i >= o && r >= n) {
                return 0;
            }
            if (i >= o) {
                return -1;
            }
            if (r >= n) {
                return 1;
            }
            r >>>= 0;
            n >>>= 0;
            i >>>= 0;
            o >>>= 0;
            if (this === e) return 0;
            var s = o - i;
            var f = n - r;
            var a = Math.min(s, f);
            var h = this.slice(i, o);
            var c = e.slice(r, n);
            for (var l = 0; l < a; ++l) {
                if (h[l] !== c[l]) {
                    s = h[l];
                    f = c[l];
                    break;
                }
            }
            if (s < f) return -1;
            if (f < s) return 1;
            return 0;
        };
        function A(t, e, r, n, i) {
            if (t.length === 0) return -1;
            if (typeof r === "string") {
                n = r;
                r = 0;
            } else if (r > 2147483647) {
                r = 2147483647;
            } else if (r < -2147483648) {
                r = -2147483648;
            }
            r = +r;
            if ($(r)) {
                r = i ? 0 : t.length - 1;
            }
            if (r < 0) r = t.length + r;
            if (r >= t.length) {
                if (i) return -1; else r = t.length - 1;
            } else if (r < 0) {
                if (i) r = 0; else return -1;
            }
            if (typeof e === "string") {
                e = u.from(e, n);
            }
            if (u.isBuffer(e)) {
                if (e.length === 0) {
                    return -1;
                }
                return x(t, e, r, n, i);
            } else if (typeof e === "number") {
                e = e & 255;
                if (typeof Uint8Array.prototype.indexOf === "function") {
                    if (i) {
                        return Uint8Array.prototype.indexOf.call(t, e, r);
                    } else {
                        return Uint8Array.prototype.lastIndexOf.call(t, e, r);
                    }
                }
                return x(t, [ e ], r, n, i);
            }
            throw new TypeError("val must be string, number or Buffer");
        }
        function x(t, e, r, n, i) {
            var o = 1;
            var s = t.length;
            var f = e.length;
            if (n !== undefined) {
                n = String(n).toLowerCase();
                if (n === "ucs2" || n === "ucs-2" || n === "utf16le" || n === "utf-16le") {
                    if (t.length < 2 || e.length < 2) {
                        return -1;
                    }
                    o = 2;
                    s /= 2;
                    f /= 2;
                    r /= 2;
                }
            }
            function u(t, e) {
                if (o === 1) {
                    return t[e];
                } else {
                    return t.readUInt16BE(e * o);
                }
            }
            var a;
            if (i) {
                var h = -1;
                for (a = r; a < s; a++) {
                    if (u(t, a) === u(e, h === -1 ? 0 : a - h)) {
                        if (h === -1) h = a;
                        if (a - h + 1 === f) return h * o;
                    } else {
                        if (h !== -1) a -= a - h;
                        h = -1;
                    }
                }
            } else {
                if (r + f > s) r = s - f;
                for (a = r; a >= 0; a--) {
                    var c = true;
                    for (var l = 0; l < f; l++) {
                        if (u(t, a + l) !== u(e, l)) {
                            c = false;
                            break;
                        }
                    }
                    if (c) return a;
                }
            }
            return -1;
        }
        u.prototype.includes = function t(e, r, n) {
            return this.indexOf(e, r, n) !== -1;
        };
        u.prototype.indexOf = function t(e, r, n) {
            return A(this, e, r, n, true);
        };
        u.prototype.lastIndexOf = function t(e, r, n) {
            return A(this, e, r, n, false);
        };
        function T(t, e, r, n) {
            r = Number(r) || 0;
            var i = t.length - r;
            if (!n) {
                n = i;
            } else {
                n = Number(n);
                if (n > i) {
                    n = i;
                }
            }
            var o = e.length;
            if (o % 2 !== 0) throw new TypeError("Invalid hex string");
            if (n > o / 2) {
                n = o / 2;
            }
            for (var s = 0; s < n; ++s) {
                var f = parseInt(e.substr(s * 2, 2), 16);
                if ($(f)) return s;
                t[r + s] = f;
            }
            return s;
        }
        function B(t, e, r, n) {
            return K(X(e, t.length - r), t, r, n);
        }
        function I(t, e, r, n) {
            return K(G(e), t, r, n);
        }
        function _(t, e, r, n) {
            return I(t, e, r, n);
        }
        function S(t, e, r, n) {
            return K(Z(e), t, r, n);
        }
        function U(t, e, r, n) {
            return K(H(e, t.length - r), t, r, n);
        }
        u.prototype.write = function t(e, r, n, i) {
            if (r === undefined) {
                i = "utf8";
                n = this.length;
                r = 0;
            } else if (n === undefined && typeof r === "string") {
                i = r;
                n = this.length;
                r = 0;
            } else if (isFinite(r)) {
                r = r >>> 0;
                if (isFinite(n)) {
                    n = n >>> 0;
                    if (i === undefined) i = "utf8";
                } else {
                    i = n;
                    n = undefined;
                }
            } else {
                throw new Error("Buffer.write(string, encoding, offset[, length]) is no longer supported");
            }
            var o = this.length - r;
            if (n === undefined || n > o) n = o;
            if (e.length > 0 && (n < 0 || r < 0) || r > this.length) {
                throw new RangeError("Attempt to write outside buffer bounds");
            }
            if (!i) i = "utf8";
            var s = false;
            for (;;) {
                switch (i) {
                  case "hex":
                    return T(this, e, r, n);

                  case "utf8":
                  case "utf-8":
                    return B(this, e, r, n);

                  case "ascii":
                    return I(this, e, r, n);

                  case "latin1":
                  case "binary":
                    return _(this, e, r, n);

                  case "base64":
                    return S(this, e, r, n);

                  case "ucs2":
                  case "ucs-2":
                  case "utf16le":
                  case "utf-16le":
                    return U(this, e, r, n);

                  default:
                    if (s) throw new TypeError("Unknown encoding: " + i);
                    i = ("" + i).toLowerCase();
                    s = true;
                }
            }
        };
        u.prototype.toJSON = function t() {
            return {
                type: "Buffer",
                data: Array.prototype.slice.call(this._arr || this, 0)
            };
        };
        function M(t, e, r) {
            if (e === 0 && r === t.length) {
                return n.fromByteArray(t);
            } else {
                return n.fromByteArray(t.slice(e, r));
            }
        }
        function C(t, e, r) {
            r = Math.min(t.length, r);
            var n = [];
            var i = e;
            while (i < r) {
                var o = t[i];
                var s = null;
                var f = o > 239 ? 4 : o > 223 ? 3 : o > 191 ? 2 : 1;
                if (i + f <= r) {
                    var u, a, h, c;
                    switch (f) {
                      case 1:
                        if (o < 128) {
                            s = o;
                        }
                        break;

                      case 2:
                        u = t[i + 1];
                        if ((u & 192) === 128) {
                            c = (o & 31) << 6 | u & 63;
                            if (c > 127) {
                                s = c;
                            }
                        }
                        break;

                      case 3:
                        u = t[i + 1];
                        a = t[i + 2];
                        if ((u & 192) === 128 && (a & 192) === 128) {
                            c = (o & 15) << 12 | (u & 63) << 6 | a & 63;
                            if (c > 2047 && (c < 55296 || c > 57343)) {
                                s = c;
                            }
                        }
                        break;

                      case 4:
                        u = t[i + 1];
                        a = t[i + 2];
                        h = t[i + 3];
                        if ((u & 192) === 128 && (a & 192) === 128 && (h & 192) === 128) {
                            c = (o & 15) << 18 | (u & 63) << 12 | (a & 63) << 6 | h & 63;
                            if (c > 65535 && c < 1114112) {
                                s = c;
                            }
                        }
                    }
                }
                if (s === null) {
                    s = 65533;
                    f = 1;
                } else if (s > 65535) {
                    s -= 65536;
                    n.push(s >>> 10 & 1023 | 55296);
                    s = 56320 | s & 1023;
                }
                n.push(s);
                i += f;
            }
            return k(n);
        }
        var L = 4096;
        function k(t) {
            var e = t.length;
            if (e <= L) {
                return String.fromCharCode.apply(String, t);
            }
            var r = "";
            var n = 0;
            while (n < e) {
                r += String.fromCharCode.apply(String, t.slice(n, n += L));
            }
            return r;
        }
        function O(t, e, r) {
            var n = "";
            r = Math.min(t.length, r);
            for (var i = e; i < r; ++i) {
                n += String.fromCharCode(t[i] & 127);
            }
            return n;
        }
        function D(t, e, r) {
            var n = "";
            r = Math.min(t.length, r);
            for (var i = e; i < r; ++i) {
                n += String.fromCharCode(t[i]);
            }
            return n;
        }
        function j(t, e, r) {
            var n = t.length;
            if (!e || e < 0) e = 0;
            if (!r || r < 0 || r > n) r = n;
            var i = "";
            for (var o = e; o < r; ++o) {
                i += V(t[o]);
            }
            return i;
        }
        function N(t, e, r) {
            var n = t.slice(e, r);
            var i = "";
            for (var o = 0; o < n.length; o += 2) {
                i += String.fromCharCode(n[o] + n[o + 1] * 256);
            }
            return i;
        }
        u.prototype.slice = function t(e, r) {
            var n = this.length;
            e = ~~e;
            r = r === undefined ? n : ~~r;
            if (e < 0) {
                e += n;
                if (e < 0) e = 0;
            } else if (e > n) {
                e = n;
            }
            if (r < 0) {
                r += n;
                if (r < 0) r = 0;
            } else if (r > n) {
                r = n;
            }
            if (r < e) r = e;
            var i = this.subarray(e, r);
            i.__proto__ = u.prototype;
            return i;
        };
        function R(t, e, r) {
            if (t % 1 !== 0 || t < 0) throw new RangeError("offset is not uint");
            if (t + e > r) throw new RangeError("Trying to access beyond buffer length");
        }
        u.prototype.readUIntLE = function t(e, r, n) {
            e = e >>> 0;
            r = r >>> 0;
            if (!n) R(e, r, this.length);
            var i = this[e];
            var o = 1;
            var s = 0;
            while (++s < r && (o *= 256)) {
                i += this[e + s] * o;
            }
            return i;
        };
        u.prototype.readUIntBE = function t(e, r, n) {
            e = e >>> 0;
            r = r >>> 0;
            if (!n) {
                R(e, r, this.length);
            }
            var i = this[e + --r];
            var o = 1;
            while (r > 0 && (o *= 256)) {
                i += this[e + --r] * o;
            }
            return i;
        };
        u.prototype.readUInt8 = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 1, this.length);
            return this[e];
        };
        u.prototype.readUInt16LE = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 2, this.length);
            return this[e] | this[e + 1] << 8;
        };
        u.prototype.readUInt16BE = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 2, this.length);
            return this[e] << 8 | this[e + 1];
        };
        u.prototype.readUInt32LE = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 4, this.length);
            return (this[e] | this[e + 1] << 8 | this[e + 2] << 16) + this[e + 3] * 16777216;
        };
        u.prototype.readUInt32BE = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 4, this.length);
            return this[e] * 16777216 + (this[e + 1] << 16 | this[e + 2] << 8 | this[e + 3]);
        };
        u.prototype.readIntLE = function t(e, r, n) {
            e = e >>> 0;
            r = r >>> 0;
            if (!n) R(e, r, this.length);
            var i = this[e];
            var o = 1;
            var s = 0;
            while (++s < r && (o *= 256)) {
                i += this[e + s] * o;
            }
            o *= 128;
            if (i >= o) i -= Math.pow(2, 8 * r);
            return i;
        };
        u.prototype.readIntBE = function t(e, r, n) {
            e = e >>> 0;
            r = r >>> 0;
            if (!n) R(e, r, this.length);
            var i = r;
            var o = 1;
            var s = this[e + --i];
            while (i > 0 && (o *= 256)) {
                s += this[e + --i] * o;
            }
            o *= 128;
            if (s >= o) s -= Math.pow(2, 8 * r);
            return s;
        };
        u.prototype.readInt8 = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 1, this.length);
            if (!(this[e] & 128)) return this[e];
            return (255 - this[e] + 1) * -1;
        };
        u.prototype.readInt16LE = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 2, this.length);
            var n = this[e] | this[e + 1] << 8;
            return n & 32768 ? n | 4294901760 : n;
        };
        u.prototype.readInt16BE = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 2, this.length);
            var n = this[e + 1] | this[e] << 8;
            return n & 32768 ? n | 4294901760 : n;
        };
        u.prototype.readInt32LE = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 4, this.length);
            return this[e] | this[e + 1] << 8 | this[e + 2] << 16 | this[e + 3] << 24;
        };
        u.prototype.readInt32BE = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 4, this.length);
            return this[e] << 24 | this[e + 1] << 16 | this[e + 2] << 8 | this[e + 3];
        };
        u.prototype.readFloatLE = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 4, this.length);
            return i.read(this, e, true, 23, 4);
        };
        u.prototype.readFloatBE = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 4, this.length);
            return i.read(this, e, false, 23, 4);
        };
        u.prototype.readDoubleLE = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 8, this.length);
            return i.read(this, e, true, 52, 8);
        };
        u.prototype.readDoubleBE = function t(e, r) {
            e = e >>> 0;
            if (!r) R(e, 8, this.length);
            return i.read(this, e, false, 52, 8);
        };
        function P(t, e, r, n, i, o) {
            if (!u.isBuffer(t)) throw new TypeError('"buffer" argument must be a Buffer instance');
            if (e > i || e < o) throw new RangeError('"value" argument is out of bounds');
            if (r + n > t.length) throw new RangeError("Index out of range");
        }
        u.prototype.writeUIntLE = function t(e, r, n, i) {
            e = +e;
            r = r >>> 0;
            n = n >>> 0;
            if (!i) {
                var o = Math.pow(2, 8 * n) - 1;
                P(this, e, r, n, o, 0);
            }
            var s = 1;
            var f = 0;
            this[r] = e & 255;
            while (++f < n && (s *= 256)) {
                this[r + f] = e / s & 255;
            }
            return r + n;
        };
        u.prototype.writeUIntBE = function t(e, r, n, i) {
            e = +e;
            r = r >>> 0;
            n = n >>> 0;
            if (!i) {
                var o = Math.pow(2, 8 * n) - 1;
                P(this, e, r, n, o, 0);
            }
            var s = n - 1;
            var f = 1;
            this[r + s] = e & 255;
            while (--s >= 0 && (f *= 256)) {
                this[r + s] = e / f & 255;
            }
            return r + n;
        };
        u.prototype.writeUInt8 = function t(e, r, n) {
            e = +e;
            r = r >>> 0;
            if (!n) P(this, e, r, 1, 255, 0);
            this[r] = e & 255;
            return r + 1;
        };
        u.prototype.writeUInt16LE = function t(e, r, n) {
            e = +e;
            r = r >>> 0;
            if (!n) P(this, e, r, 2, 65535, 0);
            this[r] = e & 255;
            this[r + 1] = e >>> 8;
            return r + 2;
        };
        u.prototype.writeUInt16BE = function t(e, r, n) {
            e = +e;
            r = r >>> 0;
            if (!n) P(this, e, r, 2, 65535, 0);
            this[r] = e >>> 8;
            this[r + 1] = e & 255;
            return r + 2;
        };
        u.prototype.writeUInt32LE = function t(e, r, n) {
            e = +e;
            r = r >>> 0;
            if (!n) P(this, e, r, 4, 4294967295, 0);
            this[r + 3] = e >>> 24;
            this[r + 2] = e >>> 16;
            this[r + 1] = e >>> 8;
            this[r] = e & 255;
            return r + 4;
        };
        u.prototype.writeUInt32BE = function t(e, r, n) {
            e = +e;
            r = r >>> 0;
            if (!n) P(this, e, r, 4, 4294967295, 0);
            this[r] = e >>> 24;
            this[r + 1] = e >>> 16;
            this[r + 2] = e >>> 8;
            this[r + 3] = e & 255;
            return r + 4;
        };
        u.prototype.writeIntLE = function t(e, r, n, i) {
            e = +e;
            r = r >>> 0;
            if (!i) {
                var o = Math.pow(2, 8 * n - 1);
                P(this, e, r, n, o - 1, -o);
            }
            var s = 0;
            var f = 1;
            var u = 0;
            this[r] = e & 255;
            while (++s < n && (f *= 256)) {
                if (e < 0 && u === 0 && this[r + s - 1] !== 0) {
                    u = 1;
                }
                this[r + s] = (e / f >> 0) - u & 255;
            }
            return r + n;
        };
        u.prototype.writeIntBE = function t(e, r, n, i) {
            e = +e;
            r = r >>> 0;
            if (!i) {
                var o = Math.pow(2, 8 * n - 1);
                P(this, e, r, n, o - 1, -o);
            }
            var s = n - 1;
            var f = 1;
            var u = 0;
            this[r + s] = e & 255;
            while (--s >= 0 && (f *= 256)) {
                if (e < 0 && u === 0 && this[r + s + 1] !== 0) {
                    u = 1;
                }
                this[r + s] = (e / f >> 0) - u & 255;
            }
            return r + n;
        };
        u.prototype.writeInt8 = function t(e, r, n) {
            e = +e;
            r = r >>> 0;
            if (!n) P(this, e, r, 1, 127, -128);
            if (e < 0) e = 255 + e + 1;
            this[r] = e & 255;
            return r + 1;
        };
        u.prototype.writeInt16LE = function t(e, r, n) {
            e = +e;
            r = r >>> 0;
            if (!n) P(this, e, r, 2, 32767, -32768);
            this[r] = e & 255;
            this[r + 1] = e >>> 8;
            return r + 2;
        };
        u.prototype.writeInt16BE = function t(e, r, n) {
            e = +e;
            r = r >>> 0;
            if (!n) P(this, e, r, 2, 32767, -32768);
            this[r] = e >>> 8;
            this[r + 1] = e & 255;
            return r + 2;
        };
        u.prototype.writeInt32LE = function t(e, r, n) {
            e = +e;
            r = r >>> 0;
            if (!n) P(this, e, r, 4, 2147483647, -2147483648);
            this[r] = e & 255;
            this[r + 1] = e >>> 8;
            this[r + 2] = e >>> 16;
            this[r + 3] = e >>> 24;
            return r + 4;
        };
        u.prototype.writeInt32BE = function t(e, r, n) {
            e = +e;
            r = r >>> 0;
            if (!n) P(this, e, r, 4, 2147483647, -2147483648);
            if (e < 0) e = 4294967295 + e + 1;
            this[r] = e >>> 24;
            this[r + 1] = e >>> 16;
            this[r + 2] = e >>> 8;
            this[r + 3] = e & 255;
            return r + 4;
        };
        function F(t, e, r, n, i, o) {
            if (r + n > t.length) throw new RangeError("Index out of range");
            if (r < 0) throw new RangeError("Index out of range");
        }
        function z(t, e, r, n, o) {
            e = +e;
            r = r >>> 0;
            if (!o) {
                F(t, e, r, 4, 3.4028234663852886e38, -3.4028234663852886e38);
            }
            i.write(t, e, r, n, 23, 4);
            return r + 4;
        }
        u.prototype.writeFloatLE = function t(e, r, n) {
            return z(this, e, r, true, n);
        };
        u.prototype.writeFloatBE = function t(e, r, n) {
            return z(this, e, r, false, n);
        };
        function q(t, e, r, n, o) {
            e = +e;
            r = r >>> 0;
            if (!o) {
                F(t, e, r, 8, 1.7976931348623157e308, -1.7976931348623157e308);
            }
            i.write(t, e, r, n, 52, 8);
            return r + 8;
        }
        u.prototype.writeDoubleLE = function t(e, r, n) {
            return q(this, e, r, true, n);
        };
        u.prototype.writeDoubleBE = function t(e, r, n) {
            return q(this, e, r, false, n);
        };
        u.prototype.copy = function t(e, r, n, i) {
            if (!n) n = 0;
            if (!i && i !== 0) i = this.length;
            if (r >= e.length) r = e.length;
            if (!r) r = 0;
            if (i > 0 && i < n) i = n;
            if (i === n) return 0;
            if (e.length === 0 || this.length === 0) return 0;
            if (r < 0) {
                throw new RangeError("targetStart out of bounds");
            }
            if (n < 0 || n >= this.length) throw new RangeError("sourceStart out of bounds");
            if (i < 0) throw new RangeError("sourceEnd out of bounds");
            if (i > this.length) i = this.length;
            if (e.length - r < i - n) {
                i = e.length - r + n;
            }
            var o = i - n;
            var s;
            if (this === e && n < r && r < i) {
                for (s = o - 1; s >= 0; --s) {
                    e[s + r] = this[s + n];
                }
            } else if (o < 1e3) {
                for (s = 0; s < o; ++s) {
                    e[s + r] = this[s + n];
                }
            } else {
                Uint8Array.prototype.set.call(e, this.subarray(n, n + o), r);
            }
            return o;
        };
        u.prototype.fill = function t(e, r, n, i) {
            if (typeof e === "string") {
                if (typeof r === "string") {
                    i = r;
                    r = 0;
                    n = this.length;
                } else if (typeof n === "string") {
                    i = n;
                    n = this.length;
                }
                if (e.length === 1) {
                    var o = e.charCodeAt(0);
                    if (o < 256) {
                        e = o;
                    }
                }
                if (i !== undefined && typeof i !== "string") {
                    throw new TypeError("encoding must be a string");
                }
                if (typeof i === "string" && !u.isEncoding(i)) {
                    throw new TypeError("Unknown encoding: " + i);
                }
            } else if (typeof e === "number") {
                e = e & 255;
            }
            if (r < 0 || this.length < r || this.length < n) {
                throw new RangeError("Out of range index");
            }
            if (n <= r) {
                return this;
            }
            r = r >>> 0;
            n = n === undefined ? this.length : n >>> 0;
            if (!e) e = 0;
            var s;
            if (typeof e === "number") {
                for (s = r; s < n; ++s) {
                    this[s] = e;
                }
            } else {
                var f = u.isBuffer(e) ? e : new u(e, i);
                var a = f.length;
                for (s = 0; s < n - r; ++s) {
                    this[s + r] = f[s % a];
                }
            }
            return this;
        };
        var J = /[^+/0-9A-Za-z-_]/g;
        function Y(t) {
            t = t.trim().replace(J, "");
            if (t.length < 2) return "";
            while (t.length % 4 !== 0) {
                t = t + "=";
            }
            return t;
        }
        function V(t) {
            if (t < 16) return "0" + t.toString(16);
            return t.toString(16);
        }
        function X(t, e) {
            e = e || Infinity;
            var r;
            var n = t.length;
            var i = null;
            var o = [];
            for (var s = 0; s < n; ++s) {
                r = t.charCodeAt(s);
                if (r > 55295 && r < 57344) {
                    if (!i) {
                        if (r > 56319) {
                            if ((e -= 3) > -1) o.push(239, 191, 189);
                            continue;
                        } else if (s + 1 === n) {
                            if ((e -= 3) > -1) o.push(239, 191, 189);
                            continue;
                        }
                        i = r;
                        continue;
                    }
                    if (r < 56320) {
                        if ((e -= 3) > -1) o.push(239, 191, 189);
                        i = r;
                        continue;
                    }
                    r = (i - 55296 << 10 | r - 56320) + 65536;
                } else if (i) {
                    if ((e -= 3) > -1) o.push(239, 191, 189);
                }
                i = null;
                if (r < 128) {
                    if ((e -= 1) < 0) break;
                    o.push(r);
                } else if (r < 2048) {
                    if ((e -= 2) < 0) break;
                    o.push(r >> 6 | 192, r & 63 | 128);
                } else if (r < 65536) {
                    if ((e -= 3) < 0) break;
                    o.push(r >> 12 | 224, r >> 6 & 63 | 128, r & 63 | 128);
                } else if (r < 1114112) {
                    if ((e -= 4) < 0) break;
                    o.push(r >> 18 | 240, r >> 12 & 63 | 128, r >> 6 & 63 | 128, r & 63 | 128);
                } else {
                    throw new Error("Invalid code point");
                }
            }
            return o;
        }
        function G(t) {
            var e = [];
            for (var r = 0; r < t.length; ++r) {
                e.push(t.charCodeAt(r) & 255);
            }
            return e;
        }
        function H(t, e) {
            var r, n, i;
            var o = [];
            for (var s = 0; s < t.length; ++s) {
                if ((e -= 2) < 0) break;
                r = t.charCodeAt(s);
                n = r >> 8;
                i = r % 256;
                o.push(i);
                o.push(n);
            }
            return o;
        }
        function Z(t) {
            return n.toByteArray(Y(t));
        }
        function K(t, e, r, n) {
            for (var i = 0; i < n; ++i) {
                if (i + r >= e.length || i >= t.length) break;
                e[i + r] = t[i];
            }
            return i;
        }
        function Q(t) {
            return t instanceof ArrayBuffer || t != null && t.constructor != null && t.constructor.name === "ArrayBuffer" && typeof t.byteLength === "number";
        }
        function W(t) {
            return typeof ArrayBuffer.isView === "function" && ArrayBuffer.isView(t);
        }
        function $(t) {
            return t !== t;
        }
    }, {
        "base64-js": 10,
        ieee754: 12
    } ],
    12: [ function(t, e, r) {
        r.read = function(t, e, r, n, i) {
            var o, s;
            var f = i * 8 - n - 1;
            var u = (1 << f) - 1;
            var a = u >> 1;
            var h = -7;
            var c = r ? i - 1 : 0;
            var l = r ? -1 : 1;
            var p = t[e + c];
            c += l;
            o = p & (1 << -h) - 1;
            p >>= -h;
            h += f;
            for (;h > 0; o = o * 256 + t[e + c], c += l, h -= 8) {}
            s = o & (1 << -h) - 1;
            o >>= -h;
            h += n;
            for (;h > 0; s = s * 256 + t[e + c], c += l, h -= 8) {}
            if (o === 0) {
                o = 1 - a;
            } else if (o === u) {
                return s ? NaN : (p ? -1 : 1) * Infinity;
            } else {
                s = s + Math.pow(2, n);
                o = o - a;
            }
            return (p ? -1 : 1) * s * Math.pow(2, o - n);
        };
        r.write = function(t, e, r, n, i, o) {
            var s, f, u;
            var a = o * 8 - i - 1;
            var h = (1 << a) - 1;
            var c = h >> 1;
            var l = i === 23 ? Math.pow(2, -24) - Math.pow(2, -77) : 0;
            var p = n ? 0 : o - 1;
            var g = n ? 1 : -1;
            var d = e < 0 || e === 0 && 1 / e < 0 ? 1 : 0;
            e = Math.abs(e);
            if (isNaN(e) || e === Infinity) {
                f = isNaN(e) ? 1 : 0;
                s = h;
            } else {
                s = Math.floor(Math.log(e) / Math.LN2);
                if (e * (u = Math.pow(2, -s)) < 1) {
                    s--;
                    u *= 2;
                }
                if (s + c >= 1) {
                    e += l / u;
                } else {
                    e += l * Math.pow(2, 1 - c);
                }
                if (e * u >= 2) {
                    s++;
                    u /= 2;
                }
                if (s + c >= h) {
                    f = 0;
                    s = h;
                } else if (s + c >= 1) {
                    f = (e * u - 1) * Math.pow(2, i);
                    s = s + c;
                } else {
                    f = e * Math.pow(2, c - 1) * Math.pow(2, i);
                    s = 0;
                }
            }
            for (;i >= 8; t[r + p] = f & 255, p += g, f /= 256, i -= 8) {}
            s = s << i | f;
            a += i;
            for (;a > 0; t[r + p] = s & 255, p += g, s /= 256, a -= 8) {}
            t[r + p - g] |= d * 128;
        };
    }, {} ],
    13: [ function(t, e, r) {
        var n = e.exports = {};
        var i;
        var o;
        function s() {
            throw new Error("setTimeout has not been defined");
        }
        function f() {
            throw new Error("clearTimeout has not been defined");
        }
        (function() {
            try {
                if (typeof setTimeout === "function") {
                    i = setTimeout;
                } else {
                    i = s;
                }
            } catch (t) {
                i = s;
            }
            try {
                if (typeof clearTimeout === "function") {
                    o = clearTimeout;
                } else {
                    o = f;
                }
            } catch (t) {
                o = f;
            }
        })();
        function u(t) {
            if (i === setTimeout) {
                return setTimeout(t, 0);
            }
            if ((i === s || !i) && setTimeout) {
                i = setTimeout;
                return setTimeout(t, 0);
            }
            try {
                return i(t, 0);
            } catch (e) {
                try {
                    return i.call(null, t, 0);
                } catch (e) {
                    return i.call(this, t, 0);
                }
            }
        }
        function a(t) {
            if (o === clearTimeout) {
                return clearTimeout(t);
            }
            if ((o === f || !o) && clearTimeout) {
                o = clearTimeout;
                return clearTimeout(t);
            }
            try {
                return o(t);
            } catch (e) {
                try {
                    return o.call(null, t);
                } catch (e) {
                    return o.call(this, t);
                }
            }
        }
        var h = [];
        var c = false;
        var l;
        var p = -1;
        function g() {
            if (!c || !l) {
                return;
            }
            c = false;
            if (l.length) {
                h = l.concat(h);
            } else {
                p = -1;
            }
            if (h.length) {
                d();
            }
        }
        function d() {
            if (c) {
                return;
            }
            var t = u(g);
            c = true;
            var e = h.length;
            while (e) {
                l = h;
                h = [];
                while (++p < e) {
                    if (l) {
                        l[p].run();
                    }
                }
                p = -1;
                e = h.length;
            }
            l = null;
            c = false;
            a(t);
        }
        n.nextTick = function(t) {
            var e = new Array(arguments.length - 1);
            if (arguments.length > 1) {
                for (var r = 1; r < arguments.length; r++) {
                    e[r - 1] = arguments[r];
                }
            }
            h.push(new y(t, e));
            if (h.length === 1 && !c) {
                u(d);
            }
        };
        function y(t, e) {
            this.fun = t;
            this.array = e;
        }
        y.prototype.run = function() {
            this.fun.apply(null, this.array);
        };
        n.title = "browser";
        n.browser = true;
        n.env = {};
        n.argv = [];
        n.version = "";
        n.versions = {};
        function v() {}
        n.on = v;
        n.addListener = v;
        n.once = v;
        n.off = v;
        n.removeListener = v;
        n.removeAllListeners = v;
        n.emit = v;
        n.prependListener = v;
        n.prependOnceListener = v;
        n.listeners = function(t) {
            return [];
        };
        n.binding = function(t) {
            throw new Error("process.binding is not supported");
        };
        n.cwd = function() {
            return "/";
        };
        n.chdir = function(t) {
            throw new Error("process.chdir is not supported");
        };
        n.umask = function() {
            return 0;
        };
    }, {} ]
}, {}, [ 9 ]);