/**
 * @author mikelownds
 */
package Screens
{
	import flash.display.MovieClip;
	import flash.display.Graphics;
	
	public class MainMenu extends MovieClip
	{
		
		public var _background : MovieClip;
		public var playButton : MovieClip;
		
		public function MainMenu()
		{
			/* Create Play Button */
			{
				/*playButton = new MovieClip();
				// define the line style
				playButton.graphics.lineStyle(2,0x000000);
				// define the fill
				playButton.graphics.beginFill(0x666699);
				//Draw the circle
				playButton.graphics.drawCircle(0, 0, 100);
				playButton.graphics.endFill();
				
				playButton.graphics.beginFill(0x996666);
				// set the starting point for the play icon
				playButton.graphics.moveTo(-50,-50);
				// move the line through a series of coordinates
				playButton.graphics.lineTo(-50,50);
				playButton.graphics.lineTo(50,0);
				
				playButton.graphics.endFill();*/
				
				_background = new BG_mainmenu();
				_background.x = 320;
				_background.y = 240;
				addChild(_background);
				
				playButton = new MovieClip();
				playButton.addChild(new btn_play_mainmenu());
				
				playButton.x = 320;
				playButton.y = 240;
				
				addChild(playButton);
			}
		}
	}
}