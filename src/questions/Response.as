/**
 * @author mikelownds
 */
package questions
{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	public class Response extends Sprite
	{
		
		//private var _category     : String;
		private var _response     : Bitmap;
		private var _targetArea   : Rectangle;
		
		public function Response(/*category : String,*/ response : Bitmap)
		{
			//_category = category;
			_response = response;
			_response.scaleX = _response.scaleY = .5;
			addChild(_response);
			
			_targetArea = new Rectangle(this.x, this.y, this.width * .6, this.height * .6);
		}
		
		/*public function get category() : String
		{
			return _category;
		}*/
		
		public function get detectionArea() : Rectangle
		{
			// Setup detection area
			_targetArea.x = this.x + (this.width - _targetArea.width) / 2;
			_targetArea.y = this.y + (this.height - _targetArea.height) / 2;
			
			return _targetArea;
		}
	}

}