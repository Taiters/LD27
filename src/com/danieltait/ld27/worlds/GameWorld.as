package com .danieltait.ld27.worlds
{
	import com.danieltait.ld27.entities.FlashbackPoint;
	import com.danieltait.ld27.entities.Level;
	import com.danieltait.ld27.entities.Player;
	import com.danieltait.ld27.entities.ShadowPlayer;
	import com.danieltait.ld27.EntityTrackingCamera;
	import com.danieltait.ld27.PlayerData;
	import com.danieltait.ld27.Queue;
	import com.danieltait.ld27.Resources;
	import com.danieltait.ld27.LevelBuilder;
	import com.danieltait.ld27.AudioManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Taiters
	 */
	public class GameWorld extends World
	{
		private var level:Level;
		
		public static const EXPLOSION:String = "explosion";
		public static const GREEN_EXPLOSION:String = "green_explosion";
		public static const BLOOD:String = "blood";
		
		protected var emitter:Emitter;
		
		private var vignette:Image;
		
		public var bitmapTest:BitmapData;
		
		public function GameWorld() 
		{
			level = LevelBuilder.buildLevel(Resources.TEST_LEVEL, this);
			
			emitter = new Emitter(Resources.PARTICLE, 5, 5);
			emitter.relative = false;
			
			emitter.newType(EXPLOSION, [0]);
			emitter.setMotion(EXPLOSION, 0, 50, 0.2, 360, 25, 0.2);
			emitter.setColor(EXPLOSION, 0xFF8570FF, 0x008570FF);
			
			emitter.newType(GREEN_EXPLOSION, [0]);
			emitter.setMotion(GREEN_EXPLOSION, 0, 50, 0.2, 360, 25, 0.2);
			emitter.setColor(GREEN_EXPLOSION, 0xFF61E058, 0x0061E058);
			
			emitter.newType(BLOOD, [0]);
			emitter.setMotion(BLOOD, 0, 50, 0.2, 360, 25, 0.2);
			emitter.setColor(BLOOD, 0xFFFF448F, 0xFFFF448F);
			
			vignette = new Image(Resources.VIGNETTE);
			AudioManager.getInstance().setWorld(this);
			AudioManager.getInstance().addSound("Shot", new Sfx(Resources.SHOOT))
				.addSound("Hit", new Sfx(Resources.HIT))
				.addSound("Song", new Sfx(Resources.MUSIC))
				.addSound("Flashback", new Sfx(Resources.FLASHBACK))
				.playSound("Song", 0.5);
		}
		
		override public function update():void 
		{
			super.update();
			level.getCamera().update();
			emitter.update();
		}
		
		override public function render():void
		{
			super.render();
			var test:Canvas = new Canvas(FP.width, FP.height);
			emitter.render(bitmapTest, new Point(0, 0), FP.camera);
			test.copyPixels(bitmapTest, new Rectangle(0, 0, FP.width, FP.height), new Point(0, 0));
			bitmapTest.fillRect(new Rectangle(0, 0, bitmapTest.width, bitmapTest.height), 0x00000000);
			test.applyFilter(new GlowFilter(0xFFFFFF,1,12,12,1));
			test.render(FP.buffer, new Point(0, 0), new Point(0, 0));
			
			render_markers();
			var player:Player = this.getInstance("Player") as Player;
			if (player.isInFlashback()) {
				var alpha:Number = player.getFlashbackTimeTaken() / 10000;
				vignette.alpha = alpha;
				Draw.graphic(vignette, FP.camera.x, FP.camera.y);
				Draw.text("" + Math.floor(((player.getFlashbackTime() - player.getStartTime()) / 1000) - (player.getFlashbackTimeTaken() / 1000)), FP.camera.x + 40, FP.camera.y + 40);
				
			}
			else {
				Draw.text(""+Math.floor(player.getHistoryTime()/1000), FP.camera.x + 40, FP.camera.y + 40);
			}
			Draw.text("SCORE: " + player.getScore(), FP.camera.x + 40, FP.camera.y + 60);
		}
		
		private function render_markers():void 
		{
			var centerX:Number = FP.camera.x + FP.halfWidth;
			var centerY:Number = FP.camera.y + FP.halfHeight;
			var fbps:Array = [];
			this.getType("FlashbackPoint", fbps);
			for each(var fbp:FlashbackPoint in fbps) {
				var xd:Number = fbp.x - centerX;
				var yd:Number = fbp.y - centerY;
				var dist = Math.sqrt(Math.pow(xd, 2) + Math.pow(yd, 2));
				if(dist > FP.halfWidth && dist < 600) {
					var dir:Number = Math.atan2(yd, xd);
					
					var xPos:Number = Math.cos(dir) * FP.halfWidth;
					var yPos:Number = Math.sin(dir) * FP.halfHeight;
					
					trace(xPos+ " " +yPos);
					
					var img:Image = new Image(Resources.MARKER);
					img.centerOO();
					
					img.render(FP.buffer, new Point(FP.halfWidth + xPos,FP.halfHeight + yPos),new Point(0,0));
				}
			}
		}
		
		public function emit(type:String, x:Number, y:Number, amount:int = 10):void
		{
			for ( var i:int = 0; i < amount; i++) {
				emitter.emit(type, x, y);
			}
		}
		
	}

}