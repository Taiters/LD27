package com .danieltait.ld27.worlds
{
	import com.danieltait.ld27.entities.Player;
	import com.danieltait.ld27.entities.ShadowPlayer;
	import com.danieltait.ld27.PlayerData;
	import com.danieltait.ld27.Queue;
	import net.flashpunk.World;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Taiters
	 */
	public class GameWorld extends World
	{
		public function GameWorld() 
		{
			var shadow:ShadowPlayer = new ShadowPlayer;
			this.add(new Player(shadow));
			this.add(shadow);
		}
	}

}