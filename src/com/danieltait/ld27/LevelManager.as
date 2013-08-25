package com.danieltait.ld27 
{
	/**
	 * ...
	 * @author Taiters
	 */
	public class LevelManager 
	{
		private var levels:Array;
		private static var instance:LevelManager;
		
		private var currentLevel:int;
		
		public function LevelManager() 
		{
			levels = [];
			levels.push(Resources.LEVEL_1);
			levels.push(Resources.LEVEL_2);
			currentLevel = -1;
		}
		
		public static function getInstance():LevelManager
		{
			if (instance == null) {
				instance = new LevelManager;
			}
			return instance;
		}
		
		public function getNextLevel():Class
		{
			currentLevel++;
			if (levels.length > currentLevel) {
				return levels[currentLevel];
			}
			return null;
		}
		
		public function hasNextLevel():Boolean
		{
			if (levels.length > currentLevel + 1) {
				return true;
			}
			return false;
		}
		
		public function getCurrentLevel():Class
		{
			if (levels.length > currentLevel) {
				return levels[currentLevel];
			}
			return null;
		}
		
		public function getCurrentLevelIndex():int
		{
			return currentLevel;
		}
		public function reset():void
		{
			currentLevel = -1;
		}
	}

}