/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	//import spark.effects.animation.Animation;
	import com.gskinner.motion.GTween;
	//import fl.transitions.Tween;
 	//import mx.transitions.easing.*;
 	//import mx.transitions.TweenEvent;
	
	public class Main extends Sprite
	{
		
		private var _timer : MovieClip;
		private var _timerApple : MovieClip;
		private var _questionArea : MovieClip;
		
		private var _questionTimer : GTween;//Timer;
		private var _timerCallback : Function;
		
		public function Main()
		{
			// White Question Area Background
			_questionArea = new overlay_bar_small();
			_questionArea.x = 471/2 + 78;
			_questionArea.y = 71/2 + 64 + 320 + 20;
			addChild(_questionArea);
			_questionArea.gotoAndStop(13);
			
			// Create timer
			_timer = new timer();
			_timer.x = 143.45 / 2;
			_timer.y = 240;
			addChild(_timer);
			
			// Create timer apple
			_timerApple = new timer_apple();
			_timerApple.x=18.4;
			_timerApple.y=-195.95;
			_timer.addChildAt(_timerApple, 0);
			_timerApple.gotoAndStop(1);
			
		}
		
		public function setupTimerCallback( callback : Function) : void
		{
			_timerCallback = callback;
		}
		
		public function timerStart( time : Number ) : void
		{
			/*_questionTimer = new Timer(time * 1000, 1);
			_questionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCallback);
			//_questionTimer = new Tween(_timerApple, "y", Regular.easeOut, -195.95, 120, time, true);
			//_questionTimer.addEventListener(TweenEvent.MOTION_FINISH, timerCallback);
			_questionTimer.start();*/
			
			//_questionTimer = new Animation(time * 1000, "_timerApple.y", -195.95, 120);
			//_questionTimer.play();
			
			_timerApple.y = -195.95;
			_questionTimer = new GTween(_timerApple, time, {y:120});
			_questionTimer.onComplete = timerCallback;
		}
		
		public function timerStop() : void
		{
			//_questionTimer.stop();
			_questionTimer.paused = true;
			_timerApple.y = -195.95;
		}
		
		private function timerCallback(tween:GTween/*e:TimerEvent*/) : void
		{
			_timerCallback();
		}
		
	}

}