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
		//[Embed(systemFont="HouseSampler-HouseSlant", fontName="scoreFont", fontWeight="normal", mimeType = "application/x-font")] private var font:Class;
		[Embed(source="../HouseSampler-HouseSlant.ttf", fontName="scoreFont", fontWeight="normal", mimeType = "application/x-font")] private var font:Class;
		//HouseSampler-HouseSlant
		[Embed(source="assets/Jeopardy-daily2x.mp3")]
		private var double:Class;
		[Embed(source="assets/correct.mp3")] private var correct:Class;
		[Embed(source="assets/incorrect.mp3")] private var incorrect:Class;
		
		private var _textFormat : TextFormat = new TextFormat();
		private var _doubleSound : Sound = new double();
		
		private var _correctSound : Sound = new correct();
		private var _incorrectSound : Sound = new incorrect();
		
		private var _doubleStars : MovieClip = new STARS();
		private var _doubleText : MovieClip = new daily_double();
		
		private var _scoreIcon : MovieClip;
		private var _highScoreIcon : MovieClip;
		
		private var _scoreText : TextField;
		private var _highScoreText : TextField;
		
		private var _score : Number = 0;
		private var _highscore : Number = 0;
		private var _levelQuestions : Number;
		
		private var _questionsThisLevel : Number = 0;
		private var _doubleQuestionLocatins : Array = new Array();
		private var _bonusDouble : Boolean = false;
		
		public function Scoreboard()
		{
			// Score icon
			_scoreIcon = new score();
			_scoreIcon.x = 110.5/2 + 75 + 30 - 240;
			_scoreIcon.y = 38.8 /2;// + 45;
			addChild(_scoreIcon);
			
			// Score text
			_textFormat.font = "scoreFont";
			_textFormat.size = 52;
			_textFormat.align = TextFormatAlign.LEFT;
			
			_scoreText = new TextField();
			_scoreText.embedFonts = true;
			_scoreText.defaultTextFormat = _textFormat;
			_scoreText.text = String(_score);
			_scoreText.x = 220 - 240; //230;
			_scoreText.y = -9; //10;
			_scoreText.width = 60;
			_scoreText.height = 40;
			_scoreText.autoSize = "left";
			_scoreText.textColor = 0xE85E2F;
			addChild(_scoreText);
			
			_highScoreText = new TextField();
			_highScoreText.embedFonts = true;
			_highScoreText.defaultTextFormat = _textFormat;
			_highScoreText.text = String(_highscore);
			_highScoreText.x = 30 + 200 ; //230;
			_highScoreText.y = -9; //10;
			_highScoreText.width = 60;
			_highScoreText.height = 40;
			_highScoreText.autoSize = "left";
			_highScoreText.textColor = 0xE85E2F;
			addChild(_highScoreText);
			
			// Highscore icon
			_highScoreIcon = new high_score();
			_highScoreIcon.x = 186.9/2 - 160 + 200;
			_highScoreIcon.y = 38.8 /2;
			addChild(_highScoreIcon);
			
			_doubleStars.x = _doubleStars.width / 2 - 60;
			_doubleStars.y = -1 * _doubleStars.height / 2;
			
			_doubleText.scaleX = _doubleText.scaleY = .7;
			_doubleText.x = 75;
			_doubleText.y = -50;
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
			{
				_doubleSound.play();
				addChild(_doubleStars);
				addChild(_doubleText);
				_doubleText.gotoAndPlay(1);
			}
		}
		
		public function get levelScore() : Number
		{
			return _score;
		}
		
		public function set levelScore( s : Number ) : void
		{
			_score = s;
		}
		
		public function scoreEvent( correct : Boolean , warmup : Boolean = false ) : void
		{
			(correct) ? _correctSound.play() : _incorrectSound.play();
			
			if(warmup)
				return;
			
			if(correct)
				_score += (_doubleQuestionLocatins.indexOf(_questionsThisLevel - 1) < 0) ? 25 : 50;
			_scoreText.text = String(_score);
			
			if(_score > _highscore)
				_highscore = _score;
			_highScoreText.text = String(_highscore);
			
			if(this.contains(_doubleStars))//if(!(_doubleQuestionLocatins.indexOf(_questionsThisLevel - 1) < 0))
			{
				removeChild(_doubleStars);
				removeChild(_doubleText);
			}
			
			if(_questionsThisLevel >= _levelQuestions)
				resetLevel();
		}
		
	}

}