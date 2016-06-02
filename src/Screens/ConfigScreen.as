/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ConfigScreen extends MovieClip
	{
		
		private var _background : MovieClip;
		private var _callback : Function;
		private var _defaultArray : Array;
		
		public function ConfigScreen()
		{
			_background = new config_screen();
			
			_background.error.visible = false;
			_background.error.OK.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {_background.error.visible = false;});
			
			addChild(_background);
			
			_defaultArray = new Array(
				4,
				4,
				4,
				4,
				"Yes"
			);
		}
		
		public function set callback(f:Function) : void
		{
			_callback = f;
			_background.next.addEventListener(MouseEvent.MOUSE_DOWN, 
				function(e:MouseEvent):void
				{
					if(
						Number(_background.KC1.selectedLabel) +
						Number(_background.KC2.selectedLabel) +
						Number(_background.KC3.selectedLabel) +
						Number(_background.KC4.selectedLabel)
						!= 0
					)
						_callback();
					else
						_background.error.visible = true;
						//Alert.show('You must select questions from at least one knowledge category', 'Warning');
				}
			);
		}
		
		public function get configuration() : Array
		{
			var config_array : Array;
			if(_background.KC1.selectedLabel != null)
			{
				config_array = new Array(
					Number(_background.KC1.selectedLabel),
					Number(_background.KC2.selectedLabel),
					Number(_background.KC3.selectedLabel),
					Number(_background.KC4.selectedLabel),
					_background.rand.selectedLabel
				);
			}
			else
			{
				config_array = _defaultArray;
			}
			return config_array;
		}
		
		public function get defaults() : Boolean
		{
			return (this.configuration == _defaultArray);
		}
		
		public function get dataSource() : String
		{
			if(_background.datasource.selectedLabel != null)
				return _background.datasource.selectedLabel;
			else
				return "KidsCom";
		}
	}

}