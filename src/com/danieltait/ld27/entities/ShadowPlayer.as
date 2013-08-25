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
		private var image:Image;
		private var exists:Boolean = false;
		
		private var currentFrame:PlayerData;
		
		public function ShadowPlayer() 
		{
			image = new Image(Resources.PLAYER);
			image.centerOO();
			image.alpha = 1;
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
			this.visible = false;
			this.currentFrame = null;
		}
		
		public function getFrame():PlayerData
		{
			
			if (currentFrame) {
				return currentFrame;
			}
			return null;
		}
		
		public function addData(data:PlayerData)
		{
			dataQueue.write(data);
		}
		
		public function getFlashbackFrames():Array
		{
			if(currentFrame) {
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
						currentFrame = dataQueue.read();
						if (exists) {
							
							this.x = data.x;
							this.y = data.y;
							this.image.angle = data.direction;
							if (data.shot) {
								shoot();
							}
							this.visible = true;
						}
						else {
							this.visible = false
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