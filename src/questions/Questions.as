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
			_categories[0].push( new Array() );
			_categories[0][0].push( new Question("Fiber helps you get rid of waste from your body. What kind of food has fiber?", 0, _QR._fruits_and_vegetables, [_QR._cheese, _QR._meat, _QR._milk]) );
			_categories[0][0].push( new Question("Which of the these is the healthiest choice?", 0, _QR._apple, [_QR._pop, _QR._caramel_apple, _QR._crackers]) );
			_categories[0][0].push( new Question("Christy is hungry. Choose the healthiest snack for her.", 0, _QR._carrot, [_QR._french_fries, _QR._candybar, _QR._potato_chips]) );
			
			_categories[0].push( new Array() );
			_categories[0][1].push( new Question("Which of the following is a vegetable?", 0, _QR._cucumber, [_QR._banana, _QR._apple, _QR._grapes], new _whichIsaVegetable()) );
			_categories[0][1].push( new Question("Fruits and vegetables are foods you can _________ to get energy and help you grow.", 0, _QR._Eat_More, [_QR._Eat_Less, _QR._Eat_None]) );
			_categories[0][1].push( new Question("Make ___________ your dinner plate fruits and vegetables", 0, _QR._Half, [_QR._All, _QR._Almost_all, _QR._None]) );
			
			_categories[0].push( new Array() );
			_categories[0][2].push( new Question("Do you know what healthy nutrients fruits/vegetables contain?", 0, _QR._All_of_these_choices, [_QR._Vitamins, _QR._Antioxidants, _QR._Minerals]) );
			_categories[0][2].push( new Question("What vegetable should you eat most often so you can stay healthy?", 0, _QR._All_of_these_choices, [_QR._tomato, _QR._squash, _QR._spinach]) );
			_categories[0][2].push( new Question("Vegetables grow....", 0, _QR._in_the_ground, [_QR._in_grocery_stores, _QR._on_trees, _QR._and_come_down_from_the_sky]) );

			// Cat 1 - Avoid Oversized Portions
			_categories.push( new Array() );
			_categories[1].push( new Array() );
			_categories[1][0].push( new Question("Eating smaller portions can help you:", 0, _QR._Be_strong_and_healthy, [_QR._Wake_up, _QR._be_more_popular, _QR._read_better]) );
			_categories[1][0].push( new Question("From which food group should you eat the fewest servings each day?", 0, _QR._Protein, [_QR._grains_copy, _QR._Vegetables, _QR._Fruits]) );
			_categories[1][0].push( new Question("Eating oversized portions of unhealthy foods gives you:", 0, _QR._All_of_these_choices, [_QR._Extra_Fat, _QR._Extra_Calories, _QR._Extra_Sugar]) );
			
			_categories[1].push( new Array() );
			_categories[1][1].push( new Question("1 serving of dairy equals:", 0, _QR._8_ounces_of_yogurt, [_QR._2_slices_of_cheese, _QR._1_cup_of_ice_cream, _QR._6_ounces_of_milk]) );
			_categories[1][1].push( new Question("How big is a serving of fruit?", 0, _QR._One_fist, [_QR._Two_handfuls, _QR._As_much_as_you_can_eat, _QR._Size_of_your_foot]) );
			_categories[1][1].push( new Question("A 1 ounce serving of grains is equal to:", 0, _QR._1_slice_whole_wheat_bread, [_QR._1_cup_white_rice, _QR._3_4_cups_whole_grain_pasta, _QR._Cinnamon_roll]) );
			
			_categories[1].push( new Array() );
			_categories[1][2].push( new Question("From which food group should you eat the most servings each day?", 0, _QR._Vegetables, [_QR._Fruits, _QR._Protein, _QR._Dairy]) );
			_categories[1][2].push( new Question("The serving size of a food is:", 0, _QR._All_of_these_choices, [_QR._A_way_to_measure_food, _QR._Found_on_all_food_labels, _QR._Important_to_know_for_choosing_healthier_portions]) );
			_categories[1][2].push( new Question("How many servings of fruits and vegetables do you need every day?", 0, _QR._5_five, [_QR._4_four, _QR._3_three, _QR._2_two]) );
			
			// Cat 2
			_categories.push( new Array() );
			_categories[2].push( new Array() );
			_categories[2][0].push( new Question("Which drink should you choose most often when you feel thirsty?", 0, _QR._water, [_QR._juice, _QR._milk, _QR._sportsdrink]) );
			_categories[2][0].push( new Question("What does regular soda/pop contain?", 0, _QR._Sugar, [_QR._Vitamins, _QR._Minerals, _QR._Fat]) );
			_categories[2][0].push( new Question("Which one of these can you drink a lot of and still be healthy?", 0, _QR._water, [_QR._chocolateshake, _QR._lemonade, _QR._slushie]) );
			
			_categories[2].push( new Array() );
			_categories[2][1].push( new Question("Our bones grow stronger when we drink:", 0, _QR._milk, [_QR._juice, _QR._water, _QR._pop]) );
			_categories[2][1].push( new Question("Which of the following is NOT a sugary drink?", 0, _QR._water, [_QR._sweet_tea, _QR._sportsdrink, _QR._grape_drink]) );
			_categories[2][1].push( new Question("Our bodies are composed of mostly:", 0, _QR._Water, [_QR._Blood, _QR._Organs, _QR._Skin]) );
			
			_categories[2].push( new Array() );
			_categories[2][2].push( new Question("You just ran a mile in gym class, what is the best thing to drink?", 0, _QR._water, [_QR._sportsdrink, _QR._juice, _QR._pop]) );
			_categories[2][2].push( new Question("How many ounces are in 1 cup of water?", 0, _QR._8_ounces, [_QR._4_ounces, _QR._12_ounces, _QR._16_ounces]) );
			_categories[2][2].push( new Question("Your teeth grow stronger when you drink which beverage?", 0, _QR._milk, [_QR._pop, _QR._juice, _QR._water]) );
			
			// Cat 3
			_categories.push( new Array() );
			_categories[3].push( new Array() );
