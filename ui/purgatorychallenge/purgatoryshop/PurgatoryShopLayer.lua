-- Filename: PurgatoryShopLayer.lua
-- Author: lichenyang
-- Date: 2015-05-06
-- Purpose: 个人跨服赛商店显示层

module("PurgatoryShopLayer", package.seeall)

require "script/ui/purgatorychallenge/PurgatoryData"
require "script/ui/purgatorychallenge/purgatoryshop/PurgatoryShopData"
require "script/ui/purgatorychallenge/purgatoryshop/PurgatoryShopCell"
require "script/ui/purgatorychallenge/purgatoryshop/PurgatoryShopService"
require "script/model/user/UserModel"
local _touchPrority = nil
local _zOrder       = nil
local _bgLayer      = nil

function init()
	_touchPrority = nil
	_zOrder       = nil
	_bgLayer      = nil
end

function show(p_touchPrority, p_zOrder)
    AudioUtil.playBgm("audio/bgm/music17.mp3")
	local layer = createLayer()
	MainScene.changeLayer(layer, "PurgatoryShopLayer")
end

function createLayer(p_touchPrority, p_zOrder)
    local zeroTime = TimeUtil.getCurDayZeroTime()
    local curServerTime = BTUtil:getSvrTimeInterval()

    MainScene.setMainSceneViewsVisible(false,false,false)
	_zOrder = p_zOrder or 800
	_priority = p_touchPrority or -300
	_bgLayer = CCLayer:create()
	loadBg()
	loadMenu()
    PurgatoryShopService.getInfo(function ( ... )
        loadTableView()
    end)
    local actions1 = CCArray:create()
            actions1:addObject(CCDelayTime:create(0.1))
            actions1:addObject(CCCallFunc:create(function ( ... )
                curServerTime = BTUtil:getSvrTimeInterval()
                if(tonumber(curServerTime)==tonumber(zeroTime))then
                    PurgatoryShopService.getInfo(function ( ... )
                        updateCell()
                    end)
                end
            end))
    local sequence = CCSequence:create(actions1)
    local action = CCRepeatForever:create(sequence)
    _bgLayer:runAction(action)
	return _bgLayer
end

function loadBg( ... )
	--背景
    local underLayer = CCScale9Sprite:create("images/purgatory/blackbg.png")
    underLayer:setContentSize(CCSizeMake(g_winSize.width,g_winSize.height))
    underLayer:setAnchorPoint(ccp(0,0))
    underLayer:setPosition(ccp(0,0))
    _bgLayer:addChild(underLayer)

    local _spellEffectSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/purgatory/lianyvshangdian/lianyvshangdian"), -1,CCString:create(""));
    _spellEffectSprite:setAnchorPoint(ccp(0.5,0))
    _spellEffectSprite:retain()
    _spellEffectSprite:setScale(g_fElementScaleRatio)
    _spellEffectSprite:setPosition(ccp(_bgLayer:getContentSize().width*0.5, _bgLayer:getContentSize().height*0.5))
    underLayer:addChild(_spellEffectSprite,999);
    _spellEffectSprite:release()

    --阳光
    local sunShineSprite = CCSprite:create("images/barn/sun_shine.png")
    sunShineSprite:setAnchorPoint(ccp(0.5,1))
    sunShineSprite:setPosition(ccp(g_winSize.width/2,g_winSize.height))
    sunShineSprite:setScale(g_fElementScaleRatio)
    _bgLayer:addChild(sunShineSprite)

    --小镁铝
    local girlSprite = CCSprite:create("images/purgatory/mengnan.png")
    girlSprite:setAnchorPoint(ccp(0,1))
    girlSprite:setPosition(ccp(0,g_winSize.height))
    girlSprite:setScale(g_fElementScaleRatio)
    _bgLayer:addChild(girlSprite)

    --活动标题
    local titleSprite = CCSprite:create("images/purgatory/lianyushangdian.png")
    titleSprite:setAnchorPoint(ccp(0.5,1))
    _bgLayer:addChild(titleSprite)
    titleSprite:setScale(g_fElementScaleRatio)
    titleSprite:setPosition(ccp(g_winSize.width * 0.5, g_winSize.height-titleSprite:getContentSize().height*g_fElementScaleRatio))

    local wmBg = CCScale9Sprite:create("images/common/purple.png")
    wmBg:setContentSize(CCSizeMake(290,55))
    wmBg:setAnchorPoint(ccp(0.5,1))
    wmBg:setPosition(ccp(g_winSize.width/2,g_winSize.height*750/960))
    wmBg:setScale(g_fElementScaleRatio)
    _bgLayer:addChild(wmBg)

    local wmTitle = CCRenderLabel:create(GetLocalizeStringBy("llp_208"), g_sFontPangWa, 25, 1, ccc3( 0x00, 0x00, 0x00), type_shadow)
    wmBg:addChild(wmTitle)
    wmTitle:setAnchorPoint(ccp(0.5, 0.5))
    wmTitle:setPosition(ccp(88, wmBg:getContentSize().height * 0.5))

    local wmIcon = CCSprite:create("images/purgatory/lianyulingsmall.png")
    wmBg:addChild(wmIcon)
    wmIcon:setAnchorPoint(ccp(0.5, 0.5))
    wmIcon:setPosition(ccp(145, wmBg:getContentSize().height * 0.5))

    _tipLabel = CCRenderLabel:create(":", g_sFontPangWa, 25, 1, ccc3(0x00, 0x00, 0x00), type_shadow)
    wmBg:addChild(_tipLabel, 1)
    _tipLabel:setAnchorPoint(ccp(0, 0.5))
    _tipLabel:setPosition(ccp(168, wmBg:getContentSize().height * 0.5))

    local pData = PurgatoryData.getCopyInfo()
    _wmLabel = CCRenderLabel:create(pData.hell_point, g_sFontPangWa, 25, 1, ccc3(0x00, 0x00, 0x00), type_shadow)
    wmBg:addChild(_wmLabel, 1)
    _wmLabel:setAnchorPoint(ccp(0, 0.5))
    _wmLabel:setPosition(ccp(174, wmBg:getContentSize().height * 0.5))
    _wmLabel:setColor(ccc3(0x00, 0xff, 0x18))
