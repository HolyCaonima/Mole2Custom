package com.lele.LeleSocket
{
	import com.lele.Manager.Events.ManagerEventBase;
	import com.lele.Manager.Events.NetData_Net_ManagerEvent;
	import com.lele.Manager.Events.AppData_App_ManagerEvent;
	import com.lele.Manager.Events.Net_Game_ManagerEvent;
	import com.lele.LeleSocket.Param;
	import flash.events.Event;
	import flash.geom.Point;
	import com.lele.Data.GloableData;
	/**
	 * ...
	 * @author Lele
	 */
	//ID
	//DoAction,name,dir
	//AddPlayer,color,x,y
	//LoginResult,result
	//Move,roads(点集)//网络玩家移动
	//AddAll,map//请求所有区域网络玩家并添加
	//RemovePlayer,ID;移除玩家
	//DisUpdate,//停止服务端update标签
	//NetDoAction,name,dir
	//LChat,msg//大家一起说的(这个消息发送和接受都有)
	//FChatSe,toID,msg,time //向好友发送
	//FChatRe,from,msg,time //好友聊天接收
	//Weather,(weather,strength/map) //天气数据双向交互
	//Article,head,body//提交文章
	//CreatAccount,pwd//创建账户
	//BackCreatAccount,result,id//创建账户返回信息
	//MoleLoginInfo,id//请求摩尔登录基础数据
	//MoleBaseInfo,num,id,color,name//返回摩尔基础数据
	//CreateMole,color,name//创建摩尔
	//CreateMoleBack,result//0/1
	//Throw,item,x,y,action,dir,blood//投掷
	//Throw,item,x,y,action,dir,blood,ID//投掷返回
	//FriDats,Df,Ia,Tn,Nu,c,i,o,n,s//返回的好友信息块  Df,dataField标识来源,Ia,IsAppend信息模式 Tn ,TotalNum总数 Nu,Num单次返回数据量 c,Color,i,Id,o,isOnline,n,name,s,sty标识是否好友
	//RFriDats,block//请求好友数据，block为单个块大小
	//FriLogin,id//好友登录
	//FriOff,id//好友离线
	//MFriend,id//请求加好友(传出)
	//XMFriend,id,name//请求加好友(外部传入)
	//NoteY,title,content//单向Note;
	public class EventCommandConver 
	{
		
		public function EventCommandConver() 
		{
			
		}
		
		public static function ConverCommandToEvent(command:Command):NetData_Net_ManagerEvent
		{
			var resultEvt:NetData_Net_ManagerEvent;
			switch(command._commandName)
			{
				case "DoAction":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.DOACTION);
					resultEvt._playerID = command.GetValueByName("ID");
					resultEvt.DOACTION_name = command.GetValueByName("name");
					resultEvt.DOACTION_direction = command.GetValueByName("dir");
					break;
				case "AddPlayer":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.ADDNETPLAYER);
					resultEvt._playerID = command.GetValueByName("ID");
					resultEvt.ADDNETPLAYER_color = command.GetValueByName("color");
					resultEvt.ADDNETPLAYER_name = command.GetValueByName("name");
					resultEvt.ADDNETPLAYER_spownPoint = new Point((int)(command.GetValueByName("x")), (int)(command.GetValueByName("y")));
					resultEvt.ADDNETPLAYER_map = command.GetValueByName("map");
					break;
				case "LoginResult":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.LOGINRESULT);
					resultEvt.LOGINRESULT_result = command.GetValueByName("result");
					break;
				case "Move"://网络玩家移动
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.NETPLAYERMOVE);
					resultEvt._playerID = command.GetValueByName("ID");
					resultEvt.NETPLAYERMOVE_target = new Point((Number)(command.GetValueByName("x")), (Number)(command.GetValueByName("y")));
					break;
				case "RemovePlayer":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.REMOVENETPLAYER);
					resultEvt._playerID = command.GetValueByName("ID");
					break;
				case "LChat":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.NETPLAYERSAY);
					resultEvt._playerID = command.GetValueByName("ID");
					resultEvt.NETPLAYERSAY_msg = command.GetValueByName("msg");
					break;
				case "Weather":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.CHANGEWEATHER);
					resultEvt.CHANGEWEATHER_weather = command.GetValueByName("weather");
					resultEvt.CHANGEWEATHER_strength = (int)(command.GetValueByName("strength"));
					break;
				case "BackCreatAccount":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.CREATACCOUNTRESULT);
					var result:Boolean = command.GetValueByName("result") == "True"?true:false;
					resultEvt.CREATACCOUNTRESULT_result = result;
					resultEvt.CREATACCOUNTRESULT_id = command.GetValueByName("id");
					break;
				case "MoleBaseInfo":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.MOLEBASEINFO);
					resultEvt.MOLEBASEINFO_num = (int)(command.GetValueByName("num"));
					if (resultEvt.MOLEBASEINFO_num == 0) { break; }
					resultEvt.MOLEBASEINFO_color = command.GetValueByName("color");
					resultEvt.MOLEBASEINFO_name = command.GetValueByName("name");
					break;
				case "CreateMoleBack":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.CREATEMOLEBACK);
					resultEvt.CREATEMOLEBACK_result = ((int)(command.GetValueByName("result"))) == 1?true:false;
					break;
				case "Throw":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.NETTHROWITEM);
					resultEvt.NETTHROWITEM_action = command.GetValueByName("action");
					resultEvt.NETTHROWITEM_blood = (Number)(command.GetValueByName("blood"));
					resultEvt.NETTHROWITEM_dir = command.GetValueByName("dir");
					resultEvt.NETTHROWITEM_id = command.GetValueByName("ID");
					resultEvt.NETTHROWITEM_itemStyle = command.GetValueByName("item");
					resultEvt.NETTHROWITEM_position = new Point((Number)(command.GetValueByName("x")), (Number)(command.GetValueByName("y")));
					break;
				case "FChatRe":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.FRIENDCHATRECEIVE);
					resultEvt.FRIENDCHATRECEIVE_from = command.GetValueByName("from");
					resultEvt.FRIENDCHATRECEIVE_msg = command.GetValueByName("msg");
					resultEvt.FRIENDCHATRECEIVE_time = command.GetValueByName("time");
					break;
				case "FriDats":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.CHATLISTDATABACK);
					resultEvt.CHATLISTDATABACK_colors = command.GetValueByName("c");
					resultEvt.CHATLISTDATABACK_dataField = command.GetValueByName("Df");
					resultEvt.CHATLISTDATABACK_ids = command.GetValueByName("i");
					resultEvt.CHATLISTDATABACK_isAppend = command.GetValueByName("Ia") == "0"?false:true;
					resultEvt.CHATLISTDATABACK_isOnlines = command.GetValueByName("o");
					resultEvt.CHATLISTDATABACK_names = command.GetValueByName("n");
					resultEvt.CHATLISTDATABACK_num = (int)(command.GetValueByName("Nu"));
					resultEvt.CHATLISTDATABACK_stys = command.GetValueByName("s");
					resultEvt.CHATLISTDATABACK_totalNum = (int)(command.GetValueByName("Tn"));
					break;
				case "FriLogin":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.FRIENDLOGIN);
					resultEvt.FRIENDLOGIN_id = command.GetValueByName("id");
					break;
				case "FriOff":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.FRIENDOFFLINE);
					resultEvt.FRIENDOFFLINE_id = command.GetValueByName("id") ;
					break;
				case "XMFriend":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.XMFRIEND);
					resultEvt.XMFRIEND_id = command.GetValueByName("id");
					resultEvt.XMFRIEND_name = command.GetValueByName("name");
					break;
				case "NoteY":
					resultEvt = new NetData_Net_ManagerEvent(NetData_Net_ManagerEvent.NOTEY);
					resultEvt.NOTEY_title = command.GetValueByName("title");
					resultEvt.NOTEY_content = command.GetValueByName("content");
					break;
			}
			return resultEvt;
			
		}
		public static function ConverEventToCommand(evt:ManagerEventBase):String
		{
			var result:String = "<";
			switch(evt.EvtType)
			{
				case Net_Game_ManagerEvent.LOGININ:
				{
					result += "Login;3;";
					result +="key;"+(evt as Net_Game_ManagerEvent).LOGININ_GAME_playerKey + ";";
					result += "secret;" + (evt as Net_Game_ManagerEvent).LOGININ_GAME_playerSecret+";";
					result += "version;" + GloableData.Version;
					break;
				}
				case Net_Game_ManagerEvent.LOCALPLAYERMOVE_GAME://本地玩家移动
				{
					var target:Point = (evt as Net_Game_ManagerEvent).LOCALPLAYERMOVE_GAME_target;
					result += "Move;2;x;" + target.x + ";y;" + target.y;
					break;
				}
				case Net_Game_ManagerEvent.NETUPDATE_GAME:
				{
					result += "Update;3;map;" + (evt as Net_Game_ManagerEvent).NETUPDATE_GAME_map + ";x;" + (evt as Net_Game_ManagerEvent).NETUPDATE_GAME_position.x + ";y;" + (evt as Net_Game_ManagerEvent).NETUPDATE_GAME_position.y;
					break;
				}
				case Net_Game_ManagerEvent.NETPLAYERLISTAPPLY_GAME:
				{
					result += "AddAll;1;map;" + (evt as Net_Game_ManagerEvent).NETPLAYERLISTAPPLY_GAME_map;
					break;
				}
				case Net_Game_ManagerEvent.DISUPDATE_GAME:
				{
					result += "DisUpdate;0";
					break;
				}
				case Net_Game_ManagerEvent.NETDOACTION_GAME:
				{
					result += "NetDoAction;2;name;" + (evt as Net_Game_ManagerEvent).NETDOACTION_GAME_name+";dir;" + (evt as Net_Game_ManagerEvent).NETDOACTION_GAME_dir;
					break;
				}
				case Net_Game_ManagerEvent.NETCHATMSG_GAME:
				{
					result += "LChat;1;msg;" + (evt as Net_Game_ManagerEvent).NETCHATMSG_GAME_msg;
					break;
				}
				case Net_Game_ManagerEvent.WEATHER_GAME:
				{
					result += "Weather;1;map;" + GloableData.CurrentMap;
					break;
				}
				case Net_Game_ManagerEvent.SUBMITARTICLE_GAME:
				{
					result += "Article;2;head;" + (evt as Net_Game_ManagerEvent).SUBMITARTICLE_GAME_head + ";body;" + (evt as Net_Game_ManagerEvent).SUBMITARTICLE_GAME_body;
					break;
				}
				case Net_Game_ManagerEvent.CREATACCOUNT_GAME:
				{
					result += "CreatAccount;1;pwd;" + (evt as Net_Game_ManagerEvent).CREATACCOUNT_GAME_pwd;
					break;
				}
				case Net_Game_ManagerEvent.APPLYMOLELOGININFO:
				{
					result += "MoleLoginInfo;1;id;" + GloableData.TempID;
					break;
				}
				case Net_Game_ManagerEvent.CREATEMOLE_GAME:
				{
					result += "CreateMole;2;color;" + (evt as Net_Game_ManagerEvent).CREATEMOLE_GAME_color + ";name;" + (evt as Net_Game_ManagerEvent).CREATEMOLE_GAME_name;
					break;
				}
				case Net_Game_ManagerEvent.CALLNETTHROWITEM_GAME:
				{
					result += "Throw;6;item;" + (evt as Net_Game_ManagerEvent).CALLNETTHROWITEM_GAME_itemStyle+";x;" +
					(evt as Net_Game_ManagerEvent).CALLNETTHROWITEM_GAME_position.x + ";y;" + (evt as Net_Game_ManagerEvent).CALLNETTHROWITEM_GAME_position.y
					+";action;" + (evt as Net_Game_ManagerEvent).CALLNETTHROWITEM_GAME_action + ";dir;" + (evt as Net_Game_ManagerEvent).CALLNETTHROWITEM_GAME_dir +
					";blood;" + (evt as Net_Game_ManagerEvent).CALLNETTHROWITEM_GAME_blood;
					break;
				}
				case AppData_App_ManagerEvent.FRIENDCHATSEND:
				{
					result += "FChatSe;3;toID;" + (evt as AppData_App_ManagerEvent).FRIENDCHATSEND_friendID + ";msg;" +
					(evt as AppData_App_ManagerEvent).FRIENDCHATSEND_msg + ";time;" + (evt as AppData_App_ManagerEvent).FRIENDCHATSEND_time;
					break;
				}
				case AppData_App_ManagerEvent.RCHATLISTDATAS:
				{
					//if((evt as AppData_App_ManagerEvent).RCHATLISTDATAS_field=="0")//暂时这样
					result += "RFriDats;1;block;" + (evt as AppData_App_ManagerEvent).RCHATLISTDATAS_block;
					break;
				}
				case AppData_App_ManagerEvent.MAKEFRIEND:
				{
					result += "MFriend;1;id;" + (evt as AppData_App_ManagerEvent).MAKEFRIEND_id;
					break;
				}
			}
			return result + ">";
		}
		
	}

}