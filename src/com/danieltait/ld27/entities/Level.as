package com.danieltait.ld27.entities 
{
	import com.danieltait.ld27.EntityTrackingCamera;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.media.Camera;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.Entity;
	import net.flashpunk.masks.Pixelmask;
	
	/**
	 * ...
	 * @author Taiters
	 */
	public class Level extends Entity
	{
		private var camera:EntityTrackingCamera;
		public function Level(data:BitmapData) 
		{
			var canvas:Canvas = new Canvas(data.width, data.height);
			canvas.draw(0, 0, data);
			//canvas.applyFilter(new GlowFilter(0x8570FF, 1, 8, 8,2,BitmapFilterQuality.HIGH,false,false));
			this.graphic = canvas;
			this.mask = new Pixelmask(data);
			this.type = "Map";
		}
		
		public function setCamera(camera:EntityTrackingCamera):void
		{
			this.camera = camera;
		}
		
		public function getCamera():EntityTrackingCamera
		{
			return camera;
		}
		
		
		
	}

}