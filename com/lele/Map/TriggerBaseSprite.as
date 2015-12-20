package com.lele.Map
{
	import com.lele.Map.Enum.TriggerType;
	import com.lele.Map.Interface.ITrigger;
	import com.lele.MathTool.LeleMath;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lele
	 */
	public class TriggerBaseSprite extends Sprite implements ITrigger
	{
		public var X_offset:Number;
		public var Y_offset:Number;
		
		public function TriggerBaseSprite()
		{
			X_offset = 0;
			Y_offset = 0;
		}
		public function OnTrigge():void
		{
		}
		public function get _x():Number
		{
			return this.x+X_offset;
		}
		public function get _y():Number
		{
			return this.y+Y_offset;
		}
		public function get _height():Number
		{
			return this.height;
		}
		public function get _width():Number
		{
			return this.width;
		}
		public function get _triggerType():TriggerType
		{
			return TriggerType.STANDSTILL;
		}
		public function IsMeetTerm(point:Point):Boolean
		{
			if (!LeleMath.CheckArea(point.x, _x + _width / 2, x - _width / 2))
			return false;
			if (!LeleMath.CheckArea(point.y, _y + _height / 2, y - _height / 2))
			return false;
			return true;
		}
		
	}

}