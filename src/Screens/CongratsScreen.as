/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class CongratsScreen extends MovieClip
	{
		
		private var _background : MovieClip;
		private var _callback : Function;
		
		private var _timer : Timer;
		
		public function CongratsScreen()
		{
			_background = new BG_congrats();
			_background.x = _background.width / 2;
			_background.y = _background.height / 2;
			addChild(_background);
		}
		
		public function set callback( f : Function ) : void
		{
			_callback = f;
		}
		
		public function congratulate() : void
		{
			_timer = new Timer(5000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timeout);
			_timer.start();
		}
		
		private function timeout(e:TimerEvent) : void
		{
			_callback();
		}
	}

}