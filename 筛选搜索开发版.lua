gg.clearResults()
-- 设置内存范围为 A 区域
gg.setRanges(32)
-- 提示用户输入值
local input = gg.prompt({"输入值（例如：20;2;5）:"}, nil, {"number"})
local values = input[1]
-- 使用用户提供的值进行搜索
gg.searchNumber(values, gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)

-- 提示用户输入要搜索的具体值
local specificValue = gg.prompt({"输入要搜索的具体值:"}, nil, {"number"})
gg.searchNumber(specificValue[1], gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)

-- 提示用户是否清理保存列表
local clearList = gg.choice({'是', '否'}, nil, '是否清理保存列表？')
if clearList == 1 then
    gg.clearList()
    gg.toast('保存列表已清理')
else
    gg.toast('保存列表未清理')
end

-- 获取搜索结果
local results = gg.getResults(gg.getResultCount())

-- 提示用户输入 digitCount 的值
local digitCountPrompt = gg.prompt({'输入你需要检查的几位值'}, {''}, {'number'})
if digitCountPrompt == nil then
    gg.alert('未输入有效的 digitCount 值')
    return
end
local digitCount = tonumber(digitCountPrompt[1])

-- 提示用户输入 valueToCheck 的值
local valueToCheckPrompt = gg.prompt({'后几位想要检查的值'}, {''}, {'number'})
if valueToCheckPrompt == nil then
    gg.alert('未输入有效的 valueToCheck 值')
    return
end
local valueToCheck = valueToCheckPrompt[1]

-- 筛选结果，只保留地址中从后往前数指定位数包含指定值的结果
local finalFilteredResults = {}
for i, v in ipairs(results) do
    local addressHex = string.format('%X', v.address)
    if string.sub(addressHex, -digitCount) == valueToCheck then
        table.insert(finalFilteredResults, v)
    end
end

-- 清除原始搜索结果
gg.clearResults()

-- 将筛选后的结果保存到 GG 修改器
gg.addListItems(finalFilteredResults)

-- 以弹幕形式提示筛选后的结果数量
gg.toast('筛选完成，共筛选了 ' .. #finalFilteredResults .. ' 个地址')
