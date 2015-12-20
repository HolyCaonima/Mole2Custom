package com.lele.Map.Interface
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Lele
	 */
	public interface IBitMapUtil 
	{
		function get BitMap():Bitmap;
		function get BitData():BitmapData;
		function get BitSourceWidth():int;
		function get BitSourceHight():int;
		function get BitBlock():int;
		function CleanMapData();
		function GetLengthX():int;//加上block影响后的
		function GetLengthY():int;//加上block影响后的
		function GetRectColor(x:int, y:int):uint;//获取小矩形的颜色，处理过后的数据才可用这个函数
		function GetRectState(x:int, y:int):int;//处理过后的数据，经过block获取状态,0=notGo,1=canGo,2=special
		function DrawRect(x:int, y:int, color:uint, block:int);//从某一点开始画
		function DrawRectInMapResolution(x:int, y:int, color:uint);
		function DrawPixelMap():Bitmap;//_bitColorObj不准为空//标准初始化函数
	}
	
}