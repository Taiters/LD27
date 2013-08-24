package com.danieltait.ld27.entities 
{
	import com.danieltait.ld27.PlayerData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import com.danieltait.ld27.Resources;
	
	public class Player extends ShooterEntity
	{
		private var xVel:Number = 0;
		private var yVel:Number = 0;
		private var acc:Number = 50;
		private var maxSpeed:Number = 300;
		
		private var image:Image;
		
		private var shadow:ShadowPlayer;
		
		private var shot:Boolean = false;
		
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
			this.centerOrigin();
			Input.define("Up", Key.W, Key.UP);
			Input.define("Down", Key.S, Key.DOWN);
			Input.define("Left", Key.A, Key.LEFT);
			Input.define("Right", Key.D, Key.RIGHT);
			Input.define("Flashback", Key.F, Key.SHIFT);
			
			this.shadow = shadow;
			
			this.fireRate = 0.25
		}
		
		override public function render():void
		{
			super.render();
			Draw.hitbox(this);
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
		
		private function handleInput() {
			
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
			
			if (Input.check("Up")) {
				this.yVel -= acc;
			}
			else if (Input.check("Down")) {
				this.yVel += acc;
			}
			else {
				if (this.yVel > 0) {
					this.yVel -= acc;
					if (this.yVel < 0) {
						this.yVel = 0;
					}
				}
				else if (this.yVel < 0) {
					this.yVel += acc;
					if (this.yVel > 0) {
						this.yVel = 0;
					}
				}
			}
			if (Input.check("Left")) {
				this.xVel -= acc;
			}
			else if (Input.check("Right")) {
				this.xVel += acc;
			}
			else {
				if (this.xVel > 0) {
					this.xVel -= acc;
					if (this.xVel < 0) {
						this.xVel = 0;
					}
				}
				else if (this.xVel < 0) {
					this.xVel += acc;
					if (this.xVel > 0) {
						this.xVel = 0;
					}
				}
			}
			
			xVel = (xVel > maxSpeed) ? maxSpeed : (xVel < -maxSpeed) ? -maxSpeed : xVel;
			yVel = (yVel > maxSpeed) ? maxSpeed : (yVel < -maxSpeed) ? -maxSpeed : yVel;
			
			
			
			
		}
		
		private function handleCollisions() {
			x += xVel * FP.elapsed;
			y += yVel * FP.elapsed;
		}
		
		private function handleAiming() {
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
			flashbackFrames = this.shadow.getFlashbackFrames();
			if (flashbackFrames) {
				this.shadow.reset();
				doingFlashback = true;
				updateFlashback();
			}
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