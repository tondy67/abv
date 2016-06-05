package abv.sys.cpp;

class AU{

	public static function playSound(path:String)
	{
		SD.playMusic(path,-1); 
	}// playSound()
	
	public static function playMusic(path:String)
	{
		SD.playMusic(path,0); 
	}// playMusic()
	

}// abv.sys.cpp.AU

