/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.events.Event;
    
	public class Jukebox
	{
		
		[Embed(source="assets/music/fly-guy.mp3")] public var mainmenu :Class;
		[Embed(source="assets/music/lowrider.mp3")] public var level1 :Class;
		[Embed(source="assets/music/concrete-jungle.mp3")] public var level2 :Class;
		[Embed(source="assets/music/urban-edge.mp3")] public var level3 :Class;
		[Embed(source="assets/music/get-rich.mp3")] public var win :Class;
		//[Embed(source="assets/music/hard-times.mp3")] public var lose :Class;
		[Embed(source="assets/music/so-fine.mp3")] public var credits :Class;
		[Embed(source="assets/music/bounce.mp3")] public var warmup :Class;
		
		private var _volTransform : SoundTransform;
		private var _muteTransform : SoundTransform;
		private var _mute : Boolean = false;
		private var _playingSound : SoundChannel;
		private var _sound : Sound;
		
		public function Jukebox()
		{
			_volTransform = new SoundTransform(.3);
			_muteTransform = new SoundTransform(0);
		}
		
		public function play( level : Number ) : void
		{
			if(_playingSound != null)
				_playingSound.stop();
			
			switch(level)
			{
				case 0:
					_sound = new mainmenu();
					break;
				case 1:
					_sound = new level1();
					break;
				case 2:
					_sound = new level2();
					break;
				case 3:
					_sound = new level3();
					break;
				case 4:
					_sound = new win();
				case 5:
					_sound = new credits();
					break;
				case 6:
					_sound = new warmup();
					break;
			}
			
			startMusic();
			
		}
		
		public function set mute( val : Boolean ) : void
		{
			_mute = val;
			_playingSound.soundTransform = (mute) ? _muteTransform : _volTransform;
		}
		
		public function get mute() : Boolean
		{
			return _mute;
		}
		
		private function startMusic(e:Event = null) : void
		{
			_playingSound = _sound.play();
			_playingSound.soundTransform = (mute) ? _muteTransform : _volTransform;
			
			_playingSound.addEventListener(Event.SOUND_COMPLETE, startMusic);
		}
	}

}