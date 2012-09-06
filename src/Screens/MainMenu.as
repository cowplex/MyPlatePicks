/**
 * @author mikelownds
 */
package Screens
{
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	
	public class MainMenu extends MovieClip
	{
		
		private var _background : MovieClip;
		private var _playButton : MovieClip;
		private var _logo       : MovieClip;
		
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
				
				_playButton = new MovieClip();
				_playButton.addChild(new btn_play_mainmenu());
				_playButton.x = 320;
				_playButton.y = 320;
				addChild(_playButton);
				
				_logo = new LOGO_myplate();
				_logo.x = 320;
				_logo.y = 128;
				addChild(_logo);
			}
		}
		
		public function set playCallback( f : Function ) : void
		{
			_playButton.addEventListener(MouseEvent.MOUSE_DOWN, f);
		}
	}
}