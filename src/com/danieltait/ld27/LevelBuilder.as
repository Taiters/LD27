package com.danieltait.ld27 
{
	import com.danieltait.ld27.entities.Enemy;
	import com.danieltait.ld27.entities.FlashbackPoint;
	import com.danieltait.ld27.entities.Level;
	import com.danieltait.ld27.entities.Player;
	import com.danieltait.ld27.entities.ShadowPlayer;
	import com.danieltait.ld27.entities.TimeBonus;
	import com.danieltait.ld27.worlds.GameWorld;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.xml.XMLNode;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Taiters
	 */
	public class LevelBuilder 
	{
		
		
		public static function buildLevel(levelFile:Class, world:GameWorld):Level
		{
			
			var bytes:ByteArray = new levelFile;
			var xml:XML = new XML(bytes.readUTFBytes(bytes.length));
			
			var color:uint = xml.@color;
			
			var bitmap:BitmapData = new BitmapData(xml.@width, xml.@height, true, 0x00000000);
			Draw.setTarget(bitmap);
			
			for (var i:int = 0; i < xml.Bounds.Nodes.length(); i++) {
				drawNodeSet(xml.Bounds.Nodes[i].node, uint(color));
			}
			bitmap.floodFill(0, 0, uint(color));
			
			for (var i:int = 0; i < xml.Bounds.Fill.length(); i++) {
				var fill:XML = xml.Bounds.Fill[i];
				fillRegion(fill.@x, fill.@y, uint(color), bitmap);
			}
			
			var level:Level = new Level(bitmap);
			world.bitmapTest = new BitmapData(level.width, level.height, true, 0x00000000);
			
			var shadow:ShadowPlayer = new ShadowPlayer;
			var player:Player = new Player(shadow);
			world.add(player);
			world.add(shadow);
			
			shadow.renderTarget = world.bitmapTest;
			player.renderTarget = world.bitmapTest;
			
			player.x = xml.Entities.Player.@x;
			player.y = xml.Entities.Player.@y;
			
			
			for (var i:int = 0; i < xml.Entities.Enemy.length(); i++) {
				var enemy:Enemy = new Enemy();
				world.add(enemy);
				enemy.x = xml.Entities.Enemy[i].@x;
				enemy.y = xml.Entities.Enemy[i].@y;
				enemy.renderTarget = world.bitmapTest;
			}
			
			for (var i:int = 0; i < xml.Entities.FlashbackPoint.length(); i++) {
				var fbp:FlashbackPoint = new FlashbackPoint();
				world.add(fbp);
				fbp.x = xml.Entities.FlashbackPoint[i].@x;
				fbp.y = xml.Entities.FlashbackPoint[i].@y;
				fbp.renderTarget = world.bitmapTest;
				fbp.layer = 20;
			}
			
			for (var i:int = 0; i < xml.Entities.TimeBonus.length(); i++) {
				var tb:TimeBonus = new TimeBonus();
				world.add(tb);
				tb.x = xml.Entities.TimeBonus[i].@x;
				tb.y = xml.Entities.TimeBonus[i].@y;
				tb.renderTarget = world.bitmapTest;
				tb.layer = 20;
			}
			
			
			world.add(level);
			var trackingCamera:EntityTrackingCamera = new EntityTrackingCamera(player, world.camera, bitmap.width, bitmap.height);
			level.setCamera(trackingCamera);
			
			Draw.resetTarget();
			
			
			return level;
			
		}
		
		private static function drawNodeSet(nodes:XMLList, col:uint):void
		{
			for ( var i:int = 0; i < nodes.length() - 1; i++) {
				var node1:XML = nodes[i];
				var node2:XML = nodes[i + 1];
				
				Draw.line(node1.@x, node1.@y, node2.@x, node2.@y, col);
				
			}
			
			var start:XML = nodes[0];
			var end:XML = nodes[nodes.length() -1 ];
			
			Draw.line(start.@x, start.@y, end.@x, end.@y, 0x8570FF);
		}
		
		private static function fillRegion(x:int, y:int, col:uint, bitmap:BitmapData):void
		{
			bitmap.floodFill(x, y, col);
		}
		
	}

}