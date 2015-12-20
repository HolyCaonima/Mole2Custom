package com.lele.Map.Interface
{
	
	/**
	 * ...
	 * @author Lele
	 */
	public interface IClickAble 
	{
		function OnClick():Boolean;//Exit?//返回一个标准返回态度的决定,即是否让ControllerBase中函数的子函数继续执行 ,当true则不再执行后续函数
		function get _x():Number;
		function get _y():Number;
		function get _width():Number;
		function get _height():Number;
	}
	
}