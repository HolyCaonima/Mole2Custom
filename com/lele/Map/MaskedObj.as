
package com.lele.Map
{
	import com.lele.Map.Interface.IMaskObj;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import com.lele.Map.Events.SwapObjEvent;

	/**
	 * ...
	 * @author Lele
	 */
	public class MaskedObj extends MovieClip implements IMaskObj//非完整性实现，抽象类，必须继承
	{
		protected var point:Point;
		private var targets:Array = new Array();
		protected var main:Sprite;
		protected var hitType:int = 2;
		protected var upSideDown:Boolean = true;
		protected var facialDepth:int;
		
		private var recycleEvt:SwapObjEvent;
		/*private var hitState:Boolean = false;//是否发生碰撞
		private var target:Sprite;
		private var onEnter:Function;
		private var onLeave:Function;*/
		
		public function MaskedObj() 
		{
			facialDepth = 1;
		}
		private function HitTest(evt:Event):void
		{
			for (var a in targets)//目前同时使用两种遮罩方案
			{
				switch(hitType)
				{
					case 0:
						tinyHitTestOne(targets[a]);
						break;
					case 1:
						tinyHitTestTwo(targets[a]);
						break;
					case 2:
						tinyHitTestThree(targets[a]);
						break;
				}
			}
		}
		private function tinyHitTestThree(smt:smallTarget)
		{
			if (recycleEvt == null) { recycleEvt = new SwapObjEvent(); }
			if (smt.target.hitTestObject(this as Sprite))//如果碰撞上
			{
				if (smt.target.y > this.y)
				{
					recycleEvt.SwapObj = smt.target;
					recycleEvt.AddIn = false;
					this.dispatchEvent(recycleEvt);
				}
				else
				{
					recycleEvt.SwapObj = smt.target;
					recycleEvt.AddIn = true;
					this.dispatchEvent(recycleEvt);
				}
			}
		}
		private function tinyHitTestTwo(smT:smallTarget)
		{
			if (smT == null) { trace("enter is null"); return; }
			var st:Boolean = false;
			var rt:Boolean = false;//作为判断上下方向是否改变的参数
			if (smT.target.hitTestObject(this as Sprite)) st = true;
			if (st)//如果碰撞了
			{
				if (point != null)
				{
					if (smT.target.y - point.y < 0) { rt = true; }//在上面
					else { rt = false; }
				}
				else
				{
					if (smT.target.y - this.y < 0) { rt = true; }//在上面
					else { rt = false; }
				}
				if (rt!=smT.typetwo)//如果状态变化
				{
					if (rt)//在上面需要遮罩
					{
						var sw:SwapObjEvent = new SwapObjEvent();
						sw.SwapObj = smT.target;
						sw.AddIn = true;
						this.dispatchEvent(sw);
					}
					else//在下面，不需要遮罩
					{
						var sw:SwapObjEvent = new SwapObjEvent();
						sw.SwapObj = smT.target;
						sw.AddIn = false;
						this.dispatchEvent(sw);
					}
					smT.typetwo = rt;
				}
			}
			if (st == smT.hitState) return;//如果状态不变
			smT.hitState = st;
			if (!smT.hitState)//满足上述标准
			{
				var sw:SwapObjEvent = new SwapObjEvent();
				sw.SwapObj = smT.target;
				sw.AddIn = false;
				this.dispatchEvent(sw);
				if (smT.onLeave != null) { smT.onLeave(); }
			}
			else
			{
				if (point != null)
				{
					if (smT.target.y - point.y < 0) { rt = true; }//在上面
					else { rt = false; }
				}
				else
				{
					if (smT.target.y - this.y < 0) { rt = true; }//在上面
					else { rt = false; }
				}
				if (rt)//在上面需要遮罩
				{
					var sw:SwapObjEvent = new SwapObjEvent();
					sw.SwapObj = smT.target;
					sw.AddIn = true;
					this.dispatchEvent(sw);
				}
			}
		}
		private function tinyHitTestOne(smT:smallTarget)
		{
			if (smT == null) { trace("enter is null"); return; }
			var st:Boolean = false;
			if (smT.target.hitTestObject(this as Sprite)) st = true;
			if (smT.isGoDown)
			{
				if (point != null)
				{
					if (smT.target.y - point.y > 0)
					{
						var sw:SwapObjEvent = new SwapObjEvent();
						sw.SwapObj = smT.target;
						sw.AddIn = false;
						this.dispatchEvent(sw);
						smT.isGoDown = false;
						if (smT.onLeave != null) { smT.onLeave(); }
					}
				}
				else
				{
					if (smT.target.y - this.y > 0)
					{
						var swe:SwapObjEvent = new SwapObjEvent();
						swe.SwapObj = smT.target;
						swe.AddIn = false;
						this.dispatchEvent(swe);
						smT.isGoDown = false;
						if (smT.onLeave != null) { smT.onLeave(); }
					}
				}
			}
			if (st == smT.hitState) return;//如果状态不变
			smT.hitState = st;
			if (smT.hitState)//满足上述标准
			{
				//trace("物体进入");
				if (point != null)//临时解决办法
				{
					if (smT.target.y - point.y < 0) 
					{
						var swpEvt:SwapObjEvent = new SwapObjEvent();
						swpEvt.SwapObj = smT.target;
						swpEvt.AddIn = true;
						this.dispatchEvent(swpEvt);
						smT.isGoDown = true;
					}
				}
				else
				{
					if (smT.target.y - this.y<0) 
					{
						var swpEv:SwapObjEvent = new SwapObjEvent();
						swpEv.SwapObj = smT.target;
						swpEv.AddIn = true;
						this.dispatchEvent(swpEv);
						smT.isGoDown = true;//从上往下走是个特殊情况，当坐标点穿出是临界
					}
				}
				if (smT.onEnter != null) { smT.onEnter(); }
			}
			else
			{
				//trace("物体离开");
				var swEvt:SwapObjEvent = new SwapObjEvent();
				swEvt.SwapObj = smT.target;
				swEvt.AddIn = false;
				this.dispatchEvent(swEvt);
				smT.isGoDown = false;
				if (smT.onLeave != null) { smT.onLeave(); }
			}
		}
		public function Start(target:Sprite,hit:Boolean,OnEnter:Function,OnLeave:Function):void
		{
			targets.push(new smallTarget(target,hit, OnEnter, OnLeave));
			if(targets.length==1)
			this.addEventListener(Event.ENTER_FRAME, HitTest);
		}
		public function Stop(targ:Sprite):void
		{
			var temp:smallTarget;
			for (var a in targets)
			{
				if ((targets[a] as smallTarget).target == targ)
				temp =targets[a];
			}
			if (temp == null) return;
			temp.onEnter = null;
			temp.onLeave = null;
			temp.target = null;
			targets.splice(targets.indexOf(temp), 1);
			if(targets.length==0)
			this.removeEventListener(Event.ENTER_FRAME, HitTest);
		}
		public function IsHiting(targ:Sprite):Boolean
		{
			for (var a in targets)
			{
				if ((targets[a] as smallTarget).target == targ)
					return (targets[a] as smallTarget).hitState;
			}
			return undefined;
		}
		public function get FacialDepth():int
		{
			return facialDepth;
		}
	}
}
import flash.display.Sprite;
class smallTarget//这个目标是玩家
{
	public var target:Sprite;
	public var hitState:Boolean;
	public var isGoDown:Boolean = false;
	public var typetwo:Boolean = false;//Type2的参数
	public var onEnter:Function;
	public var onLeave:Function;
	
	public function smallTarget(ta:Sprite, hit:Boolean, onE:Function, onL:Function)
	{
		target = ta;
		hitState = hit;
		onEnter = onE;
		onLeave = onL;
	}
}