package com.lele.Data
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lele
	 */
	public interface IAnimationData 
	{
		function get run_dl():MovieClip;
		function get run_lu():MovieClip;
		function get run_ur():MovieClip;
		function get run_rd():MovieClip;
		
		function get run_dl_break():MovieClip;
		function get run_lu_break():MovieClip;
		function get run_ur_break():MovieClip;
		function get run_rd_break():MovieClip;
		
		function get idle_dd():MovieClip;
		function get idle_ll():Sprite;
		function get idle_uu():Sprite;
		function get idle_rr():Sprite;
		function get idle_dl():MovieClip;
		function get idle_lu():Sprite;
		function get idle_ur():Sprite;
		function get idle_rd():Sprite;
		
		function get idle_play():MovieClip;
		
		function get shadow():Sprite;
	}
	
}