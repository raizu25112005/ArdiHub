-- Custom UI Theme
local theme = {
    BackgroundColor = Color3.fromRGB(15, 15, 15),    -- Dark background
    MainColor = Color3.fromRGB(180, 25, 25),         -- Deep red
    AccentColor = Color3.fromRGB(225, 30, 30),       -- Bright red
    TextColor = Color3.fromRGB(255, 255, 255),       -- Pure white
    InactiveColor = Color3.fromRGB(80, 80, 80),      -- Gray for inactive elements
    NotificationBackground = Color3.fromRGB(20, 20, 20) -- Slightly lighter black
}

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Window Configuration
local Window = Rayfield:CreateWindow({
   Name = "Ardi Hub - Blox Fruits",
   LoadingTitle = "Ardi Hub Premium",
   LoadingSubtitle = "by raizu25112005",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ArdiHubConfig",
      FileName = "BloxFruits"
   },
   KeySystem = false,
   Discord = {
      Enabled = false,
      Invite = "coming soon",
      RememberJoins = true
   },
   Colors = {
      Main = theme.MainColor,
      Background = theme.BackgroundColor,
      Secondary = theme.AccentColor,
      TextColor = theme.TextColor
   },
   AnimationDuration = 0.5, -- Smooth animations
   DefaultDropdownAnimation = true,
   SmootherToggleAnimation = true
})

-- Main Tab
local MainTab = Window:CreateTab("Main Farm", 4483362458) -- ID icon untuk farming

-- Main Farming Section
local FarmingSection = MainTab:CreateSection("Auto Farm")

local AutoFarmToggle = MainTab:CreateToggle({
   Name = "Auto Farm Level",
   CurrentValue = false,
   Flag = "AutoFarmLevel",
   Callback = function(Value)
      getgenv().AutoFarm = Value
      if Value then
         AutoFarmLevel()
      end
   end,
})

-- Boss Tab
local BossTab = Window:CreateTab("Boss", 7251993295) -- ID icon untuk boss

-- Boss Section
local BossSection = BossTab:CreateSection("Auto Boss")

local AutoBossToggle = BossTab:CreateToggle({
   Name = "Auto Boss",
   CurrentValue = false,
   Flag = "AutoBoss",
   Callback = function(Value)
      getgenv().AutoBoss = Value
      if Value then
         AutoBoss()
      end
   end,
})

local BossDropdown = BossTab:CreateDropdown({
   Name = "Select Boss",
   Options = {"Cursed Captain", "Sea Beast", "Cake Prince", "Elite Hunter", "Sweet Cookie"},
   CurrentOption = "Cursed Captain",
   Flag = "SelectedBoss",
   Callback = function(Option)
      getgenv().SelectedBoss = Option
   end,
})

-- Submerge Quest Tab
local QuestTab = Window:CreateTab("Quest", 6022668888) -- ID icon untuk quest

local SubmergeSection = QuestTab:CreateSection("Submerge Island")

