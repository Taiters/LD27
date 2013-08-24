package com.danieltait.ld27.entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	public class ShooterEntity extends Entity
	{
		protected var lastFire = 1;
		protected var fireRate;
		
		public function getAngle():Number { return null; }
		
		protected function shoot():void
		{
			var direction:Number = this.getAngle();
			var rDirection:Number = -(direction +90) * (Math.PI / 180);
			var spawnX:Number = x + (Math.cos(rDirection) * 30);
			var spawnY:Number = y + (Math.sin(rDirection) * 30);
			var bullet:Bullet = new Bullet(spawnX, spawnY, 400, direction, rDirection, this);
			FP.world.add(bullet);
			lastFire = 0;
		}
		
	}

}