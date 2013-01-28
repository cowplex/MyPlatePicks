/**
 * @author mikelownds
 */
package Screens
{
	import flash.display.MovieClip;
	import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.events.Event;
    
	public class Extra_instructions_holder extends MovieClip
	{
		[Embed(source="assets/extra_narrations/Tutorial_1.mp3")] public var warmupinstructions1:Class;
		[Embed(source="assets/extra_narrations/Tutorial_2.mp3")] public var warmupinstructions2:Class;
		
		private var _background : Extra_instructions;
		private var _audio : Array = new Array(new warmupinstructions1(), new warmupinstructions2());
		private var _callback : Function;
		
		private var _narrationPlace : Number = 0;
		private var _playingSound : SoundChannel;
		
		public function Extra_instructions_holder()
		{
			_background = new Extra_instructions;
			_background.gotoAndStop(1);
			addChild(_background);
		}
		
		public function set callback(f:Function):void
		{
			_callback = f;
		}
		
		public function playAudio(e:Event = null):void
		{
			if(_narrationPlace < _audio.length)
			{
				_playingSound = _audio[_narrationPlace].play();
				_playingSound.addEventListener(Event.SOUND_COMPLETE, playAudio);
				_background.play();
			}
			else
			{
				_callback();
			}
			_narrationPlace++;
		}
	}

}