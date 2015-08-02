package abv.sys.gui;

import abv.bus.MD;
import haxe.Resource;

using abv.sys.ST;

class Audio{

	inline function new(){ }

	public static function play(path:String,action=MD.NONE)
	{
		GUI.playMusic(path,action);
	}// play()
	

}// abv.sys.gui.Audio

