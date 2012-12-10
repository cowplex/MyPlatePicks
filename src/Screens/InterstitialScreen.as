/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.events.Event;
	
	public class InterstitialScreen extends MovieClip
	{
		[Embed(systemFont="Baskerville", fontName="Baskerville", fontWeight="bold", mimeType = "application/x-font")] private var font:Class;
		[Embed(source="../HouseSampler-HouseSlant.ttf", fontName="titleFont", fontWeight="normal", mimeType = "application/x-font")] private var font2:Class;
		
		{
		/*
		[Embed(source="assets/Narrations/Interstitial_clear_and_dark_sodas_have_sugar_which_is_not_good_for_you.mp3")] public var Interstitial_clear_and_dark_sodas_have_sugar_which_is_not_good_for_you:Class;
		[Embed(source="assets/Narrations/Interstitial_when_going_out_to_eat_skip_supersized_options_filled_with_lots_of_sugar_and_fat.mp3")] public var Interstitial_when_going_out_to_eat_skip_supersized_options_filled_with_lots_of_sugar_and_fat:Class;
		[Embed(source="assets/Narrations/Intestitial_exercising_is_also_good_for_your_brain_and_can_help_you_focus_better_in_school.mp3")] public var Intestitial_exercising_is_also_good_for_your_brain_and_can_help_you_focus_better_in_school:Class;
		[Embed(source="assets/Narrations/Intestitial_fruits_and_vegetables_are_plants_that_make_their_own_sugar_for_plants_to_grow.mp3")] public var Intestitial_fruits_and_vegetables_are_plants_that_make_their_own_sugar_for_plants_to_grow:Class;
		*/
		/*
		[Embed(source="assets/New_Narrations/R1 I1.mp3")] public var R1I1:Class;
		[Embed(source="assets/New_Narrations/R1 I2.mp3")] public var R1I2:Class;
		[Embed(source="assets/New_Narrations/R1 I3.mp3")] public var R1I3:Class;
		[Embed(source="assets/New_Narrations/R1 I4.mp3")] public var R1I4:Class;
		*/
		
		[Embed(source="assets/Interstitial_Narrations/R1 I1 A.mp3")] public var R1I1A:Class;
		[Embed(source="assets/Interstitial_Narrations/R1 I1 B.mp3")] public var R1I1B:Class;
		[Embed(source="assets/Interstitial_Narrations/R1 I1 C.mp3")] public var R1I1C:Class;
		
		[Embed(source="assets/Interstitial_Narrations/R1 I2 A.mp3")] public var R1I2A:Class;
		[Embed(source="assets/Interstitial_Narrations/R1 I2 B.mp3")] public var R1I2B:Class;
		[Embed(source="assets/Interstitial_Narrations/R1 I2 C.mp3")] public var R1I2C:Class;
		[Embed(source="assets/Interstitial_Narrations/R1 I2 D.mp3")] public var R1I2D:Class;
		
		[Embed(source="assets/Interstitial_Narrations/R1 I3 A.mp3")] public var R1I3A:Class;
		[Embed(source="assets/Interstitial_Narrations/R1 I3 B.mp3")] public var R1I3B:Class;
		
		[Embed(source="assets/Interstitial_Narrations/R1 I4 A.mp3")] public var R1I4A:Class;
		[Embed(source="assets/Interstitial_Narrations/R1 I4 B.mp3")] public var R1I4B:Class;
		
		
		[Embed(source="assets/Interstitial_Narrations/R2 I1 A.mp3")] public var R2I1A:Class;
		[Embed(source="assets/Interstitial_Narrations/R2 I1 B.mp3")] public var R2I1B:Class;
		[Embed(source="assets/Interstitial_Narrations/R2 I1 C .mp3")] public var R2I1C:Class;
		
		[Embed(source="assets/Interstitial_Narrations/R2 I2 A.mp3")] public var R2I2A:Class;
		[Embed(source="assets/Interstitial_Narrations/R2 I2 B.mp3")] public var R2I2B:Class;
		[Embed(source="assets/Interstitial_Narrations/R2 I2 C.mp3")] public var R2I2C:Class;
		
		[Embed(source="assets/Interstitial_Narrations/R2 I3 A.mp3")] public var R2I3A:Class;
		[Embed(source="assets/Interstitial_Narrations/R2 I3 B.mp3")] public var R2I3B:Class;
		
		[Embed(source="assets/Interstitial_Narrations/R2 I4 A.mp3")] public var R2I4A:Class;
		[Embed(source="assets/Interstitial_Narrations/R2 I4 B.mp3")] public var R2I4B:Class;
		[Embed(source="assets/Interstitial_Narrations/R2 I4 C.mp3")] public var R2I4C:Class;
		
		
		[Embed(source="assets/Interstitial_Narrations/R3 I1 A .mp3")] public var R3I1A:Class;
		[Embed(source="assets/Interstitial_Narrations/R3 I1 B.mp3")] public var R3I1B:Class;
		[Embed(source="assets/Interstitial_Narrations/R3 I1 C.mp3")] public var R3I1C:Class;
		
		[Embed(source="assets/Interstitial_Narrations/R3 I2 A.mp3")] public var R3I2A:Class;
		[Embed(source="assets/Interstitial_Narrations/R3 I2 B.mp3")] public var R3I2B:Class;
		
		[Embed(source="assets/Interstitial_Narrations/R3 I3 A.mp3")] public var R3I3A:Class;
		[Embed(source="assets/Interstitial_Narrations/R3 I3 B.mp3")] public var R3I3B:Class;
		
		[Embed(source="assets/Interstitial_Narrations/R3 I4 A.mp3")] public var R3I4A:Class;
		[Embed(source="assets/Interstitial_Narrations/R3 I4 B.mp3")] public var R3I4B:Class;
		}
		
		private var _callback : Function;
		private var _timer : Timer;
		
		private var _background : MovieClip;
		private var _backgroundList : Array = new Array(
			new BG_plate(),
			new BG_proportions(),
			new BG_water(),
			new BG_activity()
		)
		private var _activeBG : MovieClip;
		
		private var _facts : Array;
		private var _titles : Array;
		private var _narrations : Array;
		
		private var _narrationPlace : Number = 0;
		private var _playingSound : SoundChannel;
		
		private var _currentKC : Number;
		private var _currentLevel : Number;
		
		private var _textField    : TextField;
		private var _format       : TextFormat;
		
		private var _title        : TextField;
		private var _titleFormat  : TextFormat;
		
		private var _whiteBG : MovieClip;
		
		private function setupFacts() : void
		{
			/*_facts = new Array
			(
				new Array
				(
					"Fruits and vegetables are plants that make their own sugar from the sun to grow. Those natural sugars are sweet, taste good, and help you grow too. Next time you crave something sweet; grab a juicy fruit or vegetable.",
					"Think of fiber as a broom that keeps your digestive system clean. Fiber helps our bodies take out the trash. Fill half your plate with fruits and vegetables to make sure you get enough fiber.",
					"Fruits and veggies keep you healthy and energized. They even help us fight diseases like cancer with their antioxidant power. Be sure to eat 5 fruits and vegetables each day!"
				),
				new Array
				(
					"When going out to eat skip super-sized options filled with lots of sugar and fat. Also try to cut portions in half and save some for later.",
					"It’s easy to over eat grains so let’s take a look at a few of the right portion sizes!\n1 slice of whole grain bread\n1 pancake\n1 cup cereal\n½ cup brown rice\nTry measuring your food the next time you eat!",
					"Overeating can make us feel too tired to do anything including exercise. Feeling like this too often can make us an unhealthy weight. To eat the right amount, take your time while you eat!"
				),
				new Array
				(
					"Clear and dark sodas have sugar, which is not good for you.  Drink low-fat milk to help build your bones instead of sugary beverages that destroy your bones.",
					"Low-fat dairy products, like fat-free milk and low-fat cheese, help to build strong bones and teeth because they have calcium and vitamin D. Because you want strong bones and teeth, drink low-fat or fat-free milk with cereal and at dinner!",
					"Water hydrates (or replenishes your body’s need for water) better than sports drinks. Sports drinks are only for professional athletes who are exercising very hard all day. Even with a lot of physical activity, grab some water instead of a sports drink."
				),
				new Array
				(
					"Exercising is also good for your brain and can help you focus better in school. Try to get at least 1 hour every day!",
					"When you are done exercising, it is always a good idea to stretch. That way you can keep your muscles flexible and not hurt yourself. See if you can touch your toes while standing. Keep practicing to see how far you can reach!",
					"Next time you watch TV, exercise during the commercial breaks, like jumping-jacks, push-ups, sit-ups, and squats."
				)
			);*/
			/*_facts = new Array
			(
				new Array
				(
					"Fruits and vegetables are plants that make their own sugar from the sun to grow. Those natural sugars are:\n• Sweet\n• Taste good\n• And help you grow",
					"Be sure to fill your plate with plenty of fruits and vegetables because:\n•Our bodies need a lot of fiber\n•Fiber helps clean out our digestive systems",
					"You should eat 5 fruits and veggies each day because they:\n• Keep you healthy and energized\n•Help us fight diseases like cancer with their antioxidant power."
				),
				new Array
				(
					"In order to maintain a healthy diet:\n•Skip super-sized meals filled with lots of sugar and fat\n•Try to cut portions in half\n•Save some room for later",
					"It’s easy to over eat grains so let’s take a look at a few of the right portion sizes!\n\n•1 slice of whole grain bread\n•1 pancake\n•1 cup cereal\n•½ cup brown rice\n\nTry measuring your food the next time you eat!",
					"Overeating can make us:\n•Too tired to do anything including exercise.\n•Reach an unhealthy weight.\nTo eat the right amount, take your time while you eat!"
				),
				new Array
				(
					"Drink low-fat milk to help build your bones instead of soda:\n•Which is not good for you\n•And destroys your bones",
					"Low-fat dairy products, like fat-free milk and low-fat cheese, have calcium and vitamin D.  These will help you build:\n•Strong bones\n•Strong teeth",
					"Water is better than sports drinks because:\n•It hydrates your body\n•Sports drinks are only for professional athletes who are exercising very hard all day\n•Even with a lot of physical activity, grab some water instead of a sports drink."
				),
				new Array
				(
					"Exercising at least 1 hour every day:\n•Is good for your brain\n• Helps you focus better in school",
					"When you are done exercising, it is always a good idea to stretch because:\n•It will keep your muscles flexible\n•It will help you avoid hurting yourself\nSee if you can touch your toes while standing. Keep practicing to see how far you can reach!",
					"Next time you watch TV, exercise during the commercial breaks by trying:\n•Jumping-jacks\n•Push-ups\n•Sit-ups\n•Squats"
				)
			);*/
			/*_facts = new Array
			(
				new Array
				(
					new Interstitial_01(),
					new Interstitial_02(),
					new Interstitial_03()
				),
				new Array
				(
					new Interstitial_11(),
					new Interstitial_12(),
					new Interstitial_13()
				),
				new Array
				(
					new Interstitial_21(),
					new Interstitial_22(),
					new Interstitial_23()
				),
				new Array
				(
					new Interstitial_31(),
					new Interstitial_32(),
					new Interstitial_33()
				)
			);*/
			_facts = new Array
			(
				new FV_BG(),
				new OP_BG(),
				new SD_BG(),
				new PA_BG()
			);
			/*_titles = new Array(
				"Make Half Your Plate Fruits and Vegetables",
				"Avoid Oversized Portions",
				"Drink Water Instead of Sugary Beverages",
				"Get 60 Minutes of Physical Activity a Day"
			);*/
			_narrations = new Array(
				new Array(
					new Array( new R1I1A(), new R1I1B(), new R1I1C() ),
					new Array( new R2I1A(), new R2I1B(), new R2I1C() ),
					new Array( new R3I1A(), new R3I1B(), new R3I1C() )
				),
				new Array(
					new Array( new R1I2A(), new R1I2B(), new R1I2C(), new R1I2D() ),
					new Array( new R2I2A(), new R2I2B(), new R2I2C() ),
					new Array( new R3I2A(), new R3I2B() )
				),
				new Array(
					new Array( new R1I3A(), new R1I3B() ),
					new Array( new R2I3A(), new R2I3B() ),
					new Array( new R3I3A(), new R3I3B() )
				),
				new Array(
					new Array( new R1I4A(), new R1I4B() ),
					new Array( new R2I4A(), new R2I4B(), new R2I4C() ),
					new Array( new R3I4A(), new R3I4B() )
				)
			)
		}
		
		public function InterstitialScreen()
		{
			setupFacts();
			
			/*_background = new MovieClip();//new BG_interstitialscreens();
			_background.x = 640/2;//_background.width/2;
			_background.y = 480/2;//_background.height/2;
			addChild(_background);
			
			_whiteBG = new MovieClip();
			addChild(_whiteBG);
			
			_titleFormat = new TextFormat();
			_titleFormat.font = "titleFont";
			_titleFormat.size = 32;
			_titleFormat.align = TextFormatAlign.CENTER;
			
			_title = new TextField;
			_title.embedFonts = true;
			_title.defaultTextFormat = _titleFormat;
			_title.autoSize = "center";
			_title.width = 500;
			_title.y     = 50;
			_title.x     = 320;
			
			addChild(_title);
			
			_format = new TextFormat();
			_format.size = 35;//25;
			_format.align = TextFormatAlign.CENTER;
			_format.font = "Baskerville";
			
			_textField = new TextField();
			_textField.multiline = true;
			//_textField.embedFonts = true;
			//_textField.defaultTextFormat = _format;
			
			_textField.wordWrap = true;
			_textField.autoSize = "left";
			_textField.width = 500;
			_textField.y     = 160; //120;
			_textField.x     = 70; //120;
			
			addChild(_textField);*/
			
			
			//_timer = new Timer(10 * 1500, 1);
			//_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCallback);
		}
		
		public function set callback(f : Function) : void
		{
			_callback = f;
		}
		
		public function show( level : Number, KC : Number ) : void
		{
			level--;
			
			/*_activeBG = KC;
			_background.addChild(_backgroundList[_activeBG]);
			
			_textField.text = _facts[KC][level];//[int(Math.random() * _facts[KC].length)];
			_title.text = _titles[KC];
			
			_whiteBG.graphics.clear();
			_whiteBG.graphics.beginFill(0xFFFFFF);//, 0.6);
			_whiteBG.graphics.drawRoundRect(_title.x - 10, _title.y - 10, _title.width + 20, _textField.y + _textField.height - _title.y + 20, 15);
			//_whiteBG.graphics.drawRoundRect(-500, 0, 250, 250, 15);
			_whiteBG.graphics.endFill();*/
			
			addChild(_facts[KC]/*[level]*/);
			_activeBG = _facts[KC]/*[level]*/;
			
			switch(level)
			{
				case 0:
					_activeBG.gotoAndStop("r1");
					break;
				case 1:
					_activeBG.gotoAndStop("r2");
					break;
				case 2:
					_activeBG.gotoAndStop("r3");
					break;
				default:
					break;
			}
			
			/*
			if(level == 0)
				_narrations[KC][level].play();
			*/
			
			_currentKC = KC;
			_currentLevel = level;
			_narrationPlace = 0;
			playDialogue();
			
			//_timer.reset();
			//_timer.start();
		}
		
		private function playDialogue(e:Event = null) : void
		{
			if(_narrationPlace < _narrations[_currentKC][_currentLevel].length)
			{
				_playingSound = _narrations[_currentKC][_currentLevel][_narrationPlace].play();
				_playingSound.addEventListener(Event.SOUND_COMPLETE, playDialogue);
				_activeBG.play();
			}
			else
			{
				timerCallback();
			}
			_narrationPlace++;
		}
		
		private function timerCallback(e:TimerEvent = null) : void
		{
			//_background.removeChild(_backgroundList[_activeBG]);
			removeChild(_activeBG);
			_callback();
		}
	}

}