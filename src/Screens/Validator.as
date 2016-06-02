/**
 * @author mikelownds
 */
package Screens 
{
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Validator extends MovieClip
	{
		
		private var _gameCallback : Function;
		private var _validationTimeout : Timer;
		private var _pause : Boolean = false;
		private var _validated : Boolean = false;
		
		private var _check : MovieClip = new checkmark();
		private var _x     : MovieClip = new xmark();
		
		private var _checkAdded : Boolean = false;
		private var _xAdded     : Boolean = false;
		
		public function Validator() 
		{
			_x.scaleX = _x.scaleY = 2;
			_check.scaleX = _check.scaleY = 2;
			
			_validationTimeout = new Timer(2000, 1);
			_validationTimeout.addEventListener(TimerEvent.TIMER_COMPLETE, timerCallback);
		}
		
		public function set callback(callback : Function) : void
		{
			_gameCallback = callback;
		}
		
		public function validate( correct : Point = null, miss : Point = null ) : void
		{
			if(correct != null)
			{
				_check.x = correct.x;
				_check.y = correct.y;
				_checkAdded = true;
				addChild(_check);
			}
			if(miss != null)
			{
				_x.x = miss.x;
				_x.y = miss.y;
				_xAdded = true;
				addChild(_x);
			}
			
			_validated = true;
			_validationTimeout.start();
			//_gameCallback();
		}
		
		public function get paused() : Boolean
		{
			return _pause;
		}
		
		public function set paused( p : Boolean ) : void
		{
			_pause = p;
			
			if(_validated)
				timerCallback();
		}
		
		private function timerCallback(e:TimerEvent = null) : void
		{
			if(_pause)
				return;
			
			_validationTimeout.reset();
			_validated = false;
			
			if(_checkAdded)
			{
				removeChild(_check);
				_checkAdded = false;
			}
			if(_xAdded)
			{
				removeChild(_x);
				_xAdded = false;
			}
			
			_gameCallback();
		}
	}

}