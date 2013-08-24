package com .danieltait.ld27.worlds
{
	import com.danieltait.ld27.entities.Level;
	import com.danieltait.ld27.entities.Player;
	import com.danieltait.ld27.entities.ShadowPlayer;
	import com.danieltait.ld27.EntityTrackingCamera;
	import com.danieltait.ld27.PlayerData;
	import com.danieltait.ld27.Queue;
	import com.danieltait.ld27.Resources;
	import com.danieltait.ld27.LevelBuilder;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
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
		public static const BLOOD:String = "blood";
		
		protected var emitter:Emitter;
		
		private var vignette:Image;
		
		public function GameWorld() 
		{
			level = LevelBuilder.buildLevel(Resources.TEST_LEVEL, this);
			
			
			emitter = new Emitter(Resources.PARTICLE, 5, 5);
			emitter.relative = false;
			
			emitter.newType(EXPLOSION, [0]);
			emitter.setMotion(EXPLOSION, 0, 50, 0.2, 360, 25, 0.2);
			emitter.setColor(EXPLOSION, 0xFF8570FF, 0x008570FF);
			
			emitter.newType(BLOOD, [0]);
			emitter.setMotion(BLOOD, 0, 50, 0.2, 360, 25, 0.2);
			emitter.setColor(BLOOD, 0xFFFF448F, 0xFFFF448F);
			
			addGraphic(emitter);
			
			vignette = new Image(Resources.VIGNETTE);
		}
		
		override public function update():void 
		{
			super.update();
			level.getCamera().update();
		}
		
		override public function render():void
		{
			super.render();
			var player:Player = this.getInstance("Player") as Player;
			if (player.isInFlashback()) {
				var alpha:Number = player.getFlashbackTime() / 10000;
				trace(alpha);
				vignette.alpha = alpha;
				Draw.graphic(vignette, FP.camera.x, FP.camera.y);
				Draw.text("REWIND: "+ (10 - Math.floor(player.getFlashbackTime() / 1000)), FP.camera.x + 40, FP.camera.y + 40);
			}
		}
		
		public function emit(type:String, x:Number, y:Number):void
		{
			for ( var i:int = 0; i < 10; i++) {
				emitter.emit(type, x, y);
			}
		}
		
	}

}