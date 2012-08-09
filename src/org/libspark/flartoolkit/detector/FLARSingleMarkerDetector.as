/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */
package org.libspark.flartoolkit.detector
{
	import flash.display.*;
	import jp.nyatla.nyartoolkit.as3.core.match.*;
	import jp.nyatla.nyartoolkit.as3.core.pickup.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.core.transmat.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterreader.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2bin.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2bin.*;
	import org.libspark.flartoolkit.core.squaredetect.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.transmat.*;
	public class FLARSingleMarkerDetector
	{	
		private var _is_continue:Boolean = false;
		private var _square_detect:FLARSquareContourDetector;
		protected var _transmat:INyARTransMat;
		private var _bin_raster:FLARBinRaster;
		protected var _tobin_filter:INyARRasterFilter_Rgb2Bin;
		private var _detect_cb:SingleDetectSquareCB;
		private var _offset:NyARRectOffset; 


		public function FLARSingleMarkerDetector(i_ref_param:FLARParam,i_ref_code:FLARCode,i_marker_width:Number)
		{
			var th:INyARRasterFilter_Rgb2Bin=new FLARRasterFilter_Threshold(100);
			var patt_inst:NyARColorPatt_Perspective_O2;
			var sqdetect_inst:FLARSquareContourDetector;
			var transmat_inst:INyARTransMat;
			
			var markerWidthByDec:Number = (100 - i_ref_code.markerPercentWidth) / 2;
			var markerHeightByDec:Number = (100 - i_ref_code.markerPercentHeight) / 2;


			patt_inst = new NyARColorPatt_Perspective_O2(i_ref_code.getWidth(), i_ref_code.getHeight(), 4, markerWidthByDec);
			patt_inst.setEdgeSizeByPercent(markerWidthByDec, markerHeightByDec, 4);
//			trace('w:'+markerWidthByDec+'/h:'+markerHeightByDec);

			sqdetect_inst=new FLARSquareContourDetector(i_ref_param.getScreenSize());
			transmat_inst=new NyARTransMat(i_ref_param);
			initInstance(patt_inst,sqdetect_inst,transmat_inst,th,i_ref_param,i_ref_code,i_marker_width);
			return;
		}
		protected function initInstance(
			i_patt_inst:INyARColorPatt,
			i_sqdetect_inst:FLARSquareContourDetector,
			i_transmat_inst:INyARTransMat,
			i_filter:INyARRasterFilter_Rgb2Bin,
			i_ref_param:FLARParam,
			i_ref_code:FLARCode,
			i_marker_width:Number):void
		{
			var scr_size:NyARIntSize=i_ref_param.getScreenSize();
			this._square_detect = i_sqdetect_inst;
			this._transmat = i_transmat_inst;
			this._tobin_filter=i_filter;
			this._bin_raster=new FLARBinRaster(scr_size.w,scr_size.h);
			//_detect_cb
			this._detect_cb=new SingleDetectSquareCB(i_patt_inst,i_ref_code,i_ref_param);
			
			this._offset=new NyARRectOffset();
			this._offset.setSquare(i_marker_width);
			return;
			
		}
		
		/**
		 * i_image
		 * 
		 * @param i_raster

		 * @throws NyARException
		 */
		public function detectMarkerLite(i_raster:FLARRgbRaster_BitmapData,i_threshold:int):Boolean
		{
			FLARRasterFilter_Threshold(this._tobin_filter).setThreshold(i_threshold);
			if(!this._bin_raster.getSize().isEqualSize_NyARIntSize(i_raster.getSize())){
				throw new FLARException();
			}

			this._tobin_filter.doFilter(i_raster,this._bin_raster);

			this._detect_cb.init(i_raster);
			this._square_detect.detectMarkerCB(this._bin_raster,_detect_cb);
			if(this._detect_cb.confidence==0){
				return false;
			}
			return true;
		}
		/**
		 * 
		 * @param o_result
		 * @throws NyARException
		 */
		public function getTransformMatrix(o_result:FLARTransMatResult):void
		{
			if (this._is_continue) {
				this._transmat.transMatContinue(this._detect_cb.square,this._offset, o_result);
			} else {
				this._transmat.transMat(this._detect_cb.square,this._offset, o_result);
			}
			return;
		}
		/**
		 * 
		 * @throws NyARException
		 */
		public function getConfidence():Number
		{
			return this._detect_cb.confidence;
		}
		
		/**
		 * 
		 * @return Returns whether any of 0,1,2,3.
		 */
		public function getDirection():int
		{
			return this._detect_cb.direction;
		}
		
		/**
		 * @return Total return detected FLARSquare 1. Detection Dekinakattara null.
		 */
		public function getSquare():NyARSquare
		{
			return this._detect_cb.square;
		}
		
		/**
		 * 
		 * @param i_is_continue
		 */
		public function setContinueMode(i_is_continue:Boolean):void
		{
			this._is_continue = i_is_continue;
		}
		
		/**
		 *  640x480
		 *  
		 * @param i_max pixel default: 100000
		 * @param i_min pixel default: 70
		 */
		public function setAreaRange(i_max:int, i_min:int=70):void
		{
			this._square_detect.setAreaRange( i_max, i_min);
		}
		
		/**
		 * 
		 */
		public function get thresholdedBitmapData() :BitmapData
		{
			try {
				return BitmapData(FLARBinRaster(this._bin_raster).getBuffer());
			} catch (e:Error) {
				return null;
			}
			return null;
		}
	}
}

