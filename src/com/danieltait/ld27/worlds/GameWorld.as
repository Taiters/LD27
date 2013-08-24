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
	import net.flashpunk.World;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Taiters
	 */
	public class GameWorld extends World
	{
		private var level:Level;
		
		public static const EXPLOSION:String = "explosion";
		
		protected var emitter:Emitter;
		
		public function GameWorld() 
		{
			level = LevelBuilder.buildLevel(Resources.TEST_LEVEL, this);
			
			emitter = new Emitter(Resources.BULLET, 5, 5);
			emitter.relative = false;
			emitter.newType(EXPLOSION, [0]);
			emitter.setMotion(EXPLOSION, 0, 50, 0.2, 360, 25, 0.2);
			emitter.setColor(EXPLOSION, 0xFFFFFFFF, 0x00FFFFFF);
			
			addGraphic(emitter);
		}
		
		override public function update():void 
		{
			super.update();
			level.getCamera().update();
		}
		
		override public function remove(e:Entity):Entity
		{
			if (e.type == "Bullet") {
				for ( var i:int = 0; i < 10; i++) {
					emitter.emit(EXPLOSION, e.x, e.y);
				}
			}
			return super.remove(e);
		}
		
	}

}