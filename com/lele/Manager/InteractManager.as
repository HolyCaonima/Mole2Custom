package com.lele.Manager
{
	import flash.events.MouseEvent;
	import com.lele.Manager.Interface.IReport;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.lele.Container.ContainerBase;
	import flash.geom.Point;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author Lele
	 */
	public class InteractManager extends Sprite implements IReport
	{
		private var _repoter:IReport;
		private var _container:ContainerBase;
		
		public function InteractManager(report:IReport,interactContainer:ContainerBase) 
		{
			_repoter = report;
			_container = interactContainer;
		}
		
		public function OnReport(evt:Event):void
		{
			
		}
		
		public function MouseClickMode(style:Sprite, OnClick:Function)
		{
			var sjb:Sprite = new Sprite();//这个过来的sprite有病，会发癫
			sjb.addChild(style);
			var _OnClick:Function = function(evt:MouseEvent):void{
				OnClick(new Point(mouseX,mouseY)); 
				sjb.removeEventListener(MouseEvent.CLICK, _OnClick);
			}
			
			sjb.addEventListener(Event.ENTER_FRAME, MouseClickMode_everyFrame);
			sjb.addEventListener(MouseEvent.CLICK, MouseClickMode_onClick);
			sjb.addEventListener(MouseEvent.CLICK, _OnClick);
			
			_container.addChild(sjb);
			
			Mouse.hide();
		}
		private function MouseClickMode_onClick(evt:MouseEvent)
		{
			(evt.target as Sprite).removeEventListener(MouseEvent.CLICK, MouseClickMode_onClick);
			(evt.target as Sprite).removeEventListener(Event.ENTER_FRAME, MouseClickMode_everyFrame);
			(evt.target as Sprite).parent.removeChild((evt.target as Sprite));
			Mouse.show();
		}
		private function MouseClickMode_everyFrame(evt:Event)
		{
			(evt.target as Sprite).x = mouseX-(evt.target as Sprite).width/2; 
			(evt.target as Sprite).y = mouseY-(evt.target as Sprite).height/2;
		}
		
	}

}