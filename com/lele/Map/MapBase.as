package com.lele.Map
{
	import com.lele.Controller.Avatar.Interface.IAvatar;
	import flash.display.BitmapEncodingColorSpace;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import com.lele.Map.Events.SwapObjEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Lele
	 */
	public class MapBase extends MovieClip
	{
		protected var maskedObj:Array;//这个地图对象包含的maskedObj组
		protected var depth:MovieClip;//玩家存在层
		
		private var hasStart:Boolean;
		private var playerArray:Array;
		//private var sourceLayer:int;//原层次
		//protected var tempBeMask:Array;//临时存放被遮罩对象的信息//考虑是否用来存放所有角色
		
		public function MapBase() 
		{
			maskedObj = new Array();
			hasStart = false;
			//tempBeMask = new Array();
		}
		private function PlayersMask(evt:Event)//对玩家之间的遮罩
		{
			playerArray = new Array();
			for (var a:int = 0; a < depth.numChildren; a++ )
			{
				if ((depth.getChildAt(a) is MaskedObj) || (depth.getChildAt(a) is MaskedObj_Sprite)) { continue; }
				playerArray.push(depth.getChildAt(a));
			}//得到玩家组
			
			
			for (var a:int = 0; a < depth.numChildren; a++ )
			{
				for (var b:int = a; b < depth.numChildren-1; b++ )
				{
					if ((depth.getChildAt(b + 1) is MaskedObj || depth.getChildAt(b + 1) is MaskedObj_Sprite)&&(depth.getChildAt(b ) is MaskedObj || depth.getChildAt(b ) is MaskedObj_Sprite))
					{
						continue;
					}
					if (depth.getChildAt(b).y > depth.getChildAt(b + 1).y)
					{
						depth.addChildAt(depth.getChildAt(b + 1), b);
					}
				}
			}
			/*var indexHead:int = -1;
			for (var a:int =0; a < depth.numChildren; a++ )
			{
				if (depth.getChildAt(a) is MaskedObj_Sprite || depth.getChildAt(a) is MaskedObj)
				{
					LineAreaPlayerBetween(indexHead, a);
					indexHead = a;
				}
			}
			LineAreaPlayerBetween(indexHead, depth.numChildren);*/
		}
		private function LineAreaPlayerBetween(indexHead:int, indexTail:int)//对一段区间的玩家进行深度排序
		{
			if (indexTail - indexHead < 3) {return; }
			for (var a:int = indexHead + 1; a < indexTail-1; a++ )
			{
				for (var b:int = a + 1; b < indexTail; b++ )
				{
					if ((depth.getChildAt(a) as Sprite).y > (depth.getChildAt(b) as Sprite).y)
					{
						depth.addChildAt(depth.getChildAt(b), a);
					}
				}
			}
		}
		private function DepthAdd(sp:Sprite)
		{
			var hasAdd:Boolean = false;
			for (var a:int = 0; a < depth.numChildren; a++ )
			{
				if (depth.getChildAt(a) is MaskedObj || depth.getChildAt(a) is MaskedObj_Sprite&&depth.getChildAt(a).y>sp.y)
				{
					depth.addChildAt(sp, a);
					hasAdd = true;
				}
			}
			if (!hasAdd)
			{
				depth.addChild(sp);
			}
		}
		public function StartMask(target:IAvatar,isHit:Boolean=false,OnEnter:Function=null,OnLeave:Function=null)
		{
			var targetObj = target.Avatar;
			//这里加入时应该给一个正确的深度位置
			DepthAdd(targetObj);
			//原版是这样，但是现在暂时不用
			/*for (var a in maskedObj)//当需要交换时maskedObj发出事件，通知map交换Obj
			{
				if (maskedObj[a] as MaskedObj == null) { continue; }
				(maskedObj[a] as MaskedObj).addEventListener(SwapObjEvent.SWAPOBJ_MASK, OnSwapObj);//对maskedObj添加OnSwapObj的监听器，当交换时
				(maskedObj[a] as MaskedObj).Start(targetObj, isHit, OnEnter, OnLeave);//调用maskedObj开始进行循环碰撞检测和监听
			}
			for (var a in maskedObj)
			{
				if (maskedObj[a] as MaskedObj_Sprite == null) { continue; }
				(maskedObj[a] as MaskedObj_Sprite).addEventListener(SwapObjEvent.SWAPOBJ_MASK, OnSwapObj);//对maskedObj添加OnSwapObj的监听器，当交换时
				(maskedObj[a] as MaskedObj_Sprite).Start(targetObj, isHit, OnEnter, OnLeave);//调用maskedObj开始进行循环碰撞检测和监听
			}*/
			if (!hasStart)
			{
				this.addEventListener(Event.ENTER_FRAME, PlayersMask);
				hasStart = true;
			}
		}
		public function StopMask(targetObj:Sprite)
		{
			//原版是这样，但是现在暂时不用
			/*for (var a in maskedObj)
			{
				if (maskedObj[a] as MaskedObj == null) { continue; }
				(maskedObj[a] as MaskedObj).Stop(targetObj);
			}
			for (var a in maskedObj)
			{
				if (maskedObj[a] as MaskedObj_Sprite == null) { continue; }
				(maskedObj[a] as MaskedObj_Sprite).Stop(targetObj);
			}*/
			depth.removeChild(targetObj);
		}
		public function StopMaskListener():void //这个在后期要改写，也许在map中加入要mask的对象的数组
		{
			for (var a in maskedObj)
			{
				if (maskedObj[a] as MaskedObj == null) { continue; }
				(maskedObj[a] as MaskedObj).removeEventListener(SwapObjEvent.SWAPOBJ_MASK, OnSwapObj);
			}
			for (var a in maskedObj)
			{
				if (maskedObj[a] as MaskedObj_Sprite == null) { continue; }
				(maskedObj[a] as MaskedObj_Sprite).removeEventListener(SwapObjEvent.SWAPOBJ_MASK, OnSwapObj);
			}
			if(hasStart)
			this.removeEventListener(Event.ENTER_FRAME, PlayersMask);
		}
		public function Clean()
		{
			for (var a:int = 0; a < depth.numChildren; a++ )
			{
				depth.removeChildAt(0);
			}
		}
		protected function OnSwapObj(evt:SwapObjEvent):void
		{
			/*var beMaskObj:Object = GetBeMaskedObj(evt.SwapObj as Sprite);//evt.target是maskedObj就是地图上的遮挡景物发出的
			if (beMaskObj == null) 
			{
				beMaskObj= new Object(); 
				beMaskObj.maskedObj = evt.SwapObj as Sprite; 
				beMaskObj.depth = this.getChildIndex(evt.SwapObj as Sprite);
				tempBeMask.push(beMaskObj);
				//说明是新加入的则加入
			}*/
			if (evt.AddIn)//加入
			{
				//beMaskObj.depth = this.getChildIndex(evt.SwapObj as Sprite);
				//sourceLayer = depth.getChildIndex(evt.SwapObj);
				if (depth.getChildIndex(evt.SwapObj as Sprite) < depth.getChildIndex(evt.target as Sprite)) { return; }
				var tempPos:int = depth.getChildIndex(evt.target as Sprite);
				depth.addChildAt(evt.SwapObj as Sprite,tempPos);
			}
			else//移除
			{
				if (depth.getChildIndex(evt.target as Sprite) < depth.getChildIndex(evt.SwapObj as Sprite)) { return; }
				var tempPos:int = depth.getChildIndex(evt.target as Sprite);
				AddPlayerAt(evt.SwapObj as Sprite,tempPos);
				//AddPlayerAt(evt.SwapObj as Sprite,sourceLayer-1);
			}
		}
		
		protected function AddPlayer(player:Sprite):void //将play放置在地图合适的层中
		{
			depth.addChild(player);//需要重写吧
		}
		protected function AddPlayerAt(player:Sprite,index:int):void//在指定位置加入
		{
			depth.addChildAt(player, index);
		}
		/*protected function GetBeMaskedObj(maskedObj:Sprite):Object//这个Obj是包含原深度信息的 Obj.maskedObj 是被包装的Sprite Obj.depth 是对应的原始深度
		{
			for (var a in tempBeMask)
			{
				if (tempBeMask[a].maskedObj is Sprite)
				{
					return tempBeMask[a];
				}
			}
			return null;
		}*/
	}
}