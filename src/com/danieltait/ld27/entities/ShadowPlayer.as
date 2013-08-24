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
		
		public function reset():void 
		{
			dataQueue.reset();
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
						this.visible = true;
						data = dataQueue.read();
						this.x = data.x;
						this.y = data.y;
						this.image.angle = data.direction;
						if (data.shot) {
							shoot();
						}
					}
					else {
						this.visible = false;
					}
				}
			}
		}
		
	}

}