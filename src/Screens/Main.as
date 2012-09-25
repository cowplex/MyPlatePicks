/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import com.gskinner.motion.GTween;
	import flash.media.Sound;
    import flash.media.SoundChannel;
	//import fl.transitions.Tween;
 	//import mx.transitions.easing.*;
 	//import mx.transitions.TweenEvent;
	
	public class Main extends MovieClip
	{
		[Embed(source="assets/countdown.mp3")] private var countdown:Class;
		[Embed(source="assets/timeup.mp3")] private var timeup:Class;
		
		private var _countdownSound : Sound = new countdown();
		private var _channel : SoundChannel;
		private var _timeupSound : Sound = new timeup();
		
		private var _background : MovieClip;
		private var _timer : MovieClip;
		private var _timerApple : MovieClip;
		private var _questionArea : MovieClip;
		
		private var _screenMask : MovieClip;
		private var _overlayMask : MovieClip;
		
		private var _questionTimer : GTween;//Timer;
		private var _timerCallback : Function;
		
		public function Main()
		{
			// Create mask
			_screenMask = new MovieClip();
			_screenMask.graphics.lineStyle(1,0x000000);
			_screenMask.graphics.beginFill(0x000000);
			_screenMask.graphics.drawRect(0,0,640,480);
			_screenMask.graphics.endFill();
			addChild(_screenMask);
			
			// Create game background
			_background = new BG_LOGOS();//new BG_game_play();
			_background.x = _background.width /2;
			_background.y = _background.height /2;
			addChild(_background);
			
			// Create timer
			_timer = new timer();
			_timer.x = 143.45 / 2;//90.25;
			_timer.y = 240;//247.55;
			addChild(_timer);
			
			// Create timer apple
			_timerApple = new timer_apple();
			_timerApple.x=18.4;
			_timerApple.y=-195.95;
			_timer.addChildAt(_timerApple, 0);
			_timerApple.gotoAndStop(1);
			
			// White Question Area Background
			_questionArea = new overlay_bar_small();
			_questionArea.x = _questionArea.width/2 + 129; //471/2 + 78 + 110;
			trace(_questionArea.x);
			_questionArea.y = 15 + 71/2;
			addChild(_questionArea);
			_questionArea.gotoAndStop(13);
			
			// Add Masks
			_timer.mask = _screenMask;
			_questionArea.mask = _screenMask;
			
			// Create overlay mask
			_overlayMask = new MovieClip();
			_overlayMask.graphics.lineStyle(1,0x333333);
			_overlayMask.graphics.beginFill(0x333333);
			_overlayMask.graphics.drawRect(-200,-200,1040,880);
			_overlayMask.graphics.lineStyle(1,0x000000);
			_overlayMask.graphics.drawRect(0,0,640,480);
			_overlayMask.graphics.endFill();
			addChild(_overlayMask);
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
			
			if(_channel != null)
				_channel.stop();
			_channel = _countdownSound.play();
		}
		
		public function timerStop() : void
		{
			//_questionTimer.stop();
			_channel.stop();
			_questionTimer.paused = true;
			_timerApple.y = -195.95;
		}
		
		public function set timerPaused( pause : Boolean) : void
		{
			_questionTimer.paused = pause;
			pause ? _channel.stop() : _channel = _countdownSound.play();
		}
		
		private function timerCallback(tween:GTween/*e:TimerEvent*/) : void
		{
			_channel.stop();
			_timeupSound.play();
			_timerCallback();
		}
		
	}

}