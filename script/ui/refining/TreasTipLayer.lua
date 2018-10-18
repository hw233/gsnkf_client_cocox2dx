-- Filename: TreasTipLayer.lua
-- Author: zhang zihang
-- Date: 2015-4-28
-- Purpose: 该文件用于: 炼化宝物提示

module ("TreasTipLayer", package.seeall)

local _bgLayer = nil
local _touchProperty 
local _zOrder
local _callBackFn

local function init()
    _bgLayer = nil
    _touchProperty= nil
    _zOrder= nil
    _callBackFn= nil

end

local function onTouchesHandler(  )
    return true
end

local function onNodeEvent( event )
    if (event == "enter") then
        _bgLayer:registerScriptTouchHandler(onTouchesHandler, false, _touchProperty, true)
        _bgLayer:setTouchEnabled(true)
    elseif (event == "exit") then

        _bgLayer:unregisterScriptTouchHandler()
    end
end

function closeCb()
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
    _bgLayer:removeFromParentAndCleanup(true)
    _bgLayer = nil

    --require "script/ui/recycle/BreakDownLayer"
    --BreakDownLayer.cancelBreakDown()
end

function okCb()
    require "script/audio/AudioUtil"
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
    _bgLayer:removeFromParentAndCleanup(true)
    _bgLayer = nil

    if(_callBackFn~= nil) then 
        _callBackFn()
    end
end

