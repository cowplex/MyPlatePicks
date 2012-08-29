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
		
		// Embedded images
		// Load Classes
		/*
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
		
		// Sounds
		[Embed(source="question_audio/Which not related to broccoli.mp3")]
        public var _notRelatedToBroccoli:Class;
        [Embed(source="question_audio/Which is a Vegetable.mp3")]
        public var _whichIsaVegetable:Class;
        [Embed(source="question_audio/Which is a fruit.mp3")]
        public var _whichIsaFruit:Class;
		}
		// Create Image Vairables
		{
			private var _apple:Response = new Response( "Apple", new apple() );
			private var _applejuice:Response = new Response( "Apple Juice", new applejuice() );
			private var _banana:Response = new Response( "Bananna", new banana() );
			private var _biking:Response = new Response( "Biking", new biking() );
			private var _broccoli:Response = new Response( "Broccoli", new broccoli() );
			private var _brusselssprouts:Response = new Response( "Brussels Sprouts", new brusselssprouts() );
			private var _cabbage:Response = new Response( "Cabbage", new cabbage() );
			private var _candybar:Response = new Response( "Candy Bar", new candybar() );
			private var _carrot:Response = new Response( "Carrot", new carrot() );
			private var _cauliflower:Response = new Response( "Cauliflower", new cauliflower() );
			private var _chocolateshake:Response = new Response( "Chocolate Shake", new chocolateshake() );
			private var _cucumber:Response = new Response( "Cucumber", new cucumber() );
			private var _dairy:Response = new Response( "Dairy", new dairy() );
			private var _egg:Response = new Response( "Egg", new egg() );
			private var _fruitpunch:Response = new Response( "Fruit Punch", new fruitpunch() );
			private var _fruits:Response = new Response( "Fruits", new fruits() );
			private var _grains:Response = new Response( "Grains", new grains() );
			private var _grapes:Response = new Response( "Grapes", new grapes() );
			private var _hulahoop:Response = new Response( "Hula Hoop", new hulahoop() );
			private var _jumprope:Response = new Response( "Jumprope", new jumprope() );
			private var _lemonade:Response = new Response( "Lemonade", new lemonade() );
			private var _meat:Response = new Response( "Meat", new meat() );
			private var _milk:Response = new Response( "Milk", new milk() );
			private var _orange:Response = new Response( "Orange", new orange() );
			private var _raisins:Response = new Response( "Raisins", new raisins() );
			private var _rice:Response = new Response( "Rice", new rice() );
			private var _running:Response = new Response( "Running", new running() );
			private var _sliceofbread:Response = new Response( "Slice of Bread", new sliceofbread() );
			private var _soccer:Response = new Response( "Soccer", new soccer() );
			private var _spinach:Response = new Response( "Spinach", new spinach() );
			private var _stretching:Response = new Response( "Stretching", new stretching() );
			private var _swimming:Response = new Response( "Swimming", new swimming() );
			private var _veggiejuice:Response = new Response( "Veggie Juice", new veggiejuice() );
			private var _water:Response = new Response( "Water", new water() );
			private var _weightbearing:Response = new Response( "Weight Bearing", new weightbearing() );
			private var _yoga:Response = new Response( "Yoga", new yoga() );
			
			private var _8ozornagedrink:Response = new Response( "8 oz. Orange Drink" );
			private var _4ozornagejuice:Response = new Response( "4 oz. Orange Juice" );
			private var _4ozfruitpunch:Response = new Response( "4 oz. Fruit Punch" );
			private var _8ozgrapesoda:Response = new Response( "8 oz Grape Soda/Pop" );
		}
		
		*/
		
		private var _QR : QuestionResponses = new QuestionResponses();
		
		public function Questions()
		{
			_responseHolder.x = 164;
			_responseHolder.y = 64;
			addChild(_responseHolder);
			
			for(var i:int = 0; i < _usedQuestions.length; i++)
				_usedQuestions[i] = new Array();
			
			// Load data
			
			// Cat 0 - Make Half Your Plate Fruits and Vegetables
			_categories.push( new Array() );
			_categories[0].push( new Question("Fiber helps you get rid of waste from your body. What kind of food has fiber?", 0, _QR._fruits_and_vegetables, [_QR._2_slices_of_cheese, _QR._meat, _QR._milk]) );
			_categories[0].push( new Question("Which of the these is the healthiest choice?", 0, _QR._apple, [_QR._pop, _QR._caramel_apple, _QR._crackers]) );
			_categories[0].push( new Question("Christy is hungry. Choose the healthiest snack for her.", 0, _QR._carrot, [_QR._french_fries, _QR._candybar, _QR._potato_chips]) );
			//_categories[0].push( new Question("Which of the following is a fruit?", 0, _orange, [_broccoli, _carrot, _spinach], new _whichIsaFruit()) );
			//_categories[0].push( new Question("Which of the following is a vegetable?", 0, _cucumber, [_banana, _apple, _grapes], new _whichIsaVegetable()) );
			//_categories[0].push( new Question("Which vegetable is not in the same family as broccoli?", 0, _cabbage, [_carrot, _brusselssprouts, _cauliflower], new _notRelatedToBroccoli()) );
			//_categories[0].push( new Question("What kind of juice counts toward a serving of fruit?", 0, _4ozornagejuice, [_8ozornagedrink, _4ozfruitpunch, _8ozgrapesoda]) );
			
			// Cat 0 - Avoid Oversized Portions
			_categories.push( new Array() );
			//_categories[1].push( new Question("Which of these food groups has a 3 oz. serving size that looks about the same size of a deck of cards?", 1, _meat, [_fruits, _grains, _dairy]) );
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