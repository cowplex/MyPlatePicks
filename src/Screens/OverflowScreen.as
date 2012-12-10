/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	
	public class OverflowScreen extends MovieClip
	{
		
		private var _overlayMask : MovieClip;
		
		public function OverflowScreen()
		{
			_overlayMask = new MovieClip();
			_overlayMask.graphics.lineStyle(1,0x333333);
			_overlayMask.graphics.beginFill(0x333333);
			_overlayMask.graphics.drawRect(-1000,-1000,2640,2480);
			_overlayMask.graphics.lineStyle(1,0x000000);
			_overlayMask.graphics.drawRect(0,0,640,480);
			_overlayMask.graphics.endFill();
			addChild(_overlayMask);
		}
	}

}