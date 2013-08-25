package com.danieltait.ld27.entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import com.danieltait.ld27.Resources;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Taiters
	 */
	public class Enemy extends ShooterEntity
	{
		private var image:Image;
		
		private var vel:Number;
		private var dir:Number;
		
		private static const ATTACK_DIST:int = 500;
		private static const MOVE_SPEED:int = 300;
		
		private var chasing:Boolean = false;
		
		private var acc:Number = 50;
		
		private var impulse:Point;
		
		
		public function Enemy() 
		{
			image = new Image(Resources.ENEMY);
			image.centerOO();
			this.graphic = image;
			
			this.setHitbox(image.width, image.height);
			this.type = "Enemy";
			this.centerOrigin();
			health = 100;
			
			impulse = new Point(0, 0);
		}
		
		override public function getAngle():Number
		{
			return this.image.angle;
		}
		
		override public function render():void
		{
			super.render();
			var player:Player = world.getInstance("Player");
			
			var col:uint = (chasing) ? 0x00FF00 : 0xFF0000;
			/*
			Draw.line(this.x, this.y, player.x, player.y, col);
			Draw.text("Chasing", this.x - 30, this.y - 70);
			Draw.text("Speed:    " + Math.round(this.vel), this.x - 30, this.y - 50);
			Draw.text("Rotation: " + Math.round(this.image.angle), this.x - 30, this.y - 30);
			*/
		}
		
		override public function update():void
		{
			if (this.health <= 0) {
				world.remove(this);
			}
			else {
				moveToPlayer();
				handleImpulse();
				handleCollisions();
			}
		}
		
		override public function hit(b:Bullet):void 
		{
			super.hit(b);
			impulse.x += b.xVel * b.force;
			impulse.y += b.yVel * b.force;
		}
		
		private function moveToPlayer():void
		{
			var player:Player = world.getInstance("Player");
			
			var xd:Number = player.x - this.x;
			var yd:Number = player.y - this.y;
			
			if (Math.sqrt(Math.pow(xd, 2) + Math.pow(yd, 2)) < ATTACK_DIST) {
				dir = Math.atan2(yd, xd);
				
				this.image.angle = -dir * (180 / Math.PI) - 90;
				
				vel += acc;
				
				vel = (vel > MOVE_SPEED) ? MOVE_SPEED : (vel < -MOVE_SPEED) ? -MOVE_SPEED : vel;
				
				chasing = true;
			}
			else {
				vel = 0;
				
				chasing = false;
			}
			
		}
		
		private function handleImpulse():void
		{
			var v:Number = Math.sqrt(Math.pow(impulse.x, 2) + Math.pow(impulse.y, 2));
			vel -= v;
			impulse.x = 0;
			impulse.y = 0;
		}
		
		private function handleCollisions():void
		{
			var xd:Number = (Math.cos(dir) * vel) * FP.elapsed;
			var yd:Number = (Math.sin(dir) * vel) * FP.elapsed;
			
			
			for ( var i:int = 0; i < Math.abs(xd); i++) {
				var sxd:int = FP.sign(xd);
				if (!collide("Map", x + sxd, y) 
					&& !collide("Enemy", x + sxd, y)
					&& !collide("Player", x + sxd, y)) {
					
					x += sxd;
				}
				else {
					if (!collide("Map", x + sxd, y + 1) 
						&& !collide("Enemy", x + sxd, y + 1)
						&& !collide("Player", x + sxd, y + 1)) {
							
						x += sxd;
						y += 1;
					}
					else if (!collide("Map", x + sxd, y - 1) 
						&& !collide("Enemy", x + sxd, y - 1)
						&& !collide("Player", x + sxd, y - 1)) {
						
						x += sxd;
						y -= 1;
					}
					else {
						break;
					}
				}
			}
			
			for (var i:int = 0; i < Math.abs(yd); i++) {
				var syd:int = FP.sign(yd);
				if (!collide("Map", x, y + syd) 
					&& !collide("Enemy", x, y + syd)
					&& !collide("Player", x, y + syd)) {
					
					y += syd;
				}
				else {
					if (!collide("Map", x + 1, y + syd) 
						&& !collide("Enemy", x + 1, y + syd)
						&& !collide("Player", x + 1, y + syd)) {
						
						y += syd;
						x += 1;
					}
					else if (!collide("Map", x - 1, y + syd) 
						&& !collide("Enemy", x - 1, y + syd)
						&& !collide("Player", x - 1, y + syd)) {
						
						y += syd;
						x -= 1;
					}
					else {
						break;
					}
				}
			}
		}
		
	}

}