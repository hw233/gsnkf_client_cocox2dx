
-- Filename：	AlertTip2.lua
-- Author：		bzx
-- Date：		2014-6-25
-- Purpose：		提示警告，需要用户选择的

module("AlertTip2", package.seeall)


require "script/ui/common/LuaMenuItem"
require "script/ui/main/MainScene"
require "script/localized/LocalizedUtil"

local _cormfirmCBFunc = nil 
local _closeCallbackFunc = nil
local _argsCB = nil

local alertLayer

--[[
 @desc	 处理touches事件
 @para 	 string event
 @return 
--]]
local function onTouchesHandler( eventType, x, y )
	if (eventType == "began") then
	    return true
    elseif (eventType == "moved") then
	end
end


--[[
 @desc	 回调onEnter和onExit时间
 @para 	 string event
 @return void
 --]]
local function onNodeEvent( event )
	if (event == "enter") then
		print("AlertTip.onNodeEvent.......................enter")
		alertLayer:registerScriptTouchHandler(onTouchesHandler, false, -5600, true)
		alertLayer:setTouchEnabled(true)
	elseif (event == "exit") then
		print("AlertTip.onNodeEvent.......................exit")
		alertLayer:unregisterScriptTouchHandler()
        alertLayer = nil
       
	end
end


function closeAction()
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	if(alertLayer) then
		alertLayer:removeFromParentAndCleanup(true)
		alertLayer = nil
	end
	if(_closeCallbackFunc )then
		_closeCallbackFunc()
	end
end

-- 按钮响应
function menuAction( tag, itemBtn )
	require "script/audio/AudioUtil"
	AudioUtil.playEffect("audio/effect/guanbi.mp3")
	if(alertLayer) then
		alertLayer:removeFromParentAndCleanup(true)
		alertLayer = nil
	end
	print ("tag==", tag)
	local isConfirm = false
	if(tag == 10001) then
		isConfirm = true
	elseif (tag == 10002) then
		isConfirm = false
	end
	-- 回调
	if (_cormfirmCBFunc) then
		_cormfirmCBFunc(isConfirm, _argsCB)
	end
	
end

