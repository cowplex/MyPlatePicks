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
	
	public class Questions extends Sprite
	{
				
		private var _categories : Array = new Array();
		private var _usedQuestions : Array = new Array( 4 );
		private var _currentQuestion : Question;
		
		private var _detectorCallback : Function;
		private var _scoreCallback : Function;
		
		private var _responseHolder : MovieClip = new MovieClip();
		
		// Embedded images
		// Load Classes
		{
		[Embed(source="question_responses/apple.png")]
		private var apple:Class;
		
		[Embed(source="question_responses/dairy.png")]
		private var dairy:Class;
		
		[Embed(source="question_responses/raisins.png")]
		private var raisins:Class;
		
		[Embed(source="question_responses/applejuice.png")]
		private var applejuice:Class;
		
		[Embed(source="question_responses/egg.png")]
		private var egg:Class;
		
		[Embed(source="question_responses/rice.png")]
		private var rice:Class;
		
		[Embed(source="question_responses/banana.png")]
		private var banana:Class;
		
		[Embed(source="question_responses/fruitpunch.png")]
		private var fruitpunch:Class;
		
		[Embed(source="question_responses/running.png")]
		private var running:Class;
		
		[Embed(source="question_responses/biking.png")]
		private var biking:Class;
		
		[Embed(source="question_responses/fruits.png")]
		private var fruits:Class;
		
		[Embed(source="question_responses/sliceofbread.png")]
		private var sliceofbread:Class;
		
		[Embed(source="question_responses/broccoli.png")]
		private var broccoli:Class;
		
		[Embed(source="question_responses/grains.png")]
		private var grains:Class;
		
		[Embed(source="question_responses/soccer.png")]
		private var soccer:Class;
		
		[Embed(source="question_responses/brusselssprouts.png")]
		private var brusselssprouts:Class;
		
		[Embed(source="question_responses/grapes.png")]
		private var grapes:Class;
		
		[Embed(source="question_responses/spinach.png")]
		private var spinach:Class;
		
		[Embed(source="question_responses/cabbage.png")]
		private var cabbage:Class;
		
		[Embed(source="question_responses/hulahoop.png")]
		private var hulahoop:Class;
		
		[Embed(source="question_responses/stretching.png")]
		private var stretching:Class;
		
		[Embed(source="question_responses/candybar.png")]
		private var candybar:Class;
		
		[Embed(source="question_responses/jumprope.png")]
		private var jumprope:Class;
		
		[Embed(source="question_responses/swimming.png")]
		private var swimming:Class;
		
		[Embed(source="question_responses/carrot.png")]
		private var carrot:Class;
		
		[Embed(source="question_responses/lemonade.png")]
		private var lemonade:Class;
		
		[Embed(source="question_responses/veggiejuice.png")]
		private var veggiejuice:Class;
		
		[Embed(source="question_responses/cauliflower.png")]
		private var cauliflower:Class;
		
		[Embed(source="question_responses/meat.png")]
		private var meat:Class;
		
		[Embed(source="question_responses/water.png")]
		private var water:Class;
		
		[Embed(source="question_responses/chocolateshake.png")]
		private var chocolateshake:Class;
		
		[Embed(source="question_responses/milk.png")]
		private var milk:Class;
		
		[Embed(source="question_responses/weightbearing.png")]
		private var weightbearing:Class;
		
		[Embed(source="question_responses/cucumber.png")]
		private var cucumber:Class;
		
		[Embed(source="question_responses/orange.png")]
		private var orange:Class;
		
		[Embed(source="question_responses/yoga.png")]
		private var yoga:Class;
		}
		// Create Image Vairables
		{
			private var _apple:Response = new Response( new apple() );
			private var _applejuice:Response = new Response( new applejuice() );
			private var _banana:Response = new Response( new banana() );
			private var _biking:Response = new Response( new biking() );
			private var _broccoli:Response = new Response( new broccoli() );
			private var _brusselssprouts:Response = new Response( new brusselssprouts() );
			private var _cabbage:Response = new Response( new cabbage() );
			private var _candybar:Response = new Response( new candybar() );
			private var _carrot:Response = new Response( new carrot() );
			private var _cauliflower:Response = new Response( new cauliflower() );
			private var _chocolateshake:Response = new Response( new chocolateshake() );
			private var _cucumber:Response = new Response( new cucumber() );
			private var _dairy:Response = new Response( new dairy() );
			private var _egg:Response = new Response( new egg() );
			private var _fruitpunch:Response = new Response( new fruitpunch() );
			private var _fruits:Response = new Response( new fruits() );
			private var _grains:Response = new Response( new grains() );
			private var _grapes:Response = new Response( new grapes() );
			private var _hulahoop:Response = new Response( new hulahoop() );
			private var _jumprope:Response = new Response( new jumprope() );
			private var _lemonade:Response = new Response( new lemonade() );
			private var _meat:Response = new Response( new meat() );
			private var _milk:Response = new Response( new milk() );
			private var _orange:Response = new Response( new orange() );
			private var _raisins:Response = new Response( new raisins() );
			private var _rice:Response = new Response( new rice() );
			private var _running:Response = new Response( new running() );
			private var _sliceofbread:Response = new Response( new sliceofbread() );
			private var _soccer:Response = new Response( new soccer() );
			private var _spinach:Response = new Response( new spinach() );
			private var _stretching:Response = new Response( new stretching() );
			private var _swimming:Response = new Response( new swimming() );
			private var _veggiejuice:Response = new Response( new veggiejuice() );
			private var _water:Response = new Response( new water() );
			private var _weightbearing:Response = new Response( new weightbearing() );
			private var _yoga:Response = new Response( new yoga() );
		}
		
		public function Questions()
		{
			_responseHolder.x = 164;
			_responseHolder.y = 64;
			addChild(_responseHolder);
			
			for(var i:int = 0; i < _usedQuestions.length; i++)
				_usedQuestions[i] = new Array();
			
			// Load data
			
			// Cat 1 - Make Half Your Plate Fruits and Vegetables
			_categories.push( new Array() );
			_categories[0].push( new Question("Which of the following is a fruit?", 0, _orange, [_broccoli, _carrot, _spinach]) );
			_categories[0].push( new Question("Which of the following is a vegetable?", 0, _cucumber, [_banana, _apple, _grapes]) );
			_categories[0].push( new Question("Which vegetable is not in the same family as broccoli?", 0, _cabbage, [_carrot, _brusselssprouts, _cauliflower]) );

		}
		
		public function drawQuestion( category : int ) : void
		{
			category--;
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