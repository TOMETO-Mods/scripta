-- [[ term married Alya - Universal Mobile Script ]]
-- تم التحديث ليتوافق مع اسم المستودع الجديد: scripta

local OrionLib
local successUI, errUI = pcall(function()
    return loadstring(game:HttpGet("https://githubusercontent.com"))()
end)

if successUI and OrionLib then
    OrionLib = successUI
else
    OrionLib = loadstring(game:HttpGet("https://githubusercontent.com"))()
end

local Window = OrionLib:MakeWindow({
    Name = "term married Alya", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "AlyaHubConfig",
    IntroEnabled = true,
    IntroText = "Welcome to term married Alya Hub",
    IntroIcon = "rbxassetid://4483345998"
})

_G.AlyaConfig = {
    AutoFarm = false,
    AutoAttack = true,
    AutoChest = false,
    ESPPlayer = false,
    ESPChest = false,
    DevilFruitESP = false,
    isFarmActive = false,
    isChestActive = false
}

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local activeThread = nil
local chestThread = nil

local function getWorkspaceRef()
    local ok, res = pcall(function()
        return cloneref and cloneref(Workspace) or Workspace
    end)
    return ok and res or Workspace
end
local WorkspaceRef = getWorkspaceRef()

local function isTargetReady(target)
    if not target or not target.Parent or not target:IsDescendantOf(WorkspaceRef) then
        return false
    end
    local humanoid = target:FindFirstChildOfClass("Humanoid")
    local rootPart = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
    if humanoid and humanoid.Health > 0 and rootPart then
        return true
    end
    return false
end

local function startFarmLoop()
    if _G.AlyaConfig.isFarmActive then return end
    _G.AlyaConfig.isFarmActive = true
    
    activeThread = task.spawn(function()
        while _G.AlyaConfig and _G.AlyaConfig.AutoFarm do
            task.wait(0.02)
            pcall(function()
                local enemies = WorkspaceRef:FindFirstChild("Enemies")
                if enemies then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        if isTargetReady(enemy) then
                            local character = LocalPlayer.Character
                            if character and character:FindFirstChildOfClass("Humanoid") and character.Humanoid.Health > 0 then
                                local myRoot = character:FindFirstChild("HumanoidRootPart")
                                local enemyRoot = enemy:FindFirstChild("HumanoidRootPart") or enemy.PrimaryPart
                                
                                if myRoot and enemyRoot and enemyRoot:IsA("BasePart") then
                                    myRoot.CFrame = enemyRoot.CFrame * CFrame.new(0, 11, 0)
                                    
                                    if _G.AlyaConfig.AutoAttack then
                                        local tool = character:FindFirstChildOfClass("Tool")
                                        if tool then
                                            tool:Activate()
                                            local remote = tool:FindFirstChild("LeftClickRemote") or tool:FindFirstChildOfClass("RemoteEvent")
                                            if remote and remote:IsA("RemoteEvent") then
                                                remote:FireServer()
                                            end
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
        _G.AlyaConfig.isFarmActive = false
        activeThread = nil
    end)
end

local function startChestLoop()
    if _G.AlyaConfig.isChestActive then return end
    _G.AlyaConfig.isChestActive = true

    chestThread = task.spawn(function()
        while _G.AlyaConfig and _G.AlyaConfig.AutoChest do
            task.wait(0.05)
            pcall(function()
                local chestModels = WorkspaceRef:FindFirstChild("ChestModels") or WorkspaceRef
                for _, chest in ipairs(chestModels:GetChildren()) do
                    if chest.Name:lower():find("chest") and chest:FindFirstChild("RootPart") then
                        local character = LocalPlayer.Character
                        if character and character:FindFirstChildOfClass("Humanoid") and character.Humanoid.Health > 0 then
                            local myRoot = character:FindFirstChild("HumanoidRootPart")
                            if myRoot then
                                myRoot.CFrame = chest.RootPart.CFrame * CFrame.new(0, 3, 0)
                                task.wait(0.15)
                                break
                            end
                        end
                    end
                end
            end)
        end
        _G.AlyaConfig.isChestActive = false
        chestThread = nil
    end)
end

local Tab1 = Window:MakeTab({ Name = "Main Grinding", Icon = "rbxassetid://4483345998" })
local Tab2 = Window:MakeTab({ Name = "Sub Farm", Icon = "rbxassetid://4483346048" })
local Tab3 = Window:MakeTab({ Name = "Visuals (ESP)", Icon = "rbxassetid://4483346175" })
local Tab4 = Window:MakeTab({ Name = "Misc Menu", Icon = "rbxassetid://4483346256" })

local GrindingSec = Tab1:AddSection({ Name = "Level Farming" })
GrindingSec:AddToggle({
    Name = "Auto Farm Level ( تلفيل تلقائي )",
    Default = false,
    Callback = function(Value)
        if _G.AlyaConfig then
            _G.AlyaConfig.AutoFarm = Value
            if Value then startFarmLoop() end
        end
    end    
})

GrindingSec:AddToggle({
    Name = "Fast Attack ( الضرب التلقائي )",
    Default = true,
    Callback = function(Value)
        if _G.AlyaConfig then _G.AlyaConfig.AutoAttack = Value end
    end    
})

local ChestSec = Tab2:AddSection({ Name = "Chest Grinding" })
ChestSec:AddToggle({
    Name = "Auto Farm Chests ( جمع الصناديق )",
    Default = false,
    Callback = function(Value)
        if _G.AlyaConfig then
            _G.AlyaConfig.AutoChest = Value
            if Value then startChestLoop() end
        end
    end    
})

local ESPSec = Tab3:AddSection({ Name = "Render Settings" })
ESPSec:AddToggle({ Name = "Player ESP", Default = false, Callback = function(v) if _G.AlyaConfig then _G.AlyaConfig.ESPPlayer = v end end })
ESPSec:AddToggle({ Name = "Chest ESP", Default = false, Callback = function(v) if _G.AlyaConfig then _G.AlyaConfig.ESPChest = v end end })
ESPSec:AddToggle({ Name = "Devil Fruit ESP", Default = false, Callback = function(v) if _G.AlyaConfig then _G.AlyaConfig.DevilFruitESP = v end end })

local MiscSec = Tab4:AddSection({ Name = "System" })
MiscSec:AddButton({ Name = "Destroy UI ( إغلاق السكربت )", Callback = function() OrionLib:Destroy() end })

OrionLib:Init()
print("[term married Alya] Mobile Script Synced with 'scripta' Repository!")
