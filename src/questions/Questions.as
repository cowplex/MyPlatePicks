/**
 * @author mikelownds
 */
package questions
{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.media.Sound;
    import flash.media.SoundChannel;
    	
	public class Questions extends Sprite
	{
				
		private var _categories : Array = new Array();
		private var _usedQuestions : Array = new Array( 4 );
		private var _currentQuestion : Question;
		
		private var _detectorCallback : Function;
		private var _scoreCallback : Function;
		
		private var _responseHolder : MovieClip = new MovieClip();
		
		{
		// Sounds
		//[Embed(source="question_audio/Which not related to broccoli.mp3")]
        //public var _notRelatedToBroccoli:Class;
        [Embed(source="question_audio/Which is a Vegetable.mp3")]
        public var _whichIsaVegetable:Class;
        //[Embed(source="question_audio/Which is a fruit.mp3")]
        //public var _whichIsaFruit:Class;
		}
		
		private var _QR : QuestionResponses = new QuestionResponses();
		
		public function Questions()
		{
			_responseHolder.x = 164;
			_responseHolder.y = 90;//64;
			addChild(_responseHolder);
			
			for(var i:int = 0; i < _usedQuestions.length; i++)
				_usedQuestions[i] = new Array();
			
			// Load data
			
			// Cat 0 - Make Half Your Plate Fruits and Vegetables
			_categories.push( new Array() );
			_categories[0].push( new Question("Fiber helps you get rid of waste from your body. What kind of food has fiber?", 0, _QR._fruits_and_vegetables, [_QR._cheese, _QR._meat, _QR._milk]) );
			_categories[0].push( new Question("Which of the these is the healthiest choice?", 0, _QR._apple, [_QR._pop, _QR._caramel_apple, _QR._crackers]) );
			_categories[0].push( new Question("Christy is hungry. Choose the healthiest snack for her.", 0, _QR._carrot, [_QR._french_fries, _QR._candybar, _QR._potato_chips]) );
			
			_categories[0].push( new Question("Which of the following is a vegetable?", 0, _QR._cucumber, [_QR._banana, _QR._apple, _QR._grapes], new _whichIsaVegetable()) );
			//_categories[0].push( new Question("Fruits and vegetables are foods you can _________ to get energy and help you grow.", 0, , [, , ]) );
			//_categories[0].push( new Question("Make ___________ your dinner plate fruits and vegetables", 0, , [, , ]) );

			// Cat 1 - Avoid Oversized Portions
			_categories.push( new Array() );
			_categories[1].push( new Question("Eating smaller portions can help you:", 0, _QR._Be_strong_and_healthy, [_QR._Wake_up, _QR._be_more_popular, _QR._read_better]) );
			_categories[1].push( new Question("From which food group should you eat the fewest servings each day?", 0, _QR._Protein, [_QR._grains_copy, _QR._Vegetables, _QR._Fruits]) );
			_categories[1].push( new Question("Eating oversized portions of unhealthy foods gives you:", 0, _QR._All_of_these_choices, [_QR._Extra_Fat, _QR._Extra_Calories, _QR._Extra_Sugar]) );
			
			// Cat 2
			_categories.push( new Array() );
			_categories[2].push( new Question("Which drink should you choose most often when you feel thirsty?", 0, _QR._water, [_QR._juice, _QR._milk, _QR._sportsdrink]) );
			_categories[2].push( new Question("What does regular soda/pop contain?", 0, _QR._Sugar, [_QR._Vitamins, _QR._Minerals, _QR._Fat]) );
			_categories[2].push( new Question("Which one of these can you drink a lot of and still be healthy?", 0, _QR._water, [_QR._chocolateshake, _QR._lemonade, _QR._slushie]) );
			
			// Cat 3
			_categories.push( new Array() );
			_categories[3].push( new Question("Which sport is a weight bearing activity that will help build strong bones?", 0, _QR._Jump_Roping, [_QR._Swimming, _QR._Bike_Riding, _QR._Stretching]) );
			_categories[3].push( new Question("When we are physically active, we benefit our:", 0, _QR._All_of_these_choices, [_QR._muscles, _QR._Blood, _QR._bones]) );
			_categories[3].push( new Question("In a typical day, we should try to be active or exercise for:", 0, _QR._At_least_1_hour, [_QR._At_least_30_minutes, _QR._At_least_1_minute, _QR._At_least_2_hours]) );
			
		}
		
		public function drawQuestion( category : int ) : void
		{
			//category--;
			if(category < 0 || category > _categories.length)
				return;
			
			// Reset question list if all questions have been asked
			if(_categories[category].length <= 0)
			{
				while(_usedQuestions[category].length > 0)
					_categories[category].push(_usedQuestions[category].pop());
			}
			
			if(_categories[category].length > 0)
			{
				_currentQuestion = _categories[category].splice(int(Math.random() * _categories[category].length), 1)[0];
				_currentQuestion.randomizeResponses();
				drawResponses(_currentQuestion);
				addChild(_currentQuestion);
				_currentQuestion.readQuestion();
			}
		}
		
		public function hideQuestion() : void
		{
			if(_currentQuestion != null)
			{
				_usedQuestions[_currentQuestion.category].push(_currentQuestion);
				removeResponses(_currentQuestion);
				removeChild(_currentQuestion);
				_currentQuestion = null;
			}
		}
		
		public function setScoreCallback(scoreCallback : Function) : void
		{
			_scoreCallback = scoreCallback;
		}
		
		public function setDetectorCallback(detectorCallback : Function) : void
		{
			_detectorCallback = detectorCallback;
		}
		
		public function detectHit() : void
		{
			if(_currentQuestion == null)
				return;
			
			var motion : Rectangle;
			
			// Detect Misses
			for(var i:int = 0; i < _currentQuestion.incorrectResponses.length; i++)
			{
				motion = _detectorCallback(_currentQuestion.incorrectResponses[i].detectionArea);
				if(motion.width * motion.height > 50 && _currentQuestion.incorrectResponses[i].detectionArea.intersects(motion))
				{
					dimImcorrectResponses();
					_scoreCallback(false,
					               new Point(_currentQuestion.correctResponse.detectionArea.x + _currentQuestion.correctResponse.detectionArea.width/2, 
					                         _currentQuestion.correctResponse.detectionArea.y + _currentQuestion.correctResponse.detectionArea.height/2),
					               new Point(_currentQuestion.incorrectResponses[i].detectionArea.x + _currentQuestion.incorrectResponses[i].detectionArea.width/2,
					                         _currentQuestion.incorrectResponses[i].detectionArea.y + _currentQuestion.incorrectResponses[i].detectionArea.height/2)
					              );
					return;
				}
			}
			
			// Detect correct answer
			motion = _detectorCallback(_currentQuestion.correctResponse.detectionArea);
			if(motion.width * motion.height > 50 && _currentQuestion.correctResponse.detectionArea.intersects(motion))
			{
				dimImcorrectResponses();
				_scoreCallback(true,
					           new Point(_currentQuestion.correctResponse.detectionArea.x + _currentQuestion.correctResponse.detectionArea.width/2, 
					                     _currentQuestion.correctResponse.detectionArea.y + _currentQuestion.correctResponse.detectionArea.height/2)
					           );
			}
			
		}
		
		public function questionTimeout() : void
		{
			dimImcorrectResponses();
			
			_scoreCallback(false,
				           new Point(_currentQuestion.correctResponse.detectionArea.x + _currentQuestion.correctResponse.detectionArea.width/2, 
				                     _currentQuestion.correctResponse.detectionArea.y + _currentQuestion.correctResponse.detectionArea.height/2)
				           );
		}
		
		private function drawResponses( question : Question ) : void
		{
			var responses : Array = question.getRandomResponses();
			for(var i:int = 0; i < responses.length; i++)
			{
				responses[i].x = (420 - responses.length * responses[i].width) / (responses.length + 1) * (i + 1) + (responses[i].width * i);
				responses[i].y = 15;
				_responseHolder.addChild(responses[i]);
			}
		}
		
		private function dimImcorrectResponses() : void
		{
			for(var i:int = 0; i < _currentQuestion.incorrectResponses.length; i++)
				_currentQuestion.incorrectResponses[i].alpha = .2;
		}
		
		private function removeResponses( question : Question) : void
		{
			var responses : Array = question.getRandomResponses();
			for(var i:int = 0; i < responses.length; i++)
			{
				_responseHolder.removeChild(responses[i]);
				responses[i].alpha = 1;
			}
		}
		
	}
	
	
}