package com.danieltait.ld27 
{
	import com.danieltait.ld27.entities.Level;
	import com.danieltait.ld27.entities.Player;
	import com.danieltait.ld27.entities.ShadowPlayer;
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
		
		
		public static function buildLevel(levelFile:Class, world:World):Level
		{
			var bitmap:BitmapData = new BitmapData(1280, 960, true, 0x00000000);
			Draw.setTarget(bitmap);
			var bytes:ByteArray = new levelFile;
			var xml:XML = new XML(bytes.readUTFBytes(bytes.length));
			
			for (var i:int = 0; i < xml.Bounds.Nodes.length(); i++) {
				drawNodeSet(xml.Bounds.Nodes[i].node);
			}
			bitmap.floodFill(0, 0, 0xFF8570FF);
			
			for (var i:int = 0; i < xml.Bounds.Fill.length(); i++) {
				var fill:XML = xml.Bounds.Fill[i];
				fillRegion(fill.@x, fill.@y, 0xFF8570FF, bitmap);
			}
			
			
			
			var shadow:ShadowPlayer = new ShadowPlayer;
			var player:Player = new Player(shadow);
			world.add(player);
			world.add(shadow);
			
			player.x = xml.Entities.Player.@x;
			player.y = xml.Entities.Player.@y;
			
			
			var level:Level = new Level(bitmap);
			
			world.add(level);
			var trackingCamera:EntityTrackingCamera = new EntityTrackingCamera(player, world.camera, bitmap.width, bitmap.height);
			level.setCamera(trackingCamera);
			
			return level;
			
		}
		
		private static function drawNodeSet(nodes:XMLList):void
		{
			for ( var i:int = 0; i < nodes.length() - 1; i++) {
				var node1:XML = nodes[i];
				var node2:XML = nodes[i + 1];
				
				Draw.line(node1.@x, node1.@y, node2.@x, node2.@y, 0x8570FF);
				
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