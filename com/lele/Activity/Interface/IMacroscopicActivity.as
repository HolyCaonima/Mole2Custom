package com.lele.Activity.Interface
{
	
	/**
	 * ...
	 * @author Lele
	 */
	//活动由两大块组成，宏观和微观，宏观为一个章节，微观为其中一个。所以活动都包装于Swf中，由ActivityManager来加载
	//在游戏的整个架构中分布着各个活动接口。活动接口有一个参数。为String类型，接收活动事物触发的位置。
	//在活动Swf中有一个Xml表，记载着这个活动各个区域的事件情况。
	//所有任务都要重写接口中的事物，从而产生各种不同的活动。
	//在每个活动swf中还有一系列相应的函数，用于处理不同情况的事物
	public interface IMacroscopicActivity 
	{
		
	}
	
}