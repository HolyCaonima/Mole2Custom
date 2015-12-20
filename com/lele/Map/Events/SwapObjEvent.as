package com.lele.Map.Events
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Lele
	 */
	public class SwapObjEvent extends Event//对mask用的交换maskedObj之后的obj和targetObj
	{
		public static const SWAPOBJ_MASK:String="交换对象";
		private var swapObj:Sprite;
		private var addIn:Boolean;//true为加入遮罩， false为移出遮罩
		
		public function SwapObjEvent() 
		{
			super(SWAPOBJ_MASK);
		}
		
		public function get SwapObj():Sprite
		{
			return swapObj;
		}
		public function set SwapObj(swaps:Sprite):void
		{
			swapObj = swaps;
		}
		public function get AddIn():Boolean
		{
			return addIn;
		}
		public function set AddIn(state:Boolean):void
		{
			addIn = state;
		}
		override public function clone():Event 
		{
			var tempEvent = new SwapObjEvent();
			tempEvent.swapObj = swapObj;
			tempEvent.addIn = addIn;
			return tempEvent;
		}
	}

}