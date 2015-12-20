package com.lele.Plugin.RoadFind
{
	import adobe.utils.CustomActions;
	import com.lele.Plugin.RoadFind.Interface.IRoadFinder;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import com.lele.Map.BitMapUtil;
	import com.lele.MathTool.LeleMath;
	import com.lele.Map.Interface.IBitMapUtil;
	/**
	 * ...
	 * @author Lele
	 */
	public class RoadFinder implements IRoadFinder
	{
		private var _roadData:Array;//第一个是y第二个是x
		private var _roadHeight:int;
		private var _roadWidth:int;
		private var _roadNode:Array;
		private var _changeNode:Array;
		private var _roadNodeState:Boolean;//标识是否可用
		private var _findTimes:int;
		private var _iniOptimizatimes:int;
		
		public var bitmu:IBitMapUtil;
		
		public function RoadFinder()  //默认colorObj 三种状态 canGo, notGo ,special
		{
			_roadNodeState = true;
			_findTimes = 0;
			_iniOptimizatimes = 2;
		}
		//public function FindRoad(poSource:Point, poTarget:Point):Array
		//{
		//}
		public function get IniOptimizatimes():int
		{
			return _iniOptimizatimes;
		}
		public function set IniOptimizatimes(times:int)
		{
			_iniOptimizatimes = times;
		}
		public function get ChangeNode():Array
		{
			if (_changeNode == null) { return null; }
			for (var a:int = 0; a < _changeNode.length; a++ )
			{
				(_changeNode[a] as Point).x *= bitmu.BitBlock;
				(_changeNode[a] as Point).y *= bitmu.BitBlock;
			}
			return _changeNode;
		}
		public function get RoadNode():Array
		{
			for (var a:int = 0; a < _roadNode.length; a++ )
			{
				(_roadNode[a] as Point).x *= bitmu.BitBlock;
				(_roadNode[a] as Point).y *= bitmu.BitBlock;
			}
			return _roadNode;
		}
		public function GetBlock():int
		{
			return bitmu.BitBlock;
		}
		public function IsRoadNodeAvilable():Boolean
		{
			return _roadNodeState;
		}
		public function FindRoad(poSource:Point, poTarget:Point)
		{
			//var time1:Date = new Date();
			//初始化执行过程
			poSource.x =Math.round(poSource.x/bitmu.BitBlock);
			poSource.y =Math.round(poSource.y/bitmu.BitBlock);
			poTarget.x =Math.round(poTarget.x/bitmu.BitBlock);
			poTarget.y =Math.round(poTarget.y/bitmu.BitBlock);
			{
				//trace(poTarget);
				var tempState:int = GetPointState(poTarget);
				//trace(tempState);
				if (tempState == 0)
				{
					var tempArray:Array = InitBetween(poSource, poTarget);
					var crossPoint:Array = GetCrossPoints(tempArray);
					poTarget = crossPoint[crossPoint.length-1];
				}
			}
			_roadNode = new Array();
			_findTimes = 0;
			_roadNodeState = true;
			
			var traceArray = new Array();
			//
			var roadPoints:Array = InitBetween(poSource, poTarget);//插值路线
			var roadCross:Array = GetCrossPoints(roadPoints);//获得交错路径
			if (roadCross.length == 2)
			{
				_roadNode.push(poSource, poTarget);
				
				_changeNode= GetCrossWaterPoints(_roadNode);
				//trace("finished");
				return ;
			}
			else
			{
				_roadNode.push(poSource);
				_roadNode.push(poTarget);
				FindStep(poSource, poTarget);
				//trace(_findTimes);
				//trace("finished");
				OptimizationNode();
				//trace(_roadNode);
				//trace(_roadNode.length);
				/*for (var a:int = 0; a < _roadNode.length-1; a++ )
				{
					DrawLineBetween(_roadNode[a], _roadNode[a + 1],4289855498);
				}*/
				//将合格的_roadNode给traceArray;
				
			}
			//var time2:Date = new Date();
			//trace(time2.getMilliseconds() - time1.getMilliseconds());
			
		}
		/*public function DrawLineBet(poSource:Point,poTarget:Point,bitMapUtil:BitMapUtil)//用来看的没有实际用途..根据封装这个函数也不应该放在这
		{
			//var tab:Number = 1.0 / (Math.sqrt((poSource.x - poTarget.x) * (poSource.x - poTarget.x) + (poSource.y - poTarget.y) * (poSource.y - poTarget.y)) / Math.sqrt(2));//1/(距离除以根号2)=平均插值量
			//tab *=1;
			var poArray:Array = InitBetween(poSource, poTarget);
			for (var a:int = 0; a <poArray.length; a++)//间隔tab
			{
				bitMapUtil.DrawRectInMapResolution(poArray[a].x, poArray[a].y, 4289655498);//4289955498
			}
			var crossArray:Array = GetCrossPoints(poArray);
			for (var a:int = 0; a <crossArray.length; a++)//间隔tab
			{
				bitMapUtil.DrawRectInMapResolution(crossArray[a].x, crossArray[a].y, 4289055498);//4289955498
			}
			
			bitmu = bitMapUtil;
			/*var pos:Array = GetVertLinePoints(poSource, poTarget);
			var newLine:Array = InitBetween(pos[0], pos[1]);
			for (var a:int = 0; a <newLine.length; a++)//间隔tab
			{
				bitMapUtil.DrawRectInMapResolution(newLine[a].x, newLine[a].y, 4289955498);//4289955498
			}
			var cos:Array = GetCrossPoints(newLine);
			for (var a:int = 0; a <cos.length; a++)//间隔tab
			{
				bitMapUtil.DrawRectInMapResolution(cos[a].x, cos[a].y, 4289055498);//4289955498
			}*/
			
			//FindStep(poSource, poTarget);
		//}
		
		public function CreatRoadDataFromMapData(bitMapUtil:IBitMapUtil)//这时的bitData应该是BitMapUtil处理过的只有单色矩形
		{
			Reset();
			_roadWidth= bitMapUtil.GetLengthX();
			_roadHeight = bitMapUtil.GetLengthY();
			_roadData = new Array();
			for (var y:int = 0; y < _roadHeight; y++ )
			{
				_roadData[y] = new Array();
				for (var x:int = 0; x < _roadWidth; x++ )
				{
					_roadData[y][x] = bitMapUtil.GetRectState(x, y);
				}
			}
			bitmu = bitMapUtil;
			//创建完成得到一组_roadData;
		}
		private function Reset()
		{
			_roadData = null;
			_roadHeight = 0;
			_roadWidth = 0;
		}
		
		private function OptimizationNode()
		{
			if (_roadNode.length < 3) { return; }//先去除可能的不可行点
			for (var a:int = 0; a < _roadNode.length-2; a++)
			{
				for (var b:int = a + 2; b < _roadNode.length; b++ )
				{
					var tempArray:Array = InitBetween(_roadNode[a], _roadNode[b]);
					if (GetCrossPoints(tempArray).length <= 2) { _roadNode.splice(b-1,1); b--;}
				}
			}
			//是否超出导致不可行也是判断条件之一
			/*var iniRoadData:Array = new Array();
			iniRoadData.push(_roadNode[0]);
			for (var a:int = 1; a < _roadNode.length - 1; a++ )
			{
				//如果不可行直接退出
				if (GetPointState(new Point(Math.round((_roadNode[a].x + _roadNode[a - 1].x) / 2), Math.round((_roadNode[a].y + _roadNode[a - 1].y) / 2)))==0)
				{
					break;
				}
				iniRoadData.push(_roadNode[a]);
			}
			_roadNode = iniRoadData;
			if (_roadNode.length < 3) { return; }//如果不满足插值条件直接退出
			*/
			//然后在线段中插值
			IniOptimization(_iniOptimizatimes);
			//最后再去除一次点
			if (_roadNode.length < 3) { return; }//先去除可能的不可行点
			for (var a:int = 0; a < _roadNode.length-2; a++)
			{
				for (var b:int = a + 2; b < _roadNode.length; b++ )
				{
					var tempArray:Array = InitBetween(_roadNode[a], _roadNode[b]);
					if (GetCrossPoints(tempArray).length <= 2) { _roadNode.splice(b-1,1); b--;}
				}
			}
			
		}
		private function IniOptimization(times:int)
		{
			if (times == 0 || _roadNode.length < 3) { return; }
			for (var a:int = 0; a < _roadNode.length-1; a++ )
			{
				_roadNode.splice(a + 1, 0, GetCenterPoint(_roadNode[a], _roadNode[a + 1]));
				a++;
			}
			//最后去除插值中的连线间点//此时点数必然>=5
			for (var a:int = 1; a < _roadNode.length - 2; a++ )
			{
				var tempArray:Array = InitBetween(_roadNode[a], _roadNode[a + 2]);
				if (GetCrossPoints(tempArray).length <= 2) { _roadNode.splice(a + 1, 1); }
				else { a++; }
			}
			IniOptimization(--times);
		}
		private function FindStep(poSource:Point, poTarget:Point)//返回可行组合//array为不包括poSource和poTarget的中间点集
		{
			if (_findTimes > 100) 
			{
				_roadNodeState = false;
				return;
			}
			_findTimes++;
			try
			{
			var roadPoints:Array = InitBetween(poSource, poTarget);
			var roadCross:Array = GetCrossPoints(roadPoints);
			if (roadCross.length == 2) { InsertRoadData(poSource,poTarget,1); /*trace(poSource+"-To-" + poTarget); DrawLineBetween(poSource, poTarget,4289955498); /*trace("end One");*/ return; }
			else
			{
				var roadVert:Array = GetVertLinePoints(poSource, poTarget);
				var roadVertPoints:Array = InitBetween(roadVert[0], roadVert[1]);
				var roadCenter:Array = GetCenterPoints(GetCrossPoints(roadVertPoints));
				var poValuest:Object = GetValuestPoint(poSource, poTarget, roadCenter);
				if (poValuest.value == 0)//表示对双向都要进行计算
				{
					FindStep(poValuest.point, poTarget);
					FindStep(poSource, poValuest.point);
				}
				else if (poValuest.value == 1)//表示只要针对poTarget连线计算
				{
					FindStep(poValuest.point, poTarget);
					InsertRoadData(poSource, poValuest.point,1);
					//trace(poSource+"-To-"+poValuest.point);
					//DrawLineBetween(poSource, poValuest.point,4289955498);
				}
				else if (poValuest.value == 2)//表示要对poSource连线计算
				{
					FindStep(poSource, poValuest.point);
					InsertRoadData(poValuest.point, poTarget, 1);
					//trace(poValuest.point+"-To-"+poTarget);
					//DrawLineBetween(poValuest.point, poTarget,4289955498);
				}
				//else if (poValuest.value == 3)//表示不要连线，该点就可用
				//{
				//	trace("该点可用");
				//	DrawLineBetween(poValuest.point, poTarget);//画线是测试代码
				//	DrawLineBetween(poSource, poValuest.point);
				//}
			}
			}
			catch(error:Error)//当寻路出错
			{
				_roadNodeState = false;
				return;
			}
		}
		private function InsertRoadData(poCom:Point, poTarget:Point,insetIn:int):void
		{
			if (_roadNode.indexOf(poCom) == -1)//如果没有
			{
				_roadNode.splice(insetIn, 0, poCom);
			}
			_roadNode.splice(_roadNode.indexOf(poCom) + 1, 0, poTarget);
			//清理重复点
			for (var a:int = 0; a < _roadNode.length - 1; a++ )
			{
				if ((_roadNode[a] as Point).equals(_roadNode[a + 1] as Point)) { _roadNode.splice(a, 1); a--; }
			}
		}
		/*private function DrawLineBetween(poSource:Point, poTarget:Point,color:uint):void//在两点之间画线
		{
			var needLines:Array = InitBetween(poSource, poTarget);
			for (var a:int = 0; a < needLines.length; a++ )
			{
				bitmu.DrawRectInMapResolution(needLines[a].x, needLines[a].y, color);
			}
		}*/
		private function GetCenterPoints(points:Array):Array//获得连续点的中间点，并且这些点都在可行走区 
		{
			var cetPoints:Array = new Array();
			for (var a:int = 0; a < points.length-1; a++ )
			{
				var cetPo:Point = new Point(((points[a] as Point).x + (points[a + 1] as Point).x) / 2, ((points[a] as Point).y + (points[a + 1] as Point).y) / 2);
				cetPo.x = Math.round(cetPo.x);
				cetPo.y = Math.round(cetPo.y);
				if (GetPointState(cetPo) == 0) { continue; }
				cetPoints.push(cetPo);
			}
			return cetPoints;
		}
		private function GetCenterPoint(poSource:Point, poTarget:Point):Point
		{
			var cetPo:Point = new Point(((poSource as Point).x + (poTarget as Point).x) / 2, ((poSource as Point).y + (poTarget as Point).y) / 2);
			cetPo.x = Math.round(cetPo.x);
			cetPo.y = Math.round(cetPo.y);
			return cetPo;
		}
		private function GetPointValue(poSource:Point, poTarget:Point, poTest:Point):int//返回值为价值衡量值,0表示无连线,1表示对target,2表示对source,3表示双向
		{
			var value:int = 0;
			var tempPoint:Array;
			var tempCross:Array;
			tempPoint = InitBetween(poSource, poTest);
			tempCross = GetCrossPoints(tempPoint);
			if (tempCross.length == 2) { value++; }
			tempPoint = InitBetween(poTarget, poTarget);
			tempCross = GetCrossPoints(tempPoint);
			if (tempCross.length == 2) { value++; }
			if (value == 2) { value++; }
			return value;
		}
		private function GetValuestPoint(poSource:Point,poTarget:Point,poTest:Array):Object
		{
			var index:int = 0;
			var value:int = GetPointValue(poSource, poTarget, poTest[index]);
			var valuePoint:Object = new Object();
			var valueEstPoint:Array = new Array();
			valuePoint.point = poTest[0];
			valuePoint.value = value;
			valueEstPoint.push(valuePoint);
			if (poTest.length == 1) { return valuePoint; };
			for (var a:int = 1; a < poTest.length; a++ )
			{
				var tv:int = GetPointValue(poSource, poTarget, poTest[a]);
				if (tv > value)
				{
					value = tv;
					index = a;
					valueEstPoint = new Array();
					var obj:Object = new Object();
					obj.point = poTest[a];
					obj.value = tv;
					valueEstPoint.push(obj);
				}
				else if (tv == value)
				{
					var obj:Object = new Object();
					obj.point = poTest[a];
					obj.value = tv;
					valueEstPoint.push(obj);
				}
			}
			valuePoint.point = poTest[index];
			if (valueEstPoint.length > 1)
			{
				var pointList:Array = new Array();
				for (var a:int = 0; a < valueEstPoint.length; a++ )
				{
					pointList.push(valueEstPoint[a].point);
				}
				valuePoint.point=GetNearestPoint(poSource, poTarget, pointList);
			}
			valuePoint.value = value;
			return valuePoint;
		}
		private function GetNearestPoint(poSource:Point,poTarget:Point,pos:Array):Point
		{
			var minIndex:int = 0;
			var minValue:Number = 0;
			minValue = Math.sqrt(((pos[0] as Point).x - poSource.x) * ((pos[0] as Point).x - poSource.x) + ((pos[0] as Point).y - poSource.y) * ((pos[0] as Point).y - poSource.y));
			minValue+= Math.sqrt(((pos[0] as Point).x - poTarget.x) * ((pos[0] as Point).x - poTarget.x) + ((pos[0] as Point).y - poTarget.y) * ((pos[0] as Point).y - poTarget.y));
			for (var a:int = 1; a < pos.length; a++ )
			{
				var value:Number = Math.sqrt(((pos[a] as Point).x - poSource.x) * ((pos[a] as Point).x - poSource.x) + ((pos[a] as Point).y - poSource.y) * ((pos[a] as Point).y - poSource.y));
				value+=Math.sqrt(((pos[a] as Point).x - poTarget.x) * ((pos[a] as Point).x - poTarget.x) + ((pos[a] as Point).y - poTarget.y) * ((pos[a] as Point).y - poTarget.y));
				if (value < minValue)
				{
					minValue = value;
					minIndex = a;
				}
			}
			return pos[minIndex];
		}
		private function GetVertLinePoints(poSource:Point,poTarget:Point):Array//获得与原点连线相垂直的点
		{
			var pairPoint:Array = new Array();
			var followX:Boolean = Math.abs(poSource.x-poTarget.x) > Math.abs(poSource.y-poTarget.y)?false:true;//这个标志着从x方向增值还是从y方向增值
			var centerPo:Point = new Point(Math.round((poSource.x+poTarget.x) / 2), Math.round((poSource.y+poTarget.y) / 2));//获取round后的中点
			var k:Number = (poSource.x - poTarget.x) / (poTarget.y - poSource.y);
			var b:Number = centerPo.y - k * centerPo.x;
			if (followX)
			{
				//先进行上半部分，即从x->00
				for (var x:int = centerPo.x;; x++)
				{
					var y:int = k * x + b;
					if (x == 0 || x == _roadWidth || y == 0 || y == _roadHeight)
					{
						pairPoint.push(new Point(x, y));
						break;
					}
				}
				//再进行下半部分，即从x->-00
				for (var x:int = centerPo.x;; x-- )
				{
					var y:int = k * x + b;
					if (x == 0 || x == _roadWidth || y == 0 || y == _roadHeight)
					{
						pairPoint.push(new Point(x, y));
						break;
					}
				}
				return pairPoint;
			}
			else
			{
				for (var y:int = centerPo.y;; y++ )
				{
					var x:int = (y - b) / k;
					if (y == 0 || y == _roadHeight || x == 0 || x == _roadWidth )
					{
						pairPoint.push(new Point(x, y));
						break;
					}
				}
				for (var y:int = centerPo.y;; y-- )
				{
					var x:int = (y - b) / k;
					if (y == 0 || y == _roadHeight || x == 0 || x == _roadWidth )
					{
						pairPoint.push(new Point(x, y));
						break;
					}
				}
				return pairPoint;
			}
		}
		private function GetCrossWaterPoints(pointArray:Array):Array//结果的后处理,增加动作变化点
		{
			var result:Array = new Array();
			var road:Array = new Array();
			for (var a:int = 0; a < pointArray.length-1; a++ )
			{
				road.push(pointArray[a]);
				var tempArray:Array = InitBetween(pointArray[a], pointArray[a + 1]);
				var flag:int = 0;
				for (var b:int = 0; b < tempArray.length - 1; b++ )
				{
					if ((GetPointState(tempArray[b]) + GetPointState(tempArray[b + 1])) == 3)//说明是交点
					{
						if (flag == 1) { flag--; continue; }
						flag++;
						result.push(tempArray[b]);
						road.push(new Point(tempArray[b].x,tempArray[b].y));
					}
					else
					{
						flag = flag - 1 >= 0?flag - 1:0;
					}
				}
			}
			road.push(pointArray[pointArray.length - 1]);
			_roadNode = road;
			return result;
		}
		private function GetCrossPoints(pointArray:Array):Array//只在可走和不可走处做交点  //相邻非常近的点不应该被剔除!!!但必须合并
		{
			var result:Array = new Array();
			if (GetPointState(pointArray[0]) > 0) { result.push(pointArray[0]); }//首点
			for (var a:int = 1; a < pointArray.length - 1; a++ )
			{
				if ((GetPointState(pointArray[a]) > 0) && GetPointState(pointArray[a + 1]) == 0) { result.push(pointArray[a]); continue; }//情况1  special/canGo->notGo
				if (GetPointState(pointArray[a]) == 0 && GetPointState(pointArray[a + 1]) > 0) { result.push(pointArray[a + 1]); }
			}
			//判断与地图的交点
			if (GetPointState(pointArray[pointArray.length - 1]) > 0) { result.push(pointArray[pointArray.length - 1]); }//末点
			//开始合并距离非常近的点
			for (var a:int = 0; a < result.length - 1; a++)
			{
				if (LeleMath.GetDistance(result[a], result[a + 1]) < Math.sqrt(18))
				{
					result.splice(a, 1);
					a--;
				}
			}//非常重要的处理过程!!!!!
			return result;
		}
		private function GetPointState(point:Point):int
		{
			return _roadData[point.y][point.x];
		}
		public function GetState(point:Point):int
		{
			try
			{
			return _roadData[Math.round(point.y / bitmu.BitBlock)][Math.round(point.x / bitmu.BitBlock)];
			}
			catch (er:Error) { trace(er.message); }
			return 1;
		}
		/*private function GetCrossPointAllState(pointArray:Array):Array
		{
			
		}*/
		private function InitBetween(poSource:Point, poTarget:Point):Array//在两个点之间插值  //比较point注意用equals
		{
			poSource.x = Math.round(poSource.x);
			poSource.y = Math.round(poSource.y);
			poTarget.x = Math.round(poTarget.x);
			poTarget.y = Math.round(poTarget.y);
			poTarget.x = poTarget.x < 0?0:poTarget.x;
			poTarget.y = poTarget.y < 0?0:poTarget.y;
			poTarget.x = poTarget.x >= _roadWidth?_roadWidth-1:poTarget.x;
			poTarget.y = poTarget.y >= _roadHeight?_roadHeight-1:poTarget.y;//插值点初始化检查
			poSource.x = poSource.x < 0?0:poSource.x;
			poSource.y = poSource.y < 0?0:poSource.y;
			poSource.x = poSource.x >= _roadWidth?_roadWidth-1:poSource.x;
			poSource.y = poSource.y >= _roadHeight?_roadHeight-1:poSource.y;//插值点初始化检查
			var pointArray:Array = new Array();
			var tabX:Number = 1.0 / Math.abs(poSource.x - poTarget.x);
			var tabY:Number = 1.0 / Math.abs(poSource.y - poTarget.y);//根据间隔最小的进行插值
			var tab:Number = tabX > tabY?tabY:tabX;
			for (var sat:Number = 0; sat <= 1; sat+=tab)//间隔tab
			{
				var point:Point = new Point(Math.round((1.0 - sat) * poSource.x + sat * poTarget.x), Math.round((1.0 - sat) * poSource.y + sat * poTarget.y));//Math.round()修正不精确的点
				pointArray.push(point);
			}
			//首尾校验
			if (!pointArray[0].equals(poSource)) { trace("not head"); }
			if (!pointArray[pointArray.length - 1].equals(poTarget)) { pointArray.push(poTarget); }
			return pointArray;
		}
		
	}

}