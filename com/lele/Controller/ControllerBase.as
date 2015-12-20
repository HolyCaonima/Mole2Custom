package com.lele.Controller
{
	import com.lele.Controller.Interface.IControlMap;
	import com.lele.Map.Interface.IClickAble;
	import com.lele.MathTool.LeleMath;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Lele
	 */
	//控制器的基类，包含了两个事件，用函数自动注册和关闭，事件代码可重写
	public class ControllerBase extends Sprite//不可继承
	{
		private var controlable:Boolean;
		protected var _clickEnable:Boolean;
		protected var _controlMap:IControlMap;
		
		public function ControllerBase() 
		{
			controlable = false;
			_clickEnable = false;
		}
		public function get IsControlAble():Boolean
		{
			return controlable;
		}
		protected function SwitchOn(clickObj:Sprite):void
		{
			clickObj.addEventListener(MouseEvent.CLICK, OnMouseClick);
			clickObj.addEventListener(Event.ENTER_FRAME, EveryFrame);
			controlable = true;
		}
		protected function SwitchOff(clickObj:Sprite):void//事件统一调度，可点击的物件必须继承IClickAble而且得开启_clickEnable
		{
			clickObj.removeEventListener(MouseEvent.CLICK, OnMouseClick);
			clickObj.removeEventListener(Event.ENTER_FRAME, EveryFrame);
			controlable = false;
		}
		private function OnMouseClick(evt:MouseEvent)
		{
			if (!controlable) { return; }//终止，并且让子类不执行下去
			if (!_clickEnable) { return; }
			var temp:Array = _controlMap.ClickObj;
			var targetArray:Array = new Array();
			for (var b:int = 0; b < temp.length; b++ )
			{
				if (temp[b] is IClickAble)
				{
					targetArray.push(temp[b]);
				}
			}
			//添加拓展点击对象
			targetArray = CatchClickObj(targetArray, AdditionClickObj);
			for (var a in targetArray)
			{
				var clickA:IClickAble = targetArray[a] as IClickAble;
				if (LeleMath.CheckArea(evt.localX, clickA._x + clickA._width / 2, clickA._x - clickA._width / 2) &&
				LeleMath.CheckArea(evt.localY, clickA._y + clickA._height / 2, clickA._y - clickA._height / 2))
				{
					if (clickA.OnClick()) { return; }//如果OnClick函数决定退出则退出
				}
			}
			OnChildMouseClick(evt);
		}
		private function CatchClickObj(sourceArray:Array, targetArray:Array):Array
		{
			if (targetArray==null||targetArray.length == 0) { return sourceArray; }
			for (var a:int = 0; a < targetArray.length; a++ )
			{
				var flag:Boolean = true;
				for (var b:int = 0; b < sourceArray.length; b++ )
				{
					if (targetArray[a] == sourceArray[b]) { flag = false; break; }
				}
				if (flag) { sourceArray.push(targetArray[a]); }
			}
			return sourceArray;
		}
		protected function get AdditionClickObj():Array
		{
			return null;
		}
		//留给子类重写
		protected function OnChildMouseClick(evt:MouseEvent)
		{
		}
		protected function EveryFrame(evt:Event)
		{
		}
		
	}

}