--[[
	@desc	alertView
	@para 	tipText, 		 显示文字 string
			confirmCBFunc,   回调 func
			isNeedCancel,	 是否需要取消按钮 bool
	 		argsCB,			 回调传参  
	@return void
--]]
function showAlert( tipText, tipText2, confirmCBFunc, isNeedCancel, argsCB, confirmTitle, cancelTitle, closeCallbackFunc,isNeedKuoChong, others)
	_cormfirmCBFunc = confirmCBFunc
	_argsCB = argsCB
	_closeCallbackFunc = closeCallbackFunc

	confirmTitle = confirmTitle or GetLocalizeStringBy("key_2864")
	cancelTitle = cancelTitle or GetLocalizeStringBy("key_2326")
	if(alertLayer) then
		alertLayer:removeFromParentAndCleanup(true)
		alertLayer = nil
	end

	-- layer
	alertLayer = CCLayerColor:create(ccc4(0,0,0,155))
	alertLayer:registerScriptHandler(onNodeEvent)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:addChild(alertLayer, 2000)

	-- 背景
	local fullRect = CCRectMake(0,0,213,171)
	local insetRect = CCRectMake(50,50,113,71)
	local alertBg = CCScale9Sprite:create("images/common/viewbg1.png", fullRect, insetRect)
	alertBg:setPreferredSize(CCSizeMake(520, 410))
	alertBg:setAnchorPoint(ccp(0.5, 0.5))
	alertBg:setPosition(ccp(alertLayer:getContentSize().width*0.5, alertLayer:getContentSize().height*0.5))
	alertLayer:addChild(alertBg)
	alertBg:setScale(g_fScaleX)	
    if others ~= nil then
        others.bg = alertBg
    end

	local alertBgSize = alertBg:getContentSize()

	-- 关闭按钮bar
	local closeMenuBar = CCMenu:create()
	closeMenuBar:setPosition(ccp(0, 0))
	alertBg:addChild(closeMenuBar)
	closeMenuBar:setTouchPriority(-5601)
	-- 关闭按钮
	local closeBtn = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
	closeBtn:registerScriptTapHandler(closeAction)
	closeBtn:setAnchorPoint(ccp(0.5, 0.5))
    closeBtn:setPosition(ccp(alertBg:getContentSize().width*0.95, alertBg:getContentSize().height*0.98))
	closeMenuBar:addChild(closeBtn)

	-- 标题
	local titleLabel = CCRenderLabel:create(GetLocalizeStringBy("key_3158"), g_sFontPangWa, 35, 1, ccc3( 0xff, 0xff, 0xff), type_stroke)
    -- titleLabel:setSourceAndTargetColor(ccc3( 0xff, 0xed, 0x55), ccc3( 0xff, 0x8f, 0x00));
    titleLabel:setColor(ccc3(0x78, 0x25, 0x00))
    titleLabel:setAnchorPoint(ccp(0.5, 0.5))
    titleLabel:setPosition(ccp(alertBgSize.width*0.5, alertBgSize.height - 72))
    alertBg:addChild(titleLabel)

	-- 描述
    if tipText ~= nil then
        local descLabel = CCLabelTTF:create(tipText, g_sFontName, 25, CCSizeMake(460, 120), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
        descLabel:setColor(ccc3(0x78, 0x25, 0x00))
        descLabel:setAnchorPoint(ccp(0.5, 0.5))
        descLabel:setPosition(ccp(alertBgSize.width * 0.5, alertBgSize.height - 180))
        alertBg:addChild(descLabel)
    end
    if tipText2 ~= nil then
        local descLabel2 = CCLabelTTF:create(tipText2, g_sFontName, 23, CCSizeMake(460, 120), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
        descLabel2:setColor(ccc3(0x78, 0x25, 0x00))
        descLabel2:setAnchorPoint(ccp(0.5, 1))
        descLabel2:setPosition(ccp(alertBgSize.width * 0.5, alertBgSize.height - 210))
        alertBg:addChild(descLabel2)
    end
	-- 按钮
	local menuBar = CCMenu:create()
	menuBar:setPosition(ccp(0,0))
	menuBar:setTouchPriority(-5601)
	alertBg:addChild(menuBar)

	-- 确认
	-- local confirmBtn = LuaMenuItem.createItemImage("images/tip/btn_confirm_n.png", "images/tip/btn_confirm_h.png", menuAction )
	require "script/libs/LuaCC"
	local confirmBtn = LuaCC.create9ScaleMenuItem("images/star/intimate/btn_blue_n.png", "images/star/intimate/btn_blue_h.png",CCSizeMake(160, 70), confirmTitle,ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	confirmBtn:setAnchorPoint(ccp(0.5, 0.5))

    confirmBtn:registerScriptTapHandler(menuAction)
	menuBar:addChild(confirmBtn, 1, 10001)
	
	-- 取消
	-- local cancelBtn = LuaMenuItem.createItemImage("images/tip/btn_cancel_n.png", "images/tip/btn_cancel_n.png", menuAction )
	local cancelBtn = LuaCC.create9ScaleMenuItem("images/star/intimate/btn_blue_n.png", "images/star/intimate/btn_blue_h.png",CCSizeMake(160, 70), cancelTitle,ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	cancelBtn:setAnchorPoint(ccp(0.5, 0.5))
    -- cancelBtn:setPosition(alertBgSize.width*520/640, alertBgSize.height*0.4))
    cancelBtn:registerScriptTapHandler(menuAction)
	menuBar:addChild(cancelBtn, 1, 10002)

	if (isNeedCancel) then
		confirmBtn:setPosition(ccp(alertBgSize.width*0.3, alertBgSize.height*0.2))
		cancelBtn:setPosition(ccp(alertBgSize.width*0.7, alertBgSize.height*0.2))
	else
		confirmBtn:setPosition(ccp(alertBgSize.width*0.5, alertBgSize.height*0.2))
		cancelBtn:setVisible(false)
	end

	-- 背包去掉扩充用
	if(isNeedKuoChong == false)then
		cancelBtn:setPosition(ccp(alertBgSize.width*0.5, alertBgSize.height*0.2))
		confirmBtn:setVisible(false)
	end
end

-- 显示通知对话框
local _bNoticeDialogIsVisible=false
function showNoticeDialog(tParam)
	if _bNoticeDialogIsVisible then
		return
	end
	require "script/ui/network/LoadingUI"
	LoadingUI.stopLoadingUI()
	_bNoticeDialogIsVisible = true
	--标题文本
	local title = tParam.title or GetLocalizeStringBy("key_3158")
	-- 正文文本
	local text = tParam.text or ""
	-- 创建灰色摭罩层
	local cclMask = CCLayerColor:create(ccc4(155,150,150,80))
	cclMask:setTouchEnabled(true)
	cclMask:registerScriptTouchHandler(function ( ... )
		return true
	end, false, -999999998, true)
--	cclMask:setTouchPriority(-99999999)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:addChild(cclMask, 999999998)

-- 主体背景框
	local tBgPreferredSize=CCSizeMake(536, 360)
	local cs9Bg=CCScale9Sprite:create("images/common/viewbg1.png", CCRectMake(0,0,213,171), CCRectMake(50,50,113,71))
	cs9Bg:setPreferredSize(tBgPreferredSize)
	cs9Bg:setAnchorPoint(ccp(0.5, 0.5))
	cs9Bg:setPosition(g_winSize.width/2, g_winSize.height/2)
	cs9Bg:setScale(g_fElementScaleRatio)
	cclMask:addChild(cs9Bg)
-- 标题
	local crlTitle = CCRenderLabel:create(GetLocalizeStringBy("key_3158"), g_sFontPangWa, 35, 1, ccc3(255, 255, 255), type_stroke)
	crlTitle:setAnchorPoint(ccp(0.5, 0.5))
	crlTitle:setColor(ccc3(0x78, 0x25, 0))
	crlTitle:setPosition(tBgPreferredSize.width/2, tBgPreferredSize.height*0.8)
	cs9Bg:addChild(crlTitle)
-- 正文文本显示对象
	local cltText = CCLabelTTF:create(text, g_sFontName, 25, CCSizeMake(tBgPreferredSize.width*0.885, 120), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
	cltText:setAnchorPoint(ccp(0.5, 0.5))
	cltText:setColor(ccc3(0, 0, 0))
	cltText:setPosition(tBgPreferredSize.width/2, tBgPreferredSize.height/2)
	cs9Bg:addChild(cltText)
-- 按钮菜单栏
	local menuBar = CCMenu:create()
	menuBar:setPosition(ccp(0,0))
	menuBar:setTouchPriority(-999999999)
	cs9Bg:addChild(menuBar)

	local fullRect = CCRectMake(0, 0, 119, 64)
	local insetRect = CCRectMake(56, 29, 10, 1)
	local preferredSize = CCSizeMake(166, 64)

	local cs9BgN01 = CCScale9Sprite:create("images/common/btn/btn_blue_n.png", fullRect, insetRect)
	cs9BgN01:setPreferredSize(preferredSize)
	local cs9BgH01 = CCScale9Sprite:create("images/common/btn/btn_blue_h.png", fullRect, insetRect)
	cs9BgH01:setPreferredSize(preferredSize)
	local cmisRelogin = CCMenuItemSprite:create(cs9BgN01, cs9BgH01)
	cmisRelogin:registerScriptTapHandler(function ( ... )
		_bNoticeDialogIsVisible = false
		cclMask:removeFromParentAndCleanup(true)
		if tParam.callback then
			tParam.callback(1)
		end
	end)
	cmisRelogin:setPosition(tBgPreferredSize.width*0.1, 52)
	menuBar:addChild(cmisRelogin)

	local cs9BgN02 = CCScale9Sprite:create("images/common/btn/btn_blue_n.png", fullRect, insetRect)
	cs9BgN02:setPreferredSize(preferredSize)
	local cs9BgH02 = CCScale9Sprite:create("images/common/btn/btn_blue_h.png", fullRect, insetRect)
	cs9BgH02:setPreferredSize(preferredSize)
	local cmisReconn = CCMenuItemSprite:create(cs9BgN02, cs9BgH02)
	cmisReconn:registerScriptTapHandler(function ( ... )
		_bNoticeDialogIsVisible = false
		cclMask:removeFromParentAndCleanup(true)
		if tParam.callback then
			tParam.callback(2)
		end
	end)
	cmisReconn:setPosition(tBgPreferredSize.width*0.6, 52)
	menuBar:addChild(cmisReconn)

	local clRelogin01 = CCRenderLabel:create(GetLocalizeStringBy("key_2270"), g_sFontPangWa, 30, 1, ccc3(0, 0, 0), type_stroke)
	clRelogin01:setColor(ccc3(0xfe, 0xdb, 0x1c))
	cmisRelogin:addChild(clRelogin01)
	clRelogin01:setAnchorPoint(ccp(0.5, 0.5))
	clRelogin01:setPosition(cmisRelogin:getContentSize().width/2, cmisRelogin:getContentSize().height/2)

	local clReconn01 = CCRenderLabel:create(GetLocalizeStringBy("key_3346"), g_sFontPangWa, 30, 1, ccc3(0, 0, 0), type_stroke)
	clReconn01:setColor(ccc3(0xfe, 0xdb, 0x1c))
	cmisReconn:addChild(clReconn01)
	clReconn01:setAnchorPoint(ccp(0.5, 0.5))
	clReconn01:setPosition(cmisRelogin:getContentSize().width/2, cmisRelogin:getContentSize().height/2)
end


function showNoramlDialog(tParam)
	--标题文本
	local title = tParam.title or GetLocalizeStringBy("key_3158")
	-- 正文文本
	local text = tParam.text or ""
	-- 创建灰色摭罩层
	local cclMask = CCLayerColor:create(ccc4(0,0,0,155))
	cclMask:setTouchEnabled(true)
	cclMask:registerScriptTouchHandler(function ( ... )
		return true
	end, false, -5601, true)
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:addChild(cclMask, 2002)

-- 主体背景框
	local tBgPreferredSize=CCSizeMake(536, 360)
	local cs9Bg=CCScale9Sprite:create("images/common/viewbg1.png", CCRectMake(0,0,213,171), CCRectMake(50,50,113,71))
	cs9Bg:setPreferredSize(tBgPreferredSize)
	cs9Bg:setAnchorPoint(ccp(0.5, 0.5))
	cs9Bg:setPosition(g_winSize.width/2, g_winSize.height/2)
	cs9Bg:setScale(g_fElementScaleRatio)
	cclMask:addChild(cs9Bg)
-- 标题
	local crlTitle = CCRenderLabel:create(GetLocalizeStringBy("key_3158"), g_sFontPangWa, 35, 1, ccc3(255, 255, 255), type_stroke)
	crlTitle:setAnchorPoint(ccp(0.5, 0.5))
	crlTitle:setColor(ccc3(0x78, 0x25, 0))
	crlTitle:setPosition(tBgPreferredSize.width/2, tBgPreferredSize.height*0.8)
	cs9Bg:addChild(crlTitle)
-- 正文文本显示对象
	local cltText = CCLabelTTF:create(text, g_sFontName, 25, CCSizeMake(tBgPreferredSize.width*0.885, 120), kCCTextAlignmentCenter, kCCVerticalTextAlignmentTop)
	cltText:setAnchorPoint(ccp(0.5, 0.5))
	cltText:setColor(ccc3(0, 0, 0))
	cltText:setPosition(tBgPreferredSize.width/2, tBgPreferredSize.height/2)
	cs9Bg:addChild(cltText)
-- 按钮菜单栏
	local menuBar = CCMenu:create()
	menuBar:setPosition(ccp(0,0))
	menuBar:setTouchPriority(-5602)
	cs9Bg:addChild(menuBar)

	local fullRect = CCRectMake(0, 0, 119, 64)
	local insetRect = CCRectMake(56, 29, 10, 1)
	local preferredSize = CCSizeMake(136, 64)

	for i=1, #tParam.items do
		local cs9BgN = CCScale9Sprite:create("images/common/btn/btn_blue_n.png", fullRect, insetRect)
		local cs9BgH = CCScale9Sprite:create("images/common/btn/btn_blue_h.png", fullRect, insetRect)
		cs9BgN:setPreferredSize(preferredSize)
		cs9BgH:setPreferredSize(preferredSize)
		local cmisBtn = CCMenuItemSprite:create(cs9BgN, cs9BgH)
		cmisBtn:registerScriptTapHandler(function (tag, obj)
			cclMask:removeFromParentAndCleanup(true)
			if tParam.callback then
				tParam.callback(tag)
			end
		end)
		local clTitle = CCRenderLabel:create(tParam.items[i].text, g_sFontPangWa, 30, 1, ccc3(0, 0, 0), type_stroke)
		clTitle:setColor(ccc3(0xfe, 0xdb, 0x1c))
		clTitle:setAnchorPoint(ccp(0.5, 0.5))
		clTitle:setPosition(cmisBtn:getContentSize().width/2, cmisBtn:getContentSize().height/2)
		cmisBtn:addChild(clTitle)
		cmisBtn:setPosition(tParam.items[i].pos_x, tParam.items[i].pos_y)
		menuBar:addChild(cmisBtn, 0, tParam.items[i].tag)
	end

end



