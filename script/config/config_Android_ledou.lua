-- Filename: config_Android_lvan.lua
-- Author: jin lu lu
-- Date: 2014-9-22
-- Purpose: android 乐逗 平台配置
module("config", package.seeall)
loginInfoTable = {}
function getFlag( ... )
	return "ledouphone"
end


function getPidUrl( sessionid )
	local url = Platform.getDomain() .. "phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .."?sessionid=" .. Platform.sdkLoginInfo.sid .. "&open_id=" .. Platform.sdkLoginInfo.uid .. "&game_id=" .. Platform.sdkLoginInfo.gameid .. Platform.getUrlParam() .."&bind=" .. g_dev_udid
 	return postString
end 

-- 这个是 Release Secret
function getAppId( ... )
	return "773a0245f64708a33adc"
end

function getAppKey( ... )
	return "5ce7b60eb7b90f3aaddd"
end
 

function getName( ... )
	return "乐逗游戏"
end
function  getInitParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(getAppId()),"appId")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	local groupid = CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(Platform.getPid()),"pid")
	return dict
end

function getUserInfoParam(gameState)
	require "script/model/user/UserModel"
    require "script/ui/login/ServerList"
    local dict = CCDictionary:create()
    dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
    dict:setObject(CCString:create(ServerList.getSelectServerInfo().name),"groupName")
    dict:setObject(CCString:create(loginInfoTable.newuser),"newuser")
    if(tonumber(gameState) == 1)then
	    -- 下面的appUid和appUname暂时获取不到，先不用
	    dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	    dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
	    dict:setObject(CCString:create(UserModel.getUserUtid()),"appUtid")
	    dict:setObject(CCString:create(UserModel.getHeroLevel()),"appUlevel")
	end

	return dict
end

function setLoginInfo( xmlTable )
	loginInfoTable.uid = xmlTable:find("uid")[1]
	loginInfoTable.newuser = xmlTable:find("newuser")[1]
end

function getGroupParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	return dict
end

--debug conifg
function getServerListUrl_debug( ... )
 	return "http://119.255.38.86/phone/serverlistnotice/?".. Platform.getUrlParam()
end 

function getPidUrl_debug( sessionid )
	local url = "http://119.255.38.86/phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .."?sessionid=" .. Platform.sdkLoginInfo.sid .. "&open_id=" .. Platform.sdkLoginInfo.uid .. "&game_id=" .. Platform.sdkLoginInfo.gameid .. Platform.getUrlParam() .."&bind=" .. g_dev_udid
 	return postString
end 

function getAppId_debug( ... )
	return getAppId()
end

function getAppKey_debug( ... )
	return getAppKey()
end

 