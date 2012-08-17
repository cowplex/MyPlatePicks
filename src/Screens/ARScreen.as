/**
 * @author mikelownds
 */
package Screens
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
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
	
	public class ARScreen extends MovieClip
	{
		
		private var _detectorTarget : MovieClip;
		private var _arFound : Boolean = false;
		
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
			_detectorTarget = new AR_detection();
			_detectorTarget.x = 210;
			_detectorTarget.y = 160;
			addChild(_detectorTarget);
			
			setup3D();
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
			
			var cube1:Cube = new Cube(ml,30,30,30);
			var cube2:Cube = new Cube(ml,30,30,30);
			cube2.z = 50;
			var cube3:Cube = new Cube(ml,30,30,30);
			cube3.z = 100;
			
			container.addChild(cube1);
			container.addChild(cube2);
			container.addChild(cube3);
			
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
				//vp.x = 210;
				//vp.y = 160;
			}
			
			if(found)
				vp.visible = true;
			else
				vp.visible = false;
			
			return vp.visible;
		}
		
		public function renderMarker( trans : FLARTransMatResult ) : void
		{
			container.setTransformMatrix(trans);
			bre.renderScene(scene, camera, vp);
		}
	}

}