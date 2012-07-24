/**
 * @author mikelownds
 */
package Screens
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class MainMenu extends Sprite
	{
		public var playButton : Sprite;
		public function MainMenu()
		{
			/* Create Play Button */
			{
				playButton = new Sprite();
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
				
				playButton.graphics.endFill();
				
				playButton.x = 320;
				playButton.y = 240;
				
				addChild(playButton);
			}
		}
	}
}