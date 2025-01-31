-- 📌 Список сгенерированных ключей
local validKeys = {
    "XbR9fZx2VjC3wD5k",
    "HtY1gLs9N0e7JqFp",
    "Dm5K2zVgQzZ0Iu4a",
    "OeL1dN3Xk8TtMbJr",
    "YpQ8VhR7Fi2N6mG4C",
    "Z4xBd2z5gO9MwJtP",
    "TnV2wFxK7Cz0Hk8U",
    "JfP9D8RkTzLwE5n1q",
    "Bv1XzM6Nz9L2JtFw",
    "GzC7TiO5p0Fw4k3X",
    "Wb3Hz6YdP2kLz7Jq",
    "R9Xs5fKi7B0cV3nW",
    "D8GpJ4m5V6kLtHzT",
    "M2Qd0FbPz8LxK1V9",
    "C0J6pLsR8kF3m5Vn",
    "Ht3A7zF5rP9VkLz2",
    "ZxX7B3tV5pLd2n0K",
    "Q4Vz1X5m8T0Fw9Jp",
    "K6y0D5fX9Zg7JmLn",
    "U2tB9F8p5C0wK3jZ",
    "Q2pY6wK4LzX7V8gM",
    "X1t0LgB3Pz9F7Cm6",
    "V7Y8sF0aN2K9mX5b",
    "J3z0FwQ6D9VpL2R5",
    "K0X1mD8V2gF9s7zT",
    "F6L3p5R9zK0YwVm1",
    "J4n7L8kV3x2FwQ0T",
    "T5Q0V2D3K9nLzFwX",
    "Zx5B0g8J1yR2p3N7",
    "P1tZ9L4xV7Y0kF3m",
    "B0mF2R6V1x7Qn8Ls",
    "F7wK5pX2t9Y0nL3Z",
    "Y3L8gD9V0F1tQ5X7",
    "Z5F2X0q9L6k8p7B1",
    "G2L9B0V5pX1F7w4N",
    "R7Y0t5L3Q2K8X9V1",
    "J5z3V0K9Y2wT7L1P",
    "X8F0p9B1N7tL2Y6v",
    "K6J5T2m8X1V9FwL0",
    "D4Z9L1X0V2T5p6mJ",
    "L1Y7Z3Q0V5B2kF9X",
    "P6X7g5V2D0K1L8T3",
    "T2Y9X0m5V7K3L1Fw",
    "B8g5V6Y0L1t9J3N2",
    "K1J9X3V2p5L8Fw0m",
    "Q5X0t6L7V9B3m2Y1",
    "D8F5V9L3p0X1k7T2",
    "L9V0J2m8Q1F5X6B7",
    "F4Y0V5m7B9L2X3kT",
    "J6tX2V5Y0B8K7n9L"
}

-- 📌 Переменная для ввода ключа
local script_key = "B0mF2R6V1x7Qn8Ls"  -- Здесь будет ключ, введённый игроком в консоли

-- 📌 Функция для проверки ключа
local function checkKey(inputKey)
    -- Проверяем, существует ли ключ в списке валидных ключей
    for _, key in ipairs(validKeys) do
        if inputKey == key then
            return true  -- Ключ правильный
        end
    end
    return false  -- Ключ неправильный
end

-- 📌 Функция для запуска скрипта
local function runScript()
    -- Здесь идет основной код скрипта, который будет выполняться после правильного ключа
    print("Ключ принят! Скрипт продолжает выполнение.")
end

-- 📌 Проверка ключа и выполнение действия
if checkKey(script_key) then
    runScript()
else
    print("Неверный ключ! Отключение скрипта.")
    game.Players.LocalPlayer:Kick("Неверный ключ! Выключение скрипта.")  -- Кикаем игрока с ошибкой
    return
end

-- 📌 Получаем основные сервисы Roblox
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- 📌 Получаем сетевое хранилище с таймаутом
local Network = ReplicatedStorage:WaitForChild("Network", 10)
if not Network then
    return warn("❌ Network не найден! Скрипт не запущен.") 
end

-- 📌 Функция для асинхронного выполнения
local function runAsync(func)
    task.spawn(func)
end

-- 📌 Функции для сетевых событий
local function invokeRemoteEvent(remoteName, args)
    local remoteEvent = Network:FindFirstChild(remoteName)
    if not remoteEvent then return warn("❌ Не найден RemoteEvent '" .. remoteName .. "'") end
    local success, result = pcall(function()
        return remoteEvent:InvokeServer(unpack(args))
    end)
    return success, result
end

-- 📌 Авто-покупка товаров из vending machine
local function autoPurchaseVendingMachine()
    while task.wait() do
        local args = { [1] = "PotionVendingMachine" }
        local success, result = invokeRemoteEvent("VendingMachines_Purchase", args)
        if not success then
            warn("❌ Ошибка при покупке из vending machine:", result)
        end
    end
end

-- 📌 Авто-ролл яиц (спамим 10 роллов за тик)
local function autoRollEggs()
    while task.wait() do
        for i = 1, 10 do
            invokeRemoteEvent("Eggs_Roll", {})
        end
    end
end

-- 📌 Авто-высиживание яиц
local function autoHatchEggs()
    while task.wait(0.1) do
        invokeRemoteEvent("Tycoons: Hatch", {})
    end
