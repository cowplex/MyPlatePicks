/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.display.Graphics;
	
	public class GameOverScreen extends MovieClip
	{
		
		private var _background : BG_game_over;
		
		public function GameOverScreen(s : Number)
		{
			//_background = new MovieClip();
			//_background.addChild(new BG_game_over());
			_background = new BG_game_over();
			_background.x = 320;
			_background.y = 240;
			
			_background.score.text = ""+s;
			
			addChild(_background);
		}
	}

}