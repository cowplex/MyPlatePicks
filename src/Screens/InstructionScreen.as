/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class InstructionScreen extends MovieClip
	{
		
		private var _background : BG_instructions;
		private var _timeout : Timer;
		private var _callback : Function;
		
		public function InstructionScreen()
		{
			_background = new BG_instructions();
			addChild(_background);
			
			_timeout = new Timer(7000, 1);
			_timeout.addEventListener(TimerEvent.TIMER_COMPLETE, timerCallback);
			_timeout.start();
		}
		
		public function set callback(callback : Function) : void
		{
			_callback = callback;
		}
		
		private function timerCallback(e:TimerEvent) : void
		{
			_callback();
		}
	}

}