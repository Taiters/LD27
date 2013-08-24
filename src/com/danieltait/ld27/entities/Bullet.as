package com.danieltait.ld27.entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	import com.danieltait.ld27.Resources;
	
	public class Bullet extends Entity
	{
		private var image:Image;
		
		private var xVel:Number;
		private var yVel:Number;
		private var direction:Number;
		
		private var shotBy:ShooterEntity;
		
		public function Bullet(x:Number, y:Number, vel:Number, direction:Number, rDirection:Number, shotBy:ShooterEntity) 
		{
			this.image = new Image(Resources.BULLET);
			this.image.centerOO();
			this.graphic = image;
			this.centerOrigin();
			this.x = x;
			this.y = y;
			this.xVel = vel * Math.cos(rDirection);
			this.yVel = vel * Math.sin(rDirection);
			this.image.angle = direction;
			this.shotBy = shotBy;
		}
		
		override public function update():void 
		{
			this.x += xVel * FP.elapsed;
			this.y += yVel * FP.elapsed;
		}
		
	}

}