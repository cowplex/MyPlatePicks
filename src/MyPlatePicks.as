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
		
		// Game Variables
		private var _gamestate : Number = 0;
		private var _detecting : Boolean = true;
		private var _answeredQuestions : Number = 0;
		private var _questions : Questions;
		private var _questionValidator : Validator;
		
		// Video Parameters
		private const _vidWidth : int = 420;
		private const _vidHeight : int = 320;
		private var _video    : Video;
		private var _bitmap   : BitmapData;
		private var _source   : Bitmap;
		private var _mtx      : Matrix
		
		// Menus
		private var _mainMenu : MainMenu;
		private var _warmup   : Warmup;
		private var _pause    : Pause;
		private var _scoreboard    : Scoreboard;
		private var _mainScreen    : Main;
		private var _level : Level;
		private var _arScreen : ARScreen;
		
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
					setupMainMenu();
					break;
				case 2:
					setupVideo();
					setupAR();
					
					setupWarmup();
					setupPause();
					setupScoreboard();
					setupMainScreen();
					setupLevel();
					setupQuestions();
					setupQuestionValidator();
					
					addEventListener(Event.ENTER_FRAME, loop);
					
					break;
				default: break;
			}
		}
		
		private function setupMainMenu() : void
		{
			_mainMenu = new MainMenu();
			_mainMenu.playButton.addEventListener(MouseEvent.MOUSE_DOWN, 
			                                                            function(e:MouseEvent):void
			                                                            {
			                                                            	removeChild(_mainMenu);
			                                                            	setupSequence(2);
			                                                            }
			                                     );
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
			
			// Create transform matrix to flip video
			_mtx = new Matrix();
			_mtx.translate(-_vidWidth, 0); 
			_mtx.scale(-1, 1); 
			
			// Display the camera input with the same filters (minus the blur) as the MotionTracker is using
			_bitmap = new BitmapData(_vidWidth, _vidHeight, false, 0);
			_source = new Bitmap(_bitmap);
			_source.x = 164;
			_source.y = 64;
			addChild(_source);
			
			// DEBUG
			var debugVid : Bitmap = new Bitmap(_motionTracker.trackingImage);
			debugVid.x = _source.x + 10 + _vidWidth;
			debugVid.y = _source.y;
			debugVid.scaleX = debugVid.scaleY = .25;
//			addChild(debugVid);
			// DEBUG
			
		}
		
		private function setupAR() : void
		{
			// Setup detectin screen
			_arScreen = new ARScreen();
			_arScreen.x = _source.x;
			_arScreen.y = _source.y;
		}
		
		private function setupWarmup() : void
		{
			_warmup = new Warmup();
			_warmup.x = _source.x;
			_warmup.y = _source.y;
			_warmup.setupCallback(stateCallback);
			addChild(_warmup);
		}
		
		private function setupPause() : void
		{
			_pause = new Pause();
			_pause.x = _source.x;
			_pause.y = _source.y;
			addChild(_pause);
		}
		
		private function setupScoreboard() : void
		{
			_scoreboard = new Scoreboard();
			_scoreboard.x = 305;
			_scoreboard.y = 15;
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
		}
		
		private function setupQuestions() : void
		{
			_questions = new Questions();
			_questions.setScoreCallback(stateCallback);
			_questions.setDetectorCallback(_motionTracker.detectMotion);
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
			
		private function timerCallback() : void
		{
			switch(_gamestate)
			{
				case 1:
					_questions.questionTimeout();
					break;
				case 2:
					stateCallback();
					break;
			}
		}
		
		// Detect Scoring
		private function stateCallback( hit : Boolean = false, correct : Point = null, miss : Point = null) : void
		{
			switch(_gamestate)
			{
				case 0:
					_answeredQuestions++;
					if(_answeredQuestions >= QUESTIONS_PER_LEVEL)
					{
						removeChild(_warmup);
						_detecting = false;
						_level.level++;
						//stateSetup();
						_questionValidator.validate();
					}
					break;
				case 1:
					_detecting = false;
					
					_mainScreen.timerStop();
					
					_answeredQuestions++;
					_scoreboard.scoreEvent(hit);
					break;
				case 2:
					// Remove AR detector
					_detecting = false;
					
					removeChild(_arScreen);
					break;
				case 3:
					// Remove Interstitial
					break;
				default: break;
			}
			
// FIXME: potentially move into switch statement
			if(_gamestate == 1)
				_questionValidator.validate(correct, miss);
			else if(_gamestate != 0)
				stateSetup();
		}
		
		private function validateCallback() : void
		{
			switch(_gamestate)
			{
				case 1:
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
				case 1:
					if(_answeredQuestions < QUESTIONS_PER_LEVEL)
						break;
					_answeredQuestions = 0;
				default:
					_gamestate++;
			}
			
			if(_gamestate > 3)
			{
				_gamestate = 1;
				_level.level++;
			}
			
			switch(_gamestate)
			{
				case 1:
					// Add Question
					_questions.drawQuestion(_level.level);
					_mainScreen.timerStart(10);
					_detecting = true;
					break;
				case 2:
					// Begin AR Detection
					addChild(_arScreen);
					_mainScreen.timerStart(20);
					_detecting = true;
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
			_pause.detectHit(_motionTracker.detectMotion(_pause.detectionArea));
			
			// Stop tracking if the game is paused or we're validating user input
			if(_pause.paused || !_detecting)
				return;
			
			// Track things
			switch(_gamestate)
			{
				case 0:
					_warmup.detectHit(_motionTracker.detectMotion(_warmup.detectionArea));
					break;
				case 1:
					_questions.detectHit();
					break;
			}
		}
		
	}

}