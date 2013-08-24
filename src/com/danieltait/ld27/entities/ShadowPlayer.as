package com.danieltait.ld27.entities 
{
	import com.danieltait.ld27.PlayerData;
	import com.danieltait.ld27.Queue;
	import com.danieltait.ld27.Resources;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	
	public class ShadowPlayer extends ShooterEntity
	{
		private var dataQueue:Queue;
		var image:Image;
		var exists:Boolean = false;
		public function ShadowPlayer() 
		{
			image = new Image(Resources.PLAYER);
			image.centerOO();
			image.alpha = 0.5;
			this.graphic = image;
			this.centerOrigin();
			
			dataQueue = new Queue;
			
			this.visible = false;
		}
		
		public function setExists(exists:Boolean):void
		{
			this.exists = exists;
		}
		
		public function reset():void 
		{
			dataQueue.reset();
			this.exists = false;
		}
		
		public function getFrame():PlayerData
		{
			
			var data:PlayerData = dataQueue.peek();
			var date:Date = new Date();
			var timestamp:Number = date.time;
			if (timestamp - 10000 > data.timestamp) {
				return data;
			}
			return null;
		}
		
		public function addData(data:PlayerData)
		{
			dataQueue.write(data);
		}
		
		public function getFlashbackFrames():Array
		{
			var data:PlayerData = dataQueue.peek();
			var date:Date = new Date();
			var timestamp:Number = date.time;
			trace(timestamp - data.timestamp);
			if (timestamp - 10000 > data.timestamp) {
				return dataQueue.getContents().reverse();
			}
			return null;
		}
		
		override public function update():void
		{
			updateData();
		}
		
		override public function getAngle():Number
		{
			return this.image.angle;
		}
		
		private function updateData():void
		{
			if (!dataQueue.isEmpty) {
				var data:PlayerData = dataQueue.peek();
				if (data) {
					var date:Date = new Date();
					var timestamp:Number = date.time;
					if (timestamp - 10000 > data.timestamp) {
						data = dataQueue.read();
						this.x = data.x;
						this.y = data.y;
						this.image.angle = data.direction;
						if(exists) {
							if (data.shot) {
								shoot();
							}
							this.image.alpha = 1;
						}
						else {
							this.image.alpha = 0.25;
						}
						
						this.visible = true;
					}
					else {
						this.visible = false;
					}
				}
			}
		}
		
	}

}