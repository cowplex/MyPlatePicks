/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;

	public class GameOverScreen extends MovieClip
	{			
		[Embed(source="../HouseSampler-HouseSlant.ttf", fontName="scoreFont", fontWeight="normal", mimeType = "application/x-font")] private var font:Class;
			
		private var _background : BG_game_over;
		private var _callbackRetry : Function;
		private var _callbackHome : Function;
		
		private var _textFormat : TextFormat = new TextFormat();
				
		public function GameOverScreen(s : Number = 0, vp : Number = 1, hs : Number = 2, round : Number = 9, defaults : Boolean = true)
		{
			//_background = new MovieClip();
			//_background.addChild(new BG_game_over());
			_background = new BG_game_over();
			_background.x = 320;
			_background.y = 240;
			
			_textFormat.font = "scoreFont";
			_textFormat.size = 66;
			_textFormat.align = TextFormatAlign.LEFT;
			_background.scoreText.embedFonts = true;
			_background.scoreText.defaultTextFormat = _textFormat;
			_background.vpText.embedFonts = true;
			_background.vpText.defaultTextFormat = _textFormat;
						
			vp = Math.round(vp);
			
			_background.scoreText.text = s.toString();
			//_background.highscoreText.text = hs.toString();
			
			_background.vp_desc_text.visible = defaults;
			_background.vp.visible = defaults;
			if(defaults)
				_background.vpText.text = vp.toString();
			//_background.round.gotoAndStop(round);
			
			_background.home.addEventListener(MouseEvent.MOUSE_DOWN, doCallbackHome); 
			_background.retry.addEventListener(MouseEvent.MOUSE_DOWN, doCallbackRetry);
			
			addChild(_background);			
		}
		
		public function set callbackRetry(f : Function) : void
		{
			_callbackRetry = f;
		}
		
		public function set callbackHome(f : Function) : void
		{
			_callbackHome = f;
		}
		
		private function doCallbackRetry(e:MouseEvent) : void
		{
			_callbackRetry();
		}
		
		private function doCallbackHome(e:MouseEvent) : void
		{
			_callbackHome();
		}
	}

}