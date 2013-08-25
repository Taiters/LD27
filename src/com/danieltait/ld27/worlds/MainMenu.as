package com.danieltait.ld27.worlds 
{
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
	import com.danieltait.ld27.LevelManager;
	/**
	 * ...
	 * @author Taiters
	 */
	public class MainMenu extends World
	{
		var spritefont:SpriteFont;
		var spinner:Image;
		
		public static const PLAY:String = "play";
		public static const HOW_TO:String = "how to";
		
		private var hover_play:Boolean = false;
		private var hover_how_to:Boolean = false;
		public function MainMenu() 
		{
			LevelManager.getInstance().reset();
			var image:Bitmap = new Resources.FONT32();
			spritefont = new SpriteFont(image.bitmapData.clone(), 8, 8, 32);
			
			spinner = new Image(Resources.FLASHBACKPOINT);
			spinner.scale = 3;
			spinner.alpha = 0.5;
			spinner.centerOO();
			spinner.x =  480;
			spinner.y = 180;
			addGraphic(spinner);
			
			addGraphic(new Image(Resources.TITLE), 0, 0, 0);
			
			var playButton:Option = new Option(PLAY, spritefont, FP.halfWidth - (PLAY.length / 2) * 32, 300, function():void {
				var level:Class = LevelManager.getInstance().getNextLevel();
				var levelIndex:int = LevelManager.getInstance().getCurrentLevelIndex();
				FP.world = new GameWorld(level,levelIndex);
			});
			
			add(playButton);
			
			var howToButton:Option = new Option(HOW_TO, spritefont,  FP.halfWidth - (HOW_TO.length / 2) * 32,340, function():void {
				FP.world = new HowTo;
			});
			
			add(howToButton);
			
			
		}
		
		override public function update():void
		{
			super.update();
			spinner.angle += 50 * FP.elapsed;
		}
		
		
	}

}