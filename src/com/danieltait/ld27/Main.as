package com.danieltait.ld27
{
	import com.danieltait.ld27.worlds.GameWorld;
	import com.danieltait.ld27.worlds.MainMenu;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;

	public class Main extends Engine 
	{
		
		public function Main() 
		{
			super(640, 480, 60, false);
			
			AudioManager.getInstance().addSound("Shot", new Sfx(Resources.SHOOT))
				.addSound("Hit", new Sfx(Resources.HIT))
				.addSound("Song", new Sfx(Resources.SONG))
				.addSound("Flashback", new Sfx(Resources.FLASHBACK))
				.addSound("PlayerDie", new Sfx(Resources.PLAYER_DIE))
				.loopSound("Song", 0.5);
			
			FP.world = new MainMenu;
		}
		
	}
	
}