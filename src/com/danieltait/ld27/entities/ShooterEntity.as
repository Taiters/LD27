package com.danieltait.ld27.entities 
{
	import com.danieltait.ld27.worlds.GameWorld;
	import com.danieltait.ld27.AudioManager;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	public class ShooterEntity extends Entity
	{
		protected var lastFire:Number = 1;
		protected var fireRate:Number;
		protected var health:int;
		
		public function getAngle():Number { return null; }
		private var value:int = 25;
		private var score:int = 0;
		
		protected function shoot():void
		{
			var direction:Number = this.getAngle();
			var rDirection:Number = -(direction +90) * (Math.PI / 180);
			var spawnX:Number = x + (Math.cos(rDirection) * 30);
			var spawnY:Number = y + (Math.sin(rDirection) * 30);
			var bullet:Bullet = new Bullet(spawnX, spawnY, 400, direction, rDirection, this);
			FP.world.add(bullet);
			bullet.renderTarget = (world as GameWorld).bitmapTest;
			lastFire = 0;
			
			AudioManager.getInstance().playSound("Shot",0.5);
		}
		
		public function addScore(val:int):void 
		{
			score += val;
		}
		
		public function getScore():int
		{
			return score;
		}
		
		public function hit(b:Bullet):void 
		{
			health -= b.getDamage();
			if (health <= 0) {
				b.shooter().addScore(this.value);
				die();
			}
			(world as GameWorld).emit(GameWorld.BLOOD, this.x, this.y);
			AudioManager.getInstance().playSound("Hit");
		}
		
		protected function die():void{}
		
	}

}