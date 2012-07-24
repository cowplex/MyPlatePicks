/**
 * @author mikelownds
 */
package Screens
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Warmup extends Sprite
	{
		
		private static const _vidWidth : int = 420;
		
		public var hitTarget   : Sprite = new Sprite();
		public var missTarget1 : Sprite = new Sprite();
		public var missTarget2 : Sprite = new Sprite();
		public var missTarget3 : Sprite = new Sprite();
		
		private var detecting : Boolean = true;
		
		private var t : Timer;
		
		public function Warmup()
		{
			createTarget(hitTarget, true);
			createTarget(missTarget1, false);
			createTarget(missTarget2, false);
			createTarget(missTarget3, false);
			attach();
		}
		
		public function get detectionArea() : Rectangle
		{
			return(new Rectangle(hitTarget.x - hitTarget.width/2, hitTarget.y - hitTarget.height/2, hitTarget.width, hitTarget.height));
		}
		
		public function detectHit( motion : Rectangle ) : void
		{
			trace(motion);
			if(detecting && motion.width * motion.height > 50
			                                     && motion.x >= (hitTarget.x - hitTarget.width/2) && motion.x <= (hitTarget.x + hitTarget.width/2)
			                                     && motion.y >= (hitTarget.y - hitTarget.height/2) && motion.y <= (hitTarget.y + hitTarget.height/2)
			  )
			{
				reset();
			}
		}
		
		private function createTarget(target : Sprite, hit : Boolean) : void
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
 
			var randomPos:Number = 0;
			for (var i:int = 0; i < shuffle.length; i++)
			{
				randomPos = int(Math.random() * order.length);
				shuffle[i] = order.splice(randomPos, 1)[0];   //since splice() returns an Array, we have to specify that we want the first (only) element
			}
						
			place(hitTarget,   shuffle[0]);
			place(missTarget1, shuffle[1]);
			place(missTarget2, shuffle[2]);
			place(missTarget3, shuffle[3]);
		}
		private function attachTimer(e:TimerEvent) : void
		{
			trace("attaching timer");
			detecting = true;
			attach();
		}
		
		private function place(target : Sprite, position : Number) : void
		{
			target.x = 45 + (((_vidWidth - 45*2) / 3) * position);
			target.y = 45;
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