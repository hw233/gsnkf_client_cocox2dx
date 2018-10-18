-- FileName: OneKeyFuseOverDailog.lua 
-- Author: licong 
-- Date: 14-10-11 
-- Purpose: 一键合成后展示框 


module("OneKeyFuseOverDailog", package.seeall)

local _bgLayer                  	= nil
local _backGround 					= nil
local _second_bg  					= nil

local _desItemTid 					= nil
local _fuseNum 						= nil

function init( ... )
	_bgLayer                    	= nil
	_backGround 					= nil
	_second_bg  					= nil

	_desItemTid 					= nil
	_fuseNum 						= nil
end


--[[
	@des 	:touch事件处理
	@param 	:
	@return :
--]]
local function layerTouch(eventType, x, y)
    return true
end

--[[
	@des 	:关闭按钮回调
	@param 	:
	@return :
--]]
function closeButtonCallback( tag, sender )
    -- 音效
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
	if(_bgLayer)then
		_bgLayer:removeFromParentAndCleanup(true)
		_bgLayer = nil
	end
end


--[[
	@des 	:创建提示框
	@param 	:
	@return :
--]]
function createTipLayer( ... )

	_bgLayer = CCLayerColor:create(ccc4(11,11,11,200))
    _bgLayer:setTouchEnabled(true)
    _bgLayer:registerScriptTouchHandler(layerTouch,false,-650,true)
    local scene = CCDirector:sharedDirector():getRunningScene()
    scene:addChild(_bgLayer,1000,1)

	-- 创建背景
	_backGround = CCScale9Sprite:create(CCRectMake(100, 80, 10, 20),"images/common/viewbg1.png")
    _backGround:setContentSize(CCSizeMake(430, 350))
    _backGround:setAnchorPoint(ccp(0.5,0.5))
    _backGround:setPosition(ccp(_bgLayer:getContentSize().width*0.5,_bgLayer:getContentSize().height*0.5))
    _bgLayer:addChild(_backGround)
    -- 适配
    setAdaptNode(_backGround)

	-- 关闭按钮
	local menu = CCMenu:create()
    menu:setTouchPriority(-651)
	menu:setPosition(ccp(0, 0))
	menu:setAnchorPoint(ccp(0, 0))
	_backGround:addChild(menu,3)
	local closeButton = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
	closeButton:setAnchorPoint(ccp(0.5, 0.5))
	closeButton:setPosition(ccp(_backGround:getContentSize().width * 0.955, _backGround:getContentSize().height*0.975 ))
	closeButton:registerScriptTapHandler(closeButtonCallback)
	menu:addChild(closeButton)

	-- 标题
    local titlePanel = CCSprite:create("images/common/viewtitle1.png")
	titlePanel:setAnchorPoint(ccp(0.5, 0.5))
	titlePanel:setPosition(ccp(_backGround:getContentSize().width/2, _backGround:getContentSize().height-6.6 ))
	_backGround:addChild(titlePanel)
	local titleLabel = CCLabelTTF:create(GetLocalizeStringBy("lic_1255"), g_sFontPangWa, 33)
	titleLabel:setColor(ccc3(0xff, 0xe4, 0x00))
	titleLabel:setAnchorPoint(ccp(0.5,0.5))
	titleLabel:setPosition(ccp(titlePanel:getContentSize().width*0.5, titlePanel:getContentSize().height*0.5))
	titlePanel:addChild(titleLabel)

	-- 二级背景
	_second_bg = BaseUI.createContentBg(CCSizeMake(380,201))
 	_second_bg:setAnchorPoint(ccp(0.5,1))
 	_second_bg:setPosition(ccp(_backGround:getContentSize().width*0.5,_backGround:getContentSize().height-57))
 	_backGround:addChild(_second_bg)

 	-- 恭喜主公通过一键合成获得：
 	local font1 = CCRenderLabel:create(GetLocalizeStringBy("lic_1262"), g_sFontPangWa, 21, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
 	font1:setColor(ccc3(0xff,0xf6,0x00))
    font1:setAnchorPoint(ccp(0,1))
    font1:setPosition(ccp(42,_second_bg:getContentSize().height-24))
    _second_bg:addChild(font1)

    -- 要合成的宝物图标
    local iconSprite = ItemSprite.getItemSpriteById(_desItemTid,nil, nil, nil,  -651, 1010, -652)
    iconSprite:setAnchorPoint(ccp(0.5,1))
    iconSprite:setPosition(ccp(_second_bg:getContentSize().width*0.5,font1:getPositionY()-font1:getContentSize().height-15))
    _second_bg:addChild(iconSprite)

    -- 能合成的个数
	local numberLabel =  CCRenderLabel:create(_fuseNum, g_sFontPangWa,21,1,ccc3(0x00,0x00,0x00),type_stroke)
	numberLabel:setColor(ccc3(0x00,0xff,0x18))
	numberLabel:setAnchorPoint(ccp(0,0))
	local width = iconSprite:getContentSize().width - numberLabel:getContentSize().width - 6
	numberLabel:setPosition(ccp(width,5))
	iconSprite:addChild(numberLabel)

	--- 物品名字
	local itemData = ItemUtil.getItemById(_desItemTid)
    local nameColor = HeroPublicLua.getCCColorByStarLevel(itemData.quality)
	local nameLabel = CCRenderLabel:create( itemData.name , g_sFontName,21,1,ccc3(0x00,0x00,0x00),type_stroke)
	nameLabel:setColor(nameColor)
	nameLabel:setAnchorPoint(ccp(0.5,0.5))
	nameLabel:setPosition(ccp(iconSprite:getContentSize().width*0.5 ,-iconSprite:getContentSize().height*0.1-2))
	iconSprite:addChild(nameLabel)

	-- 确认
    require "script/libs/LuaCC"
    local confirmBtn = LuaCC.create9ScaleMenuItem("images/star/intimate/btn_blue_n.png", "images/star/intimate/btn_blue_h.png",CCSizeMake(160, 70), GetLocalizeStringBy("lic_1097"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
    confirmBtn:setAnchorPoint(ccp(0.5, 0))
    confirmBtn:setPosition(ccp(_backGround:getContentSize().width*0.5, 31))
    confirmBtn:registerScriptTapHandler(closeButtonCallback)
    menu:addChild(confirmBtn)
 
end


--[[
	@des 	:一键合成获提示框
	@param 	:p_item 选择要合成的物品
	@return :
--]]
function showTip( p_itemTid, p_fuseNum )
	-- 初始化
	init()

	-- 要合成宝物tid
	_desItemTid = tonumber(p_itemTid)	

	-- 合成的个数
	_fuseNum = p_fuseNum

	-- 创建提示layer
	createTipLayer()
end
































