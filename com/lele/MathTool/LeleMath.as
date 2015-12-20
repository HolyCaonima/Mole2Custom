package com.lele.MathTool
{
	import flash.concurrent.Mutex;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lele
	 */
	public class LeleMath 
	{
		
		public function LeleMath() 
		{
			
		}
		public static function GetDistance(point1:Point, point2:Point):Number
		{
			return Math.sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
		}
		public static function CheckArea(num:Number, arg1:Number, arg2:Number):Boolean//计算是否超出定义域
		{
			//默认arg1大于arg2..注意，这里的陈述只对函数内部有效
			if (arg2 > arg1)
			{
				if (num > arg2)
				return false;
				if (num < arg1)
				return false;
				return true;
			}
			else//arg1>arg2
			{
				if (num > arg1)
				return false;
				if (num < arg2)
				return false;
				return true;
			}
			return false;//默认
		}
		public static function GetDigree(point1:Point, point2:Point):Number//返回一个角度,from->to
		{
			var arcSource:Number = (point2.x - point1.x) / Math.sqrt((point2.x - point1.x) * (point2.x - point1.x) + (point2.y - point1.y) * (point2.y - point1.y));
			if (point2.y < point1.y)
			{
				return 360.0 - Math.acos(arcSource) * (180.0 / Math.PI);
			}
			return Math.acos(arcSource) * (180.0 / Math.PI);
		}
		public static function DealRDifference(digree:Number):Number
		{
			return 360 - digree;
		}
		public static function GetDirectionSimple(digree:Number):String
		{
			if (digree > 360) { digree-= 360; }
			if (digree > 0 && digree <= 90)
			{
				return "ur";
			}
			if (digree > 90 && digree <= 180)
			{
				return "lu";
			}
			if (digree > 180 && digree <= 270)
			{
				return "dl";
			}
			if (digree > 270 && digree <= 360)
			{
				return "rd";
			}
			return "dl";
		}
		public static function GetDirection(digree:Number):String
		{
			if (digree > 360) { digree-= 360; }
			if (digree > 337.5 || digree <= 22.5)
			{
				return "rr";
			}
			if (digree > 22.5 && digree <= 67.5)
			{
				return "ur";
			}
			if (digree > 67.5 && digree <= 112.5)
			{
				return "uu";
			}
			if (digree > 112.5 && digree <= 157.5)
			{
				return "lu";
			}
			if (digree > 157.5 && digree <= 202.5)
			{
				return "ll";
			}
			if (digree > 202.5 && digree <= 247.5)
			{
				return "dl";
			}
			if (digree > 247.5 && digree <= 292.5)
			{
				return "dd";
			}
			if (digree > 292.5 && digree <= 337.5)
			{
				return "rd";
			}
			return "dd";
			
		}
		
		public static function NextGaussian2(a:Number, b:Number):Number //a为顶点,b为扁度
		{
			var r1:Number = Math.random();
			var r2:Number = Math.random();
			var u:Number = Math.sqrt((-2) * Math.log(r1)) * Math.cos(2 * Math.PI * r2);
			var z:Number = a + u * Math.sqrt(b); return (z);
		}
		
	}

}