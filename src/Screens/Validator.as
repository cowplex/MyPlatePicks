/**
 * @author mikelownds
 */
package Screens 
{
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	// !!! HACK !!!
	import flash.display.Sprite;
	
	public class Validator extends MovieClip
	{
		
		private var _gameCallback : Function;
		private var _validationTimeout : Timer = new Timer(1000, 1);
		
		private var _check : MovieClip = new checkmark();
		
		// !!! HACK !!! because it's called "x" in the .swc, so I can't load it with "new x()"
		[Embed(source="../../Flash/MyPlate_fl8.swf", symbol="x")]
		private var xmark:Class;
		private var _x     : Sprite = new xmark();
		// !!! HACK !!!
		
		private var _checkAdded : Boolean = false;
		private var _xAdded     : Boolean = false;
		
		public function Validator(callback : Function) 
		{
			_gameCallback = callback;
			
			_x.scaleX = _x.scaleY = 2;
			_check.scaleX = _check.scaleY = 2;
			
			_validationTimeout.addEventListener(TimerEvent.TIMER_COMPLETE, timerCallback);
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
			
			_validationTimeout.start();
			//_gameCallback();
		}
		
		private function timerCallback(e:TimerEvent) : void
		{
			_validationTimeout.reset();
			
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