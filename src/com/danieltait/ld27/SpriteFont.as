package com.danieltait.ld27 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Taiters
	 */
	public class SpriteFont 
	{
		private var data:BitmapData;
		private var cols:int;
		private var rows:int;
		private var framesize:int;
		
		public function SpriteFont(data: BitmapData, cols:int, row:int, framesize:int = 32) 
		{
			this.data = data;
			this.cols = cols;
			this.rows = rows;
			this.framesize = framesize;
		}
		
		public function write(text:String, target:BitmapData, x:int, y:int, color:uint = 0xFFFFFF):void
		{
			text = text.toUpperCase();
			var count = text.length;
			
			var canvas:Canvas = new Canvas(framesize * count, framesize);
			canvas.color = color;
			for (var i:int; i < text.length; i++ ) {
				var code:int = text.charCodeAt(i) - 32;
				
				
				var sx:int = Math.floor(code % cols);
				var sy:int = Math.floor(code / cols);
				
				
				canvas.draw(i * framesize, 0, data, new Rectangle(sx * framesize, sy * framesize, framesize, framesize));
			}
			canvas.render(FP.buffer, new Point(x, y),new Point(0,0));
		}
		
	}

}