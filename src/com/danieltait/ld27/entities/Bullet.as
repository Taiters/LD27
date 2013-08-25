package com.danieltait.ld27.entities 
{
	import com.danieltait.ld27.worlds.GameWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.utils.Draw;
	
	import com.danieltait.ld27.Resources;
	
	public class Bullet extends Entity
	{
		private var image:Image;
		
		private var damage:int;
		
		private var shotBy:ShooterEntity;
		
		
		public var xVel:Number;
		public var yVel:Number;
		public var force:int;
		
		public function Bullet(x:Number, y:Number, vel:Number, direction:Number, rDirection:Number, shotBy:ShooterEntity, damage:int = 34, force:int = 4) 
		{
			this.image = new Image(Resources.PARTICLE);
			this.image.color = 0x35FF75;
			this.image.centerOO();
			this.graphic = image;
			this.setHitbox(image.width, image.height);
			this.type = "Bullet";
			this.centerOrigin();
			this.x = x;
			this.y = y;
			this.xVel = vel * Math.cos(rDirection);
			this.yVel = vel * Math.sin(rDirection);
			this.image.angle = direction;
			this.damage = damage;
			this.shotBy = shotBy;
			this.force = force;
		}
		
		public function shooter():ShooterEntity
		{
			return shotBy;
		}
		
		override public function update():void 
		{
			move();
			handleCollisions();
		}
		
		private function move():void
		{
			this.x += xVel * FP.elapsed;
			this.y += yVel * FP.elapsed;
		}
		
		private function handleCollisions():void
		{
			var e:Entity;
			if (collide("Map", x, y)) {
				(world as GameWorld).emit(GameWorld.EXPLOSION, this.x, this.y);
				explode();
			}
			else if ((e = collide("Enemy", x, y))) {
				var enemy:Enemy = e as Enemy;
				enemy.hit(this);
				explode();
			}
		}
		
		private function explode():void
		{
			world.remove(this);
		}
		
		override public function render():void
		{
			super.render();
		}
		
		public function getDamage():int
		{
			return damage;
		}
		
		
	}

}