package com.lele.Controller.Avatar.Layer
{
	import com.lele.Data.IClothAnimation;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author Lele
	 * 
	 * this class is the cloth layer belone to CAvatar ,which help deal with the avatar class
	 */
	public class ClothLayer extends Sprite
	{
		//内部隐含层次
		private var _hat:Sprite;
		private var _hair:Sprite;
		private var _eyes:Sprite;
		private var _necklace:Sprite;
		private var _hand:Sprite;
		private var _shoes:Sprite;
		private var _cloth:Sprite;
		
		private var A_hat:IClothAnimation;
		private var A_hair:IClothAnimation;
		private var A_eyes:IClothAnimation;
		private var A_necklace:IClothAnimation;
		private var A_hand:IClothAnimation;
		private var A_shoes:IClothAnimation;
		private var A_cloth:IClothAnimation;
		
		private var _dir:String;
		
		public function ClothLayer() 
		{
			_hat = new Sprite();
			_hair = new Sprite();
			_eyes = new Sprite();
			_necklace = new Sprite();
			_hand = new Sprite();
			_shoes = new Sprite();
			_cloth = new Sprite();
			
			//Add the layercontainer
			this.addChild(_cloth);
			this.addChild(_shoes);
			this.addChild(_hand);
			this.addChild(_necklace);
			this.addChild(_eyes);
			this.addChild(_hair);
			this.addChild(_hat);
			
		}
		
		public function OnClothLoaded(obj:IClothAnimation)
		{
			switch(obj.Place)
			{
				case "Hat":
					Hat = obj;
					break;
				case "Hair":
					Hair = obj;
					break;
				case "Eyes":
					Eyes = obj;
					break;
				case "Necklace":
					Necklace = obj;
					break;
				case "Hand":
					Hand = obj;
					break;
				case "Shoes":
					Shoes = obj;
					break;
				case "Cloth":
					Cloth = obj;
					break;
			}
		}
		
		public function set Hat(hat:IClothAnimation)
		{
			A_hat = hat;
		}
		public function set Hair(hair:IClothAnimation)
		{
			A_hair = hair;
		}
		public function set Eyes(eyes:IClothAnimation)
		{
			A_eyes = eyes;
		}
		public function set Necklace(necklace:IClothAnimation)
		{
			A_necklace = necklace;
		}
		public function set Hand(hand:IClothAnimation)
		{
			A_hand = hand;
		}
		public function set Shoes(shoes:IClothAnimation)
		{
			A_shoes = shoes;
		}
		public function set Cloth(cloth:IClothAnimation)
		{
			A_cloth = cloth;
		}
		
		//对所有子对象同步动作
		public function PlayAct(action:String)
		{
			ApplyDirection();
			for (var a:int = 0; a < this.numChildren; a++ )
			{
				var tempSP:Sprite = this.getChildAt(a) as Sprite;
				
				for (var b:int = 0; b < tempSP.numChildren; b++ )
				{
					(tempSP.getChildAt(b) as MovieClip).gotoAndPlay(action);
				}
			}
		}
		
		public function StopAct()
		{
			for (var a:int = 0; a < this.numChildren; a++ )
			{
				var tempSP:Sprite = this.getChildAt(a) as Sprite;
				
				for (var b:int = 0; b < tempSP.numChildren; b++ )
				{
					(tempSP.getChildAt(b) as MovieClip).stop();
				}
			}
		}
		
		private function ApplyDirection()
		{
			switch(_dir)
			{
				case "dd":
					SideBack();
					if (A_cloth != null) { SetPart(_cloth, A_cloth.FF); }
					if (A_eyes != null) { SetPart(_eyes, A_eyes.FF); }
					if (A_hair != null) { SetPart(_hair, A_hair.FF); }
					if (A_hand != null) { SetPart(_hand, A_hand.FF); }
					if (A_hat != null) { SetPart(_hat, A_hat.FF); }
					if (A_necklace != null) { SetPart(_necklace, A_necklace.FF); }
					if (A_shoes != null) { SetPart(_shoes, A_shoes.FF); }
					break;
				case "dl":
					SideBack();
					if (A_cloth != null) { SetPart(_cloth, A_cloth.FS); }
					if (A_eyes != null) { SetPart(_eyes, A_eyes.FS); }
					if (A_hair != null) { SetPart(_hair, A_hair.FS); }
					if (A_hand != null) { SetPart(_hand, A_hand.FS); }
					if (A_hat != null) { SetPart(_hat, A_hat.FS); }
					if (A_necklace != null) { SetPart(_necklace, A_necklace.FS); }
					if (A_shoes != null) { SetPart(_shoes, A_shoes.FS); }
					break;
				case "ll":
					SideBack();
					if (A_cloth != null) { SetPart(_cloth, A_cloth.SS); }
					if (A_eyes != null) { SetPart(_eyes, A_eyes.SS); }
					if (A_hair != null) { SetPart(_hair, A_hair.SS); }
					if (A_hand != null) { SetPart(_hand, A_hand.SS); }
					if (A_hat != null) { SetPart(_hat, A_hat.SS); }
					if (A_necklace != null) { SetPart(_necklace, A_necklace.SS); }
					if (A_shoes != null) { SetPart(_shoes, A_shoes.SS); }
					break;
				case "lu":
					SideBack();
					if (A_cloth != null) { SetPart(_cloth, A_cloth.BS); }
					if (A_eyes != null) { SetPart(_eyes, A_eyes.BS); }
					if (A_hair != null) { SetPart(_hair, A_hair.BS); }
					if (A_hand != null) { SetPart(_hand, A_hand.BS); }
					if (A_hat != null) { SetPart(_hat, A_hat.BS); }
					if (A_necklace != null) { SetPart(_necklace, A_necklace.BS); }
					if (A_shoes != null) { SetPart(_shoes, A_shoes.BS); }
					break;
				case "uu":
					SideBack();
					if (A_cloth != null) { SetPart(_cloth, A_cloth.BB); }
					if (A_eyes != null) { SetPart(_eyes, A_eyes.BB); }
					if (A_hair != null) { SetPart(_hair, A_hair.BB); }
					if (A_hand != null) { SetPart(_hand, A_hand.BB); }
					if (A_hat != null) { SetPart(_hat, A_hat.BB); }
					if (A_necklace != null) { SetPart(_necklace, A_necklace.BB); }
					if (A_shoes != null) { SetPart(_shoes, A_shoes.BB); }
					break;
				case "ur":
					SideDown();
					if (A_cloth != null) { SetPart(_cloth, A_cloth.BS); }
					if (A_eyes != null) { SetPart(_eyes, A_eyes.BS); }
					if (A_hair != null) { SetPart(_hair, A_hair.BS); }
					if (A_hand != null) { SetPart(_hand, A_hand.BS); }
					if (A_hat != null) { SetPart(_hat, A_hat.BS); }
					if (A_necklace != null) { SetPart(_necklace, A_necklace.BS); }
					if (A_shoes != null) { SetPart(_shoes, A_shoes.BS); }
					break;
				case "rr":
					SideDown();
					if (A_cloth != null) { SetPart(_cloth, A_cloth.SS); }
					if (A_eyes != null) { SetPart(_eyes, A_eyes.SS); }
					if (A_hair != null) { SetPart(_hair, A_hair.SS); }
					if (A_hand != null) { SetPart(_hand, A_hand.SS); }
					if (A_hat != null) { SetPart(_hat, A_hat.SS); }
					if (A_necklace != null) { SetPart(_necklace, A_necklace.SS); }
					if (A_shoes != null) { SetPart(_shoes, A_shoes.SS); }
					break;
				case "rd":
					SideDown();
					if (A_cloth != null) { SetPart(_cloth, A_cloth.FS); }
					if (A_eyes != null) { SetPart(_eyes, A_eyes.FS); }
					if (A_hair != null) { SetPart(_hair, A_hair.FS); }
					if (A_hand != null) { SetPart(_hand, A_hand.FS); }
					if (A_hat != null) { SetPart(_hat, A_hat.FS); }
					if (A_necklace != null) { SetPart(_necklace, A_necklace.FS); }
					if (A_shoes != null) { SetPart(_shoes, A_shoes.FS); }
					break;
			}
		}
		
		public function SetDirection(dir:String)
		{
			_dir = dir;
		}
		
		
		private function SideBack()
		{
			for (var a:int = 0; a < this.numChildren; a++ )
			{
				(this.getChildAt(a) as Sprite).transform.matrix = new Matrix();
			}
		}
		
		private function SideDown()
		{
			SideBack();
			for (var a:int = 0; a < this.numChildren; a++ )
			{
				(this.getChildAt(a) as Sprite).x = -(this.getChildAt(a) as Sprite).width;
				var mtx:Matrix = new Matrix();
				mtx.a = -1;
				mtx.tx = (this.getChildAt(a) as Sprite).width;
				mtx.concat((this.getChildAt(a) as Sprite).transform.matrix);
				(this.getChildAt(a) as Sprite).transform.matrix = mtx;
			}
		}
		
		private function SetPart(owner:Sprite, target:MovieClip)
		{
			//移除对象
			while (owner.numChildren > 0)
			{
				owner.removeChildAt(0);
			}
			
			target.stop();
			owner.addChild(target);
		}
		
		
	}

}