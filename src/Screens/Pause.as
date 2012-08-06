/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Graphics;
	
	public class Pause extends Sprite
	{
		
		private static const TARGET_SCALE : Number = 0.75;
		private static const SEARCH_SCALE : Number = 1.5;
		private static const TARGET_RADIUS : int   = 20;
		private static const SLIDER_TRACK_LENGTH : int   = 100;
		
		private var _pauseIcon : Sprite;
		private var _pauseIconTarget : Rectangle;
		private var _pauseIconStart : Point;
		
		private var _paused : Boolean = false;
		
		public function Pause()
		{
			_pauseIcon = new Sprite();
			// define the line style
			_pauseIcon.graphics.lineStyle(2,0x000000);
			// define the fill
			_pauseIcon.graphics.beginFill(0x666699);
			// set the starting point for the play icon
			_pauseIcon.graphics.moveTo(-TARGET_RADIUS,-TARGET_RADIUS);
			// move the line through a series of coordinates
			_pauseIcon.graphics.lineTo(-TARGET_RADIUS,TARGET_RADIUS);
			_pauseIcon.graphics.lineTo(TARGET_RADIUS,TARGET_RADIUS);
			_pauseIcon.graphics.lineTo(TARGET_RADIUS,-TARGET_RADIUS);
			
			_pauseIcon.graphics.endFill();
			
			_pauseIcon.x = 15 + TARGET_RADIUS;
			_pauseIcon.y = 265 + TARGET_RADIUS;
			
			_pauseIconTarget = new Rectangle(_pauseIcon.x + _pauseIcon.width / 2 * (1 - TARGET_SCALE), // x
			                                 _pauseIcon.y + _pauseIcon.height / 2 * (1 - TARGET_SCALE), // y 
			                                 _pauseIcon.width * TARGET_SCALE, // width
			                                 _pauseIcon.height * TARGET_SCALE); // height
			
			_pauseIconStart = new Point(_pauseIconTarget.x, _pauseIconTarget.y);
			
			addChild(_pauseIcon);
		}
		
		public function get paused() : Boolean
		{
			return _paused;
		}
		
		public function get detectionArea() : Rectangle
		{
			return(new Rectangle(_pauseIconTarget.x, _pauseIconTarget.y - _pauseIconTarget.height * (SEARCH_SCALE - 1), _pauseIconTarget.width, _pauseIconTarget.height * SEARCH_SCALE));
		}
		
		public function detectHit( motion : Rectangle ) : void
		{
			if(motion.width * motion.height > 50 && detectionArea.intersects(motion))
			{
				_pauseIcon.y -= _pauseIconTarget.y - (motion.y + (motion.height / 2) - (_pauseIconTarget.height / 2));
				_pauseIconTarget.y = motion.y + (motion.height / 2) - (_pauseIconTarget.height / 2);
			}
		}
	}

}