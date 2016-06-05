package abv.sys.cpp;

import abv.ds.VFS;

using abv.sys.ST;

class FS{

	public static function getText(path:String)
	{
		return VFS.open(path);
	}// getText()

	public static function loadText(path:String)
	{
		return ST.open(path);
	}// loadText()



}// abv.sys.cpp.FS

