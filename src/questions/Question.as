/**
 * @author mikelownds
 */
package questions
{
//	import Questions;
//	import Response;

	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.media.Sound;
    import flash.media.SoundChannel;
	
	public class Question extends Sprite
	{
		[Embed(systemFont="Baskerville", fontName="qFont", fontWeight="normal", mimeType = "application/x-font")] 
		private var font:Class;
		
		private var _question     : String;
		private var _category     : Number;
		private var _response     : Response;
		private var _responses    : Array = new Array();
		private var _randomResponses : Array;
		
		private var _sound : Sound = null;
		private var _soundChannel : SoundChannel;
		
		private var _questionDisplay : TextField;
		private var _textFormat : TextFormat = new TextFormat();
		
		public function Question(question : String, category : Number, correct : Response/*Bitmap*/, choices : Array, audio : Sound = null)
		{
			_sound = audio;
			_category = category;
			_response = correct;//new Response(category, correct);
			for(var i:int = 0; i < choices.length; i++)
			{
				_responses[i] = choices[i];//new Response(category, choices[i]);
			}
			// 330, 440, 455, 70
			
			_textFormat.size = 16;
			_textFormat.font = "qFont";
			
			_questionDisplay = new TextField();
			_questionDisplay.defaultTextFormat = _textFormat;
			_questionDisplay.text = question;
			_questionDisplay.x = 265 - 59;//150;//330;
			_questionDisplay.y = 25 - 12;//21;//410;
			_questionDisplay.width = 375;//455;
			_questionDisplay.height = 70;
			_questionDisplay.wordWrap = true;
			addChild(_questionDisplay);
		}
		
		public function get category() : Number
		{
			return _category;
		}
		public function get response() : Response
		{
			return _response;
		}
		
		public function randomizeResponses() : void
		{
			var unsortedResponses : Array = new Array(_response);
			for(var i:int = 0; i < _responses.length; i++)
				unsortedResponses.push(_responses[i]);
			
			_randomResponses = new Array(unsortedResponses.length);
			
			var randomPos:Number = 0;
			for (i = 0; i < _randomResponses.length; i++)
			{
				randomPos = int(Math.random() * unsortedResponses.length);
				_randomResponses[i] = unsortedResponses.splice(randomPos, 1)[0];   //since splice() returns an Array, we have to specify that we want the first (only) element
			}
		}
		
		public function getRandomResponses() : Array
		{
			return _randomResponses;
		}
		
		public function get incorrectResponses() : Array
		{
			return _responses;
		}
		public function get correctResponse() : Response
		{
			return _response;
		}
		
		public function readQuestion() : void
		{
			if(_sound != null)
				_soundChannel = _sound.play();
		}
		public function stopQuestion() : void
		{
			if(_sound != null)
				_soundChannel.stop();
		}
	}	
}