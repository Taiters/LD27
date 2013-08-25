package com.danieltait.ld27.Menu 
{
	import com.danieltait.ld27.SpriteFont;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	public class Option extends Entity
	{
		private var text:String;
		private var callback:Function;
		private var spritefont:SpriteFont;
		
		private var color:uint;
		
		public function Option(text:String, spritefont:SpriteFont, x:int, y:int, callback:Function ) 
		{
			this.text = text;
			this.x = x;
			this.y = y;
			this.callback = callback;
			this.spritefont = spritefont;
			this.setHitbox(text.length * 32, 32);
			
		}
		
		override public function update():void
		{
			this.color = 0x6A54D2;
			if (collidePoint(x, y, Input.mouseX, Input.mouseY)) {
				this.color = 0xA89CE5;
				if (Input.mouseDown) {
					callback();
				}
			}
		}
		
		override public function render():void
		{
			spritefont.write(text, FP.buffer, x, y, color);
		}
		
	}

}