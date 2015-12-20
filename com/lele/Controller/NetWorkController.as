package com.lele.Controller
{
	import com.lele.Controller.Avatar.Events.Avatar_PlayerController_Event;
	import com.lele.Controller.Avatar.Events.NetWorkController_NetPlayerUnit_Event;
	import com.lele.Controller.Avatar.Interface.IAvatar;
	import com.lele.Map.BitMapUtil;
	import com.lele.MathTool.LeleMath;
	import com.lele.Controller.Avatar.CAvatar;
	import com.lele.Controller.Avatar.Enum.AvatarState;
	import com.lele.Controller.ControllerBase;
	import com.lele.Data.IAnimationData;
	import com.lele.Manager.Interface.IReport;
	import com.lele.Plugin.RoadFind.Interface.IRoadFinder;
	import com.lele.Plugin.RoadFind.Interface.IRoadMap;
	import com.lele.Plugin.RoadFind.RoadFinder;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Lele
	 */
	
	 //这里不要方向数据等等一切，都由对方主机发送.
		/*
		 * 基本思路是其他玩家的数据处理过程如寻路，等的过程由对等主机计算，本地不计算，本地只接收结果和动作，尽量减少多人带了的资源消耗
		 * 与此同时增加的网络流量我想不是什么问题。
		 * */
	public class NetWorkController extends Sprite implements IReport
	{
		//测试才改成Public
		private var _roadFinder:IRoadFinder;
		private var _roadMap:IRoadMap;
		
		public var _netAvatar:CAvatar;
		private var _netAvatarState:AvatarState;
		private var _netRoadNodes:Array;
		private var _netCurrentTarget:Point;
		private var _netCurrentChange:Array;
		private var _preTarget:Point;
		
		private var _needBrake:Boolean;
		private const _brakeDistance:int = 50;
		private const _enbleBrakeDistance:int = 200;
		
		private var _repoter:IReport;
		
		private var _netWalkingSpeed:Number;
		private const _netRuningSpeed:Number = 3.5;
		private const _netSwimmingSpeed:Number = 2;
		
		public function NetWorkController(moleAct:Object,resourcePack:IAnimationData,color:String,spawnPoint:Point,name:String) 
		{
			_netAvatarState = AvatarState.IDLE;//初始站立
			_netCurrentTarget = spawnPoint;
			_netWalkingSpeed = _netRuningSpeed;
			_netAvatar = new CAvatar(moleAct, resourcePack, false,color,name);
			_netAvatar.Avatar.x = spawnPoint.x;
			_netAvatar.Avatar.y = spawnPoint.y;
			_netAvatar.Repoter = this;
			_netAvatar.DoAction("stand", "dd");
			this.addEventListener(Event.ENTER_FRAME, EveryFrame);
		}
		public function set Repoter(repoter:IReport)
		{
			_repoter = repoter;
		}
		public function get AState():AvatarState
		{
			return _netAvatarState;
		}
		public function CreatController(roadMap:IRoadMap)
		{
			_roadMap = roadMap;
			_preTarget = new Point(_netAvatar.A_X, _netAvatar.A_Y);
			var colorObj:Object = { canGo:4289555498, notGo:4294967295, special:4278229503 };
			var bitMapUtil:BitMapUtil = new BitMapUtil(roadMap.Type_mc, 960, 540, 2, colorObj);
			_roadFinder = new RoadFinder();
			bitMapUtil.DrawPixelMap();
			_roadFinder.CreatRoadDataFromMapData(bitMapUtil);
			_netRoadNodes = new Array();
			_netRoadNodes.push(new Point(_preTarget.x, _preTarget.y));
		}
		public function AvatarStateCheck()
		{
			var tempState:int = _roadFinder.GetState(new Point(_netAvatar.A_X, _netAvatar.A_Y));
			if (tempState == 2&&_netAvatarState!=AvatarState.SWIM) //该游泳不游泳
			{
				if (_netAvatarState == AvatarState.WALK)
				{
					_netAvatarState = AvatarState.SWIM;
					directionHandle();
				}
				else
				{
					_netAvatarState = AvatarState.SWIM;
					DoAction("swim", "rd");
				}
				_netWalkingSpeed = _netSwimmingSpeed;
			}
			else if(tempState!=2&&_netAvatarState==AvatarState.SWIM)//不该游泳时游泳
			{
				_netAvatarState = AvatarState.IDLE;//设为静止
				_netWalkingSpeed = _netRuningSpeed;
				DoAction("stand", "dd");
				_needBrake = false;
			}
			
		}
		public function Move(targetPoint:Point)
		{
			var source:Point = new Point(_netAvatar.Avatar.x, _netAvatar.Avatar.y);
			if (_preTarget.x == Math.round(targetPoint.x) && _preTarget.y == Math.round(targetPoint.y)) { return; }//如果起点和终点一样驳回请求
			_preTarget = new Point(Math.round(targetPoint.x), Math.round(targetPoint.y));
			_roadFinder.FindRoad(source, CalculateTarget(source, targetPoint, 4));
			_netRoadNodes = _roadFinder.RoadNode;
			_netCurrentChange = _roadFinder.ChangeNode;
			_netCurrentTarget = _netRoadNodes[0];
			if(_netAvatarState!=AvatarState.WALK&&_netAvatarState!=AvatarState.SWIM)
			_netAvatarState = AvatarState.WALK;
			if (LeleMath.GetDistance(_netRoadNodes[_netRoadNodes.length - 1], _netRoadNodes[_netRoadNodes.length - 2]) > _enbleBrakeDistance) { _needBrake = true; }
		}
		public function DoAction(actName:String, actDir:String,callback:Function=null)
		{
			if (_netAvatarState == AvatarState.SWIM&&actName!="swim") { return; }
			_netAvatar.DoAction(actName, actDir,callback);
		}
		public function EveryFrame(evt:Event)
		{
			if (_netAvatarState==AvatarState.WALK||_netAvatarState==AvatarState.PLAY||_netAvatarState==AvatarState.SWIM)//动画都在这
			{
				if (_netCurrentTarget == null) { return; }
				if (Math.abs(_netAvatar.Avatar.x -_netCurrentTarget.x)<_netWalkingSpeed && Math.abs(_netAvatar.Avatar.y -_netCurrentTarget.y)<_netWalkingSpeed) 
				{
					_netAvatar.Avatar.x = _netCurrentTarget.x;
					_netAvatar.Avatar.y = _netCurrentTarget.y;
					if (_netCurrentChange != null&&_netCurrentChange.length>0&& _netCurrentTarget.equals(_netCurrentChange[0]))
					{
						if (_netAvatarState == AvatarState.WALK) 
						{
							_netAvatarState = AvatarState.SWIM;
							_netWalkingSpeed = _netSwimmingSpeed;
						}
						else if (_netAvatarState == AvatarState.SWIM) 
						{
							_netAvatarState = AvatarState.WALK; 
							_netWalkingSpeed = _netRuningSpeed;
						}
						_netCurrentChange.splice(0, 1);
					}
					if (_netCurrentTarget.equals(_netRoadNodes[_netRoadNodes.length - 1]))//到了
					{
						if (_netAvatarState == AvatarState.SWIM)
						{
							return;
						}
						_netAvatarState = AvatarState.IDLE; //设置站立状态
						_netAvatar.DoAction("stand", LeleMath.GetDirection((LeleMath.DealRDifference(LeleMath.GetDigree(_netRoadNodes[_netRoadNodes.length - 2], _netCurrentTarget)))));
					}
					_netCurrentTarget = _netRoadNodes[_netRoadNodes.indexOf(_netCurrentTarget) + 1]; 
					directionHandle();
					return;
					//这里有一个return??????????????????????????????????????????????????????????//
				}
				//移动
				var tinyStep = LeleMath.GetDistance(new Point(_netAvatar.Avatar.x, _netAvatar.Avatar.y), _netCurrentTarget)/_netWalkingSpeed;
				_netAvatar.Avatar.x =_netAvatar.Avatar.x + (_netCurrentTarget.x - _netAvatar.Avatar.x) / tinyStep;
				_netAvatar.Avatar.y = _netAvatar.Avatar.y + (_netCurrentTarget.y - _netAvatar.Avatar.y) / tinyStep;
				//模拟刹车
				if (_needBrake&&_netCurrentTarget.equals(_netRoadNodes[_netRoadNodes.length - 1])&&_netAvatarState!=AvatarState.SWIM)//较远距离
				{
					if ((int)(LeleMath.GetDistance(new Point(_netAvatar.A_X, _netAvatar.A_Y), _netCurrentTarget)) <=_brakeDistance)
					{
						_netAvatar.DoAction("brake", directionHandle(false));
						_needBrake = false;
					}
				}
			}
		}
		private function CalculateTarget(source:Point, meansTarget:Point,offset:int):Point//得到一个差一点距离的点
		{
			if (LeleMath.GetDistance(source, meansTarget) < offset) { return meansTarget; }
			if (meansTarget.x > source.x)
			{
				meansTarget.x -= offset;
			}
			else
			{
				meansTarget.x += offset;
			}
			if (meansTarget.y > source.y)
			{
				meansTarget.y -= offset;
			}
			else
			{
				meansTarget.y += offset;
			}
			return meansTarget;
		}
		private function directionHandle(doAction:Boolean = true):String//右下优先原则//这个用于转化Avatar的内容
		{
			if (_netCurrentTarget == null) { return "dd"; }//默认执行转向命令，false就否
			var dir:String;
			if (_netAvatar.Avatar.x - _netCurrentTarget.x > 0)//先判断左右,,在左边
			{
				if (_netAvatar.Avatar.y - _netCurrentTarget.y <= 0)//在下边
				{
					dir = "dl";
				}
				else//在上边
				{
					dir = "lu";
				}
			}
			else//在右边
			{
				if (_netAvatar.Avatar.y - _netCurrentTarget.y <= 0)//在下边
				{
					dir = "rd";
				}
				else//在上边
				{
					dir = "ur";
				}
			}
			if (doAction)
			{
				if(_netAvatarState==AvatarState.WALK)
				_netAvatar.DoAction("run", dir);
				if (_netAvatarState == AvatarState.SWIM)
				_netAvatar.DoAction("swim", dir);
			}
			return dir;
		}
		public function Clean()
		{
			this.removeEventListener(Event.ENTER_FRAME, EveryFrame);
			_netAvatar = null;
			_netAvatarState = null;
			_netCurrentTarget = null;
			_netRoadNodes = null;
		}
		
		
		public function OnReport(evt:Event):void
		{
			var avt:Avatar_PlayerController_Event = evt as Avatar_PlayerController_Event;
			switch(avt.EvtType)
			{
				case Avatar_PlayerController_Event.BECLICKED:
					var callShowInfo:NetWorkController_NetPlayerUnit_Event = new NetWorkController_NetPlayerUnit_Event(NetWorkController_NetPlayerUnit_Event.SHOWOTHERPLAYERINFO);
					_repoter.OnReport(callShowInfo);
					break;
			}
		}
		
	}

}