end

function loadMenu( ... )
	--menu层
    local bgMenu = CCMenu:create()
    bgMenu:setAnchorPoint(ccp(0,0))
    bgMenu:setPosition(ccp(0,0))
    bgMenu:setTouchPriority(_priority - 10)
    _bgLayer:addChild(bgMenu)

    --返回按钮
    local returnButton = CCMenuItemImage:create("images/common/close_btn_n.png","images/common/close_btn_h.png")
    returnButton:setScale(g_fElementScaleRatio)
    returnButton:setAnchorPoint(ccp(0.5,0.5))
    returnButton:setPosition(ccp(g_winSize.width*585/640,g_winSize.height*905/960))
    returnButton:registerScriptTapHandler(closeCallBack)
    bgMenu:addChild(returnButton)
end

function loadTableView()
    --tableView背景
    local viewBgSprite = CCScale9Sprite:create(CCRectMake(50,50,6,4),"images/purgatory/inbg.png")
    viewBgSprite:setContentSize(CCSizeMake(g_winSize.width*605/640,g_winSize.height*650/960))
    viewBgSprite:setAnchorPoint(ccp(0.5,1))
    viewBgSprite:setPosition(ccp(g_winSize.width/2,g_winSize.height*675/960))
    _bgLayer:addChild(viewBgSprite)

    _shopInfo = PurgatoryShopData.getItemList()

    local h = LuaEventHandler:create(function(fn,p_table,a1,a2)
        local r
        if fn == "cellSize" then
            r = CCSizeMake(605*g_fScaleX, 190*g_fScaleX)
        elseif fn == "cellAtIndex" then
            a2 = PurgatoryShopCell.createCell(_shopInfo[a1 + 1], a1 + 1)
            a2:setScale(g_fScaleX)
            r = a2
        elseif fn == "numberOfCells" then
            r = table.count(_shopInfo)
        else
        end
        return r
    end)

    _tableView = LuaTableView:createWithHandler(h, CCSizeMake(viewBgSprite:getContentSize().width,viewBgSprite:getContentSize().height - 10))
    viewBgSprite:addChild(_tableView)
    _tableView:setVerticalFillOrder(kCCTableViewFillTopDown)
    _tableView:setAnchorPoint(ccp(0,0))
    _tableView:setPosition(ccp(0,5))
    _tableView:setTouchPriority(_priority - 2)
end

function updateCell( )
    _shopInfo = PurgatoryShopData.getItemList()
    local offset = _tableView:getContentOffset()
    _tableView:reloadData()
    _tableView:setContentOffsetInDuration(offset,0)

end

function updateWmLable( ... )
    local pData = PurgatoryData.getCopyInfo()
   _wmLabel:setString(tostring(pData.hell_point))
end


function closeCallBack()
	PurgatoryMainLayer.showLayer()
end
