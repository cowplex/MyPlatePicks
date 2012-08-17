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
		
		[Embed(source="Logos/C1N_Logo_wide.png")]
		private var L1:Class;
		[Embed(source="Logos/kc_dot_com-copy.png")]
		private var L2:Class;
		[Embed(source="Logos/Online_Game_CPHP_Logo_w_snap-ed.jpg")]
		private var L3:Class;
		
		private var _logo1 : Bitmap = new L1();
		private var _logo2 : Bitmap = new L2();
		private var _logo3 : Bitmap = new L3();
		
		private var _callback : Function;
		
		private var _logoOrder : Array = new Array(_logo1, _logo2, _logo3);
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

			// Scale logos to fit on screen
			_logo1.scaleX = _logo1.scaleY = (_logo1.width > 600) ? (600 / _logo1.width) : 1;
			_logo2.scaleX = _logo2.scaleY = (_logo2.width > 600) ? (600 / _logo2.width) : 1;
			_logo3.scaleX = _logo3.scaleY = (_logo3.width > 600) ? (600 / _logo3.width) : 1;
			
			//Position logos in center of screen
			_logo1.y = 240 - _logo1.height / 2;
			_logo1.x = 320 - _logo1.width / 2;
			
			_logo2.y = 240 - _logo2.height / 2;
			_logo2.x = 320 - _logo2.width / 2;
			
			_logo3.y = 240 - _logo3.height / 2;
			_logo3.x = 320 - _logo3.width / 2;
			
			// Fade logos out, so they can be faded in
			_logo1.alpha = 
			_logo2.alpha =
			_logo3.alpha = 0;
			
			for(var i:int = 0; i < _logoOrder.length; i++)
				addChild(_logoOrder[i]);
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