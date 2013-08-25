package com.danieltait.ld27
{
	import com.danieltait.ld27.worlds.GameWorld;
	import com.danieltait.ld27.worlds.MainMenu;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	public class Main extends Engine 
	{
		
		public function Main() 
		{
			super(640, 480, 60, false);
			FP.world = new MainMenu;
		}
		
	}
	
}