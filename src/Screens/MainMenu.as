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
	
	public class MainMenu extends MovieClip
	{
		private static var ANIMATION_START : Number = 400;
		
		private var _background : MovieClip;
		private var _playButton : MovieClip;
		private var _logo       : MovieClip;
		
		private var _settings : btn_options;
		private var _settingsButtons : Array;
		
		private var _socialMedia : btn_socialmedia_up;
		private var _socialMediaButtons : Array;
		
		public function MainMenu()
		{
			_background = new BG_mainmenu();
			_background.x = 320;
			_background.y = 240;
			addChild(_background);
			
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
			
			_settings = new btn_options();
			_settingsButtons = new Array(new btn_options());
			_settings.x = 60;
			_settings.y = ANIMATION_START;
			_settings.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { animate(_settingsButtons); });
			addChild(_settings);
			
			_socialMedia = new btn_socialmedia_up();
			_socialMediaButtons = new Array(new btn_twitter(), new btn_facebook(), new btn_youtube());
			_socialMedia.x = 580;
			_socialMedia.y = ANIMATION_START;
			_socialMedia.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { animate(_socialMediaButtons); });
			
			_socialMediaButtons[0].addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {new URLRequest("http://twitter.com/");} );
			_socialMediaButtons[1].addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {new URLRequest("http://facebook.com/");});
			_socialMediaButtons[2].addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {new URLRequest("http://youtube.com/");});
			for(var i:int = _socialMediaButtons.length - 1; i >= 0; i--)
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
		
		private function animate( target : Array ) : void
		{
			var i : int;
			var cumulative : Number = 0;
			var animation_target : Number = ANIMATION_START;
			var animate_to_start : Boolean = (target[0].y != ANIMATION_START);
			
			var tween_target : Number;
			
			
			for(i = 0; i < target.length; i++)
			{
				cumulative += 65;
				tween_target = (animate_to_start) ? ANIMATION_START : ANIMATION_START - cumulative;
				new GTween(target[i], 0.35, {y:tween_target});
				tween_target = (animate_to_start) ? 0 : 1;
				new GTween(target[i], 0.35, {scaleX:tween_target, scaleY:tween_target});
			}
		}
	}
}