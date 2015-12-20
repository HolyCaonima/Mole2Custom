package com.lele.Plugin.Rain 
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	
	
	public class RainMC extends MovieClip 
	{
		private var _times:int=0;
		private var bg:Sprite;
		
		public function RainMC() 
		{
			if(_times>6){_times=6;}
			var sp:Sprite=new Sprite();
			sp.graphics.beginFill(0x000000,1);
			sp.graphics.drawRect(0,0,960,540);
			sp.graphics.endFill();
			sp.alpha = 0;
			sp.cacheAsBitmap=true;
			this.addChild(sp);
			bg = sp;
		}
		
		public function set times(time:int)
		{
			_times = time;
			bg.alpha = (time / 12)*0.6;
		}
		
		private function EveryFrame(evt:Event)
		{
			if (this.numChildren > _times *40) { return; }
			for(var a:int=0;a<_times;a++)
			{
			var temp:RainStyle=new RainStyle(OnStop);
			this.addChild(temp);
			temp.x=Math.random()*980;
			temp.y=Math.random()*400+140;
			temp.width*=(temp.y-140)/800;
			temp.height*=(temp.y-140)/180;
			temp.cacheAsBitmap=true;
			temp.play();
			}
		}
		
		private function OnStop(sourceR:RainStyle)
		{
			sourceR.stop();
			this.removeChild(sourceR);
		}
		
		public function StopRain()
		{
			this.removeEventListener(Event.ENTER_FRAME, EveryFrame);
			try
			{
				this.removeChild(bg);
			}
			catch(er:Error){}
		}
		public function StartRain()
		{
			try { this.removeChild(bg); }
			catch (er:Error) { }
			this.addChild(bg);
			this.addEventListener(Event.ENTER_FRAME,EveryFrame);
		}
		
	}
	
}
