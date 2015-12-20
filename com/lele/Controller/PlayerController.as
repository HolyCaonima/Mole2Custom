package com.lele.Controller
{
	import adobe.utils.CustomActions;
	import com.lele.Controller.Avatar.Events.Avatar_PlayerController_Event;
	import com.lele.Manager.Events.PLC_Player_ManagerEvent;
	import com.lele.Map.BitMapUtil;
	import com.lele.Controller.Avatar.Enum.AvatarState;
	import com.lele.Controller.Avatar.Interface.IAvatar;
	import com.lele.Controller.Interface.IControlMap;
	import com.lele.Map.Interface.IClickAble;
	import com.lele.Map.Interface.ITrigger;
	import com.lele.Map.Interface.ITriggerArray;
	import com.lele.Plugin.RoadFind.Interface.IRoadFinder;
	import com.lele.Plugin.RoadFind.Interface.IRoadMap;
	import com.lele.Manager.Interface.IReport;
	import com.lele.Plugin.RoadFind.RoadFinder;
	import com.lele.MathTool.LeleMath;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Lele
	 */
	//继承自ControllerBase的类，是基础的控制类，包装好了寻路功能，需要加入一个继承自IAvatar接口的图形显示
	public final class PlayerController extends ControllerBase implements IReport
	{
		private var _freeClock:Timer;//用来触发随机动作的时钟
		private var _avatar:IAvatar;
		private var _roadFinder:IRoadFinder;
		private var _roadMap:IRoadMap;
		private var _state:AvatarState;
		private var _triggerArray:ITriggerArray;//当碰到并且地点到时会触发的,触发器两种类型，这里使用的是长久站立触发
		private var _currentTarget:Point;
		private var _currentRoad:Array;
		private var _currentChange:Array;
		private var _preTarget:Point;
		private var _repoter:IReport;
		
		private var _currentMouseMoleDirection:String;
		private var _needBrake:Boolean;
		private const _brakeDistance:int = 50;
		private const _enbleBrakeDistance:int = 200;
		
		private var _rotateAround:Boolean = true;//转来转去
		
		private const _runSpeed:Number = 3.5;
		private const _swimSpeed:Number = 2;
		private var _speed:Number;
		
		private var _getNetAvatarArray:Function;
		
		public function PlayerController(repoter:IReport) 
		{
			_speed = _runSpeed;
			_freeClock = new Timer(((Math.random()*10)+3)*1000);
			_freeClock.addEventListener(TimerEvent.TIMER, OnFree);
			_freeClock.start();
			_state = AvatarState.IDLE;//初始状态为静态站立
			_clickEnable = true;
			_repoter = repoter;
		}
		public function get AState():AvatarState
		{
			return _state;
		}
		public function Reset()
		{
			_speed = _runSpeed;
			_state = AvatarState.IDLE;
			_currentRoad = null;
			if (_avatar != null)
			{
				_preTarget=new Point(_avatar.A_X, _avatar.A_Y);
				_currentTarget = null;
				DoAction("stand");
			}
		}
		public function AvatarStateCheck()
		{
			if (_roadFinder == null) { return; }
			var tempState:int = _roadFinder.GetState(new Point(_avatar.A_X, _avatar.A_Y));
			if (tempState == 2 && _state != AvatarState.SWIM)//该游泳时不游泳
			{
				if (_state ==AvatarState.WALK)
				{
					_state = AvatarState.SWIM;
					directionHandle();
				}
				else
				{
					_state = AvatarState.SWIM;
					DoAction("swim", "rd");
				}
				_speed = _swimSpeed;//改变速度
			}
			else if (tempState != 2 && _state == AvatarState.SWIM)//不该游泳时游泳
			{
				_state = AvatarState.IDLE;
				_speed = _runSpeed;
				DoAction("stand", "dd");
				_needBrake = false;
			}
		}
		public function CreatController(roadMap:IRoadMap,avatar:IAvatar,controlMap:IControlMap,triggerArray:ITriggerArray)//现在用的是默认参数因为没有改的需要，以后抽象成config
		{
			_roadFinder = new RoadFinder();
			_avatar = avatar;
			_preTarget = new Point(_avatar.A_X, _avatar.A_Y);
			_avatar.Repoter = this;
			_triggerArray = triggerArray;
			_roadMap = roadMap;
			_controlMap = controlMap;
			var colorObj:Object = { canGo:4289555498, notGo:4294967295, special:4278229503 };
			var bitMapUtil:BitMapUtil = new BitMapUtil(roadMap.Type_mc, 960, 540, 2, colorObj);
			bitMapUtil.DrawPixelMap();
			_roadFinder.CreatRoadDataFromMapData(bitMapUtil);
			//要开启
			SwitchOn(_controlMap.Size_mc);
		}
		
		public function SetMsgDialog(dialog:Sprite)
		{
			if(_avatar!=null)
			_avatar.SetComDialog(dialog);
		}
		
		public function ShowMsgDialog(txt:String)//显示消息
		{
			_avatar.ShowDialog(txt);
		}
		
		override protected function OnChildMouseClick(evt:MouseEvent) 
		{
			//当点击到可交互物件时，获取物件态度，没点到执行，点到看态度执行,这里由抽象父类调用
			//判断是否点击在玩家上
			_rotateAround = true;
			//当点击时自动重启旋转
			var source:Point = new Point(_avatar.Avatar.x, _avatar.Avatar.y);
			var target:Point = new Point(evt.localX, evt.localY);
			if (_preTarget.x==Math.round(evt.localX)&&_preTarget.y==Math.round(evt.localY)) { return; }//如果起点和终点一样驳回请求
			_preTarget = new Point(Math.round(evt.localX), Math.round(evt.localY));
			_roadFinder.FindRoad(source, CalculateTarget(source,target,4));
			_currentRoad = _roadFinder.RoadNode;
			_currentChange = _roadFinder.ChangeNode;
			_currentTarget = _currentRoad[0];//第一个点就是脚下的点方便判断方向
			if(_state!=AvatarState.WALK&&_state!=AvatarState.SWIM)
			_state = AvatarState.WALK;
			//准备网络事件
			var evtM:PLC_Player_ManagerEvent = new PLC_Player_ManagerEvent(PLC_Player_ManagerEvent.LOCALPLAYERMOVE);
			evtM.LOCALPLAYERMOVE_target = _currentRoad[_currentRoad.length - 1];
			_repoter.OnReport(evtM);
			//
			if (LeleMath.GetDistance(_currentRoad[_currentRoad.length-1], _currentRoad[_currentRoad.length-2]) > _enbleBrakeDistance) { _needBrake = true; }
		}
		
		override protected function EveryFrame(evt:Event)//故意留的bug
		{
			if (_state==AvatarState.WALK||_state==AvatarState.PLAY||_state==AvatarState.SWIM)//动画都在这
			{
				if (_currentTarget == null) { return; }
				if (Math.abs(_avatar.Avatar.x -_currentTarget.x)<_speed && Math.abs(_avatar.Avatar.y -_currentTarget.y)<_speed) //到节点触发
				{
					_avatar.Avatar.x = _currentTarget.x;
					_avatar.Avatar.y = _currentTarget.y;
					if (_currentChange != null&&_currentChange.length>0&& _currentTarget.equals(_currentChange[0]))
					{
						if (_state == AvatarState.WALK) 
						{
							_state = AvatarState.SWIM;
							_speed = _swimSpeed;
						}
						else if (_state == AvatarState.SWIM) 
						{
							_state = AvatarState.WALK; 
							_speed = _runSpeed;
						}
						_currentChange.splice(0, 1);
					}
					if (_currentTarget.equals(_currentRoad[_currentRoad.length - 1]))//到了
					{
						if (_state == AvatarState.SWIM)
						{
							return;
						}
						_state = AvatarState.IDLE; //设置站立状态
						OnFreeActionStop();
						_avatar.DoAction("stand", LeleMath.GetDirection(LeleMath.DealRDifference(LeleMath.GetDigree(_currentRoad[_currentRoad.length - 2],_currentTarget))));	
						TriggerCheckAndDispatchEvt(_currentTarget);//触发触发器
					}
					_currentTarget = _currentRoad[_currentRoad.indexOf(_currentTarget) + 1]; 
					directionHandle();
					return;//这里有一个return??????????????????????????????????????????????????????????//
				}
				//移动
				var tinyStep = LeleMath.GetDistance(new Point(_avatar.Avatar.x, _avatar.Avatar.y), _currentTarget)/_speed;
				_avatar.Avatar.x =_avatar.Avatar.x + (_currentTarget.x - _avatar.Avatar.x) / tinyStep;
				_avatar.Avatar.y = _avatar.Avatar.y + (_currentTarget.y - _avatar.Avatar.y) / tinyStep;
				//模拟刹车
				if (_needBrake&&_currentTarget.equals(_currentRoad[_currentRoad.length - 1])&&_state!=AvatarState.SWIM)
				{
					if ((int)(LeleMath.GetDistance(new Point(_avatar.A_X, _avatar.A_Y), _currentTarget)) <=_brakeDistance)
					{
						_avatar.DoAction("brake", directionHandle(false));
						_needBrake = false;
					}
				}
			}
			if (_state == AvatarState.IDLE)
			{//方向不一致才触发
				if (_rotateAround&&_currentMouseMoleDirection != LeleMath.GetDirection(LeleMath.DealRDifference(LeleMath.GetDigree(new Point(_avatar.A_X, _avatar.A_Y), new Point(mouseX, mouseY)))))
				{
					_currentMouseMoleDirection = LeleMath.GetDirection(LeleMath.DealRDifference(LeleMath.GetDigree(new Point(_avatar.A_X, _avatar.A_Y), new Point(mouseX, mouseY))));
					_avatar.DoAction("stand", _currentMouseMoleDirection);
				}
			}
		}
		public function set GetNetAvatarArray(func:Function)
		{
			_getNetAvatarArray = func;
		}
		override protected function get AdditionClickObj():Array //额外点击事件的接受对象
		{
			var temp:Array = new Array();
			if (_getNetAvatarArray != null)
			{
				_getNetAvatarArray(temp);
			}
			temp.push(_avatar);
			return temp;
		}
		public function DoAction(actionName:String,direction:String="dd",callBack:Function=null)
		{
			//在Avatar内会对actionName进行解释
			if (_state == AvatarState.SWIM && actionName != "swim") { return; }
			_avatar.DoAction(actionName,direction,callBack);
		}
		private function OnFree(evt:Event)//当长久站立，由FreeClock触发
		{
			//判断状态
			if (_state != AvatarState.IDLE||_state==AvatarState.SWIM || _avatar == null||_state==AvatarState.PLAY) { return; }
			//停止计时器
			_freeClock.stop();
			//切换状态
			_state = AvatarState.FREE;
			//随机选择动作
			var select:int = Math.round(Math.random() * 100);
			var actionSelected:String = "yawn";
			if (select <= 20)
			{
				actionSelected = "yawn";
			}
			else if (select <= 40)
			{
				actionSelected = "scratch_buns";
			}
			else if (select <= 60)
			{
				actionSelected = "scratch_nose";
			}
			else if (select <= 80)
			{
				actionSelected = "look";
			}
			else if (select <= 100)
			{
				actionSelected = "scratch_head";
			}
			DoAction(actionSelected, "dd", OnFreeActionStop);
			//构建并发送事件
			var evvt:PLC_Player_ManagerEvent = new PLC_Player_ManagerEvent(PLC_Player_ManagerEvent.LOCALPLAYERDOACTION);
			evvt.LOCALPLAYERDOACTION_dir = "dd";
			evvt.LOCALPLAYERDOACTION_name = actionSelected;
			_repoter.OnReport(evvt);
		}
		private function OnFreeActionStop()//回调
		{
			if (_state == AvatarState.SWIM) { return; }
			_freeClock.stop();
			_state = AvatarState.IDLE;
			var time:Number = Math.round(LeleMath.NextGaussian2(8, 5)) * 1000;
			if (time > 20000)
			{
				time = 20000;
			}
			_freeClock.delay = time;
			_freeClock.start();
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
		private function TriggerCheckAndDispatchEvt(checkPoint:Point)
		{
			var temp:Array = _triggerArray.TriggerArray;
			for (var a:int = 0; a <temp.length; a++ )
			{
				if ((temp[a] as ITrigger).IsMeetTerm(checkPoint))
				{
					(temp[a] as ITrigger).OnTrigge();
				}
			}
		}
		public function get State():AvatarState
		{
			return _state;
		}
		public function SetStatePlay()
		{
			if (_state == AvatarState.SWIM) { return; }
			_state = AvatarState.PLAY;
		}
		public function SetStateIdle()
		{
			if (_state == AvatarState.SWIM) { return; }
			_state = AvatarState.IDLE;
			OnFreeActionStop();
		}
		private function directionHandle(doAction:Boolean = true):String//右下优先原则//这个用于转化Avatar的内容
		{
			if (_currentTarget == null) { return "dd"; }//默认执行转向命令，false就否
			var dir:String;
			if (_avatar.Avatar.x - _currentTarget.x > 0)//先判断左右,,在左边
			{
				if (_avatar.Avatar.y - _currentTarget.y <= 0)//在下边
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
				if (_avatar.Avatar.y - _currentTarget.y <= 0)//在下边
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
				
				if(_state==AvatarState.WALK)
				_avatar.DoAction("run", dir);
				if (_state == AvatarState.SWIM)
				_avatar.DoAction("swim", dir);
			}
			return dir;
		}
		public function OnReport(evt:Event):void
		{
			var event:Avatar_PlayerController_Event = evt as Avatar_PlayerController_Event;
			switch(event.EvtType)
			{
				case Avatar_PlayerController_Event.CALLOFFROTATEAROUND:
				{
					_rotateAround = false;
					return;
				}
				case Avatar_PlayerController_Event.CALLONROTATEAROUND:
				{
					_rotateAround = true;
					return;
				}
			}
		}
		
	}

}