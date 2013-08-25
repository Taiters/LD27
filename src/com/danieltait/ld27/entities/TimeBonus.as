package com.danieltait.ld27.entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import com.danieltait.ld27.Resources;
	/**
	 * ...
	 * @author Taiters
	 */
	public class TimeBonus extends Entity
	{
		
		public static const ROTATION_SPEED:int = 50;
		
		private var image:Image;
		public function TimeBonus() 
		{
			image = new Image(Resources.TIMEBONUS);
			image.centerOO();
			
			this.graphic = image;
			
			this.setHitbox(image.width, image.height);
			this.type = "TimeBonus";
			this.centerOrigin();
		}
		
		override public function update():void
		{
			this.image.angle += ROTATION_SPEED * FP.elapsed;
		}
		
	}

}