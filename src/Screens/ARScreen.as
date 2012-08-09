/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	
	public class ARScreen extends MovieClip
	{
		
		private var _detectorTarget : MovieClip;
		
		public function ARScreen()
		{
			_detectorTarget = new AR_detection();
			_detectorTarget.x = 210;
			_detectorTarget.y = 160;
			addChild(_detectorTarget);
		}
	}

}