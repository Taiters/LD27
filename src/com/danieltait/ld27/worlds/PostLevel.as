package com.danieltait.ld27.worlds 
{
	import com.danieltait.ld27.entities.FlashbackPoint;
	import com.danieltait.ld27.Menu.Option;
	import com.danieltait.ld27.Resources;
	import com.danieltait.ld27.SpriteFont;
	import com.danieltait.ld27.LevelManager;
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
	public class PostLevel extends World
	{
		
		public static const REPLAY:String = "replay";
		public static const NEXT_LEVEL:String = "next level";
		public static const MAIN_MENU:String = "Main menu";
		
		public static const YOU_LOST:String = "you lost";
		public static const MESSAGE_LOOSE_1:String = "Press replay";
		public static const MESSAGE_LOOSE_2:String = "to play again";
		
		public static const YOU_WIN:String = "you won";
		public static const MESSAGE_WIN_1:String = "YOU SCORED";
		
		private var spritefont32:SpriteFont;
		private var score;
		
		private var win:Boolean;
		
		public function PostLevel(score:int, win:Boolean) 
		{
			this.score = score;
			this.win = win;
			trace(win);
			
			var image32:Bitmap = new Resources.FONT32();
			spritefont32 = new SpriteFont(image32.bitmapData.clone(), 8, 8, 32);
			
			var replayButton:Option = new Option(REPLAY, spritefont32, FP.halfWidth - (REPLAY.length / 2) * 32, 430, function():void {
				var lvl:Class = LevelManager.getInstance().getCurrentLevel();
				var index:int = LevelManager.getInstance().getCurrentLevelIndex();
				FP.world = new GameWorld(lvl, index);
			});
			
			add(replayButton);
			
			if (win) {
				var nextButton:Option;
				if (LevelManager.getInstance().hasNextLevel()) {
					nextButton = new Option(NEXT_LEVEL, spritefont32, FP.halfWidth - (NEXT_LEVEL.length / 2) * 32, 390, function():void {
						var lvl:Class = LevelManager.getInstance().getNextLevel();
						var index:int = LevelManager.getInstance().getCurrentLevelIndex();
						FP.world = new GameWorld(lvl, index);
					});
				}
				else {
					nextButton = new Option(MAIN_MENU, spritefont32, FP.halfWidth - (MAIN_MENU.length / 2) * 32, 390, function():void {
						FP.world = new MainMenu;
					});
				}
				add(nextButton);
				
			}
			
		}
		
		override public function render():void
		{
			super.render();
			
			if (!win) {
				spritefont32.write(YOU_LOST, FP.buffer, FP.halfWidth - (YOU_LOST.length / 2) * 32, 20, 0x8570FF);
				spritefont32.write(MESSAGE_LOOSE_1, FP.buffer,  FP.halfWidth - (MESSAGE_LOOSE_1.length / 2) * 32, 100, 0x8570FF);
				spritefont32.write(MESSAGE_LOOSE_2, FP.buffer,  FP.halfWidth - (MESSAGE_LOOSE_2.length / 2) * 32, 140, 0x8570FF);
			}
			else {
				spritefont32.write(YOU_WIN, FP.buffer, FP.halfWidth - (YOU_WIN.length / 2) * 32, 20, 0x8570FF);
				spritefont32.write(MESSAGE_WIN_1, FP.buffer,  FP.halfWidth - (MESSAGE_WIN_1.length / 2) * 32, 100, 0x8570FF);
				spritefont32.write(String(score), FP.buffer,  FP.halfWidth - (String(score).length / 2) * 32, 140, 0x8570FF);
			}
		}
		
		override public function update():void
		{
			super.update();
		}
		
		
	}

}