package com.lele.Controller.Avatar
{
	import com.lele.Controller.Avatar.Interface.ICommunication;
	import com.lele.Controller.Avatar.Layer.ClothLayer;
	import com.lele.Data.IClothAnimation;
	import com.lele.Map.Interface.IDepthObj;
	import com.lele.Controller.Avatar.Events.Avatar_PlayerController_Event;
	import com.lele.Manager.Interface.IReport;
	import fl.motion.Color;
	import com.lele.Controller.Avatar.Enum.AvatarState;
	import com.lele.Controller.Avatar.Interface.IAvatar;
	import com.lele.Controller.Avatar.Interface.IControllerClickAble;
	import com.lele.Data.IAnimationData;
	import flash.display.ColorCorrection;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.globalization.StringTools;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Lele
	 */
	//这个类其实不应该放在这里
	//抽象成抽象类才能放在这里
	//CAvatar作为PlayerController的子对象，是一个容纳显示部分的对象
	public class CAvatar extends MovieClip implements IAvatar,IControllerClickAble,IDepthObj//用这个类可以来完成一些动画,,一个包装各种动作在一起的容器，同时只有一个MovieClip在子对象列表中
	{
		private var _repoter:IReport;
		
		private var _resourcePack:IAnimationData;
		private var _skin:Object;
		private var _bone:Object;
		private var _effect:Object;
		
		private var shadow:Sprite;
		
		private var _clothLayer:ClothLayer;
		private var _bodyLayer:Sprite;
		private var _effectLayer:Sprite;
		private var _shadowLayer:Sprite;
		private var _otherLayer:Sprite;
		private var _isSelfOwner:Boolean;
		
		private var _body_skin:Sprite;
		private var _body_bone:Sprite;
		private var _body_effect:Sprite;
		
		private var MoleState:Function;
		
		private var _currentDir:String;
		private var _currentState:String;
		
		private var _timeCounter:Object;
		private var _depth:int;
		
		private var _chatDialog:Sprite;//聊天弹窗
		private var _nameTxt:TextField;
		
		public function Reset()
		{
			(_effect.down as MovieClip).stop();
			(_effect.up as MovieClip).stop();
			(_effect.leftdown as MovieClip).stop();
			(_effect.leftup as MovieClip).stop();
			(_effect.left as MovieClip).stop();
		}
		
		public function OnClothLoaded(cloth:IClothAnimation)
		{
			_clothLayer.OnClothLoaded(cloth);
		}
		
		public function SetComDialog(dialog:Sprite)
		{
			if (_chatDialog != null) { return; }
			_chatDialog = dialog;
			_otherLayer.addChild(_chatDialog);
			_chatDialog.y = -95;
		}
		
		public function ShowDialog(txt:String)
		{
			(_chatDialog as ICommunication).ShowTxt(txt);
			_chatDialog.x = ( -_chatDialog.width / 2) + 5;
		}
		//test Func
		
		public function CAvatar(moleAct:Object,resourcePack:IAnimationData,isSelfOwner:Boolean,color:String="white",name:String=null)
		{
			_timeCounter = new Object();
			
			_depth = 0;
			
			shadow = resourcePack.shadow;
			
			//创建名字框
			_nameTxt = new TextField();
			_nameTxt.autoSize = TextFieldAutoSize.CENTER;
			_nameTxt.text = name;
			_nameTxt.x -= 48;
			_nameTxt.y = 8;
			
			_skin = moleAct.skin;
			_bone = moleAct.bone;
			_effect = moleAct.effect;
			
			(_skin.down as MovieClip).transform.matrix = new Matrix();//重置数据
			(_skin.up as MovieClip).transform.matrix = new Matrix();
			(_skin.left as MovieClip).transform.matrix = new Matrix();
			(_skin.leftdown as MovieClip).transform.matrix = new Matrix();
			(_skin.leftup as MovieClip).transform.matrix = new Matrix();
			
			(_bone.down as MovieClip).transform.matrix = new Matrix();
			(_bone.up as MovieClip).transform.matrix = new Matrix();
			(_bone.left as MovieClip).transform.matrix = new Matrix();
			(_bone.leftdown as MovieClip).transform.matrix = new Matrix();
			(_bone.leftup as MovieClip).transform.matrix = new Matrix();
			
			(_effect.down as MovieClip).transform.matrix = new Matrix();
			(_effect.up as MovieClip).transform.matrix = new Matrix();
			(_effect.left as MovieClip).transform.matrix = new Matrix();
			(_effect.leftdown as MovieClip).transform.matrix = new Matrix();
			(_effect.leftup as MovieClip).transform.matrix = new Matrix();
			
			//设置颜色
			SetColor(color, _bone.up);
			SetColor(color, _bone.down);
			SetColor(color, _bone.leftup);
			SetColor(color, _bone.leftdown);
			SetColor(color, _bone.left);
			
			_clothLayer = new ClothLayer();//构建容器
			_bodyLayer = new Sprite();
			_shadowLayer = new Sprite();
			_otherLayer = new Sprite();
			_effectLayer = new Sprite();
			
			(_effect.down as MovieClip).stop();//停止效果
			(_effect.up as MovieClip).stop();
			(_effect.leftdown as MovieClip).stop();
			(_effect.leftup as MovieClip).stop();
			(_effect.left as MovieClip).stop();
			(_effect.down as MovieClip).cacheAsBitmap = true;
			(_effect.up as MovieClip).cacheAsBitmap = true;
			(_effect.leftdown as MovieClip).cacheAsBitmap = true;
			(_effect.leftup as MovieClip).cacheAsBitmap = true;
			(_effect.left as MovieClip).cacheAsBitmap = true;
			
			(_bone.down as MovieClip).cacheAsBitmap = true;
			(_bone.up as MovieClip).cacheAsBitmap = true;
			(_bone.left as MovieClip).cacheAsBitmap = true;
			(_bone.leftdown as MovieClip).cacheAsBitmap = true;
			(_bone.leftup as MovieClip).cacheAsBitmap = true;
			
			this.addChild(_shadowLayer);//添加层
			this.addChild(_bodyLayer);
			this.addChild(_clothLayer);
			this.addChild(_effectLayer);
			this.addChild(_otherLayer);
			
			_body_bone = new Sprite();//添加Body的子层
			_body_effect = new Sprite();
			_body_skin = new Sprite();
			
			_bodyLayer.addChild(_body_bone);
			_bodyLayer.addChild(_body_skin);
			
			_effectLayer.addChild(_body_effect);
			
			_shadowLayer.addChild(shadow);//添加阴影
			
			_otherLayer.addChild(_nameTxt);//添加名字
			
			_isSelfOwner = isSelfOwner;
			MoleState = function() { }
			this.addEventListener(Event.ENTER_FRAME, EnterFrame);
			DoAction("stand", "dd");
		}
		public function DoAction(actionName:String, direction:String,callBack:Function=null)
		{
			var act = ActionSuggest.SuggestAction(actionName);//对动作名进行解释
			//
			if (_currentState == act && _currentDir == direction)
			return;
			MoleActivity(act, direction,callBack);
		}
		
		//动作解析调度
		
		private function MoleActivity(act:String,dir:String,callBack:Function=null)//动作总调度
		{
			if (_shadowLayer.numChildren == 0) { _shadowLayer.addChild(shadow); }
			_currentState = act;
			transformDirection(dir);
			switch(act)
			{
				case "run":
				{
					PlayAct(act, 50,-1,function(){
					//	_body_effect.removeChildAt(0);
					});
					return;
				}
				case "swim":
				{
					PlayAct(act, 78, -1, null, true);
					if (_shadowLayer.numChildren > 0) { _shadowLayer.removeChildAt(0); }
					return;
				}
				case "stand":
				{
					PlayAct(act, 10);
					return;
				}
				case "brake":
				{
					PlayAct(act, 68, 1, function() {
					//	_body_effect.removeChildAt(0);
					},true);
					return;
				}
				case "disdain":
				{
					//请求停止自动旋转
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 745, 4, function() {
						if (callBack != null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					//	_body_effect.removeChildAt(0);
					});
					return;
				}
				case "big_smile":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 856, 5, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					//	_body_effect.removeChildAt(0);
					},true);
					return;
				}
				case "bad_smile":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 773, 1, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					},true);
					return;
				}
				case "pudency":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 782, 3, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					//	_body_effect.removeChildAt(0);
					},true);
					return;
				}
				case "complacent":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 811, 3, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					//	_body_effect.removeChildAt(0);
					},true);
					return;
				}
				case "spit":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 846, 1, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					},true);
					return;
				}
				case "embarrassed":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 899, 1, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					},true);
					return;
				}
				case "cry":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 1013, 10, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					//	_body_effect.removeChildAt(0);
					},true);
					return;
				}
				case "naughty":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 907, 4, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					});
					return;
				}
				case "surprised":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 932, 1, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					},true);
					return;
				}
				case "sweat":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 973, 3, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					//	_body_effect.removeChildAt(0);
					},true);
					return;
				}
				case "dizzy":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 997, 4, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					//	_body_effect.removeChildAt(0);
					},true);
					return;
				}
				case "angry":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 1021, 4, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					//	_body_effect.removeChildAt(0);
					},true);
					return;
				}
				case "think":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 1029, 3, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					//	_body_effect.removeChildAt(0);
					},true);
					return;
				}
				case "hello":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 630, 1, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					},true);
					return;
				}
				case "feel_wronged":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 733, 3, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					});
					return;
				}
				case "sitdown_1":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 20, -1, null,false);
					return;
				}
				case "dance":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 1233, 2, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					},false);
					return;
				}
				case "wave":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct(act, 598, 3, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					});
					return;
				}
				case "superdance":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct("dance", 1233, -1, function() {
					},false);
					return;
				}
				case "yawn":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct("yawn", 182, 1, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					});
					return;
				}
				case "scratch_buns":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct("scratch_buns", 222, 1, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					});
					return;
				}
				case "scratch_nose":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct("scratch_nose", 265, 1, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					});
					return;
				}
				case "look":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct("look", 307, 1, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					});
					return;
				}
				case "scratch_head":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct("scratch_head", 348, 1, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", "dd");
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					});
					return;
				}
				case "throw":
				{
					var stopRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLOFFROTATEAROUND);
					_repoter.OnReport(stopRotEvt);
					PlayAct("throw", 99, 1, function() {
						if(callBack!=null)
						callBack();
						DoAction("stand", dir);
						var startRotEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.CALLONROTATEAROUND);
						_repoter.OnReport(startRotEvt);
					});
					return;
				}
			}
		}
		
		private function EnterFrame(evt:Event)
		{
			MoleState();
		}
		
		private function PlayAct(act:String, deadLine:int,loopTimes:int=-1,onStop:Function=null,hasEffect:Boolean=false)
		{
			_timeCounter[act + "now"] = 1;
			_timeCounter[act + "target"] = loopTimes;
			var temp:Function;
			
			//set cloth to go
			_clothLayer.PlayAct(act);
			
			//set body to go
			(_body_bone.getChildAt(0) as MovieClip).gotoAndPlay(act);
			(_body_skin.getChildAt(0) as MovieClip).gotoAndPlay(act);
			(_body_effect.getChildAt(0) as MovieClip).gotoAndStop(act);
			
			if (hasEffect) { (_body_effect.getChildAt(0) as MovieClip).gotoAndPlay(act); }
			//设置方法
			temp = function() {
				if ((_body_bone.getChildAt(0) as MovieClip).currentFrame == deadLine)
				{
					if (_timeCounter[act + "now"]== _timeCounter[act + "target"])
					{
						//set cloth stop
						_clothLayer.StopAct();
						
						//set bone stop
						(_body_bone.getChildAt(0) as MovieClip).stop();
						(_body_skin.getChildAt(0) as MovieClip).stop();
						
						if (hasEffect) { (_body_effect.getChildAt(0) as MovieClip).stop(); }
						if (onStop != null)
						{
							onStop();
							return;
						}
					}
					//set cloth play
					_clothLayer.PlayAct(act);
					
					//set bone play
					(_body_bone.getChildAt(0) as MovieClip).gotoAndPlay(act);
					(_body_skin.getChildAt(0) as MovieClip).gotoAndPlay(act);
					
					if (hasEffect) { (_body_effect.getChildAt(0) as MovieClip).gotoAndPlay(act); }
					
					_timeCounter[act + "now"] = _timeCounter[act + "now"] + 1;
				}
			}
			MoleState = temp;
			/*if (loop)
			{
				temp = function() {
				if ((_body_bone.getChildAt(0) as MovieClip).currentFrame == deadLine)
				{
					(_body_bone.getChildAt(0) as MovieClip).gotoAndPlay(act);
					(_body_skin.getChildAt(0) as MovieClip).gotoAndPlay(act);
					if (hasEffect){(_body_effect.getChildAt(0) as MovieClip).gotoAndPlay(act);}
				}
				}
			}
			else
			{
				temp = function() {
				if ((_body_bone.getChildAt(0) as MovieClip).currentFrame == deadLine)
				{
					(_body_bone.getChildAt(0) as MovieClip).stop();
					(_body_skin.getChildAt(0) as MovieClip).stop();
					if (hasEffect) { (_body_effect.getChildAt(0) as MovieClip).stop(); }
					if (onStop != null)
					{
						onStop();
					}
				}
				}
			}*/
			//MoleState = temp;
		}
		
		private function transformDirection(dir:String)//改变方向
		{
			if (_currentDir == dir) { return; }
			_currentDir = dir;
			switch(dir)
			{
				case "dd":
				{
					SideBack(_bone.down);
					SideBack(_skin.down);
					SideBack(_effect.down);
					CAddChild(_body_bone, _bone.down);
					CAddChild(_body_skin, _skin.down);
					CAddChild(_body_effect, _effect.down);
					break;
				}
				case "dl":
				{
					SideBack(_bone.leftdown);
					SideBack(_skin.leftdown);
					SideBack(_effect.leftdown);
					CAddChild(_body_bone, _bone.leftdown);
					CAddChild(_body_skin, _skin.leftdown);
					CAddChild(_body_effect, _effect.leftdown);
					break;
				}
				case "ll":
				{
					SideBack(_bone.left);
					SideBack(_skin.left);
					SideBack(_effect.left);
					CAddChild(_body_bone, _bone.left);
					CAddChild(_body_skin, _skin.left);
					CAddChild(_body_effect, _effect.left);
					break;
				}
				case "lu":
				{
					SideBack(_bone.leftup);
					SideBack(_skin.leftup);
					SideBack(_effect.leftup);
					CAddChild(_body_bone, _bone.leftup);
					CAddChild(_body_skin, _skin.leftup);
					CAddChild(_body_effect, _effect.leftup);
					break;
				}
				case "uu":
				{
					SideBack(_bone.up);
					SideBack(_skin.up);
					SideBack(_effect.up);
					CAddChild(_body_bone, _bone.up);
					CAddChild(_body_skin, _skin.up);
					CAddChild(_body_effect, _effect.up);
					break;
				}
				case "ur":
				{
					SideDown(_bone.leftup);
					SideDown(_skin.leftup);
					SideDown(_effect.leftup);
					CAddChild(_body_bone, _bone.leftup);
					CAddChild(_body_skin, _skin.leftup);
					CAddChild(_body_effect, _effect.leftup);
					break;
				}
				case "rr":
				{
					SideDown(_bone.left);
					SideDown(_skin.left);
					SideDown(_effect.left);
					CAddChild(_body_bone, _bone.left);
					CAddChild(_body_skin, _skin.left);
					CAddChild(_body_effect, _effect.left);
					break;
				}
				case "rd":
				{
					SideDown(_bone.leftdown);
					SideDown(_skin.leftdown);
					SideDown(_effect.leftdown);
					CAddChild(_body_bone, _bone.leftdown);
					CAddChild(_body_skin, _skin.leftdown);
					CAddChild(_body_effect, _effect.leftdown);
					break;
				}
			}
			_clothLayer.SetDirection(dir);
			(_body_effect.getChildAt(0) as MovieClip).gotoAndStop(1);//效果先停止
		}
		private function SetColor(color:String,targetMC:MovieClip)
		{
			var co:Color;
			switch(color)
			{
				case "blue":
				{
					co = new Color(0.109803, 0.705882, 0.992156);
					break;
				}
				case "white":
					co = new Color(1, 1, 1);
					break;
				case "black":
				{
					co = new Color(0, 0, 0);
					break;
				}
				case "orange":
				{
					co = new Color(0.988, 0.494, 0.094);
					break;
				}
				case "green":
				{
					co = new Color(0.152, 0.913, 0.454);
					break;
				}
				case "red":
				{
					co = new Color(0.890, 0.133, 0.066);
					break;
				}
				case "brown":
				{
					co = new Color(0.705, 0.490, 0.164);
					break;
				}
				case "purple":
				{
					co = new Color(0.807, 0.152, 0.811);
					break;
				}
				case "grey":
				{
					co = new Color(0.639, 0.627, 0.635);
					break;
				}
				case "pink":
				{
					co = new Color(0.952, 0.301, 0.592);
					break;
				}
			}
			targetMC.transform.colorTransform=co;
		}
		private function SideDown(mc:MovieClip)
		{
			SideBack(mc);//倒置前先清理状态
			mc.x = -mc.width;
			var mtx:Matrix = new Matrix();
			mtx.a = -1;
			mtx.tx = mc.width;
			mtx.concat(mc.transform.matrix);
			mc.transform.matrix = mtx;
		}
		private function SideBack(mc:MovieClip)
		{
			mc.transform.matrix = new Matrix();
		}
		private function CAddChild(container:Sprite,child:Sprite)
		{
			for (var a:int = 0; a < container.numChildren; a++ )
			{
				container.removeChildAt(0);
			}
			container.addChild(child);
		}
		
		public function get Avatar():Sprite
		{
			return this;
		}
		
		public function set Repoter(repoter:IReport)
		{
			_repoter = repoter;
		}
		//对深度接口的实现
		public function get Depth():int { return _depth; }
		public function set Depth(depth:int) { _depth = depth; }
		
		//对IAvatar接口实现
		public function get A_X():Number { return this.x; }
		public function get A_Y():Number { return this.y; }
		
		//对IControllerClickAble接口的实现
		public function OnClick():Boolean//Exit?//返回一个标准返回态度的决定,即是否让ControllerBase中函数的子函数继续执行 ,当true则不再执行后续函数
		{
			var beClickEvt:Avatar_PlayerController_Event = new Avatar_PlayerController_Event(Avatar_PlayerController_Event.BECLICKED);
			_repoter.OnReport(beClickEvt);
			trace("MoleClick");
			return true;
		}
		public function get _x():Number
		{
			return this.x;
		}
		public function get _y():Number
		{
			return this.y-25;
		}
		public function get _width():Number
		{
			return 25;
		}
		public function get _height():Number
		{
			return 52;
		}
		public function get IsSelfOwner():Boolean
		{
			return _isSelfOwner;
		}
		
	}

}