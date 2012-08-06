/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class Scoreboard extends MovieClip
	{		
		private var _scoreIcon : MovieClip;
		private var _highScoreIcon : MovieClip;
		
		private var _scoreText : TextField;
		private var _highScoreText : TextField;
		
		private var _score : Number = 0;
		private var _levelQuestions : Number = 0;
		
		public function Scoreboard()
		{
			// Score icon
			_scoreIcon = new score();
			_scoreIcon.x = 110.5/2 + 75 + 30;
			_scoreIcon.y = 38.8 /2;// + 45;
			addChild(_scoreIcon);
			
			// Score text
			_scoreText = new TextField();
			_scoreText.text = String(_score);
			_scoreText.x = 230;
			_scoreText.y = 10;
			_scoreText.width = 60;
			_scoreText.height = 40;
			addChild(_scoreText);
			
			// Highscore icon
			_highScoreIcon = new high_score();
			_highScoreIcon.x = 186.9/2 - 160;
			_highScoreIcon.y = 38.8 /2;
			addChild(_highScoreIcon);
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
				_score += 1;
			_scoreText.text = String(_score);
		}
		
	}

}