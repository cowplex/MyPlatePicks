/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.display.Graphics;
	
	public class GameOverScreen extends MovieClip
	{
		
		private var _background : MovieClip;
		
		public function GameOverScreen()
		{
			_background = new MovieClip();
			//_background.addChild(new BG_game_over());
			_background.x = 320;
			_background.y = 240;
			addChild(_background);
		}
	}

}