---
--- 用来处理红点生成规则
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Bailixi.
--- DateTime: 2023/10/13 15:23
---

-- local RedDotGenerateHelper = require("Client.Modules.RedDot.RedDotGenerateHelper")
-- RedDotGenerateHelper.GenerateHeroModuleRedDot(itemIds)

local RedDotGenerateHelper = {}

---获得对应模块的红点前缀
---@param ApplyModel string|number 需要获取的模块配置
---@param ItemId number 需要获得前缀的物品id
---@return string
function RedDotGenerateHelper.RedDotGenerateRuleCfg_GetPreStr(ApplyModel, ItemId)    
    local ItemCfg = G_ConfigHelper:GetSingleItemById(Cfg_ItemConfig, ItemId)
    local AllData = G_ConfigHelper:GetMultiItemsByKeys(Cfg_RedDotGenerateRuleCfg, 
            {
                Cfg_RedDotGenerateRuleCfg_P.RedDotGenerateRuleApplyModule,
                Cfg_RedDotGenerateRuleCfg_P.RedDotGenerateRuleApplyItemMainType,
                Cfg_RedDotGenerateRuleCfg_P.RedDotGenerateRuleApplyItemSubType,
            },
            {
                ApplyModel,
                ItemCfg[Cfg_ItemConfig_P.Type],
                ItemCfg[Cfg_ItemConfig_P.SubType]
            }
    )
    
    local PreStrs = {}
    for _, v in pairs(AllData) do
        table.insert(PreStrs, v[Cfg_RedDotGenerateRuleCfg_P.RedDotGenerateRulePreStr])
    end
    
    return PreStrs
end

---生成英雄模块的红点数据
---@param itemIds number[] 需要获得前缀的物品id
function RedDotGenerateHelper.GenerateHeroModuleRedDot(itemIds)
    for _, itemId in pairs(itemIds) do
        local PreStrs = RedDotGenerateHelper.RedDotGenerateRuleCfg_GetPreStr("Hero", itemId)
        if not PreStrs or not next(PreStrs) then
            CError("[cw] Cannot find Generate Rule of item(" .. tostring(itemId) .. ") in hero Module, Please Check source data")
        else
            ---@type RedDotModel
            local RedDotModel = MvcEntry:GetModel(RedDotModel)
            for _, pre in pairs(PreStrs) do
                RedDotModel:AddRedDot(pre, itemId)
            end
        end
    end
end

return RedDotGenerateHelper