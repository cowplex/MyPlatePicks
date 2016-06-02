/**
 * @author mikelownds
 */
package
{
	
	// Debug! Yay!
	//import VideoDebug;
	//import flash.display.MovieClip;
		
	// Data Imports
	import Screens.*;
	import questions.Questions;
	import AR.*;
	import Reporting.*;
	
	// Shared Imports
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	
	// Motion Tracking Imports
	import uk.co.soulwire.cv.MotionTracker;
	
	// FLARToolkit imports
	
	// Flash stuff
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.*;
	import com.senocular.utils.*;
	
	//[Frame(factoryClass="preloaderclass")]
	[SWF(width="640", height="480", frameRate="30", backgroundColor="#333333")]
	public class MyPlatePicks extends Sprite
	{
		//DEBUG
		//private var debugVid : Bitmap;
		
		private static const QUESTIONS_PER_LEVEL : Number = 4;
		private static const NUM_WARMUP_QUESTIONS : Number = 6;
		
		private var _game : MovieClip;
		
		// Game Variables
		private var _gamestate : Number = 0;
		private var _reset : Boolean = false;
		private var _detecting : Boolean = true;
		private var _answeredQuestions : Number = 0;
		
		private var _questions : Questions;
		private var _questionValidator : Validator;
		private var _arDetector : ARDetector;
		
		private var _jukebox : Jukebox;
		
		private var _key : KeyObject;// = new KeyObject(this.stage/*stage*/);
		
		// Video Parameters
		private const _vidWidth : int = 420;
		private const _vidHeight : int = 320;
		private var _video    : Video;
		private var _bitmap   : BitmapData;
		private var _source   : Bitmap;
		private var _mtx      : Matrix
		
		// Menus
		private var _logoScreen : LogoScreen;
		private var _configScreen : ConfigScreen;
		private var _mainMenu : MainMenu;
		private var _login : LoginScreen;
		private var _instructions : InstructionScreen;
		private var _extraInstructions : Extra_instructions_holder;
		private var _warmup   : Warmup;
		private var _pause    : Pause;
		private var _scoreboard    : Scoreboard;
		private var _mainScreen    : Main;
		private var _level : Level;
		private var _arScreen : ARScreen;
		private var _interstitial : InterstitialScreen;
		private var _gameOver : GameOverScreen;
		private var _congratsScreen : CongratsScreen;
		private var _mask : OverflowScreen;
		
		// FLARToolkit variables	
		//private var raster:FLARRgbRaster_BitmapData;
		
		// Motion Tracker variables
		private var _motionTracker : MotionTracker;
		
		// Reporting Variables
		private var _report : Report;
		private var _highscore : Number = 0;
		
		// Setups
		{
		
		private function setupSequence( step : Number) : void
		{
			// Set up different parts of the game progressively
			switch(step)
			{
				case 0:
					setupLogoScreen();
					break;
				case 1:
					setupConfigScreen();
					if(_key.isDown(_key.SPACE))
					{
						break;
					}
				case 2:
					_game.removeChild(_configScreen);
					setupJukebox();
					setupMainMenu();
					_jukebox.play(0);
					break;
				case 3:
					setupReport();
					setupLoginScreen();
					break;
				case 4:
					_game.removeChild(_mainMenu);
					setupInstructions();
					setupExtraInstructions();
					break;
				case 5:
					setupMainScreen();
					
					_detecting = true;
					
					setupVideo();
					setupAR();
					
					setupWarmup();
					setupScoreboard();
					setupLevel();
					setupQuestions();
					setupQuestionValidator();
									
					setupPause();
									
					setupInterstitial();
					setupCongrats();
					
					addEventListener(Event.ENTER_FRAME, loop);
					
					if(_reset)
						_jukebox.play(1/*_level.level*/);
					else
						_jukebox.play(6);
					
					break;
				case 6:
					_jukebox.play(7);
					setupGameOver();
					_report.sendReport("quit", "");
					break;
				default: break;
			}
		}
		
		private function setupLogoScreen() : void
		{
			_logoScreen = new LogoScreen();
			_game.addChild(_logoScreen);
			_logoScreen.callback = logoScreenCallback;
		}
		
		private function setupConfigScreen() : void
		{
			_configScreen = new ConfigScreen();
			_configScreen.callback = function():void{setupSequence(2);};
			
			_game.addChild(_configScreen);
		}
		
		private function setupJukebox() : void
		{
			_jukebox = new Jukebox();
		}
		
		private function setupMainMenu() : void
		{
			_mainMenu = new MainMenu(_jukebox);
			/*_mainMenu._playButton.addEventListener(MouseEvent.MOUSE_DOWN, 
			                                                            function(e:MouseEvent):void
			                                                            {
			                                                            	_game.removeChild(_mainMenu);
			                                                            	setupSequence(3);
			                                                            }
			                                     );*/
			_mainMenu.playCallback = function(e:MouseEvent):void { setupSequence(3); };
			_game.addChild(_mainMenu);
		}
		
		private function setupReport() : void
		{
			_report = new Report(_configScreen.dataSource);
		}
		
		private function setupLoginScreen() : void
		{
			_login = new LoginScreen();
			_login.callback = loginScreenCallback;
			_login.reportCallback = _report.sendReport;
			_login.backCallback = function():void {_game.removeChild(_login);};
			_game.addChild(_login);
		}

		private function setupInstructions():void
		{
			_instructions = new InstructionScreen();
			_instructions.callback = instructionScreenCallback;
			_game.addChild(_instructions);
		}
		
		private function setupExtraInstructions():void
		{
			_extraInstructions = new Extra_instructions_holder();
			_extraInstructions.callback = extraInstructionsCallback;
		}
		private function setupVideo():void
		{
			if(_video != null)
			{
				_game.addChild(_source);
				return;
			}
			
			// Create the camera
			var cam : Camera = Camera.getCamera();
			cam.setMode(_vidWidth, _vidHeight, stage.frameRate);
			
			// Create a video
			_video = new Video(_vidWidth, _vidHeight);
			_video.attachCamera(cam);
			
			// Create the Motion Tracker
			_motionTracker = new MotionTracker(_vidWidth, _vidHeight);
			
			// Create transform matrix to flip video horizontally
			_mtx = new Matrix();
			_mtx.translate(-_vidWidth, 0); 
			_mtx.scale(-1, 1); 
			
			// Display the camera input with the same filters (minus the blur) as the MotionTracker is using
			_bitmap = new BitmapData(_vidWidth, _vidHeight, false, 0);
			_source = new Bitmap(_bitmap);
			_source.x = 164;
			_source.y = 90; //64;
			_game.addChild(_source);
			
			// DEBUG
			var debugVid : Bitmap = new Bitmap(_motionTracker.trackingImage);
			//debugVid.x = _source.x + 10 + _vidWidth;
			//debugVid.y = _source.y;
			//debugVid.scaleX = debugVid.scaleY = .25;
			debugVid.x = _source.x;
			debugVid.y = _source.y;
//			_game.addChild(debugVid);
			// DEBUG
			
		}
		
		private function setupAR() : void
		{
			// Setup detection screen
			_arScreen = new ARScreen();
			_arScreen.x = _source.x;
			_arScreen.y = _source.y;
			_arScreen.callback = stateCallback;
			
			// Setup AR Engine
			_arDetector = new ARDetector();
		}
		
		private function setupWarmup() : void
		{
			_warmup = new Warmup();
			_warmup.x = _source.x;
			_warmup.y = _source.y;
			_warmup.hitCallback = stateCallback;
			_game.addChild(_warmup);
		}
		
		private function setupPause() : void
		{
			_pause = new Pause(_jukebox);
			//_pause.x = _source.x;
			//_pause.y = _source.y;
			//_pause.x = 60;
			//_pause.y = 420;
			
			_pause.pauseCallback = pauseCallback;
			_pause.resetCallback = resetCallback;
			
//			function():void {
//				_report.sendReport("quit", "");
//				/*removeChild(_game); _game = new MovieClip(); addChild(_game);*/
//				_mainScreen.setupTimerCallback(null);
//				_reset = true;
//				_answeredQuestions = 0;
//				_gamestate = 0;
//				setupSequence(5);
//				validateCallback();
//				/*stateSetup(); /*stage.removeChildAt(0); stage.addChild(new MyPlatePicks()); /*_reset = true; stateCallback();*/
//			};

			_pause.quitCallback = quitGame;//function():void { _report.sendReport("quit", ""); _gamestate = 0; _video.attachCamera(null); while(_game.numChildren != 0) {_game.removeChildAt(0);} removeChild(_game); _game = new MovieClip(); addChild(_game); setupSequence(0);/*removeChild(this); /*stage.removeChildAt(0); stage.addChild(new MyPlatePicks()); /*_reset = true; stateCallback();*/ };
		
			//_game.addChild(_pause);
		}
		
		private function setupScoreboard() : void
		{
			//var highscore : Number = 0;
			if(_scoreboard != null)
				_highscore = _scoreboard.highScore;
			_scoreboard = new Scoreboard();
			_scoreboard.x = 305;
			_scoreboard.y = 420; //15;
			_scoreboard.highScore = _highscore;
			_game.addChild(_scoreboard);
		}
		
		private function setupMainScreen() : void
		{
			_mainScreen = new Main();
			_game.addChild(_mainScreen);
		}
		
		private function setupLevel() : void
		{
			_level = new Level();
			_level.x = 71;//67.5;
			_level.y = 25;
			_game.addChild(_level);
			
			//_scoreboard.questionsPerLevel = _level.numKnowledgeCategories * QUESTIONS_PER_LEVEL;
			_scoreboard.questionsPerLevel = Number(_configScreen.configuration[0]) + Number(_configScreen.configuration[1]) + Number(_configScreen.configuration[2]) + Number(_configScreen.configuration[3]);
			_scoreboard.resetLevel();
		}
		
		private function setupQuestions() : void
		{
			_questions = new Questions();
			_questions.scoreCallback = stateCallback;
			_questions.detectorCallback = _motionTracker.detectMotion;
			_questions.timerStartCallback = timerStartCallback;
			_game.addChild(_questions);
			
			_questions.randomness = Boolean(_configScreen.configuration[4] == "Yes");
			
			// Setup callback for timer to show correct/incorrect answers
			//_mainScreen.setupTimerCallback(_questions.questionTimeout);
			_mainScreen.setupTimerCallback(timerCallback);
		}
		
		private function setupQuestionValidator() : void
		{
			_questionValidator = new Validator();
			_questionValidator.x = _source.x;
			_questionValidator.y = _source.y;
			_questionValidator.callback = validateCallback;
			_game.addChild(_questionValidator);
		}
		
		private function setupInterstitial() : void
		{
			_interstitial = new InterstitialScreen();
			_interstitial.callback = stateCallback;
			//_game.addChild(_interstitial);
		}
		private function setupCongrats() : void
		{
			_congratsScreen = new CongratsScreen();
			_congratsScreen.callback = stateCallback;
		}
		
		private function setupGameOver() : void
		{
			_gameOver = new GameOverScreen(_scoreboard.levelScore, _scoreboard.levelScore/10, _scoreboard.highScore, _level.level, _configScreen.defaults);
			//_gameOver.callbackHome = resetGameMainMenuCallback;
 			//_gameOver.callbackRetry = restartGameCallback;
 			_gameOver.callbackRetry = resetCallback;
 			_gameOver.callbackHome = quitGame;
			_game.addChild(_gameOver);
		}
		
		}
		
		/*
		 * Constructor
		 */
		public function MyPlatePicks()
		{
			addEventListener(Event.ADDED_TO_STAGE, function(event:Event):void{_key = new KeyObject(stage);});
			
			_game = new MovieClip();
			addChild(_game);
			
			_mask = new OverflowScreen();
			addChild(_mask);
			
			setupSequence(0);
		}

		private function quitGame() : void
		{
			_report.sendReport("quit", "");
			_gamestate = 0;
			
			if(_scoreboard.highScore > _highscore)
				_highscore = _scoreboard.highScore;
			
			//_video.attachCamera(null);
			_jukebox.stop();
			
			while(_game.numChildren != 0)
				_game.removeChildAt(0);

			removeChild(_game); 
			_game = new MovieClip();
			addChild(_game); 
			//_detecting = true;
			setupSequence(0);
		}


		// Callbacks
		{
		
		private function resetGameMainMenuCallback() : void
		{
			_game.removeChild(_gameOver);
			//TODO: Add in functionality to return to main menu
		}

		public function restartGameCallback() : void
		{
			_game.removeChild(_gameOver);
			 _report.sendReport("quit", ""); 
			
			  _mainScreen.setupTimerCallback(null); 
			  _reset = true; 
			  _answeredQuestions = 0; 
			  setupSequence(5); 
			  _gamestate = 0; 
			  validateCallback();
		} 
		
		private function loginScreenCallback() : void
		{
			_game.removeChild(_login);
			setupSequence(4);
		}
		
		private function logoScreenCallback() : void
		{
			_game.removeChild(_logoScreen);
			setupSequence(1/*2*/);
		}
		
		private function instructionScreenCallback() : void
		{
			_game.removeChild(_instructions);
			setupSequence(5);
		}
			
		private function timerCallback() : void
		{
			switch(_gamestate)
			{
				case 2:
					_questions.questionTimeout();
					break;
				case 3:
					stateCallback();
					break;
			}
		}
		
		private function timerStartCallback() : void
		{
			 _mainScreen.timerStart(15);
			 _mainScreen.timerPaused = _questionValidator.paused;
		}
		
		private function pauseCallback( paused : Boolean ) : void
		{
			_mainScreen.timerPaused = paused;
			_questionValidator.paused = paused;
		}
		
		private function resetCallback() : void
		{
			_report.sendReport("quit", "");
			_mainScreen.setupTimerCallback(null);
			_reset = true;
			_answeredQuestions = 0;
			_gamestate = 0;
			setupSequence(5);
			validateCallback();
		}
		
		// Detect Scoring
		private function stateCallback( hit : Boolean = false, correct : Point = null, miss : Point = null, response : String = null) : void
		{
			switch(_gamestate)
			{
				case 0:
					_scoreboard.scoreEvent(true, true);
					_answeredQuestions++;
					if(_answeredQuestions >= NUM_WARMUP_QUESTIONS)
					{
						/*_game.removeChild(_warmup);
						_detecting = false;
						_level.level++;
						_game.addChild(_pause);*/
						//stateSetup();
						_questionValidator.validate();
					}
					break;
				case 1:
					// Remove Interstitial
					_game.removeChild(_interstitial);
					break;
				case 2:
					_detecting = false;
					
					_mainScreen.timerStop();
					
					_answeredQuestions++;
					_scoreboard.scoreEvent(hit);
					
					// Report on the event
					_report.level = _level.level.toString();
					_report.sendReport("answer", (hit ? "true" : response));
					_report.sendReport("time", _mainScreen.timerPosition.toString());
					_report.sendReport("score", _scoreboard.levelScore.toString());
					break;
				case 3:
					// Remove AR detector
					_detecting = false;
					_mainScreen.timerStop();
					//_scoreboard.scoreEvent(hit);
					_game.removeChild(_arScreen);
					break;
				case 4:
					_game.removeChild(_congratsScreen);
					if(_level.level == /*1*/4)
					{
						_gamestate = -1;
						setupSequence(6);
						break;
					}
				default: break;
			}
			
// FIXME: potentially move into switch statement
			if(_gamestate == 2)
				_questionValidator.validate(correct, miss);
			else if(_gamestate != 0)
				stateSetup();
		}
		
		private function validateCallback() : void
		{
			switch(_gamestate)
			{
				case 0:
					_detecting = false;
					if(!_game.contains(_warmup))
						return;
					_game.removeChild(_warmup);
					_game.addChild(_extraInstructions);
					_extraInstructions.playAudio();
					return;
					_detecting = false;
					_level.level++;
					_game.addChild(_pause);
					break;
				case 2:
					_questions.hideQuestion();
					_mainScreen.timerStop();
					break;
				case 3:
					break;
			}
			stateSetup();
		}
		
		private function extraInstructionsCallback() : void
		{
			_game.removeChild(_extraInstructions);
			_detecting = false;
			_level.level++;
			_game.addChild(_pause);
			stateSetup();
		}
		
		private function stateSetup() : void
		{
			if(_reset)
			{
				_gamestate = 1;
				//_reset = false;
			}
			
			switch(_gamestate)
			{
				case 0:
				case 2:
					if(_answeredQuestions < Number(_configScreen.configuration[_level.knowledgeCategory]))//QUESTIONS_PER_LEVEL)
						break;
					_answeredQuestions = 0;
				case 1:
					while(Number(_configScreen.configuration[_level.knowledgeCategory]) == 0 && _level.knowledgeCategory < 5)
						_level.knowledgeCategory++;
				default:
					if(!_reset)
						_gamestate++;
			}
			
			_reset = false;
			
			if(_gamestate > 3)
			{
				_questions.hideARTargetQuestion();
				_gamestate = 1;
				_level.knowledgeCategory++;
				while(Number(_configScreen.configuration[_level.knowledgeCategory]) == 0 && _level.knowledgeCategory < 5)
						_level.knowledgeCategory++;
				_mainScreen.changeBG(_level.level);
				//_level.level++;
			}
			
			// Show a screen on level-up
			if(_level.leveled_up)
				_gamestate = 4;
			
			//if(_level.level == /*1*/4)
			/*{
				_gamestate = -1;
				setupSequence(6);
			}*/
			
			switch(_gamestate)
			{
				case 1:
					// Interstitial 
					_game.addChild(_interstitial);
					_interstitial.show(_level.level, _level.knowledgeCategory);
					_detecting = false;
					_questions.resetQuestionCount();
					
					// Add level music
					_jukebox.play(_level.level);
					
					_report.sendReport("interstitial", "");
					
					_questions.numRandomQuestions = Number(_configScreen.configuration[_level.knowledgeCategory]) - 2;
					
					break;
				case 2:
					// Add Question
					_scoreboard.updateRound();
					var interval : Boolean = _scoreboard.showQuestion();
					setTimeout(_questions.drawQuestion, (interval ? 2500 : 0), _level.level, _level.knowledgeCategory);
					//setTimeout(new function() : void {_questions.drawQuestion(_level.level, _level.knowledgeCategory); _report.sendReport("question", _questions.questionText);}, (interval ? 2500 : 0));
					setTimeout(sendQuestionReport, (interval ? 2600 : 50));
					//_questions.drawQuestion(_level.level, _level.knowledgeCategory);
					//_mainScreen.timerStart(15);
					_detecting = true;
					//_report.sendReport("question", _questions.questionText);
					break;
				case 3:
					_scoreboard.updateRound(true);
					// Begin AR Detection
					//_questions.showARTargetQuestion(_level.level, _level.knowledgeCategory);
					_arScreen.randomize();
					_game.addChild(_arScreen);
					//_arScreen.question(_level.level, _level.knowledgeCategory);
					_mainScreen.timerStart(40);
					//_arDetector.setupMarker(_level.level, _level.knowledgeCategory);
					_detecting = true;
					break;
				case 4:
					_game.addChild(_congratsScreen);
					_congratsScreen.correct("Correct: " + _scoreboard.qCorrect + "/" + _scoreboard.qTotal);
					_congratsScreen.total("Total: " + _scoreboard.totalCorrectQuestions + "/" + _scoreboard.totalGameQuestions);
					_congratsScreen.congratulate(_level.level - 1);
					_detecting = false;
					_level.knowledgeCategory = -1;
					_scoreboard.resetScore();
					_report.sendReport("max_level", _level.level.toString());
					break;
			}
		}
		
		}
		
		private function sendQuestionReport() : void
		{
			 //_report.sendReport("question", _questions.questionText);
			 _report.question = _questions.questionText;
		}
		
		// Main Loop
		private function loop(e:Event):void
		{
			// Update video frame
			_bitmap.draw(_video, _mtx);
			_motionTracker.track(_bitmap);
			//_pause.detectHit(_motionTracker.detectMotion(_pause.detectionArea));
			
			// Stop tracking if the game is paused or we're validating user input
			if(_pause.paused || !_detecting)
				return;
			
			// Track things
			switch(_gamestate)
			{
				case 0:
					// Warmup time
					_warmup.detectHit(_motionTracker.detectMotion(_warmup.detectionArea));
					_scoreboard.levelScore = 0;
					_scoreboard.highScore = 0;
					break;
				case 2:
					// Asking a question
					_questions.detectHit();
					break;
				case 3:
					// Detecting AR Marker
					/*if(_arScreen.detectAR(_arDetector.track(_bitmap)))
					{
						//_mainScreen.timerStop();
						_arScreen.renderMarker(_arDetector.getTransformMatrix());
					}*/
					if(_arScreen.detectHit(_motionTracker.detectMotion(_arScreen.detectionArea)))
						_scoreboard.scoreEvent(true, true);
					return;
			}
		}
		
	}

}