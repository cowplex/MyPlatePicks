/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Graphics;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.gskinner.motion.GTween;
	
	public class Pause extends Sprite
	{
		
		private static const TARGET_SCALE : Number = 0.75;
		private static const SEARCH_SCALE : Number = 1.5;
		private static const TARGET_RADIUS : int   = 20;
		private static const SLIDER_TRACK_LENGTH : int   = 100;
		
		private static const TARGET_DEFAULT : Number = 265 + TARGET_RADIUS;
		
		private var _pauseIcon : SimpleButton;//Sprite;
		private var _pauseIconTarget : Rectangle;
		private var _pauseIconStart : Point;
		
		private var _grabTimeout : Timer;
		private var _slideTween : GTween;
		private var _tracking : Boolean = true;
		
		private var _pauseCallback : Function;
		
		private var _paused : Boolean = false;
		
		public function Pause()
		{
			_pauseIcon = new btn_pause();
			
			_pauseIcon.x = 17 + TARGET_RADIUS;
			_pauseIcon.y = TARGET_DEFAULT;
			
			_pauseIcon.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { togglePause(); } );
			
			_pauseIconTarget = new Rectangle(_pauseIcon.x - _pauseIcon.width / 2 + _pauseIcon.width * TARGET_SCALE / 2,// * (1 - TARGET_SCALE), // x
			                                 _pauseIcon.y - _pauseIcon.height / 2 + _pauseIcon.height * TARGET_SCALE / 2,// * (1 - TARGET_SCALE), // y 
			                                 _pauseIcon.width * TARGET_SCALE, // width
			                                 _pauseIcon.height * TARGET_SCALE); // height
			
			_pauseIconStart = new Point(_pauseIconTarget.x, _pauseIconTarget.y);
			
			addChild(_pauseIcon);
			
			_grabTimeout = new Timer(500, 1);
			_grabTimeout.addEventListener(TimerEvent.TIMER_COMPLETE, resetButton);
		}
		
		public function resetButton(e:TimerEvent = null) : void
		{
			_slideTween = new GTween(_pauseIconTarget, .5, {y:TARGET_DEFAULT});
			_slideTween.onComplete = tweenCallback;
			_tracking = false;
		}
		
		public function set pauseCallback( f : Function ) : void
		{
			_pauseCallback = f;
		}
			
		public function get paused() : Boolean
		{
			return _paused;
		}
		
		public function get detectionArea() : Rectangle
		{
			return(new Rectangle(_pauseIconTarget.x, _pauseIconTarget.y - _pauseIconTarget.height * (SEARCH_SCALE - 1), _pauseIconTarget.width, _pauseIconTarget.height * SEARCH_SCALE));
		}
		
		public function detectHit( motion : Rectangle ) : void
		{
			if(_tracking && motion.width * motion.height > 50 && detectionArea.intersects(motion))
			{
				//_pauseIcon.y -= _pauseIconTarget.y - (motion.y + (motion.height / 2) - (_pauseIconTarget.height / 2));
				if(motion.y + motion.height < 320)
					_pauseIconTarget.y = motion.y + (motion.height / 2);
				if(TARGET_DEFAULT - _pauseIconTarget.y >= SLIDER_TRACK_LENGTH)
				{
					togglePause();
					resetButton();
				}
				_grabTimeout.reset();
			}
			_pauseIcon.y = _pauseIconTarget.y - ((_pauseIcon.height - _pauseIconTarget.height) /2);
			_grabTimeout.start();
		}
		
		private function togglePause() : void
		{
			_paused = !_paused;
			_pauseCallback(_paused);
		}
		
		private function tweenCallback(tween:GTween) : void
		{
			_tracking = true;
		}
	}

}