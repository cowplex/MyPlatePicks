/**
 * @author mikelownds
 */
package Screens
{
	//import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Warmup extends MovieClip //Sprite
	{
		
		private static const _vidWidth : int = 420;
		
		public var hitTarget   : MovieClip = new warmup_marker();
		public var missTarget1 : MovieClip = new warmup_marker();
		public var missTarget2 : MovieClip = new warmup_marker();
		public var missTarget3 : MovieClip = new warmup_marker();
		
		private var detecting : Boolean = true;
		
		private var _hitCallback : Function;
		
		private var t : Timer;
		
		public function Warmup()
		{
			/*createTarget(hitTarget, true);
			createTarget(missTarget1, false);
			createTarget(missTarget2, false);
			createTarget(missTarget3, false);*/
			
			missTarget1.gotoAndStop(1);
			missTarget2.gotoAndStop(1);
			missTarget3.gotoAndStop(1);
			
			hitTarget.scaleX = missTarget1.scaleX = missTarget2.scaleX = missTarget3.scaleX = .5;
			hitTarget.scaleY = missTarget1.scaleY = missTarget2.scaleY = missTarget3.scaleY = .5;
			
			attach();
		}
		
		public function set hitCallback( callback : Function ) : void
		{
			_hitCallback = callback;
		}
		
		public function get detectionArea() : Rectangle
		{
			return(new Rectangle(hitTarget.x - hitTarget.width/2, hitTarget.y - hitTarget.height/2, hitTarget.width, hitTarget.height));
		}
		
		public function detectHit( motion : Rectangle ) : Boolean
		{
			/*if(detecting && motion.width * motion.height > 50
			                                     && motion.x >= (hitTarget.x - hitTarget.width/2) && motion.x <= (hitTarget.x + hitTarget.width/2)
			                                     && motion.y >= (hitTarget.y - hitTarget.height/2) && motion.y <= (hitTarget.y + hitTarget.height/2)
			  )*/
			if(detecting && motion.width * motion.height > 50 && detectionArea.intersects(motion))
			{
				reset();
				_hitCallback();
				return true;
			}
			return false;
		}
		
		private function createTarget(target : MovieClip/*Sprite*/, hit : Boolean) : void
		{
			//target = new Sprite();
			// define the line style
			target.graphics.lineStyle(2,0x000000);
			// define the fill
			if(hit)
				target.graphics.beginFill(0x996666);
			else
				target.graphics.beginFill(0x666699);
			//Draw the circle
			target.graphics.drawCircle(0, 0, 30);
			target.graphics.endFill();
		}
		
		private function attach() : void
		{
			var order : Array = new Array(0,1,2,3);
			var shuffle : Array = new Array(order.length);
			
			var i:int;
 
			var randomPos:Number = 0;
			for (i = 0; i < shuffle.length; i++)
			{
				randomPos = int(Math.random() * order.length);
				shuffle[i] = order.splice(randomPos, 1)[0];   //since splice() returns an Array, we have to specify that we want the first (only) element
			}
			
			i = shuffle.length - 1;
			place(hitTarget,   shuffle[0], i);
			place(missTarget1, shuffle[1], i);
			place(missTarget2, shuffle[2], i);
			place(missTarget3, shuffle[3], i);
		}
		private function attachTimer(e:TimerEvent) : void
		{
			detecting = true;
			attach();
		}
		
		private function place(target : MovieClip, position : Number, max : Number) : void
		{
			//target.x = 45 + (((_vidWidth - 45*2) / 3) * position);
			target.x = 15 + (((_vidWidth - 15*2) / 3) * position);
			target.y = (position == 0 || position == max) ? /*90*/ 130 : 25 /*45*/;
			target.rotation = (position == 0) ? 90 : ((position == max) ? -90 : 180 );
			addChild(target);
		}
		
		private function reset() : void
		{
			detecting = false;
			removeChild(hitTarget);
			removeChild(missTarget1);
			removeChild(missTarget2);
			removeChild(missTarget3);
			//attach();
			t = new Timer(500, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, attachTimer);
			t.start();
		}
	}
}