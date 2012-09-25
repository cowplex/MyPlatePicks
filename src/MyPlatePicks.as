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
	
	// Shared Imports
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
	
	[SWF(width="640", height="480", frameRate="30", backgroundColor="#333333")]
	public class MyPlatePicks extends Sprite
	{
		//DEBUG
		//private var debugVid : Bitmap;
		
		private static const QUESTIONS_PER_LEVEL : Number = 4;
		private static const NUM_WARMUP_QUESTIONS : Number = 6;
		
		// Game Variables
		private var _gamestate : Number = 0;
		private var _detecting : Boolean = true;
		private var _answeredQuestions : Number = 0;
		
		private var _questions : Questions;
		private var _questionValidator : Validator;
		private var _arDetector : ARDetector;
		
		private var _jukebox : Jukebox;
		
		// Video Parameters
		private const _vidWidth : int = 420;
		private const _vidHeight : int = 320;
		private var _video    : Video;
		private var _bitmap   : BitmapData;
		private var _source   : Bitmap;
		private var _mtx      : Matrix
		
		// Menus
		private var _logoScreen : LogoScreen;
		private var _mainMenu : MainMenu;
		private var _warmup   : Warmup;
		private var _pause    : Pause;
		private var _scoreboard    : Scoreboard;
		private var _mainScreen    : Main;
		private var _level : Level;
		private var _arScreen : ARScreen;
		private var _interstitial : InterstitialScreen;
		private var _gameOver : GameOverScreen;
		private var _congratsScreen : CongratsScreen;
		
		// FLARToolkit variables	
		//private var raster:FLARRgbRaster_BitmapData;
		
		// Motion Tracker variables
		private var _motionTracker : MotionTracker;
		
		// Setups
		{
		
		private function setupSequence( step : Number) : void
		{
			// Set up different parts of the game progressively
			switch(step)
			{
				case 1:
					setupLogoScreen();
					break;
				case 2:
					setupJukebox();
					setupMainMenu();
					_jukebox.play(0);
					break;
				case 3:
					removeChild(_mainMenu);
					
					setupMainScreen();
					
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
					
					break;
				case 4:
					setupGameOver();
					break;
				default: break;
			}
		}
		
		private function setupLogoScreen() : void
		{
			_logoScreen = new LogoScreen();
			addChild(_logoScreen);
			_logoScreen.callback = logoScreenCallback;
		}
		
		private function setupJukebox() : void
		{
			_jukebox = new Jukebox();
		}
		
		private function setupMainMenu() : void
		{
			_mainMenu = new MainMenu();
			/*_mainMenu._playButton.addEventListener(MouseEvent.MOUSE_DOWN, 
			                                                            function(e:MouseEvent):void
			                                                            {
			                                                            	removeChild(_mainMenu);
			                                                            	setupSequence(3);
			                                                            }
			                                     );*/
			_mainMenu.playCallback = function(e:MouseEvent):void { setupSequence(3); };
			addChild(_mainMenu);
		}
		
		private function setupVideo():void
		{
			
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
			addChild(_source);
			
			// DEBUG
			var debugVid : Bitmap = new Bitmap(_motionTracker.trackingImage);
			//debugVid.x = _source.x + 10 + _vidWidth;
			//debugVid.y = _source.y;
			debugVid.scaleX = debugVid.scaleY = .25;
//			addChild(debugVid);
			// DEBUG
			
		}
		
		private function setupAR() : void
		{
			// Setup detection screen
			_arScreen = new ARScreen();
			_arScreen.x = _source.x;
			_arScreen.y = _source.y;
			
			// Setup AR Engine
			_arDetector = new ARDetector();
		}
		
		private function setupWarmup() : void
		{
			_warmup = new Warmup();
			_warmup.x = _source.x;
			_warmup.y = _source.y;
			_warmup.hitCallback = stateCallback;
			addChild(_warmup);
		}
		
		private function setupPause() : void
		{
			_pause = new Pause();
			//_pause.x = _source.x;
			//_pause.y = _source.y;
			_pause.x = 60;
			_pause.y = 420;
			
			_pause.pauseCallback = pauseCallback;
			
			//addChild(_pause);
		}
		
		private function setupScoreboard() : void
		{
			_scoreboard = new Scoreboard();
			_scoreboard.x = 305;
			_scoreboard.y = 420; //15;
			addChild(_scoreboard);
		}
		
		private function setupMainScreen() : void
		{
			_mainScreen = new Main();
			addChild(_mainScreen);
		}
		
		private function setupLevel() : void
		{
			_level = new Level();
			_level.x = 67.5;
			_level.y = 25;
			addChild(_level);
			
			_scoreboard.questionsPerLevel = _level.numKnowledgeCategories * QUESTIONS_PER_LEVEL;
			_scoreboard.resetLevel();
		}
		
		private function setupQuestions() : void
		{
			_questions = new Questions();
			_questions.scoreCallback = stateCallback;
			_questions.detectorCallback = _motionTracker.detectMotion;
			addChild(_questions);
			
			// Setup callback for timer to show correct/incorrect answers
			//_mainScreen.setupTimerCallback(_questions.questionTimeout);
			_mainScreen.setupTimerCallback(timerCallback);
		}
		
		private function setupQuestionValidator() : void
		{
			_questionValidator = new Validator( validateCallback );
			_questionValidator.x = _source.x;
			_questionValidator.y = _source.y;
			addChild(_questionValidator);
		}
		
		private function setupInterstitial() : void
		{
			_interstitial = new InterstitialScreen();
			_interstitial.callback = stateCallback;
			//addChild(_interstitial);
		}
		private function setupCongrats() : void
		{
			_congratsScreen = new CongratsScreen();
			_congratsScreen.callback = stateCallback;
		}
		
		private function setupGameOver() : void
		{
			_gameOver = new GameOverScreen();
			addChild(_gameOver);
		}
		
		}
		
		/*
		 * Constructor
		 */
		public function MyPlatePicks()
		{
			setupSequence(1);
		}

		// Callbacks
		{
		
		private function logoScreenCallback() : void
		{
			removeChild(_logoScreen);
			setupSequence(2);
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
		
		private function pauseCallback( paused : Boolean ) : void
		{
			_mainScreen.timerPaused = paused;
		}
		
		// Detect Scoring
		private function stateCallback( hit : Boolean = false, correct : Point = null, miss : Point = null) : void
		{
			switch(_gamestate)
			{
				case 0:
					_scoreboard.scoreEvent(true, true);
					_answeredQuestions++;
					if(_answeredQuestions >= NUM_WARMUP_QUESTIONS)
					{
						removeChild(_warmup);
						_detecting = false;
						_level.level++;
						//stateSetup();
						_questionValidator.validate();
						addChild(_pause);
					}
					break;
				case 1:
					// Remove Interstitial
					removeChild(_interstitial);
					break;
				case 2:
					_detecting = false;
					
					_mainScreen.timerStop();
					
					_answeredQuestions++;
					_scoreboard.scoreEvent(hit);
					break;
				case 3:
					// Remove AR detector
					_detecting = false;
					
					removeChild(_arScreen);
					break;
				case 4:
					removeChild(_congratsScreen);
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
				case 2:
					_questions.hideQuestion();
					break;
				case 3:
					break;
			}
			stateSetup();
		}
		
		private function stateSetup() : void
		{
			switch(_gamestate)
			{
				case 0:
				case 2:
					if(_answeredQuestions < QUESTIONS_PER_LEVEL)
						break;
					_answeredQuestions = 0;
				default:
					_gamestate++;
			}
			
			if(_gamestate > 3)
			{
				_questions.hideARTargetQuestion();
				_gamestate = 1;
				_level.knowledgeCategory++;
				//_level.level++;
			}
			
			// Show a screen on level-up
			if(_level.leveled_up)
				_gamestate = 4;
			
			if(_level.level == 4)
			{
				_gamestate = -1;
				setupSequence(4);
			}
			
			switch(_gamestate)
			{
				case 1:
					// Interstitial 
					addChild(_interstitial);
					_interstitial.show(_level.level, _level.knowledgeCategory);
					_detecting = false;
					_questions.resetQuestionCount();
					
					// Add level music
					_jukebox.play(_level.level);
					
					break;
				case 2:
					// Add Question
					_questions.drawQuestion(_level.level, _level.knowledgeCategory);
					_scoreboard.showQuestion();
					_mainScreen.timerStart(15);
					_detecting = true;
					break;
				case 3:
					// Begin AR Detection
					_questions.showARTargetQuestion(_level.level, _level.knowledgeCategory);
					addChild(_arScreen);
					_arScreen.question(_level.level, _level.knowledgeCategory);
					_mainScreen.timerStart(40);
					_arDetector.setupMarker(_level.level, _level.knowledgeCategory);
					_detecting = true;
					break;
				case 4:
					addChild(_congratsScreen);
					_congratsScreen.congratulate();
					_detecting = false;
					break;
			}
		}
		
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
					break;
				case 2:
					// Asking a question
					_questions.detectHit();
					break;
				case 3:
					// Detecting AR Marker
					if(_arScreen.detectAR(_arDetector.track(_bitmap)))
					{
						//_mainScreen.timerStop();
						_arScreen.renderMarker(_arDetector.getTransformMatrix());
					}
					return;
			}
		}
		
	}

}