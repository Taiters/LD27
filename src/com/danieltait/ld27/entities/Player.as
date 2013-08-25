package com.danieltait.ld27.entities 
{
	import com.danieltait.ld27.PlayerData;
	import com.danieltait.ld27.worlds.GameWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	import com.danieltait.ld27.Resources;
	import com.danieltait.ld27.AudioManager;
	
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
		
		private var timeBonus:Number = 0;
		
		
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
			if (doingFlashback) {
				return flashBackTime;
			}
			return null;
		}
		
		public function getFlashbackTimeTaken():Number
		{
			if (doingFlashback && flashbackFrames[flashBackFrameIndex]) {
				return flashBackTime - flashbackFrames[flashBackFrameIndex].timestamp;
			}
			return null;
		}
		
		public function getHistoryTime():Number
		{
			if(shadow.getFrame()) {
				var date:Date = new Date;
				var timestamp:Number = date.time;
				return timestamp - shadow.getFrame().timestamp - timeBonus;
			}
			return null;
		}
		
		public function getStartTime():Number
		{
			return shadow.getFrame().timestamp;
		}
		
		private function handleInput():void
		{
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
			var fbp:FlashbackPoint;
			if (( fbp = (collide("FlashbackPoint", x, y) as FlashbackPoint))) {
				if (flashback()) {
					(world as GameWorld).emit(GameWorld.EXPLOSION, fbp.x, fbp.y, 30);
					world.remove(fbp);
					addScore(100);
					return;
				}
			}
			
			var tb:TimeBonus;
			if (( tb = (collide("TimeBonus", x, y) as TimeBonus))) {
				(world as GameWorld).emit(GameWorld.GREEN_EXPLOSION, tb.x, tb.y, 30);
				world.remove(tb);
				timeBonus += 5000;
			}
			
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
		
		private function writeShadowData():void
		{
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
		
		private function flashback():Boolean
		{
			if (canFlashback()) {
				doingFlashback = true;
				updateFlashback();
				var date:Date = new Date;
				flashBackTime = date.time;
				AudioManager.getInstance().fadeTo("Song", 0.1, 0.5);
				AudioManager.getInstance().loopSound("Flashback");
				var tween:VarTween = new VarTween();
				tween.tween(image, "alpha", 0.25, 0.5);
				world.addTween(tween);
				return true;
			}
			return false;
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
				timeBonus = 0;
				AudioManager.getInstance().fadeTo("Song", 0.5, 0.5);
				AudioManager.getInstance().stopSound("Flashback");
				shadow.reset();
				var flashbacks:Array = [];
				world.getType("FlashbackPoint", flashbacks);
				if (flashbacks.length == 0) {
					(world as GameWorld).win = true;
					AudioManager.getInstance().fadeTo("Song", 0, 2);
				}
				this.image.alpha = 1;
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