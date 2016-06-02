/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	
	public class Level extends MovieClip
	{
		private var _numKnowledgeCategories : Number = 4;
		
		private var _levels : Array;
		private var _textLevel1 : MovieClip = new round_1();
		private var _textLevel2 : MovieClip = new round_2();
		private var _textLevel3 : MovieClip = new round_3();
		//private var _textLevel1 : MovieClip = new round1();
		//private var _textLevel2 : MovieClip = new round2();
		//private var _textLevel3 : MovieClip = new round3();
		
		private var _level : int;
		private var _knowledgeCategory : int = 0;
		private var _leveled_up : Boolean  = false;
		
		public function Level()
		{
			addChild(_textLevel1);
			addChild(_textLevel2);
			addChild(_textLevel3);
			
			//_textLevel3.gotoAndStop(3); //HACK, FIXME
			
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
		
		public function get numKnowledgeCategories() : Number
		{
			return _numKnowledgeCategories;
		}
		public function get knowledgeCategory() : Number
		{
			return _knowledgeCategory;
		}
		public function set knowledgeCategory(kc : Number) : void
		{
			_knowledgeCategory = kc;
			
			if(_knowledgeCategory >= _numKnowledgeCategories)
			{
				_knowledgeCategory = 0;
				level++;
				_leveled_up = true;
			}
		}
		
		public function get leveled_up() : Boolean
		{
			var return_val : Boolean = _leveled_up;
			_leveled_up = false;
			return return_val;
		}
	}

}