/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Graphics;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import com.gskinner.motion.GTween;
	
	public class Pause extends MovieClip
	{
		
		private static const TARGET_SCALE : Number = 0.75;
		private static const SEARCH_SCALE : Number = 1.5;
		private static const TARGET_RADIUS : int   = 20;
		private static const SLIDER_TRACK_LENGTH : int   = 100;
		
		private static const TARGET_DEFAULT : Number = 265 + TARGET_RADIUS;
		
		private static var r:Number=0.212671;
		private static var g:Number=0.715160;
		private static var b:Number=0.072169;
		private var matrix:Array = [r, g, b, 0, 0,
		                            r, g, b, 0, 0,
		                            r, g, b, 0, 0,
		                            0, 0, 0, 1, 0];
		private var _filter : ColorMatrixFilter = new ColorMatrixFilter(matrix);
		private var _colorFilter : ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,1,0]);
		
		private var _pauseIcon : SimpleButton;//Sprite;
		private var _pauseIconTarget : Rectangle;
		private var _pauseIconStart : Point;
		
		private var _grabTimeout : Timer;
		private var _slideTween : GTween;
		private var _tracking : Boolean = true;
		
		private var _playButton : btn_play = new btn_play();
		private var _pauseScreen : MovieClip;
		
		private var _pauseCallback : Function;
		private var _resetCallback : Function;
		private var _quitCallback : Function;
		
		private var _paused : Boolean = false;
		private var _lastMusicState : Boolean;
		
		private var _jukebox : Jukebox;
		private var _musicButton : MovieClip;//BTN_MUSICNOTE;
		private var _resetButton : btn_replay;
		private var _quitButton : btn_home;//btn_quit;
		
		private var _quitComfirm : quit_confirm;
		
		public function Pause(j : Jukebox)
		{
			_jukebox = j;
			_lastMusicState = _jukebox.mute;
			
			_pauseIcon = new btn_pause();
			
			_pauseIcon.x = 60;
			_pauseIcon.y = 420;
			//_pauseIcon.x = 17 + TARGET_RADIUS;
			//_pauseIcon.y = TARGET_DEFAULT;
			
			_pauseIcon.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { togglePause(); } );
			
			_pauseIconTarget = new Rectangle(_pauseIcon.x - _pauseIcon.width / 2 + _pauseIcon.width * TARGET_SCALE / 2,// * (1 - TARGET_SCALE), // x
			                                 _pauseIcon.y - _pauseIcon.height / 2 + _pauseIcon.height * TARGET_SCALE / 2,// * (1 - TARGET_SCALE), // y 
			                                 _pauseIcon.width * TARGET_SCALE, // width
			                                 _pauseIcon.height * TARGET_SCALE); // height
			
			_pauseIconStart = new Point(_pauseIconTarget.x, _pauseIconTarget.y);
			
			addChild(_pauseIcon);
			
			_pauseScreen = new MovieClip;
			_pauseScreen.graphics.beginFill(0xFFFFFF, 0.7);
			//_pauseScreen.graphics.drawRoundRect(0,0,250, 480, 25);
			_pauseScreen.graphics.drawRoundRect(0,0,160 + 25, 480, 25);
			_pauseScreen.graphics.endFill();
			_pauseScreen.x = -_pauseScreen.width;
			addChild(_pauseScreen);
			
			_playButton.y = _pauseScreen.height / 2;
			_playButton.x = _pauseScreen.width - _playButton.width - 15;
			_playButton.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { togglePause(); } );
			_pauseScreen.addChild(_playButton);
			
			_musicButton = new PlayPause(_jukebox.mute);//new BTN_MUSICNOTE();//new MovieClip();
			//_musicButton.addChild(_jukebox.button);
			_musicButton.y = _pauseScreen.height / 2 - _playButton.height - 5;
			_musicButton.x = _pauseScreen.width - _musicButton.width - 15;
			//_musicButton.filters = (_jukebox.mute ? [_filter] : null);
			_musicButton.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void {  if(paused) {_lastMusicState = !_lastMusicState;} else {_jukebox.mute = !_jukebox.mute;}; _musicButton.mute = paused ? _lastMusicState : _jukebox.mute;/*_musicButton.filters = (_jukebox.mute ? new Array(_filter) : new Array());*/ });
			_pauseScreen.addChild(_musicButton);
			
			_resetButton = new btn_replay();
			_resetButton.y = _pauseScreen.height / 2 + _playButton.height + 5;
			_resetButton.x = _pauseScreen.width - _musicButton.width - 15;
			_resetButton.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { _jukebox.mute = _lastMusicState; _resetCallback() });
			_pauseScreen.addChild(_resetButton);
			
			_quitButton = new btn_home();//new btn_quit();
			_quitButton.y = _pauseScreen.height / 2 + _playButton.height + _resetButton.height + 5 * 2;
			_quitButton.x = _pauseScreen.width - _resetButton.width - 15;
			_quitButton.addEventListener(MouseEvent.MOUSE_DOWN,  quit);//function(e:MouseEvent):void { _quitCallback() });
			_pauseScreen.addChild(_quitButton);
			
			_quitComfirm = new quit_confirm();
			_quitComfirm.y = _pauseScreen.height / 2;
			_quitComfirm.x = -30 - (_quitComfirm.width / 2);
			_pauseScreen.addChild(_quitComfirm);
			
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
		
		public function set resetCallback( f : Function ) : void
		{
			_resetCallback = f;
		}
		
		public function set quitCallback( f : Function ) : void
		{
			_quitCallback = f;
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
			
			var tween_target : Number = (_paused) ? -25 : -_pauseScreen.width;
			new GTween(_pauseScreen, 0.35, {x:tween_target});
			
			if(paused)
				_jukebox.mute = true;
			else
				_jukebox.mute = _lastMusicState;
				
			if(paused)
				_quitComfirm.x = -30 - (_quitComfirm.width / 2);
				
			_pauseCallback(_paused);
		}
		
		private function tweenCallback(tween:GTween) : void
		{
			_tracking = true;
		}
		
		private function quit(e:MouseEvent = null) : void
		{
			var tween_target : Number = _quitComfirm.x > 0 ? (-30 - (_quitComfirm.width / 2)) : (stage.stageWidth / 2 + 15);
			new GTween(_quitComfirm, 0.35, {x:tween_target});
			
			_quitComfirm.yes.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { _quitCallback() });
			_quitComfirm.no.addEventListener(MouseEvent.MOUSE_DOWN,  quit);
		}
	}

}