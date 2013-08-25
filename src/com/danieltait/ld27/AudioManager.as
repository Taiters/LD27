package com.danieltait.ld27 
{
	import flash.utils.Dictionary;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.sound.SfxFader;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Taiters
	 */
	public class AudioManager 
	{
		
		private var sounds:Dictionary;
		private static var instance:AudioManager;
		private var world:World;
		
		public function AudioManager() 
		{
			sounds = new Dictionary;
		}
		
		public static function getInstance():AudioManager
		{
			if (instance == null) {
				instance = new AudioManager;
			}
			return instance;
		}
		
		public function setWorld(world:World):void
		{
			this.world = world;
		}
		
		public function addSound(name:String, sound:Sfx):AudioManager
		{
			sounds[name] = sound;
			return this;
		}
		
		public function playSound(name:String, vol:Number = 1, pan:Number = 0 ):void
		{
			(sounds[name] as Sfx).play(vol, pan);
		}
		
		public function loopSound(name:String, vol:Number = 1, pan:Number = 0 ):void
		{
			(sounds[name] as Sfx).loop(vol, pan);
		}
		
		public function stopSound(name:String):void
		{
			(sounds [name] as Sfx).stop();
		}
		
		public function crossFade(from:String, to:String, loop:Boolean = false, duration:Number = 1, vol:Number = 1):void
		{
			var fader:SfxFader = new SfxFader((sounds[from] as Sfx));
			fader.crossFade((sounds[to] as Sfx), loop, duration, vol);
			world.addTween(fader, true);
		}
		
		public function fadeTo(name:String, vol:Number, duration:Number = 1):void
		{
			var fader:SfxFader = new SfxFader((sounds[name] as Sfx));
			fader.fadeTo(vol, duration);
			world.addTween(fader, true);
		}
		
		public function getSound(name:String):Sfx
		{
			return sounds[name] as Sfx;
		}
		
	}

}