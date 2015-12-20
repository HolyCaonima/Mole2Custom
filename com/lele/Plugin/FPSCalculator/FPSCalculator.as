package com.lele.Plugin.FPSCalculator
{    
   
    //imports  
   
	import flash.display.Sprite;
	import flash.display.Stage;
    import flash.events.Event;  
	import flash.events.TimerEvent;
	import flash.text.TextField;
    import flash.utils.getTimer;  
    import flash.display.MovieClip;  
	import flash.utils.Timer;
   
    public class FPSCalculator extends MovieClip {  
   
        //variable to hold the current time  
        private var currentTime:int = 0;
		private var fps:Number;
		private var txtContainer:TextField;
		
		private var myTimer:Timer;
   
        public function FPSCalculator(stage:Stage,tf:TextField) 
		{  
            //add the enter frame listener, this is fired when the SWF updates to a new frame  
            stage.addEventListener(Event.ENTER_FRAME, onFrameLoop);
			txtContainer = tf;
			myTimer = new Timer(1000, 0);
			myTimer.addEventListener(TimerEvent.TIMER, OnTxtChange);
			myTimer.start();
        }  
   
        private function onFrameLoop (evt:Event):void
		{  
            //for the sanity of the fellow developers, try to put each task into a seperate function.  
            //this makes it infinitely easier to read for them and yourself on a large project or when you come back to and old one  
            //since the getTimer() function returns the played time in milliseconds and we want FPSecond, we divide it into 1000  
            fps= Math.round((1000 / timeDifference));  
        }
		private function OnTxtChange(evt:TimerEvent)
		{
			txtContainer.text ="fps: "+fps.toString();
		}
        //this is a get function so it can be referenced just like a variable, without the brackets on the end like a normal function  
        private function get timeDifference ():int
		{  
   
            //the getTimer() function returns the total played time of the SWF in milliseconds  
            var totalPlayedTime:int = getTimer();  
   
            //The difference in time from the previous frame to this frame will to calculated here  
            var timeDifference:int = (totalPlayedTime - currentTime);  
   
            //The currentTime is set to the total played time so it is ready for the next frame  
            currentTime = getTimer();     
   
            //return the difference in time  
            return timeDifference  
        }  
    }  
}  