-- 
function showLayer( itemInfo, callBackFn,touchProperty, zOrder )
    init()
    print("itemInfo itemInfo itemInfo")
    print_t(itemInfo)
    _callBackFn= callBackFn
    _touchProperty = touchProperty or -555
    _zOrder = zOrder or _zOrder

    _bgLayer = CCLayerColor:create(ccc4(0,0,0,155))
    _bgLayer:registerScriptHandler(onNodeEvent)
    --_bgLayer:registerScriptTouchHandler(onTouchesHandler, false, _touchProperty, true)
    local runningScene = CCDirector:sharedDirector():getRunningScene()
    runningScene:addChild(_bgLayer, 999)

    require "script/ui/main/MainScene"
    local myScale = MainScene.elementScale
    local mySize = CCSizeMake(550,390)

    local fullRect = CCRectMake(0, 0, 213, 171)
    local insetRect = CCRectMake(84, 84, 2, 3)
    local breakSayBg = CCScale9Sprite:create("images/common/viewbg1.png",fullRect,insetRect)
    breakSayBg:setContentSize(mySize)
    breakSayBg:setScale(myScale)
    breakSayBg:setPosition(ccp(g_winSize.width*0.5,g_winSize.height*0.5))
    breakSayBg:setAnchorPoint(ccp(0.5,0.5))
    _bgLayer:addChild(breakSayBg)

    local labelTitle = CCRenderLabel:create(GetLocalizeStringBy("key_3158"), g_sFontPangWa,35,2,ccc3(0xff,0xff,0xff),type_shadow)
    labelTitle:setPosition(ccp(breakSayBg:getContentSize().width/2, breakSayBg:getContentSize().height-35))
    labelTitle:setAnchorPoint(ccp(0.5,1))
    labelTitle:setColor(ccc3(0x78,0x25,0x00))
    breakSayBg:addChild(labelTitle)

    -- .. itemInfo.itemDesc.name .. GetLocalizeStringBy("key_1079") .. tonumber(itemInfo.itemDesc.quality) ..GetLocalizeStringBy("key_3330"),
    local content = CCLabelTTF:create(GetLocalizeStringBy("key_2364") , g_sFontName ,24)
    content:setColor(ccc3(0x78,0x25,0x00))
    if table.count(itemInfo) > 3 then
        content:setPosition(ccp(breakSayBg:getContentSize().width/2, breakSayBg:getContentSize().height/2+80))
    else
        content:setPosition(ccp(breakSayBg:getContentSize().width/2, breakSayBg:getContentSize().height/2+60))
    end
    content:setAnchorPoint(ccp(0.5,0.5))
    breakSayBg:addChild(content)

    require "script/ui/hero/HeroPublicLua"
    require "script/utils/BaseUI"

    if table.count(itemInfo) > 3 then
        local contentTable = {}
        for i = 1,3 do
            local content = CCRenderLabel:create("[" .. itemInfo[i].itemDesc.name .. "]", g_sFontName ,24,1,ccc3(0x0,0x0,0x0), type_stroke)
            content:setColor(HeroPublicLua.getCCColorByStarLevel(itemInfo[i].itemDesc.quality))
            local content2 = CCLabelTTF:create("，", g_sFontName ,24)
            content2:setColor(ccc3(0x78,0x25,0x00))
            local aleteNode = BaseUI.createHorizontalNode({content, content2})
            table.insert(contentTable,aleteNode)
        end

        local aleteNode = BaseUI.createHorizontalNode(contentTable)
        aleteNode:setAnchorPoint(ccp(0.5, 0.5))
        aleteNode:setPosition(ccp(breakSayBg:getContentSize().width/2, breakSayBg:getContentSize().height/2+40))
        breakSayBg:addChild(aleteNode)

        local contentTable = {}
        for i = 4,#itemInfo do
            local content = CCRenderLabel:create("[" .. itemInfo[i].itemDesc.name .. "]", g_sFontName ,24,1,ccc3(0x0,0x0,0x0), type_stroke)
            content:setColor(HeroPublicLua.getCCColorByStarLevel(itemInfo[i].itemDesc.quality))
            local content2 = CCLabelTTF:create("，", g_sFontName ,24)
            content2:setColor(ccc3(0x78,0x25,0x00))
            local aleteNode = BaseUI.createHorizontalNode({content, content2})
            table.insert(contentTable,aleteNode)
        end

        local aleteNode = BaseUI.createHorizontalNode(contentTable)
        aleteNode:setAnchorPoint(ccp(0.5, 0.5))
        aleteNode:setPosition(ccp(breakSayBg:getContentSize().width/2, breakSayBg:getContentSize().height/2))
        breakSayBg:addChild(aleteNode)
    else
        local contentTable = {}
        for i = 1,#itemInfo do
            local content = CCRenderLabel:create("[" .. itemInfo[i].itemDesc.name .. "]", g_sFontName ,24,1,ccc3(0x0,0x0,0x0), type_stroke)
            content:setColor(HeroPublicLua.getCCColorByStarLevel(itemInfo[i].itemDesc.quality))
            local content2 = CCLabelTTF:create("，", g_sFontName ,24)
            content2:setColor(ccc3(0x78,0x25,0x00))
            local aleteNode = BaseUI.createHorizontalNode({content, content2})
            table.insert(contentTable,aleteNode)
        end

        local aleteNode = BaseUI.createHorizontalNode(contentTable)
        aleteNode:setAnchorPoint(ccp(0.5, 0.5))
        aleteNode:setPosition(ccp(breakSayBg:getContentSize().width/2, breakSayBg:getContentSize().height/2+20))
        breakSayBg:addChild(aleteNode)
    end
    local aleteNode = nil
    local contentNew = nil
    -- local isHaveInlay = false
    -- for i=1 ,#itemInfo do
    --     if(itemInfo[i].va_item_text and not table.isEmpty(itemInfo[i].va_item_text.treasureInlay))then
    --         isHaveInlay = true
    --         break
    --     end
    -- end
   --if(not isHaveInlay)then
        --宝物上没有符印
        local content2 = CCLabelTTF:create(GetLocalizeStringBy("key_1079")..GetLocalizeStringBy("djn_177"), g_sFontName ,24)
        content2:setColor(ccc3(0x78,0x25,0x00))
        -- local content3 = CCRenderLabel:create( itemInfo[1].itemDesc.quality .. GetLocalizeStringBy("key_1119"), g_sFontName ,24,1,ccc3(0x0,0x0,0x0), type_stroke)
        -- content3:setColor(HeroPublicLua.getCCColorByStarLevel(tonumber(itemInfo[1].itemDesc.quality)))
        local content3 = CCLabelTTF:create( GetLocalizeStringBy("key_2977"), g_sFontName ,24)
        content3:setColor(ccc3(0x78,0x25,0x00))
        
        aleteNode = BaseUI.createHorizontalNode({content2, content3})
        aleteNode:setAnchorPoint(ccp(0.5, 0.5))

        local contentNew1 = CCLabelTTF:create(GetLocalizeStringBy("key_1256"), g_sFontName ,24)
        contentNew1:setColor(ccc3(0x78,0x25,0x00))
        local contentNew2 = CCRenderLabel:create(GetLocalizeStringBy("key_1612"), g_sFontName ,24,1,ccc3(0x0,0x0,0x0), type_stroke)
        contentNew2:setColor(HeroPublicLua.getCCColorByStarLevel(5))
        local contentNew3 = CCLabelTTF:create(GetLocalizeStringBy("key_2191"), g_sFontName ,24)
        contentNew3:setColor(ccc3(0x78,0x25,0x00))

        contentNew = BaseUI.createHorizontalNode({contentNew1, contentNew2,contentNew3})
       
    -- else
    --     --宝物上有符印
    --     local content2 = CCLabelTTF:create(GetLocalizeStringBy("djn_222"), g_sFontName ,24)
    --     content2:setColor(ccc3(0x78,0x25,0x00))
    --     -- local content3 = CCRenderLabel:create( itemInfo[1].itemDesc.quality .. GetLocalizeStringBy("key_1119"), g_sFontName ,24,1,ccc3(0x0,0x0,0x0), type_stroke)
    --     -- content3:setColor(HeroPublicLua.getCCColorByStarLevel(tonumber(itemInfo[1].itemDesc.quality)))
    --     local content3 = CCLabelTTF:create( GetLocalizeStringBy("lic_1531"), g_sFontName ,24)
    --     content3:setColor(HeroPublicLua.getCCColorByStarLevel(5))

    --     local content4 = CCLabelTTF:create(","..GetLocalizeStringBy("djn_223"), g_sFontName ,24)
    --     content4:setColor(ccc3(0x78,0x25,0x00))
    --     aleteNode = BaseUI.createHorizontalNode({content2, content3,content4})
    --     aleteNode:setAnchorPoint(ccp(0.5, 0.5))

    -- end
  
    if table.count(itemInfo) > 3 then
        aleteNode:setPosition(ccp(breakSayBg:getContentSize().width/2, breakSayBg:getContentSize().height/2-40))
        if(contentNew)then
            contentNew:setAnchorPoint(ccp(0.5,0.5))
            breakSayBg:addChild(contentNew)
            contentNew:setPosition(ccp(breakSayBg:getContentSize().width/2, breakSayBg:getContentSize().height/2-80))
        end
    else
        aleteNode:setPosition(ccp(breakSayBg:getContentSize().width/2, breakSayBg:getContentSize().height/2-20))
        if(contentNew)then
            contentNew:setAnchorPoint(ccp(0.5,0.5))
            breakSayBg:addChild(contentNew)
            contentNew:setPosition(ccp(breakSayBg:getContentSize().width/2, breakSayBg:getContentSize().height/2-60))
        end
    end
    breakSayBg:addChild(aleteNode)

    local menu = CCMenu:create()
    menu:setPosition(ccp(0,0))
    menu:setTouchPriority(-600)
    breakSayBg:addChild(menu,99)

    local width = nil
    local cancelBtn = CCMenuItemImage:create("images/common/btn/btn_blue_n.png", "images/common/btn/btn_blue_h.png")
    cancelBtn:setPosition(ccp(breakSayBg:getContentSize().width*0.75,35))
    cancelBtn:setAnchorPoint(ccp(0.5,0))
    menu:addChild(cancelBtn)
    local closeLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2326"), g_sFontPangWa,30,2,ccc3(0x00,0x00,0x0),type_stroke)
    closeLabel:setColor(ccc3(0xfe,0xdb,0x1c))
    width = (cancelBtn:getContentSize().width - closeLabel:getContentSize().width)/2
    closeLabel:setPosition(ccp(width,54))
    cancelBtn:addChild(closeLabel)
    cancelBtn:registerScriptTapHandler(closeCb)

    local okBtn = CCMenuItemImage:create("images/common/btn/btn_blue_n.png", "images/common/btn/btn_blue_h.png")
    okBtn:setPosition(ccp(breakSayBg:getContentSize().width*0.25,35))
    okBtn:setAnchorPoint(ccp(0.5,0))
    menu:addChild(okBtn)
    local closeLabel = CCRenderLabel:create(GetLocalizeStringBy("key_1465"), g_sFontPangWa,30,2,ccc3(0x00,0x00,0x0),type_stroke)
    closeLabel:setColor(ccc3(0xfe,0xdb,0x1c))
    width = (okBtn:getContentSize().width - closeLabel:getContentSize().width)/2
    closeLabel:setPosition(ccp(width,54))
    okBtn:addChild(closeLabel)
    okBtn:registerScriptTapHandler(okCb)
    
    local closeBtn = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
    closeBtn:setPosition(ccp(mySize.width*1.03,mySize.height*1.03))
    closeBtn:setAnchorPoint(ccp(1,1))
    closeBtn:registerScriptTapHandler(closeCb)
    menu:addChild(closeBtn)

end
