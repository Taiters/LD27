package com.danieltait.ld27 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Taiters
	 */
	public class EntityTrackingCamera
	{
		private var track:Entity;
		private var camera:Point;
		private var maxX:int;
		private var maxY:int;
		
		public function EntityTrackingCamera(track:Entity, camera:Point, maxX:int, maxY:int) 
		{
			this.track = track;
			this.camera = camera;
			
			this.maxX = maxX;
			this.maxY = maxY;
		}
		
		public function update():void {
			camera.x = track.x - FP.width / 2;
			camera.y = track.y - FP.height / 2;
			if (camera.x + FP.width > maxX) {
				camera.x = maxX - FP.width
			}
			else if (camera.x < 0) {
				camera.x = 0;
			}
			if (camera.y + FP.height > maxY) {
				camera.y = maxY - FP.height;
			}
			else if (camera.y < 0) {
				camera.y = 0;
			}
		}
		
	}

}