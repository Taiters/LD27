package com.danieltait.ld27
{
	import flash.utils.ByteArray;
	public class Queue 
    {
		private var q:Array = [];
			public var l:int = 0;
		  
			public function Queue() { }

			public function write(d:*):void 
			{ 
				q[q.length] = d; l++; }

			public function read():* 
			{
				if (isEmpty)
				{
					return  null;
				}
				else
				{
					l--;
					return q.shift(); 
				}
			}
			public function get isEmpty():Boolean 
			{ 
				return (l <= 0); 
			}
			
			public function reset():void
			{
				q = [];
				l = 0;
			}

			public function peek():* 
			{
				return (isEmpty) ? null : q[0];
			}
			
			public function getContents():Array
			{
				return q.slice();
			}
    }
}