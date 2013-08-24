package com.danieltait.ld27.entities 
{
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
		
		private var xVel:Number;
		private var yVel:Number;
		
		private static const ATTACK_DIST:int = 500;
		private static const MOVE_SPEED:int = 300;
		
		private var chasing:Boolean = false;
		
		
		public function Enemy() 
		{
			image = new Image(Resources.PLAYER);
			image.centerOO();
			this.graphic = image;
			
			this.setHitbox(image.width, image.height);
			this.type = "Enemy";
			this.centerOrigin();
			health = 100;
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
			
			//Draw.line(this.x, this.y, player.x, player.y, col);
		}
		
		override public function update():void
		{
			if (this.health <= 0) {
				world.remove(this);
			}
			else {
				moveToPlayer();
				handleCollisions();
			}
		}
		
		private function moveToPlayer():void
		{
			var player:Player = world.getInstance("Player");
			
			var xd:Number = player.x - this.x;
			var yd:Number = player.y - this.y;
			
			if (Math.sqrt(Math.pow(xd, 2) + Math.pow(yd, 2)) < ATTACK_DIST) {
				var dir:Number = Math.atan2(yd, xd);
				
				this.image.angle = -dir * (180 / Math.PI) - 90;
				
				xVel = Math.cos(dir) * MOVE_SPEED;
				yVel = Math.sin(dir) * MOVE_SPEED;
				
				chasing = true;
			}
			else {
				xVel = 0;
				yVel = 0;
				
				chasing = false;
			}
			
		}
		
		private function handleCollisions():void
		{
			var xd:Number = xVel * FP.elapsed;
			var yd:Number = yVel * FP.elapsed;
			
			
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