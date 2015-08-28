package abv.sys.gui;

class AU{

	inline function new(){ }

	public static function playSound(path:String)
	{
		GUI.playMusic(path,-1); 
	}// playSound()
	
	public static function playMusic(path:String)
	{
		GUI.playMusic(path,0); 
	}// playMusic()
	

}// abv.sys.gui.AU

