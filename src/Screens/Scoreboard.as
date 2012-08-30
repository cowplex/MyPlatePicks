/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.media.Sound;
    import flash.media.SoundChannel;
	
	public class Scoreboard extends MovieClip
	{
		[Embed(systemFont="HouseSampler-HouseSlant", fontName="HouseSlant", fontWeight="normal", mimeType = "application/x-font")] 
		private var font:Class;
		[Embed(source="assets/Jeopardy-daily2x.mp3")]
        private var _double:Class;
		
		private var _textFormat : TextFormat = new TextFormat();
		private var _doubleSound : Sound = new _double();
		
		private var _scoreIcon : MovieClip;
		private var _highScoreIcon : MovieClip;
		
		private var _scoreText : TextField;
		private var _highScoreText : TextField;
		
		private var _score : Number = 0;
		private var _levelQuestions : Number;
		
		private var _questionsThisLevel : Number = 0;
		private var _doubleQuestionLocatins : Array = new Array();
		private var _bonusDouble : Boolean = false;
		
		public function Scoreboard()
		{
			// Score icon
			_scoreIcon = new score();
			_scoreIcon.x = 110.5/2 + 75 + 30;
			_scoreIcon.y = 38.8 /2;// + 45;
			addChild(_scoreIcon);
			
			// Score text
			_textFormat.font = "HouseSlant";
			_textFormat.size = 52;
			_textFormat.align = TextFormatAlign.LEFT;
			
			_scoreText = new TextField();
			_scoreText.embedFonts = true;
			_scoreText.defaultTextFormat = _textFormat;
			_scoreText.text = String(_score);
			_scoreText.x = 220; //230;
			_scoreText.y = -3; //10;
			_scoreText.width = 60;
			_scoreText.height = 40;
			_scoreText.autoSize = "left";
			addChild(_scoreText);
			
			// Highscore icon
			_highScoreIcon = new high_score();
			_highScoreIcon.x = 186.9/2 - 160;
			_highScoreIcon.y = 38.8 /2;
			addChild(_highScoreIcon);
		}
		
		public function set questionsPerLevel( q : Number ) : void
		{
			_levelQuestions = q;
		}
		
		public function resetLevel() : void
		{
			_questionsThisLevel = 0;
			
			_doubleQuestionLocatins[0] = int(Math.random() * _levelQuestions);
			_doubleQuestionLocatins[1] = int(Math.random() * (_levelQuestions - 1));
			if(_doubleQuestionLocatins[1] == _doubleQuestionLocatins[0])
			{
				if(++_doubleQuestionLocatins[1] >= _levelQuestions)
					_doubleQuestionLocatins[1] = 0;
			}
		}
		
		public function showQuestion() : void
		{
			_questionsThisLevel++;
			if(!(_doubleQuestionLocatins.indexOf(_questionsThisLevel - 1) < 0))
				_doubleSound.play();
		}
		
		public function get levelScore() : Number
		{
			return _score;
		}
		
		public function set levelScore( s : Number ) : void
		{
			_score = s;
		}
		
		public function scoreEvent( correct : Boolean ) : void
		{
			if(correct)
				_score += (_doubleQuestionLocatins.indexOf(_questionsThisLevel - 1) < 0) ? 25 : 50;
			_scoreText.text = String(_score);
			
			if(_questionsThisLevel >= _levelQuestions)
				resetLevel();
		}
		
	}

}