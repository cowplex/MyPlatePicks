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
		
		private var _levelText : Array = new Array(new round_1(), new round_2(), new round_3());
		
		private var _timer : Timer;
		
		public function CongratsScreen()
		{
			_background = new BG_Congrats();
			_background.x = _background.width / 2;
			_background.y = _background.height / 2;
			addChild(_background);
		}
		
		public function set callback( f : Function ) : void
		{
			_callback = f;
		}
		
		public function correct(s : String) : void
		{
			_background.correct.text = s;
		}
		
		public function congratulate(level : Number) : void
		{
			if(level < _levelText.length)
			{
				_levelText[level].x = -19 + _background.x;
				_levelText[level].y = 137.65 + _background.y;
				addChild(_levelText[level]);
			}
			level--;
			if(level < _levelText.length)
			{
				_levelText[level].x = -15.55 + _background.x;
				_levelText[level].y = 14.70 + _background.y;
				addChild(_levelText[level]);
			}
			
			_timer = new Timer(5000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timeout);
			_timer.start();
		}
		
		private function timeout(e:TimerEvent) : void
		{
			for(var i:int = 0; i < _levelText.length; i++)
			{
				if(this.contains(_levelText[i]))
					removeChild(_levelText[i]);
			}
			_callback();
		}
	}

}