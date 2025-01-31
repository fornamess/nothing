-- 📌 **Получаем основные сервисы Roblox**
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- 📌 **Получаем сетевое хранилище с таймаутом**
local Network = ReplicatedStorage:WaitForChild("Network", 10)
if not Network then
    return warn("❌ Network не найден! Скрипт не запущен.")
end

-- 📌 **Функция для асинхронного выполнения**
local function runAsync(func)
    task.spawn(func)
end

-- 📌 **Функции для сетевых событий**
local function invokeRemoteEvent(remoteName, args)
    local remoteEvent = Network:FindFirstChild(remoteName)
    if not remoteEvent then return warn("❌ Не найден RemoteEvent '" .. remoteName .. "'") end
    local success, result = pcall(function()
        return remoteEvent:InvokeServer(unpack(args))
    end)
    return success, result
end

-- 📌 **Авто-покупка товаров из vending machine**
runAsync(function()
    while task.wait() do
        local args = { [1] = "PotionVendingMachine" }
        local success, result = invokeRemoteEvent("VendingMachines_Purchase", args)
        if not success then
            warn("❌ Ошибка при покупке из vending machine:", result)
        end
    end
end)

-- 📌 **Авто-ролл яиц (спамим 10 роллов за тик)**
runAsync(function()
    while task.wait() do
        for i = 1, 10 do
            invokeRemoteEvent("Eggs_Roll", {})
        end
    end
end)

-- 📌 **Авто-высиживание яиц**
runAsync(function()
    while task.wait(0.1) do
        invokeRemoteEvent("Tycoons: Hatch", {})
    end
end)

-- 📌 **Авто-сбор яиц**
runAsync(function()
    local eggNames = { "TierOneEgg", "TierTwoEgg", "TierThreeEgg", "TierFourEgg", "TierFiveEgg", "TierSixEgg", "TierSevenEgg", "TierEightEgg" }
    local dropperClaimEvent = Network:FindFirstChild("Tycoons: Dropper Claim")
    if not dropperClaimEvent then return warn("❌ Не найден RemoteEvent 'Tycoons: Dropper Claim'.") end

    while task.wait(0.05) do
        local debrisFolder = Workspace:FindFirstChild("__DEBRIS")
        if not debrisFolder then continue end

        local character = LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then continue end

        for _, egg in ipairs(debrisFolder:GetChildren()) do
            if table.find(eggNames, egg.Name) then
                local eggPart = egg:FindFirstChild("Handle") or egg
                if eggPart then
                    eggPart.CanCollide = false
                    eggPart.Anchored = true
                end

                egg.Parent = character
                egg.Position = humanoidRootPart.Position + Vector3.new(0, -2, 0)

                local success, result = pcall(function()
                    return dropperClaimEvent:InvokeServer(egg)
                end)

                if success and result then
                    egg:Destroy()
                end
            end
        end
    end
end)

-- 📌 **Авто-покупка товаров**
local merchants = { "StandardMerchant", "MiningMerchant", "FishingMerchant", "IceFishingMerchant", "FactoryMerchant" }
local soldOutItems = {}

local function isItemSoldOut(merchant, slot)
    return soldOutItems[merchant] and soldOutItems[merchant][slot] or false
end

local function purchaseFromMerchants()
    while true do
        local allSoldOut = true
        for _, merchantName in ipairs(merchants) do
            for slot = 1, 8 do
                if isItemSoldOut(merchantName, slot) then continue end

                local args = { [1] = merchantName, [2] = slot }
                local success, result = invokeRemoteEvent("CustomMerchants_Purchase", args)

                if success then
                    allSoldOut = false
                else
                    warn("❌ Ошибка при покупке у " .. merchantName .. " слот " .. slot .. ": " .. result)
                    soldOutItems[merchantName] = soldOutItems[merchantName] or {}
                    soldOutItems[merchantName][slot] = true
                end

                task.wait(0.3)
            end
        end

        if allSoldOut then
            task.wait(10)
            soldOutItems = {}
        end
    end
end

runAsync(purchaseFromMerchants)

