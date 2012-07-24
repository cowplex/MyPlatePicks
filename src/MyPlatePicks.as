/**
 * @author mikelownds
 */
package
{
	
	// Debug! Yay!
	//import VideoDebug;
	
	// Data Imports
	import Screens.*;
	
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
	
	[SWF(width="640", height="480", frameRate="30", backgroundColor="#FFFFFF")]
	public class MyPlatePicks extends Sprite
	{
		//DEBUG
		//private var debugVid : Bitmap;
		
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
		
		// FLARToolkit variables	
		//private var raster:FLARRgbRaster_BitmapData;
		
		// Motion Tracker variables
		private var _motionTracker : MotionTracker;
		
		private function setupMainMenu() : void
		{
			_mainMenu = new MainMenu();
			_mainMenu.playButton.addEventListener(MouseEvent.MOUSE_DOWN, 
			                                                            function(e:MouseEvent):void
			                                                            {
			                                                            	removeChild(_mainMenu);
			                                                            	setupVideo();
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
			
			_mtx = new Matrix();
			_mtx.translate(-_vidWidth, 0); 
			_mtx.scale(-1, 1); 
			
			// Display the camera input with the same filters (minus the blur) as the MotionTracker is using
			_bitmap = new BitmapData(_vidWidth, _vidHeight, false, 0);
			_source = new Bitmap(_bitmap);
			//_source.scaleX = -1;
			_source.x = 10;// + _vidWidth;
			_source.y = 10;
			addChild(_source);
			
			// DEBUG
			var debugVid : Bitmap = new Bitmap(_motionTracker.trackingImage);
			debugVid.x = 20 + _vidWidth;
			debugVid.y = 10;
			debugVid.scaleX = debugVid.scaleY = .25;
			addChild(debugVid);
			// DEBUG
			
			setupWarmup();
			addEventListener(Event.ENTER_FRAME, loop);
			
		}
		
		private function setupWarmup() : void
		{
			_warmup = new Warmup();
			_warmup.x = _source.x;
			_warmup.y = _source.y;
			addChild(_warmup);
		}
		
		public function MyPlatePicks()
		{
			setupMainMenu();
			//setupVideo();
			//addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(e:Event):void
		{
			_bitmap.draw(_video, _mtx);
			_motionTracker.track(_bitmap);
			_warmup.detectHit(_motionTracker.detectMotion(_warmup.detectionArea));
			/*var rect : Rectangle = new Rectangle(0,0,_vidWidth,_vidHeight);
			var test : Rectangle = _motionTracker.detectMotion(rect);
			trace(test);*/
		}
		
	}

}