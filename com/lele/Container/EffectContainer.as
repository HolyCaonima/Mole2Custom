package com.lele.Container
{
	import com.lele.Plugin.ScreenShoot.ScreenShooter;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Lele
	 */
	public class EffectContainer extends Sprite
	{
		private var _screenShooter:ScreenShooter;
		private var _resourceHolder:Sprite;
		private var _maskHolder:Sprite;
		private var _frontDisplay:Sprite;//前景
		private var _backDisplay:Sprite;//后景
		private var _triggedTime:Number;
		
		public function EffectContainer() 
		{
			_frontDisplay = new Sprite();
			_backDisplay = new Sprite();
			_resourceHolder = new Sprite();
			_screenShooter = new ScreenShooter();
			this.addChild(_backDisplay);
			this.addChild(_frontDisplay);
			_frontDisplay.alpha = 0;
		}
		public function Shoot(disp1:DisplayObject, disp2:DisplayObject)//截屏
		{
			var tempContainer:Sprite = new Sprite();
			tempContainer.addChild(disp1);
			tempContainer.addChild(disp2);
			_resourceHolder=_screenShooter.ShootScreen(tempContainer);
		}
		public function UnShowAndTurnDark()
		{
			_maskHolder = new Sprite();
			_maskHolder.graphics.beginFill(0x000000);
			_maskHolder.graphics.drawRect(0, 0, _resourceHolder.width, _resourceHolder.height);
			_maskHolder.graphics.endFill();
			if (_frontDisplay.numChildren>0) { _frontDisplay.removeChildAt(0); }
			_frontDisplay.addChild(_maskHolder);
			if (_backDisplay.numChildren>0) { _backDisplay.removeChildAt(0); }
			_backDisplay.addChild(_resourceHolder);
			_triggedTime = (new Date()).time;
			this.addEventListener(Event.ENTER_FRAME, UnShowAndTurnDarkEveryFrame);
		}
		private function UnShowAndTurnDarkEveryFrame(evt:Event)//渐黑
		{
			var tempTime:Date = new Date();
			if (_triggedTime+1000 > tempTime.time)//当在工作范围内
			{
				_frontDisplay.alpha = (1 - ((_triggedTime+1000) - tempTime.time) / 1000)*0.5;
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME,UnShowAndTurnDarkEveryFrame);//终止这个函数
			}
		}
		public function ShowAndTurnBright()
		{	
			if (_backDisplay.numChildren>0) { _backDisplay.removeChildAt(0); }
			_triggedTime = (new Date()).time;
			this.addEventListener(Event.ENTER_FRAME, ShowAndTurnBrightEveryFrame);
		}
		private function ShowAndTurnBrightEveryFrame(evt:Event)
		{
			var tempTime:Date = new Date();
			if (_triggedTime+1000 > tempTime.time)//当在工作范围内
			{
				_frontDisplay.alpha = (((_triggedTime+1000) - tempTime.time) / 1000) * 0.5;
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, ShowAndTurnBrightEveryFrame);//终止这个函数
				if (_frontDisplay.numChildren>0) { _frontDisplay.removeChildAt(0); }	
			}
		}
		
	}

}