/**
 * @author mikelownds
 */
package Screens 
{
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Validator extends MovieClip
	{
		
		private var _gameCallback : Function;
		
		private var _validationTimeout : Timer = new Timer(1000, 1);
				
		public function Validator(callback : Function) 
		{
			_gameCallback = callback;
			
			_validationTimeout.addEventListener(TimerEvent.TIMER_COMPLETE, timerCallback);
		}
		
		public function validate() : void
		{
			_validationTimeout.start();
			//_gameCallback();
		}
		
		private function timerCallback(e:TimerEvent) : void
		{
			_validationTimeout.reset();
			_gameCallback();
		}
	}

}