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
	import com.danieltait.ld27.SpriteFont;
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
		public static const END_PAUSE:int = 2;
		
		public var win:Boolean = false;
		public var loose:Boolean = false;
		
		protected var emitter:Emitter;
		
		private var vignette:Image;
		
		private var spritefont:SpriteFont;
		
		public var bitmapTest:BitmapData;
		
		private var endPauseTimer:Number = 0;
		
		private var levelindex:int;
		
		public function GameWorld(leveldata:Class, levelindex:int) 
		{
			this.levelindex = levelindex;
			level = LevelBuilder.buildLevel(leveldata, this);
			
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
				
			
			var image:Bitmap = new Resources.FONT16();
			spritefont = new SpriteFont(image.bitmapData.clone(), 8, 8, 16);
		}
		
		override public function update():void 
		{
			super.update();
			level.getCamera().update();
			emitter.update();
			
			var player:Player = this.getInstance("Player") as Player;
			if (player && !player.isInFlashback() && !win) {
				if (Math.floor(player.getHistoryTime() / 1000) >= 10)
				{
					emit(EXPLOSION, player.x, player.y, 40);
					this.remove(player);
					loose = true;
					AudioManager.getInstance().playSound("PlayerDie");
				}
			}
			
			if (win || loose) {
				endPauseTimer += FP.elapsed;
				if (endPauseTimer > END_PAUSE) {
					var score:int = 0;
					if (player) {
						score = player.getScore();
					}
					FP.world = new PostLevel(score, win);
				}
			}
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
			if(player) {
				if (player.isInFlashback()) {
					render_flashback(player);
				}
				else {
					render_remaining(player);
				}
				render_score(player);
			}
		}
		
		private function render_score(player:Player):void
		{
			spritefont.write("Score " + player.getScore(), FP.buffer, 10, 50);
		}
		
		private function render_remaining(player:Player):void
		{
			spritefont.write("Remaining " + (10-Math.floor(player.getHistoryTime() / 1000)), FP.buffer,
				10, 10);
		}
		
		private function render_flashback(player:Player):void
		{
			var alpha:Number = player.getFlashbackTimeTaken() / 10000;
			vignette.alpha = alpha;
			Draw.graphic(vignette, FP.camera.x, FP.camera.y);
			spritefont.write("Remaining: " + (10-Math.floor(((player.getFlashbackTime() - player.getStartTime()) / 1000) - (player.getFlashbackTimeTaken() / 1000))),
				FP.buffer, 10, 10);
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