/*		*/	_categories[3][0].push( new Question("Which sport is a weight bearing activity that will help build strong bones?", 0, _QR._jumprope, [_QR._swimming, _QR._biking, _QR._stretching]) );
			_categories[3][0].push( new Question("When we are physically active, we benefit our:", 0, _QR._All_of_these_choices, [_QR._muscles, _QR._Blood, _QR._bones]) );
			_categories[3][0].push( new Question("In a typical day, we should try to be active or exercise for:", 0, _QR._At_least_1_hour, [_QR._At_least_30_minutes, _QR._At_least_1_minute, _QR._At_least_2_hours]) );
			
			_categories[3].push( new Array() );
			_categories[3][1].push( new Question("Kids need to exercise:", 0, _QR._One_time_each_day, [_QR._One_time_each_week, _QR._One_time_each_month, _QR._One_time_each_year]) );
			_categories[3][1].push( new Question("What are signs that we are exercising and working hard?", 0, _QR._All_of_these_choices, [_QR._Our_heart_rate_increases, _QR._We_are_breathing_heavier, _QR._We_feel_warmer]) );
			_categories[3][1].push( new Question("If we get more than 1 hour of exercise each day we:", 0, _QR._All_of_these_choices, [_QR._Feel_great, _QR._Burn_extra_energy, _QR._Fall_asleep_faster]) );
			
			_categories[3].push( new Array() );
			_categories[3][2].push( new Question("During commercial breaks, when you are watching TV, what can you do to be physically active?", 0, _QR._Jumping_Jacks, [_QR._Continue_sitting, _QR._Walk_to_get_a_snack_and_sit_back_down, _QR._Get_a_drink_of_water]) );
			_categories[3][2].push( new Question("Which type of exercise will build strong muscles?", 0, _QR._All_of_these_choices, [_QR._pushups, _QR._jumping_jacks, _QR._situps]) );
			_categories[3][2].push( new Question("It recently snowed outside, so you have to play inside. Which activity involves the most physical activity?", 0, _QR._dancing, [_QR._coloring, _QR._baking, _QR._watching_tv]) );
			
		}
		
		public function drawQuestion( level : int, category : int ) : void
		{
			level--;
			if(category < 0 || category > _categories.length)
				return;
			
			// Reset question list if all questions have been asked
			if(_categories[category][level].length <= 0)
			{
				while(_usedQuestions[category][level].length > 0)
					_categories[category][level].push(_usedQuestions[category][level].pop());
			}
			
			if(_categories[category][level].length > 0)
			{
				_currentQuestion = _categories[category][level].splice(int(Math.random() * _categories[category][level].length), 1)[0];
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
		
		public function set scoreCallback(scoreCallback : Function) : void
		{
			_scoreCallback = scoreCallback;
		}
		
		public function set detectorCallback(detectorCallback : Function) : void
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