local AutoSubmergeToggle = QuestTab:CreateToggle({
   Name = "Auto Submerge Quest",
   CurrentValue = false,
   Flag = "AutoSubmerge",
   Callback = function(Value)
      getgenv().SubmergeQuest = Value
      if Value then
         AutoSubmergeQuest()
      end
   end,
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", 5107152076) -- ID icon untuk settings

local MiscSection = SettingsTab:CreateSection("Misc Settings")

local FastAttackToggle = SettingsTab:CreateToggle({
   Name = "Fast Attack",
   CurrentValue = false,
   Flag = "FastAttack",
   Callback = function(Value)
      getgenv().FastAttack = Value
   end,
})

local AutoHakiToggle = SettingsTab:CreateToggle({
   Name = "Auto Haki",
   CurrentValue = true,
   Flag = "AutoHaki",
   Callback = function(Value)
      getgenv().AutoHaki = Value
   end,
})

-- Protection Section
local ProtectionSection = SettingsTab:CreateSection("Protection")

local AntiAFKToggle = SettingsTab:CreateToggle({
   Name = "Anti AFK",
   CurrentValue = true,
   Flag = "AntiAFK",
   Callback = function(Value)
      getgenv().AntiAFK = Value
      if Value then
         local vu = game:GetService("VirtualUser")
         game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
         end)
      end
   end,
})

-- Stats Tab
local StatsTab = Window:CreateTab("Stats", 4483345998) -- ID icon untuk stats

local AutoStatsSection = StatsTab:CreateSection("Auto Stats")

local StatDropdown = StatsTab:CreateDropdown({
   Name = "Select Stat",
   Options = {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"},
   CurrentOption = "Melee",
   Flag = "SelectedStat",
   Callback = function(Option)
      getgenv().SelectedStat = Option
   end,
})

local AutoStatToggle = StatsTab:CreateToggle({
   Name = "Auto Stats",
   CurrentValue = false,
   Flag = "AutoStats",
   Callback = function(Value)
      getgenv().AutoStats = Value
      if Value then
         AutoUpgradeStats()
      end
   end,
})

-- Credits Tab
local CreditsTab = Window:CreateTab("Credits", 4483364237) -- ID icon untuk credits

local CreditsSection = CreditsTab:CreateSection("Credits")

local CreditsLabel = CreditsTab:CreateLabel("Created by: raizu25112005")
local DiscordLabel = CreditsTab:CreateLabel("Discord: Coming Soon")
local VersionLabel = CreditsTab:CreateLabel("Version: 1.0.0")

local DiscordButton = CreditsTab:CreateButton({
   Name = "Join Discord",
   Callback = function()
      -- Add your Discord invite link here
      setclipboard("Discord link coming soon")
      Rayfield:Notify({
         Title = "Discord",
         Content = "Discord link copied to clipboard!",
         Duration = 3,
      })
   end,
})

-- Custom Loading Screen
local LoadingScreen = Instance.new("ScreenGui")
local Background = Instance.new("Frame")
local Logo = Instance.new("ImageLabel")
local LoadingBar = Instance.new("Frame")
local LoadingText = Instance.new("TextLabel")

-- Setup loading screen
LoadingScreen.Name = "ArdiHubLoading"
LoadingScreen.Parent = game.CoreGui
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = theme.BackgroundColor
Background.Parent = LoadingScreen

Logo.Size = UDim2.new(0, 200, 0, 200)
Logo.Position = UDim2.new(0.5, -100, 0.4, -100)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://4483362458" -- Replace with your logo
Logo.Parent = Background

LoadingBar.Size = UDim2.new(0, 0, 0, 3)
LoadingBar.Position = UDim2.new(0.3, 0, 0.6, 0)
LoadingBar.BackgroundColor3 = theme.MainColor
LoadingBar.Parent = Background

LoadingText.Text = "Loading Ardi Hub..."
LoadingText.Position = UDim2.new(0.5, -100, 0.65, 0)
LoadingText.Size = UDim2.new(0, 200, 0, 30)
LoadingText.TextColor3 = theme.TextColor
LoadingText.Parent = Background

-- Animate loading bar
spawn(function()
    local TweenService = game:GetService("TweenService")
    TweenService:Create(LoadingBar, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0.4, 0, 0, 3)
    }):Play()
    wait(2)
    LoadingScreen:Destroy()
end)

-- Notification on Load with new theme
Rayfield:Notify({
   Title = "Ardi Hub Premium",
   Content = "Welcome to Ardi Hub Premium! Enjoy your premium features.",
   Duration = 6.5,
   Image = 4483362458,
   Actions = {
      Ignore = {
         Name = "⚡ Let's Start!",
         Callback = function()
            print("User acknowledged notification")
         end
      },
   },
   Colors = {
      Background = theme.NotificationBackground,
      Main = theme.MainColor,
      Text = theme.TextColor
   },
   AnimationSpeed = 0.5
})