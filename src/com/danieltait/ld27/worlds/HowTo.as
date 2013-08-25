package com.danieltait.ld27.worlds 
{
	import com.danieltait.ld27.entities.FlashbackPoint;
	import com.danieltait.ld27.Menu.Option;
	import com.danieltait.ld27.Resources;
	import com.danieltait.ld27.SpriteFont;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Taiters
	 */
	public class HowTo extends World
	{
		
		public static const BACK:String = "back";
		private var spritefont:SpriteFont;
		
		private var timeshifter:Image;
		private var enemy:Image;
		private var timebonus:Image;
		
		public function HowTo() 
		{
			var image:Bitmap = new Resources.FONT16();
			spritefont = new SpriteFont(image.bitmapData.clone(), 8, 8, 16);
			
			timeshifter = new Image(Resources.FLASHBACKPOINT);
			timeshifter.centerOO();
			timeshifter.x = 55;
			timeshifter.y = 160;
			addGraphic(timeshifter);
			
			enemy = new Image(Resources.ENEMY);
			enemy.centerOO();
			enemy.x = 100;
			enemy.y = 230;
			addGraphic(enemy);
			
			timebonus = new Image(Resources.TIMEBONUS);
			timebonus.centerOO();
			timebonus.x = 480;
			timebonus.y = 230;
			addGraphic(timebonus);
			
			var image32:Bitmap = new Resources.FONT32();
			var spritefont32:SpriteFont = new SpriteFont(image32.bitmapData.clone(), 8, 8, 32);
			
			var backButton:Option = new Option(BACK, spritefont32, FP.halfWidth - (BACK.length / 2) * 32, 430, function():void {
				FP.world = new MainMenu;
			});
			
			add(backButton);
			
			
		}
		
		override public function render():void
		{
			super.render();
			var line = 10;
			spritefont.write("you can only survive for 10 seconds..", FP.buffer, 10, line, 0x61E058);
			spritefont.write("luckily, you can stand on time shifters", FP.buffer, 10, line += 30, 0x61E058);
			spritefont.write("to go back in time. Stand in them all", FP.buffer, 10, line += 20, 0x61E058);
			spritefont.write("to win", FP.buffer, 10, line += 20, 0x61E058);
			spritefont.write("this is a timeshifter", FP.buffer, 107, 155, 0x61E058);
			
			line = 374;
			spritefont.write("Use wasd to move and the mouse", FP.buffer, 10, line, 0x61E058);
			spritefont.write("to shoot.", FP.buffer, 10, line += 20, 0x61E058);
			
			spritefont.write("Enemies will try", FP.buffer, 10, 260, 0x61E058);
			spritefont.write("to block you", FP.buffer, 10, 280, 0x61E058);
			
			spritefont.write("These will give", FP.buffer, 397, 260, 0x61E058);
			spritefont.write("you more time", FP.buffer, 397, 280, 0x61E058);
			
		}
		
		override public function update():void
		{
			super.update();
			timeshifter.angle += 30 * FP.elapsed;
			enemy.angle += 35 * FP.elapsed;
			timebonus.angle += 25 * FP.elapsed;
		}
		
		
	}

}