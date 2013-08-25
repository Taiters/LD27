package com.danieltait.ld27.entities 
{
	import com.danieltait.ld27.PlayerData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import com.danieltait.ld27.Resources;
	
	public class Player extends ShooterEntity
	{
		
		public static const MOVE_SPEED:int = 300;
		
		private var acc:Number = 50;
		
		private var vel:Number;
		private var dir:Number;
		
		private var image:Image;
		
		private var shadow:ShadowPlayer;
		
		private var shot:Boolean = false;
		
		private var flashBackTime:Number;
		private var flashbackFrames:Array;
		private var doingFlashback:Boolean = false;
		private var flashBackFrameIndex:int = 0;
		
		public function Player(shadow:ShadowPlayer) 
		{
			image = new Image(Resources.PLAYER);
			image.centerOO();
			
			this.graphic = image;
			
			this.setHitbox(image.width, image.height);
			this.type = "Player";
			this.name = "Player";
			this.centerOrigin();
			Input.define("Up", Key.W, Key.UP);
			Input.define("Down", Key.S, Key.DOWN);
			Input.define("Left", Key.A, Key.LEFT);
			Input.define("Right", Key.D, Key.RIGHT);
			Input.define("Flashback", Key.F, Key.SHIFT);
			
			this.shadow = shadow;
			
			this.fireRate = 0.25
			
			this.vel = 0;
			this.dir = 0;
		}
		
		override public function render():void
		{
			super.render();
		}
		
		override public function update():void
		{
			if (doingFlashback) {
				updateFlashback();
			}
			else {
				shot = false;
				handleInput();
				handleCollisions();
				handleAiming();
				writeShadowData();
			}
		}
		
		override public function getAngle():Number
		{
			return this.image.angle;
		}
		
		public function isInFlashback():Boolean
		{
			return doingFlashback;
		}
		
		public function getFlashbackTime():Number
		{
			if (doingFlashback && flashbackFrames[flashBackFrameIndex]) {
				return flashBackTime - flashbackFrames[flashBackFrameIndex].timestamp;
			}
			return null;
		}
		
		private function handleInput():void
		{
			
			if (Input.pressed("Flashback")) {
				if (flashback()) {
					return;
				}
			}
			
			if (Input.check(Key.L)) {
				this.shadow.setExists(true);
			}
			if (Input.check(Key.K)) {
				this.shadow.setExists(false);
			}
			
			var xVel:Number = Math.cos(dir) * vel;
			var yVel:Number = Math.sin(dir) * vel;
			
			if (Input.check("Up")) {
				yVel -= acc;
			}
			else if (Input.check("Down")) {
				yVel += acc;
			}
			else {
				if (yVel > 0) {
					yVel -= acc;
					if (yVel < 0) {
						yVel = 0;
					}
				}
				else if (yVel < 0) {
					yVel += acc;
					if (yVel > 0) {
						yVel = 0;
					}
				}
			}
			if (Input.check("Left")) {
				xVel -= acc;
			}
			else if (Input.check("Right")) {
				xVel += acc;
			}
			else {
				if (xVel > 0) {
					xVel -= acc;
					if (xVel < 0) {
						xVel = 0;
					}
				}
				else if (xVel < 0) {
					xVel += acc;
					if (xVel > 0) {
						xVel = 0;
					}
				}
			}
			
			vel = Math.sqrt(Math.pow(xVel, 2) + Math.pow(yVel, 2));
			dir = Math.atan2(yVel, xVel);
			vel = (vel > MOVE_SPEED) ? MOVE_SPEED : (vel < -MOVE_SPEED) ? -MOVE_SPEED : vel;
			
		}
		
		private function handleCollisions():void 
		{
			var xc:Number = Math.cos(dir);
			xc = ((xc < 0.0001 && xc > 0) ||
				(xc > -0.0001 && xc < 0)) ? 0 : Math.cos(dir);
				
			var yc:Number = Math.sin(dir);
			yc = ((yc < 0.0001 && yc > 0) ||
				(yc > -0.0001 && yc < 0)) ? 0 : Math.sin(dir);
			
			var xd:Number = xc * vel * FP.elapsed;
			var yd:Number = yc * vel * FP.elapsed;
			
			for ( var i:int = 0; i < Math.abs(xd); i++) {
				var sxd:int = FP.sign(xd);
				if (!collide("Map", x + sxd, y)
					&& !collide("Enemy", x + sxd, y)) {
					x += sxd;
				}
				else {
					if (!collide("Map", x + sxd, y + 1)
						&& !collide("Enemy", x + sxd, y +1)) {
						x += sxd;
						y += 1;
					}
					else if (!collide("Map", x + sxd, y - 1)
						&& !collide("Enemy", x + sxd, y - 1)) {
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
					&& !collide("Enemy", x , y + syd)) {
					y += syd;
				}
				else {
					if (!collide("Map", x + 1, y + syd)
						&& !collide("Enemy", x + 1, y + syd)) {
						y += syd;
						x += 1;
					}
					else if (!collide("Map", x - 1, y + syd)
						&& !collide("Enemy", x - 1, y + syd)) {
						y += syd;
						x -= 1;
					}
					else {
						break;
					}
				}
			}
		}
		
		private function handleAiming():void 
		{
			var mouseX:Number = Input.mouseX + world.camera.x;
			var mouseY:Number = Input.mouseY + world.camera.y;
			
			var angle = Math.atan2(mouseX - x, mouseY - y);
			image.angle  = (angle) * (180 / Math.PI) + 180;
			
			lastFire += FP.elapsed;
			if (Input.mouseDown && lastFire > fireRate) {
				shoot();
				shot = true;
			}
		}
		
		private function writeShadowData() {
			if(!doingFlashback) {
				var date:Date = new Date;
				var timestamp:Number = date.time;
				
				var data:PlayerData = new PlayerData;
				data.x = this.x;
				data.y = this.y;
				data.direction = image.angle;
				data.timestamp = timestamp;
				data.shot = shot;
				this.shadow.addData(data);
			}
		}
		
		private function flashback():void 
		{
			if (canFlashback()) {
				this.shadow.reset();
				doingFlashback = true;
				updateFlashback();
				var date:Date = new Date;
				flashBackTime = date.time;
			}
		}
		
		public function canFlashback():Boolean
		{
			return (flashbackFrames = this.shadow.getFlashbackFrames())
				? true : false;
		}
		
		private function updateFlashback():void
		{
			if (flashBackFrameIndex < flashbackFrames.length) {
				setData(flashbackFrames[flashBackFrameIndex], false);
				flashBackFrameIndex += 3;
			}
			else {
				flashBackFrameIndex = 0;
				flashbackFrames = null;
				doingFlashback = false;
			}
		}
		
		private function setData(data:PlayerData, shoot:Boolean):void
		{
			this.x = data.x;
			this.y = data.y;
			this.image.angle = data.direction;
			if (shoot && data.shot) {
				this.shoot();
			}
		}
		
	}

}