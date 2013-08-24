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
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Taiters
	 */
	public class GameWorld extends World
	{
		private var level:Level;
		public function GameWorld() 
		{
			level = LevelBuilder.buildLevel(Resources.TEST_LEVEL, this);
		}
		
		override public function update():void 
		{
			super.update();
			level.getCamera().update();
		}
		
	}

}