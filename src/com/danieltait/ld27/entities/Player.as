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
		var xVel:Number = 0;
		var yVel:Number = 0;
		var acc:Number = 50;
		var maxSpeed:Number = 300;
		
		var image:Image;
		
		var shadow:ShadowPlayer;
		
		var shot:Boolean = false;
		
		public function Player(shadow) 
		{
			image = new Image(Resources.PLAYER);
			image.centerOO();
			this.graphic = image;
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
		}
		
		override public function update():void
		{
			shot = false;
			handleInput();
			writeShadowData();
		}
		
		override public function getAngle():Number
		{
			return this.image.angle;
		}
		
		private function handleInput() {
			
			if (Input.check("Flashback")) {
				flashback();
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
			
			x += xVel * FP.elapsed;
			y += yVel * FP.elapsed;
			
			var mouseX = Input.mouseX;
			var mouseY = Input.mouseY;
			
			var angle = Math.atan2(mouseX - x, mouseY - y);
			image.angle  = (angle) * (180 / Math.PI) + 180;
			
			lastFire += FP.elapsed;
			if (Input.mouseDown && lastFire > fireRate) {
				shoot();
				shot = true;
			}
			
		}
		
		private function writeShadowData() {
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
		
		private function flashback():void 
		{
			var frame:PlayerData = this.shadow.getFrame();
			if (frame) {
				this.x = frame.x;
				this.y = frame.y;
				this.image.angle = frame.direction;
				this.shadow.reset();
			}
		}
		
	}

}