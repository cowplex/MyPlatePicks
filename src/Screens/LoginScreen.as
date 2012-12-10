/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class LoginScreen extends MovieClip
	{
		
		private var _background : MovieClip;
		private var _callback : Function;
		private var _players : Number;
		private var _playerInputs : Array = new Array();
		
		public function LoginScreen()
		{
			_background = new login_screen();
			setup(1);
			addChild(_background);
		}
		
		public function set callback(f : Function) : void
		{
			_callback = f;
		}
		
		private function setup(frame : Number) : void
		{
			_background.gotoAndStop(frame);
			
			var i:int;
			
			switch(frame)
			{
				case 1:
					_background.oneplayer.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { _players = 1; setup(2); });
					_background.twoplayer.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { _players = 2; setup(2); });
					break;
				case 2:
					for(i = 0; i < _playerInputs.length; i++)
						removeChild(_playerInputs[i]);
					_playerInputs = new Array();
					_background.independent.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { doCallback(); });
					_background.kidscom.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { setup(3); });
					_background.back.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { setup(1); });
					break;
				case 3:
					for(i = 0; i < _players; i++)
					{
						_playerInputs[i] = new Login();
						_playerInputs[i].x = 320;
						_playerInputs[i].y = 480 + (_playerInputs[i].height + 15 * (_players - 1)) * (i - _players);
						addChild(_playerInputs[i]);
					}
					_background.back.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { setup(2); });
				default:
					break;
			}
		}
		
		private function doCallback() : void
		{
			_callback();
		}
	}

}