package com.lele.Map.Interface
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lele
	 */
	public interface IMaskObj 
	{
		function get FacialDepth():int;
		function Start(target:Sprite, hit:Boolean, OnEnter:Function, OnLeave:Function):void;
		function Stop(targ:Sprite):void;
		function IsHiting(targ:Sprite):Boolean;
	}
	
}