-- Filename: SevenLotteryRewardShowDialog.lua
-- Author: llp
-- Date: 2016-08-11

module("SevenLotteryRewardShowDialog", package.seeall)

require "script/utils/BaseUI"
require "script/ui/hero/HeroPublicLua"
require "script/ui/refining/preview/RefiningPreviewUtil"

local _touchPriority 	= nil	-- 触摸优先级
local _zOrder 		 	= nil	-- 显示层级
local _bgLayer 		 	= nil	-- 背景层
local _okCallBack 		= nil   -- 确定回调

--[[
	@desc 	: 初始化方法
	@param 	: 
	@return : 
--]]
local function init()
	_touchPriority 	 = nil
	_zOrder 		 = nil
	_bgLayer 		 = nil
	_okCallBack		 = nil
end

--[[
	@desc 	: 显示界面方法
	@param 	: pItemArrData 	炼化将获得的物品信息
	@param  : pHadFiveStr   炼化高级物品提示文字
	@param 	: pHadMaxStar   炼化物品最高星级
	@param	: pCallBackFunc 确定回调
	@param 	: pTouchPriority 触摸优先级
	@param 	: pZorder 显示层级
	@return : 
--]]
function showDialog( pItemArrData, pHadFiveStr, pHadMaxStar, pCallBackFunc, pTouchPriority, pZorder )
	_okCallBack = pCallBackFunc
	_touchPriority = pTouchPriority or -1800
	_zOrder = pZorder or 800

    local layer = createDialog(pItemArrData,pHadFiveStr,pHadMaxStar,_okCallBack,_touchPriority, _zOrder)
	local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(layer,_zOrder)
end

--[[
	@desc 	: 背景层触摸回调
	@param 	: eventType 事件类型 x,y 触摸点
	@return : 
--]]
local function layerToucCallback( eventType, x, y )
	return true
end

--[[
	@desc 	: 回调onEnter和onExit事件
	@param 	: event 事件名
	@return : 
--]]
function onNodeEvent( event )
	if (event == "enter") then
		_bgLayer:registerScriptTouchHandler(layerToucCallback,false,_touchPriority,true)
		_bgLayer:setTouchEnabled(true)
	elseif (event == "exit") then
		_bgLayer:unregisterScriptTouchHandler()
		_bgLayer = nil
	end
end

