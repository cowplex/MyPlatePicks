/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class InterstitialScreen extends MovieClip
	{
		
		private var _callback : Function;
		private var _timer : Timer;
		
		private var _background : MovieClip;
		
		private var _facts : Array;
		
		private var _textField    : TextField;
		private var _format       : TextFormat;
		
		private function setupFacts() : void
		{
			_facts = new Array
			(
				new Array
				(
					"Fiber helps to keep us full and it helps our bodies to take out the trash. Think of fiber as a broom that keeps your digestive system clean.",
					"Fruits and vegetables are plants that make their own sugar from the sun to grow. Those natural sugars are sweet, taste good, and help you grow too.",
					"Fruits and veggies keep you healthy and energized. They even help us fight diseases like cancer with their antioxidant power."
				),
				new Array
				(
					"Check the nutrition facts label to see how many servings there are and if it says 2, share with a friend or save half for later.",
					"Water helps cool your body on a hot day; helps blood move throughout your body; helps your joints move; and breaks down food.",
					"Overeating can make us feel too tired to do anything including exercise. To eat the right amount, take your time while you eat!"
				),
				new Array
				(
					"Dehydration is a lack of fluid in your body. If you are thirsty, you could be dehydrated. Kids need about 6 cups of water every day.",
					"When eating out skip super-sized portions filled with lots of sugar and fat. Read nutrition labels for serving size and use your fist to help you figure out how much you should eat.",
					"Energy drinks give you “fake” energy that wears off quickly. When that happens, you will feel very tired."
				),
				new Array
				(
					"Exercising is also good for our brain. It helps us to feel happy and to be able to focus better in school.",
					"When watching TV, you can do exercises during the commercial breaks, like jumping jacks, push-ups, sit-ups, and squats",
					"When you’re walking, an easy way to raise your heart rate is by running, doing lunges, hopping, jumping or leaping!"
				)
			);	
		}
		
		public function InterstitialScreen()
		{
			setupFacts();
			
			_background = new BG_interstitialscreens();
			_background.x = _background.width/2;
			_background.y = _background.height/2;
			addChild(_background);
			
			
			_format = new TextFormat();
			_format.size = 15;
			_format.align = TextFormatAlign.CENTER;
			
			_textField = new TextField();
			_textField.defaultTextFormat = _format;
			
			_textField.wordWrap = true;
			_textField.autoSize = "center";
			_textField.width = 300;
			_textField.y     = 120;
			_textField.x     = 120;
			
			addChild(_textField);
			
			
			_timer = new Timer(10 * 1000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCallback);
		}
		
		public function set callback(f : Function) : void
		{
			_callback = f;
		}
		
		public function show( level : Number, KC : Number ) : void
		{
			_textField.text = _facts[KC][level];//[int(Math.random() * _facts[KC].length)];
			
			_timer.reset();
			_timer.start();
		}
		
		private function timerCallback(e:TimerEvent) : void
		{
			_callback();
		}
	}

}