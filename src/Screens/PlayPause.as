/**
 * @author mikelownds
 */
package Screens 
{
	
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
		
	public class PlayPause extends MovieClip
	{
		
		private var _muteButton : BTN_MUSICNOTE;
		private var _playButton : BTN_MUSICNOTE;
		private var _mute : Boolean;
		
		public function PlayPause(mute : Boolean = false) 
		{
			_mute = mute;
			
			_muteButton = new BTN_MUSICNOTE();
			_playButton = new BTN_MUSICNOTE();
			addChild(_muteButton);
			addChild(_playButton);
			_muteButton.filters = [new ColorMatrixFilter([0.212671, 0.715160, 0.072169, 0, 0,  0.212671, 0.715160, 0.072169, 0, 0,  0.212671, 0.715160, 0.072169, 0, 0,  0, 0, 0, 1, 0])];
			_playButton.visible = !_mute;
			_muteButton.visible = _mute;
		}
		
		public function set mute(mute : Boolean) : void
		{
			_mute = mute;
			
			_playButton.visible = !_mute;
			_muteButton.visible = _mute;
		}
	}

}