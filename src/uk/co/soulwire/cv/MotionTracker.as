/**		
 * 
 *	MotionTracker
 *	
 *	@version 1.00 | Apr 2, 2008
 *	@author Justin Windle
 *	
 *	MotionTracker is a very simple but fast approach to basic motion tracking 
 *	using a webcam as input. For more information, please visit my blog:
 *	
 *	http://blog.soulwire.co.uk/code/actionscript-3/webcam-motion-detection-tracking
 *  
 **/
 
package uk.co.soulwire.cv 
{
	// Thanks to Grant Skinner for the ColorMatrix Class
	import com.gskinner.geom.ColorMatrix;

	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.media.Video;

	public class MotionTracker extends Point
	{

		//	----------------------------------------------------------------
		//	CONSTANTS
		//	----------------------------------------------------------------

		private static const DEFAULT_AREA : int = 10;
		private static const DEFAULT_BLUR : int = /*20*/10;
		private static const DEFAULT_BRIGHTNESS : int = /*20*/ 40;
		private static const DEFAULT_CONTRAST : int = 150;
		
		private static const _transform:ColorTransform = new ColorTransform(1,0,0,1,0,0,0,0);

		//	----------------------------------------------------------------
		//	PRIVATE MEMBERS
		//	----------------------------------------------------------------

		private var _now : BitmapData;
		private var _old : BitmapData;

		private var _blr : BlurFilter;
		private var _cmx : ColorMatrix;
		private var _col : ColorMatrixFilter;
		private var _box : Rectangle;
		private var _act : Boolean;
		private var _mtx : Matrix;
		private var _min : uint;

		private var _brightness : Number = 0.0;
		private var _contrast : Number = 0.0;
		private var _threshold : Number = 0xFF404040;

		//	----------------------------------------------------------------
		//	CONSTRUCTOR
		//	----------------------------------------------------------------
		
		/**
		 * The MotionTracker class will track the movement within video data
		 * 
		 * @param	source	A video object which will be used to track motion
		 */

		public function MotionTracker( w : int, h : int/*source : Video*/ ) 
		{
			super();
						
			if ( _now != null ) 
			{ 
				_now.dispose(); 
				_old.dispose(); 
			}
			_now = new BitmapData(w, h, false, 0);
			_old = new BitmapData(w, h, false, 0);
			
			_cmx = new ColorMatrix();
			_blr = new BlurFilter();
			
			blur = DEFAULT_BLUR;
			minArea = DEFAULT_AREA;
			contrast = DEFAULT_CONTRAST;
			brightness = DEFAULT_BRIGHTNESS;
			
			applyColorMatrix();
		}

		//	----------------------------------------------------------------
		//	PUBLIC METHODS
		//	----------------------------------------------------------------
		
		/**
		 * Track movement within the source Video object.
		 */

		public function track( input : BitmapData ) : void
		{
			_now.copyPixels(input, input.rect, new Point());
			_now.draw(_old, null, null, BlendMode.DIFFERENCE);
			
			_now.applyFilter(_now, _now.rect, new Point(), _col);
			_now.applyFilter(_now, _now.rect, new Point(), _blr);
			
			//_now.threshold(_now, _now.rect, new Point(), '>', 0xFF333333, 0xFFFFFFFF);
			_now.threshold(_now, _now.rect, new Point(), '>', _threshold, 0xFFFFFFFF);
			_now.threshold(_now, _now.rect, new Point(), '<=', _threshold, 0xFF000000);
			
			_old.copyPixels(input, input.rect, new Point());
			
			var area : Rectangle = _now.getColorBoundsRect(0xFFFFFFFF, 0xFFFFFFFF, true);
			_act = ( area.width > ( _now.width / 100) * _min || area.height > (_now.height / 100) * _min );
			
			if ( _act )
			{
				_box = area;
				x = _box.x + (_box.width / 2);
				y = _box.y + (_box.width / 2);
			}
		}
		
		/**
		 *  Detect Motion in an area
		 */
		
		public function detectMotion( position : Rectangle) : Rectangle
		{
			var frame : BitmapData = new BitmapData(_now.width, _now.height, false, 0);
			var area : Rectangle;
			
			frame.copyPixels(_now, _now.rect, new Point());
			frame.colorTransform(position, _transform);
			
			area =frame.getColorBoundsRect(0xFFFFFFFF, 0xFFFF0000, true);
			
			return area;
		}

		//	----------------------------------------------------------------
		//	PRIVATE METHODS
		//	----------------------------------------------------------------

		private function applyColorMatrix() : void
		{
			_cmx.reset();
			_cmx.adjustContrast(_contrast);
			_cmx.adjustBrightness(_brightness);
			_col = new ColorMatrixFilter(_cmx);
		}

		//	----------------------------------------------------------------
		//	PUBLIC ACCESSORS
		//	----------------------------------------------------------------
		
		/**
		 * The image the MotionTracker is working from
		 */
		public function get trackingImage() : BitmapData 
		{ 
			return _now; 
		}

		/**
		 * The area of the image the MotionTracker is working from
		 */
		public function get trackingArea() : Rectangle 
		{ 
			return new Rectangle(0, 0, _now.width, _now.height); 
		}

		/**
		 * Whether or not movement is currently being detected
		 */
		public function get hasMovement() : Boolean 
		{ 
			return _act; 
		}

		/**
		 * The area in which movement is being detected
		 */
		public function get motionArea() : Rectangle 
		{ 
			return _box; 
		}

		/* BLUR */
		
		/**
		 * the blur being applied to the input in order to improve accuracy
		 */
		public function get blur() : int 
		{ 
			return _blr.blurX; 
		}

		public function set blur( n : int ) : void 
		{ 
			_blr.blurX = _blr.blurY = n; 
		}

		/* BRIGHTNESS */
		
		/**
		 * The brightness filter being applied to the input
		 */
		public function get brightness() : Number 
		{ 
			return _brightness; 
		}

		public function set brightness( n : Number ) : void
		{
			_brightness = n;
			applyColorMatrix();
		}

		/* CONTRAST */
		
		/**
		 * The contrast filter being applied to the input
		 */
		public function get contrast() : int 
		{ 
			return _cmx.contrast; 
		}

		public function set contrast( n : int ) : void
		{
			_contrast = n;
			applyColorMatrix();
		}

		/* MIN AREA */
		
		
		/**
		 * The minimum area (percent of the input dimensions) of movement to be considered movement
		 */
		public function get minArea() : uint 
		{ 
			return _min; 
		}

		public function set minArea( n : uint ) : void
		{
			_min = n;
		}
		
	}
}
