/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.media.Sound;
    import flash.media.SoundChannel;
	import flash.filters.GlowFilter;
	
	public class Scoreboard extends MovieClip
	{
		//[Embed(systemFont="HouseSampler-HouseSlant", fontName="scoreFont", fontWeight="normal", mimeType = "application/x-font")] private var font:Class;
		[Embed(source="../HouseSampler-HouseSlant.ttf", fontName="scoreFont", fontWeight="normal", mimeType = "application/x-font")] private var font:Class;
		//HouseSampler-HouseSlant
		[Embed(source="assets/Jeopardy-daily2x.mp3")]
		private var double:Class;
		[Embed(source="assets/correct.mp3")] private var correct:Class;
		[Embed(source="assets/incorrect.mp3")] private var incorrect:Class;
		[Embed(source="assets/correctAlternate.mp3")] private var correctAlternate:Class;
		
		private var _textFormat : TextFormat = new TextFormat();
		private var _doubleSound : Sound = new double();
		
		private var _correctSound : Sound = new correct();
		private var _incorrectSound : Sound = new incorrect();
		private var _correctAlternateSound : Sound = new correctAlternate();
		
		private var _doubleStars : MovieClip = new STARS();
		private var _doubleText : MovieClip = new daily_double();
		
		private var _scoreIcon : MovieClip;
		private var _highScoreIcon : MovieClip;
		
		private var _scoreText : TextField;
		private var _highScoreText : TextField;
		private var _roundText : TextField;
		
		private var _background : Sprite;
		
		private var _score : Number = 0;
		private var _correctQuestions : Number = 0;
		private var _highscore : Number = 0;
		private var _levelQuestions : Number;
		
		private var _totalCorrectQuestions : Number = 0;
		private var _totalGameQuestions : Number = 0;
		
		private var _questionsThisLevel : Number = 0;
		private var _doubleQuestionLocatins : Array = new Array();
		private var _bonusDouble : Boolean = false;
		
		public function Scoreboard()
		{
			var _outline:GlowFilter=new GlowFilter(0xffffff,1.0,2.0,2.0,10);
			
			// Score icon
			/*_scoreIcon = new score();
			_scoreIcon.x = 110.5/2 + 75 + 30 - 240 - 20;
			_scoreIcon.y = 38.8 /2;// + 45;
			addChild(_scoreIcon);*/
			
			// Score text
			_textFormat.font = "scoreFont";
			_textFormat.size = 38;//52;
			_textFormat.align = TextFormatAlign.LEFT;
			
			_scoreText = new TextField();
			_scoreText.embedFonts = true;
			_scoreText.defaultTextFormat = _textFormat;
			_scoreText.text = String(_score);
			_scoreText.x = 220 - 240 - 20 -111 + 15; //230;
			_scoreText.y = -9; //10;
			_scoreText.width = 60;
			_scoreText.height = 40;
			_scoreText.autoSize = "left";
			_scoreText.textColor = 0xE85E2F;
			_scoreText.filters = [_outline];
			addChild(_scoreText);
			
			_highScoreText = new TextField();
			_highScoreText.embedFonts = true;
			_highScoreText.defaultTextFormat = _textFormat;
			_highScoreText.text = String(_highscore);
			_highScoreText.x = 30 + 200 + 20 - 398/2 - 5; //230;
			_highScoreText.y = -9; //10;
			_highScoreText.width = 60;
			_highScoreText.height = 40;
			_highScoreText.autoSize = "left";
			_highScoreText.textColor = 0xE85E2F;
			_highScoreText.filters = [_outline];
			addChild(_highScoreText);
			
			var _qTextFormat:TextFormat = new TextFormat();
			_qTextFormat.font = "scoreFont";
			_qTextFormat.size = 24;
			_qTextFormat.align = TextFormatAlign.LEFT;
			
			// Put a background around question number
			_background = new Sprite();
			addChild(_background);
			/*_background.graphics.beginFill(0x000000);//, 0.6);
			_background.graphics.drawRoundRect(-290,-380,150, 30, 15);
			_background.graphics.endFill();*/
			
			_roundText = new TextField();
			_roundText.embedFonts = true;
			_roundText.defaultTextFormat = _qTextFormat;
			_roundText.text = "Warmup";
			_roundText.x = -285; //230;
			_roundText.y = -380; //10;
			_roundText.width = 60;
			_roundText.height = 40;
			_roundText.autoSize = "left";
			_roundText.textColor = 0xE85E2F;
			_roundText.filters = [_outline]
			addChild(_roundText);
			
			updateBackground();
			
			// Highscore icon
			/*_highScoreIcon = new high_score();
			_highScoreIcon.x = 186.9/2 - 160 + 200 + 20;
			_highScoreIcon.y = 38.8 /2;
			addChild(_highScoreIcon);*/
			
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
		
		public function get qTotal() : Number
		{
			return _levelQuestions;
		}
		
		public function get totalCorrectQuestions() : Number
		{
			return _totalCorrectQuestions;
		}
		
		public function get totalGameQuestions() : Number
		{
			return _totalGameQuestions;
		}
		
		public function get highScore() : Number
		{
			return _highscore;
		}
		
		public function get qCorrect() : Number
		{
			return _correctQuestions;
		}
		
		public function resetScore() : void
		{
			_correctQuestions = 0;
		}
		
		public function resetLevel() : void
		{
			//_correctQuestions = 0;
			
			_questionsThisLevel = 0;
			
			_doubleQuestionLocatins[0] = int(Math.random() * _levelQuestions);
			_doubleQuestionLocatins[1] = int(Math.random() * (_levelQuestions - 1));
			if(_doubleQuestionLocatins[1] == _doubleQuestionLocatins[0])
			{
				if(++_doubleQuestionLocatins[1] >= _levelQuestions)
					_doubleQuestionLocatins[1] = 0;
			}
		}
		
		public function showQuestion() : Boolean
		{
			_questionsThisLevel++;
			if(!(_doubleQuestionLocatins.indexOf(_questionsThisLevel - 1) < 0))
			{
				_doubleSound.play();
				addChild(_doubleStars);
				addChild(_doubleText);
				_doubleText.gotoAndPlay(1);
				return true;
			}
			return false;
		}
		
		public function updateRound(AR : Boolean = false) : void
		{
			_background.graphics.clear();
			if(AR)
				_roundText.text = "";
			else
			{
				_roundText.text = String("Question " + (_questionsThisLevel + 1) + "/" + _levelQuestions);
				
				updateBackground();
			}
		}
		
		
		public function get levelScore() : Number
		{
			return _score;
		}
		
		public function set levelScore( s : Number ) : void
		{
			_score = s;
			updateScores();
		}
		
		public function set highScore( s : Number ) : void
		{
			_highscore = s;
			updateScores();
		}
		
		private function updateScores() : void
		{
			_scoreText.text = String("Score: " + _score);
			_highScoreText.text = String("High Score: " + _highscore);
		}
		
		public function scoreEvent( correct : Boolean , warmup : Boolean = false ) : void
		{			
			if(warmup)
			{
				if(correct)
				{
					_correctAlternateSound.play();
					_score += 5;
				}
			
				if(_score > _highscore)
					_highscore = _score;
				
				updateScores();
				
				return;
			}
			
			(correct) ? _correctSound.play() : _incorrectSound.play();
			
			if(correct)
			{
				_score += (_doubleQuestionLocatins.indexOf(_questionsThisLevel - 1) < 0) ? 25 : 50;
				_correctQuestions++;
				_totalCorrectQuestions++;
			}
			
			_totalGameQuestions++;
			
			if(_score > _highscore)
				_highscore = _score;
			
			updateScores();
			
			if(this.contains(_doubleStars))//if(!(_doubleQuestionLocatins.indexOf(_questionsThisLevel - 1) < 0))
			{
				removeChild(_doubleStars);
				removeChild(_doubleText);
			}
			
			if(_questionsThisLevel >= _levelQuestions)
				resetLevel();
		}
		
		private function updateBackground() : void
		{
			_background.graphics.beginFill(0x000000);//, 0.6);
			_background.graphics.drawRoundRect(-290,-380, _roundText.textWidth + 15, 30, 15);
			_background.graphics.endFill();
		}
		
	}

}