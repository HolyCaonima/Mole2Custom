package com.lele.Map
{
	import flash.display.MovieClip;
	import com.lele.Map.Interface.IClickAble;
	/**
	 * ...
	 * @author Lele
	 */
	public class ClickObjBase extends MovieClip implements IClickAble//抽象类，只能继承
	{
		protected var X_offset:Number;
		protected var Y_offset:Number;
		
		public function ClickObjBase() 
		{
			X_offset = 0;
			Y_offset = 0;
		}
		public function OnClick():Boolean//返回一个标准返回态度的决定,即是否让ControllerBase中函数的子函数继续执行
		{
			return true;
		}
		public function get _x():Number
		{
			return this.x+X_offset;
		}
		public function get _y():Number
		{
			return this.y + Y_offset;
		}
		public function get _width():Number
		{
			return this.width;
		}
		public function get _height():Number
		{
			return this.height;
		}
		
	}

}