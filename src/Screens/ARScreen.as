/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.geom.Rectangle;
	
	// Papervsion stuff
	import flash.utils.ByteArray;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.materials.MovieMaterial;
	
	public class ARScreen extends MovieClip
	{
		[Embed(systemFont="Baskerville", fontName="arFont", fontWeight="normal", mimeType = "application/x-font")] private var font:Class;
		
		private static const _vidWidth : int = 420;
		
		public var hitTarget   : MovieClip = new warmup_marker();
		
		private var _detectorTarget : MovieClip;
		private var _arFound : Boolean = false;
		
		private var _questions : Array;
		private var _artworks : Array;
		
		private var _questionDisplay : TextField;
		private var _textFormat : TextFormat = new TextFormat();
		
		private var _lastDisplayed : Plane = null;
		
		private var _hitTarget   : MovieClip = new warmup_marker();
		
		private var _callback : Function;
		
		// Papervsion stuff
		private var scene:Scene3D;
		private var camera:FLARCamera3D;
		private var container:FLARBaseNode;
		private var vp:Viewport3D;
		private var bre:BasicRenderEngine;
		//private var trans:FLARTransMatResult;
		
		[Embed(source="../AR/data/camera_para.dat", mimeType="application/octet-stream")]
		private var cameraParams : Class;
		
		public function ARScreen()
		{
			_questions = new Array(
				new Array(
					"I’m easy to eat any time of day – just peel down my yellow skin. What am I?",
					"One portion of lean protein would be:",
					"What beverage can you drink without worrying about too much sugar or more fuel than you need?",
					"Which type of exercise will help our muscles to stretch and relax?"
				),
				new Array(
					"Fruits and vegetables are juicy because they contain lots of",
					"Which of the following is not the correct portion size?",
					"Soda is most like?",
					"All exercise helps us to grow stronger but only _______ exercises build strong bones."
				),
				new Array(
					"I’m a fruit in the red color group and my seeds are on the outside. What am I?",
					"How long does it take your brain to know your stomach is full?",
					"Which of the following drinks are healthiest for your body?",
					"What kind of physical activity do you do every day?"
				)
			);
			
			_artworks = new Array(
				new Array(
					new MovieMaterial(new AR_BANANA_ANIMATED(), true, false, true),
					new MovieMaterial(new AR_CHICKEN(), true, false, true),
					new MovieMaterial(new AR_WATER_ANIMATED(), true, false, true),
					new MovieMaterial(new AR_YOGA_ANIMATED(), true, false, true) // new
				),
				new Array(
					new MovieMaterial(new AR_WATER(), true, false, true),
					new MovieMaterial(new AR_RICE(), true, false, true),
					new MovieMaterial(new AR_CANDYBAR(), true, false, true),
					new MovieMaterial(new AR_WEIGHT(), true, false, true)
				),
				new Array(
					new MovieMaterial(new AR_STRAWBERRY(), true, false, true),
					new MovieMaterial(new AR_20MIN(), true, false, true),
					new MovieMaterial(new AR_BANANA_ANIMATED(), true, false, true), //new
					new MovieMaterial(new AR_WALKING(), true, false, true)
				)
			);
			
			_textFormat.size = 15;
			_textFormat.font = "arFont";
			
			_questionDisplay = new TextField();
			_questionDisplay.defaultTextFormat = _textFormat;
			//_questionDisplay.text = question;
			_questionDisplay.x = 265 - 164 - 59;
			_questionDisplay.y = 25 - 90;
			_questionDisplay.width = 260;
			_questionDisplay.height = 70;
			_questionDisplay.wordWrap = true;
			_questionDisplay.text = "Find the corresponding AR marker in the Pickup Pile:";
			addChild(_questionDisplay);
			
			_detectorTarget = new AR_detection();
			_detectorTarget.x = 210;
			_detectorTarget.y = 160;
			//addChild(_detectorTarget);
			
			_hitTarget.scaleX = _hitTarget.scaleY = .5;
			
			setup3D();
		}
		
		public function set callback(f:Function) : void
		{
			_callback = f;
		}
		
		private function setup3D() : void
		{
			scene = new Scene3D();
			
			var fparams : FLARParam = new FLARParam();
			fparams.loadARParam(new cameraParams() as ByteArray);
			camera = new FLARCamera3D(fparams);
			
			container = new FLARBaseNode();
			scene.addChild(container);
			
			var pl:PointLight3D = new PointLight3D();
			pl.x = 1000;
			pl.y = 1000;
			pl.z = -1000;
			
			var ml:MaterialsList = new MaterialsList({all: new FlatShadeMaterial(pl)});
			/*
			var cube1:Cube = new Cube(ml,30,30,30);
			var cube2:Cube = new Cube(ml,30,30,30);
			cube2.z = 50;
			var cube3:Cube = new Cube(ml,30,30,30);
			cube3.z = 100;
			
			container.addChild(cube1);
			container.addChild(cube2);
			container.addChild(cube3);
			*/
			/*var movie : MovieClip = new AR_WEIGHT();
			
			var material :MovieMaterial;
			var object   :Plane;
			
			material             = new MovieMaterial(movie, true, false, true);
			//material.doubleSided = true;
			//material.interactive = true;
			
			object = new Plane(material);
			container.addChild(object);*/
			
			var i : int;
			var j : int;
			for(i=0; i < _artworks.length; i++)
			{
				for(j=0; j < _artworks[i].length; j++)
				{
					_artworks[i][j].doubleSided = true;
					_artworks[i][j] = new Plane(_artworks[i][j]);
				}
			}
			
			bre = new BasicRenderEngine();
			//trans = new FLARTransMatResult();
			
			vp = new Viewport3D(420, 320);
		}
		
		public function detectAR( found : Boolean ) : Boolean
		{
			if(found && !_arFound)
			{
				_arFound = true;
				
				removeChild(_detectorTarget);
				
				this.addChild(vp);
				
				var position : int = int(Math.random() * 4);
				_hitTarget.x = 15 + (((_vidWidth - 15*2) / 3) * position);
				_hitTarget.y = (position == 0 || position == 3) ? /*90*/ 130 : 25 /*45*/;
				_hitTarget.rotation = (position == 0) ? 90 : ((position == 3) ? -90 : 180 );
				addChild(_hitTarget);
				
				//_callback();
				//vp.x = 210;
				//vp.y = 160;
			}
			
			if(found)
				vp.visible = true;
			else
				vp.visible = false;
			
			var x : int = (_lastDisplayed.x - _hitTarget.x) < 0 ? -(_lastDisplayed.x - _hitTarget.x) : (_lastDisplayed.x - _hitTarget.x);
			var y : int = (_lastDisplayed.y - _hitTarget.y) < 0 ? -(_lastDisplayed.y - _hitTarget.y) : (_lastDisplayed.y - _hitTarget.y);
			
			if(found && x < 200 && y < 200)
			{
				removeChild(_hitTarget);
				_callback();
			}
			
			return vp.visible;
		}
		
		public function renderMarker( trans : FLARTransMatResult ) : void
		{
			container.setTransformMatrix(trans);
			container.x += 120;
			container.scaleX = container.scaleY = .5;
			//container.rotation += 90;
			bre.renderScene(scene, camera, vp);
		}
		
		public function question(level : Number, KC : Number) : void
		{
			level--;
			//_questionDisplay.text = _questions[level][KC];

			if(_lastDisplayed != null)
				container.removeChild(_lastDisplayed);
			
			if(_arFound)
			{
				_arFound = false;
				addChild(_detectorTarget);
				removeChild(vp);
			}
			
			container.addChild(_artworks[level][KC]);
			_lastDisplayed = _artworks[level][KC];
		}
		
		
		public function randomize() : void
		{
			var position : Number = int(Math.random() * 4);
			//target.x = 45 + (((_vidWidth - 45*2) / 3) * position);
			hitTarget.x = 15 + (((_vidWidth - 15*2) / 3) * position);
			hitTarget.y = (position == 0 || position == 3) ? /*90*/ 130 : 25 /*45*/;
			hitTarget.rotation = (position == 0) ? 90 : ((position == 3) ? -90 : 180 );
			addChild(hitTarget);
			
			_questionDisplay.text = "";
			switch(position)
			{
				case 0:
					_questionDisplay.appendText("Lunge left ");
					break;
				case 1:
					_questionDisplay.appendText("Jump left ");
					break;
				case 2:
					_questionDisplay.appendText("Jump right ");
					break;
				case 3:
					_questionDisplay.appendText("Lunge right ");
					break;
			}
			_questionDisplay.appendText("to touch the glowing marker!");
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
			if(motion.width * motion.height > 50 && detectionArea.intersects(motion))
			{
				//reset();
				//_callback(true);
				removeChild(hitTarget);
				randomize();
				return true;
			}
			return false;
		}
	}

}