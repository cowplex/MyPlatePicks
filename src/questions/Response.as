/**
 * @author mikelownds
 */
package questions
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Response extends Sprite
	{
		
		private var _text         : String;
		private var _response     : Bitmap;
		private var _targetArea   : Rectangle;
		
		private var _background   : Sprite;
		
		private var _textField    : TextField;
		private var _format       : TextFormat;
		
		public function Response(name : String, response : Bitmap = null)
		{
			_text = name;
			_response = response;
			
			_background = new Sprite();
			addChild(_background);
			
			if(response != null)
			{
				_response.scaleX = _response.scaleY = .5;
				addChild(_response);
			}
			
			_format = new TextFormat();
			_format.size = 15;
			_format.align = TextFormatAlign.CENTER;
			
			_textField = new TextField();
			_textField.defaultTextFormat = _format;
			_textField.text = _text;
			
			_textField.wordWrap = true;
			_textField.autoSize = "center";
			_textField.width = (response == null) ? 81 : _response.width;
			_textField.y     = (response == null) ? 0  : _response.y + _response.height + 5;
			
			addChild(_textField);
			
			_background.graphics.beginFill(0xFFFFFF, 0.6);
			_background.graphics.drawRoundRect(0,0,this.width, this.height, 15);
			_background.graphics.endFill();
			
			_targetArea = new Rectangle(this.x, this.y, this.width * .6, this.height * .6);
		}
		
		public function get detectionArea() : Rectangle
		{
			// Setup detection area
			_targetArea.x = this.x + (this.width - _targetArea.width) / 2;
			_targetArea.y = this.y + (this.height - _targetArea.height) / 2;
			
			return _targetArea;
		}
	}

}