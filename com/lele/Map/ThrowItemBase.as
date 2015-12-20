package com.lele.Map
{
	import com.lele.Map.Interface.IThrowItem
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Lele
	 */
	public class ThrowItemBase extends MovieClip implements IThrowItem
	{
		private var _callBack:Function;
		private var _from:Point;
		private var _to:Point;
		
		private var g:Number=-400;
		private var V:Number = 300;
		private var S:Number;
		private var theta:Number;
		private var af:Number;
		private var h:Number;
		private var isNeg:Boolean;
		private var t:Number;
		
		private var _From:Point;
		private var _To:Point;
		
		public function ThrowItemBase() 
		{
			isNeg = false;
			t = 0;
		}
		public function SetCallBack(callBack:Function)
		{
			_callBack = callBack;
		}
		public function get From():Point
		{
			return _From;
		}
		public function get To():Point
		{
			return _To;
		}
		public function Start(from:Point,to:Point)
		{
			_from = new Point(from.x, from.y);
			_to = new Point(to.x, to.y);
			_From = new Point(from.x, from.y);
			_To = new Point(to.x, to.y);
			
			if (_to.x == _from.x)
			{
				_to.x += 3;
			}
			if (_to.y == _from.y)
			{
				_to.y += 3;
			}
			if (_to.x < _from.x) 
			{ 
				isNeg = true; 
				_to = new Point(2 * _from.x - _to.x, _to.y);
			}
			do
			{
				V += 10;
				S = Math.sqrt((_to.y - _from.y) * (_to.y - _from.y) + (_to.x - _from.x) * (_to.x - _from.x));
				var M:Number = (Math.abs(g) * S) / (V * V);
				theta =180- ((Math.asin(M) * 360) / Math.PI)/2;
				af = (Math.atan((_to.y - _from.y) / (_to.x - _from.x)) * 360) / Math.PI;
			}
			while (isNaN(theta));
			this.addEventListener(Event.ENTER_FRAME, Every);
		}
		private function Every(evt:Event)
		{
			var x:Number = Getxp(t);
			var y:Number = Getyp(t);
			this.x = x;
			this.y = y;
			this.height = 18 * (h * 0.001 + 1);
			this.width = 18 * (h * 0.001 + 1);
			if (h < 0) 
			{
				this.removeEventListener(Event.ENTER_FRAME, Every);
				t = 0;
				isNeg = false;
				_callBack(new Point(this.x,this.y));
				return;	
			}
			t += (1 / 24);
		}
		function GetTemph(t:Number):Number
		{
			h = V * Math.sin(theta * Math.PI / 360) * t + (1 / 2) * g * t * t;
			return h;
		}
		function GetTemps(t:Number):Number
		{
			return V*Math.cos(theta*Math.PI/360)*t;
		}
		function Getx(t:Number):Number
		{
			return GetTemps(t)*Math.cos(af*Math.PI/360)+_from.x;
		}
		function Gety(t:Number):Number
		{
			return GetTemps(t)*Math.sin(af*Math.PI/360)+_from.y;
		}
		function Getxp(t:Number):Number
		{
			if (isNeg)
			{
				return 2 *_from.x - Getx(t);
			}
			return Getx(t);
		}
		function Getyp(t:Number):Number
		{
			return Gety(t) - GetTemph(t);
		}
		
	}

}