--[[
	@desc 	: 创建Dialog及UI
	@param 	: pItemArrData 炼化将获得的物品信息
	@param  : pHadFiveStr  炼化高级物品提示文字
	@param 	: pHadMaxStar  炼化物品最高星级
	@param	: pCallBackFunc 确定回调
	@param 	: pTouchPriority 触摸优先级
	@param 	: pZorder 显示层级
	@return : 
--]]
function createDialog( pItemArrData, pHadFiveStr, pHadMaxStar, pCallBackFunc, pTouchPriority, pZorder )
	_okCallBack = pCallBackFunc
	_touchPriority = pTouchPriority or -800
	_zOrder = pZorder or 800

	-- print("pHadFiveStr:",pHadFiveStr)
	-- print("pHadMaxStar:",pHadMaxStar)
	local bgSize = CCSizeMake(600,510)
	if pHadFiveStr ~= nil then
		bgSize = CCSizeMake(600,550)
	end

	-- 背景层
	_bgLayer = CCLayerColor:create(ccc4(11,11,11,200))
	_bgLayer:setPosition(ccp(0, 0))
	_bgLayer:registerScriptHandler(onNodeEvent)
	_bgLayer:setAnchorPoint(ccp(0, 0))

	-- 背景框
	local bgSprite = CCScale9Sprite:create(CCRectMake(100, 80, 10, 20),"images/common/viewbg1.png")
	bgSprite:setContentSize(bgSize)
	bgSprite:setAnchorPoint(ccp(0.5,0.5))
	bgSprite:setScale(g_fElementScaleRatio)
	bgSprite:setPosition(ccp(g_winSize.width*0.5,g_winSize.height*0.5))
	_bgLayer:addChild(bgSprite)

	-- 标题
	local titlePanel = CCSprite:create("images/common/viewtitle1.png")
	titlePanel:setAnchorPoint(ccp(0.5, 0.5))
	titlePanel:setPosition(ccp(bgSprite:getContentSize().width/2, bgSprite:getContentSize().height-6.6))
	bgSprite:addChild(titlePanel)

	local titleLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2295"), g_sFontPangWa, 33 ,1, ccc3( 0x00, 0x00, 0x00), type_stroke)
	titleLabel:setColor(ccc3(0xff, 0xe4, 0x00))
	titleLabel:setAnchorPoint(ccp(0.5,0.5))
	titleLabel:setPosition(ccp(titlePanel:getContentSize().width*0.5, titlePanel:getContentSize().height*0.5))
	titlePanel:addChild(titleLabel)

	-- 返回按钮Menu
	local backMenu = CCMenu:create()
    backMenu:setPosition(ccp(0, 0))
    backMenu:setAnchorPoint(ccp(0,0))
    backMenu:setTouchPriority(_touchPriority-30)
    bgSprite:addChild(backMenu, 10)

    -- 返回按钮
    local backItem = CCMenuItemImage:create("images/common/btn_close_n.png","images/common/btn_close_h.png")
    backItem:setAnchorPoint(ccp(0.5,0.5))
    backItem:setPosition(ccp(bgSprite:getContentSize().width*0.955, bgSprite:getContentSize().height*0.975))
    backItem:registerScriptTapHandler(backItemCallback)
    backMenu:addChild(backItem,1)

    -- 确定按钮
    require "script/libs/LuaCC"
	local okItem = LuaCC.create9ScaleMenuItem("images/common/btn/btn_blue_n.png","images/common/btn/btn_blue_h.png",CCSizeMake(150, 64), GetLocalizeStringBy("key_10114"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	okItem:setAnchorPoint(ccp(0.5, 0.5))
	okItem:registerScriptTapHandler(okItemCallback)
	okItem:setPosition(ccp(bgSprite:getContentSize().width*0.5, 65))
	backMenu:addChild(okItem,1)

	-- 取消按钮
	-- local noItem = LuaCC.create9ScaleMenuItem("images/common/btn/btn_blue_n.png","images/common/btn/btn_blue_h.png",CCSizeMake(150, 64), GetLocalizeStringBy("key_2326"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
	-- noItem:setAnchorPoint(ccp(0.5, 0.5))
	-- noItem:registerScriptTapHandler(backItemCallback)
	-- noItem:setPosition(ccp(bgSprite:getContentSize().width*0.7, 65))
	-- backMenu:addChild(noItem,1)

	-- 提示文字 炼化后将会获得
	local noticeLabel = CCLabelTTF:create(GetLocalizeStringBy("llp_496"), g_sFontPangWa, 25)
    noticeLabel:setColor(ccc3(0x78, 0x25, 0x00))
    noticeLabel:setAnchorPoint(ccp(0.5,1))
    noticeLabel:setPosition(ccp(bgSprite:getContentSize().width*0.5,bgSprite:getContentSize().height-45))
    bgSprite:addChild(noticeLabel)

    -- 炼化高级物品提示
    if pHadFiveStr ~= nil then
		local fiveRichInfo = {elements = {},lineAlignment = 2,alignment = 2,defaultType = "CCLabelTTF",}
		local tmpRich ={}
		tmpRich = {
		        text = GetLocalizeStringBy("lgx_1061"),
		        font = g_sFontPangWa,
		        size = 25,
		        color = ccc3(0x78, 0x25, 0x00)
		       }
		table.insert(fiveRichInfo.elements,tmpRich)
		tmpRich = {
		        text = pHadFiveStr,
		        font = g_sFontPangWa,
		        size = 25,
		        color = HeroPublicLua.getCCColorByStarLevel(pHadMaxStar)
		       }
		table.insert(fiveRichInfo.elements,tmpRich)
		tmpRich = {
		        text = GetLocalizeStringBy("lgx_1062"),
		        font = g_sFontPangWa,
		        size = 25,
		        color = ccc3(0x78, 0x25, 0x00)
		       }
		table.insert(fiveRichInfo.elements,tmpRich)

		local fiveStrLabel = LuaCCLabel.createRichLabel(fiveRichInfo)
		fiveStrLabel:setAnchorPoint(ccp(0.5,0))
		fiveStrLabel:setPosition(ccp(bgSprite:getContentSize().width*0.5,115))
		bgSprite:addChild(fiveStrLabel)
    end

	-- 物品区域
    local itemBgSprite = CCScale9Sprite:create("images/copy/fort/textbg.png")
	itemBgSprite:setContentSize(CCSizeMake(530, 310))
	itemBgSprite:setAnchorPoint(ccp(0.5, 1))
	itemBgSprite:setPosition(ccp(bgSprite:getContentSize().width*0.5,bgSprite:getContentSize().height-85))
	bgSprite:addChild(itemBgSprite)

	-- 物品列表
	local itemTableView = createItemTableView(pItemArrData)
	itemTableView:setPosition(ccp(5, 5))
	itemBgSprite:addChild(itemTableView)

    return _bgLayer
end

--[[
	@desc 	: 创建物品列表
	@param 	: pItemArrData 重生将获得的物品信息
	@return : tableView 物品列表
--]]
function createItemTableView( pItemArrData )
	local itemData = pItemArrData or {}
	local cellSize = CCSizeMake(520, 140)
	-- 列表数据源和代理方法
	local h = LuaEventHandler:create(function(fn, table, a1, a2)
		local r
		if fn == "cellSize" then
			r = cellSize
		elseif fn == "cellAtIndex" then
			a2 = CCTableViewCell:create()
			local posArrX = {0.01,0.25,0.49,0.73}
			for i=1,4 do
				if(itemData[a1*4+i] ~= nil)then
					local itemSprite = ItemUtil.createGoodListCell(itemData[a1*4+i],_touchPriority-41,_zOrder)
					itemSprite:setAnchorPoint(ccp(0.5,1))
					itemSprite:setPosition(ccp(520*posArrX[i],0))
					a2:addChild(itemSprite)
				end
			end
			r = a2
		elseif fn == "numberOfCells" then
			local num = #itemData
			r = math.ceil(num/4)
		elseif fn == "cellTouched" then
			
		elseif (fn == "scroll") then
			
		end
		return r
	end)

	local goodTableView = LuaTableView:createWithHandler(h, CCSizeMake(520, 300))
	goodTableView:setBounceable(true)
	goodTableView:setTouchPriority(_touchPriority-40)
	-- 上下滑动
	goodTableView:setDirection(kCCScrollViewDirectionVertical)
	goodTableView:setVerticalFillOrder(kCCTableViewFillTopDown)

	return goodTableView
end

--[[
	@desc 	: 确认按钮回调,确认重生
	@param 	: 
	@return : 
--]]
function okItemCallback()
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
	-- 确认回调
	if (_okCallBack ~= nil) then
		_okCallBack()
	end
	-- 关闭界面
	backItemCallback()
end

--[[
	@desc 	: 返回/取消 按钮回调,关闭界面
	@param 	: 
	@return : 
--]]
function backItemCallback()
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
	if not tolua.isnull(_bgLayer) then
		_bgLayer:removeFromParentAndCleanup(true)
		_bgLayer = nil
	end
end