/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.*;
	
	public class LoginScreen extends MovieClip
	{
		
		private var _background : MovieClip;
		private var _callback : Function;
		private var _backCallback : Function;
		private var _reportCallback : Function;
		private var _players : Number;
		private var _playerInputs : Array = new Array();
		private var _playerUIDs : Array = new Array();
		
		private var _independent : Boolean = false;
		
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
		
		public function set backCallback(f : Function) : void
		{
			_backCallback = f;
		}
		
		public function set reportCallback(f : Function) : void
		{
			_reportCallback = f;
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
					_background.back.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { _backCallback(); });
					break;
				case 2:
					for(i = 0; i < _playerInputs.length; i++)
						removeChild(_playerInputs[i]);
					_playerInputs = new Array();
					for(i = 0; i < _playerUIDs.length; i++)
						removeChild(_playerUIDs[i]);
					_playerUIDs = new Array();
					_background.independent.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { _independent=true; setup(4);/*_callback();*/ });
					_background.kidscom.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { _independent=false; setup(3); });
					_background.back.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { setup(1); });
					break;
				case 3:
					for(i = 0; i < _playerUIDs.length; i++)
						removeChild(_playerUIDs[i]);
					_playerUIDs = new Array();
					for(i = 0; i < _players; i++)
					{
						_playerInputs[i] = new Login();
						_playerInputs[i].x = stage.stageWidth / 2; //320;
						_playerInputs[i].y = (stage.stageHeight / 2) - ((_playerInputs[i].height * _players + 15 * (_players - 1)) / 2) - (_playerInputs[i].height/2) - 30 + ((_playerInputs[i].height * (i+1) + 15 * i));
						//_playerInputs[i].y = (stage.stageHeight / 2 - _playerInputs[i].height / 2) + (((15 * (_players - 1)) + (_playerInputs[i].height * _players)) * ((i+1)/_players)) - (((15 * (_players - 1)) + (_playerInputs[i].height * _players))/2);
						//_playerInputs[i].y = /*680*//*480*/ 500 + (_playerInputs[i].height + 15 * (_players - 1)) * (i - _players);
						
						_playerInputs[i].newuser.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {var url:String = "http://www.my.kidscom.com/jsp_a01_mkc/jsp_a01_b04_mis/jsp_a01_b04_c01_registration/kc_register.jsp";var request:URLRequest = new URLRequest(url); navigateToURL(request);});			
						_playerInputs[i].help.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {var url:String = "http://www.kidscom.com/info/faq.html";var request:URLRequest = new URLRequest(url); navigateToURL(request);});			
						_playerInputs[i].rules.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {var url:String = "http://www.kidscom.com/chat/kidschat/rules.html";var request:URLRequest = new URLRequest(url); navigateToURL(request);});			
						
						addChild(_playerInputs[i]);
					}
					_background.back.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { setup(2); });
					_background.play_button.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { setup(4); });
					break;
				case 4:
					for(i = 0; i < _playerInputs.length; i++)
						removeChild(_playerInputs[i]);
					_playerInputs = new Array();
					for(i = 0; i < _players; i++)
					{
						_playerUIDs[i] = new UID_prompt();
						_playerUIDs[i].x = stage.stageWidth / 2; //320;
						_playerUIDs[i].y = (stage.stageHeight / 2) - ((_playerUIDs[i].height * _players + 15 * (_players - 1)) / 2) - (_playerUIDs[i].height/2) - 30 + ((_playerUIDs[i].height * (i+1) + 15 * i));
						
						_playerUIDs[i].uidname.text = "Player " + (i+1) + " UID:";
						
						addChild(_playerUIDs[i]);
					}
					_background.back.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { _independent ? setup(2) : setup(3); });
					_background.play_button.addEventListener(MouseEvent.MOUSE_DOWN,  function(e:MouseEvent):void { for(var i:int = 0; i < _players; i++) { _reportCallback("UID" + (i+1), _playerUIDs[i].UID.text) }; _callback(); });
					break;
				/*default:
					break;*/
			}
		}
	}

}