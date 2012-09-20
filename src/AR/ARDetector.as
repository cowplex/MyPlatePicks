/**
 * @author mikelownds
 */
package AR
{
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
//	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
//	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;
	
	public class ARDetector
	{
		
		// Data imports
		{
		[Embed(source="data/camera_para.dat", mimeType="application/octet-stream")]
		private var cameraParams : Class;
		[Embed(source="patterns/weightbearing32.pat", mimeType="application/octet-stream")] private var weightbearing32 : Class;
		[Embed(source="patterns/banana32.pat", mimeType="application/octet-stream")] private var banana32 : Class;
		[Embed(source="patterns/water32.pat", mimeType="application/octet-stream")] private var water32 : Class;
		[Embed(source="patterns/yoga32.pat", mimeType="application/octet-stream")] private var yoga32 : Class;
		}
		
		private var _patterns : Array = new Array(
			new Array(
				new banana32(),
				new weightbearing32(),
				new weightbearing32()
			),
			new Array(
				new weightbearing32(),
				new weightbearing32(),
				new weightbearing32()
			),
			new Array(
				new water32(),
				new weightbearing32(),
				new weightbearing32()
			),
			new Array(
				new yoga32(),
				new weightbearing32(),
				new weightbearing32()
			)
		);
		
		private var _FLARparams  : FLARParam;
		private var _arPattern   : FLARCode;
		
		//private var _bitmap      : BitmapData;
		private var _raster      : FLARRgbRaster_BitmapData;
		
		private var _detector    : FLARSingleMarkerDetector;
//		private var _container   : FLARBaseNode;
		private var _transMatrix : FLARTransMatResult;
		
		public function ARDetector()
		{
			_FLARparams = new FLARParam();
			_FLARparams.loadARParam(new cameraParams() as ByteArray);
			
			/*_arPattern = new FLARCode(32, 32);//(16, 16);
			_arPattern.loadARPatt(new pattern());
			
			_detector = new FLARSingleMarkerDetector(_FLARparams, _arPattern, 80);*/
		}
		
		public function setupMarker(level : Number, KC : Number) : void
		{
			level--;
			
			_arPattern = new FLARCode(32, 32);//(16, 16);
			_arPattern.loadARPatt(_patterns[KC][level]);
			
			_detector = new FLARSingleMarkerDetector(_FLARparams, _arPattern, 80);
		}
		
		public function track( bitmap : BitmapData ) : Boolean
		{
			_raster = new FLARRgbRaster_BitmapData(bitmap);
			return (_detector.detectMarkerLite(_raster, 80) && _detector.getConfidence() > 0.5)
		}
		public function getTransformMatrix() : FLARTransMatResult
		{
			return _detector.getTransformMatrix();
		}
	}

}