-- 📌 **Удаление питомцев**
local function removePets()
    for _, pet in ipairs(Workspace:GetChildren()) do
        if pet:IsA("Model") and pet:FindFirstChild("Humanoid") then
            local petOwner = pet:FindFirstChild("Owner")
            if petOwner and petOwner.Value == LocalPlayer then
                pet:Destroy()
            end
        end
    end
end

-- 📌 **Телепортация игрока и удаление питомцев**
local targetCFrame = CFrame.new(143.08812, 2.74222946, 308.668762, -0.931046844, 0, -0.364899606, 0, 1, 0, 0.364899606, 0, -0.931046844)

local function teleportPlayerAndRemovePets()
    removePets()
    LocalPlayer.Character:SetPrimaryPartCFrame(targetCFrame)
end

runAsync(teleportPlayerAndRemovePets)

-- 📌 **Телепортация объектов к игроку**
local function teleportObjectToPlayer(object)
    while object and object.Parent do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            object.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 2, 0)
        end
        task.wait(0.1)
    end
end

-- 📌 **Использование зелий**
local luckyPotions = {
    "8e4ba7cc7fdb47caae33616b68bd85dd",
    "a2ae174631e448b4be535e24852def23",
    "4c59135922a04e8d8e50386cb6eb145c",
    "0c7a09b80148420996fbc9534861502b",
    "dbe8fc2bf1374e7d977e3ec51604b32a",
    "4dbcbe44bf364af7a688f5a52b77ab7c",
    "c3150e8d84a243dbbbe1a34c51b2f334",
    "245f513a65264748874d9d1ab3a68276"
}

local function hasActiveBuff()
    local player = game:GetService("Players").LocalPlayer
    local buffs = player and player:FindFirstChild("Buffs")
    if buffs then
        for _, buff in ipairs(buffs:GetChildren()) do
            for _, potionID in ipairs(luckyPotions) do
                if buff.Name == potionID then
                    return true
                end
            end
        end
    end
    return false
end

local function useBestPotion()
    while true do
        if not hasActiveBuff() then
            for i = #luckyPotions, 1, -1 do
                local potionID = luckyPotions[i]
                local args = { [1] = potionID, [2] = 1 }
                local success, result = invokeRemoteEvent("Consumables_Consume", args)
                if not success then
                    warn("❌ Ошибка при использовании зелья:", result)
                end
                break
            end
        end
        task.wait(2)
    end
end

runAsync(useBestPotion)

-- 📌 **Телепортация объектов к игроку**
local function teleportObjectToPlayer(object)
    while object and object.Parent do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Обновляем позицию объекта относительно персонажа игрока
            object.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 2, 0)
        end
        task.wait(0.1)
    end
end



-- Получаем необходимые сервисы
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Функция для автоматического открытия лутбоксов
local function autoOpenLootboxes()
    -- Массив с ID предметов, которые нужно открывать
    local itemIDs = {
        "3c4ee090048140e29888ab7aa38e95f8", 
        "af6ee6c55f1140b3b58522ea6fffa247",  -- Пример предмета
        "f14ac191d0774bc99ebb0f0ec2675d9f", 
        "02936d87a8b44185bb1ba06f981099f2",
        "93540d1171d44e85aaeb6499e1966cdc",
        "c39f53c005654d47bdde51e738459c39"
    }

    -- Бесконечный цикл для открытия лутбоксов
    while true do
        for _, itemID in ipairs(itemIDs) do
            local args = {
                [1] = itemID,  -- ID предмета для открытия
                [2] = 5,  -- Количество предметов (открывать по 1 предмету за раз)
            }

            -- Попытка открыть лутбокс
            local success, result = pcall(function()
                return ReplicatedStorage.Network["Lootbox: Open"]:InvokeServer(unpack(args))
            end)

            if not success then
                warn("❌ Ошибка при открытии лутбокса с ID " .. itemID .. ":", result)
            end

            -- Пауза между открытиями (например, 0.5 секунды)
            task.wait(0.01)
        end
    end
end

-- Запуск автоматического открытия лутбоксов
autoOpenLootboxes()
