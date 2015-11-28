package abv.lib;
/**
 * Enums
 **/

enum States{
	DISABLED;
	NORMAL;
	ACTIVE;
	VISITED;
	HOVER;
	FOCUS;
	LINK;
	PRESSED;
	CLICK;
}

enum OsName{
	BSD;
	LINUX;
	MAC;
	WINDOWS;
}

enum RenderKind{
	BOX;
	VBOX;
	HBOX;
	FBOX;
	BUTTON;
	LABEL;
	IMAGE;
	DIALOG;
	POINT;
	LINE;
	TRIANGLE;
	CIRCLE;
	ELLIPSE;
	SHAPE;
	RK_NONE;
}

enum RenderContext{
	CTX_1D;
	CTX_2D;
	CTX_3D;
}

enum ValType{
	INT;
	FLOAT;
	STRING;
	ARRAY_INT;
	ARRAY_FLOAT;
	ARRAY_STRING;
	UNKNOWN;
}



// abv.lib.Enums
