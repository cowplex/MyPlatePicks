/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	public class Main extends Sprite
	{
		
		private var _timer : MovieClip;
		private var _timerApple : MovieClip;
		private var _questionArea : MovieClip;
		
		public function Main()
		{
			// White Question Area Background
			_questionArea = new overlay_bar_small();
			_questionArea.x = 471/2 + 78;
			_questionArea.y = 71/2 + 64 + 320 + 20;
			addChild(_questionArea);
			
			// Create timer
			_timer = new timer();
			_timer.x = 143.45 / 2;
			_timer.y = 240;
			addChild(_timer);
			
			// Create timer apple
			_timerApple = new timer_apple();
			_timer.addChild(_timerApple);
			
		}
	}

}