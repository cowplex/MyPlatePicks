/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import com.gskinner.motion.GTween;
	
	public class LogoScreen extends MovieClip
	{
		
		//[Embed(source="Logos/C1N_Logo_wide.png")] private var L1:Class;
//		[Embed(source="Logos/combined.png")] private var L1:Class;
		//[Embed(source="Logos/kc_dot_com-copy.png")] private var L2:Class;
//		[Embed(source="Logos/Online_Game_CPHP_Logo_w_snap-ed.jpg")] private var L2:Class;

		[Embed(source="Logos/MPP.png")] private var L0:Class;
		[Embed(source="Logos/sponsored.png")] private var L1:Class;
		[Embed(source="Logos/UIC.png")] private var L2:Class;
		[Embed(source="Logos/combined.png")] private var L3:Class;

		
		//private var _logo1 : Bitmap = new L1();
		//private var _logo2 : Bitmap = new L2();
		//private var _logo3 : Bitmap = new L3();
		
		private var _callback : Function;
		
		private var _logoOrder : Array = new Array(new L0(), new L1(), new L2(), new L3());//, _logo3);
		private var _logoNum : int = 0;
		
		private var _fadeTween : GTween;
		
		public function LogoScreen()
		{
			// Create a white background
			var mc:MovieClip = new MovieClip();
			mc.graphics.beginFill(0xFFFFFF);
			mc.graphics.drawRect(0, 0, 640, 480);
			mc.graphics.endFill();
			addChild(mc);
			
			for(var i:int = 0; i < _logoOrder.length; i++)
			{
				// Scale logos to fit on screen
				_logoOrder[i].scaleX = _logoOrder[i].scaleY = (_logoOrder[i].width > 600) ? (600 / _logoOrder[i].width) : 1;
				//Position logos in center of screen
				_logoOrder[i].y = 240 - _logoOrder[i].height / 2;
				_logoOrder[i].x = 320 - _logoOrder[i].width / 2;
				// Fade logos out, so they can be faded in
				_logoOrder[i].alpha = 0;
				addChild(_logoOrder[i]);
			}
		}
		
		public function set callback( f : Function ) :  void
		{
			_callback = f;
			
			// Now we have a callback set up, start the fading
			_fadeTween = new GTween(_logoOrder[_logoNum], 1.5, {alpha:1});
			_fadeTween.onComplete = timeoutCallback;
		}
		
		private function tweenCallback(tween:GTween) : void
		{
			if(_logoOrder[_logoNum].alpha == 1)
			{
				_fadeTween = new GTween(_logoOrder[_logoNum], 1.0, {alpha:0});
				_fadeTween.onComplete = tweenCallback;
			}
			else if(++_logoNum < _logoOrder.length)
			{
				_fadeTween = new GTween(_logoOrder[_logoNum], 1.0, {alpha:1});
				_fadeTween.onComplete = timeoutCallback;
			}
			else
			{
				
				_callback();
			}
		}
		
		private function timeoutCallback(tween:GTween) : void
		{
			_fadeTween = new GTween(_logoOrder[_logoNum], 1.5, {alpha:1});
			_fadeTween.onComplete = tweenCallback;
		}
	}

}