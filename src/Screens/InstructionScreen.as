/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.events.Event;
	
	public class InstructionScreen extends MovieClip
	{
		[Embed(source="assets/extra_narrations/Warmups_Final.mp3")] public var warmupinstructions:Class;
		
		private var _soundFile : Sound;
		private var _playingSound : SoundChannel;
		
		private var _background : BG_instructions;
		private var _timeout : Timer;
		private var _callback : Function;
		
		public function InstructionScreen()
		{
			_background = new BG_instructions();
			addChild(_background);
			
			_soundFile = new warmupinstructions();
			_playingSound = _soundFile.play();
			_playingSound.addEventListener(Event.SOUND_COMPLETE, narrationCallback);
			
			/*_timeout = new Timer(7000, 1);
			_timeout.addEventListener(TimerEvent.TIMER_COMPLETE, timerCallback);
			_timeout.start();*/
		}
		
		public function set callback(callback : Function) : void
		{
			_callback = callback;
		}
		
		private function timerCallback(e:TimerEvent) : void
		{
			_callback();
		}
		
		private function narrationCallback(e:Event) : void
		{
			_callback();
		}
	}

}