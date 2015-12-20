package com.lele.Controller.Avatar.Interface
{
	import com.lele.Map.Interface.IClickAble;
	
	/**
	 * ...
	 * @author Lele
	 */
	//控制器专用点击接口
	public interface IControllerClickAble extends IClickAble
	{
		function get IsSelfOwner():Boolean;
	}
	
}