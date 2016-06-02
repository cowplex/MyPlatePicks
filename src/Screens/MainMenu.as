/**
 * @author mikelownds
 */
package Screens
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import com.gskinner.motion.GTween;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class MainMenu extends MovieClip
	{
		private static var ANIMATION_START : Number = 400;
				
		private var _background : MovieClip;
		private var _playButton : MovieClip;
		private var _logo       : MovieClip;
		private var _credits    : MovieClip;
		
		private var _jukebox : Jukebox;
		
		private var _settings : btn_options;
		private var _settingsButtons : Array;
		
		private var _socialMedia : MovieClip;//btn_socialmedia_up;
		private var _socialMediaStates : Array = new Array(new btn_socialmedia_up(), new btn_socialmedia_down());
		private var _socialMediaButtons : Array;
		
		private var _creditTween : GTween; 
		
		public function MainMenu(j : Jukebox)
		{
			_jukebox = j;
			
			
			_background = new BG_mainmenu();
			_background.x = 320;
			_background.y = 240;
			addChild(_background);
			
			_background.c1.gotoAndPlay(1);
			_background.c2.gotoAndPlay(1);
			
			_playButton = new MovieClip();
			_playButton.addChild(new btn_play_mainmenu());
			_playButton.x = 320;
			_playButton.y = 320;
			addChild(_playButton);
			
			_logo = new LOGO_myplate();
			_logo.x = 320;
			_logo.y = 128;
			addChild(_logo);
			
			_logo.scaleX = _logo.scaleY = 0;
			new GTween(_logo, 0.5, {scaleX:1, scaleY:1});
			
			_credits = new BG_credits();
			_credits.x = 320;
			_credits.y = 240;
			_credits.back.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void {_creditTween.beginning(); add_remove(_credits, 0); _jukebox.play(0); });
			
		var i:int;
						
			_settings = new btn_options();
			_settingsButtons = new Array(new btn_info(), new PlayPause()/*new BTN_MUSICNOTE()*/);
			_settings.x = 60;
			_settings.y = ANIMATION_START;
			_settings.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { animate(_settingsButtons); });
			
			_settingsButtons[0].addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { add_remove(_credits, 1); _credits.credits.y = 3590; _creditTween = new GTween(_credits.credits, 80, {y:(-_credits.credits.height)}); _jukebox.play(5); });
			_settingsButtons[1].addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void {  _jukebox.mute = !_jukebox.mute; _settingsButtons[1].mute = _jukebox.mute; });
			for(i = _settingsButtons.length - 1; i >= 0; i--)
			{
				_settingsButtons[i].x = 60;
				_settingsButtons[i].y = ANIMATION_START;
				_settingsButtons[i].scaleX = _settingsButtons[i].scaleY = 0;
				addChild(_settingsButtons[i]);
			}
			addChild(_settings);
			
			_socialMedia = new MovieClip();//new btn_socialmedia_up();
			_socialMedia.addChild(_socialMediaStates[0]);
			_socialMediaButtons = new Array(new BTN_myplate(), new BTN_KidsCom(), new btn_youtube(), new btn_facebook(), new BTN_TWITTER());
			_socialMedia.x = 580;
			_socialMedia.y = ANIMATION_START;
			_socialMedia.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { animate(_socialMediaButtons, 1); });
			
			_socialMediaButtons[0].addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {navigateToURL(new URLRequest("http://www.choosemyplate.gov/"));});
			_socialMediaButtons[1].addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {navigateToURL(new URLRequest("http://kidscom.com/"));});
			_socialMediaButtons[2].addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {navigateToURL(new URLRequest("http://www.youtube.com/user/OfficialKidsCom?feature=watch"));});
			_socialMediaButtons[3].addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {navigateToURL(new URLRequest("https://www.facebook.com/KidsCom?ref=ts"));});
			_socialMediaButtons[4].addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {navigateToURL(new URLRequest("https://twitter.com/IdeaSeekers/"));} );
			for(i = _socialMediaButtons.length - 1; i >= 0; i--)
			{
				_socialMediaButtons[i].x = 580;
				_socialMediaButtons[i].y = ANIMATION_START;
				_socialMediaButtons[i].scaleX = _socialMediaButtons[i].scaleY = 0;
				addChild(_socialMediaButtons[i]);
			}
			addChild(_socialMedia);
			
		}
		
		public function set playCallback( f : Function ) : void
		{
			_playButton.addEventListener(MouseEvent.MOUSE_DOWN, f);
		}
		
		private function add_remove( target : MovieClip, i : Number) : void
		{
			if(i == 1)
				addChild(target);
			else if(this.contains(target))
				removeChild(target);
		}
		
		private function animate( target : Array, orig : Number = 0 ) : void
		{
			var i : int;
			var cumulative : Number = 0;
			var animation_target : Number = ANIMATION_START;
			var animate_to_start : Boolean = (target[0].y != ANIMATION_START);
			
			var tween_target : Number;
			
			
			//for(i = 0; i < target.length; i++)
			for(i = target.length - 1; i >= 0; i--)
			{
				cumulative += 65;
				tween_target = (animate_to_start) ? ANIMATION_START : ANIMATION_START - cumulative;
				new GTween(target[i], 0.35, {y:tween_target});
				tween_target = (animate_to_start) ? 0 : 1;
				new GTween(target[i], 0.35, {scaleX:tween_target, scaleY:tween_target});
			}
			
			if(orig == 0)
				return;
			
			if(!_socialMedia.contains(_socialMediaStates[tween_target]))
				_socialMedia.addChild(_socialMediaStates[tween_target]);
			tween_target = (tween_target == 0) ? 1 : 0; 
			if(_socialMedia.contains(_socialMediaStates[tween_target]))
				_socialMedia.removeChild(_socialMediaStates[tween_target]);
		}
	}
}