end

-- 📌 Авто-сбор яиц
local function autoCollectEggs()
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
end

-- 📌 Список ID фруктов и их значений для активации апгрейда
local fruitUpgradeValues = {
    ["81056d1e79ae444f91530ff0769da1c7"] = 25,
    ["ad24b8d3629d43e8b7042d0e617d6627"] = 25,
    ["2b44f53844484311b16a48be956e8cf5"] = 25,
    ["8e37346203ab46b192aa1956ee72c0be"] = 25,
    ["8e2a9935f66e4fa58b30dd58f2ec897e"] = 25,
    ["ea4c2220b51e4b87892d33da12df9ffe"] = 25,
    ["0e0e52fda5344330a0c5244d3f11b89d"] = 25,
    ["00b223c98c914eef8fd2b0b5ddfb3301"] = 25,
    ["5d6d82b5d6224fb1a9c419a96ec7e785"] = 25,
    ["11ba838264664919951968639ba4bb0f"] = 25,
    ["f15d965528a24b79a7d3e4dc274f8af5"] = 25
}

-- Функция для активации апгрейда фруктов
local function upgradeFruits()
    for fruitID, value in pairs(fruitUpgradeValues) do
        -- Аргументы для активации апгрейда
        local args = {
            [1] = { [fruitID] = value },  -- ID фрукта и его значение
            [2] = true,                   -- Второй аргумент (по умолчанию true)
        }

        -- Отправляем запрос на сервер для активации апгрейда
        game:GetService("ReplicatedStorage").Network["UpgradeFruitsMachine_Activate"]:InvokeServer(unpack(args))

        -- Пауза перед следующим апгрейдом
        wait(1)  -- Пауза 1 секунда
    end
end

-- Запускаем цикл для активации апгрейдов фруктов
while true do
    upgradeFruits()  -- Активируем апгрейд фруктов
    wait(5)          -- Ждем 5 секунд перед следующим циклом
end

-- Список ID фруктов
local fruits = {
    "1625a83c4ea74364b73b2298a2cb95fa", 
    "868ab27f1b6e4f62b5cc88bb500e20cd",
    "705d3c4ca9a84296bd57ac592bbc797e", 
    "a52de87711334ef19af29bb145264cc7",
    "a5cc2c890e2a43e3973d7242322de52b", 
    "f7e96e538890449e95bda98a569b47e2",
    "ea4c2220b51e4b87892d33da12df9ffe",
    "0e0e52fda5344330a0c5244d3f11b89d",
    "00b223c98c914eef8fd2b0b5ddfb3301",
    "5d6d82b5d6224fb1a9c419a96ec7e785",
    "11ba838264664919951968639ba4bb0f",
    "f15d965528a24b79a7d3e4dc274f8af5"
}

-- Функция для использования фруктов
local function useFruits()
    for _, fruitID in ipairs(fruits) do
        -- Аргументы для использования фрукта
        local args = {
            [1] = fruitID,  -- ID фрукта
            [2] = 1,        -- Количество (по-умолчанию 1)
        }

        -- Вызываем сервер для использования фрукта
        game:GetService("ReplicatedStorage").Network["Fruits: Consume"]:InvokeServer(unpack(args))

        -- Пауза между использованием фруктов
        wait(0.01)  -- Пауза 1 секунда
    end
end

-- Запускаем цикл для использования фруктов
while true do
    useFruits()  -- Используем все фрукты
    wait(1)      -- Ждем 5 секунд перед повтором
end

-- 📌 **Авто-покупка товаров**
local merchants = { "StandardMerchant", "MiningMerchant", "FishingMerchant", "IceFishingMerchant", "FactoryMerchant" }
local soldOutItems = {}

-- Функция для проверки, продан ли товар
local function isItemSoldOut(merchant, slot)
    return soldOutItems[merchant] and soldOutItems[merchant][slot] or false
end

-- Функция для покупки товаров у торговцев
local function purchaseFromMerchants()
    while true do
        local allSoldOut = true
        for _, merchantName in ipairs(merchants) do
            for slot = 1, 8 do
                -- Пропускаем уже проданные товары
                if isItemSoldOut(merchantName, slot) then
                    -- Используем break для пропуска и перехода к следующему слоту
                    break
                end

                -- Пытаемся купить товар
                local args = { [1] = merchantName, [2] = slot }
                local success, result = pcall(function()
                    -- Используем InvokeServer для покупки товара у мерчанта
                    return game:GetService("ReplicatedStorage").Network["CustomMerchants_Purchase"]:InvokeServer(unpack(args))
                end)

                if success then
                    allSoldOut = false
                else
                    warn("❌ Ошибка при покупке у " .. merchantName .. " слот " .. slot .. ": " .. result)
                    soldOutItems[merchantName] = soldOutItems[merchantName] or {}
                    soldOutItems[merchantName][slot] = true
                end

                -- Ожидаем немного перед следующей попыткой
                task.wait(0.3)
            end
        end

        -- Если все товары проданы, ждем 10 секунд и очищаем soldOutItems
        if allSoldOut then
            task.wait(10)
            soldOutItems = {} -- Очищаем soldOutItems только после того, как все товары закончились
        end
    end
end

-- Запускаем функцию покупок асинхронно
spawn(purchaseFromMerchants)
