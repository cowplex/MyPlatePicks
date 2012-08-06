/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	
	public class Level extends MovieClip
	{
		
		private var _levels : Array;
		private var _textLevel1 : level_1;
		private var _textLevel2 : level_2;
		private var _textLevel3 : level_3;
		
		private var _level : int;
		private var _knowledgeCategory : int;
		
		public function Level()
		{
			_textLevel1 = new level_1();
			_textLevel2 = new level_2();
			_textLevel3 = new level_3();
			
			addChild(_textLevel1);
			addChild(_textLevel2);
			addChild(_textLevel3);
			
			_levels = new Array(_textLevel1, _textLevel2, _textLevel3);
			
			level = 0;
		}
		
		public function get level() : int
		{
			return _level;
		}
		public function set level(level : int) : void
		{
			_level = level;
			
			// Set Correct Level Text
			for(var i:int = 0; i < _levels.length; i++)
			{
				_levels[i].visible = false;
			}
			if(level > 0 && level <= _levels.length)
				_levels[level - 1].visible = true;
		}
	}

}