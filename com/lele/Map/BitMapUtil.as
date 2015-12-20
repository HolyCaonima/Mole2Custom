package com.lele.Map
{
	import com.lele.Map.Interface.IBitMapUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Lele
	 */
	public class BitMapUtil implements IBitMapUtil //目前功能，sprite转成bitmap并包含上色功能  //包装类建议不继承private var colorObj:Object = { canGo:4289555498, notGo:4294967295, special:4278229503 };
	{
		private var _bitData:BitmapData;
		private var _bitMap:Bitmap;
		private var _bitBlock:int;
		private var _bitSprite:Sprite;
		private var _bitMapWidth:int;
		private var _bitMapHight:int;
		private var _bitColorObj:Object
		public function BitMapUtil(sprite:Sprite,width:int,hight:int,block:int,bitColorObj:Object) 
		{
			_bitMapWidth = width;
			_bitMapHight = hight;
			_bitSprite = sprite;
			_bitBlock = block >= 2?block:2;
			_bitData = new BitmapData(_bitMapWidth, _bitMapHight);
			_bitData.draw(_bitSprite);
			_bitColorObj = bitColorObj;
		}
		//各种get set
		public function get BitMap():Bitmap
		{
			_bitMap = new Bitmap(_bitData);//创建最新数据的bitmap并返回
			return _bitMap;
		}
		public function get BitData():BitmapData
		{
			return _bitData;
		}
		public function get BitSourceWidth():int
		{
			return _bitMapWidth;
		}
		public function get BitSourceHight():int
		{
			return _bitMapHight;
		}
		public function get BitBlock():int
		{
			return _bitBlock;
		}
		//轻量函数
		public function CleanMapData()
		{
			_bitData = null;
			_bitData = new BitmapData(_bitMapWidth, _bitMapHight);
		}
		public function GetLengthX():int//加上block影响后的
		{
			return _bitMapWidth / _bitBlock;
		} 
		public function GetLengthY():int//加上block影响后的
		{
			return _bitMapHight / _bitBlock;
		}
		public function GetRectColor(x:int,y:int):uint//获取小矩形的颜色，处理过后的数据才可用这个函数
		{
			return _bitData.getPixel32(x*_bitBlock, y*_bitBlock);
		}
		public function GetRectState(x:int, y:int):int//处理过后的数据，经过block获取状态,0=notGo,1=canGo,2=special
		{
			var color:uint = GetRectColor(x, y);
			if (color == _bitColorObj.notGo)
			return 0;
			if (color == _bitColorObj.canGo)
			return 1;
			if (color == _bitColorObj.special)
			return 2;
			return 0;//默认不可走
		}
		
		
		
		
		//在图上绘制的函数
		public function DrawRect(x:int, y:int, color:uint, block:int)//从某一点开始画
		{
			for (var yy:int = y; yy < (y + 1) * block; yy++ )
			{
				for (var xx:int = x; xx < (x + 1) * block; xx++ )
				{
					_bitData.setPixel32(xx, yy, color);
				}
			}
		}
		public function DrawRectInMapResolution(x:int, y:int, color:uint)
		{
			x = x >= GetLengthX()?GetLengthX() - 1:x;
			y = y >= GetLengthY()?GetLengthY() - 1:y;
			SetRectPixelColor(x, y, color);
		}
		
		
		
		
		
		//一下是初始的DrawPixelMap和各内部函数
		public function DrawPixelMap():Bitmap//_bitColorObj不准为空//标准初始化函数
		{
			_bitData = new BitmapData(_bitMapWidth, _bitMapHight); 
			_bitData.draw(_bitSprite);
			if (_bitColorObj == null) { trace("标识色彩为空!"); return BitMap; }
			for (var y:int = 0; y < _bitMapHight/_bitBlock; y++)
			{
				for (var x:int = 0; x < _bitMapWidth/_bitBlock; x ++ )
				{
					var tempColor:uint = GetRectPixelColor(x, y);
					SetRectPixelColor(x, y, tempColor);
				}
			}
			return BitMap;
		}
		private function SetRectPixelColor(x:int, y:int,color:uint):void//,某分辨率缩放后的点,自动使用block,这时的状态已经是粗化后的点了,这个方法其实是未来不需要的
		{
			for (var yy:int = y * _bitBlock; yy < (y + 1) * _bitBlock; yy++ )
			{
				for (var xx:int = x * _bitBlock; xx < (x + 1) * _bitBlock; xx++ )
				{
					_bitData.setPixel32(xx, yy, color);
				}
			}
		}
		private function GetRectPixelColor(x:int, y:int):uint//根据block自动适应 测试用函数//处理模糊rect
		{
			var tempX:int = x * _bitBlock + _bitBlock / 2;
			var tempY:int = y * _bitBlock + _bitBlock / 2;
			var tempColor:uint = _bitData.getPixel32(tempX, tempY);//矩形中点颜色
			if (tempColor!=_bitColorObj.canGo&&tempColor!=_bitColorObj.notGo&&tempColor!=_bitColorObj.special)
			{
				//寻找新的可用像素
				tempColor = GetValuablePixelColor(x, y);
			}
			return tempColor;
		}
		private function GetValuablePixelColor(tx:int, ty:int):uint//,根据block自适应这个要保留,当色彩不对时用这个函数重采样
		{
			var outPixel32:uint;
			for (var yy:int = ty*_bitBlock; yy < (ty+1)*_bitBlock; yy++ )
			{
				for (var xx:int = tx*_bitBlock; xx < (tx+1)*_bitBlock; xx++ )
				{
					outPixel32 = _bitData.getPixel32(xx, yy);
					if (outPixel32 == _bitColorObj.canGo || outPixel32 == _bitColorObj.notGo || outPixel32 == _bitColorObj.special)
					return outPixel32;
				}
			}
			return _bitColorObj.notGo;
		}
		
	}

}