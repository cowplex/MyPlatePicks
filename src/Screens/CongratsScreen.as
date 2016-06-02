/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	
	public class CongratsScreen extends MovieClip
	{
		[Embed(source="../HouseSampler-HouseSlant.ttf", fontName="scoreFont", fontWeight="normal", mimeType = "application/x-font")] private var font:Class;
		
		private var _background : MovieClip;
		private var _callback : Function;
		
		private var _levelText : Array = new Array(new round_1(), new round_2(), new round_3());
		
		private var _timer : Timer;
		
		private var _textFormat : TextFormat = new TextFormat();
		
		public function CongratsScreen()
		{
			_background = new BG_Congrats();
			_background.x = _background.width / 2;
			_background.y = _background.height / 2;
			
			_textFormat.font = "scoreFont";
			_textFormat.size = 69;
			_textFormat.align = TextFormatAlign.CENTER;
			_background.correct.embedFonts = true;
			_background.correct.defaultTextFormat = _textFormat;
			
			_textFormat.size = 40;
			_background.finished.total.embedFonts = true;
			_background.finished.total.defaultTextFormat = _textFormat;
			
			addChild(_background);
		}
		
		public function set callback( f : Function ) : void
		{
			_callback = f;
		}
		
		public function correct(s : String) : void
		{
			_background.correct.text = s;
		}
		
		public function total(s : String) : void
		{
			_background.finished.total.text = s;
		}
		
		public function congratulate(level : Number) : void
		{
			_background.extra.visible = true;
			_background.finished.visible = false;
			
			if(level < _levelText.length)
			{
				_levelText[level].x = -19 + _background.x;
				_levelText[level].y = /*207.65*/ 138 + 60 + _background.y;
				addChild(_levelText[level]);
				//_levelText[level].stop(); //BUGFIX
			}
			else
			{
				_background.extra.visible = false;
				_background.finished.visible = true;
			}
			
			level--;
			if(level < _levelText.length)
			{
				_levelText[level].x = -15.55 + _background.x;
				_levelText[level].y = /*84.70*/ 10  + 60 + _background.y;
				addChild(_levelText[level]);
				//_levelText[level].stop(); //BUGFIX
			}
			
			_timer = new Timer(5000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timeout);
			_timer.start();
		}
		
		private function timeout(e:TimerEvent) : void
		{
			for(var i:int = 0; i < _levelText.length; i++)
			{
				if(this.contains(_levelText[i]))
					removeChild(_levelText[i]);
			}
			_callback();
		}
	}

}