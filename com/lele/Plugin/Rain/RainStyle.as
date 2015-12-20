package com.lele.Plugin.Rain 
{
	
	import flash.display.MovieClip;
	
	
	public class RainStyle extends MovieClip {
		
		private var onStop:Function;
		
		public function RainStyle(father:Function) 
		{
			onStop=father;
			this.addFrameScript(74,frame74);
			this.stop();
			// constructor code
		}
		
		function frame74()
		{
			onStop(this);
		}
		
	}
	
}
