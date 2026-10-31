-- Unix v2 | 164 blocks, 8 protection, 1 UI library removed (protection hidden)

-- [1 protection block(s) removed, see AntiTamper]
local a = getgenv()

if game.PlaceId ~= 16116270224 and game.PlaceId ~= 16552821455 then
  return
end

a.GograAutofarmSuspended = false
local b = os.clock() + 2

while a.GograCrashStopGuard and os.clock() < b do
  task.wait(0.05)
end

if a.GograCrashStopGuard then
  warn("[Gogra Autofarm] Restart Roblox to clear the previous stop guard")
  return
end

if a.GograAutofarm and a.GograAutofarm.version == "4.8.57" and not a.GograAutofarm.destroyed then
  return
end

a.GograAutofarmStartPaused = not (a.GograAutofarm and a.GograAutofarm.enabled == true)
-- [4 protection block(s) removed, see AntiTamper]
local e = getgenv()

if e.GograAutofarmSuspended then
  warn("[Gogra Autofarm] Suspended after crash investigation; farming remains disabled")
  return
end

if game.PlaceId ~= 16116270224 and game.PlaceId ~= 16552821455 then
  return
end

-- [1 protection block(s) removed, see AntiTamper]

if e.GograAutofarm and e.GograAutofarm.version == "4.8.57" and e.GograAutofarm.SetEnabled and not e.GograAutofarm.destroyed then
  return
end

warn("WARNING: Doesn't Work On Solara , Xeno!")
local f = game:GetService("Players")
local g = game:GetService("ReplicatedStorage")
local h = game:GetService("RunService")
local i = game:GetService("UserInputService")
local j = game:GetService("ContextActionService")

if not game:IsLoaded() then
  game.Loaded:Wait()
end

while not f.LocalPlayer do
  task.wait(0.1)
end

if e.GograAutofarm and e.GograAutofarm.version == "4.8.57" and not e.GograAutofarm.destroyed then
  return
end

local k = f.LocalPlayer
local l = {}

for m, n in ipairs({"UserInputService", "TweenService", "Players", "CoreGui", "HttpService", "RunService",
    "GuiService"}) do
  l[n] = game:GetService(n)
end

local aa = (function()
  return function(m)
    local n = game:GetService("Workspace")
    local o = game:GetService("TweenService")
    local p = game:GetService("RunService")
    local q = {}
    q.stats = {lastBlock = nil, lastReason = nil, segments = 0, corrections = 0, teleportAttempts = 0,
      teleports = 0}
    function q.encounterBlockedReason(r)
      if not r then
        return nil
      end
      if r.Name == "RodgerMonster" then
        local s = r.PrimaryPart or r:FindFirstChild("HumanoidRootPart") or r:FindFirstChild("RootPart") or r:FindFirstChildWhichIsA("BasePart", true)
        if not s then
          return "rodger-not-ready"
        end
        local t = r:FindFirstChild("ChasingValue")
        local u = t and t.Value ~= nil
        for v, w in ipairs({"Attacking", "Chasing", "BeamActive"}) do
          local x = r:FindFirstChild(w)
          if r:GetAttribute(w) == true or x and x.Value == true then
            u = true
          end
        end
        if s.Anchored and not u then
          return "rodger-dormant-capsule"
        end
        return nil
      end
      if r.Name ~= "ConnieMonster" then
        return nil
      end
      local s = m.room()
      if not s then
        return nil
      end
      for t, u in ipairs(s:GetDescendants()) do
        if u.Name == "Stats" then
          local v = u:FindFirstChild("Connie")
          if v and v:IsA("BoolValue") and v.Value == true then
            return "connie-merged-with-machine"
          end
        end
      end
      return nil
    end
    local r = 30
    q.maxEscapeSpeed = 30
    q.stats.maxTweenSpeed = r
    function q.prepareTweenAnimations(s)
      if not m.animations or not q.movementOwned then
        return
      end
      local t = m.animations.acquire()
      q.animationLease = m.animations.active
      if s then
        m.animations.settle()
      end
      if t and q.geometry and q.geometry.invalidateBody then
        q.geometry.invalidateBody()
      end
      if t and q.invalidateStandingOffset then
        q.invalidateStandingOffset()
      end
    end
    function q.makeTween(s, t, u)
      q.stats.groundBlock = nil
      q.prepareTweenAnimations(true)
      if m.strictGround and m.groundTweenFactory then
        if not q.groundedTween then
          q.groundedTween = m.groundTweenFactory({clock = os.clock, minInterval = 0.016666666666666666,
            completed = function(v)
            return v.PlaybackState == Enum.PlaybackState.Completed
          end, throttled = function()
            q.stats.poseWritesSkipped = (q.stats.poseWritesSkipped or 0) + 1
          end, current = function(v)
            return v.CFrame
          end, value = function(v)
            local w = Instance.new("CFrameValue")
            w.Value = v
            return w
          end, tween = function(v, w, x)
            return o:Create(v, w, x)
          end, apply = function(v, w)
            local x, y, z = m.character()
            if z ~= v or not m.alive() then
              return false, "character-changed"
            end
            if q.exitWriteGuard then
              local A, B = q.exitWriteGuard(v, w)
              if not A then
                return false, B
              end
            end
            if m.releaseReady and not m.releaseReady() then
              return false, "machine-release-pending"
            end
            if m.ensureNoclip and (m.options.noclip or q.stats.collisionSuppression or m.cover and (m.cover.active or m.cover.pending)) then
              local A, B = m.ensureNoclip()
              if not A then
                return false, B or "noclip-not-ready"
              end
            end
            local A, B
            if q.directHeightTravel then
              A = q.uprightGroundPose(v, w)
            else
              A, B = q.projectGroundPose(v, w)
            end
            if not A then
              return false, B
            end
            v.CFrame = A
            v.AssemblyLinearVelocity = Vector3.zero
            q.stats.poseWrites = (q.stats.poseWrites or 0) + 1
            return true
          end, displaced = function(v, w, y)
            local z = y.Position - w.Position
            if z.Magnitude > 2.5 then
              q.stats.lastTweenDisplacement = {expected = tostring(w.Position), actual = tostring(y.Position),
                distance = z.Magnitude}
              return true, "server-correction"
            end
            return false
          end, blocked = function(v)
            q.stats.groundBlock = v
          end})
        end
        return q.groundedTween(s, t, u)
      end
      return o:Create(s, t, u)
    end
    q.stats.extremeStrictTeleport = true
    q.stats.sproutOnlyEscape = true
    local s = math.clamp(tonumber(m.options.hideSearchDistance) or 30, 30, 80)
    q.stats.hideSearchDistance = s
    local t, u
    local function v()
      if t and t.Parent then
        t.Anchored = false
      end
      t, u = nil, nil
      q.stats.coverPinned = false
    end
    local w = m.cover or {}
    if w.geometry and w.geometryController and (w.geometry.grounded and w.geometryController.version == "ground-yaw-8" or not m.coverGeometry) then
      q.geometry = w.geometryController
      q.geometryByPart = {[w.part] = w.geometry}
    end
    local y = w.active == true
    local z, A, B, C = false, nil, nil, nil
    local D = nil
    local E = nil
    function q.ownsHeight()
      if q.directHeightTravel then
        return true
      end
      if m.strictGround then
        return q.groundOwned == true
      end
      return D ~= nil and D.PlaybackState == Enum.PlaybackState.Playing or m.options.fullBodyHiding and (w.active or w.pending)
    end
    local F, G = nil, nil
    q.escapeSpeedCap = q.maxEscapeSpeed
    local H
    local I = false
    local J, K, L = nil, -math.huge, {}
    local M
    local N, O, P, Q = nil, nil, -math.huge, 0
    local R = setmetatable({}, {__mode = "k"})
    local S, T = nil, nil
    local U, V = nil, 0
    q.watch = {rejectedWalls = setmetatable({}, {__mode = "k"}), rescueAt = 0, watchAt = 0}
    local W, X, Y = 0, false, false
    local Z, _, aa = nil, false, nil
    local ab = false
    local ac = false
    local ad = nil
    local ae = false
    local af = nil
    local ag
    local ah
    local ai
    local aj, ak, al = nil, {}, 0
    q.stats.coverEvents = {}
    local function am(an, ao)
      local ap, aq, ar = m.character()
      local as = q.stats.coverEvents
      table.insert(as, {at = os.clock(), action = an, reason = ao, health = aq and aq.Health, position = ar and tostring(ar.Position),
        kind = w.kind, part = w.part and w.part:GetFullName()})
      if #as > 32 then
        table.remove(as, 1)
      end
    end
    local an, ao = nil, nil
    local ap = math.clamp(tonumber(m.options.machineCoverDistance) or 40, 40, 100)
    q.stats.machineReturnDistance = ap
    local aq = m.teleportPolicy or {}
    local function ar(as)
      if as == "pickup" then
        return false
      end
      if as == "elevator" and m.machinesFinished and m.machinesFinished() then
        return true
      end
      if m.options.tweenOnly and not (as == "elevator" and m.machinesFinished and m.machinesFinished()) then
        return false
      end
      if as == "wall-center" then
        return true
      end
      if as == "elevator" and m.options.strictElevatorTeleport then
        return true
      end
      if m.options.teleportOnly and (as == "machine" or as == "research") then
        q.stats.teleportDisabled = false
        return true
      end
      local at = m.room()
      if aq.floor ~= at then
        aq.floor, aq.disabled, aq.failures = at, false, 0
        aq.elevatorDisabled = false
      end
      q.stats.teleportDisabled = aq.disabled == true and m.options.farmMode ~= "extreme"
      q.stats.elevatorTeleportDisabled = aq.elevatorDisabled == true
      if as == "elevator-exit" or as == "machine" and m.options.farmMode == "extreme" then
        return true
      end
      return as == "elevator" and not aq.elevatorDisabled or as ~= "elevator" and not aq.disabled
    end
    local as, at, au = nil, 0, nil
    local function av()
      return m.activity and m.activity() == "pickup" and as == nil
    end
    local function aw()
      return (m.options.machineHideMode == "detected" or m.options.machineHideMode == "retreat") and m.activity and (m.activity() == "machine" or m.activity() == "machine-travel") and as == nil
    end
    local function ax()
      return I or m.activity and m.activity() == "machine-travel"
    end
    local function ay()
      return av() and m.options.pickupChaseMode == "chase"
    end
    local function az()
      return m.options.machineHideMode == "retreat" and "retreat-machine" or m.options.machineHideMode == "detected" and "detected-machine" or nil
    end
    local aA = 15
    q.stats.detectedMachineStopDistance = aA
    local function aB()
      return av() or aw()
    end
    local aC = setmetatable({}, {__mode = "k"})
    local aD, aE, aF, aG = nil, {}, -math.huge, nil
    local aH, aI, aJ = nil, {}, -math.huge
    local aK, aL = Vector3.zero, Vector3.new(0, 1, 0)
    local function aM(aN)
      return math.max(0, tonumber(m.options.safetyMargin) or 0) + (aN.lethal and math.max(20, tonumber(m.options.lethalMargin) or 25) or 0)
    end
    local function aN(aO)
      local aP = aO
      local aQ = m.room()
      while aP and aP ~= aQ and aP ~= n do
        local aR = aP.Name:lower()
        if aR:find("stair", 1, true) or aR:find("step", 1, true) or aR:find("ramp", 1, true) or aR:find("ladder", 1, true) then
          return true
        end
        aP = aP.Parent
      end
      return false
    end
    local function aO(aP)
      local aQ = aP
      local aR = m.room()
      while aQ and aQ ~= aR and aQ ~= n do
        local aS = aQ.Name:lower():gsub("[^%a]", "")
        if aS == "generators" or aS:find("generator", 1, true) or aS:find("treadmil", 1, true) or aS:find("tredmil", 1, true) then
          return true
        end
        local aT = aQ:FindFirstChild("Stats")
        if aT and aT:FindFirstChild("Completed") and aT:FindFirstChild("CurrentAmount") then
          return true
        end
        aQ = aQ.Parent
      end
      return false
    end
    local function aP(aQ)
      local aR = aQ
      local aS = m.room()
      while aR and aR ~= aS and aR ~= n do
        local aT = aR.Name:lower()
        if aT:find("floor", 1, true) or aT:find("ground", 1, true) or aT:find("ceiling", 1, true) or aT:find("roof", 1, true) then
          return true
        end
        aR = aR.Parent
      end
      return false
    end
    local function aQ(aR)
      return aN(aR) or aO(aR) or aP(aR)
    end
    q.isCoverAllowed = function(aR)
      return aR ~= nil and not aQ(aR)
    end
    local function aR(aS)
      local aT = m.room()
      local aU = aT and aT:FindFirstChild("Generators")
      if not aU then
        return false
      end
      local aV = OverlapParams.new()
      aV.FilterType = Enum.RaycastFilterType.Include
      aV.FilterDescendantsInstances = {aU}
      aV.MaxParts = 1
      return #n:GetPartBoundsInBox(CFrame.new(aS), Vector3.new(2.5, 4, 2.5), aV) > 0
    end
    local function aS()
      return m.activity and (m.activity() == "machine" or m.activity() == "machine-travel") and 0.75 or 2
    end
    local function aT(aU, aV)
      if not m.hazards then
        return true
      end
      local aW, aX = m.hazards.segmentClear(aU, aV, aS())
      return aW, type(aX) == "table" and aX.reason or "ichor-puddle"
    end
    local function aU(aV)
      local aW = m.room()
      if not aW then
        return false
      end
      local aX = OverlapParams.new()
      aX.FilterType = Enum.RaycastFilterType.Include
      aX.FilterDescendantsInstances = {aW}
      aX.CollisionGroup = "Default"
      aX.MaxParts = 60
      for aY, aZ in ipairs(n:GetPartBoundsInBox(CFrame.new(aV + Vector3.new(0, 1, 0)), Vector3.new(3, 6, 3), aX)) do
        if aN(aZ) then
          return true
        end
      end
      return false
    end
    local function aV()
      return z or y or w.active == true or w.pending == true or (m.options and m.options.noclip == true)
    end
    local function aW(aX, aY)
      q.stats.lastReason = aX
      q.stats.lastBlock = aY and aY:GetFullName() or nil
      return false
    end
    local function aX(aY)
      return Vector3.new(aY.X, 0, aY.Z)
    end
    function q.correctedLegBlocked(aY, aZ)
      local a_ = q.watch.correctedLegs
      if not a_ or a_.floor ~= m.room() then
        return false
      end
      local a0 = aX(aZ - aY)
      local a1 = a0.Magnitude
      if a1 < 0.3 then
        return false
      end
      for a2, a3 in ipairs(a_) do
        if os.clock() >= a3.untilTime or math.abs(a3.center.Y - (aY.Y + aZ.Y) * 0.5) > 4 then
          continue
        end
        local a4 = math.clamp(aX(a3.center - aY):Dot(a0) / (a1 * a1), 0, 1)
        if aX(aY + a0 * a4 - a3.center).Magnitude < 2.5 and math.abs(a0.Unit:Dot(a3.direction)) > 0.65 then
          return true
        end
      end
      return false
    end
    function q.noteCorrectedLeg(aY, aZ, a_)
      local a0 = aX(aZ - aY)
      if a0.Magnitude < 0.3 then
        return
      end
      local a1 = q.watch.correctedLegs
      if not a1 or a1.floor ~= m.room() then
        a1 = {floor = m.room()}
        q.watch.correctedLegs = a1
      end
      a1[#a1 + 1] = {center = (aY + aZ) * 0.5, direction = a0.Unit, untilTime = os.clock() + 10}
      if #a1 > 12 then
        table.remove(a1, 1)
      end
      q.stats.correctedLegAvoidance = (q.stats.correctedLegAvoidance or 0) + 1
      q.stats.lastCorrectionDetail = {from = tostring(aY), expected = tostring(aZ), actual = tostring(a_)}
      if m.report then
        pcall(m.report, "position-correction", "Tween stopped after an unexpected position correction")
      end
    end
    local function aY(aZ, a_)
      return aX(aZ - a_).Magnitude
    end
    local function aZ(a_)
      return not Y and W == a_ and m.alive()
    end
    function q.coverSearchBudget(a_)
      local a0 = m.room()
      local a1 = m.character()
      local a2, a3, a4, a5 = os.clock(), os.clock(), 0, 0
      local a6 = false
      return function()
        if a6 then
          return false
        end
        if Y or not m.alive() or m.room() ~= a0 or m.character() ~= a1 or a_ ~= nil and not aZ(a_) then
          a6 = true
          return false
        end
        local a7 = os.clock()
        a5 += 1
        if a7 - a2 > 0.14 or a4 + a7 - a3 > 0.018 or a5 > 1600 then
          a6 = true
          q.stats.coverSearchLimited = (q.stats.coverSearchLimited or 0) + 1
          return false
        end
        if a7 - a3 >= 0.002 or a5 % 128 == 0 then
          a4 += a7 - a3
          q.stats.coverSearchYields = (q.stats.coverSearchYields or 0) + 1
          p.Heartbeat:Wait()
          a3 = os.clock()
          if Y or not m.alive() or m.room() ~= a0 or m.character() ~= a1 or a_ ~= nil and not aZ(a_) then
            a6 = true
            return false
          end
        end
        return true
      end
    end
    local function a_(a0)
      return not a0 and m.healthDanger ~= nil and m.healthDanger() == true
    end
    local function a0()
      local a1, a2, a3 = m.character()
      local a4 = a1 and a1:FindFirstChild("Stats")
      local a5 = a4 and a4:FindFirstChild("Health")
      if a5 and tonumber(a5.Value) and a5.Value <= 0 then
        return nil
      end
      if a1 and a2 and a3 and a1.Parent and a3.Parent and a2.Health > 0 then
        return a1, a2, a3
      end
      return nil
    end
    local a1 = {}
    local function a2()
      if not m.machinePosition or m.options.farmMode == "distraction" or not m.activity or m.activity() ~= "machine" and m.activity() ~= "machine-travel" then
        return nil
      end
      local a3, a4 = m.machinePosition()
      local a5, a6, a7 = a0()
      if typeof(a3) ~= "Vector3" or not a7 then
        return nil
      end
      if a1.floor ~= m.room() or a1.object ~= a4 or not a1.position or aY(a1.position, a3) > 2 then
        a1 = {floor = m.room(), object = a4, position = a3, radius = math.max(40, aY(a7.Position, a3))}
      end
      q.stats.generatorRetreatRadius = a1.radius
      q.stats.generatorRetreatDistance = aY(a7.Position, a1.position)
      return a1.position, a1.radius
    end
    local function a3(a4, a6)
      local a7, a8 = a2()
      if a7 == nil or aY(a4, a7) <= a8 + 0.1 then
        return true
      end
      return a6 == true and not w.active and q.chaseThreat and q.chaseThreat() ~= nil and aY(a4, a7) <= a8 + 16.1
    end
    local function a4()
      if D then
        D:Cancel()
        D = nil
      end
      E = nil
      q.stats.motionMode = nil
      local a6, a7 = a0()
      if a7 then
        a7:Move(aK, false)
      end
      m.setSprint(false)
    end
    local function a6(a7, a8, a9)
      local ba = a7 and a7:FindFirstChild(a8)
      return ba and tonumber(ba.Value) or a9
    end
    local function a7(a8)
      local a9 = a8 and a8:FindFirstChild("Stats")
      for ba, bb in ipairs({"Sprinting", "HoldingSprint"}) do
        local bc = a9 and a9:FindFirstChild(bb)
        if bc and bc.Value == true then
          return true
        end
      end
      return false
    end
    local function a8(a9)
      return a9.PrimaryPart or a9:FindFirstChild("HumanoidRootPart") or a9:FindFirstChild("RootPart") or a9:FindFirstChildWhichIsA("BasePart", true)
    end
    local function a9(ba)
      local bb = m.character()
      local bc = m.room()
      local bd = {}
      if bb then
        table.insert(bd, bb)
      end
      local be = n:FindFirstChild("InGamePlayers")
      if be then
        table.insert(bd, be)
      end
      if bc then
        for bf, bg in ipairs(ba and {"Monsters", "Items", "HolidayPickups", "Generators"} or {"Monsters",
            "Items", "HolidayPickups"}) do
          local bh = bc:FindFirstChild(bg)
          if bh then
            table.insert(bd, bh)
          end
        end
      end
      local bf = RaycastParams.new()
      bf.FilterType = Enum.RaycastFilterType.Exclude
      bf.FilterDescendantsInstances = bd
      bf.IgnoreWater = true
      bf.RespectCanCollide = true
      local bg, bh, bi = a0()
      if bi then
        bf.CollisionGroup = bi.CollisionGroup
      end
      return bf
    end
    local function ba(bb, bc)
      local bd = bc - bb
      if bd.Magnitude < 0.1 then
        return true
      end
      local be = a9(false)
      local bf = m.room()
      local bh = bf and bf:FindFirstChild("Generators")
      if bh then
        local bi = be.FilterDescendantsInstances
        bi[#bi + 1] = bh
        be.FilterDescendantsInstances = bi
      end
      be.RespectCanCollide = false
      be.CollisionGroup = "Default"
      return n:Raycast(bb, bd, be) == nil
    end
    local function bb(bc)
      local bd = m.room()
      local be = os.clock()
      if not bc and bd == aD and be - aF < 0.04 then
        return aE
      end
      aF, aD, aE, aG = be, bd, {}, nil
      q.stats.threatScans = (q.stats.threatScans or 0) + 1
      q.stats.dormantGourdy = 0
      local bf, bh, bi = a0()
      local bj = m.character()
      local bk = bd and bd:FindFirstChild("Monsters")
      if not bk or not bi then
        return aE
      end
      for bl, bm in ipairs(bk:GetChildren()) do
        if bm:IsA("Model") then
          if bm.Name == "BlottMonster" or q.encounterBlockedReason(bm) then
            continue
          end
          local bn = a8(bm)
          if bn and bn:IsA("BasePart") then
            local bo = bm:FindFirstChild("ChasingValue")
            local bp = bm:FindFirstChild("Attacking")
            local bq = bm:FindFirstChild("BeamActive")
            local br = bm:FindFirstChild("Chasing")
            local bs = bm.Name:lower():find("gourdy", 1, true) ~= nil
            if bs then
              local bt = bm:FindFirstChild("GourdyState")
              local bu = bm:FindFirstChild("IsStationary")
              local bv = bm:GetAttribute("GourdyEmerging") == true or bm:GetAttribute("GourdyEmergenceComplete") == true or bm:GetAttribute("IsStationary") == false or bu and bu.Value == false or bt and (bt.Value == "Mobile" or bt.Value == "Rage") or bm:GetAttribute("Attacking") == true or bm:GetAttribute("Chasing") == true or bp and bp.Value == true or br and br.Value == true or bo and bo.Value ~= nil
              local bw = bm:GetAttribute("IsStationary") == true or bu and bu.Value == true or bt and bt.Value == "Stationary"
              if bw and not bv then
                q.stats.dormantGourdy += 1
                continue
              end
            end
            local bt = bm.Name == "RazzleDazzleMonster"
            local bu = bm:FindFirstChild("Awake")
            local bv = bt and (bm:GetAttribute("Attacking") == true or bm:GetAttribute("Awake") == true or bm:GetAttribute("Chasing") == true or bp and bp.Value == true or bu and bu.Value == true or bq and bq.Value == true or br and br.Value == true or bo and bo.Value ~= nil)
            local bw = bm.Name == "DandyMonster" or bm.Name == "DyleMonster"
            local bx = bm:FindFirstChild("Chaser") or bm:FindFirstChild("Script")
            local by = bn.Position
            local bz = bm:FindFirstChildWhichIsA("Humanoid")
            local bA = math.max(a6(bx, "RunSpeed", 24), bz and tonumber(bz.WalkSpeed) or 0)
            local bB = a6(bx, "KillRadius", (bt or bm.Name == "RodgerMonster") and a6(bx, "InstantRadius", 40) or bw and 8.5 or 6)
            local bC = bt and bB or nil
            if bt and not bv and not a7(bj) then
              bB = math.max(3, math.max(bn.Size.X, bn.Size.Z) * 0.5 + math.max(bi.Size.X, bi.Size.Z) * 0.5)
            end
            local bD = a6(bx, "InstantRadius", 30)
            local bE = a6(bx, "VisionRadius", 90)
            if bs then
              bB = math.max(bB, 4)
              bA = math.max(bA, 26)
              bE = math.max(bE, 100)
              bD = math.max(bD, 35)
            end
            local bF = aX(bn.AssemblyLinearVelocity)
            local bG = aC[bm]
            if bG and be - bG.time > 0.04 and be - bG.time < 0.75 then
              local bH = aX(by - bG.position) / (be - bG.time)
              if bH.Magnitude > bF.Magnitude then
                bF = bH
              end
            end
            if bF.Magnitude > bA * 1.3 then
              bF = bF.Unit * bA * 1.3
            end
            if not bG or be - bG.time >= 0.04 then
              aC[bm] = {position = by, time = be, velocity = bF}
            elseif bG.velocity and bG.velocity.Magnitude > bF.Magnitude then
              bF = bG.velocity
            end
            local bH = bm:FindFirstChild("ChasingValue")
            local bI = bm:FindFirstChild("Chasing")
            local bJ = bm:FindFirstChild("Grabbing", true)
            local bK = bm:FindFirstChild("Attacking", true)
            local bL = bH and bH.Value
            local bM = bL ~= nil and (bL == bj or bL:IsDescendantOf(bj))
            if bL and bL:IsA("Player") then
              bM = bL.Character == bj
            end
            table.insert(aE, {model = bm, position = by, velocity = bF, killRadius = bB, instantRadius = bD,
              visionRadius = bE, runSpeed = bA, ranged = bm.Name:lower():find("goob", 1, true) ~= nil or bm.Name:lower():find("scraps", 1, true) ~= nil,
              grabbing = (bJ and bJ.Value == true) or bm:GetAttribute("Grabbing") == true or bm:GetAttribute("Attacking") == true or bK and bK.Value == true,
              chasing = bm:GetAttribute("Chasing") == true or (bI and bI.Value == true) or false, chasingUs = bM,
              stationary = bt, ribbonActive = bv == true, ribbonRadius = bC, hearingRadius = bt and a6(bx, "HearingRadius", 125) or nil,
              lethal = bw, forward = aX(bn.CFrame.LookVector)})
          else
            aG = bm
          end
        end
      end
      return aE
    end
    local function bc(bd, be, bh)
      local bi = aX(be.velocity)
      local bj = aX(bd - be.position)
      local bk = bi:Dot(bi)
      local bl = bk > 0.01 and math.clamp(bj:Dot(bi) / bk, 0, bh) or 0
      local bm = be.position + bi * bl
      return math.min(bj.Magnitude, aY(bd, bm)), be.position + bi * bh
    end
    local function bd(be, bh, bi)
      local bj = bi or be.position
      if ba(bj + aL, bh + aL) then
        return false
      end
      if not be.ranged then
        return true
      end
      for bk, bl in ipairs({aK, Vector3.new(0.75, 0, 0), Vector3.new(-0.75, 0, 0), Vector3.new(0, 0, 0.75),
          Vector3.new(0, 0, -0.75)}) do
        if ba(bj, bh + bl) then
          return false
        end
      end
      return true
    end
    local function be(bh)
      local bi = math.max(bh.killRadius + 30, bh.instantRadius + 24)
      bi += aM(bh)
      if bh.ranged then
        bi = math.max(bi, bh.visionRadius + 25)
      end
      return bi
    end
    local function bh(bi)
      if bi.stationary then
        return bi.killRadius + 6
      end
      if m.detectionOnly and not bi.chasingUs and not bi.grabbing then
        return bi.killRadius + 2 + math.min(5, aM(bi))
      end
      local bj = math.max(bi.killRadius + 12, bi.instantRadius + 12, m.options.advancedIdleDistance or 40) + aM(bi)
      if bi.ranged then
        bj = math.max(bj, bi.visionRadius + 25)
      end
      return bj
    end
    local function bi(bj)
      return math.max(ap, bj.killRadius + 12) + aM(bj)
    end
    local function bj()
      local bk = m.character()
      local bl = bk and bk:FindFirstChild("Decoding")
      if ao ~= m.room() or bl and bl.Value ~= nil then
        an, ao = nil, nil
      end
      return an ~= nil
    end
    local function bk(bl)
      if bl.stationary then
        return bl.killRadius + 6
      end
      if m.detectionOnly and not bl.chasingUs and not bl.grabbing then
        return bl.killRadius + 1.5 + math.min(5, aM(bl))
      end
      return math.max(bl.ranged and bl.visionRadius + 25 or aw() and 15 or 30, not m.options.returnToGenerator and bj() and ap or 0, bl.killRadius + 12) + aM(bl)
    end
    local function bl(bm, bn)
      local bo = aX(bm - bn.position)
      return not ba(bn.position + aL, bm + aL) or bo.Magnitude > 0.1 and bn.forward.Magnitude > 0.1 and bn.forward.Unit:Dot(bo.Unit) <= 0
    end
    local function bm(bn, bo)
      local bp = aX(bn - bo.position)
      local bq = bp.Magnitude > 0.1 and bo.forward and bo.forward.Magnitude > 0.1 and bo.forward.Unit:Dot(bp.Unit) > 0.35
      local br = bp.Magnitude > 0.1 and bo.velocity.Magnitude > 1 and bo.velocity.Unit:Dot(bp.Unit) > 0.4
      local bs = (bq or br) and (m.options.advancedApproachDistance or 70) or (m.options.advancedIdleDistance or 40)
      if bo.ranged then
        bs = math.max(bs, bo.visionRadius + 15)
      end
      return math.max(bs, bo.killRadius + 12) + aM(bo)
    end
    local function bn(bo, bp, bq)
      if as ~= bp.model or not m.options.researchMode or os.clock() >= at or bp.chasingUs or bp.grabbing then
        return false
      end
      local br = bp.model.Name:gsub("Monster$", "")
      if m.options.selectedTwisteds and m.options.selectedTwisteds[br] ~= true then
        return false
      end
      return bc(bo, bp, math.min(bq or 0.6, 0.8)) > be(bp)
    end
    local function bo(bp)
      if bp.chasingUs then
        return true
      end
      if not m.detectedUs or bp.stationary then
        return false
      end
      local bq, br, bs = a0()
      if not bs then
        return false
      end
      local bt = aX(bs.Position - bp.position)
      local bu = bt.Magnitude > 0.1 and bt.Magnitude <= bp.visionRadius and bp.forward.Magnitude > 0.1 and bp.forward.Unit:Dot(bt.Unit) > 0.2 and ba(bp.position + aL, bs.Position + aL)
      if not m.detectionOnly and m.options.soloRun and bp.chasing and bu then
        return true
      end
      return m.detectedUs(bp.model, bq, bu)
    end
    local function bp(bq, br, bs, bt)
      local bu = aY(bq, br.position)
      local bv = bc(bq, br, math.clamp(bs or 0.6, 0, 1.5))
      if ag then
        local bw, bx = ag(br, bq, bs)
        if bw then
          return bw <= bx and 6 or 0, bw, false
        end
      end
      if m.options.reactiveHideOnly and not as then
        if math.abs(bq.Y - br.position.Y) > 16 then
          return 0, bu, false
        end
        local bw = math.max(tonumber(m.options.closeHideDistance) or 10, br.killRadius + 1)
        return (bu <= bw or br.chasingUs or bo(br)) and 6 or 0, bu, false
      end
      if math.abs(bq.Y - br.position.Y) > 16 then
        return 0, bv, false
      end
      if br.stationary then
        return bv <= br.killRadius + 6 and 6 or 0, bv, false
      end
      if br.ranged and br.grabbing and bu <= br.visionRadius + 25 + aM(br) and not bd(br, bq) then
        return 6, bv, true
      end
      if bt == "travel" then
        local bw = bk(br)
        if not bj() and m.options.detectionMode == "advanced" and not br.chasingUs and not ba(br.position + aL, bq + aL) then
          bw = br.killRadius + 8 + aM(br)
        end
        return bv <= bw and 4 or 0, bv, false
      end
      if bt == "detected-machine" then
        if bo(br) then
          return 6, bu, true
        end
        if bv <= math.max(aA, br.killRadius + 6 + aM(br)) and not bd(br, bq) then
          return 6, bv, true
        end
        return bu <= aA and 6 or 0, bu, false
      end
      if bt == "machine-return" then
        return (bo(br) or bv <= bi(br)) and 6 or 0, bv, false
      end
      if bt == "retreat-machine" then
        return (br.chasingUs or bu <= bi(br) or R[br.model] == m.room() and not bl(bq, br)) and 6 or 0, bv, false
      end
      if bt == "pickup" then
        return bv <= bh(br) and 4 or 0, bv, false
      end
      if m.options.detectionMode == "advanced" then
        local bw = bm(bq, br)
        local bx = bu <= bw + 12 and ba(br.position + aL, bq + aL)
        if bv <= br.killRadius + 6 + aM(br) then
          return 6, bv, bx
        end
        if (bx or br.chasingUs) and bv <= bw then
          return 4, bv, bx
        end
        return 0, bv, bx
      end
      local bw = bu <= br.visionRadius + 6 and ba(br.position + aL, bq + aL)
      local bx = 0
      if bv < br.killRadius + 4 then
        bx = 6
      elseif bv < br.killRadius + 8 then
        bx = 4
      elseif bw then
        bx = 2
      end
      local by = math.max(br.instantRadius + 24, br.killRadius + 30)
      by += aM(br)
      if br.ranged then
        by = math.max(by, br.visionRadius + 25)
      end
      if br.grabbing and bv < by + 20 then
        bx = math.max(bx, 6)
      end
      if (bw or br.chasingUs) and bv < by then
        bx = math.max(bx, 4)
      elseif br.chasingUs and bv < br.visionRadius + 20 then
        bx = math.max(bx, 3)
      end
      return bx, bv, bw
    end
    local function bq(br)
      local bs = m.hazards and (m.hazards.attackDangerAt or m.hazards.handDangerAt)
      local bt = bs and bs(br)
      if not bt then
        return nil
      end
      return {model = bt.object, position = bt.cf.Position, velocity = bt.velocity or aK, reason = bt.reason or "blott-hand",
        risk = 99, hazard = true, attack = bt, killRadius = math.max(bt.size.X, bt.size.Z) * 0.5 + 8,
        distance = aY(br, bt.cf.Position)}
    end
    function q.rollingPumpkinThreat()
      local br, bs, bt = a0()
      local bu = m.hazards and (m.hazards.pumpkinPursuitAt or m.hazards.pumpkinDangerAt)
      return bt and bu and bu(bt.Position) or nil
    end
    function q.immediateThreatAt(bs)
      local bt = bq(bs)
      if bt then
        return true, bt
      end
      for bu, bv in ipairs(bb()) do
        if math.abs(bs.Y - bv.position.Y) > 16 then
          continue
        end
        local bw = aY(bs, bv.position)
        local bx = bw <= math.max(tonumber(m.options.closeHideDistance) or 10, bv.killRadius + 1)
        local by = bv.chasingUs or bo(bv)
        if bx or by then
          local bz = table.clone(bv)
          bz.distance = bw
          bz.risk = 6
          bz.reason = by and (bv.chasingUs and "twisted-chasing" or "twisted-detected") or "twisted-too-close"
          return true, bz
        end
      end
      return false
    end
    function q.itemContactAt(bs)
      if bq(bs) then
        return true
      end
      for bt, bu in ipairs(bb()) do
        if math.abs(bs.Y - bu.position.Y) <= 16 and aY(bs, bu.position) <= math.max(tonumber(m.options.closeHideDistance) or 10, bu.killRadius + 1) then
          return true
        end
      end
      return false
    end
    local function bs(bt, bu)
      local bv = bq(bt)
      if bv then
        return bv
      end
      for bw, bx in ipairs(bb()) do
        local by = bu or (m.options.prioritizeSafety and 2 or 8)
        if bu == nil and m.options.fullBodyHiding and w.active and not w.leaving and w.geometry and q.geometry and bd(bx, bt) and q.geometry.contains(w.geometry, CFrame.new(bt) * w.cframe.Rotation) then
          by = bx.lethal and 4 or m.options.prioritizeSafety and 2 or 1.25
        end
        if math.abs(bt.Y - bx.position.Y) <= 16 and aY(bt, bx.position) <= bx.killRadius + by then
          local bz = table.clone(bx)
          bz.reason = "enemy-reaching-cover"
          bz.risk = 99
          return bz
        end
      end
      return nil
    end
    local function bt(bu, bv)
      local bw = bv - bu
      local bx = bw:Dot(bw)
      for by, bz in ipairs(bb()) do
        if math.abs(bu.Y - bz.position.Y) > 16 and math.abs(bv.Y - bz.position.Y) > 16 then
          continue
        end
        local bA = bx > 0.01 and math.clamp((bz.position - bu):Dot(bw) / bx, 0, 1) or 0
        if aY(bu + bw * bA, bz.position) <= bz.killRadius + 2 then
          if aY(bu, bz.position) > bz.killRadius + 2 or (bu - bz.position):Dot(bw) < 0 then
            return false
          end
        end
      end
      return true
    end
    function q.threatAt(bu, bv)
      if typeof(bu) ~= "Vector3" then
        return true, {risk = 99, reason = "invalid-position"}
      end
      local bw = bq(bu)
      if bw then
        return true, bw
      end
      local bx, by = nil, 0
      local bz = bb()
      if aG then
        return true, {model = aG, risk = 99, reason = "untracked-threat"}
      end
      for bA, bB in ipairs(bz) do
        if bn(bu, bB, 0.6) then
          continue
        end
        local bC = bv
        if not bC and (w.leaving or not w.active and not w.pending and not y) then
          bC = ax() and not as and "travel" or av() and "pickup" or aw() and az() or nil
        end
        local bD, bE, bF = bp(bu, bB, 0.6, bC)
        if bD > by or (bD == by and bD > 0 and bE < bx.distance) then
          by = bD
          bx = table.clone(bB)
          bx.distance, bx.risk, bx.lineOfSight = bE, bD, bF
        end
      end
      return by >= ((y or w.active) and not w.leaving and 6 or 4), bx
    end
    function q.nearestDanger()
      local bu, bv, bw = a0()
      if not bw then
        return nil, math.huge
      end
      local bx = bq(bw.Position)
      if bx then
        return bx, bx.distance
      end
      local by, bz = nil, math.huge
      local bA = bb()
      if aG then
        return {model = aG, position = bw.Position, risk = 99, reason = "untracked-threat"}, 0
      end
      for bB, bC in ipairs(bA) do
        local bD, bE, bF = bp(bw.Position, bC, 0.6)
        if bD >= ((y or w.active) and not w.leaving and 6 or 4) and bE < bz then
          by, bz = table.clone(bC), bE
          by.distance, by.risk, by.lineOfSight = bE, bD, bF
        end
      end
      return by, bz
    end
    function q.chaseThreat()
      local bv, bw, bx = a0()
      local by, bz = nil, math.huge
      for bA, bB in ipairs(bb()) do
        if bB.chasingUs and not bB.stationary then
          R[bB.model] = m.room()
          local bC = bx and aY(bx.Position, bB.position) or math.huge
          if not by or bC < bz then
            by = table.clone(bB)
            by.reason = "twisted-chasing"
            by.risk = 6
            bz = bC
          end
        end
      end
      return by
    end
    function q.detectedThreat()
      for bw, bx in ipairs(bb()) do
        if bo(bx) and not bx.stationary then
          R[bx.model] = m.room()
          local by = table.clone(bx)
          by.reason = "twisted-detected"
          by.risk = 6
          return by
        end
      end
      return nil
    end
    function q.nativePursuer()
      local bw = m.room()
      local bx = m.character()
      if q.watch.pursuitFloor ~= bw or q.watch.pursuitCharacter ~= bx then
        q.watch.pursuitFloor, q.watch.pursuitCharacter = bw, bx
        q.watch.pursuitAt = nil
      end
      local by = bw and bw:FindFirstChild("Monsters")
      local bz
      if not by or not bx then
        return nil
      end
      for bA, bB in ipairs(by:GetChildren()) do
        if bB:IsA("Model") then
          local bC = bB:FindFirstChild("ChasingValue", true)
          local bD = bC and bC:IsA("ObjectValue") and bC.Value
          local bE = bD and (bD == bx or bD:IsDescendantOf(bx) or bD:IsA("Player") and bD.Character == bx)
          local bF = bB:FindFirstChild("Chasing", true)
          local bG = bB:GetAttribute("Chasing") == true or bF and bF:IsA("BoolValue") and bF.Value == true
          if bE or not bD and m.options.soloRun and bG then
            R[bB] = bw
            q.watch.pursuitAt = os.clock()
            if not bz then
              bz = {model = bB, reason = "twisted-chasing", risk = 6}
            end
          end
        end
      end
      return bz
    end
    function q.exitWriteGuard(bw, bx)
      if not af and not w.leaving then
        return true
      end
      if m.machinesFinished and m.machinesFinished() then
        return true
      end
      local by = q.nativePursuer()
      if by then
        q.stats.blockedExitEnemy = by.model.Name
        q.stats.blockedChaseExits = (q.stats.blockedChaseExits or 0) + 1
        return false, "twisted-chasing"
      end
      if q.watch.pursuitAt and os.clock() - q.watch.pursuitAt < 0.85 then
        return false, "twisted-chasing"
      end
      if bw and bx and not q.travelLegClear(bw.Position, bx.Position, 0, true) then
        return false, "twisted-on-exit-corridor"
      end
      return true
    end
    function q.coverResumeClear(bw)
      local bx, by, bz = a0()
      if not bz then
        return false, "waiting-for-character"
      end
      if q.nativePursuer() then
        return false, "waiting-for-chase-to-clear"
      end
      if q.watch.pursuitAt and os.clock() - q.watch.pursuitAt < 0.85 then
        return false, "waiting-for-chase-clear-window"
      end
      local bA = math.clamp(tonumber(m.options.resumeDistance) or 55, 50, 60)
      local bB = math.huge
      local bC = m.options.farmMode == "faster"
      q.stats.resumePolicy = bC and "vision-and-route" or "distance-and-route"
      for bD, bE in ipairs(bb()) do
        if bE.stationary or math.abs(bE.position.Y - bz.Position.Y) > 16 then
          continue
        end
        if bE.chasingUs or bo(bE) then
          R[bE.model] = m.room()
          q.stats.resumeWaitDistance = aY(bz.Position, bE.position)
          q.stats.resumeRequiredDistance = bA
          return false, "waiting-for-chase-to-clear"
        end
        if R[bE.model] ~= m.room() then
          continue
        end
        local bF = bc(bz.Position, bE, 0.75)
        if typeof(bw) == "Vector3" then
          local bG = bc(bw, bE, 0.75)
          bF = math.min(bF, bG)
        end
        if bC and bF < bA then
          if not q.patrolLegClear(bE, bz.Position, bz.Position, 0, 0.75) or typeof(bw) ~= "Vector3" or not q.patrolLegClear(bE, bw, bw, 0, 0.75) then
            q.stats.resumeWaitDistance = bF
            q.stats.resumeRequiredDistance = bA
            return false, "waiting-for-vision-clearance"
          end
          continue
        end
        bB = math.min(bB, bF)
      end
      q.stats.resumeWaitDistance = bB
      q.stats.resumeRequiredDistance = bA
      if aG then
        return false, "waiting-for-twisted-position"
      end
      if bB < bA then
        return false, "waiting-for-twisted-distance"
      end
      return true
    end
    function q.sproutThreat()
      local bw, by, bz = a0()
      if not bz then
        return nil
      end
      local bA = m.hazards and m.hazards.sproutDangerAt and m.hazards.sproutDangerAt(bz.Position)
      if bA then
        return {model = bA.object, position = bA.cf.Position, velocity = aK, reason = "sprout-tendril",
          risk = 99, hazard = true, killRadius = math.max(bA.size.X, bA.size.Z) * 0.5 + 8, distance = aY(bz.Position, bA.cf.Position)}
      end
      local bB, bC = nil, math.huge
      for bD, bE in ipairs(bb()) do
        if bE.model.Name == "SproutMonster" and bo(bE) then
          local bF = aY(bz.Position, bE.position)
          if bF < bC then
            bB = table.clone(bE)
            bB.reason = "sprout-detected"
            bB.risk = 6
            bC = bF
          end
        end
      end
      return bB
    end
    function q.machineEmergencyThreat()
      local by, bz, bA = a0()
      local bB = by and by:FindFirstChild("Decoding")
      if not bA or not bB or not bB.Value or w.active and not w.leaving then
        return nil
      end
      for bC, bD in ipairs(bb()) do
        if bD.stationary or math.abs(bA.Position.Y - bD.position.Y) > 16 then
          continue
        end
        local bE = ba(bD.position + aL, bA.Position + aL) or ba(bD.position, bA.Position)
        if not bE and not bD.chasingUs then
          continue
        end
        local bF = bc(bA.Position, bD, 0.35)
        local bG = bD.killRadius + (bD.lethal and 5 or 3) + math.max(0, tonumber(m.options.safetyMargin) or 0)
        if bD.chasingUs or bo(bD) or not m.detectionOnly and bF <= bG then
          R[bD.model] = m.room()
          local bH = table.clone(bD)
          bH.reason = "twisted-machine-contact"
          bH.risk = 99
          return bH
        end
      end
      return nil
    end
    function q.imminentThreatAt(by)
      if m.options.prioritizeSafety ~= true then
        return nil
      end
      local bz, bA
      for bB, bC in ipairs(bb()) do
        if math.abs(bC.position.Y - by.Y) > 16 or bC.stationary and not bC.ribbonActive then
          continue
        end
        local bD = aX(by - bC.position)
        local bE = aX(bC.velocity)
        if bC.chasingUs and bE.Magnitude < 1 and bD.Magnitude > 0.1 then
          bE = bD.Unit * bC.runSpeed
        end
        local bF = bC.killRadius + (bC.lethal and 4 or 1.5)
        if bD.Magnitude > bF + bE.Magnitude * 0.85 then
          continue
        end
        local bG = bE:Dot(bE)
        local bH = bG > 0.01 and math.clamp(bD:Dot(bE) / bG, 0, 0.85) or 0
        local bI = (bD - bE * bH).Magnitude
        if bI <= bF and not bd(bC, by) and (not bA or bH < bA) then
          bz = table.clone(bC)
          bz.reason = "twisted-imminent-contact"
          bz.risk = 99
          bz.distance, bz.timeToContact = bI, bH
          bA = bH
        end
      end
      return bz
    end
    function q.shouldHide(by, bz)
      if m.options.reactiveHideOnly and not m.options.prioritizeSafety and not as then
        return q.immediateThreatAt(by)
      end
      local bA = bq(by)
      if bA then
        return true, bA
      end
      if m.detectionOnly then
        for bB, bC in ipairs(bb()) do
          local bD = bC.stationary and bC.ribbonActive and aY(by, bC.position) <= bC.killRadius + 6 or bC.ranged and bC.grabbing and not bd(bC, by) and aY(by, bC.position) <= bC.visionRadius + 5
          if bD then
            local bE = table.clone(bC)
            bE.reason = "active-twisted-attack"
            return true, bE
          end
        end
      end
      if not bz and a_(false) then
        return true, "health-loss"
      end
      local bB = q.sproutThreat()
      if bB then
        return true, bB
      end
      local bC = q.imminentThreatAt(by)
      if bC then
        return true, bC
      end
      local bD = q.machineEmergencyThreat()
      if bD then
        return true, bD
      end
      if m.options.wallCenterHiding then
        local bE = q.detectedThreat()
        if bE then
          return true, bE
        end
      end
      local bE = q.chaseThreat()
      if bE then
        R[bE.model] = m.room()
        if ay() then
          return false
        end
        return true, bE
      end
      if m.detectionOnly and not as then
        local bF = q.detectedThreat()
        return bF ~= nil, bF
      end
      if av() then
        return false
      end
      if aw() then
        if m.detectionOnly then
          local bF = q.detectedThreat()
          return bF ~= nil, bF
        end
        if m.options.machineHideMode == "retreat" then
          for bF, bG in ipairs(bb()) do
            if R[bG.model] == m.room() and (aY(by, bG.position) < bi(bG) or not bl(by, bG)) then
              local bH = table.clone(bG)
              bH.reason = "waiting-turn-away"
              return true, bH
            end
          end
          return false
        end
        local bF = q.detectedThreat()
        if bF then
          return true, bF
        end
        return q.threatAt(by, "detected-machine")
      end
      if ax() and not as then
        return q.threatAt(by, "travel")
      end
      local bF, bG = q.safeToInteract(by, 2, bz)
      if not bF and bG == "ichor-puddle" then
        return false
      end
      return not bF, bG
    end
    local function by(bz)
      if not aB() or bz == "health-loss" then
        return true
      end
      local bA, bB, bC = a0()
      return bC ~= nil and q.shouldHide(bC.Position, true)
    end
    function q.sprintSafe()
      local bz, bB, bC = a0()
      if not bC then
        return false
      end
      for bD, bE in ipairs(bb()) do
        if bE.stationary and aY(bC.Position, bE.position) <= math.max(125, bE.hearingRadius or 125) then
          return false
        end
      end
      return true
    end
    local bB = false
    local bC = -math.huge
    function q.enforceRibbonWalk()
      if m.movementMachine and m.movementMachine() then
        bB = false
        q.stats.ribbonWalk = false
        return false
      end
      local bD, bE, bF = a0()
      local bG = false
      if bF then
        for bH, bI in ipairs(bb()) do
          if bI.stationary and math.abs(bF.Position.Y - bI.position.Y) <= 16 and aY(bF.Position, bI.position) <= math.max(125, bI.hearingRadius or 125) then
            bG = true
            break
          end
        end
      end
      if bG and (not bB or a7(bD)) and os.clock() - bC >= 0.15 then
        m.setSprint(false, true)
        bC = os.clock()
        q.stats.ribbonSprintStops = (q.stats.ribbonSprintStops or 0) + 1
      end
      bB = bG
      q.stats.ribbonWalk = bG
      return bG
    end
    local bD, bE, bF, bG = nil, nil, -math.huge, {}
    function q.isRampShape(bH)
      return bH:IsA("WedgePart") or bH:IsA("CornerWedgePart") or bH:IsA("Part") and (tostring(bH.Shape) == "Enum.PartType.Wedge" or tostring(bH.Shape) == "Enum.PartType.CornerWedge")
    end
    function q.isGroundSurface(bH, bI, bJ)
      local bK = false
      local bL = bH
      while bL and bL ~= bI do
        local bM = bL.Name:lower():gsub("[^%w]", "")
        local bN = bL ~= bH and (bL:IsA("Folder") or bL:IsA("Model")) and (bM == "props" or bM == "decorations" or bM == "mapprops" or bM == "mapdecorations") and (bK or q.isRampShape(bH))
        if bM:find("ceiling", 1, true) or bM:find("roof", 1, true) or not bK and bM:find("wall", 1, true) or bM:find("table", 1, true) or bM:find("chair", 1, true) or bM:find("stool", 1, true) or bM:find("desk", 1, true) or bM:find("crate", 1, true) or bM:find("cone", 1, true) or bM:find("shelf", 1, true) or bM:find("shelv", 1, true) or bM:find("lamp", 1, true) or not bN and (bM:find("prop", 1, true) or bM:find("decoration", 1, true)) or bM:find("rail", 1, true) or bM:find("banister", 1, true) or bM == "generators" or bM == "items" or bM == "monsters" or bM == "dandystore" then
          return false
        end
        if bM:match("^floor") or bM:match("floor$") or bM:match("^ground") or bM:find("stair", 1, true) or bM:find("step", 1, true) or bM:find("ramp", 1, true) or bM == "platform" or bJ and bM == "base" then
          bK = true
        end
        bL = bL.Parent
      end
      if bK then
        return true
      end
      if not bH.CanCollide or bH.CanQuery == false then
        return false
      end
      local bM = bH.Size
      return math.min(bM.X, bM.Z) >= 3 and bM.Y <= math.max(bM.X, bM.Z) and (q.isRampShape(bH) or bH.CFrame.UpVector.Y >= 0.6 and bH.CFrame.UpVector.Y < 0.999 or bH:IsA("MeshPart") and bM.Y <= math.min(bM.X, bM.Z) * 0.75)
    end
    local function bH()
      local bI, bJ = m.room(), n:FindFirstChild("Elevators")
      if bI ~= bD or bJ ~= bE or os.clock() - bF > (#bG > 0 and 4 or 0.1) then
        bD, bE, bF, bG = bI, bJ, os.clock(), {}
        q.groundParametersCache = nil
        if bI then
          local bK = {}
          for bL, bM in ipairs({"Monsters", "Items", "HolidayPickups", "Generators"}) do
            local bN = bI:FindFirstChild(bM)
            if bN then
              table.insert(bK, bN)
            end
          end
          for bL, bM in ipairs(bI:GetDescendants()) do
            if not bM:IsA("BasePart") then
              continue
            end
            local bN = false
            for bO, bP in ipairs(bK) do
              if bM:IsDescendantOf(bP) then
                bN = true
                break
              end
            end
            if bN then
              continue
            end
            if m.strictGround then
              if q.isGroundSurface(bM, bI) then
                bG[#bG + 1] = bM
              end
              continue
            end
            local bO = bM
            while bO and bO ~= bI do
              local bP = bO.Name:lower()
              if bP:find("floor", 1, true) or bP:find("ground", 1, true) or bP:find("stair", 1, true) or bP:find("step", 1, true) or bP:find("ramp", 1, true) or bP:find("platform", 1, true) then
                table.insert(bG, bM)
                break
              end
              bO = bO.Parent
            end
          end
        end
        if bJ then
          if m.strictGround then
            for bK, bL in ipairs(bJ:GetDescendants()) do
              if bL:IsA("BasePart") and q.isGroundSurface(bL, bJ, true) then
                bG[#bG + 1] = bL
              end
            end
          else
            table.insert(bG, bJ)
          end
        end
        q.stats.supportPartCount = #bG
      end
      if q.groundParametersCache then
        return q.groundParametersCache
      end
      local bK = RaycastParams.new()
      bK.FilterType = Enum.RaycastFilterType.Include
      bK.FilterDescendantsInstances = bG
      bK.IgnoreWater = true
      bK.RespectCanCollide = true
      bK.CollisionGroup = "Default"
      q.groundParametersCache = bK
      q.stats.groundParameterBuilds = (q.stats.groundParameterBuilds or 0) + 1
      return bK
    end
    function q.groundHit(bI, bJ, bK)
      local bL = bJ
      for bM = 1, 5 do
        local bN = n:Raycast(bI, -aL * bL, bK)
        if not bN then
          return nil
        end
        if bN.Normal.Y >= 0.5 then
          return bN
        end
        local bO = math.max(0.03, bI.Y - bN.Position.Y + 0.03)
        bL -= bO
        if bL <= 0 then
          return nil
        end
        bI = Vector3.new(bI.X, bI.Y - bO, bI.Z)
      end
      return nil
    end
    local function bI(bJ, bK, bL)
      for bM, bN in ipairs({aK, Vector3.new(0.12, 0, 0), Vector3.new(-0.12, 0, 0), Vector3.new(0, 0, 0.12),
          Vector3.new(0, 0, -0.12)}) do
        local bO = q.groundHit(bJ + bN, bK, bL)
        if bO then
          return bO.Position.Y, bO.Instance, bO.Normal.Y
        end
      end
      for bM, bN in ipairs({Vector3.new(0.4, 0, 0), Vector3.new(0, 0, 0.4)}) do
        local bO = q.groundHit(bJ - bN, bK, bL)
        local bP = q.groundHit(bJ + bN, bK, bL)
        if bO and bP and math.abs(bO.Position.Y - bP.Position.Y) <= 0.75 then
          q.stats.seamSupportSamples = (q.stats.seamSupportSamples or 0) + 1
          return (bO.Position.Y + bP.Position.Y) * 0.5, bO.Instance, math.min(bO.Normal.Y, bP.Normal.Y)
        end
      end
      return nil
    end
    function q.calibrateStandingOffset(bJ, bK)
      local bL = bK.Parent
      local bM = bL.GetAttribute and tostring(bL:GetAttribute("ModuleName")) .. ":" .. tostring(bL:GetAttribute("CurrentSkin")) or ""
      local bN = q.standingProfile
      if bN and bN.char == bL and bN.root == bK and bN.skin == bM and bN.hip == bJ.HipHeight and bN.size == bK.Size and os.clock() - bN.at < 0.15 then
        return bN.offset
      end
      local bO = bL:FindFirstChild("Left Leg") or bL:FindFirstChild("Right Leg")
      local bP = math.max(0, bJ.HipHeight) + bK.Size.Y * 0.5
      if bJ.RigType == Enum.HumanoidRigType.R6 and bO then
        bP += bO.Size.Y
      end
      bP = math.clamp(bP, 0.5, 12)
      local bQ, bR, bS = math.huge, math.huge, -math.huge
      local bT, bU, bV = {}, nil, false
      for bW, bX in ipairs(bL:GetDescendants()) do
        local bY = bX:IsA("Bone")
        if not bY and (not bX:IsA("BasePart") or bX == bK or (bX.Transparency or 0) >= 0.95) then
          continue
        end
        local bZ = bX.Parent
        local b_ = false
        while bZ and bZ ~= bL do
          if bZ:IsA("Accessory") or bZ:IsA("Tool") then
            b_ = true
            break
          end
          bZ = bZ.Parent
        end
        if b_ then
          continue
        end
        local b0 = bX.Name:lower():gsub("[^%a]", "")
        if b0:find("hitbox", 1, true) or b0:find("collider", 1, true) or b0:find("shadow", 1, true) then
          continue
        end
        if bY then
          if b0:find("foot", 1, true) or b0:find("feet", 1, true) then
            local b1 = bK.CFrame:PointToObjectSpace(bX.TransformedWorldCFrame.Position) - aL * 0.12
            if b1.Y == b1.Y and b1.Y >= -25 and b1.Y <= 0 then
              bV = true
              bQ = math.min(bQ, b1.Y)
              bT[#bT + 1] = b1
              if b1.Y < bR then
                bR, bU = b1.Y, b1
              end
            end
          end
          continue
        end
        local b1 = b0:find("foot", 1, true) or b0:find("feet", 1, true) or b0 == "leftleg" or b0 == "rightleg" or b0:find("lowerleg", 1, true) or b0:find("toe", 1, true)
        for b2, b3 in ipairs({-1, 1}) do
          for b4, b5 in ipairs({-1, 1}) do
            for b6, b7 in ipairs({-1, 1}) do
              local b8 = bK.CFrame:PointToObjectSpace(bX.CFrame:PointToWorldSpace(Vector3.new(bX.Size.X * b3 * 0.5, bX.Size.Y * b5 * 0.5, bX.Size.Z * b7 * 0.5)))
              if b8.Y < bR then
                bR, bU = b8.Y, b8
              end
              bS = math.max(bS, b8.Y)
              if b1 and b5 == -1 then
                bQ = math.min(bQ, b8.Y)
                bT[#bT + 1] = b8
              end
            end
          end
        end
      end
      local bW = -math.min(bQ, bR)
      local bX, bY, bZ = bP, nil, "native-rig-fallback"
      if m.strictGround and bW == bW and bW >= 0 and bW <= 25 and bU then
        bX = bW
        bY = bT
        bY[#bY + 1] = bU
        bZ = bV and "current-skeleton-and-rig" or "current-rendered-rig"
      elseif not m.strictGround then
        local b_ = bI(bK.Position + aL * 0.1, 10, bH())
        local b0 = b_ and bK.Position.Y - b_
        if b0 and b0 >= 0.5 and b0 <= 12 then
          bX = b0
        end
      end
      S, T = bL, bX
      q.groundSolePoints = bY
      q.standingProfile = {char = bL, root = bK, skin = bM, hip = bJ.HipHeight, size = bK.Size, at = os.clock(),
        offset = bX, top = bS, skeleton = bV}
      q.stats.standingCalibration = bZ
      q.stats.standingOffset = bX
      q.stats.standingRig = bM
      return bX
    end
    local function bJ(bK, bL)
      return q.calibrateStandingOffset(bK, bL)
    end
    function q.invalidateStandingOffset()
      S, T = nil, nil
      q.groundSolePoints = nil
      q.standingProfile = nil
    end
    function q.uprightGroundPose(bK, bL)
      local bM = bL.LookVector
      local bN = Vector3.new(bM.X, 0, bM.Z)
      if bN.Magnitude < 0.001 then
        local bO = bK.CFrame.LookVector
        bN = Vector3.new(bO.X, 0, bO.Z)
      end
      if bN.Magnitude < 0.001 then
        bN = Vector3.new(0, 0, -1)
      end
      return CFrame.lookAt(bL.Position, bL.Position + bN.Unit, aL)
    end
    function q.projectGroundPose(bK, bL)
      if not m.strictGround or not m.floorFollowerFactory then
        return bL
      end
      bL = q.uprightGroundPose(bK, bL)
      if not q.groundFollower then
        q.groundFollower = m.floorFollowerFactory({room = function()
          return m.room() or n:FindFirstChild("Elevators")
        end, current = function(bM)
          return bM.CFrame
        end, position = function(bM)
          return bM.Position
        end, offset = function(bM, bN)
          local bO, bP = a0()
          if not bP then
            return nil
          end
          local bQ = bJ(bP, bM)
          if q.groundSolePoints and #q.groundSolePoints > 0 then
            local bR = math.huge
            for bS, bT in ipairs(q.groundSolePoints) do
              bR = math.min(bR, bN:PointToWorldSpace(bT).Y - bN.Position.Y)
            end
            if bR == bR and bR <= 0 and bR >= -25 then
              bQ = -bR
            end
          end
          return bQ
        end, pose = function(bM, bN, bO, bP)
          return CFrame.new(bN, bO, bP) * bM.Rotation
        end, padding = function()
          return 0.06
        end, recover = function(bM, bN, bO)
          local bP = q.standingProfile
          local bQ = bP and bP.top or 2
          if bQ ~= bQ or bQ == math.huge or bQ == -math.huge then
            bQ = 2
          end
          bQ = math.clamp(bQ, 0.25, 25)
          local bR = bM.Position
          local bS = bR.Y + bQ + 0.12
          local bT = bI(Vector3.new(bR.X, bS, bR.Z), bN + bQ + 3, bH())
          if bT and bT > bO + 0.1 and bT <= bS and bT - bO <= bN + bQ + 0.12 then
            return bT
          end
        end, sample = function(bM, bN)
          local bO, bP, bQ = bI(Vector3.new(bM.X, bN, bM.Z), 96, bH())
          return bO, bP and aN(bP) or false, bQ
        end})
      end
      local bM, bN = q.groundFollower.project(bK, bL)
      q.groundOwned = bM ~= nil
      q.stats.grounding = q.groundFollower.stats
      if bM then
        q.lastGroundAt = os.clock()
        q.lastGroundPosition = bM.Position
      end
      return bM, bN
    end
    function q.enforceGround()
      if q.directHeightTravel then
        return false
      end
      if q.resetInProgress or not m.strictGround or not m.alive() then
        return false
      end
      local bK, bL, bM = a0()
      if not bM or bM.Anchored then
        q.groundOwned = false
        return false
      end
      if m.releaseReady and not m.releaseReady() and not w.active then
        q.groundOwned = false
        return false
      end
      if w.active and not w.leaving and w.geometry and w.geometry.grounded and w.position and (bM.Position - w.position).Magnitude < 0.03 and os.clock() - (w.lastGroundCheck or -math.huge) < 0.16 then
        return true
      end
      if D and D.PlaybackState == Enum.PlaybackState.Playing and q.groundOwned and os.clock() - (q.lastGroundAt or 0) < 0.075 then
        return true
      end
      if q.groundOwned and q.lastGroundPosition and os.clock() - (q.lastGroundAt or 0) < 0.025 and (bM.Position - q.lastGroundPosition).Magnitude < 0.02 then
        bM.AssemblyLinearVelocity = Vector3.new(bM.AssemblyLinearVelocity.X, 0, bM.AssemblyLinearVelocity.Z)
        return true
      end
      local bN, bO = q.projectGroundPose(bM, bM.CFrame)
      if not bN then
        q.stats.groundBlock = bO
        return false
      end
      if math.abs(bN.Position.Y - bM.Position.Y) > 0.035 then
        bM.CFrame = bN
      end
      bM.AssemblyLinearVelocity = Vector3.new(bM.AssemblyLinearVelocity.X, 0, bM.AssemblyLinearVelocity.Z)
      return true
    end
    local function bL(bM, bN)
      local bO, bP, bQ = a0()
      if not bQ then
        return nil
      end
      local bR = Vector3.new(bM.X, math.max(bN, bM.Y) + 0.75, bM.Z)
      local bS = bH()
      local bT, bU, bV = bI(bR, 64, bS)
      if bT then
        return Vector3.new(bM.X, bT + bJ(bP, bQ) + (m.strictGround and 0.06 or 0), bM.Z), bV, bU
      end
      q.stats.lastGroundMiss = {position = tostring(bM), referenceY = bN, origin = tostring(bR), supportPartCount = #bG}
      return nil
    end
    function q.ensureGeometry()
      if q.geometry then
        return q.geometry
      end
      q.geometry = m.coverGeometry({character = m.character, room = m.room, maxDistance = s, standingOffset = function()
        local bM, bN, bO = a0()
        return bO and bN and bJ(bN, bO)
      end, allowPartial = function()
        return m.options.prioritizeSafety ~= true
      end, preferWalls = function()
        return m.options.coverPreference ~= "nearest"
      end, floorY = function(bM, bN)
        local bO = math.min(bM.Y, bN.Y) + 0.75
        return bI(Vector3.new(bM.X, bO, bM.Z), 64, bH())
      end})
      if w.geometry and w.geometryController and w.geometryController ~= q.geometry then
        local bM = w.geometryController
        w.geometryController = q.geometry
        q.geometryByPart = q.geometryByPart or {}
        q.geometryByPart[w.part] = w.geometry
        if bM.destroy then
          pcall(bM.destroy)
        end
      end
      return q.geometry
    end
    local function bM(bN, bO)
      local bP = w.part
      if not (w.leaving or bO) or not w.active or w.kind ~= "wall" or w.floor ~= m.room() or not bP or not bP.Parent or not bP:IsA("BasePart") or not bP.CanCollide or aQ(bP) or typeof(w.position) ~= "Vector3" or (bN - w.position).Magnitude > 12 or math.abs(bN.Y - w.position.Y) > 0.8 then
        return false
      end
      local bQ = m.character()
      if bQ ~= w.character then
        return false
      end
      local bR = bP.CFrame:PointToObjectSpace(bN)
      local bS = bP.Size * 0.5
      return math.abs(bR.X) < bS.X and math.abs(bR.Y) < bS.Y and math.abs(bR.Z) < bS.Z
    end
    local function bN(bO, bP)
      if (av() or as ~= nil) and not w.active and not w.pending then
        return bL(bO, bP)
      end
      if aV() and not w.leaving and (w.active or w.pending or y) then
        return bO
      end
      local bQ = bL(bO, bP)
      if not bQ and bM(bO) then
        return Vector3.new(bO.X, w.position.Y, bO.Z)
      end
      return bQ
    end
    function q.terrainSampleSpacing()
      if not m.strictGround then
        return 2
      end
      local bO, bP, bQ = a0()
      local bR = bQ and bP and bJ(bP, bQ) or 2.3
      return math.clamp((bR + 0.6) / 1.8, 0.3, 1.25)
    end
    local function bO(bP, bQ, bR, bS, bT)
      if q.correctedLegBlocked(bP, bQ) then
        return false
      end
      local bU = math.max(1, math.ceil((bQ - bP).Magnitude / q.terrainSampleSpacing()))
      local bV = aX(bQ - bP)
      local bW = bV.Magnitude > 0.1 and Vector3.new(-bV.Z, 0, bV.X).Unit * 0.65 or Vector3.new(0.65, 0, 0)
      local bX = bS ~= false and bM(bP, bS)
      local bY = false
      local bZ, b_, b0
      for b1 = 0, bU do
        if bT and not bT() then
          return false
        end
        local b2 = bP:Lerp(bQ, b1 / bU)
        if m.strictGround and bZ then
          b2 = Vector3.new(b2.X, bZ.Y, b2.Z)
        end
        local b3 = true
        local b4, b5, b6
        for b7, b8 in ipairs({aK, bW, -bW}) do
          local b9 = m.strictGround and b2.Y or math.max(bP.Y, bQ.Y, tonumber(bR) or -math.huge)
          if m.strictGround and b8 ~= aK and b4 and b5 and b5 >= 0.5 and b5 < 0.999 then
            local ca = b8.Magnitude * math.sqrt(math.max(0, 1 / (b5 * b5) - 1))
            b9 = math.max(b9, b4.Y) + math.min(1.2, ca)
          end
          local ca, cb, cc = bL(b2 + b8, b9)
          if not ca then
            b3 = false
            if bX and not bY and bM(b2 + b8, bS) then
              continue
            end
            q.stats.unsupportedLegs = (q.stats.unsupportedLegs or 0) + 1
            q.stats.lastUnsupportedSample = {from = tostring(bP), to = tostring(bQ), point = tostring(b2 + b8),
              supportY = bR}
            return false
          end
          if m.strictGround then
            if b8 == aK then
              b4, b5, b6 = ca, cb, cc
            elseif b4 and (ca.Y - b4.Y > 2 or b4.Y - ca.Y > 6.05) then
              q.stats.terrainFailure = {reason = "side-height", from = tostring(bP), to = tostring(bQ),
                point = tostring(b2 + b8), centerY = b4.Y, groundY = ca.Y, part = cc and cc:GetFullName()}
              return false
            end
            if not bZ then
              if math.abs(ca.Y - bP.Y) > 2 then
                q.stats.terrainFailure = {reason = "origin-height", from = tostring(bP), to = tostring(bQ),
                  point = tostring(b2 + b8), expectedY = bP.Y, groundY = ca.Y, part = cc and cc:GetFullName()}
                return false
              end
            else
              local cd = ca.Y - bZ.Y
              local ce = aY(ca, bZ)
              local cf = aN(cc) or b0 and aN(b0)
              local cg = cb and cb >= 0.5 and cb < 0.999 or b_ and b_ >= 0.5 and b_ < 0.999
              if cd > 0.65 and not (cf or cg and cd <= ce * 1.8 + 0.2) or cd > math.max(2.55, ce * 1.8 + 0.2) or cd < -6.05 then
                q.stats.terrainFailure = {reason = "profile-change", from = tostring(bP), to = tostring(bQ),
                  point = tostring(b2 + b8), rise = cd, span = ce, normalY = cb, stairs = cf, part = cc and cc:GetFullName()}
                return false
              end
            end
          end
        end
        if b4 then
          bZ, b_, b0 = b4, b5, b6
        end
        if b3 then
          bY = true
        end
      end
      if m.strictGround and bZ and math.abs(bZ.Y - bQ.Y) > 2 then
        q.stats.terrainFailure = {reason = "endpoint-level", from = tostring(bP), to = tostring(bQ), expectedY = bQ.Y,
          groundY = bZ.Y}
        return false
      end
      return true
    end
    q.floorLegSafe = bO
    function q.projectRoutePoint(bP, bQ)
      local bR = bP
      local bS = math.max(1, math.ceil(aY(bP, bQ) / q.terrainSampleSpacing()))
      for bT = 1, bS do
        local bU = bP:Lerp(bQ, bT / bS)
        bR = bL(Vector3.new(bU.X, bR.Y, bU.Z), bR.Y)
        if not bR then
          return nil
        end
      end
      return bR
    end
    function q.safeToInteract(bP, bQ, bR, bS, bT)
      if typeof(bP) ~= "Vector3" then
        return false, "invalid-position"
      end
      if not m.options.reactiveHideOnly and not bR and a_(false) then
        return false, "health-loss"
      end
      if not m.alive() then
        return false, "cancelled"
      end
      local bU, bV, bW = a0()
      if not bW then
        return false, "no-character"
      end
      local bX
      if bS then
        bX = bP
      elseif aY(bP, bW.Position) <= 3 and math.abs(bP.Y - bW.Position.Y) < 4 then
        bX = bW.Position
      else
        bX = bL(bP, bP.Y)
      end
      if not bX then
        return false, "no-floor-at-target"
      end
      local bY = bq(bX)
      if bY then
        return false, bY
      end
      local bZ = aY(bX, bW.Position) <= 6 and q.imminentThreatAt(bX)
      if bZ then
        return false, bZ
      end
      if m.hazards and m.hazards.dangerAt(bX, aS()) then
        return false, "ichor-puddle"
      end
      if m.options.reactiveHideOnly and not as then
        local b_, b0 = q.immediateThreatAt(bX)
        return not b_, b0
      end
      local b_ = math.clamp(math.max(1.2, tonumber(bQ) or 0.35), 1.2, 4)
      local b0 = bb()
      if aG then
        return false, {model = aG, risk = 99, reason = "untracked-threat"}
      end
      for b1, b2 in ipairs(b0) do
        if bn(bX, b2, b_) then
          continue
        end
        if math.abs(bX.Y - b2.position.Y) <= 16 then
          if b2.stationary then
            if m.detectionOnly and not b2.ribbonActive then
              continue
            end
            if aY(bX, b2.position) <= b2.killRadius + 6 then
              local b3 = table.clone(b2)
              b3.reason = "twisted-ribbon-circle"
              b3.risk = 6
              return false, b3
            end
            continue
          end
          local b3, b4 = bc(bX, b2, b_)
          local b5 = aY(bX, b2.position)
          if b2.ranged and b2.grabbing and b5 <= b2.visionRadius + 25 + aM(b2) and not bd(b2, bX) then
            local b6 = table.clone(b2)
            b6.reason = "ranged-attack-visible"
            b6.risk = 6
            return false, b6
          end
          if bT == "pickup" or bT == "detected-machine" or bT == "retreat-machine" or bT == "machine-return" then
            local b6 = (bT == "detected-machine" or bT == "machine-return") and bo(b2)
            local b7 = b2.chasingUs and not (bT == "pickup" and m.options.pickupChaseMode == "chase")
            if m.detectionOnly and (bT == "detected-machine" or bT == "machine-return" and not w.active and not w.pending and not w.leaving) then
              if b7 or b6 then
                local b8 = table.clone(b2)
                b8.reason = b2.chasingUs and "twisted-chasing" or "twisted-detected"
                return false, b8
              end
              if b5 <= b2.killRadius + 2 and not bd(b2, bX) then
                local b8 = table.clone(b2)
                b8.reason = "twisted-machine-contact"
                return false, b8
              end
              continue
            end
            local b8 = bT == "detected-machine" and aA or (bT == "retreat-machine" or bT == "machine-return") and bi(b2) or bh(b2)
            local b9 = bT == "detected-machine" and b5 or b3
            if m.options.returnToGenerator and (bT == "machine-return" or bT == "detected-machine") then
              b8 = math.max(aA, b2.killRadius + 8) + aM(b2)
              b6 = false
              b7 = b2.chasingUs and b3 <= b8
            end
            local ca = bT == "retreat-machine" and R[b2.model] == m.room() and not bl(bX, b2)
            if b7 or b6 or b9 <= b8 or ca then
              local cb = table.clone(b2)
              cb.reason = b2.chasingUs and "twisted-chasing" or b6 and "twisted-detected" or bT == "pickup" and "twisted-near-pickup" or "twisted-too-close"
              cb.risk = 4
              cb.distance = b9
              return false, cb
            end
            continue
          end
          if m.options.detectionMode == "advanced" then
            local b6 = bm(bX, b2)
            local b7 = (b5 <= b6 + 12 and ba(b2.position + aL, bX + aL)) or (aY(bX, b4) <= b6 + 12 and ba(b4 + aL, bX + aL))
            local b8
            if b3 <= b2.killRadius + 8 + aM(b2) then
              b8 = "twisted-too-close"
            elseif (b7 or b2.chasingUs) and b3 <= b6 then
              b8 = b2.chasingUs and "twisted-chasing" or "twisted-facing-or-approaching"
            end
            if b8 then
              local b9 = table.clone(b2)
              b9.reason = b8
              b9.risk = 4
              b9.distance = b3
              b9.lineOfSight = b7
              return false, b9
            end
            continue
          end
          local b6 = math.max(b2.instantRadius + 20, b2.killRadius + 25)
          b6 += aM(b2)
          if b2.ranged then
            b6 = math.max(b6, b2.visionRadius + 25)
          end
          local b7 = (b5 <= b2.visionRadius + 10 and ba(b2.position + aL, bX + aL)) or (aY(bX, b4) <= b2.visionRadius + 10 and ba(b4 + aL, bX + aL))
          local b8
          if b3 <= b6 then
            b8 = "twisted-too-close"
          elseif b2.chasingUs and b3 <= b2.visionRadius + 20 then
            b8 = "twisted-chasing"
          elseif b7 and b3 <= b2.visionRadius + 10 then
            b8 = "twisted-visible"
          end
          if b8 then
            local b9 = table.clone(b2)
            b9.distance, b9.currentDistance = b3, b5
            b9.position, b9.standingPosition = b2.position, bX
            b9.forecastSeconds, b9.lineOfSight, b9.reason = b_, b7, b8
            b9.risk = 4
            return false, b9
          end
        end
      end
      return true
    end
    function q.safeToPickup(bP, bQ, bR, bS)
      return q.safeToInteract(bP, bQ, bR, bS, "pickup")
    end
    function q.safeToMachine(bP, bQ, bR, bS)
      return q.safeToInteract(bP, bQ, bR, bS, bj() and "machine-return" or az())
    end
    function q.safeToMachineReturn(bP, bQ, bR, bS)
      return q.safeToInteract(bP, bQ, bR, bS, "machine-return")
    end
    function q.safeHere(bP, bQ, bR)
      local bS = av() and q.safeToPickup or aw() and q.safeToMachine or q.safeToInteract
      return bS(bP, bQ, bR)
    end
    local function bP(bQ)
      if not af then
        return true
      end
      local bR, bS = q.exitWriteGuard()
      if not bR then
        return false, bS
      end
      if q.chaseThreat() or q.detectedThreat() then
        return false, "twisted-chasing"
      end
      if m.detectionOnly and af == "machine" then
        local bT = not bq(bQ) and q.travelLegClear(bQ, bQ, 0, true)
        return bT, bT and nil or "cover-exit-unsafe"
      end
      local bT = af == "machine" and q.safeToMachineReturn or af == "pickup" and q.safeToPickup or q.safeToInteract
      local bV = bT(bQ, 1.2, true, true)
      return bV, bV and nil or "cover-exit-unsafe"
    end
    function q.elevatorPosition()
      local bQ = n:FindFirstChild("Elevators")
      local bR = bQ and bQ:FindFirstChild("Elevator")
      local bS = bR and bR:FindFirstChild("Base")
      local bT, bV, bW = a0()
      if bS and bS:IsA("BasePart") and bW then
        return bS.Position + aL * (bS.Size.Y * 0.5 + bJ(bV, bW))
      end
      return nil
    end
    local function bQ(bR)
      if aV() then
        return true
      end
      local bS, bT, bV = a0()
      if not bV then
        return aW("no-character")
      end
      local bW = OverlapParams.new()
      bW.FilterType = Enum.RaycastFilterType.Exclude
      bW.FilterDescendantsInstances = a9(false).FilterDescendantsInstances
      bW.RespectCanCollide = true
      bW.CollisionGroup = bV.CollisionGroup
      bW.MaxParts = 40
      local bX = Vector3.new(math.clamp(bV.Size.X * 0.85, 1.2, 2), math.clamp(bV.Size.Y * 0.9, 1.5, 2.4), math.clamp(bV.Size.Z * 0.85, 1, 2))
      local bY = n:GetPartBoundsInBox(CFrame.new(bR), bX, bW)
      for bZ, b_ in ipairs(bY) do
        if b_.CanCollide then
          return aW("blocked-destination", b_)
        end
      end
      return true
    end
    local function bR(bT, bV, bW)
      if bW.stationary then
        return false
      end
      local bX = H(nil, true)
      local bY = (bV - bT).Magnitude / bX
      if bY <= 0.000001 then
        return false
      end
      local bZ = aX(bV - bT) / bY - aX(bW.velocity)
      return aX(bT - bW.position):Dot(bZ) > 0 and aY(bV, bW.position) >= aY(bT, bW.position) - 0.01
    end
    local function bT(bV, bW, bX)
      if (bW - bV).Magnitude > 32.1 or w.active and not w.leaving then
        return false
      end
      for bY, bZ in ipairs(bX or bb()) do
        if not bZ.stationary and math.abs(bV.Y - bZ.position.Y) <= 16 and (bZ.chasingUs or bo(bZ)) and bc(bV, bZ, 0.6) <= bZ.killRadius + 12 + aM(bZ) then
          return true
        end
      end
      return false
    end
    local function bV(bW, bX, bY)
      local bZ = (bX - bW).Magnitude / math.max(0.1, H(nil, true))
      if bZ < 0.000001 then
        return true
      end
      local b_ = aX(bW - bY.position)
      local b0 = aX(bX - bW) / bZ - aX(bY.velocity)
      local b1 = b0:Dot(b0)
      local b2 = b1 > 0.00001 and math.clamp(-b_:Dot(b0) / b1, 0, bZ) or 0
      local b3 = (b_ + b0 * b2).Magnitude
      local b4 = (b_ + b0 * bZ).Magnitude
      local b5 = b_.Magnitude
      local b6 = bY.killRadius + 7 + aM(bY)
      local b7
      if b5 < b6 then
        b7 = b3 >= b5 - 0.05 and b4 >= b5 - 0.01 and aY(bX, bY.position) > b5 + 0.1
      else
        b7 = b3 >= b6
      end
      if not b7 then
        q.stats.retreatBlocker = bY.model and bY.model.Name
        q.stats.retreatClosest = b3
      end
      return b7
    end
    local function bW(bX, bY)
      if (bY - bX).Magnitude <= 0.0001 then
        return true
      end
      local bZ = bb()
      if aG then
        return false
      end
      local b_ = bT(bX, bY, bZ)
      for b0, b1 in ipairs(bZ) do
        if math.abs(bX.Y - b1.position.Y) > 16 and math.abs(bY.Y - b1.position.Y) > 16 then
          continue
        end
        if b1.stationary then
          local b2, b3 = aY(bX, b1.position), aY(bY, b1.position)
          if b3 <= b1.killRadius + 6 and b3 < b2 + 0.2 then
            return false
          end
          continue
        end
        local b2 = ah and ah(bX, bY, b1)
        if b2 ~= nil then
          if not b2 then
            return false
          end
          continue
        end
        if b_ and not b1.ranged then
          if not bV(bX, bY, b1) then
            return false
          end
          continue
        end
        if bR(bX, bY, b1) then
          continue
        end
        local b3, b4, b5 = bp(bX, b1, 0.6)
        local b6, b7, b8 = bp(bY, b1, 0.6)
        if y then
          if b7 < b1.killRadius + 7 and b7 < b4 + 0.2 then
            return false
          end
          if b7 < b1.instantRadius + 8 and b7 < b4 - 0.5 and ba(b1.position + aL, bY + aL) then
            return false
          end
          continue
        end
        if b3 < 4 and b6 >= 4 then
          return false
        end
        if b7 < b1.killRadius + 5 and b7 < b4 + 0.5 then
          return false
        end
        if b4 < b1.instantRadius + 10 and b7 < b4 - 0.5 then
          return false
        end
        if b5 and b8 and (b3 >= 4 or b6 >= 4) and b7 < b4 - 1 then
          return false
        end
        if not b5 and b8 and b6 >= 4 and b7 <= b4 + 0.5 then
          return false
        end
      end
      return true
    end
    local function bX(bY, bZ)
      if not aB() then
        return false
      end
      local b_ = false
      for b0, b1 in ipairs(bb()) do
        if b1.chasingUs and not ay() or (aw() and m.options.machineHideMode ~= "retreat" and bo(b1)) then
          return false
        end
        local b2 = bc(bY, b1, 0.6)
        local b3 = bc(bZ, b1, 0.6)
        if math.abs(bY.Y - b1.position.Y) <= 16 and math.min(b2, b3) <= bh(b1) then
          b_ = true
          if not bR(bY, bZ, b1) then
            return false
          end
        end
      end
      return b_
    end
    local function bY(bZ, b_)
      if aV() then
        return true
      end
      local b0, b1 = b_ - bZ, aX(b_ - bZ)
      if b1.Magnitude < 0.2 then
        return true
      end
      local b2 = Vector3.new(-b1.Z, 0, b1.X).Unit
      local b3 = a9(false)
      for b4, b5 in ipairs({aK, b2 * 0.75, b2 * -0.75, aL * 0.75}) do
        local b6 = n:Raycast(bZ + b5, b0, b3)
        if b6 then
          return aW("route-blocked", b6.Instance)
        end
      end
      return true
    end
    local function bZ(b_)
      return not b_ and m.exitRequired ~= nil and m.exitRequired() == true
    end
    local function b_(b0, b1, b2, b3, b4, b5, b6)
      if a_(b2) then
        return nil, "health-loss"
      end
      if bZ(b2) then
        return nil, "exit-required"
      end
      local b7 = bb()
      local b8 = not b2 and (b6 == "pickup" or b6 == "detected-machine" or b6 == "retreat-machine" or (b6 == "machine" and m.options.machineHideMode ~= "default") or (b6 == nil and aB()))
      local b9 = b6 == "retreat-machine" or b6 == "machine" and m.options.machineHideMode == "retreat" or b6 == nil and aw() and m.options.machineHideMode == "retreat"
      local ca = {}
      local function cb(cc, cd, ce)
        local cf = aX(cd - cc)
        local cg = cf.Magnitude > 0.1 and math.clamp(aX(ce - cc):Dot(cf) / cf:Dot(cf), 0, 1) or 0
        return aY(cc + cf * cg, ce)
      end
      for cc, cd in ipairs(b7) do
        if cd.position.Y >= math.min(b0.Y, b1.Y) - 16 and cd.position.Y <= math.max(b0.Y, b1.Y) + 16 then
          local ce = math.max(cd.killRadius + (b2 and 12 or 25), cd.instantRadius + (b2 and 8 or 20))
          ce += aM(cd)
          if cd.stationary then
            ce = cd.killRadius + 6
          end
          if b9 then
            ce = bi(cd)
          elseif b8 then
            ce = bh(cd)
          elseif m.options.detectionMode == "advanced" and not cd.stationary then
            ce = bm((b0 + b1) * 0.5, cd)
          end
          if not b2 and as == cd.model then
            ce = be(cd)
          end
          if cd.ranged then
            ce = math.max(ce, cd.visionRadius + (b2 and 12 or 25))
          end
          local cf = cd.position + cd.velocity * 0.6
          if not b2 and not as then
            ce = bk(cd)
          end
          if cd.ranged and (not m.detectionOnly or cd.chasingUs or cd.grabbing) then
            ce = math.max(ce, cd.visionRadius + 25)
          end
          if cd.stationary then
            ce = cd.killRadius + 7
          end
          table.insert(ca, {threat = cd, position = cd.position, predicted = cf, radius = ce})
        end
      end
      local function cc(cd, ce, cf)
        if q.correctedLegBlocked(cd, ce) then
          return false, "corrected-route-cooldown"
        end
        if not b5 and not bY(cd, ce) then
          return false, "route-blocked"
        end
        local cg, ch = aT(cd, ce)
        if not cg then
          return false, ch
        end
        if not b2 and not as and not q.travelLegClear(cd, ce, cf) then
          return false, "twisted-on-direct-route"
        end
        local ci = b2 and bT(cd, ce, b7)
        for cj, ck in ipairs(ca) do
          local cl = ck.threat
          if m.detectionOnly and not b2 and not as then
            continue
          end
          if cl.position.Y < math.min(cd.Y, ce.Y) - 16 or cl.position.Y > math.max(cd.Y, ce.Y) + 16 then
            continue
          end
          if b2 and ah then
            local cm = ah(cd, ce, cl)
            if cm == true then
              continue
            end
            if cm == false then
              return false, "cover-entry-intercept"
            end
          end
          if ci and not cl.stationary and not cl.ranged then
            if not bV(cd, ce, cl) then
              return false, "escape-leg-intercept"
            end
            continue
          end
          local cm = ck.radius
          if not b8 and m.options.detectionMode == "advanced" and not cl.stationary and not cl.chasingUs and not ba(cl.position + aL, cd + aL) and not ba(cl.position + aL, ce + aL) and not ba(cl.position + aL, (cd + ce) * 0.5 + aL) then
            cm = cl.killRadius + 8 + aM(cl)
          end
          if b2 and not cl.stationary and not ba(cl.position + aL, cd + aL) and not ba(cl.position + aL, ce + aL) and not ba(cl.position + aL, (cd + ce) * 0.5 + aL) then
            cm = cl.killRadius + 10 + aM(cl)
          end
          local cn = {ck.position, ck.predicted}
          if b2 and bR(cd, ce, cl) then
            cn = {ck.position}
          end
          for co, cp in ipairs(cn) do
            local cq, cr = aY(cd, cp), aY(ce, cp)
            local cs = cb(cd, ce, cp)
            if cq < cm then
              if cr < cq + 0.25 or cs < cq - 0.5 then
                return false, "twisted-on-direct-route"
              end
            elseif cs < cm then
              return false, "twisted-on-direct-route"
            end
            if cs < cl.killRadius + 7 and cs < cq - 0.1 then
              return false, "twisted-on-direct-route"
            end
          end
        end
        local cj = bO(cd, ce)
        return cj, cj and nil or "unsupported-tween-leg"
      end
      if b6 == "machine-exit" then
        for cd, ce in ipairs(ca) do
          ce.radius = math.max(ce.radius, ce.threat.killRadius + 14, 20 + aM(ce.threat))
        end
      end
      local function cd(ce, cf)
        return (cf - ce).Magnitude / math.max(1, H(nil, false))
      end
      local ce, cf = cc(b0, b1)
      if ce then
        q.stats.routeReason = "direct-supported-tween-route"
        return {b0, b1}
      end
      if m.hideWhilePlanning and not b2 and not as and not w.active and not w.pending and av() and cf == "twisted-on-direct-route" and not q.canPlanFromClearGround(b0) then
        return nil, "route-needs-cover"
      end
      local cg = aX(b1 - b0)
      if cg.Magnitude > 0.1 then
        local ch = Vector3.new(-cg.Z, 0, cg.X).Unit
        for ci, cj in ipairs({8, -8, 16, -16, 28, -28}) do
          local ck = bL((b0 + b1) * 0.5 + ch * cj, (b0.Y + b1.Y) * 0.5)
          if ck and cc(b0, ck, 0) and cc(ck, b1, cd(b0, ck)) and bO(b0, ck) and bO(ck, b1) then
            q.stats.routeReason = "short-supported-detour"
            return {b0, ck, b1}
          end
        end
      end
      if m.hazards then
        local ch, ci = nil, math.huge
        for cj, ck in ipairs(m.hazards.detours(b0, b1)) do
          local cl, cm = bL(ck[1], b0.Y), bL(ck[2], b0.Y)
          if cl and cm and cc(b0, cl, 0) and cc(cl, cm, cd(b0, cl)) and cc(cm, b1, cd(b0, cl) + cd(cl, cm)) and bO(b0, cl) and bO(cl, cm) and bO(cm, b1) then
            local cn = (cl - b0).Magnitude + (cm - cl).Magnitude + (b1 - cm).Magnitude
            if cn < ci then
              ch, ci = {b0, cl, cm, b1}, cn
            end
          end
        end
        if ch then
          q.stats.puddleDetours = (q.stats.puddleDetours or 0) + 1
          return ch
        end
      end
      local ch = {}
      if m.nativeRoutes and not b2 and not as then
        local ci = M
        if not ci or ci.floor ~= b4 or os.clock() - ci.at > 2 or (ci.origin - b0).Magnitude > 2.5 or (ci.target - b1).Magnitude > 1 then
          local cj, ck, cl = a0()
          local cm = cl and bJ(ck, cl) or 2
          local cn, co = pcall(function()
            local cn = game:GetService("PathfindingService"):CreatePath({AgentRadius = 1.4, AgentHeight = math.max(4, cm * 2),
              AgentCanJump = false, AgentCanClimb = false, WaypointSpacing = 5})
            cn:ComputeAsync(b0 - aL * (cm - 0.3), b1 - aL * (cm - 0.3))
            if cn.Status ~= Enum.PathStatus.Success then
              return nil
            end
            local co = {}
            for cp, cq in ipairs(cn:GetWaypoints()) do
              if cq.Action == Enum.PathWaypointAction.Jump then
                return nil
              end
              co[#co + 1] = cq.Position + aL * cm
            end
            return co
          end)
          ci = {floor = b4, at = os.clock(), origin = b0, target = b1, points = cn and co or nil}
          M = ci
          q.stats.nativeRouteComputes = (q.stats.nativeRouteComputes or 0) + 1
        end
        if b3 and not aZ(b3) then
          return nil, "cancelled"
        end
        if Z then
          return nil, "twisted-detected"
        end
        if ci.points then
          local cj = {b0}
          local ck = true
          local cl
          local cm = 0
          for cn, co in ipairs(ci.points) do
            local cp
            if m.strictGround then
              cp = q.projectRoutePoint(cj[#cj], co)
            else
              cp = bL(co, co.Y)
            end
            if cp then
              ch[#ch + 1] = cp
              if (cp - cj[#cj]).Magnitude > 0.2 then
                local cq, cr = cc(cj[#cj], cp, cm)
                if not cq then
                  if not cl then
                    q.stats.nativeGroundBlock = cr == "unsupported-tween-leg" and (q.stats.terrainFailure or q.stats.lastUnsupportedSample) or nil
                  end
                  ck = false
                  cl = cl or cr
                end
                cm += cd(cj[#cj], cp)
                cj[#cj + 1] = cp
              end
            else
              ck = false
              cl = cl or "native-route-without-floor"
            end
          end
          local cn, co = cc(cj[#cj], b1, cm)
          if not cn then
            ck = false
            cl = cl or co
          end
          cj[#cj + 1] = b1
          q.stats.nativeRouteBlock = cl
          if ck then
            local cp = {b0}
            local cq = 1
            local cr = 0
            while cq < #cj do
              local cs = cq + 1
              for ct = math.min(#cj, cq + 12), cq + 2, -1 do
                if cc(cj[cq], cj[ct], cr) then
                  cs = ct
                  break
                end
              end
              if not cc(cj[cq], cj[cs], cr) then
                ck = false
                q.stats.nativeRouteBlock = "timed-smoothed-route-blocked"
                break
              end
              cr += cd(cj[cq], cj[cs])
              cp[#cp + 1] = cj[cs]
              cq = cs
            end
            if ck then
              q.stats.routeReason = "native-supported-tween-route"
              q.stats.routeWaypoints = #cp
              return cp
            end
          end
        end
      end
      if not b2 and not as then
        local ci = {b0, b1}
        local cj = {}
        local ck, cl, cm = a0()
        if not cm then
          return nil, "no-character"
        end
        local cn = bJ(cl, cm)
        local function co(cp, cq)
          if #ci >= 192 or typeof(cp) ~= "Vector3" then
            return
          end
          local cr = bL(cp, cq or cp.Y)
          if not cr or not bQ(cr) then
            return
          end
          local cs = string.format("%d:%d:%d", math.round(cr.X / 2), math.round(cr.Y / 2), math.round(cr.Z / 2))
          if cj[cs] then
            return
          end
          cj[cs] = true
          table.insert(ci, cr)
        end
        if J ~= b4 or os.clock() - K > 2 then
          J, K, L = b4, os.clock(), {}
          local cp = b4 and b4:FindFirstChild("Waypoints")
          if cp then
            for cq, cr in ipairs(cp:GetDescendants()) do
              if cr:IsA("BasePart") then
                table.insert(L, {position = cr.Position + aL * cn, kind = "corridor"})
              end
            end
          end
          if b4 then
            for cq, cr in ipairs(b4:GetDescendants()) do
              if #L >= 512 then
                break
              end
              local cs = false
              local ct = cr
              while ct and ct ~= b4 do
                if ct.Name:lower():find("ladder", 1, true) then
                  cs = true
                  break
                end
                ct = ct.Parent
              end
              if cr:IsA("BasePart") and cr.CanCollide and (aN(cr) or q.isGroundSurface(cr, b4) and cr.CFrame.UpVector.Y < 0.999 or q.isRampShape(cr)) and not cs and cr.CFrame.UpVector.Y >= 0.6 and (not m.strictGround or q.isGroundSurface(cr, b4)) then
                local cu = cr.Size
                local cv, cw = math.abs(cr.CFrame.RightVector.Y), math.abs(cr.CFrame.LookVector.Y)
                local cx = q.isRampShape(cr) and "Z" or math.max(cv, cw) > 0.04 and (cv > cw and "X" or "Z") or (cu.X > cu.Z and "X" or "Z")
                local cy = cx == "X" and cu.X or cu.Z
                local cz = math.clamp(math.ceil(cy / 3), 1, 20)
                for cA = 0, cz do
                  local cB = -cy * 0.5 + 0.6 + math.max(0, cy - 1.2) * cA / cz
                  local cC = cx == "X" and Vector3.new(cB, cu.Y * 0.5, 0) or Vector3.new(0, cu.Y * 0.5, cB)
                  local cD = cr.CFrame:PointToWorldSpace(cC)
                  table.insert(L, {position = cD + aL * cn, kind = "stairs"})
                end
              end
            end
          end
        end
        local cp = table.clone(L)
        table.sort(cp, function(cq, cr)
          local cs = (cq.position - b0).Magnitude + (cq.position - b1).Magnitude
          local ct = (cr.position - b0).Magnitude + (cr.position - b1).Magnitude
          return cs < ct
        end)
        local cq, cr = 0, 0
        for cs, ct in ipairs(ch) do
          if cs == 1 or cs == #ch or cs % 2 == 0 then
            co(ct)
          end
          if #ci >= 42 then
            break
          end
        end
        local cs = aX(b1 - b0)
        local ct = cs.Magnitude > 0.1 and Vector3.new(-cs.Z, 0, cs.X).Unit or Vector3.new(0, 0, 1)
        local cu = 0
        for cv, cw in ipairs(ca) do
          local cx = cb(b0, b1, cw.position) < cw.radius + 35
          if not cx then
            for cy, cz in ipairs(ch) do
              if aY(cz, cw.position) < cw.radius + 24 then
                cx = true
                break
              end
            end
          end
          if cx then
            local cy = {cw.radius + 10}
            if m.detectionOnly and not cw.threat.stationary and not cw.threat.chasingUs then
              cy = {math.max(cw.radius + 5, cw.threat.instantRadius + 5), math.max(cw.radius + 10, cw.threat.visionRadius + 5)}
            end
            for cz, cA in ipairs(cy) do
              for cB = 0, 7 do
                local cC = cw.position + Vector3.new(math.cos(cB * math.pi / 4), 0, math.sin(cB * math.pi / 4)) * cA
                co(cC, cw.position.Y)
              end
            end
            cu += 1
            if cu >= 8 then
              break
            end
          end
        end
        for cv, cw in ipairs(cp) do
          if cw.kind == "stairs" and cq < 44 then
            co(cw.position)
            cq += 1
          elseif cw.kind == "corridor" and cr < 32 then
            co(cw.position)
            cr += 1
          end
        end
        for cv, cw in ipairs({0.25, 0.5, 0.75}) do
          for cx, cy in ipairs({-56, -28, 28, 56}) do
            local cz = b0:Lerp(b1, cw) + ct * cy
            co(cz, cz.Y)
          end
        end
        local cv = {[1] = 0}
        local cw, cx, cy = {}, {}, {}
        local cz = false
        local cA = 0
        local cB = os.clock()
        local cC = cB
        while os.clock() - cB < 0.4 and cA < 1200 do
          if b3 and not aZ(b3) then
            return nil, "cancelled"
          end
          if Z and not b2 then
            return nil, "twisted-detected"
          end
          local cD, cE
          for cF, cG in pairs(cv) do
            local cH = cG + (ci[cF] - b1).Magnitude
            if not cx[cF] and (not cE or cH < cE) then
              cD, cE = cF, cH
            end
          end
          if not cD then
            break
          end
          if cD == 2 then
            cz = true
            break
          end
          cx[cD] = true
          local cF = {}
          for cG, cH in ipairs(ci) do
            if cG ~= cD and not cx[cG] then
              local cI = (cH - ci[cD]).Magnitude
              if cG == 2 or cI <= 80 then
                table.insert(cF, {index = cG, distance = cI})
              end
            end
          end
          table.sort(cF, function(cG, cH)
            if cG.index == 2 or cH.index == 2 then
              return cG.index == 2 and cH.index ~= 2
            end
            return cG.distance < cH.distance
          end)
          for cG, cH in ipairs(cF) do
            if cG > 24 or cA >= 1200 or os.clock() - cB >= 0.4 then
              break
            end
            local cI = cH.index
            local cJ = cv[cD] + cH.distance
            if cv[cI] and cv[cI] <= cJ then
              continue
            end
            local cK = cv[cD] / math.max(1, H(nil, false))
            local cL = cD .. ":" .. cI .. ":" .. math.floor(cK * 1000)
            local cM = cy[cL]
            if cM == nil then
              cA += 1
              cM = cc(ci[cD], ci[cI], cK)
              cy[cL] = cM
            end
            if cM then
              cv[cI] = cJ
              cw[cI] = cD
            end
            if b3 and os.clock() - cC > 0.012 then
              p.Heartbeat:Wait()
              cC = os.clock()
            end
          end
        end
        q.stats.routeSearchChecks = cA
        q.stats.routeSearchNodes = #ci
        if cz then
          local cD = {}
          local cE = 2
          while cE do
            table.insert(cD, 1, ci[cE])
            cE = cw[cE]
          end
          q.stats.alternateRoutes = (q.stats.alternateRoutes or 0) + 1
          q.stats.routeWaypoints = #cD
          q.stats.routeReason = "alternate-supported-tween-route"
          return cD
        end
        q.stats.routeReason = "no-supported-alternate-route"
      end
      return nil, b2 and "escape-route-danger" or cf or "no-supported-tween-route"
    end
    function q.directRouteSafe(b0, b1)
      local b2, b3, b4 = a0()
      if not b4 then
        return false, "no-character"
      end
      local b5 = bL(b0, b0.Y)
      if not b5 then
        return false, "no-floor-at-target"
      end
      local b6, b7 = b_(b4.Position, b5, false, nil, m.room(), false, b1)
      return b6 ~= nil, b7
    end
    function q.canPlanFromClearGround(b0)
      local b1 = q.watch.routeWait
      if not b1 or b1.floor ~= m.room() or (b1.noCoverFailures or 0) < 1 then
        return false
      end
      if q.nativePursuer() or q.shouldHide(b0) or not q.travelLegClear(b0, b0, 0) then
        return false
      end
      if os.clock() - (b1.lastClearPlan or -math.huge) < 0.75 then
        return false
      end
      b1.lastClearPlan = os.clock()
      q.stats.clearGroundRoutePlans = (q.stats.clearGroundRoutePlans or 0) + 1
      return true
    end
    function q.routeBetween(b0, b1, b3)
      local b4 = bL(b0, b0.Y)
      local b5 = bL(b1, b1.Y)
      if not b4 or not b5 then
        return nil, "route-endpoint-has-no-floor"
      end
      return b_(b4, b5, false, nil, m.room(), false, b3)
    end
    function q.machineApproach(b0, b1, b3, b4)
      local b5, b6, b7 = a0()
      if not b7 or typeof(b1) ~= "Vector3" then
        return nil, "no-machine-prompt"
      end
      local b8 = math.max(0, (tonumber(b3) or 0) - 0.35)
      if b8 <= 0 then
        return b0
      end
      local function b9(ca)
        return not b4 or (ca - b4).Magnitude >= 1.5
      end
      if not w.active and not w.pending and (b7.Position - b1).Magnitude <= b8 and b9(b7.Position) and (not m.hazards or not m.hazards.dangerAt(b7.Position, 0.75)) then
        local ca = q.safeToMachine(b7.Position, 1, true, true)
        if ca then
          q.stats.machineApproach = "already-in-prompt-range"
          return b7.Position
        end
      end
      b0 = typeof(b0) == "Vector3" and b0 or b1
      local ca = bL(b0, b0.Y)
      if ca and b9(ca) and (ca - b1).Magnitude <= b8 and bQ(ca) and (not m.hazards or not m.hazards.dangerAt(ca, 0.75)) and q.safeToMachine(ca, 1, true, true) then
        q.stats.machineApproach = "dry-preferred-stand"
        return ca
      end
      local cb = {b0, b1}
      local cc = math.sqrt(math.max(0, b8 * b8 - 9))
      for cd, ce in ipairs({math.min(3, cc), math.min(5, cc), cc}) do
        for cf = 0, 7 do
          table.insert(cb, b1 + Vector3.new(math.cos(cf * math.pi / 4), 0, math.sin(cf * math.pi / 4)) * ce)
        end
      end
      local cd, ce, cf
      local cg = {unsupported = 0, outOfRange = 0, solid = 0, hazard = 0, threat = 0}
      for ch, ci in ipairs(cb) do
        local cj = typeof(ci) == "Vector3" and bL(ci, ci.Y)
        if not cj then
          cg.unsupported += 1
          continue
        end
        if not b9(cj) or (cj - b1).Magnitude > b8 then
          cg.outOfRange += 1
          continue
        end
        if not bQ(cj) then
          cg.solid += 1
          continue
        end
        local ck = m.hazards and m.hazards.dangerAt(cj, 0.75)
        if ck then
          cg.hazard += 1
          cf = cf or ck.reason or "ichor-puddle"
          continue
        end
        local cl, cm = q.safeToMachine(cj, 1, true, true)
        if not cl then
          cg.threat += 1
          cf = cm or cf
          continue
        end
        local cn = (cj - b7.Position).Magnitude + (cj - b0).Magnitude * 0.1
        if not ce or cn < ce then
          cd, ce = cj, cn
        end
      end
      q.stats.machineApproachFailures = cg
      if cd then
        q.stats.machineApproach = "dry-in-range"
        return cd
      end
      q.stats.machineApproach = "blocked"
      if cf then
        return nil, cf
      end
      return nil, cg.solid > 0 and "blocked-destination" or cg.unsupported > 0 and "no-floor-at-target" or "no-dry-machine-approach"
    end
    H = function(b0, b1)
      local b3 = math.clamp(tonumber(m.options and m.options.tweenSpeed) or r, 15, r)
      if b1 then
        b3 = math.clamp(tonumber(m.options.escapeTweenSpeed) or 30, 18, q.maxEscapeSpeed)
      end
      if ay() and q.chaseThreat() then
        b3 = math.clamp(tonumber(m.options.pickupChaseSpeed) or r, 15, r)
      end
      local b4, b6, b7 = a0()
      local b8, b9 = nil, 0
      if b1 and b7 then
        for ca, cb in ipairs(bb()) do
          local cc = math.abs(b7.Position.Y - cb.position.Y) <= 16 and aY(b7.Position, cb.position) <= math.max(80, cb.visionRadius + 20)
          if cc and not cb.stationary then
            local cd = bp(b7.Position, cb, 0.6)
            if cb.chasingUs or bo(cb) or cd >= 4 then
              local ce = math.max(cb.runSpeed, aX(cb.velocity).Magnitude)
              if ce > b9 then
                b8, b9 = cb, ce
              end
            end
          end
        end
        if b8 then
          b3 = math.max(b3, math.min(q.maxEscapeSpeed, b9 + math.max(6, b9 * 0.2)))
        end
      end
      local ca = m.room()
      if N ~= ca or O ~= b4 then
        F, N, O, Q, P = r, ca, b4, 0, -math.huge
        q.escapeSpeedCap = q.maxEscapeSpeed
      end
      G = b3
      if F and F < r and Q >= 3 and os.clock() - P >= 1 then
        F = r
        Q = 0
      end
      local cb = math.min(b3, b1 and q.escapeSpeedCap or F or b3)
      q.stats.speed, q.stats.requestedSpeed = cb, b3
      q.stats.escapeEnemy = b8 and b8.model.Name or nil
      q.stats.escapeEnemySpeed = b8 and b9 or nil
      q.stats.escapeSpeedLimited = b8 ~= nil and cb < b9 + math.max(3, b9 * 0.15)
      q.stats.speedReason = cb < b3 and "server-position-correction" or b8 and "adaptive-escape" or "requested-speed"
      return cb
    end
    local function b0(b1)
      if not b1 then
        q.stats.corrections += 1
      end
      local b3 = H(nil, ab)
      P, Q = os.clock(), 0
      local b4 = G or b3
      if ab then
        q.escapeSpeedCap = math.max(12, b3 * 0.75)
      else
        F = math.max(math.min(b4, 24), b4 * 0.9)
      end
      q.stats.speed = ab and q.escapeSpeedCap or F
      q.stats.speedReason = "server-position-correction"
    end
    local function b1(b3, b4, b6)
      local b7 = b4 - b3
      if b7.Magnitude < 0.01 then
        return (b6 - b3).Magnitude > 2.4, 0, 0
      end
      local b8 = aX(b7).Magnitude < 0.1
      local b9 = b8 and b7.Unit or aX(b7).Unit
      local ca = (b8 and (b6 - b3) or aX(b6 - b3)):Dot(b9)
      local cb = math.min(0.25, (b8 and b7.Magnitude or aX(b7).Magnitude) * 0.5)
      if b7.Magnitude <= 0.3 and (b6 - b4).Magnitude <= 0.3 then
        return false, ca, cb
      end
      return aY(b6, b4) > 2.4 or math.abs(b6.Y - b4.Y) > 4 or ca < cb, ca, cb
    end
    local function b3(b4, b6, b7, b8, b9, ca, cb)
      local cc = b6.Position
      v()
      local cd = H(b4, b8)
      if cd <= 0.1 then
        return false, "movement-disabled"
      end
      if b6.Anchored then
        return false, "root-anchored"
      end
      if not bO(b6.Position, b7, cb) then
        return false, "unsupported-tween-leg"
      end
      local ce, cf = aT(b6.Position, b7)
      if not ce then
        return false, cf
      end
      local cg, ch = bP(b6.Position)
      if cg then
        cg, ch = bP(b7)
      end
      if not cg then
        return false, ch
      end
      local ci = (b7 - b6.Position).Magnitude / cd
      local cj = CFrame.new(b7) * b6.CFrame.Rotation
      if not aZ(b9) then
        return false, "cancelled"
      end
      a4()
      local ck = q.makeTween(b6, TweenInfo.new(math.max(0.05, ci), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = cj})
      local function cl(cm)
        ck:Cancel()
        if D == ck then
          D = nil
        end
        if E == "tween" then
          E = nil
          q.stats.motionMode = nil
        end
        if cm == "server-correction" then
          b0()
          q.noteCorrectedLeg(cc, b7, b6.Position)
        end
        return false, cm
      end
      if not aZ(b9) then
        return cl("cancelled")
      end
      D = ck
      E = "tween"
      q.stats.motionMode = "tween"
      ab = b8 == true
      ck:Play()
      m.status(b8 and "Tweening directly toward cover" or q.stats.routeWaypoints and q.stats.routeWaypoints > 2 and "Tweening along an alternate route" or "Tweening to the target")
      local cm = os.clock() + ci + 0.5
      local cn = os.clock() + math.max(1.5, ci + 1)
      local co = 0
      while aZ(b9) and os.clock() < cm and os.clock() < cn do
        if ad and m.exitRequired and m.exitRequired() then
          return cl("exit-required")
        end
        if not b8 and au and au() then
          return cl("research-detected")
        end
        if Z and not b8 then
          return cl("danger")
        end
        if a_(b8) then
          return cl("health-loss")
        end
        if bZ(b8) then
          return cl("exit-required")
        end
        local cp, cq, cr = a0()
        if cp ~= b4 or cr ~= b6 then
          return cl("character-changed")
        end
        if ck.PlaybackState == Enum.PlaybackState.Cancelled then
          return cl(q.stats.groundBlock or "tween-cancelled")
        end
        if ck.PlaybackState == Enum.PlaybackState.Playing and os.clock() < co then
          p.Heartbeat:Wait()
          continue
        end
        co = os.clock() + 0.04
        q.enforceRibbonWalk()
        if m.room() ~= ca or not ca.Parent then
          return cl("floor-changed")
        end
        local cs = H(b4, b8)
        if not b8 and cs + 0.01 < cd then
          return cl("speed-changed")
        end
        if cr.Anchored then
          local ct = b8 and m.releaseExtraction and m.releaseExtraction("extraction-lock-relatched")
          if not ct or cr.Anchored then
            return cl("root-anchored")
          end
        end
        local ct, cu = bP(cr.Position)
        if not ct then
          return cl(cu)
        end
        if ck.PlaybackState == Enum.PlaybackState.Completed then
          if D == ck then
            D = nil
          end
          E = nil
          q.stats.motionMode = nil
          return true, "segment-completed"
        end
        local cv = cr.Position
        local cw = b7 - cv
        local cx = cv + cw * math.min(1, math.max(2, cd * 0.16) / math.max(cw.Magnitude, 0.01))
        local cy = bN(cx, cv.Y)
        if not cy then
          return cl("no-floor-on-route")
        end
        ct, cu = bP(cy)
        if not ct then
          return cl(cu)
        end
        if not bO(cv, cy, cb) then
          return cl("unsupported-tween-leg")
        end
        ce, cf = aT(cv, cy)
        if not ce then
          return cl(cf)
        end
        if not bQ(cy) or not bY(cv, cy) then
          return cl("route-blocked")
        end
        local cz, cA = q.threatAt(cv)
        if cz and cA and cA.reason == "untracked-threat" then
          return cl("untracked-threat")
        end
        if ad then
          local cB, cC = ad(cv, cy)
          if not cB then
            return cl(cC or "distraction-route-changed")
          end
        elseif b8 and ae then
          if not ai(cv, cy, false) then
            return cl("cover-hop-exposed")
          end
        elseif b8 then
          if not bW(cv, cy) then
            return cl("escape-blocked")
          end
        else
          local cB = q.chaseThreat()
          if cB and not ay() then
            return cl("twisted-chasing")
          end
          if cz or q.threatAt(cy) then
            if not bX(cv, cy) then
              return cl("danger")
            end
          end
        end
        if ck.PlaybackState == Enum.PlaybackState.Cancelled then
          return cl(q.stats.groundBlock or "tween-cancelled")
        end
        if b8 and (cs > cd + 1 or cs + 0.01 < cd) then
          ck:Cancel()
          cd = cs
          ci = (b7 - cr.Position).Magnitude / cd
          ck = q.makeTween(cr, TweenInfo.new(math.max(0.05, ci), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = cj})
          D = ck
          ck:Play()
          cm = os.clock() + ci + 0.5
        end
        p.Heartbeat:Wait()
      end
      return cl(aZ(b9) and "tween-timeout" or "cancelled")
    end
    local function b4(b6, b7, b8, b9)
      I = not b8
      q.stats.travelActive = I
      local ca, cb, cc = a0()
      local cd = m.room()
      if not aZ(b9) then
        return false, "cancelled"
      end
      if a_(b8) then
        return false, "health-loss"
      end
      if bZ(b8) then
        return false, "exit-required"
      end
      if not ca or not cd then
        return false, "no-character-or-floor"
      end
      if typeof(b6) ~= "Vector3" then
        return false, "invalid-position"
      end
      m.status("Preparing a supported route")
      if not (y and b8) then
        b6 = bL(b6, b6.Y)
      else
        b6 = bN(b6, cc.Position.Y)
      end
      if not b6 then
        return false, "no-floor-at-target"
      end
      b7 = math.clamp(tonumber(b7) or 3, 0.6, 12)
      local ce = cc.Position
      local cf = b8 and aY(ce, b6) <= 12.1 and bW(ce, b6)
      local cg, ch = q.threatAt(b6)
      if cg and (not cf or not ch or ch.reason == "untracked-threat") then
        return false, ch and ch.reason == "untracked-threat" and "untracked-threat" or "unsafe-target"
      end
      if not bQ(b6) then
        return false, "blocked-destination"
      end
      local ci, cj = b_(cc.Position, b6, b8, b9, cd)
      if not ci then
        return false, cj
      end
      q.stats.routeWaypoints = #ci
      local ck, cl, cm, cn = 2, 0, 0, 0
      local function co(cp)
        if b8 or as or Z or cn >= 3 or a_(false) or bZ(false) then
          return false
        end
        if q.chaseThreat() and not ay() then
          return false
        end
        local cq, cr, cs = a0()
        if not cs or m.room() ~= cd or not aZ(b9) then
          return false
        end
        local ct = b_(cs.Position, b6, false, b9, cd)
        if not ct then
          return false
        end
        ci, ck, cn = ct, 2, cn + 1
        q.stats.routeReplans = (q.stats.routeReplans or 0) + 1
        q.stats.replanReason = cp
        return true
      end
      local cp = os.clock() + 65
      m.status(b8 and "Preparing a supported cover route" or "Preparing a supported generator route")
      while aZ(b9) and os.clock() < cp and cm < 450 do
        if not b8 and au and au() then
          return false, "research-detected"
        end
        if a_(b8) then
          return false, "health-loss"
        end
        if bZ(b8) then
          return false, "exit-required"
        end
        local cr, cs, ct = a0()
        if cr ~= ca or not ct then
          return false, "character-changed"
        end
        if m.room() ~= cd or not cd.Parent then
          return false, "floor-changed"
        end
        local cu = ct.Position
        if aY(cu, b6) <= b7 and math.abs(cu.Y - b6.Y) < 0.8 then
          if not b8 then
            p.Heartbeat:Wait()
          end
          if not aZ(b9) then
            return false, "cancelled"
          end
          if a_(b8) then
            return false, "health-loss"
          end
          if bZ(b8) then
            return false, "exit-required"
          end
          local cv, cw, cx = a0()
          if cv ~= ca or not cx then
            return false, "character-changed"
          end
          if m.room() ~= cd then
            return false, "floor-changed"
          end
          if aY(cx.Position, b6) <= b7 and math.abs(cx.Position.Y - b6.Y) < 0.8 then
            if q.threatAt(cx.Position) then
              if cf and bW(ce, cx.Position) then
                return true, "retreated"
              end
              return false, "danger-after-teleport"
            end
            return true, "arrived"
          end
          cl += 1
          b0()
          if cl >= 3 or aY(cx.Position, cu) > 12 then
            return false, "server-correction"
          end
          ck = math.max(2, #ci)
          ct, cu = cx, cx.Position
        end
        while ci[ck] and (cu - ci[ck]).Magnitude <= 1.8 and math.abs(cu.Y - ci[ck].Y) < 0.8 and ck < #ci do
          ck += 1
        end
        local cv = ci[ck] or b6
        local cw = cv - cu
        local cx = aX(cw).Magnitude
        if cw.Magnitude < 0.1 then
          return false, "route-stalled"
        end
        local cy = b8 and 8 or 12
        local cz = math.min(1, cy / math.max(cw.Magnitude, 0.1))
        local cA = cu + cw * cz
        local cB = bN(cA, cv.Y)
        if not cB then
          cB = bL(Vector3.new(cA.X, cu.Y, cA.Z), cu.Y)
        end
        if not cB then
          return false, "no-floor-on-route"
        end
        if (cB - cu).Magnitude > cy then
          if not m.strictGround and cB.Y - cu.Y > 1 then
            cB = cu + aL * math.min(cy, cB.Y - cu.Y)
          elseif not m.strictGround and cu.Y - cB.Y > 1 and aX(cA - cu).Magnitude > 0.1 then
            cB = Vector3.new(cA.X, cu.Y, cA.Z)
          else
            cB = cu + (cB - cu).Unit * cy
          end
        end
        local cC = math.max(cu.Y, cv.Y)
        if not bO(cu, cB, cC) then
          if co("unsupported-tween-leg") then
            continue
          end
          return false, "unsupported-tween-leg"
        end
        if not bY(cu, cB) or not bQ(cB) then
          if co("route-blocked") then
            continue
          end
          return false, "route-blocked"
        end
        local cD, cE = q.threatAt(cu)
        if cD and cE and cE.reason == "untracked-threat" then
          return false, "untracked-threat"
        end
        if b8 then
          if not bW(cu, cB) then
            return false, "escape-blocked"
          end
        elseif (cD or q.threatAt(cB)) and not bX(cu, cB) then
          if co("twisted-moved") then
            continue
          end
          return false, "danger"
        end
        if not aZ(b9) then
          return false, "cancelled"
        end
        if bZ(b8) then
          return false, "exit-required"
        end
        local cF, cG = b3(ca, ct, cB, b8, b9, cd, cC)
        if not cF then
          if (cG == "danger" or cG == "route-blocked" or cG == "unsupported-tween-leg" or cG == "ichor-puddle" or cG == "sprout-tendril" or cG == "blott-hand") and co(cG) then
            continue
          end
          return false, cG
        end
        cm += 1
        q.stats.segments += 1
        p.Heartbeat:Wait()
        if not aZ(b9) then
          return false, "cancelled"
        end
        if bZ(b8) then
          return false, "exit-required"
        end
        local cH, cI, cJ = a0()
        if cH ~= ca or not cJ then
          return false, "character-changed"
        end
        if m.room() ~= cd then
          return false, "floor-changed"
        end
        local cK = cJ.Position
        local cL, cM, cN = b1(cu, cB, cK)
        if cL then
          q.stats.lastCorrectionDetail = {from = tostring(cu), expected = tostring(cB), actual = tostring(cK),
            actualProgress = cM, minimumProgress = cN}
          cl += 1
          b0()
          q.noteCorrectedLeg(cu, cB, cK)
          if co("server-correction") then
            continue
          end
          if cl >= 3 or aY(cK, cu) > 12 then
            return false, "server-correction"
          end
        else
          Q += 1
        end
      end
      return false, aZ(b9) and "movement-timeout" or "cancelled"
    end
    local function b6(b7)
      if m.options.fullBodyHiding and q.geometryByPart and q.geometryByPart[b7] then
        return q.geometry.allowed(q.geometryByPart[b7].object)
      end
      if m.options.wallCenterHiding then
        return b7 and b7.Parent and b7:IsA("BasePart") and b7.CanCollide and b7.CanQuery ~= false
      end
      return b7 and os.clock() >= (q.watch.rejectedWalls[b7] or 0) and b7.Parent and b7:IsA("Part") and b7.Shape == Enum.PartType.Block and b7.CanCollide and b7.CanQuery ~= false and not aQ(b7) and not b7:FindFirstChildWhichIsA("SpecialMesh")
    end
    local function b7()
      local b8, b9, ca = a0()
      local cb = math.max(ca and ca.Size.X * 0.5 or 1, ca and ca.Size.Z * 0.5 or 1)
      local cc, cd = cb + 0.4, false
      for ce, cf in ipairs(bb()) do
        if not cf.stationary then
          cd = true
          local cg = cf.lethal and math.min(5, math.max(0, tonumber(m.options.lethalMargin) or 25) * 0.2) or 0
          cc = math.max(cc, cf.killRadius + 0.5 + math.max(0, tonumber(m.options.safetyMargin) or 0) + cg)
        end
      end
      if not cd then
        cc = math.max(cc, 6)
      end
      return cc, math.max(2.5, ca and ca.Size.Y * 0.5 + 1.5 or 2.5)
    end
    local b9, ca, cb, cc, cd = nil, nil, -math.huge, nil, nil
    local ce, cf = {}, {}
    local cg, ch, ci = nil, -math.huge, {}
    local function cj()
      local ck, cl, cm = a0()
      if not cm then
        return nil
      end
      if ck == b9 and cm == ca and os.clock() - cb < 0.2 then
        return cm, cc, cd
      end
      local cn = cm.Size * 0.5
      local co, cp = -cn, cn
      local cr = {cm.CFrame.RightVector, cm.CFrame.UpVector, cm.CFrame.LookVector}
      local ct = 0
      ce, cf = {}, {}
      for cu, cv in ipairs({-1, 1}) do
        for cw, cx in ipairs({-1, 1}) do
          for cy, cz in ipairs({-1, 1}) do
            table.insert(ce, Vector3.new(cn.X * cv, cn.Y * cx, cn.Z * cz))
          end
        end
      end
      if cg ~= ck or os.clock() - ch >= 1 then
        cg, ch, ci = ck, os.clock(), {}
        for cu, cv in ipairs(ck:GetDescendants()) do
          if cv:IsA("Motor6D") then
            if cv.Part0 then
              ci[cv.Part0] = true
            end
            if cv.Part1 then
              ci[cv.Part1] = true
            end
          end
        end
      end
      for cu, cv in ipairs(ck:GetChildren()) do
        local cw = cv.Name:lower():gsub("[%s_]", "")
        local cx = cw == "head" or cw == "torso" or cw == "uppertorso" or cw == "lowertorso" or cw:match("^left.*arm$") or cw:match("^right.*arm$") or cw:match("^left.*leg$") or cw:match("^right.*leg$") or cw == "lefthand" or cw == "righthand" or cw == "leftfoot" or cw == "rightfoot"
        if cv:IsA("BasePart") and cv ~= cm and cv.Name ~= "RootPart" and cv.Name ~= "HumanoidRootPart" and (cv.Transparency or 0) < 0.95 then
          local cy = cm.CFrame:PointToObjectSpace(cv.Position)
          local cz = cv.Size * 0.5
          local cA = {}
          for cB = 1, 3 do
            cA[cB] = math.abs(cv.CFrame.RightVector:Dot(cr[cB])) * cz.X + math.abs(cv.CFrame.UpVector:Dot(cr[cB])) * cz.Y + math.abs(cv.CFrame.LookVector:Dot(cr[cB])) * cz.Z
          end
          local cB = Vector3.new(cA[1], cA[2], cA[3])
          local cC, cD = cy - cB, cy + cB
          co = Vector3.new(math.min(co.X, cC.X), math.min(co.Y, cC.Y), math.min(co.Z, cC.Z))
          cp = Vector3.new(math.max(cp.X, cD.X), math.max(cp.Y, cD.Y), math.max(cp.Z, cD.Z))
          for cE, cF in ipairs({-1, 1}) do
            for cG, cH in ipairs({-1, 1}) do
              for cI, cJ in ipairs({-1, 1}) do
                local cK = cv.CFrame:PointToWorldSpace(Vector3.new(cz.X * cF, cz.Y * cH, cz.Z * cJ))
                table.insert(ce, cm.CFrame:PointToObjectSpace(cK))
              end
            end
          end
          ct += 1
        end
      end
      if q.standingProfile and q.standingProfile.skeleton then
        for cu, cv in ipairs(q.groundSolePoints or {}) do
          co = Vector3.new(math.min(co.X, cv.X), math.min(co.Y, cv.Y), math.min(co.Z, cv.Z))
          cp = Vector3.new(math.max(cp.X, cv.X), math.max(cp.Y, cv.Y), math.max(cp.Z, cv.Z))
          ce[#ce + 1] = cv
        end
      end
      if ct == 0 or cp.Y - co.Y < 5 then
        co = Vector3.new(co.X, math.min(co.Y, -2.5), co.Z)
        cp = Vector3.new(cp.X, math.max(cp.Y, 2.5), cp.Z)
        for cu, cv in ipairs({-1, 1}) do
          for cw, cx in ipairs({-1, 1}) do
            for cy, cz in ipairs({-1, 1}) do
              table.insert(ce, Vector3.new(cn.X * cv, 2.5 * cx, cn.Z * cz))
            end
          end
        end
      end
      local cu = Vector3.new(0.35, 0.25, 0.35)
      b9, ca, cb = ck, cm, os.clock()
      cc, cd = co - cu, cp + cu
      q.stats.coverBodySize = tostring(cd - cc)
      return cm, cc, cd
    end
    local function ck(cl)
      local cm, cn, co = cj()
      if not cm then
        return nil
      end
      local cp = b7()
      local cr = cm.CFrame
      local ct = {cl.CFrame.RightVector, cl.CFrame.UpVector, cl.CFrame.LookVector}
      local cu = {cl.Size.X * 0.5, cl.Size.Y * 0.5, cl.Size.Z * 0.5}
      local cv, cw, cx = {}, {}, {}
      for cy = 1, 3 do
        local cz = ct[cy]
        if cy == 3 then
          cz = -cz
        end
        local cA = Vector3.new(cr.RightVector:Dot(cz), cr.UpVector:Dot(cz), -cr.LookVector:Dot(cz))
        local cB = string.format("%.6f,%.6f,%.6f", cA.X, cA.Y, cA.Z)
        local cC = cf[cB]
        if not cC then
          local cD, cE = math.huge, -math.huge
          for cF, cG in ipairs(ce) do
            local cH = cG:Dot(cA)
            cD = math.min(cD, cH)
            cE = math.max(cE, cH)
          end
          cC = {cD - 0.35, cE + 0.35}
          cf[cB] = cC
        end
        cv[cy], cw[cy] = -cu[cy] - cC[1], cu[cy] - cC[2]
        if math.abs(cz.Y) <= 0.7 then
          cv[cy] = math.max(cv[cy], -cu[cy] + cp)
          cw[cy] = math.min(cw[cy], cu[cy] - cp)
          table.insert(cx, cy)
        end
        if cv[cy] > cw[cy] then
          return nil
        end
      end
      return cv, cw, cx
    end
    local function cl(cm, cn)
      if m.options.fullBodyHiding and q.geometryByPart and q.geometryByPart[cm] then
        local co = cm == w.part and w.geometry or q.geometryByPart[cm]
        local cp, cr, ct = a0()
        local cu = ct and (ct.Position - cn).Magnitude < 0.05 and ct.CFrame or CFrame.new(cn) * co.cframe.Rotation
        return q.geometry.contains(co, cu)
      end
      if not b6(cm) then
        return false
      end
      if m.options.wallCenterHiding then
        local co = cm.CFrame:PointToObjectSpace(cn)
        local cr = cm.Size * 0.5
        return math.abs(co.X) <= cr.X + 0.05 and math.abs(co.Y) <= cr.Y + 0.05 and math.abs(co.Z) <= cr.Z + 0.05
      end
      local co, cr = ck(cm)
      if not co then
        return false
      end
      local ct = cm.CFrame:PointToObjectSpace(cn)
      local cu = {ct.X, ct.Y, ct.Z}
      for cv = 1, 3 do
        if cu[cv] < co[cv] - 0.05 or cu[cv] > cr[cv] + 0.05 then
          return false
        end
      end
      return true
    end
    local function cm(cn)
      local co = cn.lethal and math.min(5, math.max(0, tonumber(m.options.lethalMargin) or 25) * 0.2) or 0
      return cn.killRadius + 1.25 + math.max(0, tonumber(m.options.safetyMargin) or 0) + co
    end
    local function cn(co, cr, ct)
      local cu = aX(cr.velocity)
      if cu.Magnitude < 0.1 then
        return ct
      end
      local cv = n:Raycast(cr.position, cu * ct, a9(false))
      if not cv or cv.Instance ~= co and (not cv.Instance.CanCollide or cv.Normal and math.abs(cv.Normal.Y) > 0.6) then
        return ct
      end
      local cw = cr.model and a8(cr.model)
      local cx = cw and math.clamp(math.min(cw.Size.X, cw.Size.Z) * 0.5, 0.5, 1) or 0.5
      local cy = math.max(0, aY(cr.position, cv.Position) - cx)
      return math.min(ct, cy / cu.Magnitude)
    end
    local function co(cr, ct, cu, cv, cw)
      if cw == nil then
        cw = bd(cu, cr)
      end
      if not cw or not cl(ct, cr) then
        return bc(cr, cu, cv)
      end
      return bc(cr, cu, cn(ct, cu, cv))
    end
    function q.patrolLegClear(cr, ct, cu, cv, cw)
      local cx = aX(cu - ct)
      local cy = cx.Magnitude
      local cz = cy > 0.01 and math.clamp(aX(cr.position - ct):Dot(cx) / (cy * cy), 0, 1) or 0
      local cA = math.max(cr.visionRadius, cr.instantRadius, cr.killRadius) + 3 + aX(cr.velocity).Magnitude * 0.75
      if aY(ct + cx * cz, cr.position) > cA then
        return true
      end
      local cB = math.clamp(math.ceil(cy / 3), 1, 80)
      local cC = aY(ct, cr.position)
      local cD = aY(cu, cr.position) > cC + 0.2
      for cE = 0, cB do
        local cF = cE / cB
        local cG = ct:Lerp(cu, cF)
        local cH = cr.position + cr.velocity * math.clamp((cv or 0) + cw * cF, 0, 0.75)
        local cI = aX(cG - cH)
        local cJ = cI.Magnitude
        local cK = math.max(cr.killRadius + 2, cr.instantRadius + 2)
        if cI.Magnitude > 0.1 and cr.forward.Magnitude > 0.1 and cr.forward.Unit:Dot(cI.Unit) > 0.2 then
          cK = math.max(cK, cr.visionRadius + 2)
        end
        if cJ > cK or bd(cr, cG, cH) then
          continue
        end
        if cD and cJ >= cC - 0.05 then
          continue
        end
        q.stats.travelBlocker = cr.model and cr.model.Name
        q.stats.travelClearance, q.stats.travelMargin = cJ, cK
        return false
      end
      return true
    end
    function q.travelLegClear(cr, ct, cu, cv)
      local cw = math.max(0.01, (ct - cr).Magnitude / math.max(1, H(nil, false)))
      local cx = aX(ct - cr) / cw
      local function cy(cz, cA, cB)
        local cC = cA:Dot(cA)
        local cD = cC > 0.01 and math.clamp(-cz:Dot(cA) / cC, 0, cB) or 0
        return (cz + cA * cD).Magnitude
      end
      for cz, cA in ipairs(bb()) do
        if math.abs(cA.position.Y - cr.Y) > 16 and math.abs(cA.position.Y - ct.Y) > 16 then
          continue
        end
        local cB = cu or 0
        local cC = cn(nil, cA, cB + cw)
        local cD = cA.position + cA.velocity * math.min(cB, cC)
        local cE = math.clamp(cC - cB, 0, cw)
        local cF = aX(cr - cD)
        local cG = cx - aX(cA.velocity)
        local cH = cy(cF, cG, cE)
        local cI = cF + cG * cE
        cH = math.min(cH, cy(cI, cx, cw - cE))
        local cJ = (cI + cx * (cw - cE)).Magnitude
        local cK = bk(cA)
        if cv and not cA.stationary then
          cK = math.max(cK, cA.killRadius + 14, 20 + aM(cA))
        end
        local cL = cH >= cK
        if cF.Magnitude < cK then
          cL = cH >= cF.Magnitude - 0.05 and cJ > cF.Magnitude + 0.1
        end
        if not cL then
          q.stats.travelBlocker = cA.model and cA.model.Name
          q.stats.travelClearance = cH
          q.stats.travelMargin = cK
          return false
        end
        if m.detectionOnly and not cA.stationary and not cA.chasingUs and not cA.grabbing and not q.patrolLegClear(cA, cr, ct, cu, cw) then
          return false
        end
      end
      return aG == nil
    end
    ah = function(cr, ct, cu, cv)
      local cw = cv and cv.part or w.part
      local cx = cv and cv.position or w.position
      local cy = cv and cv.kind == "occluded-wall" or not cv and w.kind == "occluded-wall"
      if cu.stationary or not cv and (not w.pending or not y or w.leaving or w.floor ~= m.room()) or not cw or not cx or not cy and not cl(cw, cx) then
        return nil
      end
      if cy and not q.wallShelterClear(cw, cx, cv and cv.cframe or w.cframe, cu) then
        return false
      end
      if cu.ranged and not bd(cu, cx) then
        return nil
      end
      if cu.ranged and bd(cu, cr) and not bd(cu, ct) then
        return false
      end
      local cz = cv and cv.entryOrigin or w.entry
      if cz and aY(ct, cz) > s + 0.1 then
        return false
      end
      local cA, cB = a2()
      local cC = q.watch.routeWait and math.max(ap, (cB or 0) + 20) or ap
      if cA and aY(ct, cA) > cC + 0.1 then
        return false
      end
      local cD = (ct - cr).Magnitude / math.max(0.1, H(nil, true))
      if cD < 0.00001 then
        return true
      end
      local cE = aX(ct - cr) / cD
      local cF = aX(cu.velocity)
      local cG = cn(cw, cu, cD)
      local cH = aX(cr - cu.position)
      local function cI(cJ, cK, cL)
        local cM = cK:Dot(cK)
        local cN = cM > 0.00001 and math.clamp(-cJ:Dot(cK) / cM, 0, cL) or 0
        return (cJ + cK * cN).Magnitude
      end
      local cJ = cE - cF
      local cK = cI(cH, cJ, cG)
      local cL = cH + cJ * cG
      cK = math.min(cK, cI(cL, cE, cD - cG))
      local cM = (cL + cE * (cD - cG)).Magnitude
      local cN = cH.Magnitude
      local cO = cv and cu.killRadius + (cu.lethal and 4 or 1.5) or cm(cu)
      local cP = cK >= cO
      if cN < cO then
        cP = cK >= cN - 0.05 and cM >= cN - 0.01 and aY(ct, cu.position) > cN + 0.1
      end
      q.stats.coverEntryClosest = cK
      if not cP then
        q.stats.retreatBlocker = cu.model and cu.model.Name
        q.stats.retreatClosest = cK
      end
      return cP, cK
    end
    function q.coverLegClear(cr, ct, cu, cv)
      if cu.searchCheckpoint and not cu.searchCheckpoint() then
        return false
      end
      if not bO(cr, ct, nil, nil, cu.searchCheckpoint) then
        return false
      end
      if m.hazards and not m.hazards.segmentClear(cr, ct) then
        return false
      end
      local cw = math.huge
      local cx = math.max(0.01, (ct - cr).Magnitude / math.max(1, H(nil, true)))
      for cy, cz in ipairs(bb()) do
        if cu.searchCheckpoint and not cu.searchCheckpoint() then
          return false
        end
        if math.abs(cz.position.Y - cr.Y) > 16 and math.abs(cz.position.Y - ct.Y) > 16 then
          continue
        end
        local cA = cz
        if (cv or 0) > 0 then
          cA = table.clone(cz)
          local cB = cn(cu.part, cz, cv)
          cA.position = cz.position + cz.velocity * cB
          if cB < cv then
            cA.velocity = aK
          end
        end
        local cB, cC = ah(cr, ct, cA, cu)
        if cB == nil then
          local cD = aX(cr - cA.position)
          local cE = aX(ct - cr) / cx - aX(cA.velocity)
          local cF = cE:Dot(cE)
          local cG = cF > 0.01 and math.clamp(-cD:Dot(cE) / cF, 0, cx) or 0
          cC = (cD + cE * cG).Magnitude
          local cH = cA.killRadius + (cA.lethal and 4 or 1.5)
          cB = cC >= cH or cD.Magnitude < cH and cC >= cD.Magnitude - 0.05 and aY(ct, cA.position) > cD.Magnitude + 0.1
        end
        if cB == false then
          return false
        end
        cw = math.min(cw, cC or math.huge)
      end
      if aG then
        return false
      end
      return true, cw
    end
    function q.coverRouteClear(cr, ct)
      local cu, cv = 0, math.huge
      for cw = 2, #cr do
        local cx, cy = q.coverLegClear(cr[cw - 1], cr[cw], ct, cu)
        if not cx then
          return false
        end
        cv = math.min(cv, cy)
        cu += (cr[cw] - cr[cw - 1]).Magnitude / math.max(1, H(nil, true))
      end
      return true, cv
    end
    function q.planCoverApproach(cr, ct)
      if ct.searchCheckpoint and not ct.searchCheckpoint() then
        return nil
      end
      if q.geometry and ct.kind ~= "occluded-wall" then
        q.geometryByPart = q.geometryByPart or {}
        q.geometryByPart[ct.part] = ct
      end
      ct.partialApproach = false
      ct.entryOrigin = ct.entryOrigin or cr
      if ct.approachRemaining and #ct.approachRemaining > 1 then
        local cu = {cr}
        for cv, cw in ipairs(ct.approachRemaining) do
          if aY(cr, cw) > 1 then
            cu[#cu + 1] = cw
          end
        end
        local cv, cw = q.coverRouteClear(cu, ct)
        if cv and #cu > 1 then
          return cu, cw
        end
      end
      local cu, cv = q.coverLegClear(cr, ct.position, ct)
      local cw = aX(ct.position - cr)
      if cw.Magnitude < 0.1 then
        return cu and {cr, ct.position} or nil
      end
      if ct.approachWaypoint and aY(cr, ct.approachWaypoint) > 1 then
        local cx = ct.approachWaypoint
        local cy, cz = q.coverLegClear(cr, cx, ct)
        local cA = (cx - cr).Magnitude / math.max(1, H(nil, true))
        local cB, cC = q.coverLegClear(cx, ct.position, ct, cA)
        if cy and cB then
          return {cr, cx, ct.position}, math.min(cz, cC)
        end
      end
      if cu then
        ct.approachWaypoint = nil
        ct.approachRemaining = nil
        return {cr, ct.position}, cv
      end
      if m.hazards and m.hazards.detours then
        for cx, cy in ipairs(m.hazards.detours(cr, ct.position)) do
          local cz, cA = bL(cy[1], cr.Y), bL(cy[2], cr.Y)
          if cz and cA and aY(cr, cz) <= s and aY(cr, cA) <= s then
            local cB = {cr, cz, cA, ct.position}
            local cC, cD = q.coverRouteClear(cB, ct)
            if cC and bO(cr, cz) and bO(cz, cA) then
              ct.approachRemaining = {cz, cA, ct.position}
              return cB, cD
            end
          end
        end
      end
      local cx = cw.Unit
      local cy = Vector3.new(-cx.Z, 0, cx.X)
      local cz, cA, cB
      for cC, cD in ipairs({-math.pi / 3, math.pi / 3, -math.pi / 2, math.pi / 2}) do
        if ct.searchCheckpoint and not ct.searchCheckpoint() then
          return nil
        end
        local cE = cr + (cx * math.cos(cD) + cy * math.sin(cD)) * math.min(6, cw.Magnitude * 0.5)
        local cF = bL(cE, cr.Y)
        if not cF or bq(cF) or not bO(cr, cF) then
          continue
        end
        local cG = false
        for cH, cI in ipairs(q.watch.hideTrail or {}) do
          if aY(cI, cF) < 2.5 and aY(cr, cI) > 2 then
            cG = true
            break
          end
        end
        if cG then
          continue
        end
        local cH, cI = q.coverLegClear(cr, cF, ct)
        local cJ = (cF - cr).Magnitude / math.max(1, H(nil, true))
        local cK, cL = q.coverLegClear(cF, ct.position, ct, cJ)
        if cH and cK then
          local cM = math.min(cI, cL)
          local cN = (cF - cr).Magnitude + (ct.position - cF).Magnitude + 12 / math.max(0.5, cM)
          if not cA or cN < cA then
            cz, cA, cB = cF, cN, cM
          end
        end
      end
      if not cz then
        local cC, cD, cE
        for cF, cG in ipairs({6, 10}) do
          for cH, cI in ipairs({-1, 1}) do
            for cJ, cK in ipairs({0, cG}) do
              if ct.searchCheckpoint and not ct.searchCheckpoint() then
                return nil
              end
              local cL = bL(cr + cy * (cG * cI) - cx * cK, cr.Y)
              local cM = bL(ct.position + cy * (cG * cI), cr.Y)
              if not cL or not cM or bq(cL) or bq(cM) or not bO(cr, cL) or not bO(cL, cM) then
                continue
              end
              local cN = {cr, cL, cM, ct.position}
              local cO, cP = q.coverRouteClear(cN, ct)
              if cO then
                local cQ = (cL - cr).Magnitude + (cM - cL).Magnitude + (ct.position - cM).Magnitude
                local cR = cQ + 12 / math.max(0.5, cP)
                if cQ <= s + 20 and (not cD or cR < cD) then
                  cC, cD, cE = cN, cR, cP
                end
              end
            end
          end
        end
        if cC then
          ct.approachRemaining = {cC[2], cC[3], cC[4]}
          return cC, cE
        end
        if ct.allowPartialApproach then
          local cF, cG, cH
          for cI, cJ in ipairs({0, -math.pi / 6, math.pi / 6, -math.pi / 3, math.pi / 3}) do
            local cK = cr + (cx * math.cos(cJ) + cy * math.sin(cJ)) * math.min(5, cw.Magnitude)
            local cL = bL(cK, cr.Y)
            local cM = cL and cw.Magnitude - aY(cL, ct.position) or -math.huge
            local cN = false
            if cL then
              for cO, cP in ipairs(q.watch.hideTrail or {}) do
                if aY(cP, cL) < 1.5 then
                  cN = true
                  break
                end
              end
            end
            if cL and not cN and cM > 0.75 and not bq(cL) and bO(cr, cL) then
              local cO, cP = q.coverLegClear(cr, cL, ct)
              if cO and (not cG or cM > cG) then
                cF, cG, cH = cL, cM, cP
              end
            end
          end
          if cF then
            ct.partialApproach = true
            ct.approachRemaining = nil
            ct.approachWaypoint = nil
            return {cr, cF}, cH
          end
        end
        return nil
      end
      ct.approachWaypoint = cz
      ct.approachRemaining = {cz, ct.position}
      return {cr, cz, ct.position}, cB
    end
    ag = function(cr, ct, cu)
      if w.kind == "occluded-wall" and not w.leaving and (w.active or w.pending) and q.wallShelterClear(w.part, ct, w.cframe, cr) then
        return bc(ct, cr, cn(w.part, cr, math.clamp(cu or 0.6, 0, 2))), cr.killRadius + 1.5 + (cr.lethal and 4 or 0)
      end
      if cr.stationary or w.leaving or not w.active and not w.pending or not cl(w.part, ct) or not bd(cr, ct) then
        return nil
      end
      return co(ct, w.part, cr, math.clamp(cu or 0.6, 0, 2), true), cm(cr)
    end
    function q.wallShelterClear(cr, ct, cu, cv, cw)
      if not cr or not cr.Parent or not cr.CanCollide or bq(ct) then
        return false, "shelter-unavailable"
      end
      local cx, cy, cz = cj()
      if not cx then
        return false, "no-character"
      end
      cu = CFrame.new(ct) * (cu and cu.Rotation or cx.CFrame.Rotation)
      local cA = cv and {cv} or bb()
      if aG then
        return false, "untracked-threat"
      end
      for cB, cC in ipairs(cA) do
        if math.abs(cC.position.Y - ct.Y) > 16 then
          continue
        end
        local cD = cC.killRadius + (cC.stationary and 6 or 1.5) + (cC.lethal and 4 or 0)
        local cE = bc(ct, cC, cn(cr, cC, 0.65))
        if cE <= cD and not cw then
          return false, "twisted-contact"
        end
        if cC.stationary and not cC.ranged then
          continue
        end
        if aY(ct, cC.position) > cC.visionRadius + 10 and not cC.chasingUs and not bo(cC) and not cC.grabbing then
          continue
        end
        if ba(cC.position + aL, ct + aL) then
          return false, "twisted-visible"
        end
        for cF, cG in ipairs({cy.X, cz.X}) do
          for cH, cI in ipairs({cy.Y, cz.Y}) do
            for cJ, cK in ipairs({cy.Z, cz.Z}) do
              if ba(cC.position + aL, cu:PointToWorldSpace(Vector3.new(cG, cI, cK))) then
                return false, "body-visible"
              end
            end
          end
        end
        if cC.ranged and not bd(cC, ct) then
          return false, "ranged-line-of-sight"
        end
      end
      return true
    end
    local function cr(ct)
      if w.kind == "occluded-wall" then
        return w.part and w.part.Parent and w.floor == m.room() and w.position and aY(ct, w.position) < 2 and math.abs(ct.Y - w.position.Y) < 1
      end
      if m.options.fullBodyHiding and w.geometry and q.geometry then
        return cl(w.part, ct)
      end
      if w.kind ~= "wall" then
        return false
      end
      local cu = w.part
      if not cu or not cu.Parent or not cu:IsA("BasePart") then
        return false
      end
      local cv = cu.CFrame:PointToObjectSpace(ct)
      return math.abs(cv.X) < cu.Size.X * 0.5 and math.abs(cv.Z) < cu.Size.Z * 0.5 and math.abs(cv.Y) < cu.Size.Y * 0.5
    end
    function q.isHidden()
      local ct, cu, cv = m.character()
      if m.options.prioritizeSafety and w.geometry and w.geometry.fitMode == "feet-and-root" then
        return false
      end
      if w.kind == "occluded-wall" then
        return w.active == true and not w.leaving and cv ~= nil and cr(cv.Position) and q.wallShelterClear(w.part, cv.Position, cv.CFrame, nil, not q.coverDamaged())
      end
      return w.active == true and not w.leaving and cv ~= nil and w.floor == m.room() and w.kind == "wall" and cl(w.part, cv.Position)
    end
    function q.canWorkFromCover(cu)
      if w.kind == "occluded-wall" then
        return false
      end
      local cv, cw, cx = a0()
      if not cu or not cu.Parent or not cx or not q.isHidden() or bq(cx.Position) or bs(cx.Position, m.options.prioritizeSafety and 2 or 0) then
        return false
      end
      local cy = cu.Parent
      local cz = cy:IsA("Attachment") and cy.WorldPosition or cy:IsA("BasePart") and cy.Position
      return cz ~= nil and (cx.Position - cz).Magnitude <= math.max(0, cu.MaxActivationDistance - 0.25)
    end
    local function cu()
      v()
      aj, ak, al = nil, {}, 0
      w.clearSince, w.returnDestination = nil, nil
      w.returnRetryAt = nil
      w.exitRetryAt, w.exitRetryCount, w.exitClearSince, w.exitGoal, w.exitGoalKind, w.exitAttempted = nil, nil, nil, nil, nil, nil
      w.routeWait, w.routePlanAt = nil, nil
      w.replanTargetAt = nil
      w.leaving = false
      w.active, w.pending = false, false
      w.waitingForExit = false
      w.entry, w.part, w.position, w.floor, w.character = nil, nil, nil, nil, nil
      w.kind = nil
      w.damageStamp, w.healthAtEntry = nil, nil
      w.geometry, w.cframe, w.returnRotation, w.geometryController = nil, nil, nil, nil
      w.nextGeneratorChosen = nil
      w.workingMachine = nil
      w.workAt = nil
      w.workAmount = nil
      w.exitAttempted = nil
      w.lastGroundCheck = nil
      y = false
      q.stats.coverStatus = "outside"
      if m.setTemporaryNoclip then
        m.setTemporaryNoclip(false)
      end
    end
    local function cw(cx)
      local cy = m.room()
      local cz, cA, cB = a0()
      if not cy or not cB then
        return nil
      end
      local cC = OverlapParams.new()
      cC.FilterType = Enum.RaycastFilterType.Include
      cC.FilterDescendantsInstances = {cy}
      cC.RespectCanCollide = true
      cC.CollisionGroup = cB.CollisionGroup
      local cD = cB.Size + Vector3.new(0.2, 0.2, 0.2)
      local cE = cy:FindFirstChild("Walls")
      local cF = cy:FindFirstChild("Generators")
      for cG, cH in ipairs(n:GetPartBoundsInBox(CFrame.new(cx), cD, cC)) do
        local cI = string.lower(cH.Name)
        local cJ = string.find(cI, "wall", 1, true) or (cE and cH:IsDescendantOf(cE))
        local cK = string.find(cI, "floor", 1, true) or string.find(cI, "ceiling", 1, true) or string.find(cI, "roof", 1, true) or (cF and cH:IsDescendantOf(cF))
        if cH.CanCollide and cJ and not cK and not aQ(cH) then
          return cH
        end
      end
      return nil
    end
    local function cx()
      if not z then
        return
      end
      local cy, cA, cB = a0()
      if w.active and w.kind == "wall" and w.geometry and cy == w.character and m.room() == w.floor then
        z, A, B, C = false, nil, nil, nil
        return
      end
      local cC = cB and cw(cB.Position)
      if cC and cl(cC, cB.Position) and cy == C and m.room() == B then
        w.active, w.pending = true, false
        w.entry, w.part, w.position = A, cC, cB.Position
        w.floor, w.character, y = B, C, true
        w.kind = "wall"
        q.stats.coverStatus = "noclip-retained-in-wall"
      elseif not w.active and not w.pending then
        if m.setTemporaryNoclip then
          m.setTemporaryNoclip(false)
        end
      end
      z, A, B, C = false, nil, nil, nil
    end
    local function cy(cA, cB, cC, cD, cE, cF, cG)
      if cE == "pickup" then
        return false, "pickup-teleport-removed"
      end
      if m.options.tweenOnly and not (cE == "elevator" and m.machinesFinished and m.machinesFinished()) then
        return b4(cA, 0.6, true, cB)
      end
      v()
      local cH, cI, cJ = a0()
      local cK = m.room()
      if not aZ(cB) or not cJ or typeof(cA) ~= "Vector3" then
        return false, "cancelled"
      end
      if not ar(cE) then
        return false, "teleport-disabled-for-floor"
      end
      a4()
      E = "teleport"
      q.stats.motionMode = "teleport"
      ab = true
      if cJ.Anchored then
        local cL = os.clock() + 0.3
        while aZ(cB) and cJ.Anchored and os.clock() < cL do
          task.wait(0.03)
        end
        if cJ.Anchored then
          return false, "root-anchored"
        end
      end
      if not cC and not cD then
        local cL = bL(cA, cA.Y)
        if not cL then
          return false, "no-floor-at-target"
        end
        cA = cL
      end
      local cL = cE == "elevator" and m.machinesFinished and m.machinesFinished()
      local cM = not cL and bq(cA)
      if cM then
        return false, cM.reason
      end
      local cN = false
      local cO = m.options.farmMode == "extreme" and cE == "machine"
      local cP = 0
      local function cQ()
        if q.groundFollower then
          q.groundFollower.reset()
        end
        cJ.CFrame = CFrame.new(cA) * cJ.CFrame.Rotation
        cJ.AssemblyLinearVelocity = aK
        cP += 1
        q.stats.teleportAttempts += 1
        q.stats.lastTeleportWrites = cP
      end
      if cE == "elevator" and m.options.strictElevatorTeleport or cE == "machine" and m.options.teleportOnly then
        q.stats.teleportMode = cE .. "-burst"
        for cR = 1, 8 do
          if not aZ(cB) then
            return false, "cancelled"
          end
          local cS, cT, cU = a0()
          if cS ~= cH or cU ~= cJ or not cT or cT.Health <= 0 then
            return false, "character-changed"
          end
          if m.room() ~= cK then
            return false, "floor-changed"
          end
          if cR > 1 and (cJ.Position - cA).Magnitude > 3.5 then
            q.stats.corrections += 1
          end
          cQ()
          task.wait(0.05)
        end
        local cR = os.clock() + 0.2
        while aZ(cB) and os.clock() < cR do
          if m.character() ~= cH then
            return false, "character-changed"
          end
          if m.room() ~= cK then
            return false, "floor-changed"
          end
          if (cJ.Position - cA).Magnitude > 3.5 then
            q.stats.corrections += 1
            cN = true
            break
          end
          task.wait(0.04)
        end
        if (cJ.Position - cA).Magnitude > 3.5 then
          cN = true
        end
        q.stats.elevatorRetryPending = cN
      elseif cO then
        local cR = cI.Health
        local cS = m.damageStamp and m.damageStamp() or nil
        local cT
        if m.machinePosition then
          local cU, cV = m.machinePosition()
          cT = cV
        end
        q.stats.teleportMode = "extreme-burst"
        q.stats.extremeBurstLimit = 12
        local function cU()
          if not aZ(cB) then
            return false, "cancelled"
          end
          local cV, cW, cX = a0()
          if cV ~= cH or cX ~= cJ then
            return false, "character-changed"
          end
          if m.room() ~= cK then
            return false, "floor-changed"
          end
          if cX.Anchored then
            return false, "root-anchored"
          end
          if m.options.farmMode ~= "extreme" then
            return false, "movement-method-changed"
          end
          if cT and m.machinePosition then
            local cY, cZ = m.machinePosition()
            if cZ ~= cT then
              return false, "target-changed"
            end
          end
          if m.machineTargetValid then
            local cY, cZ = m.machineTargetValid()
            if not cY then
              return false, cZ or "target-vanished"
            end
          end
          local cY = m.damageStamp and m.damageStamp() or nil
          if cW.Health < cR or a_(false) or cS ~= nil and cY ~= cS then
            return false, "health-loss"
          end
          if bZ(false) then
            return false, "exit-required"
          end
          if q.chaseThreat() then
            return false, "twisted-chasing"
          end
          local cZ = bq(cX.Position) or bq(cA)
          if cZ then
            return false, cZ.reason
          end
          if not bO(cA, cA, nil, false) then
            return false, "no-floor-at-target"
          end
          if not bQ(cA) then
            return false, "blocked-destination"
          end
          if cF and (not cF(cX.Position) or not cF(cA)) then
            return false, cG or "machine-teleport-unsafe"
          end
          return true
        end
        repeat
          cN = false
          local cV = os.clock() + 0.85
          for cW = 1, 12 do
            local cX, cY = cU()
            if not cX then
              return false, cY
            end
            if os.clock() >= cV then
              cN = true
              break
            end
            if cP > 0 and (cJ.Position - cA).Magnitude > 3.5 then
              q.stats.corrections += 1
            end
            cQ()
            task.wait(0.04)
          end
          local cW = os.clock() + 0.12
          while not cN and os.clock() < cW do
            local cX, cY = cU()
            if not cX then
              return false, cY
            end
            if os.clock() >= cV or (cJ.Position - cA).Magnitude > 3.5 then
              q.stats.corrections += 1
              cN = true
              break
            end
            task.wait(0.04)
          end
          if not cN then
            local cX, cY = cU()
            if not cX then
              return false, cY
            end
            if os.clock() > cV or (cJ.Position - cA).Magnitude > 3.5 then
              q.stats.corrections += 1
              cN = true
            end
          end
          if cN then
            q.stats.extremeTeleportRetries = (q.stats.extremeTeleportRetries or 0) + 1
            q.stats.teleportMode = "extreme-retrying"
            m.status("Speedrun Extreme · teleport rejected; retrying the same generator")
            task.wait(0.08)
          end
        until not cN
      else
        cQ()
        local cR = os.clock() + (cE == "elevator-exit" and 0.2 or cE == "pickup" and 0.45 or 0.8)
        while aZ(cB) and os.clock() < cR do
          local cS, cT, cU = a0()
          if cS ~= cH or not cU then
            return false, "character-changed"
          end
          if m.room() ~= cK then
            return false, "floor-changed"
          end
          cM = not cL and bq(cU.Position)
          if cM then
            return false, cM.reason
          end
          if cF and not cF(cU.Position) then
            return false, cG or "cover-hop-compromised"
          end
          if (cU.Position - cA).Magnitude > 3.5 then
            q.stats.corrections += 1
            cN = true
            break
          end
          task.wait(0.04)
        end
      end
      if not aZ(cB) then
        return false, "cancelled"
      end
      if cN then
        q.stats.teleportMode = "rejected"
        q.stats.coverStatus = "teleport-rejected"
        aq.failures = (aq.failures or 0) + 1
        if cE == "elevator-exit" then
          q.stats.elevatorExitRejected = true
        elseif cE == "elevator" then
          if cL then
            q.stats.elevatorRetryPending = true
          elseif not m.options.strictElevatorTeleport then
            aq.elevatorDisabled = true
            q.stats.elevatorTeleportDisabled = true
          end
        elseif not m.options.teleportOnly then
          aq.disabled = true
          q.stats.teleportDisabled = true
        end
        m.status(cL and "Elevator arrival corrected · retrying teleport" or m.options.teleportOnly and "Teleport rejected · retrying teleport" or cE == "elevator" and m.options.strictElevatorTeleport and "Elevator teleport rejected · retrying teleport" or cE == "elevator-exit" and "Elevator exit rejected · generator teleport postponed" or "Teleport rejected · next move will use tween")
        return false, "server-correction"
      else
        q.stats.teleportMode = cO and "extreme-burst-accepted" or "direct"
      end
      q.stats.teleports += 1
      return true, "teleport-accepted"
    end
    local cA, cB, cC, cD, cE
    function q.coverHealth()
      local cF, cG = a0()
      local cH = cG and cG.Health or 0
      local cI = cF and cF:FindFirstChild("Stats")
      local cJ = cI and cI:FindFirstChild("Health")
      if cJ and type(cJ.Value) == "number" then
        cH = math.min(cH, cJ.Value)
      end
      return cH
    end
    function q.coverDamaged()
      if not w.active then
        return false
      end
      local cF = q.coverHealth()
      local cG = m.damageStamp and m.damageStamp()
      if w.healthAtEntry == nil or w.damagePolicyVersion ~= 1 then
        w.healthAtEntry = cF
        w.damageStamp = cG
        w.damagePolicyVersion = 1
        return false
      end
      return cF < w.healthAtEntry or cG ~= nil and w.damageStamp ~= nil and cG ~= w.damageStamp
    end
    function q.stableCover()
      local cF, cG, cH = a0()
      if m.options.prioritizeSafety and w.geometry and w.geometry.fitMode == "feet-and-root" then
        return false
      end
      if m.options.prioritizeSafety and w.active and cH then
        if os.clock() - (q.watch.coverHazardAt or -math.huge) >= 0.08 then
          q.watch.coverHazardAt = os.clock()
          q.watch.coverHazard = bq(cH.Position)
        end
        if q.watch.coverHazard then
          return false
        end
      end
      local cI = w.geometry and w.geometry.collider
      if cI and (not cI.Parent or not cI.CanCollide or cI.CanQuery == false or cI.CFrame ~= w.geometry.colliderCFrame or cI.Size ~= w.geometry.colliderSize) then
        return false
      end
      if w.exitAttempted and cH and not cr(cH.Position) then
        return false
      end
      if w.kind == "occluded-wall" then
        return w.active and not w.leaving and cH and cF == w.character and cr(cH.Position) and not q.coverDamaged() and q.wallShelterClear(w.part, cH.Position, cH.CFrame, nil, not q.coverDamaged())
      end
      local cJ = w.verified or w.geometry and w.geometry.verification ~= nil
      if not cJ and w.geometry and w.cframe and q.geometry then
        cJ = q.geometry.contains(w.geometry, w.cframe)
        if cJ then
          w.verified = true
        end
      end
      return m.options.fullBodyHiding and m.options.holdHideUntilDamage ~= false and w.active and not w.leaving and cH and cF == w.character and m.room() == w.floor and w.geometry and w.cframe and w.part and w.part.Parent and q.geometry and cJ and not q.coverDamaged()
    end
    local function cF()
      a4()
      local cG, cH, cI = a0()
      if w.kind == "occluded-wall" and cI and cr(cI.Position) and not w.leaving then
        if m.strictGround then
          q.enforceGround()
        end
        cI.AssemblyLinearVelocity = aK
        cI.AssemblyAngularVelocity = aK
        q.stats.coverHeld = true
        return
      end
      if m.options.fullBodyHiding and w.geometry and w.geometry.grounded and cI and w.active and not w.leaving and m.room() == w.floor then
        local cJ = w.groundPartPose ~= w.part.CFrame
        if m.strictGround and (cJ or os.clock() - (w.lastGroundCheck or -math.huge) >= 0.15) then
          local cK = q.projectGroundPose(cI, w.cframe)
          if not cK then
            return
          end
          if cJ or (cK.Position - w.cframe.Position).Magnitude > 0.02 then
            if not q.geometry.contains(w.geometry, cK, true) then
              cu()
              return
            end
          end
          w.cframe, w.position = cK, cK.Position
          w.lastGroundCheck, w.groundPartPose = os.clock(), w.part.CFrame
        end
        if (cI.Position - w.position).Magnitude > 0.02 or cI.CFrame.Rotation ~= w.cframe.Rotation then
          cI.CFrame = w.cframe
        end
        if cI.AssemblyLinearVelocity.Magnitude > 0.001 then
          cI.AssemblyLinearVelocity = aK
        end
        if (cI.AssemblyAngularVelocity or aK).Magnitude > 0.001 then
          cI.AssemblyAngularVelocity = aK
        end
      elseif m.options.wallCenterHiding and cI and w.active and not w.leaving and m.room() == w.floor and w.part and w.part.Parent then
        cI.CFrame = CFrame.new(w.part.Position) * cI.CFrame.Rotation
        w.position = w.part.Position
      end
      if cI and w.active and not w.leaving and m.room() == w.floor and (w.verified and w.geometry and w.position and (cI.Position - w.position).Magnitude < 0.03 or cl(w.part, cI.Position)) then
        if t ~= cI then
          v()
          if not cI.Anchored then
            t, u = cI, false
          end
        end
        if t == cI then
          cI.Anchored = false
          q.stats.coverPinned = false
          q.stats.coverHeld = true
        end
        if cI.AssemblyLinearVelocity.Magnitude > 0.001 then
          cI.AssemblyLinearVelocity = aK
        end
        if (cI.AssemblyAngularVelocity or aK).Magnitude > 0.001 then
          cI.AssemblyAngularVelocity = aK
        end
      end
    end
    function q.restoreCoverAnchor()
      if not q.stableCover() or m.machinesFinished and m.machinesFinished() then
        return false
      end
      local cH, cI, cJ = a0()
      if not cJ then
        return false
      end
      if (cJ.Position - w.position).Magnitude > 0.75 then
        q.stats.coverCorrections = (q.stats.coverCorrections or 0) + 1
        if m.onCoverDisplaced then
          m.onCoverDisplaced()
        end
      end
      cF()
      return true
    end
    local function cI(cJ)
      local cK, cL = a0()
      w.damageStamp = m.damageStamp and m.damageStamp() or nil
      w.healthAtEntry = q.coverHealth()
      w.damagePolicyVersion = 1
      w.verified = true
      am("entered", cJ)
    end
    local function cJ(cK)
      cF()
      w.clearSince = nil
      if cK ~= "confirming-whole-exit-corridor" and cK ~= "checking-route-from-same-cover" then
        w.exitClearSince = nil
      end
      if q.stats.coverStatus ~= "holding-same-spot" or q.stats.returnReason ~= cK then
        am("hold", cK)
      end
      q.stats.coverStatus = "holding-same-spot"
      q.stats.returnReason = cK
      if cK == "waiting-for-twisted-distance" then
        m.status(string.format("Hidden · waiting for Twisted to move %d studs away (%.0f now)", q.stats.resumeRequiredDistance or 55, q.stats.resumeWaitDistance or 0))
      else
        m.status("Hidden · staying in this spot; waiting for Twisteds to clear")
      end
      return false, "cover-holding"
    end
    function q.noteCoverExitFailure(cK)
      if not w.active or not w.exitAttempted then
        return
      end
      w.exitRetryCount = math.min(5, (w.exitRetryCount or 0) + 1)
      w.exitRetryAt = os.clock() + math.min(10, w.exitRetryCount * 2)
      w.exitClearSince = nil
      q.stats.coverExitRetryAt = w.exitRetryAt
      q.stats.coverExitRetryReason = cK
      am("exit-wait", cK or "interrupted")
    end
    function q.keepCurrentInteriorPose()
      local cK, cL, cM = a0()
      if not cM then
        return false
      end
      local cN = w.kind == "occluded-wall" and cr(cM.Position) and q.wallShelterClear(w.part, cM.Position, cM.CFrame, nil, not q.coverDamaged()) or w.geometry and q.geometry and q.geometry.contains(w.geometry, cM.CFrame, true)
      if not cN then
        return false
      end
      w.position, w.cframe = cM.Position, cM.CFrame
      if w.geometry then
        w.geometry.position, w.geometry.cframe = cM.Position, cM.CFrame
      end
      w.lastGroundCheck = nil
      w.exitAttempted = nil
      return true
    end
    function q.preflightCoverExit(cL, cM, cN)
      if m.machinesFinished and m.machinesFinished() then
        return true
      end
      if w.exitRetryAt and os.clock() < w.exitRetryAt then
        return false, "cover-exit-retry-window"
      end
      if not cL or #cL < 2 then
        return false, "cover-exit-route-missing"
      end
      local cO, cP = q.coverResumeClear(cM)
      if not cO then
        w.exitClearSince = nil
        return false, cP
      end
      local cQ = 0
      for cR = 2, #cL do
        local cS, cT = cL[cR - 1], cL[cR]
        local cU, cV = bP(cS)
        if cU then
          cU, cV = bP(cT)
        end
        if cU and m.hazards then
          local cW
          cU, cW = m.hazards.segmentClear(cS, cT)
          if not cU then
            cV = type(cW) == "table" and cW.reason or "attack-on-exit-route"
          end
        end
        if cU and not q.travelLegClear(cS, cT, cQ, true) then
          cU, cV = false, "twisted-on-exit-corridor"
        end
        q.stats.coverExitPreflightLegs = (q.stats.coverExitPreflightLegs or 0) + 1
        if not cU then
          w.exitClearSince = nil
          return false, cV
        end
        cQ += (cT - cS).Magnitude / math.max(1, H(nil, false))
      end
      if not w.exitGoal or (aY(w.exitGoal, cM) > 1) or w.exitGoalKind ~= cN then
        w.exitClearSince = nil
        w.exitGoal, w.exitGoalKind = cM, cN
      end
      w.exitClearSince = w.exitClearSince or os.clock()
      local cR = w.exitRetryCount and 2 or math.max(1, tonumber(m.options.clearDelay) or 0.5)
      if os.clock() - w.exitClearSince < cR then
        return false, "confirming-whole-exit-corridor"
      end
      return q.exitWriteGuard()
    end
    function q.coverReturnDestination()
      if not m.resumePosition then
        return nil, "entry"
      end
      local cL, cM = m.resumePosition(q)
      if cM == "pickup" and typeof(cL) == "Vector3" then
        local cN = bL(cL, cL.Y)
        if not cN then
          return nil, "pickup-no-floor"
        end
        q.stats.coverPickupPrompt = tostring(cL)
        q.stats.coverPickupStanding = tostring(cN)
        cL = cN
      end
      return cL, cM
    end
    function q.replanCoverReturn(cL, cM)
      local cN = cM == "unsupported-tween-leg" or cM == "no-supported-alternate-route" or cM == "native-route-without-floor" or cM == "route-blocked" or cM == "corrected-route-cooldown" or cM == "no-floor-at-target" or cM == "no-supported-machine-destination" or cM == "attack-on-machine-route" or cM == "twisted-on-direct-route" or cM == "twisted-route-changed" or cM == "twisted-on-exit-corridor"
      if cL ~= "machine" or not cN or not m.replanCoverTarget or os.clock() < (w.replanTargetAt or 0) then
        return false
      end
      w.replanTargetAt = os.clock() + 1
      local cO = m.replanCoverTarget(cM)
      q.stats.coverTargetReplans = (q.stats.coverTargetReplans or 0) + (cO and 1 or 0)
      q.stats.coverTargetReplanReason = cM
      return cO == true
    end
    function q.resumeWallShelter(cL)
      local cM, cN, cO = a0()
      if not cO or cM ~= w.character or m.room() ~= w.floor then
        cu()
        return false, "shelter-invalidated"
      end
      local cP = q.rollingPumpkinThreat()
      if cP then
        return q.avoidRollingPumpkin(cL, cP)
      end
      local cQ, cR = q.wallShelterClear(w.part, cO.Position, cO.CFrame, nil, not q.coverDamaged())
      if q.coverDamaged() or not cr(cO.Position) or not cQ then
        if q.coverDamaged() and w.part then
          q.watch.rejectedWalls[w.part] = os.clock() + 30
        end
        am("invalidated", cR or "wall-shelter-damaged")
        cu()
        return cB(cL, q.chaseThreat())
      end
      cF()
      if w.routeWait and os.clock() < (w.routePlanAt or 0) then
        return cJ("checking-route-from-same-cover")
      end
      local cS, cT = q.coverReturnDestination()
      if not cS or cT == "machine-occupied" or m.holdCover and m.holdCover() then
        return cJ("waiting-in-wall-shelter")
      end
      local cU, cV = q.coverResumeClear(cS)
      if not cU then
        return cJ(cV)
      end
      local cW, cX
      if cT == "machine" and q.machineHeightTravelAllowed() then
        cW, cX = q.generatorLevelRoute(cO.Position, cS, true)
      else
        cW, cX = b_(cO.Position, cS, false, cL, m.room())
      end
      if not cW and (cX == "attack-on-machine-route" or cX == "twisted-on-direct-route") then
        cW, cX = b_(cO.Position, cS, false, cL, m.room(), true, "machine-exit")
      end
      if not cW then
        if q.replanCoverReturn(cT, cX) then
          w.routePlanAt = os.clock() + 0.1
          w.routeWait = true
          return cJ("checking-route-from-same-cover")
        end
        w.routeWait = true
        w.routePlanAt = os.clock() + 0.75
        return cJ(cX or "wall-shelter-route-blocked")
      end
      local cY, cZ = q.preflightCoverExit(cW, cS, cT)
      if not cY then
        return cJ(cZ)
      end
      if m.setTemporaryNoclip and m.setTemporaryNoclip(true) == false then
        return false, "noclip-unavailable"
      end
      q.stats.collisionSuppression = true
      local c_, c0
      af = cT
      if cT == "machine" and m.options.returnToGenerator then
        c_, c0 = cE(cS, cL, true)
      else
        w.leaving = true
        w.exitAttempted = true
        c_, c0 = b4(cS, 1, false, cL)
      end
      af = nil
      w.leaving = false
      if c_ then
        cu()
        q.watch.routeWait = nil
        return true, "returned-from-wall-shelter"
      end
      q.noteCoverExitFailure(c0)
      q.keepCurrentInteriorPose()
      if cr(cO.Position) and q.wallShelterClear(w.part, cO.Position, cO.CFrame, nil, not q.coverDamaged()) then
        w.routeWait = true
        w.routePlanAt = os.clock() + 0.75
        cF()
      else
        cu()
        return cB(cL, q.chaseThreat())
      end
      return false, c0
    end
    local function cL(cM)
      if bq(cM) then
        return false
      end
      if m.options.wallCenterHiding and cl(w.part, cM) then
        return true
      end
      local cN = bb()
      if aG then
        return false
      end
      for cO, cP in ipairs(cN) do
        if cP.stationary then
          if aY(cM, cP.position) <= cP.killRadius + 6 then
            return false
          end
          continue
        end
        local cQ = bd(cP, cM)
        local cS = co(cM, w.part, cP, 1.2, cQ)
        local cT = cQ and cl(w.part, cM)
        local cU = cT and cm(cP) or math.max(cP.killRadius + 15, cP.instantRadius + 16) + aM(cP)
        if cP.ranged and not cQ then
          cU = math.max(cU, cP.visionRadius + 25)
        end
        if cS <= cU then
          return false
        end
        if aY(cM, cP.position) < cP.visionRadius + 10 and ba(cP.position + aL, cM + aL) then
          return false
        end
      end
      return true
    end
    local function cM(cN, cO)
      q.noteCoverExitFailure(cO)
      q.keepCurrentInteriorPose()
      af = nil
      w.leaving = false
      w.clearSince = nil
      q.stats.coverExitInterrupts = (q.stats.coverExitInterrupts or 0) + 1
      q.stats.lastCoverExitReason = cO
      local cP, cQ, cS = a0()
      if cS and cr(cS.Position) and cl(w.part, cS.Position) then
        w.exitAttempted = nil
        cF()
        return false
      elseif cS and aZ(cN) and m.room() == w.floor then
        local cT, cU = q.shouldHide(cS.Position, true)
        local cW = q.nativePursuer() or q.chaseThreat()
        am("exit", "interrupted-outside-cover")
        cu()
        if cT or cW then
          cB(cN, cW or cU)
        end
        return true
      end
      return false
    end
    local function cN(cO, cQ)
      local cS, cT, cU = a0()
      if not cU or not cr(cU.Position) or q.chaseThreat() then
        return false
      end
      local cW = cU.Position
      local cX = {}
      if typeof(w.entry) == "Vector3" and (w.entry - cW).Magnitude <= 32 then
        table.insert(cX, w.entry)
      end
      for cY, cZ in ipairs({4, 8, 12, 20}) do
        for c_ = 0, 7 do
          local c0 = c_ * math.pi / 4
          table.insert(cX, cW + Vector3.new(math.cos(c0), 0, math.sin(c0)) * cZ)
        end
      end
      for cY, cZ in ipairs(cX) do
        if not aZ(cO) or q.chaseThreat() or not cL(cU.Position) then
          return false
        end
        local c_ = bL(cZ, cZ.Y)
        if not c_ or cr(c_) or not bQ(c_) or not bO(cU.Position, c_, nil, true) or not bY(cU.Position, c_) or not q.safeHere(c_, 2, true) then
          continue
        end
        local c0 = true
        local c1 = cQ == "machine" and q.safeToMachineReturn or cQ == "pickup" and q.safeToPickup or q.safeToInteract
        for c2 = 0, math.max(1, math.ceil((c_ - cW).Magnitude / 2)) do
          local c3 = math.max(1, math.ceil((c_ - cW).Magnitude / 2))
          if not c1(cW:Lerp(c_, c2 / c3), 2, true, true) then
            c0 = false
            break
          end
        end
        if not c0 then
          continue
        end
        w.leaving = true
        w.exitAttempted = true
        af = cQ or "machine"
        am("exit", "blocked-return-safe-lane")
        m.status("Blocked machine return · tweening out through a nearby safe exit")
        local c2, c3 = b4(c_, 0.6, false, cO)
        af = nil
        w.leaving = false
        if c2 and not cr(cU.Position) then
          cu()
          q.stats.coverExitRecoveries = (q.stats.coverExitRecoveries or 0) + 1
          q.stats.coverStatus = "exited-blocked-return"
          return true
        end
        if not c2 then
          cM(cO, c3)
        end
        return false
      end
      return false
    end
    local function cO(cQ)
      if not w.active and not w.pending then
        return true, "no-cover"
      end
      local cT, cU, cW = a0()
      if not cW then
        return false, "no-character"
      end
      local cX = q.rollingPumpkinThreat()
      if cX then
        return q.avoidRollingPumpkin(cQ, cX)
      end
      if m.room() ~= w.floor or cT ~= w.character or (w.part and not w.part.Parent) then
        cu()
        return true, "cover-invalidated"
      end
      if w.exitRetryAt and os.clock() < w.exitRetryAt then
        return cJ("cover-exit-retry-window")
      end
      if w.kind == "occluded-wall" then
        return q.resumeWallShelter(cQ)
      end
      if m.options.prioritizeSafety and w.geometry and w.geometry.fitMode == "feet-and-root" then
        am("invalidated", "upgrading-to-full-body-cover")
        cu()
        return q.enterNearbyCover(cW.Position, cQ, true)
      end
      if m.options.fullBodyHiding and w.geometry and m.coverGeometry and (not w.geometry.grounded or not w.geometryController or w.geometryController.version ~= "ground-yaw-2" and w.geometryController.version ~= "ground-yaw-3" and w.geometryController.version ~= "ground-yaw-4" and w.geometryController.version ~= "ground-yaw-5" and w.geometryController.version ~= "ground-yaw-6" and w.geometryController.version ~= "ground-yaw-8") then
        if w.geometryController and w.geometryController ~= q.geometry then
          w.geometryController.destroy()
        end
        cu()
        return q.enterNearbyCover(cW.Position, cQ, true)
      end
      q.restoreCoverAnchor()
      if m.options.fullBodyHiding and w.active and q.coverDamaged() then
        if w.part then
          q.watch.rejectedWalls[w.part] = os.clock() + 30
        end
        am("invalidated", "damage-in-cover")
        cu()
        return q.enterNearbyCover(cW.Position, cQ, true)
      end
      local cY = q.stableCover()
      if cY then
        cF()
      end
      if cY and w.routeWait and os.clock() < (w.routePlanAt or 0) then
        return cJ("checking-route-from-same-cover")
      end
      if w.part and aQ(w.part) then
        w.active, w.pending, w.waitingForExit = false, false, true
        y = true
        q.stats.coverStatus = aO(w.part) and "machine-rejected" or "stairs-rejected"
        m.setTemporaryNoclip(true)
        return true, aO(w.part) and "unsafe-cover-machine" or "unsafe-cover-stairs"
      end
      if w.kind ~= "wall" or not cY and not cl(w.part, cW.Position) then
        am("invalidated", "not-inside-solid-cover")
        cu()
        m.status("Exposed · escaping toward solid cover")
        if m.options.fullBodyHiding then
          return q.enterNearbyCover(cW.Position, cQ, true)
        end
        return cB(cQ, q.chaseThreat())
      end
      local cZ = bq(cW.Position)
      if cZ then
        if cY then
          return cJ("attack-near-cover-holding-same-spot")
        end
        am("invalidated", cZ.reason .. "-in-cover")
        cu()
        if m.options.fullBodyHiding then
          return q.enterNearbyCover(cW.Position, cQ, true)
        end
        return cB(cQ, cZ)
      end
      local c_ = q.sproutThreat()
      if c_ then
        if cY then
          return cJ("sprout-near-cover-holding-same-spot")
        end
        if m.options.fullBodyHiding then
          if w.part then
            q.watch.rejectedWalls[w.part] = os.clock() + 15
          end
          cu()
          return q.enterNearbyCover(cW.Position, cQ, true)
        end
        return cB(cQ, c_)
      end
      w.active, w.pending, y = true, false, true
      w.leaving = false
      cF()
      if m.setTemporaryNoclip then
        local c0, c1 = m.setTemporaryNoclip(true)
        if c0 == false then
          return false, c1 or "noclip-unavailable"
        end
      end
      if not aZ(cQ) then
        return false, "cancelled"
      end
      local c0, c1 = q.coverReturnDestination()
      if c1 == "machine" then
        local c2, c3 = q.coverResumeClear(c0)
        if not c2 then
          return cJ(c3)
        end
      end
      if m.options.fullBodyHiding and c1 == "machine" and typeof(c0) == "Vector3" then
        if m.holdCover and m.holdCover() then
          return cJ("waiting-in-cover")
        end
        if q.chaseThreat() or q.detectedThreat() then
          return cJ("waiting-for-chase-to-clear")
        end
        local c2, c3 = q.safeToMachineReturn(c0, 0.6, true)
        if not c2 then
          w.clearSince = nil
          local c4 = type(c3) == "table" and c3.reason or c3
          if q.replanCoverReturn(c1, c4) then
            return cJ("checking-route-from-same-cover")
          end
          return cJ(c4)
        end
        w.clearSince = w.clearSince or os.clock()
        if os.clock() - w.clearSince < (m.options.clearDelay or 0.3) then
          cF()
          m.status("Hidden · checking generator clearance")
          return false, "checking-generator-clearance"
        end
        af = "machine"
        local c4, c5 = cE(c0, cQ, true)
        af = nil
        w.leaving = false
        if c4 then
          cu()
          if m.coverDamageHandled then
            m.coverDamageHandled()
          end
          return true, "generator-resumed-from-cover"
        end
        if cM(cQ, c5) then
          return false, "cover-exit-interrupted"
        end
        if w.active then
          local c6 = q.replanCoverReturn(c1, c5)
          w.routeWait = true
          w.routePlanAt = os.clock() + (c6 and 0.1 or 0.75)
          cF()
          m.status("Hidden · route blocked; keeping the same spot and generator")
        end
        return false, c5
      end
      if m.options.wallCenterHiding then
        local c2 = bs(cW.Position)
        if c2 then
          cu()
          return cB(cQ, c2)
        end
        local c3 = m.damageStamp and m.damageStamp()
        if w.damageStamp and c3 and c3 ~= w.damageStamp then
          U, V = w.part, os.clock() + 30
          q.watch.rejectedWalls[w.part] = V
          cu()
          return cB(cQ, q.chaseThreat())
        end
        if m.holdCover and m.holdCover() or c1 == "machine-occupied" then
          return cJ("waiting-in-wall")
        end
        if q.chaseThreat() or q.detectedThreat() then
          return cJ("detected-hold-wall-center")
        end
        c0 = c0 or w.entry
        if c1 == "elevator" then
          c0 = q.elevatorPosition()
        end
        if typeof(c0) ~= "Vector3" then
          return cJ("waiting-for-destination")
        end
        local c4, c5 = (c1 == "machine" and q.safeToMachineReturn or q.safeToInteract)(c0, 1.2, true)
        if not c4 then
          return cJ(type(c5) == "table" and c5.reason or c5)
        end
        w.clearSince = w.clearSince or os.clock()
        if os.clock() - w.clearSince < (m.options.clearDelay or 2) then
          cF()
          m.status("Centered in wall · checking return area")
          return false, "wall-center-clear-window"
        end
        w.leaving = true
        w.exitAttempted = true
        local c6, c7
        if c1 == "machine" and (m.options.machineMoveMethod or "tween") == "tween" then
          q.stats.machineReturnMethod = "tween"
          c6, c7 = cE(c0, cQ, true)
        else
          q.stats.machineReturnMethod = c1 == "machine" and "teleport" or nil
          c6, c7 = cy(c0, cQ, false, false, "wall-center")
        end
        w.leaving = false
        if c6 then
          cu()
          if m.coverDamageHandled then
            m.coverDamageHandled()
          end
          return true, "wall-center-return"
        end
        if cM(cQ, c7) then
          return false, "cover-exit-interrupted"
        end
        return false, c7
      end
      a_(false)
      local c2, c3 = a0()
      if not c3 then
        return false, "no-character"
      end
      local c4 = m.damageStamp and m.damageStamp() or nil
      if w.healthAtEntry == nil then
        cI("adopt-existing-cover")
      end
      local c5 = c3.Health < w.healthAtEntry or c4 ~= nil and w.damageStamp ~= nil and c4 ~= w.damageStamp
      if c5 and c1 ~= "elevator" and m.options.coverHop == true then
        local c6, c7 = cC(c0, cQ, true)
        if c6 then
          if m.coverDamageHandled then
            m.coverDamageHandled()
          end
          return false, "cover-hopped"
        end
        if c7 ~= "no-hidden-hop" and c7 ~= "cover-hop-retry" then
          return false, c7
        end
        return cJ("damaged-cover-no-safe-relocation")
      end
      if not cL(cW.Position) then
        return cJ("twisted-near-cover")
      end
      if q.chaseThreat() then
        return cJ("twisted-chasing")
      end
      local c6, c7 = q.safeHere(cW.Position, 2, true)
      if not c6 then
        return cJ(type(c7) == "table" and c7.reason or c7)
      end
      if m.holdCover and m.holdCover() then
        w.clearSince = nil
        q.stats.coverStatus = "research-waiting-emergence"
        return false, "research-hold-cover"
      end
      if w.returnRetryAt and os.clock() < w.returnRetryAt then
        m.status("Hidden · waiting briefly before retrying a supported exit")
        return false, "cover-return-retry"
      end
      local c8 = c1 == "pickup" and q.safeToPickup or c1 == "machine" and q.safeToMachineReturn or q.safeToInteract
      if c1 == "connie-camping-machine" or c1 == "machine-retry-cooldown" or c1 == "machine-occupied" then
        return cJ(c1)
      end
      if c1 == "elevator" then
        c0 = q.elevatorPosition()
      end
      c0 = c0 or w.entry
      if typeof(c0) ~= "Vector3" then
        return false, "cover-return-missing"
      end
      if not cr(c0) then
        c0 = bL(c0, c0.Y)
        if not c0 then
          return false, "no-floor-at-target"
        end
      end
      if not w.returnDestination or (w.returnDestination - c0).Magnitude > 1 then
        w.clearSince = nil
      end
      w.returnDestination = c0
      if c1 == "machine" then
        an, ao = c0, m.room()
      end
      local c9 = c1 == "machine" and m.options.machineHideMode == "detected" and 0.2 or (m.options.clearDelay or 2)
      local da, db = w.clearSince, os.clock() + 0.45
      while aZ(cQ) and os.clock() < db do
        local dc, dd, de = a0()
        if dc ~= cT or not de then
          return false, "character-changed"
        end
        if m.room() ~= w.floor then
          cu()
          return false, "floor-changed"
        end
        if not cl(w.part, de.Position) then
          cu()
          return cB(cQ, q.chaseThreat())
        end
        cF()
        if m.resumeAllowed then
          local df, dg = m.resumeAllowed(c0, c1)
          if not df then
            return cJ(dg or "connie-camping-machine")
          end
        end
        if not cL(de.Position) then
          return cJ("twisted-near-cover")
        end
        if q.chaseThreat() then
          return cJ("twisted-chasing")
        end
        if c1 == "machine" or c1 == "pickup" then
          local df, dg = q.coverResumeClear(c0)
          if not df then
            return cJ(dg)
          end
        end
        local df, dg = q.safeHere(de.Position, 2, true)
        if not df then
          return cJ(type(dg) == "table" and dg.reason or dg)
        end
        local dh, di = c8(c0, c1 == "machine" and 4 or 1.25, true)
        if dh then
          da = da or os.clock()
        else
          da = nil
        end
        w.clearSince = da
        if da and os.clock() - da >= c9 then
          break
        end
        q.stats.coverStatus = "waiting-for-clear-return"
        q.stats.returnReason = dh and "confirming-clear-area" or (type(di) == "table" and di.reason or di)
        m.status(dh and "Hidden · return area clear; confirming" or ("Hidden · " .. (m.describeReason and m.describeReason(di) or "waiting for return area to clear")))
        task.wait(0.05)
      end
      if not aZ(cQ) then
        return false, "cancelled"
      end
      if m.resumeAllowed then
        local dc, dd = m.resumeAllowed(c0, c1)
        if not dc then
          return cJ(dd or "connie-camping-machine")
        end
      end
      if not da or os.clock() - da < c9 then
        return false, "cover-return-unsafe"
      end
      if not c8(c0, c1 == "machine" and 4 or 1.25, true) then
        w.clearSince = nil
        return false, "cover-return-unsafe"
      end
      local dc, dd, de = a0()
      if not de or not cL(de.Position) or not q.safeHere(de.Position, 2, true) then
        return cJ("twisted-near-cover")
      end
      w.clearSince, w.returnDestination = nil, nil
      if cr(c0) then
        w.active, w.pending, w.waitingForExit = false, false, true
        q.stats.coverStatus = "clear-waiting-to-exit"
        Z = nil
        return true, "coast-clear-inside-cover"
      end
      local df, dg
      Z = nil
      af = c1
      local dh = c1 == "machine" and (m.options.machineMoveMethod or "tween") == "tween"
      local di = c1 == "machine" and m.options.farmMode == "extreme" and not dh
      local dj, dk
      if not di then
        dj, dk = b_(cW.Position, c0, false, cQ, m.room())
      end
      local dl = di or dj ~= nil
      if dj then
        for dm = 2, #dj do
          local dn, dp = dj[dm - 1], dj[dm]
          local dq = math.max(1, math.ceil((dp - dn).Magnitude / 2))
          for dr = 0, dq do
            if not bP(dn:Lerp(dp, dr / dq)) then
              dl = false
              break
            end
          end
          if not dl then
            break
          end
        end
      end
      if not dl then
        w.leaving = false
        af = nil
        local dm = dk == "unsupported-tween-leg" or dk == "blocked-height" or dk == "no-floor-on-route" or dk == "no-floor-at-target" or dk == "no-supported-tween-route" or dk == "route-blocked" or dk == "blocked-destination" or dk == "unreachable"
        if dm then
          q.stats.blockedCoverReturns = (q.stats.blockedCoverReturns or 0) + 1
          if cN(cQ, c1) then
            return true, "cover-exited-reselect"
          end
          w.returnRetryAt = os.clock() + 1
        end
        return cJ(dk or "cover-exit-route-unsafe")
      end
      local dm, dn = di, nil
      if not dm then
        dm, dn = q.preflightCoverExit(dj, c0, c1)
      end
      if not dm then
        af = nil
        return cJ(dn)
      end
      w.leaving = true
      w.exitAttempted = true
      am("exit", di and "teleport-destination-clear" or "route-and-destination-clear")
      q.stats.coverExitStartedAt = os.clock()
      local dp = (c0 - cW.Position).Magnitude
      local dq = m.canTeleportPickup and m.canTeleportPickup(dp) or dp <= 20
      if dh then
        q.stats.machineReturnMethod = "tween"
        df, dg = cE(c0, cQ, true)
      elseif not di and ((c1 == "pickup" and not dq) or m.options.hideMode == "tween" or not ar()) then
        if c1 == "pickup" and not dq then
          q.stats.farPickupTeleportsAvoided = (q.stats.farPickupTeleportsAvoided or 0) + 1
        end
        m.status(c1 == "machine" and "Preparing return to the machine" or "Preparing a supported cover exit")
        df, dg = b4(c0, 1.2, false, cQ)
      else
        m.status(c1 == "machine" and "Teleporting back to the machine" or "Teleporting out of cover")
        local dr = function(dr)
          return bP(dr)
        end
        df, dg = cy(c0, cQ, false, nil, di and "machine" or nil, dr, "machine-return-unsafe")
      end
      af = nil
      w.leaving = false
      if not df then
        if cM(cQ, dg) then
          return false, "cover-exit-interrupted"
        end
        local dr = dg == "unsupported-tween-leg" or dg == "blocked-height" or dg == "no-floor-on-route" or dg == "no-floor-at-target" or dg == "no-supported-tween-route" or dg == "route-blocked" or dg == "blocked-destination" or dg == "unreachable"
        if dr then
          q.stats.blockedCoverReturns = (q.stats.blockedCoverReturns or 0) + 1
          if cN(cQ, c1) then
            return true, "cover-exited-reselect"
          end
          w.returnRetryAt = os.clock() + 1
        end
        return false, dg
      end
      local dr, ds, dt = a0()
      if dt and not cr(dt.Position) then
        cu()
        return true, c1 == "machine" and "returned-to-machine" or "cover-exited"
      end
      return false, "cover-exit-incomplete"
    end
    local cQ, cT, cW, cX = nil, {}, {}, nil
    local function cY()
      if cX then
        cX:Disconnect()
        cX = nil
      end
      cQ = nil
      table.clear(cT)
      table.clear(cW)
    end
    local function cZ(c_)
      if cQ ~= c_ then
        cY()
        cQ = c_
        for c0, c1 in ipairs(c_:GetDescendants()) do
          if c1:IsA("Part") then
            table.insert(cT, c1)
            cW[c1] = true
          end
        end
        cX = c_.DescendantAdded:Connect(function(c0)
          if c0:IsA("Part") and not cW[c0] then
            table.insert(cT, c0)
            cW[c0] = true
          end
        end)
        q.stats.coverInventories = (q.stats.coverInventories or 0) + 1
      end
      for c0 = #cT, 1, -1 do
        local c1 = cT[c0]
        if not c1:IsDescendantOf(c_) then
          table.remove(cT, c0)
          cW[c1] = nil
        end
      end
      q.stats.coverPoolSize = #cT
      return cT
    end
    cA = function(c_, c0, c1, c3, c4, c5)
      c4 = c4 or q.coverSearchBudget()
      if not c4() then
        return c1 and {} or nil
      end
      if m.animations then
        q.prepareTweenAnimations(true)
      end
      if not m.setTemporaryNoclip then
        return nil
      end
      local c6 = m.room()
      if not c6 then
        return nil
      end
      if m.options.fullBodyHiding and m.coverGeometry then
        q.ensureGeometry()
        q.geometryByPart = q.geometryByPart or {}
        local c7, c8
        if m.machinePosition then
          c7, c8 = m.machinePosition()
        end
        local c9 = {}
        local da = bb()
        local db = c3 == true
        local de = q.watch.coverGeometryCache
        local df
        if db and de and de.floor == c6 and de.generator == c8 and aY(c_, de.origin) < 1 and os.clock() - de.at < 0.25 then
          df = de.candidates
        else
          df = q.geometry.candidates(c_, c7, c8, db and 12 or 6, db, c4)
          if db then
            q.watch.coverGeometryCache = {floor = c6, generator = c8, origin = c_, at = os.clock(), candidates = df}
          end
        end
        local dg = {considered = #df, accepted = 0, bodyRejected = q.geometry.stats.bodyRejected, contactBlocked = 0,
          sightBlocked = 0, routeBlocked = 0}
        dg.expanded = db
        q.stats.coverSearch = dg
        if m.room() ~= c6 then
          return c1 and {} or nil
        end
        c4 = q.coverSearchBudget(c5)
        for dh, di in ipairs(df) do
          if not c4() then
            break
          end
          if os.clock() < (q.watch.rejectedWalls[di.part] or 0) or os.clock() < (di.rejectedUntil or 0) or bq(di.position) then
            continue
          end
          q.geometryByPart[di.part] = di
          local dj = true
          for dk, dl in ipairs(da) do
            local dm = bd(dl, di.position)
            local dn = co(di.position, di.part, dl, 1.25, dm)
            local dp = dl.killRadius + (dl.lethal and 6 or m.options.prioritizeSafety and 2 or 1)
            if dn <= dp then
              dg.contactBlocked += 1
              dj = false
              break
            end
            if dl.ranged and not dm and aY(di.position, dl.position) < dl.visionRadius + 5 then
              dg.sightBlocked += 1
              dj = false
              break
            end
            if aY(di.position, dl.position) < dl.visionRadius + 10 then
              local dq = di.fitMode == "feet-and-root" and {Vector3.new(0, -1.8, 0), Vector3.new(0, 0.5, 0)} or {Vector3.new(0, -2.5, 0),
                Vector3.new(0, 2.5, 0)}
              for ds, dt in ipairs(dq) do
                if ba(dl.position + aL, di.cframe:PointToWorldSpace(dt)) then
                  dg.sightBlocked += 1
                  dj = false
                  break
                end
              end
            end
            if not dj then
              break
            end
          end
          if dj then
            di.allowPartialApproach = db
            di.searchCheckpoint = c4
            local dk, dl = q.planCoverApproach(c_, di)
            di.searchCheckpoint = nil
            if dk then
              local dm = 0
              for dn = 2, #dk do
                dm += (dk[dn] - dk[dn - 1]).Magnitude
              end
              di.approachPath = dk
              di.approachScore = dm + (di.partialApproach and aY(dk[#dk], di.position) + 8 or 0) + 12 / math.max(0.5, dl or math.huge) + (di.fitMode == "feet-and-root" and 1000 or 0) - (di.behindMachine and 4 or 0)
              c9[#c9 + 1] = di
              if #c9 >= 2 then
                break
              end
            else
              dg.routeBlocked += 1
            end
          end
        end
        dg.accepted = #c9
        table.sort(c9, function(dh, di)
          return dh.approachScore < di.approachScore
        end)
        if c1 then
          return c9
        end
        return c9[1]
      end
      if m.options.wallCenterHiding then
        local c7 = c6:FindFirstChild("Walls")
        local c8 = {}
        local c9 = c6:FindFirstChild("Monsters")
        local da = c6:FindFirstChild("Items")
        for db, de in ipairs(c6:GetDescendants()) do
          if de:IsA("BasePart") and de.CanCollide and de.CanQuery ~= false and not aQ(de) and not (c9 and de:IsDescendantOf(c9)) and not (da and de:IsDescendantOf(da)) and not de.Name:lower():find("carpet", 1, true) and not de.Name:lower():find("rug", 1, true) and os.clock() >= (q.watch.rejectedWalls[de] or 0) and (de ~= U or os.clock() > V) then
            local df = de.Position
            if not bs(df, 12) and bt(c_, df) then
              c8[#c8 + 1] = {part = de, position = df, kind = "wall", score = (df - c_).Magnitude}
            end
          end
        end
        table.sort(c8, function(db, de)
          return db.score < de.score
        end)
        q.stats.coverSearch = {considered = #c8, accepted = #c8, bodyRejected = 0}
        if c1 then
          return c8
        end
        return c8[1]
      end
      local c7 = bb()
      local c8 = a2()
      local c9 = false
      local da = c6:FindFirstChild("Walls")
      local db, de = nil, math.huge
      local df, dg = nil, math.huge
      local dh = {}
      local di = {considered = 0, unsupported = 0, unsafe = 0, accepted = 0, bodyRejected = 0, boundaryRejected = 0}
      q.stats.coverSearch = di
      local function dj(dk, dl, dm)
        local dn = aY(c_, dk)
        if dn > s or math.abs(dk.Y - c_.Y) > 4 then
          return
        end
        local dp, dq = a2()
        local ds = q.watch.routeWait and math.max(ap, (dq or 0) + 20) or ap
        if dp and aY(dk, dp) > ds then
          di.boundaryRejected += 1
          return
        end
        local dt = (c_ - dk).Magnitude
        if not c1 and typeof(c0) == "Vector3" then
          dt += aY(dk, c0) * 0.35
        end
        if not c1 and dt >= dg then
          return
        end
        di.considered += 1
        if dm ~= "wall" or not cl(dl, dk) then
          return
        end
        if bq(dk) then
          return
        end
        local du = bL(dk, dk.Y)
        if not du or math.abs(du.Y - dk.Y) > 0.8 or not bO(dk, dk, nil, false) then
          di.unsupported += 1
          return
        end
        if aU(dk) or aR(dk) then
          return
        end
        local dv = math.huge
        for dw, dx in ipairs(c7) do
          if dx.stationary then
            if aY(dk, dx.position) <= dx.killRadius + 6 then
              return
            end
            continue
          end
          local dy = bd(dx, dk)
          local dz, dA = co(dk, dl, dx, 2, dy)
          local dB = dy and cm(dx) or math.max(dx.killRadius + 15, dx.instantRadius + 16) + aM(dx)
          if dx.ranged and not dy then
            dB = math.max(dB, dx.visionRadius + 25)
          end
          if dz <= dB then
            di.unsafe += 1
            return
          end
          dv = math.min(dv, dz - dx.killRadius)
          if aY(dk, dx.position) <= dx.visionRadius + 15 and ba(dx.position + aL, dk + aL) then
            return
          end
          if aY(dk, dA) <= dx.visionRadius + 15 and ba(dA + aL, dk + aL) then
            return
          end
        end
        di.accepted += 1
        local dw = dt
        if c1 then
          if not bL(dk, dk.Y) then
            return
          end
          for dx, dy in ipairs(dh) do
            if (dy.position - dk).Magnitude < 3 then
              return
            end
          end
          table.insert(dh, {part = dl, position = dk, kind = dm})
        end
        if dm == "wall" and dw < dg then
          df, dg = {part = dl, position = dk, kind = dm}, dw
        end
        if dw < de then
          db, de = {part = dl, position = dk, kind = dm}, dw
        end
      end
      for dk, dl in ipairs(cZ(c6)) do
        if dl:IsDescendantOf(c6) and b6(dl) then
          local dm = string.lower(dl.Name)
          local dn = string.find(dm, "wall", 1, true) ~= nil or (da and dl:IsDescendantOf(da))
          local dp = dl
          local dq = dl:IsA("Part") and dl.Shape == Enum.PartType.Block
          while dp and dp ~= c6 do
            local ds = dp.Name:lower()
            if ds:find("wall", 1, true) or ds:find("crate", 1, true) or ds:find("shelf", 1, true) or ds:find("table", 1, true) then
              dq = true
              break
            end
            dp = dp.Parent
          end
          local ds = string.find(dm, "floor", 1, true) or string.find(dm, "ceiling", 1, true) or string.find(dm, "roof", 1, true)
          if (dn or dq) and not ds and not aQ(dl) and math.max(dl.Size.X, dl.Size.Y, dl.Size.Z) >= 2.5 then
            local dt = dl.CFrame:PointToObjectSpace(c_)
            local du = {dt.X, dt.Y, dt.Z}
            local dv, dw, dx = ck(dl)
            local dy = {}
            if not dv then
              di.bodyRejected += 1
            end
            if dv and #dx == 2 then
              for dz = 1, 3 do
                dy[dz] = math.clamp(du[dz], dv[dz], dw[dz])
              end
              local function dz(dA)
                local dB = dl.CFrame:PointToWorldSpace(Vector3.new(dA[1], dA[2], dA[3]))
                dj(dB, dl, "wall")
              end
              dz(dy)
              for dA, dB in ipairs({8, 16, 28, 40}) do
                for dC, dD in ipairs({{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {-1, -1}, {-1, 1}, {1, -1}, {1,
                    1}}) do
                  local dE = table.clone(dy)
                  for dF, dG in ipairs(dx) do
                    dE[dG] = math.clamp(dy[dG] + dD[dF] * dB, dv[dG], dw[dG])
                  end
                  dz(dE)
                end
              end
              if typeof(c0) == "Vector3" then
                local dA = dl.CFrame:PointToObjectSpace(c0)
                local dB = table.clone(dy)
                for dC, dD in ipairs(dx) do
                  dB[dD] = math.clamp(({dA.X, dA.Y, dA.Z})[dD], dv[dD], dw[dD])
                end
                for dC, dD in ipairs({16, 28, 48, 72, 96}) do
                  local dE = dl.CFrame:PointToWorldSpace(Vector3.new(dy[1], dy[2], dy[3]))
                  local dF = dl.CFrame:PointToWorldSpace(Vector3.new(dB[1], dB[2], dB[3]))
                  local dG = (dF - dE).Magnitude
                  if dG > 3 then
                    dj(dE:Lerp(dF, math.min(1, dD / dG)), dl, "wall")
                  end
                end
              end
              for dA, dB in ipairs({-1, 0, 1}) do
                for dC, dD in ipairs({-1, 0, 1}) do
                  local dE = table.clone(dy)
                  dE[dx[1]] = dB < 0 and dv[dx[1]] or dB > 0 and dw[dx[1]] or math.clamp(0, dv[dx[1]], dw[dx[1]])
                  dE[dx[2]] = dD < 0 and dv[dx[2]] or dD > 0 and dw[dx[2]] or math.clamp(0, dv[dx[2]], dw[dx[2]])
                  dz(dE)
                end
              end
            end
          end
        end
      end
      if c1 then
        return dh
      end
      return df or db
    end
    function q.inspectCover()
      local c_, c0, c1 = a0()
      local c3 = c1 and cA(c1.Position)
      return c3 and {position = tostring(c3.position), part = c3.part and c3.part:GetFullName(), kind = c3.kind} or nil
    end
    function q.verifyCoverArrival(c0, c1)
      local c3, c4, c5 = a0()
      local c6 = m.room()
      if not c5 or not c0.object or not c0.object.Parent then
        return false, "cover-entry-incomplete"
      end
      local c7, c8 = os.clock() + 0.5, os.clock()
      local c9 = c5.CFrame
      local da = -math.huge
      local db, de = q.coverHealth(), m.damageStamp and m.damageStamp()
      q.stats.coverStatus = "verifying-object-entry"
      m.status("Hiding · confirming the whole body is inside")
      while aZ(c1) and os.clock() < c7 do
        local df, dg, dh = a0()
        if m.ensureNoclip then
          local di, dj = m.ensureNoclip()
          if not di then
            return false, dj or "noclip-not-ready"
          end
        end
        if df ~= c3 or dh ~= c5 or m.room() ~= c6 then
          return false, "cover-entry-invalidated"
        end
        if not c0.object.Parent or not c0.part.Parent then
          return false, "cover-removed"
        end
        if q.coverHealth() < db or de ~= nil and m.damageStamp and m.damageStamp() ~= de then
          return false, "cover-entry-damaged"
        end
        if bq(c5.Position) then
          return false, "cover-entry-hazard"
        end
        local di = (c5.Position - c9.Position).Magnitude > 0.3
        if di or os.clock() - da >= 0.08 then
          if not q.geometry.contains(c0, c5.CFrame) then
            return false, "cover-entry-displaced"
          end
          da = os.clock()
        end
        if di then
          c8 = os.clock()
          c9 = c5.CFrame
        end
        if os.clock() - c8 >= 0.18 then
          if not q.geometry.contains(c0, c5.CFrame, true) then
            return false, "cover-entry-incomplete"
          end
          c0.position, c0.cframe = c5.Position, c5.CFrame
          w.position, w.cframe = c5.Position, c5.CFrame
          q.stats.coverEntryConfirmedAt = os.clock()
          return true
        end
        p.Heartbeat:Wait()
      end
      return false, aZ(c1) and "cover-entry-displaced" or "cancelled"
    end
    local function c0(c1, c3, c4)
      local c5, c6, c7 = a0()
      if not c7 or not aZ(c3) then
        return false, "cancelled"
      end
      if m.options.fullBodyHiding and c1.cframe and q.geometry then
        if not q.geometry.contains(c1, c1.cframe, true) then
          return false, "body-does-not-fit-cover"
        end
        local c8 = q.planCoverApproach(c7.Position, c1)
        if not c8 then
          return false, "twisteds-blocking-cover-route"
        end
        m.stopInteraction()
        local c9, da = m.setTemporaryNoclip(true)
        if c9 == false then
          return false, da
        end
        if m.ensureNoclip then
          local db, de = m.ensureNoclip()
          if not db then
            return false, de or "noclip-not-ready"
          end
        end
        w.entry, w.returnRotation = c7.Position, c7.CFrame.Rotation
        w.part, w.position, w.cframe, w.geometry = c1.part, c1.position, c1.cframe, c1
        w.geometryController = q.geometry
        w.kind, w.floor, w.character = "wall", m.room(), c5
        w.pending, w.active, w.leaving, y = true, false, false, true
        q.watch.coverCommit = {candidate = c1, floor = m.room()}
        c7.Anchored = false
        ab = true
        for db = 2, #c8 do
          local de = c7.Position
          local df = c8[db]
          local dg = math.max(0.04, (df - c7.Position).Magnitude / math.max(1, H(c5, true)))
          local dh = aY(df, c1.position) < 0.25 and c1.cframe or CFrame.new(df) * c1.cframe.Rotation
          local di = q.makeTween(c7, TweenInfo.new(dg, Enum.EasingStyle.Linear), {CFrame = dh})
          D = di
          E = "tween"
          q.stats.motionMode = "tween"
          di:Play()
          m.status("Hiding · following the selected cover approach")
          local dj = os.clock() + dg + 0.6
          local dk, dl = c7.Position, os.clock()
          while aZ(c3) and os.clock() < dj do
            if m.character() ~= c5 or m.room() ~= w.floor or not c1.object.Parent or bq(c7.Position) then
              break
            end
            if m.ensureNoclip then
              local dm, dn = m.ensureNoclip()
              if not dm then
                q.stats.groundBlock = dn or "noclip-not-ready"
                di:Cancel()
                break
              end
            end
            local dm = math.max(0.001, os.clock() - dl)
            if (c7.Position - dk).Magnitude > math.max(2.5, H(c5, true) * dm * 2 + 0.5) then
              q.stats.groundBlock = "server-correction"
              di:Cancel()
              break
            end
            dk, dl = c7.Position, os.clock()
            local dn = q.geometry.contains(c1, c7.CFrame)
            if not dn and not q.coverLegClear(c7.Position, df, c1) then
              break
            end
            c7.AssemblyLinearVelocity = aK
            c7.AssemblyAngularVelocity = aK
            if di.PlaybackState == Enum.PlaybackState.Completed or di.PlaybackState == Enum.PlaybackState.Cancelled then
              break
            end
            p.Heartbeat:Wait()
          end
          if di.PlaybackState == Enum.PlaybackState.Completed and b1(de, df, c7.Position) then
            q.stats.groundBlock = "server-correction"
            di:Cancel()
          end
          if not aZ(c3) or di.PlaybackState ~= Enum.PlaybackState.Completed then
            di:Cancel()
            if aZ(c3) and q.geometry.contains(c1, c7.CFrame, true) then
              c1.position, c1.cframe, c1.partialApproach = c7.Position, c7.CFrame, false
              w.position, w.cframe = c7.Position, c7.CFrame
              break
            end
            local dm = q.stats.groundBlock or (not aZ(c3) and "cancelled" or "full-body-hide-interrupted")
            if dm == "server-correction" then
              b0()
              q.noteCorrectedLeg(de, df, c7.Position)
              q.watch.rejectedWalls[c1.part] = os.clock() + 15
            end
            c1.rejectedUntil = os.clock() + 1
            q.watch.coverCommit = nil
            if m.report then
              pcall(m.report, "hide-interrupted", dm)
            end
            cu()
            return false, dm
          end
          q.watch.hideTrail = q.watch.hideTrail or {}
          table.insert(q.watch.hideTrail, df)
          if #q.watch.hideTrail > 6 then
            table.remove(q.watch.hideTrail, 1)
          end
          if db < #c8 then
            c1.approachWaypoint = nil
            if c1.approachRemaining and aY(df, c1.approachRemaining[1]) < 1 then
              table.remove(c1.approachRemaining, 1)
            end
          end
        end
        if c1.partialApproach and q.geometry.contains(c1, c7.CFrame, true) then
          c1.position, c1.cframe = c7.Position, c7.CFrame
          w.position, w.cframe = c7.Position, c7.CFrame
          c1.partialApproach = false
        elseif c1.partialApproach and aY(c7.Position, c1.position) > 1 then
          D = nil
          E = nil
          q.stats.motionMode = nil
          cu()
          q.stats.coverApproachProgress = (q.stats.coverApproachProgress or 0) + 1
          q.stats.coverStatus = "advancing-to-committed-cover"
          return false, "cover-approach-progress"
        end
        D = nil
        E = nil
        q.stats.motionMode = nil
        local db, de = q.verifyCoverArrival(c1, c3)
        if not db then
          if de == "cover-entry-displaced" or de == "cover-entry-incomplete" then
            q.watch.rejectedWalls[c1.part] = os.clock() + 15
          end
          c1.rejectedUntil = os.clock() + 1.5
          q.watch.coverCommit = nil
          q.stats.coverEntryRejected = (q.stats.coverEntryRejected or 0) + 1
          cu()
          return false, de
        end
        w.pending, w.active = false, true
        q.watch.coverCommit = nil
        q.watch.hideTrail = nil
        q.watch.localAnchor = nil
        q.stats.coverStatus = "whole-body-hidden"
        q.stats.hideTravel = "tween"
        q.stats.coverBehindMachine = c1.behindMachine == true
        cI("whole-body-hide")
        cF()
        m.status("Hidden · feet and body inside " .. c1.object.Name)
        if m.coverDamageHandled then
          m.coverDamageHandled()
        end
        return true, "whole-body-hidden"
      end
      if m.options.wallCenterHiding then
        m.stopInteraction()
        if m.releaseExtraction then
          m.releaseExtraction("wall-center-hide")
        end
        if not c1.part or not c1.part.Parent then
          return false, "wall-removed"
        end
        local c8 = bq(c1.part.Position)
        if c8 then
          return false, c8.reason
        end
        if m.options.hideTween and m.hazards and not m.hazards.segmentClear(c7.Position, c1.part.Position) then
          return false, "attack-on-hide-route"
        end
        w.entry, w.part, w.position = c7.Position, c1.part, c1.part.Position
        w.kind, w.floor, w.character = "wall", m.room(), c5
        w.pending, w.active, y = true, false, true
        w.leaving = false
        local c9, da = m.setTemporaryNoclip(true)
        if c9 == false then
          cu()
          return false, da
        end
        if not aZ(c3) then
          cu()
          return false, "cancelled"
        end
        if m.options.hideTween then
          c7.Anchored = false
          local db = math.max(0.08, (w.position - c7.Position).Magnitude / math.clamp(m.options.tweenSpeed or 30, 12, 30))
          local de = q.makeTween(c7, TweenInfo.new(db, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = CFrame.new(w.position) * c7.CFrame.Rotation})
          D = de
          E = "tween"
          q.stats.motionMode = "tween"
          ab = true
          q.stats.hideTravel = "tween"
          q.stats.hideTweens = (q.stats.hideTweens or 0) + 1
          de:Play()
          local df = os.clock() + db + 0.5
          while aZ(c3) and os.clock() < df do
            if m.character() ~= c5 or m.room() ~= w.floor or not c1.part.Parent then
              break
            end
            c7.Anchored = false
            if bq(c7.Position) then
              break
            end
            if de.PlaybackState == Enum.PlaybackState.Completed then
              break
            end
            if de.PlaybackState == Enum.PlaybackState.Cancelled then
              break
            end
            p.Heartbeat:Wait()
          end
          local dg = aZ(c3) and m.character() == c5 and m.room() == w.floor and de.PlaybackState == Enum.PlaybackState.Completed and (c7.Position - w.position).Magnitude < 3.5
          if not dg then
            de:Cancel()
            D = nil
            E = nil
            q.stats.motionMode = nil
            cu()
            return false, "hide-tween-interrupted"
          end
          D = nil
          E = nil
          q.stats.motionMode = nil
          q.stats.segments += 1
        else
          q.stats.hideTravel = "teleport"
          q.stats.teleportAttempts += 1
          q.stats.teleports += 1
        end
        c7.CFrame = CFrame.new(w.position) * c7.CFrame.Rotation
        c7.AssemblyLinearVelocity = aK
        w.active, w.pending = true, false
        cI("wall-center-hide")
        cF()
        q.stats.coverStatus = "wall-center"
        m.status("Hidden · centered inside wall")
        return true, "wall-center-hidden"
      end
      local c8 = m.options.controlMode ~= "self" and q.sproutThreat()
      if c8 then
        return cB(c3, c8)
      end
      if c1.kind ~= "wall" or not cl(c1.part, c1.position) then
        return false, "not-solid-interior-cover"
      end
      local c9 = bq(c1.position)
      if c9 then
        return false, c9.reason
      end
      if not bO(c1.position, c1.position, nil, false) then
        return false, "unsupported-cover-position"
      end
      if aR(c1.position) then
        return false, "unsafe-cover-machine-or-stairs"
      end
      w.entry, w.part, w.position = c7.Position, c1.part, c1.position
      w.kind = c1.kind or "wall"
      w.floor, w.character = m.room(), c5
      w.pending, w.active, y = true, false, true
      w.leaving = false
      w.waitingForExit = false
      local da, db = m.setTemporaryNoclip(true)
      if da == false then
        cu()
        return false, db or "noclip-unavailable"
      end
      if not aZ(c3) then
        return false, "cancelled"
      end
      local de, df
      if (m.options.controlMode ~= "self" and m.options.teleportHiding ~= true) or m.options.farmMode == "extreme" or (c4 or m.options.hideMode) == "tween" or not ar() then
        m.status("Tweening directly into solid cover")
        de, df = b4(c1.position, 0.6, true, c3)
      else
        m.status("Teleporting inside the closest safe wall or prop")
        de, df = cy(c1.position, c3, w.kind == "wall")
      end
      local dg, dh, di = a0()
      if not de then
        w.active = di ~= nil and cl(c1.part, di.Position)
        if not w.active then
          cu()
        end
        return false, df
      end
      if not di or not cl(c1.part, di.Position) then
        cu()
        return false, "cover-entry-incomplete"
      end
      w.active, w.pending = true, false
      cI("hide-arrival")
      cF()
      q.stats.coverStatus = "hidden"
      m.status("Hidden · checking the return area")
      local dj = os.clock() + 0.25
      while aZ(c3) and os.clock() < dj do
        local dk, dl, dm = a0()
        if dk ~= c5 or not dm then
          return false, "character-changed"
        end
        if m.room() ~= w.floor then
          cu()
          return false, "floor-changed"
        end
        if not cl(w.part, dm.Position) then
          cu()
          return false, "cover-entry-incomplete"
        end
        c9 = bq(dm.Position)
        if c9 then
          return false, c9.reason
        end
        local dn = true
        for dp, dq in ipairs(bb()) do
          if dq.stationary then
            if aY(dm.Position, dq.position) <= dq.killRadius + 6 then
              dn = false
              break
            end
            continue
          end
          local ds = aY(dm.Position, dq.position) < dq.visionRadius + 10
          local dt = bd(dq, dm.Position)
          local du = dt and cm(dq) or dq.killRadius + 8 + aM(dq)
          if aY(dm.Position, dq.position) <= du or (ds and not dt) then
            dn = false
            break
          end
        end
        if not dn then
          q.stats.coverStatus = "hiding-spot-compromised"
          cu()
          return false, "hiding-spot-compromised"
        end
        task.wait(0.05)
      end
      if not aZ(c3) then
        return false, "cancelled"
      end
      if w.active then
        Z = nil
      end
      return true, "hidden"
    end
    local function c1(c3, c4, c5)
      local c7 = q.watch.coverFailure
      if c7 and c7.floor == m.room() and c7.character == m.character() and os.clock() - c7.at < 0.9 and aY(c3, c7.origin) < 6 then
        q.stats.coverSearchCooldowns = (q.stats.coverSearchCooldowns or 0) + 1
        return false, "shelter-search-cooldown"
      end
      local c8 = q.coverSearchBudget(c4)
      local c9, da = {}, {}
      local db = "no-safe-hiding-spot"
      local function de(df)
        table.insert(c9, df)
        da[df.part] = true
        q.stats.lastHideDistance = aY(c3, df.position)
        q.stats.coverEntryAttempts = (q.stats.coverEntryAttempts or 0) + 1
        local dh, di = c0(df, c4)
        if not dh and di ~= "cancelled" then
          if di == "body-does-not-fit-cover" then
            df.rejectedUntil = os.clock() + 1
          elseif not m.options.fullBodyHiding then
            q.watch.rejectedWalls[df.part] = os.clock() + 0.5
          end
        end
        db = di
        q.stats.lastRetreatReason = di
        local dj = dh or w.active or not aZ(c4) or di == "floor-changed" or di == "character-changed" or di == "untracked-threat" or di == "root-anchored" or di == "extraction-release-pending" or di == "cover-approach-progress"
        return dj, dh, di
      end
      local df = q.watch.coverCommit
      if m.options.fullBodyHiding and df and df.floor == m.room() then
        local dh = df.candidate
        if dh.object.Parent and aY(c3, dh.position) <= s and q.geometry and q.geometry.contains(dh, dh.cframe, true) then
          local di = q.planCoverApproach(c3, dh)
          if di then
            local dj, dk, dl = de(dh)
            if dj then
              return dk, dl
            end
          end
        end
      end
      local dh = cA(c3, nil, nil, c5, c8, c4)
      if not dh and not c5 and q.chaseThreat() then
        c5 = true
        dh = cA(c3, nil, nil, true, c8, c4)
      end
      if not dh then
        q.watch.coverFailure = {floor = m.room(), character = m.character(), at = os.clock(), origin = c3}
        if m.options.wallJukeFallback and q.jukeThroughWall then
          return q.jukeThroughWall(c4)
        end
        return false, db
      end
      local di, dj, dk = de(dh)
      if di then
        return dj, dk
      end
      local dl = q.chaseThreat() or q.detectedThreat()
      if m.options.wallJukeFallback and dl and aY(c3, dl.position) < dl.killRadius + 18 then
        q.stats.urgentWallFallback = true
        return q.jukeThroughWall(c4)
      end
      local dm = cA(c3, nil, true, c5, c8, c4) or {}
      table.sort(dm, function(dn, dp)
        return (dn.approachScore or aY(c3, dn.position)) < (dp.approachScore or aY(c3, dp.position))
      end)
      for dn = 1, 2 do
        for dp, dq in ipairs(dm) do
          if #c9 >= 3 or not aZ(c4) then
            break
          end
          if dn == 1 and da[dq.part] or dn == 2 and not da[dq.part] then
            continue
          end
          local ds = false
          for dt, du in ipairs(c9) do
            if du.part == dq.part and du.fitMode == dq.fitMode and du.quarterTurn == dq.quarterTurn and aY(du.position, dq.position) < 1.5 then
              ds = true
              break
            end
          end
          if ds then
            continue
          end
          if aY(c3, dq.position) > s then
            continue
          end
          di, dj, dk = de(dq)
          if di then
            return dj, dk
          end
        end
      end
      q.watch.coverFailure = {floor = m.room(), character = m.character(), at = os.clock(), origin = c3}
      if m.options.wallJukeFallback and q.jukeThroughWall then
        return q.jukeThroughWall(c4)
      end
      return false, db
    end
    q.enterNearbyCover = c1
    function q.jukeThroughWall(c3, c4)
      local c5, c7, c8 = a0()
      local c9 = m.room()
      if not c8 or not c9 or not c4 and not aZ(c3) or w.active or w.pending then
        return false, "juke-unavailable"
      end
      local da = bq(c8.Position) or q.chaseThreat() or q.detectedThreat()
      if not c4 and not da and not a_(true) then
        return false, "juke-not-needed"
      end
      local db = c8.Position
      local de = q.watch.jukeHistory
      if not de or de.floor ~= c9 then
        de = {floor = c9, parts = setmetatable({}, {__mode = "k"})}
        q.watch.jukeHistory = de
      end
      if de.failedAt and os.clock() - de.failedAt < 0.9 and de.failedOrigin and aY(db, de.failedOrigin) < 6 then
        q.stats.wallShelterCooldowns = (q.stats.wallShelterCooldowns or 0) + 1
        return false, "wall-shelter-rechecking"
      end
      local df = q.coverSearchBudget(not c4 and c3 or nil)
      local dh = math.min(s, 48)
      local di = {}
      local dj = 6
      for dk, dl in ipairs(bb()) do
        if math.abs(dl.position.Y - db.Y) <= 16 and aY(db, dl.position) < 80 then
          dj = math.max(dj, dl.killRadius + 2 + (dl.lethal and 4 or 0))
        end
      end
      local dk = {walls = 0, tested = 0, groundRejected = 0, visibilityRejected = 0, routeRejected = 0,
        accepted = 0}
      q.stats.wallShelterSearch = dk
      local dl = q.watch.wallPool
      if not dl or dl.floor ~= c9 or os.clock() - dl.at > 2 or aY(db, dl.origin) > 8 then
        local dm
        if n.GetPartBoundsInRadius then
          local dn = OverlapParams.new()
          dn.FilterType = Enum.RaycastFilterType.Include
          dn.FilterDescendantsInstances = {c9}
          dn.RespectCanCollide = true
          dm = n:GetPartBoundsInRadius(db, dh + 8, dn)
        else
          dm = c9:GetDescendants()
        end
        dl = {floor = c9, origin = db, at = os.clock(), parts = dm}
        q.watch.wallPool = dl
        q.stats.wallShelterInventories = (q.stats.wallShelterInventories or 0) + 1
      end
      for dm, dn in ipairs(dl.parts) do
        if not df() then
          break
        end
        if not dn.Parent then
          continue
        end
        if not dn:IsA("BasePart") or not dn.CanCollide or (dn.Transparency or 0) >= 0.95 or dn.Size.Y < 3 or dn.CFrame.UpVector.Y < 0.85 or aQ(dn) or os.clock() < (q.watch.rejectedWalls[dn] or 0) or os.clock() < (de.parts[dn] or 0) then
          continue
        end
        local dp = dn
        local dq = false
        while dp and dp ~= c9 do
          local ds = dp.Name:lower()
          if ds:find("table", 1, true) or ds:find("chair", 1, true) or ds:find("stool", 1, true) or ds:find("desk", 1, true) then
            dq = true
            break
          end
          dp = dp.Parent
        end
        if dq then
          continue
        end
        local ds = dn.Size
        local dt = ds.X < ds.Z and "X" or "Z"
        local du = ds * 0.5
        if du[dt] > 16 or math.max(ds.X, ds.Z) < 3 then
          continue
        end
        local dv = dn.CFrame:PointToObjectSpace(db)
        local dw = dt == "X" and "Z" or "X"
        local dx = math.sqrt(math.max(0, math.abs(dv[dt]) - du[dt]) ^ 2 + math.max(0, math.abs(dv[dw]) - du[dw]) ^ 2)
        if dx > dh or math.abs(dv.Y) > du.Y + 3 then
          continue
        end
        di[#di + 1] = {part = dn, axis = dt, cross = dw, p = dv, half = du, gap = dx}
      end
      table.sort(di, function(dm, dn)
        return dm.gap < dn.gap
      end)
      dk.walls = #di
      local dm = {}
      local function dn(dp, dq)
        if #dm >= 2 then
          return
        end
        if not df() then
          return
        end
        dk.tested += 1
        local ds = bL(Vector3.new(dq.X, db.Y, dq.Z), db.Y)
        if not ds or aY(db, ds) > dh or cw(ds) or not bO(db, ds, nil, nil, df) or not aT(db, ds) then
          dk.groundRejected += 1
          return
        end
        local dt = CFrame.new(ds) * c8.CFrame.Rotation
        local du, dv = q.wallShelterClear(dp.part, ds, dt)
        if not du then
          dk.visibilityRejected += 1
          dk.lastRejected = dv
          return
        end
        local dw = aX(ds - db)
        if dw.Magnitude > 2 and de.direction and os.clock() - (de.at or 0) < 3 and dw.Unit:Dot(de.direction) < -0.25 then
          return
        end
        dm[#dm + 1] = {part = dp.part, object = dp.part, position = ds, cframe = dt, kind = "occluded-wall",
          score = dw.Magnitude}
      end
      for dp = 1, math.min(12, #di) do
        if not df() then
          break
        end
        local dq = di[dp]
        local ds, dt, du, dv = dq.p, dq.half, dq.axis, dq.cross
        if dq.gap < 8 then
          dn(dq, db)
        end
        for dw, dx in ipairs({ds[du] >= 0 and -1 or 1, ds[du] >= 0 and 1 or -1}) do
          for dy, dz in ipairs({0, -6, 6}) do
            local dA = dx * (dt[du] + dj)
            local dB = math.clamp(ds[dv] + dz, -dt[dv] + 0.5, dt[dv] - 0.5)
            dn(dq, dq.part.CFrame:PointToWorldSpace(du == "X" and Vector3.new(dA, ds.Y, dB) or Vector3.new(dB, ds.Y, dA)))
          end
        end
        if #dm >= 2 then
          break
        end
      end
      table.sort(dm, function(dp, dq)
        return dp.score < dq.score
      end)
      dk.accepted = #dm
      if c4 then
        return dm, dk
      end
      df = q.coverSearchBudget(c3)
      for dp = 1, math.min(2, #dm) do
        if not df() then
          break
        end
        local dq = dm[dp]
        dq.searchCheckpoint = df
        local ds = q.planCoverApproach(c8.Position, dq)
        dq.searchCheckpoint = nil
        if not ds then
          dk.routeRejected += 1
          continue
        end
        if m.setTemporaryNoclip and m.setTemporaryNoclip(true) == false then
          return false, "noclip-unavailable"
        end
        z, A, B, C = true, c8.Position, c9, c5
        local dt = c8.Position
        w.entry, w.returnRotation = dt, c8.CFrame.Rotation
        w.part, w.position, w.cframe = dq.part, dq.position, dq.cframe
        w.geometry, w.geometryController = nil, nil
        w.kind, w.floor, w.character = "occluded-wall", c9, c5
        w.active, w.pending, w.leaving, y = false, true, false, true
        q.stats.collisionSuppression = true
        m.status("Taking cover on the far side of a nearby wall")
        local du, dv = true, nil
        for dw = 2, #ds do
          if aY(c8.Position, ds[dw]) > 0.5 then
            du, dv = b4(ds[dw], 0.6, true, c3)
          end
          if not du then
            break
          end
        end
        if du and q.wallShelterClear(dq.part, c8.Position, c8.CFrame) then
          w.position, w.cframe = c8.Position, c8.CFrame
          w.active, w.pending = true, false
          de.failedAt = nil
          local dw = aX(c8.Position - dt)
          if dw.Magnitude > 1 then
            de.direction, de.at = dw.Unit, os.clock()
            q.stats.wallJukes = (q.stats.wallJukes or 0) + 1
          end
          q.stats.wallShelters = (q.stats.wallShelters or 0) + 1
          q.stats.wallJukePart = dq.part:GetFullName()
          q.stats.coverStatus = "hidden-behind-wall"
          q.stats.recoveryMode = "grounded-wall-shelter"
          cI("occluded-wall-shelter")
          cF()
          Z = nil
          m.status("Hidden behind wall · keeping the current target")
          if m.coverDamageHandled then
            m.coverDamageHandled()
          end
          return true, "wall-shelter-hidden"
        end
        cu()
        dk.routeRejected += 1
        if dv == "cancelled" or dv == "character-changed" or dv == "floor-changed" or dv == "extraction-release-pending" or dv == "machine-release-pending" then
          return false, dv
        end
        de.parts[dq.part] = os.clock() + 1
      end
      de.failedAt, de.failedOrigin = os.clock(), c8.Position
      return false, "no-supported-wall-shelter"
    end
    function q.shortEscapeClear(c3, c4, c5)
      local c7 = math.huge
      local c8 = (c4 - c3).Magnitude / math.max(1, H(nil, true))
      for c9, da in ipairs(c5 or bb()) do
        if math.abs(da.position.Y - c4.Y) > 16 then
          continue
        end
        local db = aX(c3 - da.position)
        local de = aX(c4 - c3) / math.max(0.01, c8) - aX(da.velocity)
        local df = de:Dot(de)
        local dh = df > 0.001 and math.clamp(-db:Dot(de) / df, 0, c8) or 0
        local di = (db + de * dh).Magnitude
        local dj = da.killRadius + (da.lethal and 4 or 1.5)
        if di < dj and (di < db.Magnitude - 0.05 or aY(c4, da.position) <= db.Magnitude + 0.2) then
          return false
        end
        c7 = math.min(c7, di - da.killRadius)
      end
      return not aG, c7
    end
    function q.shortEscape(c3)
      local c4, c5, c7 = a0()
      local c8 = m.room()
      if not c7 or not aZ(c3) or w.active or w.pending then
        return false, "escape-unavailable"
      end
      local c9 = bq(c7.Position) or q.chaseThreat() or q.detectedThreat()
      if not c9 then
        return false, "escape-not-needed"
      end
      local da = c7.Position
      local db = q.watch.shortEscape
      if db and db.floor == c8 and os.clock() - db.at < 0.15 and aY(da, db.origin) < 1 then
        return false, "escape-rechecking"
      end
      local de = aX(da - c9.position)
      if de.Magnitude < 0.1 then
        de = Vector3.new(1, 0, 0)
      end
      de = de.Unit
      local df = bb()
      local dh, di
      local dj = q.coverSearchBudget(c3)
      for dk, dl in ipairs({0, math.pi / 4, -math.pi / 4, math.pi / 2, -math.pi / 2, math.pi * 0.75, -math.pi * 0.75,
          math.pi}) do
        if not dj() then
          break
        end
        local dm = Vector3.new(de.X * math.cos(dl) - de.Z * math.sin(dl), 0, de.X * math.sin(dl) + de.Z * math.cos(dl))
        if db and db.floor == c8 and db.direction and os.clock() - db.at < 2 and dm:Dot(db.direction) < -0.25 then
          continue
        end
        local dn = c9.hazard and math.clamp(c9.killRadius - aY(da, c9.position) + 4, 12, 24) or 20
        local dp = bL(da + dm * dn, da.Y)
        if not dp or cw(dp) or bq(dp) or not aT(da, dp) or not bO(da, dp, nil, nil, dj) then
          continue
        end
        local dq, ds = q.shortEscapeClear(da, dp, df)
        if dq then
          local dt = math.min(ds, 50) + (db and db.direction and dm:Dot(db.direction) or 0)
          if not di or dt > di then
            dh, di = dp, dt
          end
        end
      end
      if not dh or not aZ(c3) then
        q.watch.shortEscape = {floor = c8, origin = da, at = os.clock()}
        return false, "no-clear-short-escape"
      end
      if m.setTemporaryNoclip and m.setTemporaryNoclip(true) == false then
        return false, "noclip-unavailable"
      end
      z, A, B, C = true, da, c8, c4
      q.watch.shortEscape = {floor = c8, origin = da, at = os.clock(), direction = aX(dh - da).Unit}
      m.status("Shelter unavailable · taking a short escape; keeping the current target")
      local dk = ab
      ab = true
      local dl = q.makeTween(c7, TweenInfo.new(math.max(0.08, (dh - da).Magnitude / math.max(1, H(nil, true))), Enum.EasingStyle.Linear), {CFrame = CFrame.new(dh) * c7.CFrame.Rotation})
      D = dl
      E = "tween"
      dl:Play()
      local dm, dn = os.clock() + math.max(0.6, (dh - da).Magnitude / math.max(1, H(nil, true)) + 0.25), 0
      while aZ(c3) and m.room() == c8 and m.character() == c4 and os.clock() < dm and dl.PlaybackState == Enum.PlaybackState.Playing do
        if os.clock() >= dn then
          dn = os.clock() + 0.04
          if not q.shortEscapeClear(c7.Position, dh) or not aT(c7.Position, dh) or bq(dh) then
            dl:Cancel()
            break
          end
        end
        c7.AssemblyLinearVelocity = aK
        p.Heartbeat:Wait()
      end
      local dp = dl.PlaybackState == Enum.PlaybackState.Completed
      if not dp then
        dl:Cancel()
      end
      D = nil
      E = nil
      ab = dk
      local dq = aY(da, c7.Position) > 1
      if dq then
        q.stats.shortEscapes = (q.stats.shortEscapes or 0) + 1
      end
      return dq, dp and "short-escape-progress" or q.stats.groundBlock or "short-escape-interrupted"
    end
    function q.avoidRollingPumpkin(c3, c4)
      local c5, c7, c8 = a0()
      local c9 = m.room()
      local da = m.hazards
      if not c8 or not c9 or not da or not da.pumpkinEscapeCandidates then
        return false, "pumpkin-escape-unavailable"
      end
      m.stopInteraction()
      a4()
      cu()
      if m.setTemporaryNoclip and m.setTemporaryNoclip(true) == false then
        return false, "noclip-unavailable"
      end
      z, A, B, C = true, c8.Position, c9, c5
      local db = ab
      ab = true
      q.stats.pumpkinDodging = true
      q.stats.pumpkinEpisodes = (q.stats.pumpkinEpisodes or 0) + 1
      local de, df, dh = nil, 0, nil
      local di = "pumpkin-cleared"
      while aZ(c3) and m.room() == c9 and m.character() == c5 do
        if m.machinesFinished and m.machinesFinished() then
          break
        end
        local dj = q.rollingPumpkinThreat()
        if not dj then
          dh = dh or os.clock()
          if os.clock() - dh >= 0.8 then
            break
          end
          m.status("Pumpkin safety · waiting for the burst to clear")
          p.Heartbeat:Wait()
          continue
        end
        dh = nil
        local dk = math.max(dj.size.X, dj.size.Z) * 0.5
        local dl = aX(c8.Position - dj.cf.Position).Magnitude
        local dm = da.pumpkinDangerAt(c8.Position)
        if dl >= dk + 46 and not dm then
          m.status("Pumpkin safety · keeping distance until it bursts")
          p.Heartbeat:Wait()
          continue
        end
        if os.clock() < df then
          p.Heartbeat:Wait()
          continue
        end
        df = os.clock() + 0.2
        local dn = c8.Position
        local dp, dq
        local ds = math.max(1, H(nil, true))
        local dt = bb()
        local du = q.coverSearchBudget(c3)
        for dv, dw in ipairs(da.pumpkinEscapeCandidates(dn, dj)) do
          if not du() then
            break
          end
          local dx = bL(dw, dn.Y)
          if not dx or q.recoveryElevatorContains(dx, 1) and not (m.machinesFinished and m.machinesFinished()) or not bO(dn, dx, nil, nil, du) or not da.pumpkinEscapeClear(dn, dx, ds) or da.pumpkinDangerAt(dx) then
            continue
          end
          local dy, dz = q.shortEscapeClear(dn, dx, dt)
          local dA = aX(dx - dn)
          if dy and dA.Magnitude > 1 then
            local dB = de and de:Dot(dA.Unit) or 0
            local dC = math.min(dz, 60) + dB * 30 - dA.Magnitude * 0.15
            if not dq or dC > dq then
              dp, dq = dx, dC
            end
          end
        end
        if not aZ(c3) then
          break
        end
        if not dp then
          q.stats.pumpkinBlocked = (q.stats.pumpkinBlocked or 0) + 1
          m.status("Pumpkin safety · checking supported escape directions")
          p.Heartbeat:Wait()
          continue
        end
        de = aX(dp - dn).Unit
        q.stats.pumpkinEscapeTarget = tostring(dp)
        m.status("Pumpkin safety · tweening out of its path")
        local dv = (dp - dn).Magnitude / ds
        local dw = q.makeTween(c8, TweenInfo.new(math.max(0.08, dv), Enum.EasingStyle.Linear), {CFrame = CFrame.new(dp) * c8.CFrame.Rotation})
        D = dw
        E = "tween"
        dw:Play()
        local dx, dy = os.clock() + dv + 0.4, 0
        while aZ(c3) and m.room() == c9 and m.character() == c5 and os.clock() < dx and dw.PlaybackState == Enum.PlaybackState.Playing do
          if os.clock() >= dy then
            dy = os.clock() + 0.06
            if not da.pumpkinEscapeClear(c8.Position, dp, ds) or not q.shortEscapeClear(c8.Position, dp) then
              dw:Cancel()
              break
            end
          end
          c8.AssemblyLinearVelocity = aK
          p.Heartbeat:Wait()
        end
        if dw.PlaybackState ~= Enum.PlaybackState.Completed then
          dw:Cancel()
        end
        D = nil
        E = nil
        if aY(dn, c8.Position) > 1 then
          q.stats.pumpkinDodges = (q.stats.pumpkinDodges or 0) + 1
        end
      end
      if not aZ(c3) then
        di = "cancelled"
      end
      q.stats.pumpkinDodging = false
      ab = db
      return di == "pumpkin-cleared", di
    end
    function q.localSafetyStep(c3)
      if m.options.fullBodyHiding then
        if m.options.wallJukeFallback then
          local c4, c5 = q.jukeThroughWall(c3)
          if c4 or w.active or not aZ(c3) then
            return c4, c5
          end
          return q.shortEscape(c3)
        end
        q.stats.recoveryMode = "verified-cover-route-only"
        return false
      end
      local c4, c5, c7 = a0()
      if not c7 or not aZ(c3) then
        return false
      end
      local c8 = bb()
      local c9 = math.huge
      for da, db in ipairs(c8) do
        c9 = math.min(c9, aY(c7.Position, db.position))
      end
      if c9 > 35 and not a_(false) then
        return false
      end
      local da = c7.Position
      if q.watch.localFloor ~= m.room() or not q.watch.localAnchor or aY(da, q.watch.localAnchor) > 16 then
        q.watch.localAnchor = da
        q.watch.localFloor = m.room()
      end
      local db, de
      for df = 0, 11 do
        local dh = da + Vector3.new(math.cos(df * math.pi / 6), 0, math.sin(df * math.pi / 6)) * 6
        local di = bL(dh, da.Y)
        if not di or aY(di, q.watch.localAnchor) > 14 or bq(di) then
          continue
        end
        if m.hazards and not m.hazards.segmentClear(da, di) then
          continue
        end
        local dj = math.huge
        local dk = 0
        for dl, dm in ipairs(c8) do
          if math.abs(dm.position.Y - di.Y) > 16 then
            continue
          end
          local dn = dm.position + dm.velocity * 0.25
          dj = math.min(dj, aY(di, dn) - dm.killRadius)
          if not ba(dn + aL, di + aL) then
            dk += 1
          end
        end
        local dl = math.min(dj, 50) + dk * 20 - aY(di, q.watch.localAnchor) * 0.15
        if not de or dl > de then
          db, de = di, dl
        end
      end
      if not db then
        return false
      end
      local df = m.setTemporaryNoclip(true)
      if df == false then
        return false
      end
      z, A, B, C = true, da, m.room(), c4
      ab = true
      m.status("Cover entry blocked · moving a short step out of reach")
      local dh = q.makeTween(c7, TweenInfo.new(math.max(0.08, (db - da).Magnitude / 30), Enum.EasingStyle.Linear), {CFrame = CFrame.new(db) * c7.CFrame.Rotation})
      D = dh
      E = "tween"
      q.stats.motionMode = "tween"
      dh:Play()
      local di = os.clock() + 0.5
      while aZ(c3) and os.clock() < di and dh.PlaybackState == Enum.PlaybackState.Playing do
        c7.AssemblyLinearVelocity = aK
        p.Heartbeat:Wait()
      end
      if dh.PlaybackState ~= Enum.PlaybackState.Completed then
        dh:Cancel()
        return false
      end
      q.stats.localSafetySteps = (q.stats.localSafetySteps or 0) + 1
      return true
    end
    local function c3(c4)
      if bq(c4) then
        return false
      end
      if aU(c4) or not bL(c4, c4.Y) then
        return false
      end
      local c5 = bb()
      if aG then
        return false
      end
      for c7, c8 in ipairs(c5) do
        if math.abs(c4.Y - c8.position.Y) > 16 then
          continue
        end
        local c9 = c8.stationary and c8.killRadius + 7 or c8.killRadius + 10 + aM(c8)
        if bc(c4, c8, 1.2) <= c9 then
          return false
        end
        if not c8.stationary and aY(c4, c8.position) <= c8.visionRadius + 25 + aM(c8) and not bd(c8, c4) then
          return false
        end
      end
      return true
    end
    ai = function(c4, c5, c7)
      if (c5 - c4).Magnitude > 32.01 or math.abs(c5.Y - c4.Y) > 4 or not bO(c4, c5) then
        return false
      end
      if m.hazards and not m.hazards.segmentClear(c4, c5) then
        return false
      end
      local c8 = bb()
      if aG then
        return false
      end
      local c9 = math.max(1, math.ceil((c5 - c4).Magnitude / 3))
      for da = 0, c9 do
        local db = c4:Lerp(c5, da / c9)
        for de, df in ipairs(c8) do
          if math.abs(db.Y - df.position.Y) > 16 then
            continue
          end
          local dh = df.stationary and df.killRadius + 7 or df.killRadius + 10 + aM(df)
          local di = bc(db, df, 0.8)
          if di <= dh then
            local dj = not df.stationary and bR(c4, c5, df) and di >= bc(c4, df, 0.8) - 0.2
            if not dj then
              return false
            end
          end
          if not c7 and not df.stationary and aY(db, df.position) <= df.visionRadius + 25 + aM(df) and not bd(df, db) then
            return false
          end
        end
      end
      return true
    end
    local function c4(c5, c7)
      local c8, c9, da = a0()
      if not da then
        return nil
      end
      local db = da.Position
      if typeof(c5) ~= "Vector3" then
        c5 = db
      end
      if not aj or (aj - c5).Magnitude > 3 then
        aj, ak = c5, {db}
      end
      local de = cA(db, c5, true)
      local df = {{position = db}}
      table.sort(de, function(dh, di)
        return aY(dh.position, c5) + aY(db, dh.position) * 0.2 < aY(di.position, c5) + aY(db, di.position) * 0.2
      end)
      for dh, di in ipairs(de) do
        local dj = (di.position - db).Magnitude
        local dk = false
        for dl, dm in ipairs(ak) do
          if aY(dm, di.position) < 5 then
            dk = true
            break
          end
        end
        local dl = di.kind == "wall" and cl(di.part, di.position)
        if dl and dj >= 5 and not dk and (not c7 or dj >= 12) and c3(di.position) then
          table.insert(df, di)
          if #df >= 49 then
            break
          end
        end
      end
      local dh = m.options.controlMode == "self" and m.options.farmMode ~= "extreme" and m.options.hideMode ~= "tween" and ar()
      local di, dj, dk = {[1] = 0}, {}, {}
      local dl, dm = nil, math.huge
      local dn = aY(db, c5)
      local dp = os.clock()
      local dq = 0
      for ds = 1, #df do
        local dt, du = nil, math.huge
        for dv, dw in pairs(di) do
          if not dk[dv] and dw < du then
            dt, du = dv, dw
          end
        end
        if not dt then
          break
        end
        dk[dt] = true
        if dt > 1 then
          local dv = aY(df[dt].position, c5)
          local dw = c7 and du or dv + du * 0.25
          if (c7 or dv <= dn - 4) and dw < dm then
            dl, dm = dt, dw
          end
          if c7 then
            break
          end
        end
        for dv = 2, #df do
          local dw = (df[dt].position - df[dv].position).Magnitude
          if dk[dv] or dw < 3 or dw > 32 or di[dv] and di[dv] <= du + dw then
            continue
          end
          dq += 1
          if ai(df[dt].position, df[dv].position, dh) then
            di[dv] = du + dw
            dj[dv] = dt
            local dx = aY(df[dv].position, c5)
            local dy = c7 and di[dv] or dx + di[dv] * 0.25
            if (c7 or dx <= dn - 4) and dy < dm then
              dl, dm = dv, dy
            end
          end
          if dq >= 220 or os.clock() - dp > 0.14 then
            break
          end
        end
        if dq >= 220 or os.clock() - dp > 0.14 then
          break
        end
      end
      q.stats.coverHopSearchChecks = dq
      if not dl then
        return nil
      end
      while dj[dl] and dj[dl] ~= 1 do
        dl = dj[dl]
      end
      return df[dl], dh
    end
    cC = function(c5, c7, c9)
      if q.sproutThreat() then
        return false, "sprout-detected"
      end
      if not aZ(c7) then
        return false, "cancelled"
      end
      if os.clock() < al then
        return false, "cover-hop-retry"
      end
      local da, db, de = a0()
      if not de then
        return false, "no-character"
      end
      local df, dh = c4(c5, c9)
      if not df then
        al = os.clock() + 0.35
        q.stats.coverHopReason = "no-supported-hidden-hop"
        return false, "no-hidden-hop"
      end
      local di = table.clone(w)
      local dj = de.Position
      local dk = m.room()
      m.stopInteraction()
      a4()
      w.leaving = true
      ab = true
      ae = true
      am("hop", c9 and "new-damage-in-cover" or "approach-from-outside")
      m.status(c9 and "Damaged in cover · moving to different cover" or "Cover hop · advancing toward the generator")
      local dl, dm
      if dh then
        dl, dm = cy(df.position, c7, df.kind == "wall", true, "cover-hop", c3)
      else
        dl, dm = true, "cover-hop-tweened"
        local dn = os.clock() + 4
        while aZ(c7) and os.clock() < dn and (de.Position - df.position).Magnitude > 0.6 do
          local dp = df.position - de.Position
          local dq = de.Position + dp * math.min(1, 8 / math.max(dp.Magnitude, 0.01))
          if not ai(de.Position, dq, false) then
            dl, dm = false, "cover-hop-exposed"
            break
          end
          local ds = de.Position
          dl, dm = b3(da, de, dq, true, c7, dk, math.max(ds.Y, dq.Y))
          if not dl then
            break
          end
          q.stats.segments += 1
          Q += 1
          if b1(ds, dq, de.Position) then
            b0()
            dl, dm = false, "server-correction"
            break
          end
        end
        if not aZ(c7) then
          dl, dm = false, "cancelled"
        elseif (de.Position - df.position).Magnitude > 0.8 then
          dl, dm = false, dm or "cover-hop-incomplete"
        end
      end
      ae = false
      ab = false
      w.leaving = false
      local dn, dp, dq = a0()
      if dn ~= da or not dq or m.room() ~= dk then
        cu()
        return false, "character-or-floor-changed"
      end
      local ds = false
      if df.kind == "wall" and df.part and df.part.Parent then
        local dt = df.part.CFrame:PointToObjectSpace(dq.Position)
        local du = df.part.Size * 0.5
        ds = math.abs(dt.X) < du.X and math.abs(dt.Y) < du.Y and math.abs(dt.Z) < du.Z
      end
      if cl(df.part, dq.Position) and ((dq.Position - df.position).Magnitude <= 2.5 or ds) then
        w.entry, w.part, w.position = dj, df.part, dq.Position
        w.kind, w.floor, w.character = df.kind, dk, da
        w.active, w.pending, y = true, false, true
        w.clearSince, w.returnDestination = nil, nil
        cI(c9 and "damage-relocation-arrival" or "approach-arrival")
      else
        for dt in pairs(w) do
          w[dt] = nil
        end
        for dt, du in pairs(di) do
          w[dt] = du
        end
        w.leaving = false
        if not cr(dq.Position) then
          cu()
        end
      end
      al = os.clock() + (dl and 0.08 or 0.5)
      q.stats.coverHopReason = dm
      if not dl then
        return false, dm
      end
      table.insert(ak, dj)
      q.stats.coverHops = (q.stats.coverHops or 0) + 1
      if c9 then
        q.stats.damageCoverMoves = (q.stats.damageCoverMoves or 0) + 1
      end
      q.stats.coverStatus = "hopped-to-hidden-spot"
      Z = nil
      return true, "cover-hopped"
    end
    function q.stuckSnapshot()
      local c5, c7, c9 = a0()
      local da = n:FindFirstChild("Info")
      local de = da and da:FindFirstChild("Loading")
      local df = c5 and c5:FindFirstChild("Decoding")
      local dh = c5 and c5:FindFirstChild("Stats")
      local di = dh and dh:FindFirstChild("InElevator")
      return {enabled = m.options.stuckElevatorReset ~= false and m.options.controlMode ~= "self" and m.alive(),
        ready = m.recoveryReady and m.recoveryReady() or false, floor = m.room(), actor = c5, position = c9 and c9.Position,
        finished = m.machinesFinished and m.machinesFinished(), loading = de and de.Value, working = df and df.Value or m.activity and m.activity() == "machine",
        releasing = m.releasePending and m.releasePending(), anchored = c9 and c9.Anchored, covered = w.active and not w.leaving and q.stableCover(),
        pendingCover = w.pending, grabbed = m.grabbed and m.grabbed(), activity = m.activity and m.activity(),
        inElevator = di and di.Value or c9 and q.recoveryElevatorContains and q.recoveryElevatorContains(c9.Position, 1)}
    end
    function q.noteStuckBlock(c5)
      if not m.stuckResetFactory then
        return
      end
      if not q.stuckReset then
        q.stuckReset = m.stuckResetFactory({clock = os.clock, distance = function(c7, c9)
          return (c7 - c9).Magnitude
        end})
        q.stats.stuckReset = q.stuckReset.stats
      end
      q.stuckReset.noteBlock(c5, q.stuckSnapshot())
    end
    local function c5(c7, c9)
      if Y or not m.alive() then
        return false, "cancelled"
      end
      if q.watch.rescueReason and not c9 then
        return false, "recovery-pending"
      end
      if X then
        return false, "movement-busy"
      end
      X = true
      q.movementOwned = true
      q.stats.lastBlock, q.stats.lastReason = nil, nil
      W += 1
      local da = W
      local de, df, dh, di = pcall(function()
        local de = c9 or m.releaseReady and not m.releaseReady()
        local df = de and m.releaseExtraction and m.releaseExtraction("generator-movement-release")
        local dh = m.releasePending and m.releasePending()
        if dh then
          df = false
        end
        if df then
          q.stats.releaseStatus = "emergency-unlocked"
          q.stats.emergencyReleasedAt = os.clock()
        end
        ac = c9 and (df or m.machineEscapePending and m.machineEscapePending()) or false
        local di, dj, dk = a0()
        if m.options.noclip and m.setTemporaryNoclip and dk then
          local dl, dm = m.setTemporaryNoclip(true)
          if dl == false then
            return false, dm or "noclip-unavailable"
          end
          z, A, B, C = true, dk.Position, m.room(), di
          q.stats.collisionSuppression = true
        end
        local dl = di and di:FindFirstChild("Decoding")
        if c9 and m.options.wallCenterHiding and not dh then
          m.stopInteraction()
          if dk and dk.Anchored and dk ~= t then
            dk.Anchored = false
          end
        elseif dh or (not df and dl and dl.Value) or (dk and dk.Anchored and dk ~= t) then
          m.stopInteraction()
          local dm = os.clock() + 1.5
          q.stats.releaseStatus = "waiting-for-native-release"
          while aZ(da) do
            local dn, dp, dq = a0()
            if m.releaseStep then
              m.releaseStep()
            end
            if dn ~= di or not dq then
              return false, "character-changed"
            end
            if (not dq.Anchored or dq == t) and (not dl or not dl.Parent or not dl.Value) and not (m.releasePending and m.releasePending()) then
              break
            end
            if os.clock() >= dm then
              q.stats.releaseStatus = "release-pending"
              return false, "extraction-release-pending"
            end
            p.Heartbeat:Wait()
          end
          if not aZ(da) then
            return false, "cancelled"
          end
          q.stats.releaseStatus = "released"
        end
        if m.strictGround and not w.active and not w.pending then
          q.prepareTweenAnimations(true)
          q.enforceGround()
        end
        q.enforceRibbonWalk()
        if m.options.wallCenterHiding and w.active and not w.leaving and m.room() == w.floor and w.part and w.part.Parent then
          cF()
        end
        return c7(da)
      end)
      as, at, au = nil, 0, nil
      af = nil
      I = false
      q.stats.travelActive = false
      q.stats.pumpkinDodging = false
      q.stats.chaseEscaping = false
      q.directHeightTravel = false
      ac = false
      a4()
      cx()
      if q.animationLease and m.animations and not w.active and not w.pending then
        m.animations.release()
        q.animationLease = nil
      end
      q.movementOwned = false
      ab = false
      ad = nil
      X = false
      q.stats.machineReturnDetour = false
      if not de then
        q.stats.lastReason = "navigation-error"
        if m.report then
          pcall(m.report, "navigation-error", tostring(df))
        end
        return false, "navigation-error: " .. tostring(df)
      end
      q.stats.lastReason = dh
      if df == false then
        q.noteStuckBlock(dh)
      end
      if df == false and dh and m.report and dh ~= "cancelled" and dh ~= "cover-holding" and dh ~= "movement-busy" then
        pcall(m.report, "movement-blocked", tostring(dh))
      end
      return df, dh, di
    end
    function q.distractionThreats()
      return bb(), aG
    end
    function q.distractionPoint(c7)
      local c9, da, de = a0()
      if not de then
        return nil
      end
      local df = bN(c7, de.Position.Y)
      if df and aY(de.Position, df) > 0.5 and bQ(df) and bO(de.Position, df) and bY(de.Position, df) and aT(de.Position, df) then
        return df
      end
      return nil
    end
    function q.distractionMove(c7, da)
      return c5(function(de)
        m.stopInteraction()
        local df, dh, di = a0()
        if not di or not aZ(de) then
          return false, "cancelled"
        end
        local dj, dk = da(di.Position, c7)
        if not dj then
          return false, dk
        end
        ad = da
        w.leaving = true
        local dl, dm = b3(df, di, c7, true, de, m.room())
        if w.active and not cl(w.part, di.Position) then
          cu()
        end
        w.leaving = false
        return dl, dm
      end)
    end
    cD = function(c7, da)
      if (m.options.returnToGenerator or m.machinesFinished) and not (m.machinesFinished and m.machinesFinished()) then
        return false, "generators-unfinished-stay-near-generator"
      end
      m.stopInteraction()
      a4()
      if m.releaseExtraction then
        m.releaseExtraction(da or "hide-refuge")
      end
      local de = q.elevatorPosition()
      if not de or not aZ(c7) then
        return false, "elevator-unavailable"
      end
      ab = true
      w.leaving = true
      local df, dh
      if m.options.strictElevatorTeleport or ar("elevator") then
        df, dh = cy(de, c7, false, true, "elevator")
      else
        df, dh = b4(de, 1.2, true, c7)
      end
      w.leaving = false
      local di, dj, dk = a0()
      if df and dk and (dk.Position - de).Magnitude <= 3.5 then
        cu()
        Z = nil
        q.stats.refugeTrips = (q.stats.refugeTrips or 0) + 1
        q.stats.coverStatus = "elevator-refuge"
        if m.onRefuge then
          m.onRefuge(m.room(), da)
        end
        m.status("Hidden in the elevator refuge · waiting for a safe machine")
        return true, "elevator-refuge"
      end
      return false, dh or "refuge-arrival-unconfirmed"
    end
    function q.seekRefuge(c7)
      return c5(function(da)
        return cD(da, c7)
      end, true)
    end
    function q.returnToElevator()
      if (m.options.returnToGenerator or m.machinesFinished) and not (m.machinesFinished and m.machinesFinished()) then
        return false, "generators-unfinished-return-to-generator"
      end
      return c5(function(c7)
        m.stopInteraction()
        a4()
        if not aZ(c7) then
          return false, "cancelled"
        end
        local da = q.elevatorPosition()
        if not da then
          return false, "elevator-unavailable"
        end
        q.stats.elevatorThreatChecksSkipped = true
        ab = true
        w.leaving = true
        local de, df
        if m.options.strictElevatorTeleport or ar("elevator") then
          m.status("Teleporting to the elevator")
          q.stats.elevatorMode = "teleport"
          de, df = cy(da, c7, false, true, "elevator")
        else
          m.status("Tweening to the elevator · teleport rejected on this floor")
          q.stats.elevatorMode = "tween"
          de, df = b4(da, 1.2, true, c7)
        end
        w.leaving = false
        if not de then
          return false, df
        end
        local dh, dj, dk = a0()
        if not dk or (dk.Position - da).Magnitude > 3.5 then
          return false, "elevator-arrival-unconfirmed"
        end
        cu()
        Z = nil
        return true, q.stats.elevatorMode == "teleport" and "teleported-to-elevator" or "tweened-to-elevator"
      end, true)
    end
    function q.approachShop(c7, da)
      return c5(function(de)
        if not m.shopAllowed or not m.shopAllowed() then
          return false, "shop-closed"
        end
        local df, dj, dk = a0()
        local dl = n:FindFirstChild("Elevators")
        local dm = dl and dl:FindFirstChild("Elevator")
        local dn = dm and dm:FindFirstChild("Base")
        if not dk or not dn or not dn:IsA("BasePart") or typeof(c7) ~= "Vector3" then
          return false, "shop-position-unavailable"
        end
        local dp = dn.CFrame:PointToObjectSpace(c7)
        local dq = dn.Size * 0.5
        local ds = dn.CFrame:PointToWorldSpace(Vector3.new(math.clamp(dp.X, -math.max(0, dq.X - 2), math.max(0, dq.X - 2)), dq.Y, math.clamp(dp.Z, -math.max(0, dq.Z - 2), math.max(0, dq.Z - 2))))
        local dt = ds + aL * bJ(dj, dk)
        if (dt - c7).Magnitude > da - 0.1 then
          return false, "shop-prompt-unreachable-from-elevator"
        end
        local du = q.safeToInteract(dt, 1, true, true)
        if not du then
          return false, "shop-route-unsafe"
        end
        if dk.Anchored then
          return false, "root-anchored"
        end
        m.stopInteraction()
        a4()
        ab = true
        if m.options.teleportOnly then
          dk.Anchored = false
          local dv, dw = cy(dt, de, false, true, "elevator")
          return dv, dv and "shop-in-range" or dw
        end
        m.status("Dandy: approaching the purchase prompt")
        local dv = (dt - dk.Position).Magnitude / H(df)
        local dw = q.makeTween(dk, TweenInfo.new(math.max(0.05, dv), Enum.EasingStyle.Linear), {CFrame = CFrame.new(dt) * dk.CFrame.Rotation})
        D = dw
        E = "tween"
        q.stats.motionMode = "tween"
        dw:Play()
        local dx = os.clock() + dv + 0.4
        while aZ(de) and os.clock() < dx do
          if not m.shopAllowed() or m.character() ~= df then
            dw:Cancel()
            return false, "shop-closed"
          end
          if dw.PlaybackState == Enum.PlaybackState.Cancelled then
            return false, q.stats.groundBlock or "shop-movement-cancelled"
          end
          if dw.PlaybackState == Enum.PlaybackState.Completed then
            break
          end
          p.Heartbeat:Wait()
        end
        if not aZ(de) then
          return false, "cancelled"
        end
        if dw.PlaybackState ~= Enum.PlaybackState.Completed then
          dw:Cancel()
          return false, "shop-movement-timeout"
        end
        if D == dw then
          D = nil
        end
        q.stats.segments += 1
        if (dk.Position - c7).Magnitude > da then
          return false, "shop-outside-range"
        end
        return true, "shop-in-range"
      end)
    end
    local function c7()
      local da = n:FindFirstChild("Elevators")
      local de = da and da:FindFirstChild("Elevator")
      local df = de and de:FindFirstChild("Base")
      local dj = de and de:FindFirstChild("ElevatorHitBox")
      return de, df and df:IsA("BasePart") and df or nil, dj and dj:IsA("BasePart") and dj or nil
    end
    local function da(de, df)
      local dj, dk, dl = c7()
      local dm = dl or dk
      if not dm then
        return nil
      end
      local dn = dm.CFrame:PointToObjectSpace(de)
      local dp = dm.Size * 0.5
      if math.abs(dn.X) <= dp.X + (df or 0) and math.abs(dn.Z) <= dp.Z + (df or 0) and math.abs(dn.Y) <= dp.Y + (dl and 4 or 8) then
        return true
      end
      local dq = dj and dj:FindFirstChild("ForceZone")
      if dq and dq:IsA("BasePart") then
        dn = dq.CFrame:PointToObjectSpace(de)
        dp = dq.Size * 0.5
        if math.abs(dn.X) <= dp.X + (df or 0) and math.abs(dn.Z) <= dp.Z + (df or 0) and math.abs(dn.Y) <= dp.Y + 8 then
          return true
        end
      end
      return false
    end
    q.recoveryElevatorContains = da
    function q.recoverViaElevator()
      if not q.stuckReset or X or q.resetInProgress then
        return false, "reset-not-ready"
      end
      if not q.stuckReset.begin(q.stuckSnapshot()) then
        return false, "reset-not-ready"
      end
      local de, df = c5(function(de)
        local df = q.stuckSnapshot()
        if not df.ready or df.finished or df.covered or df.pendingCover or df.loading or df.working or df.releasing or df.anchored or df.grabbed or not df.enabled then
          return false, "reset-state-changed"
        end
        local dj, dk, dl = a0()
        local dm = m.room()
        local dn = dl.Position
        local dp = q.elevatorPosition()
        if not dp or da(dp) ~= true then
          return false, "reset-elevator-unavailable"
        end
        a4()
        m.stopInteraction()
        cu()
        q.resetInProgress = true
        q.groundOwned = false
        if q.groundFollower then
          q.groundFollower.reset()
        end
        m.status("Stuck recovery · resetting at the elevator; keeping the current target")
        q.stats.stuckResetOrigin = tostring(dn)
        q.stats.stuckResetWarps = (q.stats.stuckResetWarps or 0) + 1
        dl.CFrame = CFrame.new(dp) * dl.CFrame.Rotation
        dl.AssemblyLinearVelocity = aK
        dl.AssemblyAngularVelocity = aK
        local dq, ds = os.clock() + 2.5, nil
        p.Heartbeat:Wait()
        while aZ(de) and os.clock() < dq do
          local dt, du, dv = a0()
          if dt ~= dj or dv ~= dl or m.room() ~= dm then
            return false, "reset-world-changed"
          end
          if m.machinesFinished and m.machinesFinished() then
            return false, "reset-floor-complete"
          end
          local dw = n:FindFirstChild("Info")
          local dx = dw and dw:FindFirstChild("Loading")
          if dx and dx.Value then
            return false, "reset-floor-loading"
          end
          local dy = dj:FindFirstChild("Stats")
          local dz = dy and dy:FindFirstChild("InElevator")
          local dA = da(dl.Position, 1) == false and not (dz and dz.Value) and (dl.Position - dn).Magnitude >= 6
          if dA then
            ds = ds or os.clock()
            if os.clock() - ds >= 0.18 then
              q.watch.watchPosition, q.watch.watchAt = dl.Position, os.clock()
              q.watch.rescueReason = nil
              q.watch.routeWait = nil
              q.watch.coverCommit = nil
              q.watch.localAnchor = nil
              q.stats.stuckResetExit = tostring(dl.Position)
              return true, "elevator-ejection-confirmed"
            end
          else
            ds = nil
          end
          p.Heartbeat:Wait()
        end
        return false, aZ(de) and "elevator-ejection-unconfirmed" or "cancelled"
      end, true)
      q.resetInProgress = false
      q.groundOwned = false
      if q.groundFollower then
        q.groundFollower.reset()
      end
      q.stuckReset.finish(de == true, df, q.stuckSnapshot())
      if m.report then
        pcall(m.report, "stuck-elevator-reset", tostring(df))
      end
      if m.alive() then
        m.status(de and "Stuck recovery · ejected; retrying the same task" or "Stuck recovery unconfirmed · retrying route with reset on cooldown")
      end
      return de, df
    end
    local function de(df)
      local dj, dk, dl = c7()
      local dm, dn, dp = a0()
      if not dk or not dp then
        return nil, "elevator-bounds-unavailable"
      end
      local dq = dj:FindFirstChild("ForceZone")
      local ds = dj:FindFirstChild("Positions")
      local dt = ds and ds:FindFirstChild("DoorClose") or dj:FindFirstChild("DoorHitbox")
      local du = dq and dq:IsA("BasePart") and dq or dt and dt:IsA("BasePart") and dt
      if not du then
        return nil, "elevator-door-unavailable"
      end
      local dv = aX(du.Position - dk.Position)
      if dv.Magnitude < 1 then
        return nil, "elevator-door-unavailable"
      end
      dv = dv.Unit
      local dw = Vector3.new(-dv.Z, 0, dv.X)
      local function dx(dy)
        local dz, dA = dy.CFrame, dy.Size
        return aX(dy.Position - dk.Position):Dot(dv) + math.abs(dz.RightVector:Dot(dv)) * dA.X * 0.5 + math.abs(dz.UpVector:Dot(dv)) * dA.Y * 0.5 + math.abs(dz.LookVector:Dot(dv)) * dA.Z * 0.5
      end
      local dy = dx(dk)
      for dz, dA in ipairs({dl or dk, du, dt or du}) do
        if dA:IsA("BasePart") then
          dy = math.max(dy, dx(dA))
        end
      end
      dy += math.max(dp.Size.X, dp.Size.Z) * 0.5 + 5
      local dz = math.clamp(aX(dp.Position - dk.Position):Dot(dw), -8, 8)
      for dA, dB in ipairs({0, 4, -4, 8, -8}) do
        local dC = dk.Position + dv * dy + dw * (dz + dB)
        local dD = bL(dC, dp.Position.Y)
        if not dD or math.abs(dD.Y - dp.Position.Y) > 4 or da(dD, 2) or not bO(dD, dD, nil, false) or not bQ(dD) then
          continue
        end
        local dE = bq(dD)
        if dE or m.hazards and m.hazards.dangerAt and m.hazards.dangerAt(dD, 2) then
          continue
        end
        if not q.safeToInteract(dD, 0.5, false, true) then
          continue
        end
        return dD
      end
      return nil, "elevator-exit-unavailable"
    end
    local function df(dj, dk)
      local dl, dn, dp = a0()
      if not dp then
        return false, "no-character"
      end
      local dq = da(dp.Position, 1)
      local ds = dl:FindFirstChild("Stats")
      local dt = ds and ds:FindFirstChild("InElevator")
      if dq == false or dq == nil and not (dt and dt.Value == true) then
        return true, "already-outside-elevator"
      end
      local du = m.room()
      local dv = n:FindFirstChild("Info")
      local dw = dv and dv:FindFirstChild("Loading")
      local dx = dv and dv:FindFirstChild("FloorActive")
      if not du or dw and dw.Value or dx and dx.Value == false or bZ(false) then
        return false, "floor-not-ready"
      end
      local dy, dz = de(dk)
      if not dy then
        return false, dz
      end
      local dA
      local function dB(dC)
        if not aZ(dj) or m.character() ~= dl then
          dA = "cancelled"
          return false
        end
        if m.room() ~= du then
          dA = "floor-changed"
          return false
        end
        if dw and dw.Value or dx and dx.Value == false or bZ(false) then
          dA = "floor-not-ready"
          return false
        end
        if a_(false) then
          dA = "health-loss"
          return false
        end
        if q.chaseThreat() then
          dA = "twisted-chasing"
          return false
        end
        if m.machineTargetValid then
          local dD, dE = m.machineTargetValid()
          if not dD then
            dA = dE
            return false
          end
        end
        return q.safeToInteract(dC, 0.5, false, true)
      end
      if not dB(dy) then
        return false, dA or "elevator-exit-unsafe"
      end
      q.stats.elevatorExitAttempts = (q.stats.elevatorExitAttempts or 0) + 1
      q.stats.elevatorExitPosition = tostring(dy)
      m.status("Teleporting outside the elevator before the generator")
      local dC, dD = cy(dy, dj, false, true, "elevator-exit", dB, "elevator-exit-unsafe")
      if not dC then
        return false, dA or dD
      end
      local dE, dF, dG = a0()
      if dE ~= dl or m.room() ~= du or not dG or (dG.Position - dy).Magnitude > 3.5 or da(dG.Position, 1) ~= false then
        return false, "elevator-exit-unconfirmed"
      end
      if not dB(dG.Position) then
        return false, dA or "elevator-exit-unsafe"
      end
      q.stats.elevatorExits = (q.stats.elevatorExits or 0) + 1
      return true, "outside-elevator"
    end
    function q.canTeleportToMachine()
      return (m.options.machineMoveMethod or "tween") ~= "tween" and not w.active and not w.pending and ar("machine")
    end
    function q.machineHeightTravelAllowed()
      return m.options.directGeneratorLevel == true and q.watch.heightCorrectionFloor ~= m.room()
    end
    function q.failMachineTween(dj, dk, dl)
      if dl == "server-correction" then
        b0()
        if q.directHeightTravel then
          q.watch.heightCorrectionFloor = m.room()
          q.stats.heightTravelFallbacks = (q.stats.heightTravelFallbacks or 0) + 1
        else
          local dp, dq, ds = a0()
          if ds then
            q.noteCorrectedLeg(dj, dk, ds.Position)
          end
        end
      end
      q.directHeightTravel = false
      q.groundFollower = nil
      return false, dl
    end
    function q.generatorLevelRoute(dj, dk, dl)
      if typeof(dj) ~= "Vector3" or typeof(dk) ~= "Vector3" then
        return nil, "invalid-position"
      end
      for dq, ds in ipairs({dk.X, dk.Y, dk.Z}) do
        if ds ~= ds or math.abs(ds) == math.huge then
          return nil, "invalid-position"
        end
      end
      local dq = math.max(dj.Y, dk.Y)
      local ds = {dj}
      if dq - dj.Y > 0.1 then
        ds[#ds + 1] = Vector3.new(dj.X, dq, dj.Z)
      end
      local dt = Vector3.new(dk.X, dq, dk.Z)
      if (dt - ds[#ds]).Magnitude > 0.1 then
        ds[#ds + 1] = dt
      end
      if (dk - ds[#ds]).Magnitude > 0.1 then
        ds[#ds + 1] = dk
      end
      local du = 0
      for dv = 2, #ds do
        if m.hazards and not m.hazards.segmentClear(ds[dv - 1], ds[dv]) then
          return nil, "attack-on-machine-route"
        end
        if not q.travelLegClear(ds[dv - 1], ds[dv], du, dl) then
          return nil, "twisted-on-direct-route"
        end
        du += (ds[dv] - ds[dv - 1]).Magnitude / math.max(1, H(nil, false))
      end
      return ds
    end
    function q.generatorCamped(dj, dk)
      if typeof(dj) ~= "Vector3" then
        return false
      end
      local dl
      for dq, ds in ipairs(bb()) do
        if not ds.chasingUs and not bo(ds) and aX(ds.velocity).Magnitude < 2 and aY(dj, ds.position) <= math.max(18, ds.killRadius + 10) then
          dl = ds
          break
        end
      end
      local dq = q.campState
      if not dl then
        q.campState = nil
        return false
      end
      if not dq or dq.machine ~= dk or dq.blocker ~= dl.model then
        q.campState = {machine = dk, blocker = dl.model, at = os.clock()}
        return false
      end
      return os.clock() - dq.at >= 4, dl
    end
    cE = function(dj, dk, dl)
      m.stopInteraction()
      a4()
      local dq, ds, dt = a0()
      local du = m.room()
      if not dt or not aZ(dk) then
        return false, "cancelled"
      end
      if (w.active or w.pending) and not w.leaving and not dl then
        return false, "cover-holding"
      end
      if m.options.returnToGenerator then
        local dv = bL(dj, dj.Y)
        if not dv then
          return false, "no-floor-at-generator"
        end
        local dw, dx = q.safeToMachineReturn(dv, 0.5, true, true)
        if not dw then
          return false, dx == "ichor-puddle" and "ichor-puddle" or "generator-area-unsafe"
        end
        local dy = bL(dt.Position, dt.Position.Y) or dt.Position
        if m.hideWhilePlanning and not dl and not w.active and not q.travelLegClear(dy, dv, 0) and not q.canPlanFromClearGround(dy) then
          return false, "route-needs-cover"
        end
        local dz, dA = true, nil
        if m.hazards then
          dz, dA = m.hazards.segmentClear(dy, dv)
        end
        local dB = not dz and type(dA) == "table" and dA.kind == "puddle"
        local dC, dD
        local dE = q.machineHeightTravelAllowed()
        if dE then
          dC, dD = q.generatorLevelRoute(dt.Position, dv, dl)
          if dC then
            q.stats.routeReason = "direct-generator-level"
          end
        else
          dC, dD = b_(dy, dv, false, dk, du, true, dl and "machine-exit" or "machine")
        end
        if not dC and (dD == "attack-on-machine-route" or dD == "twisted-on-direct-route") then
          local dF = dD
          dE = false
          dC, dD = b_(dy, dv, false, dk, du, true, dl and "machine-exit" or "machine")
          if dC then
            q.stats.routeReason = dF == "attack-on-machine-route" and "attack-detour" or "twisted-detour"
          else
            dD = dF
          end
        end
        if not dC then
          return false, dD or "no-route-around-twisteds"
        end
        if dl then
          local dF, dG = q.coverResumeClear(dv)
          if not dF then
            return false, dG
          end
          dF, dG = q.exitWriteGuard()
          if not dF then
            return false, dG
          end
        end
        if dl and w.active then
          local dF = af
          af = "machine"
          local dG, dH = q.preflightCoverExit(dC, dv, "machine")
          af = dF
          if not dG then
            return false, dH
          end
          w.leaving = true
          w.exitAttempted = true
        end
        q.directHeightTravel = dE
        if q.directHeightTravel then
          q.groundOwned = false
          q.groundFollower = nil
        end
        local dF = 0
        for dG = 2, #dC do
          dF += (dC[dG] - dC[dG - 1]).Magnitude
        end
        if not dE and not dB and not m.detectionOnly and dF > math.max(28, (dv - dy).Magnitude * 1.35) then
          return false, "hold-local-cover-route-too-long"
        end
        if (dC[1] - dt.Position).Magnitude < 0.6 then
          table.remove(dC, 1)
        end
        local dG, dH = m.setTemporaryNoclip(true)
        if dG == false then
          return false, dH
        end
        z, A, B, C = true, dt.Position, du, dq
        ab = false
        q.stats.machineReturnDetour = true
        q.stats.routeWaypoints = #dC
        q.stats.machineTravelMethod = #dC > 1 and "tween-around-twisteds" or "direct-tween"
        local dI = dl and w.returnRotation or dt.CFrame.Rotation
        local function dJ(dK, dL)
          local dM = q.chaseThreat() or q.detectedThreat()
          if dM then
            return false, "twisted-detected"
          end
          local dN, dO = bP(dK)
          if dN then
            dN, dO = bP(dL)
          end
          if not dN then
            return false, dO
          end
          if m.hazards then
            local dP, dQ = m.hazards.segmentClear(dK, dL)
            if not dP then
              return false, type(dQ) == "table" and dQ.reason or "attack-on-machine-route"
            end
          end
          local dP = q.travelLegClear(dK, dL, 0, dl)
          return dP, not dP and "twisted-route-changed" or nil
        end
        for dK, dL in ipairs(dC) do
          if not aZ(dk) then
            return false, "cancelled"
          end
          local dM = dt.Position
          local dN, dO = dJ(dt.Position, dL)
          if not dN then
            return false, dO or "twisted-route-changed"
          end
          local dP = H(dq, false)
          local dQ = math.max(0.05, (dL - dt.Position).Magnitude / math.max(1, dP))
          local dR = q.makeTween(dt, TweenInfo.new(dQ, Enum.EasingStyle.Linear), {CFrame = CFrame.new(dL) * dI})
          D = dR
          E = "tween"
          q.stats.motionMode = "tween"
          dR:Play()
          m.status(dB and "Going around an ichor puddle" or #dC > 1 and "Tweening around Twisteds to the generator" or "Tweening to the generator")
          local dS = os.clock() + dQ + 0.5
          local dT = 0
          while aZ(dk) and os.clock() < dS do
            if m.character() ~= dq or m.room() ~= du or bZ(false) or a_(false) then
              dR:Cancel()
              return false, "generator-route-cancelled"
            end
            if os.clock() >= dT then
              dT = os.clock() + 0.04
              local dU = dL - dt.Position
              local dV = dt.Position + dU * math.min(1, 12 / math.max(0.01, dU.Magnitude))
              local dW, dX = dJ(dt.Position, dV)
              if not dW then
                dR:Cancel()
                return false, dX or "twisted-route-changed"
              end
            end
            dt.AssemblyLinearVelocity = aK
            dt.AssemblyAngularVelocity = aK
            if dR.PlaybackState == Enum.PlaybackState.Completed or dR.PlaybackState == Enum.PlaybackState.Cancelled then
              break
            end
            p.Heartbeat:Wait()
          end
          if dR.PlaybackState ~= Enum.PlaybackState.Completed then
            dR:Cancel()
            return q.failMachineTween(dM, dL, q.stats.groundBlock or "generator-tween-interrupted")
          end
          if (dt.Position - dL).Magnitude > 2.5 then
            return q.failMachineTween(dM, dL, "server-correction")
          end
          q.stats.segments += 1
        end
        q.stats.machineReturnDetour = false
        q.directHeightTravel = false
        q.groundFollower = nil
        if m.strictGround then
          q.enforceGround()
        end
        q.watch.routeWait = nil
        w.routeWait = nil
        w.routePlanAt = nil
        return true, "generator-route-arrived"
      end
      local dv = m.machineTargetValid and m.machineTargetValid()
      local dw = bL(dj, dj.Y)
      if not dw then
        return false, "no-floor-at-target"
      end
      if not q.safeToMachine(dw, 0.5, true, true) then
        return false, "unsafe-machine-destination"
      end
      if m.hazards and not m.hazards.segmentClear(dt.Position, dw) then
        return false, "attack-on-machine-route"
      end
      local dx, dy = m.setTemporaryNoclip(true)
      if dx == false then
        return false, dy
      end
      z, A, B, C = true, dt.Position, du, dq
      local dz = math.max(0.08, (dw - dt.Position).Magnitude / math.clamp(m.options.tweenSpeed or 30, 12, 30))
      local dA = q.makeTween(dt, TweenInfo.new(dz, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = CFrame.new(dw) * (dl and w.returnRotation or dt.CFrame.Rotation)})
      D = dA
      E = "tween"
      q.stats.motionMode = "tween"
      q.stats.machineTravelMethod = "single-tween"
      dA:Play()
      m.status(dl and "Tweening back to the generator" or "Tweening directly to the machine")
      local dB = os.clock() + dz + 0.5
      while aZ(dk) and os.clock() < dB do
        if m.character() ~= dq or m.room() ~= du or bZ(false) then
          break
        end
        if dv and not m.machineTargetValid() then
          break
        end
        if q.immediateThreatAt(dt.Position) or m.hazards and not m.hazards.segmentClear(dt.Position, dw) then
          break
        end
        if dA.PlaybackState == Enum.PlaybackState.Completed or dA.PlaybackState == Enum.PlaybackState.Cancelled then
          break
        end
        p.Heartbeat:Wait()
      end
      local dC = aZ(dk) and m.character() == dq and m.room() == du and dA.PlaybackState == Enum.PlaybackState.Completed and (dt.Position - dw).Magnitude < 2
      if not dC then
        dA:Cancel()
        return false, "machine-tween-interrupted"
      end
      q.stats.segments += 1
      return true, "machine-tween-arrived"
    end
    local function dj(dk)
      return c5(function(dl)
        return cE(dk, dl, false)
      end)
    end
    function q.moveToMachine(dk, dl)
      local dq = (m.options.machineMoveMethod or "tween") ~= "tween" and (m.options.farmMode == "extreme" or m.options.teleportOnly == true and m.options.machineMoveMethod == "teleport")
      local ds = dq and "teleport" or m.options.machineMoveMethod or "tween"
      if ds == "tween" and m.options.fastMachineTravel then
        return dj(dk)
      end
      if dq and (w.active or w.pending) then
        return false, "cover-holding"
      end
      local dt, du, dv = a0()
      if m.options.teleportOnly then
        if w.active or w.pending then
          return false, "cover-holding"
        end
        if ds == "tween" or ds == "auto" and dv and (dk - dv.Position).Magnitude <= 18 then
          return dj(dk)
        end
      end
      local dw = not m.options.teleportOnly and m.options.farmMode ~= "extreme" and ds == "auto" and dv and typeof(dk) == "Vector3" and (dk - dv.Position).Magnitude <= H() * 1
      if ds == "tween" or dw or w.active or w.pending or not ar("machine") then
        q.stats.machineTravelMethod = "tween"
        return q.moveTo(dk, dl, false)
      end
      local dx
      local dy, dz = c5(function(dy)
        m.stopInteraction()
        a4()
        if not aZ(dy) then
          return false, "cancelled"
        end
        if bZ(false) then
          return false, "exit-required"
        end
        if a_(false) then
          return false, "health-loss"
        end
        local dz = q.chaseThreat()
        if dz then
          return false, "twisted-chasing"
        end
        if typeof(dk) ~= "Vector3" then
          return false, "invalid-position"
        end
        local dA = bL(dk, dk.Y)
        if not dA or not bO(dA, dA, nil, false) then
          return false, "no-floor-at-target"
        end
        if not bQ(dA) then
          return false, "blocked-destination"
        end
        local dB, dC = q.safeToMachine(dA, 4, false, true)
        if not dB then
          return false, dC
        end
        local dD, dE = df(dy, dA)
        if not dD then
          dx = dE
          return false, dE
        end
        local dF = function(dF)
          if bZ(false) then
            dx = "exit-required"
            return false
          end
          if a_(false) then
            dx = "health-loss"
            return false
          end
          if q.chaseThreat() then
            dx = "twisted-chasing"
            return false
          end
          local dG, dH = q.safeToMachine(dF, 4, false, true)
          if not dG then
            dx = dH
            return false
          end
          return true
        end
        q.stats.machineTravelMethod = m.options.farmMode == "extreme" and "extreme-teleport" or "teleport"
        m.status(m.options.farmMode == "extreme" and "Speedrun Extreme · teleporting to the selected generator" or "Teleporting to the closest safe generator")
        return cy(dA, dy, false, true, "machine", dF, "machine-teleport-unsafe")
      end)
      if dx then
        return false, dx
      end
      if not dq and not dy and (dz == "server-correction" or dz == "teleport-disabled-for-floor") then
        if m.options.teleportOnly then
          if ds == "auto" and dv and (dk - dv.Position).Magnitude <= 45 then
            return dj(dk)
          end
          return false, dz
        end
        q.stats.machineTravelMethod = "tween-after-rejected-teleport"
        return q.moveTo(dk, dl, false)
      end
      return dy, dz
    end
    function q.moveTo(dk, dl, dq)
      return c5(function(ds)
        m.stopInteraction()
        if not aZ(ds) then
          return false, "cancelled"
        end
        a4()
        if w.active or w.pending then
          local du, dv = cO(ds)
          if not du then
            return false, dv
          end
          local dw, dx, dy = a0()
          if dy and (dy.Position - dk).Magnitude <= (dl or 3) then
            return true, "arrived-after-cover"
          end
          return false, "cover-resumed"
        end
        local du, dv = b4(dk, dl, dq == true, ds)
        local dx, dy, dz = a0()
        if du and w.waitingForExit and dz and not cr(dz.Position) then
          cu()
        end
        if not du and (dv == "danger" or dv == "health-loss") and aZ(ds) and by(dv) then
          local dA, dB, dC = a0()
          local dD = dC and cA(dC.Position)
          if dD then
            local dE, dF = c0(dD, ds)
            local dG, dH, dI = a0()
            if dE and dI and aY(dI.Position, dk) <= (dl or 3) then
              return true, "arrived-after-cover"
            end
            return false, w.active and "danger-hidden" or dF
          end
          cB(ds)
          return false, "danger-retreated"
        end
        if not du and aZ(ds) and (dv == "route-blocked" or dv == "blocked-destination" or dv == "unreachable") and not aV() and m.setTemporaryNoclip then
          local dB, dC, dD = a0()
          if not dD then
            return false, "no-character"
          end
          z, A, B, C = true, dD.Position, m.room(), dB
          local dE, dF = m.setTemporaryNoclip(true)
          if dE == false then
            return false, dF or "noclip-unavailable"
          end
          m.status("Obstacle on route · temporary noclip")
          local dH, dI = b4(dk, dl, dq == true, ds)
          if not dH and (dI == "danger" or dI == "health-loss") and aZ(ds) and by(dI) then
            local dJ, dK, dL = a0()
            local dM = dL and cA(dL.Position)
            if dM then
              local dN, dO = c0(dM, ds)
              local dP, dQ, dR = a0()
              if dN and dR and aY(dR.Position, dk) <= (dl or 3) then
                return true, "arrived-after-cover"
              end
              return false, w.active and "danger-hidden" or dO
            end
            cB(ds)
            return false, "danger-retreated"
          end
          return dH, dI
        end
        return du, dv
      end)
    end
    function q.resumeCover()
      return c5(function(dk)
        a4()
        return cO(dk)
      end)
    end
    function q.advanceThroughCover(dk)
      return c5(function(dl)
        if m.options.coverHop ~= true or typeof(dk) ~= "Vector3" then
          return false, "no-hidden-hop"
        end
        if w.active or w.pending then
          return cO(dl)
        end
        if bZ(false) then
          return false, "exit-required"
        end
        local dq, ds, du = a0()
        if not du then
          return false, "no-character"
        end
        local dv, dy = c1(du.Position, dl)
        if dv then
          q.stats.proactiveCoverApproaches = (q.stats.proactiveCoverApproaches or 0) + 1
        end
        return dv, dy
      end)
    end
    function q.spendStamina(dk)
      return c5(function(dl)
        local ds, du, dv = a0()
        if not dv or dv.Anchored or w.active or w.pending then
          return false, "stamina-movement-unavailable"
        end
        local dy = ds:FindFirstChild("Stats")
        local dz = dy and dy:FindFirstChild("CurrentStamina")
        local dB = dy and dy:FindFirstChild("Stamina")
        if not dz or not dB then
          return false, "stamina-unavailable"
        end
        if dz.Value < dB.Value - 0.1 then
          return true, "stamina-already-spent"
        end
        if not q.sprintSafe() or dk and not dk() then
          return false, "stamina-sprint-unsafe"
        end
        local dC = dv.Position
        local dD
        local dE = m.room()
        local dF = n:FindFirstChild("Elevators")
        local dH = dF and dF:FindFirstChild("Elevator")
        local dI = dH and dH:FindFirstChild("Base")
        local dK = dy:FindFirstChild("InElevator")
        if dK and dK.Value and (not dI or not dI:IsA("BasePart")) then
          return false, "elevator-bounds-unavailable"
        end
        for dL, dM in ipairs({Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1)}) do
          local dN = bL(dC + dM * 4, dC.Y)
          local dO = true
          if dK and dK.Value and dI then
            local dQ = dI.CFrame:PointToObjectSpace(dN or dC)
            dO = math.abs(dQ.X) < dI.Size.X * 0.5 - 1.5 and math.abs(dQ.Z) < dI.Size.Z * 0.5 - 1.5
          end
          if dN and dO and not cw(dN) and bQ(dN) and bO(dC, dN) and bY(dC, dN) and q.safeHere(dN, 1, true) and (not m.hazards or m.hazards.segmentClear(dC, dN)) then
            dD = dN
            break
          end
        end
        if not dD then
          return false, "no-safe-stamina-step"
        end
        E = "stamina-sprint"
        q.stats.motionMode = E
        m.setSprint(true, true)
        local dL = dz.Value
        local dM = os.clock() + 0.65
        while aZ(dl) and os.clock() < dM and dz.Value >= dB.Value - 0.1 do
          if dk and not dk() or not q.sprintSafe() or a_(false) or m.room() ~= dE then
            break
          end
          local dN, dO, dQ = a0()
          if dQ ~= dv or dv.Anchored or (dv.Position - dC).Magnitude >= 3.5 then
            break
          end
          du:Move(aX(dD - dC).Unit, false)
          p.Heartbeat:Wait()
        end
        a4()
        if not aZ(dl) then
          return false, "cancelled"
        end
        local dO = dz.Value < dL and dz.Value < dB.Value - 0.1
        if dO then
          q.stats.staminaBursts = (q.stats.staminaBursts or 0) + 1
        end
        return dO, dO and "stamina-spent" or "stamina-did-not-decrease"
      end)
    end
    function q.hide(dk)
      return c5(function(dl)
        m.stopInteraction()
        local ds, du, dv = a0()
        if not dv then
          return false, "no-character"
        end
        local dy = q.rollingPumpkinThreat()
        if dy then
          return q.avoidRollingPumpkin(dl, dy)
        end
        if not q.stableCover() and (q.chaseThreat() or q.detectedThreat()) then
          return q.continuousChaseCover(dl)
        end
        if w.active or w.pending then
          if m.options.controlMode == "self" and cr(dv.Position) and cl(w.part, dv.Position) then
            cF()
            return true, "already-hidden"
          end
          return cO(dl)
        end
        local dz, dB = c1(dv.Position, dl, true)
        if dz then
          return true, dB
        end
        if m.options.fullBodyHiding and dB ~= "cover-approach-progress" and q.localSafetyStep(dl) then
          local dC, dD, dE = a0()
          if dE then
            local dF, dH = c1(dE.Position, dl, true)
            if dF or w.active then
              return dF, dH
            end
            return true, "wall-juke-progress"
          end
        end
        if m.options.elevatorRefuge then
          return cD(dl, dB or "waiting-for-machine")
        end
        return false, dB or "no-nearby-hiding-spot"
      end, true)
    end
    function q.waitForRoute(dk)
      local dl, du, dv = a0()
      if not q.watch.routeWait or q.watch.routeWait.floor ~= m.room() then
        q.watch.routeWait = {floor = m.room(), origin = dv and dv.Position, reason = dk}
      end
      q.stats.routeCoverWaits = (q.stats.routeCoverWaits or 0) + 1
      local dy, dz = q.hide("tween")
      if w.active then
        w.routeWait = true
        w.routePlanAt = os.clock() + 0.3
        m.status("Hidden · finding a route to the same generator")
      elseif not w.pending and dz ~= "cover-approach-progress" then
        q.watch.routeWait.noCoverFailures = (q.watch.routeWait.noCoverFailures or 0) + 1
      end
      return dy, dz
    end
    function q.manualTo(dk, du, dv)
      return c5(function(dy)
        m.stopInteraction()
        local dz = bL(dk, dk.Y)
        if not dz or not bQ(dz) then
          return false, "no-supported-machine-destination"
        end
        if not q.safeToMachine(dz, 1, true, true) then
          return false, "unsafe-machine-destination"
        end
        w.leaving = w.active == true or w.pending == true
        local dB, dD
        if dv == "teleport" and ar("machine") then
          local dE, dF = df(dy, dz)
          if not dE then
            return false, dF
          end
          dB, dD = cy(dz, dy, false, true, "machine", function(dH)
            return q.safeToMachine(dH, 1, true, true)
          end, "twisted-detected")
        else
          dB, dD = b4(dz, du or 1, false, dy)
        end
        local dE, dF, dH = a0()
        if dB and dH and not cr(dH.Position) then
          cu()
        end
        w.leaving = false
        return dB, dD
      end)
    end
    function q.encounterSpeed(dk)
      local du = a8(dk.model)
      return math.max(dk.runSpeed, aX(dk.velocity).Magnitude, du and aX(du.AssemblyLinearVelocity).Magnitude or 0)
    end
    function q.encounterBuffer(dk)
      return dk.killRadius + q.encounterSpeed(dk) * 0.9 + 10
    end
    function q.encounterDanger(dk)
      if bq(dk) then
        return true
      end
      for du, dv in ipairs(bb(true)) do
        if math.abs(dk.Y - dv.position.Y) > 16 then
          continue
        end
        if bc(dk, dv, 0.25) < q.encounterBuffer(dv) or dv.ranged and dv.grabbing and not bd(dv, dk) then
          return true
        end
      end
      return false
    end
    function q.encounterPosition(dk)
      local du = q.encounterBlockedReason(dk)
      if du then
        return nil, du
      end
      local dv = a8(dk)
      local dy, dz, dB = a0()
      if not dv or not dB then
        return nil, "target-vanished"
      end
      local dD
      for dF, dH in ipairs(bb(true)) do
        if dH.model == dk then
          dD = dH
          break
        end
      end
      if not dD then
        return nil, "untracked-threat"
      end
      if dD.ranged and dD.grabbing then
        return nil, "ranged-attack-active"
      end
      local dF = math.max(q.encounterBuffer(dD) + q.encounterSpeed(dD) * 0.25 + 3, dD.visionRadius - 4)
      if dD.ranged then
        dF = math.max(dF, dD.visionRadius * 0.9)
      end
      if dF > dD.visionRadius - 3 then
        return nil, "no-safe-encounter-distance"
      end
      local dH = aX(dv.CFrame.LookVector)
      if dH.Magnitude < 0.1 then
        return nil, "unknown-encounter-facing"
      end
      for dI, dK in ipairs({0, 0.25, -0.25, 0.5, -0.5, 0.8, -0.8, 1.05, -1.05}) do
        local dL = Vector3.new(dH.Unit.X * math.cos(dK) - dH.Unit.Z * math.sin(dK), 0, dH.Unit.X * math.sin(dK) + dH.Unit.Z * math.cos(dK))
        local dM = dv.Position + dL * dF
        local dO = bL(dM, dv.Position.Y)
        if not dO or math.abs(dO.Y - dv.Position.Y) > 8 or bq(dO) then
          continue
        end
        local dQ = true
        for dR, dS in ipairs(bb()) do
          if math.abs(dO.Y - dS.position.Y) > 16 then
            continue
          end
          local dT = bc(dO, dS, 0.25)
          if dT < q.encounterBuffer(dS) then
            dQ = false
            break
          end
          if dS.ranged and dS.grabbing and not bd(dS, dO) then
            dQ = false
            break
          end
        end
        if dQ and ba(dv.Position + aL, dO + aL) then
          return dO, dD
        end
      end
      return nil, "no-safe-encounter-point"
    end
    function q.encounter(dk, du)
      if m.encounterExitRequired and m.encounterExitRequired() then
        return false, "encounter-exit-deadline"
      end
      local dv = q.encounterBlockedReason(dk)
      if dv then
        return false, dv
      end
      if m.options.quickEncounters and (not m.options.tweenOnly or m.machinesFinished and m.machinesFinished()) then
        return c5(function(dz)
          w.leaving = true
          m.stopInteraction()
          a4()
          local dB, dD, dF = a0()
          local dH = m.room()
          if not dF or not dH or not dk or not dk:IsDescendantOf(dH) then
            return false, "target-vanished"
          end
          q.stats.encounterAttempts = (q.stats.encounterAttempts or 0) + 1
          local dI = dF.Position
          local dK = m.encountersPending and m.encountersPending()
          local dL = not dK and m.machinesFinished and m.machinesFinished() and q.elevatorPosition() or nil
          local dM = false
          local function dO(dQ, dR)
            if m.room() ~= dH or m.character() ~= dB then
              return dM, "cancelled"
            end
            local dS = dR or m.encounterExitRequired and m.encounterExitRequired()
            local dT = dS and m.machinesFinished and m.machinesFinished() and q.elevatorPosition()
            local dU = dT or not q.encounterDanger(dI) and dI or dL and not q.encounterDanger(dL) and dL
            if not dU and m.machinesFinished and m.machinesFinished() then
              dU = q.elevatorPosition()
              dS = true
            end
            if dU then
              if dS and m.encounterEmergencyExit then
                m.encounterEmergencyExit(dQ)
              end
              if aY(dF.Position, dU) > 0.1 then
                v()
                cu()
                dF.Anchored = false
                dF.CFrame = CFrame.new(dU) * dF.CFrame.Rotation
                dF.AssemblyLinearVelocity = aK
                q.stats.teleportAttempts += 1
                q.stats.encounterSafetyWithdrawals = (q.stats.encounterSafetyWithdrawals or 0) + 1
              end
            elseif aZ(dz) then
              cB(dz)
            end
            return dM, dQ
          end
          local function dQ()
            local dR = dk:FindFirstChild("Alerted")
            return dk:GetAttribute("Alerted") == true or dR and dR:IsA("BoolValue") and dR.Value == true
          end
          local dR = not dQ()
          local function dS()
            if dM then
              return true
            end
            local dT = a8(dk)
            if not dT then
              return false
            end
            local dU = dQ()
            if not dU then
              dR = true
            end
            local dV = aX(dF.Position - dT.Position)
            local dW = aX(dT.CFrame.LookVector)
            local dX = dk:FindFirstChild("Chaser") or dk:FindFirstChild("Script")
            local dY = dR and dU and dV.Magnitude <= a6(dX, "VisionRadius", 90) and dV.Magnitude > 0.1 and dW.Magnitude > 0.1 and dW.Unit:Dot(dV.Unit) > 0.2 and ba(dT.Position + aL, dF.Position + aL)
            local dZ = dk:FindFirstChild("ChasingValue", true)
            local d_ = dZ and dZ:IsA("ObjectValue") and dZ.Value
            local d0 = game:GetService("Players").LocalPlayer
            local d1 = d_ ~= nil and (d_ == dB or d_ == d0 or d_:IsDescendantOf(dB))
            local d2 = "ChasingValue targets local character"
            if not d1 and m.detectedUs then
              d1, d2 = m.detectedUs(dk, dB, dY)
            end
            if not d1 and m.researchObserved then
              d1 = m.researchObserved(dk)
              if d1 then
                d2 = "server research acknowledgement"
              end
            end
            if d1 then
              dM = true
              q.stats.encountersConfirmed = (q.stats.encountersConfirmed or 0) + 1
              if du then
                du(d2 or "native detection")
              end
            end
            return d1
          end
          if dS() then
            return dO("already-detected")
          end
          if m.machinesFinished and m.machinesFinished() and q.encounterDanger(dF.Position) then
            return dO("encounter-source-unsafe", true)
          end
          local dT, dU = q.encounterPosition(dk)
          if not dT then
            return false, dU
          end
          local dV = q.coverHealth()
          if q.encounterDanger(dT) then
            return false, "encounter-landing-unsafe"
          end
          v()
          cu()
          ab = true
          if m.setTemporaryNoclip then
            m.setTemporaryNoclip(true)
          end
          z, A, B, C = true, dF.Position, dH, dB
          dF.Anchored = false
          dF.CFrame = CFrame.new(dT) * dF.CFrame.Rotation
          dF.AssemblyLinearVelocity = aK
          q.stats.teleportAttempts += 1
          q.stats.encounterTeleports = (q.stats.encounterTeleports or 0) + 1
          q.stats.encounterLanding = dT
          q.stats.encounterDistance = aY(dT, a8(dk).Position)
          m.status("Encounter · waiting at a safe visible distance from " .. dk.Name)
          local dW = os.clock() + 1.1
          while aZ(dz) and m.room() == dH and m.character() == dB and os.clock() < dW do
            if m.encounterExitRequired and m.encounterExitRequired() then
              return dO("encounter-exit-deadline")
            end
            local dX = q.encounterBlockedReason(dk)
            if dX then
              return dO(dX)
            end
            if dS() then
              return dO("detected-moving-on")
            end
            if q.coverHealth() < dV then
              return dO("encounter-damage")
            end
            if q.encounterDanger(dF.Position) then
              return dO("encounter-safety-retreat")
            end
            dF.AssemblyLinearVelocity = aK
            p.Heartbeat:Wait()
          end
          return dO(aZ(dz) and "detection-unconfirmed" or "cancelled")
        end, true)
      end
      return c5(function(dz)
        m.stopInteraction()
        a4()
        if w.active or w.pending then
          return cJ("research-waiting-for-cover-clearance")
        end
        local dB, dD, dF = a0()
        local dH = m.room()
        if not dF or not dH or not dk or not dk:IsDescendantOf(dH) then
          return false, "target-vanished"
        end
        local function dI()
          local dK = dk:FindFirstChild("ChasingValue", true)
          local dL = dK and dK:IsA("ObjectValue") and dK.Value
          local dM = game:GetService("Players").LocalPlayer
          return dL ~= nil and (dL == dB or dL == dM or dL:IsDescendantOf(dB))
        end
        local dK = false
        local function dL()
          local dM = dk:FindFirstChild("Alerted")
          return dk:GetAttribute("Alerted") == true or (dM and dM:IsA("BoolValue") and dM.Value == true) or false
        end
        local dM = not dL()
        local function dO()
          if dK then
            return true
          end
          local dQ = dL()
          if not dQ then
            dM = true
          end
          local dR, dS, dT = a0()
          local dU = a8(dk)
          local dV = false
          if dM and dQ and dT and dU then
            local dW = aX(dT.Position - dU.Position)
            local dX = aX(dU.CFrame.LookVector)
            local dY = dk:FindFirstChild("Chaser") or dk:FindFirstChild("Script")
            dV = dW.Magnitude <= a6(dY, "VisionRadius", 90) and dW.Magnitude > 0.1 and dX.Magnitude > 0.1 and dX.Unit:Dot(dW.Unit) > 0.2 and ba(dU.Position + aL, dT.Position + aL)
          end
          local dW, dX
          if m.detectedUs then
            dW, dX = m.detectedUs(dk, dB, dV)
          else
            dW, dX = dI(), "ChasingValue targets local character"
          end
          if dW then
            dK = true
            if du then
              du(dX)
            end
          end
          return dK
        end
        local function dQ(dS)
          as, at, au = nil, 0, nil
          a4()
          if m.encounterExitRequired and m.encounterExitRequired() then
            return dK, "encounter-exit-deadline"
          end
          if not aZ(dz) then
            return dK, "cancelled"
          end
          local dT, dU, dV = a0()
          local dW = dV and cA(dV.Position)
          local dX, dY
          if dW then
            dX, dY = c0(dW, dz)
          elseif m.options.elevatorRefuge then
            dX, dY = cD(dz, "encounter-observed")
          else
            dX, dY = cB(dz)
          end
          return dK, dX and (dK and "detection-observed-and-retreated" or "exposure-ended-in-cover") or dY or dS
        end
        if dO() then
          return dQ("already-chasing")
        end
        local dS
        for dU, dV in ipairs(bb()) do
          if dV.model == dk then
            dS = dV
            break
          end
        end
        if not dS then
          return false, "untracked-threat"
        end
        local dU = math.max(be(dS) + 6, q.encounterBuffer(dS) + q.encounterSpeed(dS) * 0.25 + 3)
        local dV = dS.visionRadius - 4
        if dV < dU or dV <= 0 then
          return false, "no-safe-exposure-range"
        end
        as, at, au = dk, os.clock() + 35, dO
        Z = nil
        local dW = {}
        local dX = dF.Position - dS.position
        local dY = math.atan2(dX.Z, dX.X)
        for dZ, d_ in ipairs({0, math.pi / 8, -math.pi / 8, math.pi / 4, -math.pi / 4}) do
          local d0 = dY + d_
          local d1 = bL(dS.position + Vector3.new(math.cos(d0), 0, math.sin(d0)) * dV, dF.Position.Y)
          if d1 and q.safeToInteract(d1, 1, true) and ba(dS.position + aL, d1 + aL) then
            table.insert(dW, d1)
          end
        end
        table.sort(dW, function(dZ, d_)
          return aY(dF.Position, dZ) < aY(dF.Position, d_)
        end)
        local dZ, d_
        for d0, d1 in ipairs(dW) do
          local d2 = cA(d1)
          if d2 and aY(d1, d2.position) <= 160 or m.options.elevatorRefuge then
            dZ, d_ = d1, d2
            break
          end
        end
        if not dZ then
          as, at, au = nil, 0, nil
          return false, "no-covered-exposure-point"
        end
        z, A, B, C = true, dF.Position, dH, dB
        if m.setTemporaryNoclip then
          m.setTemporaryNoclip(true)
        end
        if w.active or w.pending then
          w.active, w.pending = false, false
          w.waitingForExit = true
        end
        m.status("Research · approaching " .. dk.Name .. " for confirmed detection")
        if dO() then
          return dQ("already-detected")
        end
        local d0, d1
        if m.options.researchTeleport and ar("research") then
          d0, d1 = cy(dZ, dz, false, true, "research", function(d2)
            return q.safeToInteract(d2, 0.8, true, true)
          end, "research-landing-unsafe")
        else
          d0, d1 = b4(dZ, 1.2, false, dz)
        end
        dO()
        if not d0 or dK then
          return dQ(d1)
        end
        local d2 = os.clock() + 2
        while aZ(dz) and m.options.researchMode and os.clock() < d2 and (not m.options.selectedTwisteds or m.options.selectedTwisteds[dk.Name:gsub("Monster$", "")] == true) do
          if m.encounterExitRequired and m.encounterExitRequired() then
            break
          end
          if q.encounterBlockedReason(dk) then
            break
          end
          if dO() then
            break
          end
          local d3, d4, d5 = a0()
          if not d5 or a_(false) then
            break
          end
          local d6 = q.safeToInteract(d5.Position, 0.7, true)
          if not d6 or q.encounterDanger(d5.Position) then
            break
          end
          m.status("Research · waiting briefly for " .. dk.Name .. " to detect you")
          task.wait(0.025)
        end
        dO()
        return dQ(dK and "detection-observed" or "detection-not-observed")
      end)
    end
    local function dk(du, dv)
      m.stopInteraction()
      if not aZ(du) then
        return false, "cancelled"
      end
      if m.options.teleportOnly then
        local dz, dB, dD = a0()
        if not dD then
          return false, "no-character"
        end
        local dF, dH = c1(dD.Position, du)
        if dF then
          return true, dH
        end
        return cD(du, "direct-cover-unavailable")
      end
      a4()
      local dB = q.sproutThreat()
      q.stats.sproutTweenEscape = dB ~= nil
      if (w.active or w.pending) and not dB then
        return cO(du)
      end
      if dB and (w.active or w.pending) then
        w.leaving = true
        w.clearSince = nil
        af = nil
      end
      local dD, dF, dH = a0()
      local dI = dB or q.chaseThreat() or (aw() and q.detectedThreat()) or q.nearestDanger()
      if not dH then
        return false, "no-character"
      end
      if not dI then
        local dK = dv
        if type(dK) ~= "table" or typeof(dK.position) ~= "Vector3" or not dK.model then
          local dL, dM = q.safeToInteract(dH.Position, 2, true)
          if not dL then
            dK = dM
          end
        end
        if type(dK) == "table" and typeof(dK.position) == "Vector3" and dK.model and dK.model.Parent and m.room() and dK.model:IsDescendantOf(m.room()) then
          dI = dK
        end
      end
      if not dI then
        return true, "safe"
      end
      if dI.reason == "untracked-threat" then
        return false, "untracked-threat"
      end
      local dK, dL = dH.Position, m.room()
      if not dB then
        local dM, dO = c1(dK, du)
        if dM or w.active or not aZ(du) then
          return dM, dO
        end
        q.stats.lastRetreatReason = dO
        if m.options.elevatorRefuge then
          local dQ, dS = cD(du, "detected-without-local-cover")
          if dQ then
            return true, dS
          end
          q.stats.lastRefugeFailure = dS
        end
        if not ac and m.options.allowEmergencyRetreat ~= true then
          if m.options.wallJukeFallback then
            return q.jukeThroughWall(du)
          end
          q.stats.retreatStopReason = "no-verified-cover"
          m.status("No verified hiding spot · rechecking nearby solid cover")
          return false, dO
        end
        q.stats.machineEmergencyFallback = true
      end
      q.stats.coverStatus = dB and "sprout-tween-escape" or "no-safe-hiding-spot"
      if m.setTemporaryNoclip then
        z, A, B, C = true, dK, dL, dH.Parent
        local dM, dO = m.setTemporaryNoclip(true)
        if dM == false then
          return false, dO or "noclip-unavailable"
        end
        if not aZ(du) then
          return false, "cancelled"
        end
      end
      m.status(dB and "Sprout detected you · extraction stopped; tweening away" or "Generator emergency · taking a short escape before retrying nearby cover")
      local dM = aX(dK - dI.position)
      if dM.Magnitude < 0.1 then
        dM = Vector3.new(1, 0, 0)
      end
      dM = dM.Unit
      local dO, dQ = nil, -math.huge
      local dS = aV() and 12 or 8
      local dU = dB and {0, 0.6, -0.6, 1.2, -1.2, math.pi * 0.5, -math.pi * 0.5, 1.8, -1.8} or {0, 0.6,
        -0.6, 1.2, -1.2, 1.8, -1.8, 2.4, -2.4, math.pi}
      for dV = 1, 2 do
        if dV == 2 then
          if not bT(dK, dK + dM * dS) then
            break
          end
          if not dB then
            local dW, dX = c1(dK, du, true)
            if dW or w.active or not aZ(du) then
              return dW, dX
            end
            q.stats.lastRetreatReason = dX
          end
        end
        for dW, dX in ipairs(dU) do
          local dY = Vector3.new(dM.X * math.cos(dX) - dM.Z * math.sin(dX), 0, dM.X * math.sin(dX) + dM.Z * math.cos(dX))
          local dZ = bL(dK + dY * dS, dK.Y)
          if dZ and a3(dZ, not ac and dV == 2) then
            local d_, d0 = q.threatAt(dZ)
            local d1 = d_ and (not d0 or d0.reason == "untracked-threat")
            if not d1 and bY(dK, dZ) and bQ(dZ) and not cw(dZ) and aT(dK, dZ) and bW(dK, dZ) and b_(dK, dZ, true, du, dL) then
              local d2 = a2()
              local d4 = aY(dZ, dI.position) - (d2 and aY(dZ, d2) * 0.5 or 0)
              if d4 > dQ then
                dO, dQ = dZ, d4
              end
            end
          end
        end
        if dO then
          q.stats.emergencyGeneratorExtension = dV == 2
          break
        end
      end
      if dO then
        local dV, dW = b4(dO, 1.5, true, du)
        q.stats.lastRetreatReason = dW
        if dB then
          q.stats.sproutTweenSteps = (q.stats.sproutTweenSteps or 0) + (dV and 1 or 0)
          local dX, dY, dZ = a0()
          if dZ and w.leaving and not cr(dZ.Position) then
            am("exit", "sprout-detected-tween-exit")
            cu()
          end
        end
        if dV then
          if ac and not dB then
            q.stats.machineEmergencySteps = (q.stats.machineEmergencySteps or 0) + 1
          end
          return true, "retreated"
        end
        if dW == "cancelled" or dW == "floor-changed" or dW == "character-changed" then
          return false, dW
        end
      end
      if ac and not dB then
        return false, "no-short-machine-escape"
      end
      local dV = {}
      local dW = q.elevatorPosition()
      if dW and aY(dK, dW) <= 64 then
        table.insert(dV, {position = dW})
      end
      local dY = dL and dL:FindFirstChild("Waypoints")
      if dY then
        for dZ, d_ in ipairs(dY:GetDescendants()) do
          if d_:IsA("BasePart") and aY(dK, d_.Position) >= 8 and aY(dK, d_.Position) <= 64 then
            table.insert(dV, {position = d_.Position})
          end
        end
      end
      for dZ, d_ in ipairs({12, 20, 32, 48}) do
        for d0 = 0, 11 do
          local d1 = d0 * math.pi / 6
          table.insert(dV, {position = dK + Vector3.new(math.cos(d1), 0, math.sin(d1)) * d_})
        end
      end
      local dZ = {}
      for d_, d0 in ipairs(dV) do
        if not aZ(du) then
          return false, "cancelled"
        end
        if m.room() ~= dL then
          return false, "floor-changed"
        end
        local d1 = bL(d0.position, dK.Y)
        if d1 and a3(d1) and not cw(d1) and not q.threatAt(d1) and bQ(d1) then
          d0.position = d1
          d0.score = aY(dK, d1)
          table.insert(dZ, d0)
        end
      end
      table.sort(dZ, function(d_, d0)
        return d_.score < d0.score
      end)
      local d_ = "no-safe-tween-route"
      for d0 = 1, math.min(2, #dZ) do
        if not aZ(du) then
          return false, "cancelled"
        end
        local d1, d2 = b4(dZ[d0].position, 2, true, du)
        q.stats.lastRetreatReason = d2
        if d1 then
          return true, "retreated"
        end
        d_ = d2
        if d2 == "cancelled" or d2 == "floor-changed" or d2 == "character-changed" then
          return false, d2
        end
      end
      return false, d_
    end
    cB = function(du, dv)
      ab = true
      local dB = q.sproutThreat() ~= nil
      local dF = "retreating"
      local dH, dI, dK = a0()
      if aw() and dK then
        an, ao = dK.Position, m.room()
      end
      q.stats.retreatIterations = 0
      while aZ(du) do
        if m.encounterExitRequired and m.encounterExitRequired() then
          return false, "encounter-exit-deadline"
        end
        local dL, dM, dO = a0()
        local dQ = dO and dO.Position
        local dS, dU = dk(du, dv)
        dv = nil
        q.stats.retreatIterations += 1
        dF = dU
        if not aZ(du) then
          return false, "cancelled"
        end
        if dB and not q.sproutThreat() then
          Z = nil
          q.stats.sproutTweenEscape = false
          q.stats.retreatStopReason = "sprout-detection-cleared"
          return true, "retreated-clear"
        end
        if w.active and not w.leaving and not q.sproutThreat() then
          return dS, dU
        end
        local dV, dW, dY = a0()
        if not dY then
          return false, "no-character"
        end
        if ac and not dB and dS then
          local dZ, d_ = c1(dY.Position, du)
          if dZ or w.active then
            return dZ, d_
          end
          return true, "machine-emergency-step"
        end
        local dZ = q.shouldHide(dY.Position, true)
        local d_ = aw() and q.safeToMachineReturn(dY.Position, 1.2, true, true) or not aw() and q.safeHere(dY.Position, 2, true)
        if not dZ and d_ then
          Z = nil
          q.stats.sproutTweenEscape = false
          q.stats.retreatStopReason = "activity-clearance"
          return true, "retreated-clear"
        end
        if dU == "floor-changed" or dU == "character-changed" or dU == "untracked-threat" then
          return false, dU
        end
        if not dS and dQ and (dY.Position - dQ).Magnitude < 0.5 then
          q.stats.retreatStopReason = "no-safe-progress"
          m.status("Exposed · no safe escape route; rechecking threats and targets")
          return false, dU
        end
        m.status(q.sproutThreat() and "Sprout still detects you · continuing tween escape" or "Still threatened · continuing tween retreat toward cover")
        p.Heartbeat:Wait()
      end
      return false, dF
    end
    function q.chaseRetreat(du, dv)
      m.stopInteraction()
      a4()
      if w.active or w.pending then
        return cO(du)
      end
      local dB, dF, dI = a0()
      if not dI then
        return false, "no-character"
      end
      local dK, dO = c1(dI.Position, du)
      if not dK and not w.active and dO ~= "cover-approach-progress" and m.options.wallJukeFallback then
        return q.localSafetyStep(du)
      end
      return dK, dO
    end
    function q.keepChaseDistance()
      return c5(function(du)
        local dv = q.sproutThreat()
        if dv then
          return cB(du, dv)
        end
        return q.chaseRetreat(du, q.chaseThreat())
      end, true)
    end
    function q.continuousChaseCover(du)
      ab = true
      q.stats.chaseEscaping = true
      local dv, dF = "no-safe-cover-route", 0
      while aZ(du) do
        local dI, dK, dO = a0()
        if not dO then
          return false, "no-character"
        end
        if q.stableCover() then
          q.stats.chaseEscaping = false
          return true, "hidden"
        end
        if m.machinesFinished and m.machinesFinished() then
          return false, "exit-required"
        end
        local dQ = dO.Position
        local dS, dU = c1(dQ, du, true)
        dv = dU
        if dS or q.stableCover() then
          q.stats.chaseEscaping = false
          return true, dU
        end
        if not aZ(du) or dU == "floor-changed" or dU == "character-changed" or dU == "extraction-release-pending" then
          return false, dU
        end
        if w.active or w.pending then
          cu()
        end
        if dU ~= "cover-approach-progress" then
          local dW, dY = q.localSafetyStep(du)
          dv = dY or dv
          if q.stableCover() then
            q.stats.chaseEscaping = false
            return true, dY
          end
          if not dW and not q.chaseThreat() and not q.detectedThreat() and not q.shouldHide(dO.Position, true) then
            q.stats.chaseEscaping = false
            return true, "chase-cleared"
          end
        end
        if (dO.Position - dQ).Magnitude < 0.5 then
          dF += 1
        else
          dF = 0
        end
        q.stats.continuousEscapeSteps = (q.stats.continuousEscapeSteps or 0) + 1
        if dF >= 1 then
          q.stats.chaseEscaping = false
          return false, dv
        end
        p.Heartbeat:Wait()
      end
      q.stats.chaseEscaping = false
      return false, "cancelled"
    end
    function q.evade(du)
      return c5(function(dv)
        local dF = q.rollingPumpkinThreat()
        if dF then
          return q.avoidRollingPumpkin(dv, dF)
        end
        local dK = m.options.prioritizeSafety and q.sproutThreat()
        if dK then
          return cB(dv, dK)
        end
        if q.stableCover() then
          return cO(dv)
        end
        if m.options.fullBodyHiding and (q.chaseThreat() or q.detectedThreat()) then
          return q.continuousChaseCover(dv)
        end
        if m.options.fullBodyHiding and m.options.returnToGenerator then
          m.stopInteraction()
          a4()
          local dO, dQ, dS = a0()
          if not dS then
            return false, "no-character"
          end
          local dU, dW = c1(dS.Position, dv, true)
          if not dU and dW ~= "cover-approach-progress" and q.localSafetyStep(dv) then
            local dY, dZ, d_ = a0()
            if d_ then
              dU, dW = c1(d_.Position, dv, true)
            end
            if not dU and not w.active then
              return true, "wall-juke-progress"
            end
          end
          if not dU and dW == "cover-approach-progress" then
            m.status("Hiding · advancing toward the same verified spot")
          elseif not dU then
            q.stats.coverFailure = dW
            m.status("Cover blocked · " .. tostring(dW))
          end
          return dU, dW
        end
        if not ac and not q.sproutThreat() and m.options.machineHideMode == "retreat" and aw() and not a_(false) then
          return q.chaseRetreat(dv, du)
        end
        return cB(dv, du)
      end, true)
    end
    function q.interrupt()
      W += 1
      a4()
      Z = nil
    end
    function q.start()
      if aa or m.dryRun then
        return
      end
      if m.options.fullBodyHiding and (w.active or w.pending) and m.coverGeometry then
        q.ensureGeometry()
        q.geometryByPart = q.geometryByPart or {}
        if w.part and w.geometry then
          q.geometryByPart[w.part] = w.geometry
        end
      end
      local du = p.PreSimulation or p.Stepped
      if du then
        q.anchorConnection = du:Connect(function()
          if not Y and m.alive() then
            if not q.restoreCoverAnchor() then
              q.enforceGround()
            end
          end
        end)
      end
      local dv = 0
      local function dF(dK)
        if q.watch.rescueReason then
          return
        end
        q.watch.rescueReason, q.watch.rescueAt = dK, os.clock()
        q.stats.rescueRequests = (q.stats.rescueRequests or 0) + 1
        q.stats.rescueReason = dK
        if w.part then
          q.watch.rejectedWalls[w.part] = os.clock() + 30
        end
        W += 1
        a4()
        v()
        if m.releaseExtraction then
          m.releaseExtraction(dK)
        end
        m.stopInteraction()
        cu()
      end
      aa = p.Heartbeat:Connect(function()
        if m.strictGround and not w.active and not w.pending then
          q.enforceGround()
        end
        if m.animations and m.animations.active then
          m.animations.pulse()
        end
        if m.machinesFinished and m.machinesFinished() then
          q.watch.rescueReason = nil
          Z = nil
          return
        end
        if m.options.controlMode == "self" then
          local dK, dQ, dS = a0()
          if w.active and not w.leaving and dS and cl(w.part, dS.Position) then
            cF()
          end
          return
        end
        if Y or not m.alive() or os.clock() - dv < 0.04 then
          return
        end
        local dQ, dS, dU = a0()
        if not dU or not dS then
          return
        end
        local dW = dS.Health
        local dZ = dQ:FindFirstChild("Stats")
        local d_ = dZ and dZ:FindFirstChild("Health")
        if d_ and d_:IsA("ValueBase") and type(d_.Value) == "number" then
          dW = math.min(dW, d_.Value)
        end
        if q.watch.watchCharacter ~= dQ then
          q.watch.watchCharacter, q.watch.watchPosition, q.watch.watchAt, q.watch.watchHealth = dQ, dU.Position, os.clock(), dW
        end
        if q.watch.watchHealth and dW < q.watch.watchHealth then
          dF("damage-watchdog")
        end
        q.watch.watchHealth = dW
        if not q.watch.watchPosition or (dU.Position - q.watch.watchPosition).Magnitude > 1.5 then
          q.watch.watchPosition, q.watch.watchAt = dU.Position, os.clock()
        end
        local d0 = m.activity and m.activity()
        local d1 = n:FindFirstChild("Info")
        local d2 = d1 and d1:FindFirstChild("Loading")
        local d4 = dQ:FindFirstChild("Decoding")
        local d5 = X and D ~= nil and E == "tween" and not (d4 and d4.Value) and not (d2 and d2.Value) and not w.active and not w.pending and (d0 == "machine-travel" or d0 == "pickup") and not (m.refugeActive and m.refugeActive()) and not (m.grabbed and m.grabbed())
        if d5 and os.clock() - q.watch.watchAt > (m.options.stuckTimeout or 2.5) then
          q.noteStuckBlock("movement-watchdog")
          if m.detectionOnly and not q.shouldHide(dU.Position, true) then
            W += 1
            a4()
            m.stopInteraction()
            q.stats.routeWatchdogReplans = (q.stats.routeWatchdogReplans or 0) + 1
          else
            dF("movement-watchdog")
          end
          q.watch.watchAt = os.clock()
        end
        if not d5 then
          q.watch.watchAt = os.clock()
        end
        if q.resetInProgress then
          return
        end
        local d6 = q.rollingPumpkinThreat()
        if d6 then
          dv = os.clock()
          if q.stats.pumpkinDodging then
            return
          end
          if D or X then
            W += 1
            a4()
          end
          if m.releaseExtraction then
            m.releaseExtraction("rolling-pumpkin")
          end
          m.stopInteraction()
          if not X and not _ then
            _ = true
            task.spawn(function()
              local d7, d8 = pcall(q.evade, d6)
              if not d7 then
                warn("[FloorAuto] Pumpkin escape: " .. tostring(d8))
              end
              q.stats.pumpkinDodging = false
              _ = false
            end)
          end
          return
        end
        if m.stuckResetFactory then
          if not q.stuckReset then
            q.noteStuckBlock(nil)
          end
          if q.stuckReset.observe(q.stuckSnapshot()) and not X and not _ then
            _ = true
            task.spawn(function()
              local d7, d8 = pcall(q.recoverViaElevator)
              if not d7 then
                q.resetInProgress = false
                q.stuckReset.finish(false, "reset-error", q.stuckSnapshot())
                if m.report then
                  pcall(m.report, "stuck-reset-error", tostring(d8))
                end
              end
              _ = false
            end)
            return
          end
        end
        if q.watch.rescueReason then
          if not X and not q.shouldHide(dU.Position, true) and q.safeHere(dU.Position, 0.5, true) then
            q.watch.rescueReason = nil
            if m.coverDamageHandled then
              m.coverDamageHandled()
            end
          end
        end
        if q.watch.rescueReason then
          if not X and not _ then
            _ = true
            task.spawn(function()
              local d7 = q.watch.rescueReason
              local d8, d9, ea = pcall(q.hide, m.options.tweenOnly and "tween" or "teleport")
              if d8 and d9 then
                q.watch.rescueReason = nil
                q.stats.rescues = (q.stats.rescues or 0) + 1
                if m.coverDamageHandled then
                  m.coverDamageHandled()
                end
              else
                q.stats.rescueFailure = tostring(d8 and ea or d9)
                if os.clock() - q.watch.rescueAt > 2 and not m.options.returnToGenerator then
                  local eb, ec = pcall(q.returnToElevator)
                  if eb and ec then
                    q.watch.rescueReason = nil
                    if m.coverDamageHandled then
                      m.coverDamageHandled()
                    end
                  end
                end
              end
              _ = false
            end)
          end
          return
        end
        if ab then
          return
        end
        if m.onTravelPulse then
          local d7 = E == "tween" and not w.active and not w.pending and (d0 == "pickup" or d0 == "machine-travel")
          local d8, d9 = pcall(m.onTravelPulse, d7)
          if not d8 then
            q.stats.pickupPulseError = tostring(d9)
          end
        end
        if q.restoreCoverAnchor() then
          return
        end
        if w.active and w.kind == "occluded-wall" and not w.leaving then
          local d7 = q.wallShelterClear(w.part, dU.Position, dU.CFrame, nil, not q.coverDamaged())
          if d7 and cr(dU.Position) and not q.coverDamaged() then
            cF()
            return
          end
          if w.part and q.coverDamaged() then
            q.watch.rejectedWalls[w.part] = os.clock() + 30
          end
          am("invalidated", "wall-shelter-exposed")
          cu()
        end
        dv = os.clock()
        if m.refugeActive and m.refugeActive() then
          return
        end
        if m.options.teleportOnly and m.activity and (m.activity() == "research" or m.activity() == "elevator") then
          return
        end
        local d7, d8, d9 = a0()
        if m.grabbed and m.grabbed() then
          return
        end
        local ea = n:FindFirstChild("Info")
        local eb = ea and ea:FindFirstChild("Loading")
        if not d9 or not m.room() or (eb and eb.Value) then
          return
        end
        q.enforceRibbonWalk()
        if m.options.farmMode == "distraction" then
          return
        end
        local ec = q.sproutThreat()
        if not ec and w.active and not w.leaving and m.room() == w.floor and cr(d9.Position) and cl(w.part, d9.Position) then
          local ed = bs(d9.Position)
          if not ed then
            cF()
            return
          end
          am("invalidated", ed.reason .. "-in-cover")
          cu()
        end
        if not ec and w.active and not w.leaving then
          am("invalidated", "heartbeat-exposed-cover")
          cu()
        end
        if not ec and w.pending and cL(d9.Position) then
          return
        end
        local ed = q.chaseThreat()
        local ee, ef = q.shouldHide(d9.Position, true)
        local eg = not ee
        if ed and not ay() then
          eg, ef = false, ed
        end
        local eh = not m.options.reactiveHideOnly and a_(false)
        if not eg or eh then
          Z = type(ef) == "table" and ef or Z
          q.stats.interactionInterruptedAt = os.clock()
          if m.releaseExtraction then
            m.releaseExtraction(type(ef) == "table" and ef.reason or "health-loss")
          end
          m.stopInteraction()
          if D then
            D:Cancel()
          end
          if not X and not _ then
            _ = true
            task.spawn(function()
              local ei, ej = pcall(q.evade, Z)
              if not ei then
                warn("[FloorAuto] Retreat monitor: " .. tostring(ej))
              end
              _ = false
            end)
          end
        elseif not eh then
          Z = nil
        end
      end)
    end
    function q.stop()
      q.directHeightTravel = false
      q.stats.chaseEscaping = false
      if q.anchorConnection then
        q.anchorConnection:Disconnect()
        q.anchorConnection = nil
      end
      q.resetInProgress = false
      if m.animations then
        m.animations.release()
        q.animationLease = nil
      end
      v()
      cY()
      as, at, au = nil, 0, nil
      af = nil
      w.leaving = false
      W += 1
      if aa then
        aa:Disconnect()
        aa = nil
      end
      a4()
      cx()
      if w.active or w.pending or w.waitingForExit then
        local du, dv, dF = a0()
        w.active = dF ~= nil and cr(dF.Position) and (w.kind == "occluded-wall" and not q.coverDamaged() and q.wallShelterClear(w.part, dF.Position, dF.CFrame, nil, true) or cl(w.part, dF.Position))
        w.pending = false
        if not w.active then
          cu()
        else
          q.stats.coverStatus = "paused-in-cover"
        end
      end
      if not w.active and q.geometry then
        q.geometry.destroy()
        q.geometry = nil
        q.geometryByPart = nil
      end
    end
    function q.destroy()
      Y = true
      q.stop()
      cu()
      if q.geometry then
        q.geometry.destroy()
        q.geometry = nil
        q.geometryByPart = nil
      end
      table.clear(aE)
      table.clear(aC)
    end
    function q.pickupPosition(dv, dF, dQ)
      local dS, dW, dZ = a0()
      if not dZ then
        return nil
      end
      local d_ = {}
      local d0 = {aK, Vector3.new(3.5, 0, 0), Vector3.new(-3.5, 0, 0), Vector3.new(0, 0, 3.5), Vector3.new(0, 0, -3.5)}
      local d4 = math.min(6, math.max(0, dF - 1))
      if d4 > 3.6 then
        for d5 = 0, 7 do
          local d6 = d5 * math.pi / 4
          d0[#d0 + 1] = Vector3.new(math.cos(d6) * d4, 0, math.sin(d6) * d4)
        end
      end
      for d5, d6 in ipairs(d0) do
        local d8 = bL(dv + d6, dv.Y)
        if d8 and (d8 - dv).Magnitude < dF - 0.2 and bQ(d8) and not q.itemContactAt(d8) and q.safeToPickup(d8, 0.5, true, true) then
          d_[#d_ + 1] = {position = d8, score = (dZ.Position - d8).Magnitude}
        end
      end
      table.sort(d_, function(d5, d6)
        return d5.score < d6.score
      end)
      if #d_ == 0 then
        return nil
      end
      local d5 = 1 + (math.max(0, math.floor(tonumber(dQ) or 0)) % #d_)
      return d_[d5].position
    end
    function q.isGrounded()
      local dv, dF, dQ = a0()
      local dW = dQ and bL(dQ.Position, dQ.Position.Y)
      return dW ~= nil and math.abs(dQ.Position.Y - dW.Y) < 1.5
    end
    function q.pickupInReach(dF)
      local dQ = dF and dF.Parent
      local dW = dQ and (dQ:IsA("Attachment") and dQ.WorldPosition or dQ:IsA("BasePart") and dQ.Position)
      local dZ, d_, d0 = a0()
      local d4 = dZ and dZ:FindFirstChild("Stats")
      local d5 = d4 and d4:FindFirstChild("InElevator")
      return dW ~= nil and d0 ~= nil and not (d5 and d5.Value) and da(d0.Position, 1) ~= true and (d0.Position - dW).Magnitude <= math.max(0, dF.MaxActivationDistance - 0.25) and q.isGrounded() and not q.itemContactAt(d0.Position) and q.safeToPickup(d0.Position, 0.4, true, true)
    end
    function q.exitElevatorForPickup(dF, dQ)
      local dW, dZ, d_ = a0()
      if not d_ then
        return false, "no-character"
      end
      local d0 = dW:FindFirstChild("Stats")
      local d4 = d0 and d0:FindFirstChild("InElevator")
      if da(d_.Position, 1) ~= true and not (d4 and d4.Value) then
        return true, "already-outside-elevator"
      end
      local d5, d6 = de(dQ)
      if not d5 then
        return false, d6
      end
      m.status("Exiting the elevator before collecting items")
      local d8, d9 = b4(d5, 0.6, false, dF)
      if not d8 then
        return false, d9
      end
      local ea = os.clock() + 0.5
      while aZ(dF) and os.clock() < ea do
        local eb, ec, ed = a0()
        if eb ~= dW or not ed then
          return false, "character-changed"
        end
        if da(ed.Position, 1) == false and not (d4 and d4.Value) then
          q.stats.pickupElevatorExits = (q.stats.pickupElevatorExits or 0) + 1
          q.stats.pickupElevatorExitMethod = "tween"
          return true, "outside-elevator"
        end
        task.wait(0.05)
      end
      return false, "pickup-elevator-exit-unconfirmed"
    end
    function q.moveToPickup(dF, dQ, dW)
      local dZ = dF and dF.Parent
      local d_ = dZ and (dZ:IsA("Attachment") and dZ.WorldPosition or dZ:IsA("BasePart") and dZ.Position or nil)
      if not d_ then
        return false, "missing-pickup-position"
      end
      return c5(function(d0)
        local d4, d5 = q.exitElevatorForPickup(d0, d_)
        if not d4 then
          return false, d5
        end
        if q.pickupInReach(dF) then
          q.stats.pickupInReach = (q.stats.pickupInReach or 0) + 1
          return true, "pickup-already-in-reach"
        end
        if (dW or 0) > 0 then
          M = nil
          q.stats.pickupApproachRecoveries = (q.stats.pickupApproachRecoveries or 0) + 1
        end
        local d6 = q.pickupPosition(d_, dF.MaxActivationDistance, dW)
        if not d6 then
          return false, "no-safe-pickup-position"
        end
        q.stats.pickupMoveMethod = "tween"
        return b4(d6, 0.5, false, d0)
      end)
    end
    function q.capsuleRoundTrip(dF, dQ)
      return c5(function(dW)
        if w.active or w.pending or not dQ.active() then
          return false, "capsule-cancelled"
        end
        local dZ, d_, d0 = a0()
        local d4 = m.room()
        local d5 = dF and dF.Parent
        local d6 = d5 and (d5:IsA("Attachment") and d5.WorldPosition or d5:IsA("BasePart") and d5.Position)
        if not d6 then
          return false, "missing-capsule-position"
        end
        local d8, d9 = q.exitElevatorForPickup(dW, d6)
        if not d8 then
          return false, d9
        end
        if not aZ(dW) or not dQ.active() or a0() ~= dZ or m.room() ~= d4 then
          return false, "capsule-cancelled"
        end
        local ea = bL(d6, d6.Y)
        if not ea or q.itemContactAt(ea) or not q.safeToPickup(ea, 0.8, true, true) then
          return false, "capsule-landing-unsafe"
        end
        local eb = d0.CFrame
        a4()
        E = "teleport"
        q.stats.motionMode = "teleport"
        ab = true
        q.groundFollower = nil
        q.stats.capsuleTrips = (q.stats.capsuleTrips or 0) + 1
        m.status("Capsule · teleporting onto selected research")
        local function ec()
          local ed, ee, ef = a0()
          return aZ(dW) and ed == dZ and ef == d0 and ee and ee.Health > 0 and m.room() == d4
        end
        local function ed()
          if not ec() or not dQ.active() then
            return false, "capsule-cancelled"
          end
          if (d0.Position - ea).Magnitude > 3 then
            return false, "capsule-position-corrected"
          end
          local ee = bq(d0.Position)
          if ee then
            return false, ee.reason
          end
          if not q.safeToPickup(d0.Position, 0.3, true, true) then
            return false, "capsule-threat"
          end
          return true
        end
        local ee, ef, eg = pcall(function()
          d0.CFrame = CFrame.new(ea) * eb.Rotation
          d0.AssemblyLinearVelocity = aK
          d0.AssemblyAngularVelocity = aK
          task.wait(0.1)
          return dQ.collect(ed)
        end)
        local eh = false
        if ec() then
          local ei = bL(eb.Position, eb.Position.Y)
          local ej = ei and CFrame.new(ei) * eb.Rotation
          if ej and not bq(ej.Position) and q.safeToPickup(ej.Position, 0.4, true, true) then
            q.groundFollower = nil
            d0.CFrame = ej
            d0.AssemblyLinearVelocity = aK
            d0.AssemblyAngularVelocity = aK
            task.wait(0.08)
            eh = ec() and (d0.Position - ej.Position).Magnitude <= 3
            if eh then
              q.stats.capsuleReturns = (q.stats.capsuleReturns or 0) + 1
            end
          end
        end
        if not ee then
          return false, "capsule-error: " .. tostring(ef), eh
        end
        if not eh then
          q.stats.capsuleReturnFailures = (q.stats.capsuleReturnFailures or 0) + 1
        end
        return ef, eh and eg or "capsule-return-unconfirmed", eh
      end)
    end
    function q.pickupPassTargets(dF, dQ, dW)
      local dZ, d_, d0 = a0()
      if not d0 then
        return nil
      end
      local d4 = bL(dF, dF.Y)
      if not d4 then
        return nil
      end
      local d5 = math.sqrt(math.max(0, (dQ - 0.6) ^ 2 - (d4.Y - dF.Y) ^ 2))
      if d5 < 0.5 then
        return nil
      end
      local d6 = aX(dF - d0.Position)
      if d6.Magnitude < 0.1 then
        d6 = aX(d0.CFrame.LookVector)
      end
      if d6.Magnitude < 0.1 then
        d6 = Vector3.new(0, 0, 1)
      end
      d6 = d6.Unit
      local d8 = Vector3.new(-d6.Z, 0, d6.X)
      local d9 = math.min(3, d5 * 0.45)
      local ea = (dW or 0) % 2 == 0 and 1 or -1
      for eb, ec in ipairs({ea * d9, -ea * d9, 0}) do
        local ed = bL(dF - d6 * d9 + d8 * ec, dF.Y)
        local ee = bL(dF + d6 * (d5 + 2.5) + d8 * ec, dF.Y)
        if ed and ee and (ed - dF).Magnitude < dQ - 0.25 and bQ(ed) and bQ(ee) and q.safeToPickup(ed, 0.5, true, true) and q.safeToPickup(ee, 0.5, true, true) and not q.itemContactAt(ed) and not q.itemContactAt(ee) and bO(ed, ee) and (not m.hazards or m.hazards.segmentClear(ed, ee)) then
          return ed, ee
        end
      end
      return nil
    end
    function q.slideToPickup(dF, dQ, dW)
      local d_ = dF and dF.Parent
      local d0 = d_ and (d_:IsA("Attachment") and d_.WorldPosition or d_:IsA("BasePart") and d_.Position)
      if not d0 then
        return false, "missing-pickup-position"
      end
      return c5(function(d4)
        local d5, d6 = q.exitElevatorForPickup(d4, d0)
        if not d5 then
          return false, d6
        end
        local d8, d9, ea = 0, 0, nil
        local function eb()
          if not aZ(d4) then
            return
          end
          if not dW.active() or dW.danger() then
            W += 1
            a4()
            return
          end
          if dW.confirmed() then
            W += 1
            a4()
            return
          end
          if os.clock() < d8 or d9 >= 4 or not dF.Parent or not dF.Enabled or not q.pickupInReach(dF) then
            return
          end
          d8 = os.clock() + 0.1
          d9 += 1
          dW.fire(d9)
        end
        local ec, ed, ee = xpcall(function()
          ea = p.Heartbeat:Connect(function()
            local ec, ed = pcall(eb)
            if not ec then
              q.stats.slidePickupError = tostring(ed)
            end
          end)
          eb()
          if dW.confirmed() then
            return true, "slide-collected"
          end
          local ec, ed = q.pickupPassTargets(d0, dF.MaxActivationDistance, dQ)
          if not ec then
            return false, "no-safe-pickup-pass"
          end
          q.stats.pickupMoveMethod = "slide"
          q.stats.slidePickupPasses = (q.stats.slidePickupPasses or 0) + 1
          m.status("Sliding past the selected item · collecting within reach")
          local ee, ef = b4(ec, 0.45, false, d4)
          if dW.confirmed() then
            return true, "slide-collected"
          end
          if not ee then
            return false, ef
          end
          eb()
          if dW.confirmed() then
            return true, "slide-collected"
          end
          return b4(ed, 0.45, false, d4)
        end, debug.traceback)
        if ea then
          ea:Disconnect()
        end
        q.stats.slidePickupAttempts = d9
        if not ec then
          return false, "slide-pickup-error: " .. tostring(ed)
        end
        return ed, ee
      end)
    end
    return q
  end
end)()

local ab = (function()
  return function(ab)
    local ac = {stats = {attempts = 0, confirmed = 0, failures = 0, blocks = 0}}
    local ad, ae, af, ag = nil, nil, nil, 0
    local ah, ai = {}, -math.huge
    local aj = {["movement-watchdog"] = true, ["route-blocked"] = true, ["blocked-destination"] = true,
      ["unsupported-tween-leg"] = true, ["no-supported-tween-route"] = true, ["no-supported-alternate-route"] = true,
      ["no-safe-tween-route"] = true, ["no-route-around-twisteds"] = true, ["native-route-without-floor"] = true,
      ["no-floor-on-route"] = true, ["route-endpoint-has-no-floor"] = true, ["server-correction"] = true,
      ["server-position-correction"] = true, ["position-correction"] = true, ["corrected-route-cooldown"] = true,
      ["no-supported-wall-shelter"] = true, ["no-safe-hiding-spot"] = true, ["no-nearby-hiding-spot"] = true,
      ["twisteds-blocking-cover-route"] = true, ["twisted-on-direct-route"] = true, ["twisteds-blocking-machine-route"] = true,
      ["no-safe-pickup-position"] = true, ["escape-blocked"] = true, ["cover-entry-incomplete"] = true,
      ["cover-entry-displaced"] = true, ["full-body-hide-interrupted"] = true}
    local function ak(al)
      return al and al.enabled and al.ready and al.floor and al.actor and al.position and not al.finished and not al.loading and not al.working and not al.covered and not al.releasing and not al.anchored and not al.grabbed and not al.inElevator and (al.activity == "machine-travel" or al.activity == "pickup")
    end
    local function al(am, an)
      ad, ae, af, ag = am and am.floor, am and am.actor, am and am.position, an
      table.clear(ah)
      ac.stats.blocks = 0
      ac.stats.ready = false
    end
    function ac.observe(am)
      local an = ab.clock()
      if not ak(am) then
        al(am, an)
        return false
      end
      if ad ~= am.floor or ae ~= am.actor or not af then
        al(am, an)
      end
      if ab.distance(am.position, af) >= 4 then
        al(am, an)
      end
      while ah[1] and an - ah[1] > 16 do
        table.remove(ah, 1)
      end
      ac.stats.blocks = #ah
      ac.stats.noProgress = an - ag
      ac.stats.cooldown = math.max(0, 45 - (an - ai))
      ac.stats.ready = not am.pendingCover and not ac.stats.running and #ah >= 3 and an - ag >= 8 and an - ai >= 45
      return ac.stats.ready
    end
    function ac.noteBlock(am, an)
      ac.observe(an)
      if not ak(an) or an.pendingCover or ac.stats.running or not aj[am] then
        return
      end
      local ao = ab.clock()
      if not ah[#ah] or ao - ah[#ah] >= 0.35 then
        ah[#ah + 1] = ao
      end
      ac.stats.lastBlock = am
      ac.stats.blocks = #ah
    end
    function ac.begin(am)
      if not ac.observe(am) then
        return false
      end
      ai = ab.clock()
      ac.stats.running = true
      ac.stats.attempts += 1
      ac.stats.ready = false
      return true
    end
    function ac.finish(am, an, ao)
      ac.stats.running = false
      ac.stats.lastResult = an
      if am then
        ac.stats.confirmed += 1
      else
        ac.stats.failures += 1
      end
      al(ao, ab.clock())
    end
    return ac
  end
end)()

-- [2 protection block(s) removed, see AntiTamper]

local ae = (function()
  return function(ae)
    local af = game:GetService("Workspace")
    local ag = {version = "ground-yaw-8", stats = {scans = 0, bodyRejected = 0, geometryRejected = 0,
      probes = 0, accepted = 0}}
    local ah, ai, aj, ak = {}, nil, -math.huge, nil
    local al, am, an, ao, ap = nil, -math.huge, nil, nil, {}
    local aq, ar, as = nil, nil, nil
    local at = {}
    local au, av
    local aw, ax = setmetatable({}, {__mode = "k"}), {}
    local ay = setmetatable({}, {__mode = "k"})
    local az = 32
    local aA = 0.04
    function ag.invalidateBody()
      am = -math.huge
      table.clear(ay)
    end
    local function aB(aC)
      return {aC.X, aC.Y, aC.Z}
    end
    local function aC(aD)
      return Vector3.new(aD.X, 0, aD.Z)
    end
    local function aD(aE)
      local aF = ae.room()
      while aE and aE ~= aF and aE ~= af do
        local aG = aE.Name:lower():gsub("[^%a]", "")
        if aG:find("table", 1, true) or aG:find("chair", 1, true) or aG:find("stool", 1, true) or aG:find("desk", 1, true) or aG:find("floor", 1, true) or aG:find("ceiling", 1, true) or aG:find("roof", 1, true) or aG:find("stair", 1, true) or aG:find("ladder", 1, true) or aG:find("ramp", 1, true) or aG == "generators" or aG == "monsters" or aG == "items" or aG == "holidaypickups" or aG:find("carpet", 1, true) or aG:find("rug", 1, true) then
          return true
        end
        aE = aE.Parent
      end
      return false
    end
    function ag.allowed(aE)
      if not aE or not aE.Parent or aD(aE) then
        return false
      end
      if ae.allowed and not ae.allowed(aE) then
        return false
      end
      if aE:IsA("BasePart") then
        return (aE.Transparency or 0) < 0.95 and (aE.CanQuery ~= false or aE.Archivable ~= false) and not aE:FindFirstChildWhichIsA("SpecialMesh")
      end
      return aE:IsA("Model")
    end
    function ag.propName(aE)
      local aF = aE.Name:lower()
      return aF:find("wall", 1, true) or aF:find("crate", 1, true) or aF:find("cone", 1, true) or aF:find("shel", 1, true) or aF:find("cabinet", 1, true) or aF:find("locker", 1, true) or aF:find("barrel", 1, true) or aF:find("box", 1, true)
    end
    function ag.nativeColliders(aE)
      if not aE:IsA("Model") or not ag.propName(aE) then
        return nil
      end
      local aF = {}
      for aG, aH in ipairs(aE:GetDescendants()) do
        if aH:IsA("Part") and aH.Shape == Enum.PartType.Block and aH.Name:lower():gsub("[^%a]", "") == "noclipcollider" and aH.CanCollide and aH.CanQuery ~= false and not aH:FindFirstChildWhichIsA("SpecialMesh") then
          aF[#aF + 1] = aH
          if #aF >= 8 then
            break
          end
        end
      end
      return #aF > 0 and aF or nil
    end
    local function aE()
      local aF, aG, aH = ae.character()
      if not aH then
        return nil
      end
      if al == aF and os.clock() - am < 0.5 then
        return aH, an, ao, ap
      end
      local aI, aJ = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
      local aK = 0
      local aL = 0
      at = {}
      local aM, aN = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
      local function aO(aP)
        aM = Vector3.new(math.min(aM.X, aP.X), math.min(aM.Y, aP.Y), math.min(aM.Z, aP.Z))
        aN = Vector3.new(math.max(aN.X, aP.X), math.max(aN.Y, aP.Y), math.max(aN.Z, aP.Z))
      end
      for aP, aQ in ipairs(aF:GetChildren()) do
        local aR = aQ.Name:lower():gsub("[^%a]", "")
        local aS = aR == "leftfoot" or aR == "rightfoot"
        local aT = aR == "leftleg" or aR == "rightleg" or aR == "leftlowerleg" or aR == "rightlowerleg"
        if aQ:IsA("BasePart") and (aQ == aH or aS or aT) then
          local aU = aQ.Size * 0.5
          local aV = -aU.Y
          local aW = aT and math.min(aU.Y, aV + math.clamp(aQ.Size.Y * 0.35, 0.3, 1.2)) or aU.Y
          for aX, aY in ipairs({-1, 1}) do
            for aZ, a_ in ipairs({aV, aW}) do
              for a0, a1 in ipairs({-1, 1}) do
                aO(aH.CFrame:PointToObjectSpace(aQ.CFrame:PointToWorldSpace(Vector3.new(aU.X * aY, a_, aU.Z * a1))))
              end
            end
          end
          if aS or aT then
            aL += 1
          end
          if aS or aT then
            for aX, aY in ipairs({-1, 1}) do
              for aZ, a_ in ipairs({-1, 1}) do
                at[#at + 1] = aH.CFrame:PointToObjectSpace(aQ.CFrame:PointToWorldSpace(Vector3.new(aU.X * aY, aV, aU.Z * a_)))
              end
            end
          end
        end
        local aU = aR == "head" or aR == "torso" or aR == "uppertorso" or aR == "lowertorso" or aR:find("leftleg", 1, true) or aR:find("rightleg", 1, true) or aR:find("leftarm", 1, true) or aR:find("rightarm", 1, true) or aR == "leftfoot" or aR == "rightfoot" or aR == "lefthand" or aR == "righthand"
        if aQ:IsA("BasePart") and (aQ == aH or (aQ.Transparency or 0) < 0.95) then
          aK += 1
          local aV = aQ.Size * 0.5
          for aW, aX in ipairs({-1, 1}) do
            for aY, aZ in ipairs({-1, 1}) do
              for a_, a0 in ipairs({-1, 1}) do
                local a1 = aH.CFrame:PointToObjectSpace(aQ.CFrame:PointToWorldSpace(Vector3.new(aV.X * aX, aV.Y * aZ, aV.Z * a0)))
                aI = Vector3.new(math.min(aI.X, a1.X), math.min(aI.Y, a1.Y), math.min(aI.Z, a1.Z))
                aJ = Vector3.new(math.max(aJ.X, a1.X), math.max(aJ.Y, a1.Y), math.max(aJ.Z, a1.Z))
              end
            end
          end
        end
      end
      if aK < 2 then
        aI = Vector3.new(-1, -3, -1)
        aJ = Vector3.new(1, 3, 1)
      end
      for aP, aQ in ipairs(aF:GetDescendants()) do
        local aR = aQ.Name:lower():gsub("[^%a]", "")
        if aQ:IsA("Bone") and (aR:find("foot", 1, true) or aR:find("feet", 1, true)) then
          local aS = aH.CFrame:PointToObjectSpace(aQ.TransformedWorldCFrame.Position)
          if aS.Y >= -25 and aS.Y <= 0 then
            aL += 1
            local aT = aS - Vector3.new(0.2, 0.12, 0.3)
            local aU = aS + Vector3.new(0.2, 0.12, 0.3)
            aO(aT)
            aO(aU)
            at[#at + 1] = aS - Vector3.new(0, 0.12, 0)
            aI = Vector3.new(math.min(aI.X, aT.X), math.min(aI.Y, aT.Y), math.min(aI.Z, aT.Z))
            aJ = Vector3.new(math.max(aJ.X, aU.X), math.max(aJ.Y, aU.Y), math.max(aJ.Z, aU.Z))
          end
        end
      end
      local aP = Vector3.new(0.3, 0, 0.3)
      aI, aJ = aI - aP, aJ + aP
      local aQ = (aI + aJ) * 0.5
      ap = {}
      for aR, aS in ipairs({aI.X, aQ.X, aJ.X}) do
        for aT, aU in ipairs({aI.Y, aQ.Y, aJ.Y}) do
          for aV, aW in ipairs({aI.Z, aQ.Z, aJ.Z}) do
            ap[#ap + 1] = Vector3.new(aS, aU, aW)
          end
        end
      end
      al, am, an, ao = aF, os.clock(), aI, aJ
      aq, ar, as = nil, nil, nil
      if aL > 0 then
        local aR = Vector3.new(0.04, 0, 0.04)
        aq, ar = aM - aR, aN + aR
        local aS = (aq + ar) * 0.5
        as = {}
        for aT, aU in ipairs({aq.X, aS.X, ar.X}) do
          for aV, aW in ipairs({aq.Y, aS.Y, ar.Y}) do
            for aX, aY in ipairs({aq.Z, aS.Z, ar.Z}) do
              as[#as + 1] = Vector3.new(aU, aW, aY)
            end
          end
        end
      end
      return aH, aI, aJ, ap
    end
    local function aF(aG)
      local aH, aI, aJ, aK = aE()
      if aG == "feet-and-root" then
        return aH, aq, ar, as
      end
      return aH, aI, aJ, aK
    end
    function ag.soleY(aG)
      aE()
      local aH = math.huge
      for aI, aJ in ipairs(at) do
        aH = math.min(aH, aG:PointToWorldSpace(aJ).Y)
      end
      if aH == math.huge and an then
        aH = aG:PointToWorldSpace(Vector3.new(0, an.Y, 0)).Y
      end
      return aH
    end
    function ag.groundPose(aG, aH)
      if not ae.floorY then
        return aG, nil
      end
      local aI = Vector3.new(aG.LookVector.X, 0, aG.LookVector.Z)
      if aI.Magnitude < 0.001 then
        aI = Vector3.new(0, 0, -1)
      end
      aG = CFrame.lookAt(aG.Position, aG.Position + aI.Unit, Vector3.new(0, 1, 0))
      local aJ = ae.floorY(aG.Position, aH)
      if type(aJ) ~= "number" then
        return nil
      end
      local aK = ag.soleY(aG)
      local aL = ae.standingOffset and ae.standingOffset()
      if type(aL) == "number" and aL == aL and aL >= 0 and aL <= 25 then
        aK = aG.Position.Y - aL
      end
      if aK == math.huge then
        return nil
      end
      return CFrame.new(aG.Position + Vector3.new(0, aJ + 0.18 - aK, 0)) * aG.Rotation, aJ
    end
    local function aG(aH)
      if aH:IsA("BasePart") then
        return aH.CFrame, aH.Size, {aH}
      end
      local aI = {}
      for aJ, aK in ipairs(aH:GetDescendants()) do
        if aK:IsA("BasePart") and ag.allowed(aK) then
          aI[#aI + 1] = aK
          if #aI > az then
            return nil
          end
        end
      end
      if #aI == 0 then
        return nil
      end
      local aJ, aK = pcall(aH.GetPivot, aH)
      if not aJ then
        aK = aI[1].CFrame
      end
      local aL, aM = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
      for aN, aO in ipairs(aI) do
        local aP = aO.Size * 0.5
        for aQ, aR in ipairs({-1, 1}) do
          for aS, aT in ipairs({-1, 1}) do
            for aU, aV in ipairs({-1, 1}) do
              local aW = aK:PointToObjectSpace(aO.CFrame:PointToWorldSpace(Vector3.new(aP.X * aR, aP.Y * aT, aP.Z * aV)))
              aL = Vector3.new(math.min(aL.X, aW.X), math.min(aL.Y, aW.Y), math.min(aL.Z, aW.Z))
              aM = Vector3.new(math.max(aM.X, aW.X), math.max(aM.Y, aW.Y), math.max(aM.Z, aW.Z))
            end
          end
        end
      end
      local aN = aK * CFrame.new((aL + aM) * 0.5)
      return aN, aM - aL, aI
    end
    local function aH(aI, aJ, aK, aL)
      local aM = aI:PointToObjectSpace(aK)
      local aN = aJ * 0.5 - Vector3.new(aL or aA, aL or aA, aL or aA)
      return aN.X > 0 and aN.Y > 0 and aN.Z > 0 and math.abs(aM.X) < aN.X and math.abs(aM.Y) < aN.Y and math.abs(aM.Z) < aN.Z
    end
    local function aI(aJ, aK)
      if not aJ:IsA("Part") or aJ:FindFirstChildWhichIsA("SpecialMesh") then
        return nil
      end
      local aL = aJ.CFrame:PointToObjectSpace(aK)
      local aM = aJ.Size * 0.5 - Vector3.new(aA, aA, aA)
      if aM.X <= 0 or aM.Y <= 0 or aM.Z <= 0 then
        return false
      end
      if aJ.Shape == Enum.PartType.Block then
        return math.abs(aL.X) < aM.X and math.abs(aL.Y) < aM.Y and math.abs(aL.Z) < aM.Z
      end
      if aJ.Shape == Enum.PartType.Ball then
        return (aL.X / aM.X) ^ 2 + (aL.Y / aM.Y) ^ 2 + (aL.Z / aM.Z) ^ 2 < 1
      end
      if aJ.Shape == Enum.PartType.Cylinder then
        return math.abs(aL.X) < aM.X and (aL.Y / aM.Y) ^ 2 + (aL.Z / aM.Z) ^ 2 < 1
      end
      return nil
    end
    local function aJ()
      if au and au.Parent then
        return au
      end
      av = Instance.new("Folder")
      av.Name = "GograCoverQueries"
      av.Parent = af
      au = Instance.new("Part")
      au.Name = "InteriorProbe"
      au.Anchored = true
      au.CanCollide = false
      au.CanTouch = false
      au.CanQuery = false
      au.Transparency = 1
      au.Size = Vector3.new(0.08, 0.08, 0.08)
      au.Parent = av
      return au
    end
    local function aK(aL)
      if aL.CanQuery ~= false then
        return aL, false
      end
      local aM = aw[aL]
      if not aM then
        local aN, aO = pcall(function()
          return aL:Clone()
        end)
        if not aN or not aO then
          return nil
        end
        aM = aO
        local aP = pcall(function()
          aM:ClearAllChildren()
          aM.Name = "GograCoverQueryGeometry"
          aM.Parent = nil
          aM.Anchored = true
          aM.CanCollide = false
          aM.CanTouch = false
          aM.CanQuery = true
          aM.Transparency = 1
          aM.CastShadow = false
          aM.CollisionGroup = "Default"
        end)
        if not aP then
          aM:Destroy()
          return nil
        end
        aw[aL] = aM
        ax[#ax + 1] = aL
        while #ax > 12 do
          local aQ = table.remove(ax, 1)
          local aR = aw[aQ]
          if aR then
            aR:Destroy()
            aw[aQ] = nil
          end
        end
      end
      aM.Size = aL.Size
      aM.CFrame = aL.CFrame
      aM.Parent = av
      return aM, true
    end
    local function aL(aM, aN)
      if not aH(aM.CFrame, aM.Size, aN, aA) then
        return false
      end
      if ag.remainingProbes and ag.remainingProbes < 7 then
        return false
      end
      local aO = aJ()
      aO.CFrame = CFrame.new(aN)
      local aP, aQ = aK(aM)
      if not aP then
        return false
      end
      local aR, aS = pcall(function()
        local aR = OverlapParams.new()
        aR.FilterType = Enum.RaycastFilterType.Include
        aR.FilterDescendantsInstances = {aP}
        aR.MaxParts = 1
        aR.RespectCanCollide = false
        ag.stats.probes += 1
        if ag.remainingProbes then
          ag.remainingProbes -= 1
        end
        if #af:GetPartsInPart(aO, aR) == 0 then
          return false
        end
        local aS = RaycastParams.new()
        aS.FilterType = Enum.RaycastFilterType.Include
        aS.FilterDescendantsInstances = {aP}
        aS.IgnoreWater = true
        aS.RespectCanCollide = false
        local aT = aM.Size.Magnitude + 2
        for aU, aV in ipairs({aM.CFrame.RightVector, aM.CFrame.UpVector, aM.CFrame.LookVector}) do
          for aW, aX in ipairs({-1, 1}) do
            local aY = aV * aX
            ag.stats.probes += 1
            if ag.remainingProbes then
              ag.remainingProbes -= 1
            end
            local aZ = af:Raycast(aN + aY * aT, -aY * aT, aS)
            if not aZ or aZ.Instance ~= aP or (aZ.Position - aN):Dot(aY) < aA then
              return false
            end
          end
        end
        return true
      end)
      if aQ then
        aP.Parent = nil
      end
      return aR and aS == true
    end
    local function aM(aN, aO, aP)
      for aQ, aR in ipairs(aN) do
        if aP and not aP() then
          return false
        end
        local aS = aI(aR, aO)
        if aS == true then
          return true
        end
        if aS == nil and aL(aR, aO) then
          return true
        end
      end
      return false
    end
    function ag.fitsBounds(aN, aO)
      local aP, aQ, aR, aS = aF(aN and aN.fitMode)
      if not aS or not aN or not aN.object.Parent then
        return false
      end
      for aT, aU in ipairs(aS) do
        if not aH(aN.boundsCFrame, aN.boundsSize, aO:PointToWorldSpace(aU), aA) then
          return false
        end
      end
      return true
    end
    function ag.contains(aN, aO, aR, aS)
      if not aN or not aN.object.Parent then
        return false
      end
      local aT, aU, aV, aW = aF(aN.fitMode)
      if not aW then
        return false
      end
      if aN.grounded and math.abs(ag.soleY(aO) - aN.groundY) > 0.35 then
        return false
      end
      local aX, aY, aZ = aG(aN.object)
      if not aX then
        return false
      end
      aN.boundsCFrame, aN.boundsSize, aN.parts = aX, aY, aZ
      if aN.nativeColliders then
        if not ag.fitsBounds(aN, aO) then
          return false
        end
        for a_, a0 in ipairs(aN.nativeColliders) do
          if not a0.Parent or not a0:IsDescendantOf(aN.object) or not a0.CanCollide or a0.CanQuery == false then
            continue
          end
          local a1 = true
          for a2, a3 in ipairs(aW) do
            if aI(a0, aO:PointToWorldSpace(a3)) ~= true then
              a1 = false
              break
            end
          end
          if a1 then
            aN.part, aN.collider = a0, a0
            aN.colliderCFrame, aN.colliderSize = a0.CFrame, a0.Size
            aN.verification = "native-solid-prop-collider-and-visible-" .. (aN.fitMode or "full-body")
            return true
          end
        end
        return false
      end
      local a_ = ay[aN.object]
      if not aR and a_ and a_.root == aO and a_.cover == aX and a_.size == aY and a_.fitMode == aN.fitMode and a_.bodyLo == aU and a_.bodyHi == aV and os.clock() - a_.at < 0.75 then
        return a_.result
      end
      if not ag.fitsBounds(aN, aO) then
        return false
      end
      if not ag.searching then
        ag.remainingProbes = 250
      end
      local a0 = false
      for a1, a2 in ipairs(aZ) do
        local a3 = true
        for a4, a6 in ipairs(aW) do
          if aI(a2, aO:PointToWorldSpace(a6)) ~= true then
            a3 = false
            break
          end
        end
        if a3 then
          a0 = true
          break
        end
      end
      local a1 = a0
      if not a0 then
        a1 = true
        for a2, a3 in ipairs(aW) do
          if not aM(aZ, aO:PointToWorldSpace(a3), aS) then
            a1 = false
            break
          end
        end
      end
      ay[aN.object] = {root = aO, cover = aX, size = aY, bodyLo = aU, bodyHi = aV, fitMode = aN.fitMode,
        at = os.clock(), result = a1}
      if a1 then
        aN.verification = (a0 and "convex-" or "sampled-collision-and-surface-") .. (aN.fitMode or "full-body")
      end
      return a1
    end
    local function aN(aO)
      local aR = ae.room()
      while aO and aO ~= aR do
        if aO.Name:lower():find("wall", 1, true) then
          return true
        end
        aO = aO.Parent
      end
      return false
    end
    function ag.candidate(aO, aR, aS, aT, aU, aV, aW)
      if not ag.allowed(aO) then
        return nil
      end
      aU = aU or "full-body"
      local aX, aY, aZ = aF(aU)
      if not aX or not aY then
        return nil
      end
      local a_, a0, a1 = aG(aO)
      if not a_ then
        return nil
      end
      local a2 = ag.nativeColliders(aO)
      local a3 = ae.maxDistance or 65
      if (a_.Position - aR).Magnitude > a3 + a0.Magnitude * 0.5 then
        return nil
      end
      local a4
      local a6, a7 = aY, aZ
      for a8 = 0, 1 do
        if a8 == 1 then
          if not CFrame.Angles then
            continue
          end
          aY = Vector3.new(a6.Z, a6.Y, -a7.X)
          aZ = Vector3.new(a7.Z, a7.Y, -a6.X)
        end
        local a9 = a0 * 0.5
        local ba = -a9 - aY + Vector3.new(aA, aA, aA)
        local bb = a9 - aZ - Vector3.new(aA, aA, aA)
        if ba.X > bb.X or ba.Y > bb.Y or ba.Z > bb.Z then
          ag.stats.bodyRejected += 1
          continue
        end
        local bc = - (aY + aZ) * 0.5
        local bd = a_:PointToObjectSpace(aR)
        local be = Vector3.new(math.clamp(bd.X, ba.X, bb.X), math.clamp(bd.Y, ba.Y, bb.Y), math.clamp(bd.Z, ba.Z, bb.Z))
        local bh = math.min(0.1, (bb.X - ba.X) * 0.25)
        local bi = math.min(0.1, (bb.Z - ba.Z) * 0.25)
        if aV then
          be = Vector3.new(math.clamp(be.X, ba.X + bh, bb.X - bh), be.Y, math.clamp(be.Z, ba.Z + bi, bb.Z - bi))
        end
        bc = Vector3.new(math.clamp(bc.X, ba.X, bb.X), math.clamp(bc.Y, ba.Y, bb.Y), math.clamp(bc.Z, ba.Z, bb.Z))
        local bj = {bc, be, Vector3.new(bc.X, ba.Y, bc.Z), Vector3.new(bc.X, (ba.Y + bc.Y) * 0.5, bc.Z)}
        if aV then
          for bk, bl in ipairs({ba.X + bh, bb.X - bh}) do
            bj[#bj + 1] = Vector3.new(bl, be.Y, be.Z)
          end
          for bk, bl in ipairs({ba.Z + bi, bb.Z - bi}) do
            bj[#bj + 1] = Vector3.new(be.X, be.Y, bl)
          end
        end
        for bk, bl in ipairs(bj) do
          if aW and not aW() then
            return a4
          end
          local bm = a_ * CFrame.new(bl)
          if a8 == 1 then
            bm *= CFrame.Angles(0, math.pi * 0.5, 0)
          end
          local bn
          bm, bn = ag.groundPose(bm, aR)
          if not bm then
            continue
          end
          if (bm.Position - aR).Magnitude > a3 then
            continue
          end
          local bo = {object = aO, part = a1[1], parts = a1, nativeColliders = a2, position = bm.Position,
            cframe = bm, kind = "wall", boundsCFrame = a_, boundsSize = a0, visualOnly = true, fitMode = aU,
            grounded = bn ~= nil, groundY = bn, quarterTurn = a8}
          if not ag.contains(bo, bm, true, aW) then
            ag.stats.geometryRejected += 1
            continue
          end
          if ae.safe and not ae.safe(bo) then
            continue
          end
          local bp = (bm.Position - aR).Magnitude
          local bq = aN(aO)
          if typeof(aS) == "Vector3" then
            local bs = aS
            local bt = aT and aT:FindFirstChild("TeleportPositions")
            bt = bt and bt:FindFirstChild("TeleportPosition")
            if aT and aT:IsA("Model") then
              bs = aT:GetPivot().Position
            end
            local by = (bm.Position - bs).Magnitude
            bp += by * ((not ae.preferWalls or ae.preferWalls()) and 0.7 or 0.15)
            if bq and by < 30 and (not ae.preferWalls or ae.preferWalls()) then
              local bB = aC(bs - (bt and bt:IsA("BasePart") and bt.Position or aR))
              local bC = aC(bm.Position - bs)
              if bB.Magnitude > 0.5 and bC.Magnitude > 0.5 and bB.Unit:Dot(bC.Unit) > 0.2 then
                bp -= 30
                bo.behindMachine = true
              else
                bp -= 12
              end
            end
          elseif bq and (not ae.preferWalls or ae.preferWalls()) then
            bp -= 5
          end
          if aU == "feet-and-root" then
            bp += 1000
          end
          bo.score = bp
          if aV then
            local bs = false
            for bt, by in ipairs(aV) do
              if by.object == aO and by.fitMode == aU and by.quarterTurn == a8 and (by.position - bo.position).Magnitude < 1 then
                bs = true
                break
              end
            end
            if not bs then
              aV[#aV + 1] = bo
            end
          end
          if not a4 or bp < a4.score then
            a4 = bo
          end
        end
      end
      if a4 then
        ag.stats.accepted += 1
      end
      return a4
    end
    local function aO(aR, aS)
      local aT = ae.room()
      if aT == ai and ak and (aR - ak).Magnitude < 8 and os.clock() - aj < 1 then
        return ah
      end
      ai, aj, ah, ak = aT, os.clock(), {}, aR
      if not aT then
        return ah
      end
      local aU = {}
      local aV
      if af.GetPartBoundsInRadius then
        local aW = OverlapParams.new()
        aW.FilterType = Enum.RaycastFilterType.Include
        aW.FilterDescendantsInstances = {aT}
        aW.RespectCanCollide = false
        aV = af:GetPartBoundsInRadius(aR, (ae.maxDistance or 65) + 8, aW)
        ag.stats.spatialQueries = (ag.stats.spatialQueries or 0) + 1
      else
        aV = aT:GetDescendants()
      end
      for aW, aX in ipairs(aV) do
        if aS and not aS() then
          aj = -math.huge
          break
        end
        local aY = aX.Parent
        for aZ = 1, 4 do
          if not aY or aY == aT then
            break
          end
          if aY:IsA("Model") and not aU[aY] and ag.allowed(aY) and ag.propName(aY) then
            ah[#ah + 1] = aY
            aU[aY] = true
          end
          aY = aY.Parent
        end
        if aX:IsA("BasePart") and ag.allowed(aX) then
          ah[#ah + 1] = aX
        end
      end
      ag.stats.scans += 1
      return ah
    end
    function ag.candidates(aR, aS, aT, aU, aV, aW)
      ag.searching = true
      ag.remainingProbes = aV and 420 or 210
      local aX, aY, aZ = aF("full-body")
      local a_, a0, a1 = aF("feet-and-root")
      local function a2(a3, a4, a6)
        return a4 and a3.Y >= a6.Y - a4.Y + 2 * aA and (a3.X >= a6.X - a4.X + 2 * aA and a3.Z >= a6.Z - a4.Z + 2 * aA or a3.X >= a6.Z - a4.Z + 2 * aA and a3.Z >= a6.X - a4.X + 2 * aA)
      end
      local a3 = {}
      for a4, a6 in ipairs(aO(aR, aW)) do
        if aW and not aW() then
          break
        end
        if not a6.Parent then
          continue
        end
        local a7, a8 = aG(a6)
        if a7 then
          local a9 = (a7.Position - aR).Magnitude
          local ba, bb = a2(a8, aY, aZ), a2(a8, a0, a1)
          if a9 <= (ae.maxDistance or 65) + a8.Magnitude * 0.5 and (ba or bb) then
            local bc = a9 + (not aV and typeof(aS) == "Vector3" and (a7.Position - aS).Magnitude * 0.7 or 0)
            if aN(a6) and (not ae.preferWalls or ae.preferWalls()) then
              bc -= aV and 2 or 10
            end
            a3[#a3 + 1] = {object = a6, score = bc, fullFit = ba, feetFit = bb}
          elseif not ba and not bb then
            ag.stats.bodyRejected += 1
          end
        end
      end
      table.sort(a3, function(a4, a6)
        return a4.score < a6.score
      end)
      local a4 = {}
      for a6, a7 in ipairs({"full-body", "feet-and-root"}) do
        if a7 == "feet-and-root" and ae.allowPartial and not ae.allowPartial() then
          continue
        end
        local a8, a9, ba = 0, 0, 0
        for bb, bc in ipairs(a3) do
          if aW and not aW() then
            break
          end
          if not (a7 == "full-body" and bc.fullFit or a7 == "feet-and-root" and bc.feetFit) then
            continue
          end
          a9 += 1
          if a9 > (aV and 32 or 16) then
            break
          end
          local bd = bc.object
          if not bd:IsA("Part") or bd:FindFirstChildWhichIsA("SpecialMesh") then
            a8 += 1
            if a8 > (aV and 3 or 2) then
              continue
            end
          end
          local be = ag.candidate(bd, aR, aS, aT, a7, aV and a4 or nil, aW)
          if be then
            if not aV then
              a4[#a4 + 1] = be
            end
            ba += 1
          end
          if ba >= math.max(4, aU or 8) then
            break
          end
        end
      end
      table.sort(a4, function(a6, a7)
        if aV then
          local function a8(a9)
            return (a9.position - aR).Magnitude + (a9.fitMode == "feet-and-root" and 1000 or 0) - (a9.behindMachine and 2 or 0)
          end
          return a8(a6) < a8(a7)
        end
        return a6.score < a7.score
      end)
      ag.searching = false
      return a4
    end
    function ag.destroy()
      for aR, aS in pairs(aw) do
        aS:Destroy()
      end
      table.clear(aw)
      table.clear(ax)
      if av then
        av:Destroy()
        av = nil
        au = nil
      end
      table.clear(ah)
      table.clear(ay)
    end
    return ag
  end
end)()

local af = (function()
  return function(af)
    local ag = {stats = {locks = 0, stopped = 0, errors = 0}, active = false}
    local ah, ai, aj, ak, al
    local am, an, ao = {}, {}, {}
    local function ap(aq)
      if not ag.active or not aq or ag.suppressing then
        return
      end
      ag.suppressing = true
      local ar = pcall(function()
        if not ao[aq] then
          ao[aq] = true
          if aq.Looped and af.idle(aq) then
            am[#am + 1] = {track = aq, speed = aq.Speed, time = aq.TimePosition}
          end
        end
        aq:Stop(0)
        ag.stats.stopped += 1
      end)
      ag.suppressing = false
      if not ar then
        ag.stats.errors += 1
      end
    end
    function ag.pulse()
      if not ag.active then
        return
      end
      if ai and ai.Parent then
        local aq, ar = pcall(ai.GetPlayingAnimationTracks, ai)
        if aq then
          for as, at in ipairs(ar) do
            ap(at)
          end
        end
      end
      for aq, ar in ipairs(an) do
        if ar.Parent then
          pcall(function()
            ar.Transform = af.identity
          end)
        end
      end
    end
    function ag.release()
      if not ag.active then
        return
      end
      ag.active = false
      if al then
        al:Disconnect()
        al = nil
      end
      if aj and aj.Parent then
        pcall(function()
          aj.Disabled = ak
        end)
      end
      local aq = af.character()
      if aq == ah and af.run() then
        for ar, as in ipairs(am) do
          pcall(function()
            as.track:Play(0.1, 1, as.speed)
            as.track.TimePosition = as.time
          end)
        end
      end
      ah, ai, aj = nil, nil, nil
      am, an, ao = {}, {}, {}
      ag.settled = false
    end
    function ag.acquire()
      if not af.run() then
        ag.release()
        return false
      end
      local aq, ar = af.character()
      if not aq or not ar then
        return false
      end
      if ag.active and ah == aq then
        return false
      end
      ag.release()
      ah = aq
      ag.active = true
      ag.stats.locks += 1
      ai = ar:FindFirstChildOfClass("Animator")
      aj = aq:FindFirstChild("ToonAnimate") or aq:FindFirstChild("Animate")
      if aj and aj:IsA("BaseScript") then
        ak = aj.Disabled
        aj.Disabled = true
      else
        aj = nil
      end
      for as, at in ipairs(aq:GetDescendants()) do
        if at:IsA("Motor6D") or at:IsA("Bone") then
          an[#an + 1] = at
        end
      end
      if ai then
        al = ai.AnimationPlayed:Connect(ap)
      end
      ag.pulse()
      return true
    end
    function ag.settle()
      if ag.active and not ag.settled then
        af.wait()
        ag.pulse()
        ag.settled = true
      end
    end
    function ag.destroy()
      ag.release()
    end
    return ag
  end
end)()

local ag = (function()
  return function(ag)
    local ah
    local ai = {stats = {samples = 0, corrections = 0, blocked = 0}}
    function ai.reset()
      ah = nil
    end
    function ai.project(aj, ak)
      local al = ag.room()
      local am = ag.position(ak)
      local an = ag.position(ag.current(aj))
      local ao = ag.offset(aj, ak)
      if not al or not ao or ao ~= ao then
        return nil, "ground-context-unavailable"
      end
      local ap = ah
      if ap and (ap.root ~= aj or ap.room ~= al or (am.X - ap.x) ^ 2 + (am.Z - ap.z) ^ 2 > 256 or (an.X - ap.x) ^ 2 + (an.Z - ap.z) ^ 2 > 6.25 or math.abs(an.Y - ap.y) > 0.75) then
        ap = nil
      end
      local aq = ap and ap.ground or an.Y - ao
      if not ap and ag.recover then
        local ar = ag.recover(aj, ao, aq)
        if type(ar) == "number" and ar == ar and ar < math.huge and ar > aq then
          aq = ar
        end
      end
      local ar = ap and math.sqrt((am.X - ap.x) ^ 2 + (am.Z - ap.z) ^ 2) or 0
      local as = ap and (ap.slope or ap.stairs) and math.max(ag.stepRise or 2.5, ar * 1.8 + 0.2) or (ag.stepRise or 2.5)
      local at, au, av = ag.sample(am, aq + as)
      ai.stats.samples += 1
      if type(at) ~= "number" or at ~= at then
        ai.stats.blocked += 1
        return nil, "no-floor-under-movement"
      end
      local aw = ap and at - ap.ground or 0
      local ax = type(av) == "number" and av >= 0.5 and av < 0.999
      local ay = ap and ap.slope
      local az = false
      if ap and ar > 0.01 and (ax or ay) and math.abs(aw) > 0.65 then
        local aA = {X = (am.X + ap.x) * 0.5, Y = am.Y, Z = (am.Z + ap.z) * 0.5}
        local aB = ag.sample(aA, aq + as)
        az = type(aB) == "number" and math.abs(aB - (at + ap.ground) * 0.5) <= 0.25 and math.abs(aw) <= ar * 1.8 + 0.15
      end
      local aA = au or ap and ap.stairs or az
      local aB = az and math.max(ag.stepRise or 2.5, ar * 1.8 + 0.15) or (ag.stepRise or 2.5)
      if aw > aB + 0.05 or aw > 0.65 and not aA then
        ai.stats.blocked += 1
        return nil, "rise-without-stairs"
      end
      if aw < - (ag.maxDrop or 6) and not aA then
        ai.stats.blocked += 1
        return nil, "drop-without-stairs"
      end
      local aC = at + ao + (ag.padding and ag.padding() or 0.06)
      if math.abs(am.Y - aC) > 0.035 then
        ai.stats.corrections += 1
      end
      ai.stats.groundY = at
      ai.stats.offset = ao
      ai.stats.gap = aC - ao - at
      ah = {root = aj, room = al, ground = at, stairs = au == true, slope = ax, x = am.X, y = aC, z = am.Z}
      return ag.pose(ak, am.X, aC, am.Z)
    end
    return ai
  end
end)()

local ah = (function()
  return function(ah)
    return function(ai, aj, ak)
      local al = ah.value(ah.current(ai))
      local am = ah.tween(al, aj, {Value = ak.CFrame})
      local an, ao
      local ap, aq = false, false
      local ar = ah.current(ai)
      local as = -math.huge
      local function at()
        if ap then
          return
        end
        ap = true
        if an then
          pcall(an.Disconnect, an)
          an = nil
        end
        if ao then
          pcall(ao.Disconnect, ao)
          ao = nil
        end
        pcall(al.Destroy, al)
      end
      local function au(av)
        at()
        if ah.blocked then
          pcall(ah.blocked, av)
        end
        pcall(am.Cancel, am)
      end
      local function av(aw, ax)
        if ap then
          return
        end
        if ah.clock and ah.minInterval and not ax then
          local ay = ah.clock()
          if ay - as < ah.minInterval then
            if ah.throttled then
              ah.throttled()
            end
            return
          end
        end
        if ah.displaced then
          local ay, az, aA = pcall(ah.displaced, ai, ar, ah.current(ai))
          if not ay then
            au("tween-displacement-check-error: " .. tostring(az))
            return
          end
          if az then
            au(aA or "server-correction")
            return
          end
        end
        local ay, az, aA = pcall(ah.apply, ai, aw)
        if not ay then
          au("tween-apply-error: " .. tostring(az))
        elseif not az then
          au(aA)
        else
          ar = ah.current(ai)
          if ah.clock then
            as = ah.clock()
          end
        end
      end
      an = al.Changed:Connect(function(aw)
        av(aw, false)
      end)
      ao = am.Completed:Connect(function()
        if ap or aq then
          return
        end
        aq = true
        if ah.completed and ah.completed(am) then
          av(al.Value, true)
        end
        at()
      end)
      return setmetatable({Play = function()
        if not ap then
          am:Play()
        end
      end, Cancel = function()
        at()
        pcall(am.Cancel, am)
      end}, {__index = function(aw, ax)
        return am[ax]
      end})
    end
  end
end)()

local ai = (function()
  return function(ai)
    local aj = game:GetService("RunService")
    local ak = game:GetService("Workspace")
    local al = false
    local am = false
    local an = nil
    local ao = nil
    local ap = false
    local aq = {enabled = false, lastError = nil, stats = {checks = 0, repairs = 0, failures = 0, fullRefreshes = 0,
      guardScans = 0}}
    local function ar(as)
      aq.lastError = tostring(as)
      aq.stats.failures += 1
      if ai.report then
        pcall(ai.report, "noclip-error", aq.lastError)
      end
      if not ap then
        ap = true
        warn("Floor Auto noclip: " .. aq.lastError)
      end
    end
    local function as(at)
      local au, av = pcall(function()
        return at.Connected
      end)
      if au and av == false then
        return false, true
      end
      local aw, ax = pcall(function()
        return at.Enabled
      end)
      if not aw or type(ax) ~= "boolean" then
        error("Cannot inspect a root CanCollide connection safely", 0)
      end
      return ax, false
    end
    local function at(au, av)
      aq.stats.guardScans += 1
      av = av or au.root
      if type(getconnections) ~= "function" then
        error("getconnections is unavailable; noclip stayed off", 0)
      end
      local aw = getconnections(av:GetPropertyChangedSignal("CanCollide"))
      if type(aw) ~= "table" then
        error("Cannot enumerate root CanCollide connections; noclip stayed off", 0)
      end
      for ax, ay in ipairs(aw) do
        local az, aA = as(ay)
        if az and not aA then
          if type(ay.Disable) ~= "function" or type(ay.Enable) ~= "function" then
            error("A root CanCollide connection cannot be paused and restored", 0)
          end
          if not au.guards[ay] then
            au.guards[ay] = {connection = ay, wasEnabled = true}
          end
          ay:Disable()
          local aB, aC = as(ay)
          if aB and not aC then
            error("A root CanCollide guard did not disable; no new flags were changed", 0)
          end
        end
      end
    end
    local function au(av, aw)
      if aw:IsA("BasePart") and av.parts[aw] == nil then
        av.parts[aw] = aw.CanCollide
      end
    end
    local function av()
      if type(ai.room) == "function" then
        return ai.room()
      end
      local aw = ak:FindFirstChild("CurrentRoom")
      if aw then
        for ax, ay in ipairs(aw:GetChildren()) do
          if ay:FindFirstChild("Generators") and ay:FindFirstChild("Items") then
            return ay
          end
        end
      end
      return nil
    end
    local function aw(ax, ay, az)
      local aA = {ax.character}
      local aB = ak:FindFirstChild("InGamePlayers")
      if aB then
        table.insert(aA, aB)
      end
      if az then
        for aC, aD in ipairs({"Monsters", "Items", "Generators", "HolidayPickups"}) do
          local aE = az:FindFirstChild(aD)
          if aE then
            table.insert(aA, aE)
          end
        end
      end
      local aC = RaycastParams.new()
      aC.FilterType = Enum.RaycastFilterType.Exclude
      aC.FilterDescendantsInstances = aA
      aC.IgnoreWater = true
      aC.RespectCanCollide = true
      aC.CollisionGroup = "Default"
      local aD
      for aE = 1, 24 do
        aC.FilterDescendantsInstances = aA
        aD = ak:Raycast(ay + Vector3.new(0, 0.2, 0), Vector3.new(0, -14, 0), aC)
        if not aD then
          return nil
        end
        local aF = aD.Instance
        local aG = false
        while aF and aF ~= az and aF ~= ak do
          local aH = aF.Name:lower()
          if aH:find("floor", 1, true) or aH:find("ground", 1, true) or aH:find("stair", 1, true) or aH:find("ramp", 1, true) or aH:find("platform", 1, true) or aH:find("elevator", 1, true) then
            aG = true
            break
          end
          aF = aF.Parent
        end
        if aG and aD.Normal.Y > 0.6 then
          break
        end
        table.insert(aA, aD.Instance)
        aD = nil
      end
      if not aD then
        return nil
      end
      local aE = ak:FindFirstChild("Elevators")
      if az and not aD.Instance:IsDescendantOf(az) and not (aE and aD.Instance:IsDescendantOf(aE)) then
        return nil
      end
      local aF = ay.Y - aD.Position.Y
      if aF < 0.7 or aF > 10 then
        return nil
      end
      return aD.Position.Y, aF
    end
    local function ax(ay, az, aA)
      local aB = ay.root
      local aC = az.HipHeight + aB.Size.Y * 0.5
      if az.RigType == Enum.HumanoidRigType.R6 then
        local aD = ay.character:FindFirstChild("Left Leg") or ay.character:FindFirstChild("Right Leg")
        aC = aC + (aD and aD.Size.Y or 2)
      end
      local aD, aE = aw(ay, aB.Position, aA)
      local aF = math.clamp(aC, 1.5, 6)
      if aE and aE >= 1.25 and aE <= 6.5 and math.abs(aB.AssemblyLinearVelocity.Y) < 2 and math.abs(aE - aF) <= 1.5 then
        aF = aE
      end
      ay.support = {room = aA, standing = aF, ground = aD, position = aB.Position}
    end
    local function ay(az, aA)
      local aB = az.root
      local aC = aB.Position
      local aD = aB.AssemblyLinearVelocity
      local aE = ai.enforceGround ~= nil
      local aF = aE and ai.enforceGround() == true
      if aE then
        aC = aB.Position
        aD = aB.AssemblyLinearVelocity
      end
      local aG = av()
      local aH = az.support
      if not aH or aH.room ~= aG or (aC - aH.position).Magnitude > 60 or (math.abs(aC.Y - aH.position.Y) > 12 and math.abs(aD.Y) < 1) then
        ax(az, aA, aG)
        aH = az.support
      end
      aH.position = aC
      if not az.force then
        az.attachment = Instance.new("Attachment")
        az.attachment.Name = "FloorAutoGravityAttachment"
        az.attachment.Parent = aB
        az.force = Instance.new("VectorForce")
        az.force.Name = "FloorAutoGravityBalance"
        az.force.Attachment0 = az.attachment
        az.force.RelativeTo = Enum.ActuatorRelativeTo.World
        az.force.ApplyAtCenterOfMass = true
        az.force.Parent = aB
      end
      local aI, aJ
      if not aE then
        aI, aJ = aw(az, aC, aG)
      end
      local aK = ai.cover or {}
      local aL = aK.active or aK.pending or aK.waitingForExit
      local aM = ai.ownsHeight and ai.ownsHeight() == true
      local aN = aA:GetState()
      if not aM and (aA.Jump or aN == Enum.HumanoidStateType.Jumping or not az.balanced and aN == Enum.HumanoidStateType.Freefall and aD.Y > 2) then
        az.jumping = true
      end
      local aO = aI ~= nil and aJ <= aH.standing + 0.35
      if az.jumping and aD.Y <= 0 and aO then
        az.jumping = false
      end
      local aR = not aB.Anchored and (aE and aF or not aE and (aM or not az.jumping and (aO or aL)))
      az.force.Force = aR and Vector3.new(0, aB.AssemblyMass * ak.Gravity, 0) or Vector3.zero
      if aR and aD.Y ~= 0 then
        aB.AssemblyLinearVelocity = Vector3.new(aD.X, 0, aD.Z)
      end
      az.balanced = aR
    end
    local function az(aA)
      if not aA then
        return true
      end
      if aA.force then
        aA.force:Destroy()
        aA.force = nil
      end
      if aA.attachment then
        aA.attachment:Destroy()
        aA.attachment = nil
      end
      if aA.added then
        aA.added:Disconnect()
        aA.added = nil
      end
      local aB = {}
      if next(aA.changed) ~= nil then
        local aC, aD = pcall(at, aA)
        if not aC then
          return false, "Restoration is pending: " .. tostring(aD)
        end
        for aE, aF in pairs(aA.changed) do
          local aG, aH = pcall(function()
            if aE.CanCollide ~= aF then
              aE.CanCollide = aF
            end
            if aE.CanCollide ~= aF then
              error("CanCollide did not restore", 0)
            end
          end)
          if aG then
            aA.changed[aE] = nil
          else
            table.insert(aB, tostring(aH))
          end
        end
        if next(aA.changed) ~= nil then
          return false, "Character collision restoration is pending: " .. table.concat(aB, "; ")
        end
      end
      for aC, aD in pairs(aA.guards) do
        local aE, aF = pcall(function()
          local aE, aF = as(aC)
          if not aF and aD.wasEnabled and not aE then
            aC:Enable()
            local aG, aH = as(aC)
            if not aG and not aH then
              error("A root CanCollide guard did not restore", 0)
            end
          end
        end)
        if aE then
          aA.guards[aC] = nil
        else
          table.insert(aB, tostring(aF))
        end
      end
      if next(aA.guards) ~= nil then
        return false, "Root collision guard restoration is pending: " .. table.concat(aB, "; ")
      end
      return true
    end
    local function aA()
      if not ao then
        return true
      end
      local aB, aC = az(ao)
      if aB then
        ao = nil
      end
      return aB, aC
    end
    local function aB(aC)
      local aD = false
      for aE, aF in pairs(aC.parts) do
        if aE.Parent and aE:IsDescendantOf(aC.character) then
          if aE.CanCollide then
            if not aD then
              at(aC)
              aD = true
            end
            if aE ~= aC.root then
              at(aC, aE)
            end
            aC.changed[aE] = aF
            aE.CanCollide = false
            aq.stats.repairs += 1
            if aE.CanCollide then
              aq.stats.blockedPart = aE.Name
              error("Character collision restored on " .. aE.Name, 0)
            end
          end
        elseif aC.changed[aE] ~= nil then
          aE.CanCollide = aC.changed[aE]
          aC.changed[aE] = nil
          aC.parts[aE] = nil
        else
          aC.parts[aE] = nil
        end
      end
    end
    local function aC()
      aq.stats.fullRefreshes += 1
      if not al then
        return aA()
      end
      local aD, aE, aF = ai.character()
      if ao and (ao.character ~= aD or ao.root ~= aF) then
        local aG, aH = aA()
        if not aG then
          return false, aH
        end
      end
      if not aD or not aE or not aF or aE.Health <= 0 then
        return aA()
      end
      if not aF:IsA("BasePart") or not aF:IsDescendantOf(aD) then
        return false, "The current character root is invalid; noclip stayed off"
      end
      if not ao then
        ao = {character = aD, root = aF, parts = {}, changed = {}, guards = {}}
        for aG, aH in ipairs(aD:GetDescendants()) do
          au(ao, aH)
        end
        au(ao, aF)
        ax(ao, aE, av())
        at(ao)
        local aG = ao
        ao.added = aD.DescendantAdded:Connect(function(aH)
          if al and ao == aG then
            local aI, aJ = pcall(au, aG, aH)
            if not aI then
              ar(aJ)
            end
          end
        end)
      end
      aB(ao)
      ay(ao, aE)
      return true
    end
    local function aD()
      if not al and not ao and an then
        an:Disconnect()
        an = nil
      end
    end
    local function aE(aF)
      al = false
      aq.enabled = false
      ar(aF)
      local aG, aH, aI = pcall(aA)
      if not aG or not aH then
        ar(aG and aI or aH)
      end
      aD()
    end
    local function aF()
      if an then
        return
      end
      an = (aj.PreSimulation or aj.Stepped):Connect(function()
        local aG, aH, aI = pcall(aC)
        if not aG or not aH then
          aE(aG and aI or aH)
        end
        aD()
      end)
    end
    function aq.ensure()
      if not al or am then
        return false, "noclip-not-enabled"
      end
      aq.stats.checks += 1
      local aG, aH, aI = ai.character()
      if ao and ao.character == aG and ao.root == aI and aH and aH.Health > 0 then
        local aJ, aK = pcall(aB, ao)
        if aJ then
          return true
        end
        ar(aK)
        return false, "noclip-not-ready"
      end
      local aJ, aK, aL = pcall(aC)
      if not aJ or not aK then
        ar(aJ and aL or aK)
        return false, "noclip-not-ready"
      end
      return true
    end
    function aq.setEnabled(aG)
      aG = aG == true
      if not aG and not am and ai.keepEnabled and ai.keepEnabled() then
        aG = true
        aq.stats.retainedCleanupRequests = (aq.stats.retainedCleanupRequests or 0) + 1
      end
      if aG and am then
        return false, "Noclip helper is destroyed"
      end
      if not aG then
        al = false
        aq.enabled = false
        local aH, aI, aJ = pcall(aA)
        if not aH or not aI then
          ar(aH and aJ or aI)
          aF()
          return false, aq.lastError
        end
        aD()
        return true
      end
      if al then
        return aq.ensure()
      end
      if ao then
        local aH, aI, aJ = pcall(aA)
        if not aH or not aI then
          ar(aH and aJ or aI)
          aF()
          return false, aq.lastError
        end
      end
      al = true
      aq.enabled = true
      local aH, aI, aJ = pcall(aC)
      if not aH or not aI then
        aE(aH and aJ or aI)
        if ao then
          aF()
        end
        return false, aq.lastError
      end
      aq.lastError = nil
      aF()
      return true
    end
    function aq.destroy()
      am = true
      return aq.setEnabled(false)
    end
    return aq
  end
end)()

local aj = (function()
  return function(aj)
    local ak = game:GetService("Players")
    local al = game:GetService("PathfindingService")
    local am = game:GetService("ReplicatedStorage")
    local an = ak.LocalPlayer
    local ao = {stats = {paths = 0, replans = 0, switches = 0}, blockedUntil = {}, serial = 0}
    local ap = game:GetService("RunService")
    local aq, ar, as, at, au, av
    local function aw(ax, ay)
      return Vector3.new(ax.X - ay.X, 0, ax.Z - ay.Z).Magnitude
    end
    function ao.passedWaypoint(ax, ay, az)
      if aw(ax, ay) <= 1.5 then
        return true
      end
      local aA = Vector3.new(ay.X - az.X, 0, ay.Z - az.Z)
      local aB = Vector3.new(ax.X - ay.X, 0, ax.Z - ay.Z)
      return aA.Magnitude > 0.1 and aB:Dot(aA) >= 0 and aw(ax, ay) < 6
    end
    local function ax(ay, az)
      as = ay
      local aA, aB, aC = aj.character()
      if not aC then
        return
      end
      local aD = Vector3.new(as.X - aC.Position.X, 0, as.Z - aC.Position.Z)
      if aD.Magnitude > 0.1 then
        au = aD.Unit
      end
      if ar then
        return
      end
      if not aq then
        pcall(function()
          aq = require(an.PlayerScripts.PlayerModule):GetControls()
          aq:Disable()
        end)
      end
      if at == nil then
        at = aB.AutoRotate
      end
      aB.AutoRotate = true
      ar = "GograLobbySteer_" .. tostring(ao)
      ap:BindToRenderStep(ar, Enum.RenderPriority.Character.Value + 1, function(aE)
        local aF, aG, aH = aj.character()
        if not aG or not aH then
          return
        end
        local aI = as and Vector3.new(as.X - aH.Position.X, 0, as.Z - aH.Position.Z) or Vector3.zero
        local aJ = aI.Magnitude > 0.05 and aI.Unit or au or Vector3.zero
        if au and aI:Dot(au) <= 0 then
          aJ = au
        end
        av = av and av:Lerp(aJ, math.clamp((aE or 0.016666666666666666) * 25, 0, 1)) or aJ
        aG:Move(av.Magnitude > 0.01 and av.Unit or Vector3.zero, false)
      end)
    end
    local function ay()
      as = nil
      if ar then
        ap:UnbindFromRenderStep(ar)
        ar = nil
      end
      au, av = nil, nil
      local az, aA = aj.character()
      if aA then
        aA:Move(Vector3.zero, false)
      end
      if aA and at ~= nil then
        aA.AutoRotate = at
      end
      at = nil
      if aq then
        aq:Enable()
        aq = nil
      end
    end
    local az, aA, aB = nil, 0, false
    local function aC()
      return workspace:FindFirstChild("Elevators")
    end
    function ao.isLobby()
      local aD = aC()
      return workspace:FindFirstChild("Lobby") ~= nil and aD and aD:FindFirstChild("LeftGate") ~= nil
    end
    local function aD(aE)
      return aj.enabled() and ao.serial == aE and ao.isLobby()
    end
    local function aE(aF)
      if aB == aF then
        return
      end
      aB, aA = aF, os.clock()
      if not az then
        pcall(function()
          az = require(am.SharedUtils.InputService)
        end)
      end
      local aG = az and az._actions and az._actions.Sprint
      if aG and type(firesignal) == "function" then
        pcall(firesignal, aF and aG.Pressed or aG.Released)
      end
      local aH = am:FindFirstChild("Events")
      local aI = aH and aH:FindFirstChild("SprintEvent")
      if aI then
        pcall(function()
          aI:FireServer(aF)
        end)
      end
    end
    local function aF(aG)
      local aH = aG and aG:FindFirstChild("Elevator")
      return aH and aH:FindFirstChild("Base")
    end
    function ao.inside(aG, aH)
      local aI = aF(aG)
      if not aI then
        return false
      end
      local aJ = aI.CFrame:PointToObjectSpace(aH)
      return math.abs(aJ.X) < aI.Size.X * 0.5 - 0.5 and math.abs(aJ.Z) < aI.Size.Z * 0.5 - 0.5 and aJ.Y > 0 and aJ.Y < 12
    end
    function ao.occupied(aG)
      if not aG or not aG.Parent then
        return true
      end
      local aH = aG:FindFirstChild("Status")
      if aH then
        for aI, aJ in ipairs(aH:GetDescendants()) do
          if aJ:IsA("ObjectValue") and aJ.Value and aJ.Value ~= an and aJ.Value ~= an.Character then
            return true
          end
          if aJ.Name ~= an.Name and (aJ:IsA("StringValue") and aJ.Value ~= "" and aJ.Value ~= an.Name or aJ:IsA("BoolValue") and aJ.Value and ak:FindFirstChild(aJ.Name)) then
            return true
          end
        end
      end
      for aI, aJ in ipairs(ak:GetPlayers()) do
        if aJ ~= an then
          local aK = aJ.Character
          local aL = aK and aK:FindFirstChild("HumanoidRootPart")
          if aL and ao.inside(aG, aL.Position) then
            return true
          end
        end
      end
      return false
    end
    function ao.queued(aG)
      local aH = aG and aG:FindFirstChild("Status")
      if aH then
        for aI, aJ in ipairs(aH:GetDescendants()) do
          if aJ:IsA("ObjectValue") and aJ.Value ~= nil and (aJ.Value == an or aJ.Value == an.Character) or aJ:IsA("StringValue") and aJ.Value == an.Name or aJ:IsA("BoolValue") and aJ.Name == an.Name and aJ.Value then
            return true
          end
        end
      end
      return false
    end
    function ao.findLeaveButton(aG)
      if not aG then
        return nil
      end
      for aH, aI in ipairs(aG:GetDescendants()) do
        if not (aI:IsA("TextButton") or aI:IsA("ImageButton")) then
          continue
        end
        local aJ = aI:GetFullName():lower():gsub("[^%a]", "")
        local aK = aI:IsA("TextButton") and aI.Text or ""
        for aL, aM in ipairs(aI:GetDescendants()) do
          if aM:IsA("TextLabel") then
            aK ..= " " .. aM.Text
          end
        end
        aK = aK:lower():gsub("[^%a]", "")
        local aL = aJ:find("leaveelevator", 1, true) or aK:find("leaveelevator", 1, true) or (aJ:find("elevator", 1, true) or aJ:find("queue", 1, true) or aJ:find("lift", 1, true)) and (aK == "leave" or aK == "exit" or aI.Name:lower():find("leave", 1, true))
        if not aL then
          continue
        end
        local aM = true
        local aN = aI
        while aN and aN ~= aG do
          if aN:IsA("GuiObject") and not aN.Visible or aN:IsA("LayerCollector") and not aN.Enabled then
            aM = false
            break
          end
          aN = aN.Parent
        end
        local aO, aR = pcall(function()
          return aI.Interactable
        end)
        if aM and (not aO or aR ~= false) then
          return aI
        end
      end
    end
    function ao.clickLeaveElevator()
      if aj.leaveElevator then
        return aj.leaveElevator()
      end
      if os.clock() - (ao.lastLeaveAt or -math.huge) < 0.35 then
        return false
      end
      ao.lastLeaveAt = os.clock()
      local aG = ao.findLeaveButton(an:FindFirstChildOfClass("PlayerGui"))
      if not aG then
        ao.stats.leaveError = "native Leave Elevator button is not visible"
        return false
      end
      if ao.lastLeaveButton ~= aG then
        ao.lastLeaveButton = aG
        ao.leaveAttempts = 0
      end
      ao.leaveAttempts = (ao.leaveAttempts or 0) + 1
      if ao.leaveAttempts % 2 == 1 then
        local aH = pcall(function()
          local aH = aG.AbsolutePosition + aG.AbsoluteSize * 0.5
          local aI = game:GetService("VirtualInputManager")
          aI:SendMouseButtonEvent(aH.X, aH.Y, 0, true, game, 0)
          aI:SendMouseButtonEvent(aH.X, aH.Y, 0, false, game, 0)
        end)
        if aH then
          ao.stats.leaveClicks = (ao.stats.leaveClicks or 0) + 1
          ao.stats.leaveSignal = "native mouse input"
          ao.stats.leaveError = nil
          return true
        end
      end
      for aH, aI in ipairs({"Activated", "MouseButton1Click", "MouseButton1Up", "MouseButton1Down"}) do
        local aJ = aG[aI]
        local aK = true
        if type(getconnections) == "function" then
          local aL, aM = pcall(getconnections, aJ)
          aK = aL and #aM > 0
        end
        if aK and type(firesignal) == "function" then
          local aL = pcall(firesignal, aJ)
          if aL then
            ao.stats.leaveClicks = (ao.stats.leaveClicks or 0) + 1
            ao.stats.leaveSignal = aI
            ao.stats.leaveError = nil
            return true
          end
        end
      end
      local aH = pcall(function()
        local aH = aG.AbsolutePosition + aG.AbsoluteSize * 0.5
        local aI = game:GetService("VirtualInputManager")
        aI:SendMouseButtonEvent(aH.X, aH.Y, 0, true, game, 0)
        aI:SendMouseButtonEvent(aH.X, aH.Y, 0, false, game, 0)
      end)
      if aH then
        ao.stats.leaveClicks = (ao.stats.leaveClicks or 0) + 1
        ao.stats.leaveSignal = "native mouse input"
        ao.stats.leaveError = nil
      end
      return aH
    end
    local function aG(aH)
      local aI = aH:FindFirstChild("Elevator")
      local aJ = aI and aI:FindFirstChild("Opened")
      return aF(aH) and aH:FindFirstChild("spawn") and (not aJ or aJ.Value) and not ao.occupied(aH) and os.clock() >= (ao.blockedUntil[aH] or 0)
    end
    function ao.choose()
      local aH, aI, aJ = aj.character()
      local aK = aC()
      if not aJ or not aK then
        return nil
      end
      local aL, aM
      for aN, aO in ipairs(aK:GetChildren()) do
        if aG(aO) then
          local aR = (aO.spawn.Position - aJ.Position).Magnitude
          if not aM or aR < aM then
            aL, aM = aO, aR
          end
        end
      end
      return aL
    end
    local function aI(aJ, aK, aL)
      local aM, aN, aO = aj.character()
      if not aN or not aO then
        return false, "character-missing"
      end
      local aR = al:CreatePath({AgentRadius = 1.5, AgentHeight = 5, AgentCanJump = true, WaypointSpacing = 4})
      local aS = pcall(function()
        aR:ComputeAsync(aO.Position, aJ)
      end)
      if not aS or aR.Status ~= Enum.PathStatus.Success then
        return false, "path-unavailable"
      end
      ao.stats.paths += 1
      local aT = false
      local aU = 1
      local aV = aR.Blocked:Connect(function(aV)
        if aV >= aU then
          aT = true
        end
      end)
      local function aW(aY, aZ)
        aV:Disconnect()
        if not aY then
          aE(false)
          ay()
        end
        return aY, aZ
      end
      local aY = aR:GetWaypoints()
      for aZ, a_ in ipairs(aY) do
        aU = aZ
        if not aD(aK) then
          return aW(false, "cancelled")
        end
        if aL and not aL() then
          return aW(false, "occupied")
        end
        if a_.Action == Enum.PathWaypointAction.Jump then
          aN.Jump = true
        end
        ax(a_.Position)
        aE(true)
        local a0, a1, a2 = os.clock(), os.clock(), aO.Position
        local a3 = aZ > 1 and aY[aZ - 1].Position or a2
        while not ao.passedWaypoint(aO.Position, a_.Position, a3) do
          if not aD(aK) or aj.character() ~= aM then
            return aW(false, "cancelled")
          end
          if aL and not aL() then
            return aW(false, "occupied")
          end
          if aT then
            return aW(false, "path-blocked")
          end
          if (aO.Position - a2).Magnitude > 0.6 then
            a2, a1 = aO.Position, os.clock()
          end
          if os.clock() - a1 > 1.5 or os.clock() - a0 > 5 then
            return aW(false, "stuck")
          end
          aE(true)
          task.wait(0.1)
        end
      end
      return aW(true, "arrived")
    end
    function ao.stop()
      ao.serial += 1
      aE(false)
      ay()
      local aJ, aK, aL = aj.character()
      if aK and aL then
        aK:MoveTo(aL.Position)
        aK:Move(Vector3.zero)
      end
    end
    function ao.step()
      local aJ = ao.serial
      local aK, aL, aM = aj.character()
      if not aL or not aM or aL.Health <= 0 then
        aj.status("Lobby · waiting for character")
        return
      end
      if not ao.target and not ao.leaving then
        local aN = aC()
        if aN then
          for aO, aR in ipairs(aN:GetChildren()) do
            if ao.queued(aR) or ao.inside(aR, aM.Position) then
              ao.target = aR
              break
            end
          end
        end
      end
      if ao.leaving then
        aE(false)
        ay()
        if not ao.inside(ao.leaving, aM.Position) and not ao.queued(ao.leaving) then
          ao.leaving = nil
          ao.target = nil
          ao.leaveAttempts = 0
          ao.stats.leavesConfirmed = (ao.stats.leavesConfirmed or 0) + 1
          aj.status("Lobby · left elevator; selecting an empty elevator")
          return
        end
        ao.clickLeaveElevator()
        aj.status("Lobby · pressing Leave Elevator; waiting for the queue to release")
        return
      end
      if ao.target and ao.occupied(ao.target) then
        local aN = ao.target
        ao.blockedUntil[aN] = os.clock() + 8
        ao.target = nil
        ao.stats.switches += 1
        aE(false)
        ay()
        if ao.inside(aN, aM.Position) or ao.queued(aN) then
          ao.leaving = aN
          ao.clickLeaveElevator()
          aj.status("Lobby · someone entered; pressing Leave Elevator")
        else
          aj.status("Lobby · elevator occupied; selecting another empty elevator")
        end
        return
      end
      if ao.target and ao.inside(ao.target, aM.Position) then
        aE(false)
        aj.status("Lobby · alone in " .. ao.target.Name .. "; waiting for teleport")
        return
      end
      ao.target = ao.target or ao.choose()
      if not ao.target then
        aE(false)
        aj.status("Lobby · waiting for an empty elevator")
        return
      end
      local aN = ao.target
      aj.status("Lobby · pathfinding to " .. aN.Name)
      local aO = aN:FindFirstChild("Gate")
      local aR = aF(aN)
      if not aO or not aR then
        ao.target = nil
        return
      end
      local aS = Vector3.new(aO.Position.X - aR.Position.X, 0, aO.Position.Z - aR.Position.Z).Unit
      local aT, aU = aI(aO.Position + aS * 8, aJ, function()
        return not ao.occupied(aN)
      end)
      if aT then
        ax(aO.Position - aS * 2, true)
        aE(true)
        local aV = os.clock() + 4
        repeat
          if not aD(aJ) then
            aE(false)
            ay()
            return
          end
          if ao.occupied(aN) then
            aT, aU = false, "occupied"
            break
          end
          if ao.inside(aN, aM.Position) then
            aU = "boarded"
            break
          end
          task.wait(0.1)
        until os.clock() > aV
        aE(false)
        ay()
        if not ao.inside(aN, aM.Position) then
          aT, aU = false, "entry-unconfirmed"
        end
      end
      ao.stats.lastReason = aU
      if not aT then
        ao.stats.replans += 1
        if aU == "occupied" and ao.inside(aN, aM.Position) then
          ao.target = aN
          return
        end
        if aU == "occupied" then
          ao.stats.switches += 1
        end
        ao.blockedUntil[aN] = os.clock() + (aU == "occupied" and 8 or 3)
        ao.target = nil
      end
    end
    return ao
  end
end)()

local ak = (function()
  return function()
    local ak = {floorSeen = false}
    function ak.ready(al)
      local am = al.run == true and (al.floor or 0) >= 1 and al.mapReady == true and al.loading ~= true and al.floorActive == true and al.alive == true
      if am then
        ak.floorSeen = true
      end
      return am
    end
    function ak.shouldReturn(al)
      return al.run == true and al.solo ~= false and (al.otherPlayers or 0) > 0
    end
    return ak
  end
end)()

local al = (function()
  return function(al)
    local am = {values = {}, gained = {}, stats = {updates = 0, gains = 0}, initialized = false}
    local an, ao = nil, math.huge
    local function ap(aq)
      return tostring(aq or ""):lower():gsub("monster$", ""):gsub("[^%w]", "")
    end
    function am.step()
      local aq = al.folder()
      if not aq then
        return
      end
      local ar = al.clock()
      if an ~= aq then
        an = aq
        am.values = {}
        am.initialized = false
        ao = ar + (al.settleSeconds or 0.5)
      end
      local as = am.initialized
      local at = aq:GetChildren()
      if #at == 0 and not as then
        ao = ar + (al.settleSeconds or 0.5)
      end
      for au, av in ipairs(at) do
        if not (av:IsA("NumberValue") or av:IsA("IntValue")) then
          continue
        end
        local aw = tonumber(av.Value)
        if not aw or aw ~= aw then
          continue
        end
        local ax = math.clamp(aw, 0, 100)
        local ay = ap(av.Name)
        local az = am.values[ay]
        if az ~= nil and ax < az then
          continue
        end
        if not as and az == nil then
          ao = ar + (al.settleSeconds or 0.5)
        end
        am.values[ay] = ax
        if as and az ~= nil and ax > az then
          local aA = ax - az
          am.gained[ay] = (am.gained[ay] or 0) + aA
          am.stats.gains += 1
          am.stats.updates += aA
          if al.onGain then
            al.onGain(av.Name, aA, ax)
          end
        elseif as and az == nil and al.known and al.known(av.Name) and ax > 0 then
          am.gained[ay] = (am.gained[ay] or 0) + ax
          am.stats.gains += 1
          am.stats.updates += ax
          if al.onGain then
            al.onGain(av.Name, ax, ax)
          end
        end
      end
      if ar >= ao then
        am.initialized = true
      end
    end
    function am.percent(aq)
      return am.values[ap(aq)]
    end
    function am.gain(aq)
      return am.gained[ap(aq)] or 0
    end
    function am.describe(aq, ar, as, at)
      at = at or {}
      local au = {(tostring(aq.Name):gsub("Monster$", ""))}
      local function av(aw)
        return string.format("%.1f", aw):gsub("%.0$", "")
      end
      if at.espResearch ~= false then
        local aw = am.percent(aq.Name)
        local ax = am.gain(aq.Name)
        au[#au + 1] = aw and ("Research " .. av(aw) .. "%" .. (ax > 0 and " (+" .. av(ax) .. "% run)" or aw >= 100 and " · complete" or "")) or "Research: waiting for data"
      end
      if at.espThreatDetails ~= false then
        local aw = aq:FindFirstChild("ChasingValue", true)
        local ax = aw and aw.Value
        local ay = aq:FindFirstChild("IsStationary")
        local az = ax and (ax == ar or ax == as or ar and type(ax.IsDescendantOf) == "function" and ax:IsDescendantOf(ar))
        local aA = az and "Chasing YOU" or ax and ("Chasing " .. ax.Name) or "Wandering / idle"
        local aB = tostring(aq.Name):lower():find("gourdy", 1, true)
        if aB and aq:GetAttribute("GourdyEmerging") == true and aq:GetAttribute("GourdyEmergenceComplete") ~= true then
          aA = "Standing up"
        elseif ay and ay.Value == true or aq:GetAttribute("IsStationary") == true then
          aA = aB and "Dormant" or aA .. " · stationary"
        end
        local aC = aq:FindFirstChild("Chaser")
        local aD = aC and aC:FindFirstChild("RunSpeed")
        if aD and type(aD.Value) == "number" and aD.Value > 0 then
          aA ..= " · speed " .. av(aD.Value)
        end
        if aB then
          local aE = tonumber(aq:GetAttribute("GourdyRagePercent")) or tonumber(aq:GetAttribute("MadnessPercent"))
          if not aE then
            local aF = aq:FindFirstChild("GourdyRageBar", true)
            local aG = aF and (aF:FindFirstChild("Fill", true) or aF:FindFirstChild("fill", true))
            if aG and aG:IsA("GuiObject") then
              aE = aG.Size.X.Scale * 100
            end
          end
          if aE then
            aA ..= " · madness " .. av(math.clamp(aE, 0, 100)) .. "%"
          end
        end
        au[#au + 1] = aA
      end
      return table.concat(au, "\n")
    end
    function am.snapshot()
      return {values = table.clone(am.values), gained = table.clone(am.gained), updates = am.stats.updates}
    end
    return am
  end
end)()

local am = (function()
  return function(am)
    local an = (function()
      return function(an)
        local ao = {session = nil, nextScan = 0, stats = {sessions = 0, glides = 0, coins = 0, lastTarget = 0}}
        local ap, aq, ar, as, at
        local au = setmetatable({}, {__mode = "k"})
        local av = an.workspace or workspace
        local aw = an.clock or os.clock
        function ao.target(ax)
          local ay = ax.Fish
          local az = ay and ay.Part
          if not az or ay.Destroyed or ax.Destroyed or ax._torndown or ax._countingDown or not ax.AllowTick then
            return nil
          end
          local aA = ax.GAME_CONFIG.SCREEN_HEIGHT
          local aB = az.Position
          local aC = az.Size.Y * 0.5 + 0.4
          local aD, aE = -aA * 0.5 + aC, aA * 0.5 - aC
          local aF = math.huge
          local aG
          for aI, aJ in pairs(ax._objects or {}) do
            if aJ ~= ay and not aJ.Destroyed and aJ.Model and aJ.Model.Name == "ObstacleSet" then
              local aK = aJ.Model:GetPivot().Position.X
              local aL = ax.GAME_CONFIG.MIN_SIZE.X
              if aK + aL * 0.5 >= aB.X - az.Size.X * 0.5 - 0.5 and aK < aF then
                local aM = {}
                for aN, aO in ipairs(aJ.Model:GetChildren()) do
                  if aO:IsA("BasePart") and aO ~= aJ.Model.PrimaryPart and aO.Size.Z > 1 then
                    table.insert(aM, aO)
                  end
                end
                if #aM >= 2 then
                  table.sort(aM, function(aN, aO)
                    return aN.Position.Y < aO.Position.Y
                  end)
                  aD = aM[1].Position.Y + aM[1].Size.Y * 0.5 + aC
                  aE = aM[#aM].Position.Y - aM[#aM].Size.Y * 0.5 - aC
                  aF = aK
                  aG = aJ
                end
              end
            end
          end
          if aD >= aE then
            return nil
          end
          local aI = (aD + aE) * 0.5
          local aJ = aG and aG.Coin
          if aE - aD > 0.2 and (not an.options or an.options.barnabyCoins ~= false) and aJ and aJ.Parent and not aG.CoinCollected then
            aI = math.clamp(aJ.Position.Y, aD + 0.1, aE - 0.1)
          end
          return aI, aD, aE, aG
        end
        function ao.velocity(ax, ay, az, aA, aB)
          local aC = math.clamp((ay - ax) * 10, -60, 60)
          return aC / 60 - (aB or -5) * math.clamp(az, 0, 0.1) * aA
        end
        function ao.reset()
          if ap then
            if rawget(ap, "tick") == as then
              ap.tick = ar
            end
            if not ap.Destroyed then
              ap.Weightless = at
            end
          end
          ap, aq, ar, as, at = nil, nil, nil, nil, nil
          ao.session = nil
          ao.nextScan = 0
          au = setmetatable({}, {__mode = "k"})
        end
        local function ax(ay)
          local az = av and av:FindFirstChild("Info")
          local aA = az and az:GetAttribute("BarnabyGravity") or 0.75
          if type(aA) ~= "number" or aA <= 0 then
            aA = 0.75
          end
          if az and az:GetAttribute("BarnabyGravityFromSkillCheck") == true then
            local aB = az:GetAttribute("BarnabyGravityStrength") or 0.5
            local aC = ay and ay:FindFirstChild("Stats")
            local aD = aC and aC:FindFirstChild("SkillCheckChance")
            aA *= 1 - math.clamp(aD and aD.Value or 15, 0, 100) / 100 * math.clamp(aB, 0, 1)
          end
          return aA
        end
        function ao.step()
          local ay = an.character()
          local az = ay and ay:FindFirstChild("Decoding")
          local aA = az and az.Value
          if not aA or aA:GetAttribute("MinigameType") ~= "Barnaby" then
            ao.reset()
            return false
          end
          if an.options and an.options.autoBarnaby == false then
            ao.reset()
            return true
          end
          local aB = ao.session
          if aB and (aB.Model ~= aA or aB._torndown or aB.Destroyed or not aB.Fish or aB.Fish.Destroyed) then
            ao.reset()
            aB = nil
          end
          if not aB and aw() >= ao.nextScan then
            ao.nextScan = aw() + 0.35
            if an.sessions or type(getgc) == "function" then
              for aC, aD in ipairs(an.sessions and an.sessions() or getgc(true)) do
                if type(aD) == "table" and rawget(aD, "Model") == aA and rawget(aD, "Fish") and rawget(aD, "GAME_CONFIG") and not rawget(aD, "_torndown") and not rawget(aD, "Destroyed") then
                  aB = aD
                  ao.session = aD
                  ao.stats.sessions += 1
                  break
                end
              end
            end
          end
          if not aB then
            return true
          end
          local aC = aB.Fish
          if ap ~= aC then
            if ap then
              ao.reset()
              ao.session = aB
            end
            if type(aC.tick) ~= "function" then
              ao.stats.lastReason = "waiting-for-native-fish"
              return true
            end
            ap, aq, ar, at = aC, aC.tick, rawget(aC, "tick"), aC.Weightless
            local aD = aq
            as = function(aE, aF, ...)
              local aG = an.character()
              local aI = aG and aG:FindFirstChild("Decoding")
              local aJ = aG == ay and aI and aI.Value == aA and ao.session == aB and (not an.alive or an.alive()) and (not an.options or an.options.autoBarnaby ~= false)
              if aJ then
                local aK = ao.target(aB)
                if aK then
                  aE.Weightless = false
                  aE.Velocity_Y = ao.velocity(aE.Part.Position.Y, aK, aF, ax(aG), aE.Acceleration_Y)
                  ao.stats.glides += 1
                  ao.stats.lastTarget = aK
                  for aL, aM in pairs(aB._objects or {}) do
                    if aM.CoinCollected and not au[aM] then
                      au[aM] = true
                      ao.stats.coins += 1
                    end
                  end
                end
              end
              return aD(aE, aF, ...)
            end
            aC.tick = as
          end
          return true
        end
        return ao
      end
    end)()
    local ao = (function()
      return function(ao)
        local ap = {stats = {responses = 0, passedThrough = 0, blocked = 0}}
        local aq, ar, as
        local at = ao.env or getgenv()
        local au, av = false, false
        local aw = ao.readCallback or getcallbackvalue
        local function ax()
          if av and at.scinstant == false then
            at.scinstant = au
          end
          av = false
        end
        function ap.start()
          if type(aw) ~= "function" then
            ap.stats.lastReason = "callback-read-unavailable"
            return false
          end
          if not aq then
            local ay = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
            aq = ao.event or (ay and ay:FindFirstChild("SkillcheckUpdate"))
          end
          if not aq then
            ap.stats.lastReason = "skill-callback-unavailable"
            return false
          end
          local ay, az = pcall(aw, aq, "OnClientInvoke")
          if not ay or type(az) ~= "function" then
            ap.stats.lastReason = "skill-callback-unavailable"
            return false
          end
          if as and az == as then
            return true
          end
          ar = az
          local aA = ar
          as = function(aB, ...)
            if av then
              at.scinstant = false
            end
            local aC = ao.machine()
            if aB ~= "cancel" and aC and aB == aC and ao.enabled() and ao.options.extractionMode == "instant" then
              local aD, aE = pcall(ao.canExtract)
              if aD and aE then
                ap.stats.responses += 1
                ap.stats.lastReason = "instant-great-response"
                return "supercomplete"
              end
              ap.stats.blocked += 1
              ap.stats.lastReason = "unsafe-check-blocked"
              return "noinput"
            end
            ap.stats.passedThrough += 1
            return aA(aB, ...)
          end
          local aB, aC = pcall(function()
            aq.OnClientInvoke = as
          end)
          if not aB then
            as = nil
            ar = nil
            ap.stats.lastReason = tostring(aC)
            return false
          end
          if not av and at.scinstant ~= nil then
            au = at.scinstant
            av = true
          end
          if av then
            at.scinstant = false
          end
          ap.stats.lastReason = "callback-ready"
          return true
        end
        function ap.stop()
          if aq and as then
            local ay, az = pcall(aw, aq, "OnClientInvoke")
            if ay and az == as then
              pcall(function()
                aq.OnClientInvoke = ar
              end)
            end
          end
          as = nil
          ar = nil
          aq = nil
          ax()
          ap.stats.lastReason = "released"
        end
        return ap
      end
    end)()
    local ap = an(am)
    local aq = game:GetService("ReplicatedStorage")
    local ar = game:GetService("RunService")
    local as = game:GetService("UserInputService")
    local at = am.gameContext
    local au = am.inputService
    local av = am.circleHandler
    local aw = am.treadmillHandler
    local ax = nil
    local ay = false
    local az = 0
    local aA = 0
    local aB = 0
    local aC = nil
    local aD = nil
    local aE = false
    local aF = nil
    local aG = nil
    local aI = nil
    local aJ = nil
    local aK = false
    local aL = false
    local aM = {taps = 0, checks = 0, errors = 0, lastType = "none", lastError = nil}
    local aN = {stats = aM, arcade = ap}
    local aO = ao({options = am.options or {}, machine = function()
      local aO = am.character and am.character()
      local aR = aO and aO:FindFirstChild("Decoding")
      return aR and aR.Value
    end, canExtract = function()
      return am.canExtract and am.canExtract()
    end, enabled = function()
      return ay and am.alive()
    end})
    aN.instant = aO
    local aR = 0
    function aN.circleDecision(aS, aT, aU, aV, aW)
      if not aT or aS >= aT or type(aU) ~= "number" or type(aV) ~= "number" or aV <= aU then
        return false
      end
      local aY = math.min(1, (aV - aU) * 0.1)
      if aS <= aU + aY or aS > aV - aY then
        return false
      end
      local aZ = math.clamp((aT - aS) / math.max(0.001, aW or 0.016666666666666666), 0, 2000)
      local a_ = math.min(aV - aY, (aU + aV) * 0.5 + aZ * 0.01)
      return aS <= a_ or aS - aZ * math.max(0.001, aW or 0.016666666666666666) <= aU + aY
    end
    local function aS()
      aC = nil
      aD = nil
      aE = false
      aF = nil
      if aG then
        aG:Disconnect()
        aG = nil
      end
      aI = nil
      aJ = nil
      aK = false
      aL = false
    end
    local function aT(aU, aV)
      local aW = aU
      for aY, aZ in ipairs(aV) do
        aW = aW and aW:FindFirstChild(aZ)
      end
      if not aW or not aW:IsA("ModuleScript") then
        error("Native skill-check module is not available yet", 0)
      end
      return require(aW)
    end
    local function aU(aV)
      return ay and aV == az and am.alive()
    end
    local function aV(aW, aY)
      if am.canExtract and not am.canExtract() then
        return false
      end
      if not aU(aW) or os.clock() - aA < 0.07 then
        return false
      end
      if as:GetFocusedTextBox() or au:IsTyping() then
        return false
      end
      local aZ = au._actions and au._actions.SkillCheckTap
      if not aZ or not aZ.Parent then
        return false
      end
      if not aU(aW) then
        return false
      end
      aA = os.clock()
      firesignal(aZ.Pressed)
      aM.taps = aM.taps + 1
      aM.lastType = aY
      return true
    end
    local function aW(aY)
      if not aU(aY) then
        return
      end
      if os.clock() >= aR then
        aR = os.clock() + 0.5
        aO.start()
      end
      if am.canExtract and not am.canExtract() then
        ap.reset()
        aS()
        return
      end
      local aZ, a_ = am.character()
      if not aZ or not a_ or a_.Health <= 0 then
        ap.reset()
        aS()
        return
      end
      if ap.step() then
        return
      end
      if not at.skillchecking then
        aS()
        return
      end
      local a0 = aw and aw.ActiveSkillCheck
      if a0 and a0.isActive and a0.isActive() then
        if a0 ~= aI then
          aI = a0
          aM.checks = aM.checks + 1
        end
        local a1 = a0.ui
        if a1 and a1.Frame and a1.Frame.Parent and a1.Frame.Visible then
          aV(aY, "treadmill")
        end
        return
      end
      aI = nil
      local a1 = av and av.ActiveSkillCheck
      if a1 then
        if a1 ~= aC then
          if aG then
            aG:Disconnect()
            aG = nil
          end
          aC = a1
          aD = nil
          aE = false
          aF = nil
          aM.checks = aM.checks + 1
          local a2 = a1.ui and a1.ui.ShrinkingCircle
          if a2 and typeof(a2) == "Instance" then
            aG = a2:GetPropertyChangedSignal("Size"):Connect(function()
              if aU(aY) and aC == a1 and not aE then
                local a3, a4 = pcall(aW, aY)
                if not a3 then
                  aM.errors += 1
                  aM.lastError = tostring(a4)
                end
              end
            end)
          end
        end
        local a2 = a1.ui
        if not a2 or not a2.Frame or not a2.Frame.Parent or not a2.Frame.Visible then
          return
        end
        local a3 = a2.ShrinkingCircle
        local a4 = a2.Zones
        if not a3 or not a4 or not a4.yellow or not a4.black then
          return
        end
        local a6 = a3.Size.X.Offset
        local a7 = aD
        local a8 = os.clock()
        local a9 = aF and a8 - aF or 0.016666666666666666
        if a6 ~= a7 then
          aD = a6
          aF = a8
        end
        local ba = am.options and am.options.extractionMode == "normal"
        local bb = ba and a4.yellow.size or a4.black.size
        local bc = ba and a4.grey and a4.grey.size or a4.yellow.size
        if not aE and aN.circleDecision(a6, a7, bb, bc, a9) then
          aE = true
          if aV(aY, "circle") then
            aM.lastCircleDiameter = a6
            aM.lastCircleLow = bb
            aM.lastCircleHigh = bc
          else
            aE = false
          end
        end
        return
      end
      aC = nil
      aD = nil
      aE = false
      if aG then
        aG:Disconnect()
        aG = nil
      end
      local a2 = at.Gui
      local a3 = a2 and a2:FindFirstChild("Menu")
      local a4 = a3 and a3:FindFirstChild("SkillCheckFrame")
      if not a4 or not a4.Visible then
        aL = false
        aJ = nil
        aK = false
        return
      end
      local a6 = a4:FindFirstChild("Marker")
      local a7 = a4:FindFirstChild("GoldArea")
      local a8 = a4:FindFirstChild("RequiredArea")
      if not a6 or not a7 or not a8 then
        return
      end
      local a9 = a6.Position.X.Scale
      if not aL or (aJ and a9 < aJ - 0.05) then
        aK = false
        aM.checks = aM.checks + 1
      end
      aL = true
      local ba = aJ
      aJ = a9
      if aK or not ba or a9 <= ba then
        return
      end
      local bb = a7.Position.X.Scale
      local bc = bb + a7.Size.X.Scale
      local bd = math.min(0.004, a7.Size.X.Scale * 0.1)
      local be = a9 >= bb + bd and a9 <= bc - bd
      local bh = a8.Position.X.Scale
      local bi = bh + a8.Size.X.Scale
      local bj = a9 > bc and a9 >= bh and a9 <= bi - 0.004
      local bk = am.options and am.options.extractionMode == "normal"
      local bl = bk and a9 >= bh + 0.004 and a9 <= bi - 0.004
      if bl or (not bk and (be or bj)) then
        if aV(aY, "horizontal") then
          aK = true
        end
      end
    end
    function aN.start()
      if ay then
        return true
      end
      local aY, aZ = pcall(function()
        if type(firesignal) ~= "function" then
          error("Native skill input support is unavailable", 0)
        end
        at = at or aT(aq, {"Modules", "Core", "GameContext"})
        au = au or aT(aq, {"SharedUtils", "InputService"})
        av = av or at.CircleSkillCheckHandler or aT(aq, {"Modules", "Gameplay", "CircleSkillCheckHandler"})
        aw = aw or at.TreadmillTapSkillCheck or aT(aq, {"Modules", "Gameplay", "TreadmillTapSkillCheck"})
        if not au._actions or not au._actions.SkillCheckTap then
          error("The game's SkillCheckTap input action is not initialized yet", 0)
        end
      end)
      if not aY then
        aM.lastError = tostring(aZ)
        return false, aM.lastError
      end
      az = az + 1
      local a_ = az
      ay = true
      aO.start()
      aM.lastError = nil
      aB = 0
      aA = 0
      aS()
      ax = ar.Heartbeat:Connect(function()
        if not aU(a_) or os.clock() < aB then
          return
        end
        local a0, a1 = pcall(aW, a_)
        if not a0 then
          aM.errors = aM.errors + 1
          aM.lastError = tostring(a1)
          aB = os.clock() + 0.5
        end
      end)
      return true
    end
    function aN.stop()
      ay = false
      aO.stop()
      az = az + 1
      if ax then
        ax:Disconnect()
        ax = nil
      end
      aS()
      ap.reset()
    end
    return aN
  end
end)()

local an = (function()
  return function(an, ao)
    local ap = an.groundServices
    local aq = ap and ap.Workspace or game:GetService("Workspace")
    local ar = ap and ap.RunService or game:GetService("RunService")
    local as = ap and ap.TweenService or game:GetService("TweenService")
    local at = ap and ap.PathfindingService or game:GetService("PathfindingService")
    local au = an.clock or os.clock
    local av = an.cover
    local aw = {stats = {segments = 0, teleports = 0, teleportAttempts = 0, groundOnly = true, coverPinned = false,
      corrections = 0}}
    local ax, ay, az, aA = 0, false, nil, nil
    local aB, aC, aD, aE = nil, -math.huge, {}, {}
    local aF = Vector3.new(0, 1, 0)
    for aG, aI in ipairs({"shouldHide", "itemContactAt", "chaseThreat", "detectedThreat", "sproutThreat",
        "sprintSafe", "enforceRibbonWalk", "safeToMachine", "safeToMachineReturn", "safeToPickup", "safeHere",
        "safeToInteract"}) do
      local aJ = ao[aI]
      aw[aI] = function(...)
        return aJ(...)
      end
    end
    local function aG()
      table.clear(av)
      aw.stats.coverStatus = "outside"
    end
    local function aI()
      local aJ = an.room()
      if aJ ~= aB or au() - aC > 3 then
        aB, aC, aD, aE = aJ, au(), {}, {}
        local function aK(aL, aM)
          if not aL then
            return
          end
          for aN, aO in ipairs(aL:GetDescendants()) do
            if aO:IsA("BasePart") and aO.CanCollide then
              local aR = aO
              local aS = false
              local aT = false
              while aR and aR ~= aL do
                local aU = aR.Name:lower()
                if aU == "monsters" or aU == "items" or aU == "holidaypickups" or aU == "generators" then
                  aT = true
                end
                if aU:find("ceiling", 1, true) or aU:find("roof", 1, true) then
                  aT = true
                end
                if aU == "floor" or aU == "floors" or aU == "floorpanel" or aU == "floortile" or aU:match("^floor[%d_%- ]") or aU:match("floor$") or aU == "ground" or aU == "groundpart" or aU:match("^stairs?[%d_%- ]") or aU == "stairs" or aU == "staircase" or aU == "ramp" or aU == "platform" or aM and aU == "base" then
                  aS = true
                end
                aR = aR.Parent
              end
              if aS and not aT then
                aD[#aD + 1] = aO
              end
              if not aM and not aS and not aT and aO.Size.Y > 3 and math.max(aO.Size.X, aO.Size.Z) > 2 then
                aE[#aE + 1] = aO
              end
            end
          end
        end
        aK(aJ, false)
        aK(aq:FindFirstChild("Elevators"), true)
      end
      return aD
    end
    local function aJ()
      local aK, aL, aM = an.character()
      if not aM or not aL then
        return nil
      end
      local aN = aL.HipHeight + aM.Size.Y * 0.5
      if aL.RigType == Enum.HumanoidRigType.R6 then
        local aO = aK:FindFirstChild("Left Leg") or aK:FindFirstChild("Right Leg")
        aN += aO and aO.Size.Y or 0
      end
      return math.clamp(aN, 1, 5)
    end
    function aw.groundPosition(aK)
      if typeof(aK) ~= "Vector3" then
        return nil
      end
      local aL = aJ()
      if not aL or #aI() == 0 then
        return nil
      end
      local aM = RaycastParams.new()
      aM.FilterType = Enum.RaycastFilterType.Include
      aM.FilterDescendantsInstances = aD
      aM.RespectCanCollide = true
      local aN = aq:Raycast(aK + aF * 8, -aF * 80, aM)
      if not aN or aN.Normal.Y < 0.6 then
        return nil
      end
      return Vector3.new(aK.X, aN.Position.Y + aL, aK.Z)
    end
    local function aK()
      local aL = RaycastParams.new()
      aL.FilterType = Enum.RaycastFilterType.Exclude
      aL.RespectCanCollide = true
      local aM = an.character()
      local aN = aM and {aM} or {}
      local aO = an.room()
      if aO then
        for aR, aS in ipairs({"Monsters", "Items", "HolidayPickups"}) do
          local aT = aO:FindFirstChild(aS)
          if aT then
            aN[#aN + 1] = aT
          end
        end
      end
      aL.FilterDescendantsInstances = aN
      return aL
    end
    local function aL(aM)
      local aN, aO, aR = an.character()
      if not aR then
        return false
      end
      local aS = OverlapParams.new()
      aS.FilterType = Enum.RaycastFilterType.Exclude
      aS.FilterDescendantsInstances = {aN}
      aS.RespectCanCollide = true
      local aT = aJ()
      local aU = Vector3.new(aR.Size.X + 0.35, math.max(1, aT * 2 - 0.5), aR.Size.Z + 0.35)
      for aV, aW in ipairs(aq:GetPartBoundsInBox(CFrame.new(aM), aU, aS)) do
        if aW.CanCollide then
          return false
        end
      end
      return true
    end
    function aw.isGrounded()
      local aM, aN, aO = an.character()
      local aR = aO and aw.groundPosition(aO.Position)
      return aR ~= nil and math.abs(aO.Position.Y - aR.Y) < 0.9
    end
    function aw.ownsHeight()
      return false
    end
    function aw.canTeleportToMachine()
      return false
    end
    for aN, aO in ipairs({"safeToMachine", "safeToMachineReturn", "safeToPickup", "safeToInteract"}) do
      local aR = ao[aO]
      aw[aO] = function(aS, aT, aU)
        local aV = aw.groundPosition(aS)
        if not aV or not aL(aV) then
          return false, "ground-destination-blocked"
        end
        return aR(aV, aT, aU, true)
      end
    end
    local function aN(aO)
      return an.hazards and an.hazards.attackDangerAt(aO)
    end
    local function aO(aR, aS)
      for aT, aU in ipairs(ao.distractionThreats()) do
        if math.abs(aR.Y - aU.position.Y) < 12 and (aR - aU.position).Magnitude < aU.killRadius + (aS or 5) then
          return true
        end
      end
      return aN(aR) ~= nil
    end
    function aw.pickupPosition(aR, aS)
      local aT, aU, aV = an.character()
      if not aV then
        return nil
      end
      local aW, aY
      local aZ = {aR, aR + Vector3.new(3.5, 0, 0), aR + Vector3.new(-3.5, 0, 0), aR + Vector3.new(0, 0, 3.5),
        aR + Vector3.new(0, 0, -3.5)}
      for a_, a0 in ipairs(aZ) do
        local a1 = aw.groundPosition(a0)
        if a1 and (a1 - aR).Magnitude < aS - 0.2 and aL(a1) and not aw.itemContactAt(a1) then
          local a2 = (aV.Position - a1).Magnitude
          if not aY or a2 < aY then
            aW, aY = a1, a2
          end
        end
      end
      return aW
    end
    function aw.machineApproach(aR, aS, aU)
      local aV = aw.pickupPosition(aR, math.huge)
      if aV and (aV - aS).Magnitude < aU - 0.2 then
        return aV, "ground-machine-stand"
      end
      aV = aw.pickupPosition(aS, aU)
      return aV, aV and "ground-prompt-stand" or "no-ground-prompt-position"
    end
    local function aR()
      ax += 1
      if az then
        az:Cancel()
        az = nil
      end
      aw.stats.motionMode = nil
    end
    function aw.interrupt()
      aR()
    end
    local function aS(aU)
      if ay then
        return false, "movement-busy"
      end
      if not an.alive() then
        return false, "cancelled"
      end
      ay = true
      ax += 1
      local aV = ax
      local aW, aY, aZ = xpcall(function()
        an.stopInteraction()
        if an.releaseExtraction then
          an.releaseExtraction("ground-travel")
        end
        return aU(aV)
      end, debug.traceback)
      if az then
        az:Cancel()
        az = nil
      end
      aw.stats.motionMode = nil
      ay = false
      if not aW then
        aw.stats.lastReason = tostring(aY)
        return false, "ground-navigation-error: " .. tostring(aY)
      end
      aw.stats.lastReason = aZ
      return aY, aZ
    end
    local function aU(aV, aW, aY)
      return aV == ax and an.alive() and an.character() == aW and an.room() == aY and not (an.grabbed and an.grabbed())
    end
    local function aV(aW, aY)
      local aZ = {aW}
      local a_ = (aY - aW).Magnitude
      local a0 = aq:Raycast(aW + aF * 0.3, aY - aW, aK())
      local a1 = not a0 and math.abs(aY.Y - aW.Y) < 0.8
      if a1 then
        for a2 = 1, math.max(1, math.ceil(a_ / 5)) do
          local a3 = aw.groundPosition(aW:Lerp(aY, a2 / math.max(1, math.ceil(a_ / 5))))
          if not a3 or math.abs(a3.Y - aW.Y) > 1 or not aL(a3) then
            a1 = false
            break
          end
          aZ[#aZ + 1] = a3
        end
      end
      if a1 then
        return aZ
      end
      local a2, a3, a4 = an.character()
      local a6 = at:CreatePath({AgentRadius = math.max(1, a4.Size.X * 0.5 + 0.2), AgentHeight = math.max(3, (aJ() or 2) * 2),
        AgentCanJump = false, WaypointSpacing = 5})
      local a7 = pcall(function()
        a6:ComputeAsync(aW, aY)
      end)
      if not a7 or a6.Status ~= Enum.PathStatus.Success then
        return nil, "no-ground-route"
      end
      aZ = {aW}
      for a8, a9 in ipairs(a6:GetWaypoints()) do
        if a9.Action == Enum.PathWaypointAction.Jump then
          return nil, "jump-route-rejected"
        end
        local ba = aw.groundPosition(a9.Position)
        if not ba then
          return nil, "unsupported-ground-route"
        end
        if not aL(ba) then
          return nil, "ground-route-blocked"
        end
        aZ[#aZ + 1] = ba
      end
      aZ[#aZ + 1] = aY
      return aZ
    end
    local function aW(aY, aZ, a_)
      local a0, a1, a3 = an.character()
      local a4 = an.room()
      if not a3 or not aU(aZ, a0, a4) then
        return false, "cancelled"
      end
      local a6 = aw.groundPosition(aY)
      if not a6 or not aL(a6) then
        return false, "ground-destination-blocked"
      end
      local a7 = au() + 0.65
      while a3.Anchored and aU(aZ, a0, a4) and au() < a7 do
        ar.Heartbeat:Wait()
      end
      if a3.Anchored then
        return false, "waiting-for-native-release"
      end
      if (a3.Position - a6).Magnitude < 1 then
        return true, "ground-arrived"
      end
      local a8, a9 = aV(a3.Position, a6)
      if not a8 then
        return false, a9
      end
      aG()
      aw.stats.motionMode = "ground-tween"
      for ba = 2, #a8 do
        if not aU(aZ, a0, a4) then
          return false, "cancelled"
        end
        local bb = aw.groundPosition(a8[ba])
        if not bb then
          return false, "floor-missing"
        end
        if aN(bb) or an.hazards and not an.hazards.segmentClear(a3.Position, bb) then
          return false, "attack-on-ground-route"
        end
        local bc = math.max(0.06, (bb - a3.Position).Magnitude / math.clamp(an.options.tweenSpeed or 24, 12, 30))
        local bd = as:Create(a3, TweenInfo.new(bc, Enum.EasingStyle.Linear), {CFrame = CFrame.new(bb) * a3.CFrame.Rotation})
        az = bd
        bd:Play()
        local be = au() + bc + 0.4
        while aU(aZ, a0, a4) and au() < be and bd.PlaybackState == Enum.PlaybackState.Playing do
          if aN(a3.Position) or an.hazards and not an.hazards.segmentClear(a3.Position, bb) then
            return false, "attack-on-ground-route"
          end
          if not a_ and aw.shouldHide(a3.Position) then
            return false, "twisted-detected"
          end
          ar.Heartbeat:Wait()
        end
        if not aU(aZ, a0, a4) then
          return false, "cancelled"
        end
        if bd.PlaybackState ~= Enum.PlaybackState.Completed or (a3.Position - bb).Magnitude > 2 then
          return false, "ground-tween-corrected"
        end
        az = nil
        aw.stats.segments += 1
      end
      return true, "ground-arrived"
    end
    function aw.moveToMachine(aY)
      aw.stats.machineTravelMethod = "ground-tween"
      an.status("Tweening to generator on the floor")
      return aS(function(aZ)
        return aW(aY, aZ, false)
      end)
    end
    function aw.moveToPickup(aY)
      local aZ = aY.Parent
      if not aZ then
        return false, "pickup-removed"
      end
      local a_ = aZ:IsA("Attachment") and aZ.WorldPosition or aZ:IsA("Model") and aZ:GetPivot().Position or aZ.Position
      local a0 = aw.pickupPosition(a_, aY.MaxActivationDistance)
      if not a0 then
        return false, "no-ground-pickup-position"
      end
      an.status("Tweening beside item on the floor")
      return aS(function(a1)
        return aW(a0, a1, false)
      end)
    end
    local function aY()
      local aZ = an.room()
      local a_, a0, a1 = an.character()
      if not aZ or not a1 then
        return {}
      end
      aI()
      local a3 = ao.distractionThreats()
      local a4 = {}
      local a6 = {}
      for a7, a8 in ipairs(aE) do
        if a8.Parent and (a8.Position - a1.Position).Magnitude < 120 then
          a6[#a6 + 1] = a8
        end
      end
      table.sort(a6, function(a7, a8)
        return (a7.Position - a1.Position).Magnitude < (a8.Position - a1.Position).Magnitude
      end)
      for a7 = 1, math.min(28, #a6) do
        local a8 = a6[a7]
        local a9 = a8.CFrame:PointToObjectSpace(a1.Position)
        local ba, bb = a8.Size.X * 0.5, a8.Size.Z * 0.5
        for bc, bd in ipairs({Vector3.new(ba + 3, a9.Y, math.clamp(a9.Z, -bb, bb)), Vector3.new(-ba - 3, a9.Y, math.clamp(a9.Z, -bb, bb)),
            Vector3.new(math.clamp(a9.X, -ba, ba), a9.Y, bb + 3), Vector3.new(math.clamp(a9.X, -ba, ba), a9.Y, -bb - 3)}) do
          local be = a8.CFrame:PointToWorldSpace(bd)
          be = Vector3.new(be.X, a1.Position.Y, be.Z)
          local bh = aw.groundPosition(be)
          if bh and aL(bh) and not aO(bh, 8) then
            local bi = true
            local bj = math.huge
            for bk, bl in ipairs(a3) do
              bj = math.min(bj, (bh - bl.position).Magnitude)
              if (bl.chasingUs or (a1.Position - bl.position).Magnitude < 40) and not aq:Raycast(bl.position + aF, bh - bl.position, aK()) then
                bi = false
              end
            end
            a4[#a4 + 1] = {position = bh, part = a8, hidden = bi, score = (a1.Position - bh).Magnitude + (bi and 0 or 60) - math.min(bj, 80) * 0.2}
          end
        end
      end
      table.sort(a4, function(a7, a8)
        return a7.score < a8.score
      end)
      return a4
    end
    function aw.hide()
      return aS(function(aZ)
        local a0 = aY()
        for a1 = 1, math.min(4, #a0) do
          local a3 = a0[a1]
          an.status("Tweening behind cover at floor level")
          local a4, a6 = aW(a3.position, aZ, true)
          if a4 then
            av.active = a3.hidden
            av.floor = an.room()
            av.kind = "ground"
            av.position = a3.position
            av.part = a3.part
            aw.stats.coverStatus = a3.hidden and "behind-ground-cover" or "ground-retreat"
            return true, aw.stats.coverStatus
          end
          if a6 == "cancelled" then
            return false, a6
          end
        end
        return false, "no-clear-ground-cover-route"
      end)
    end
    aw.evade = aw.hide
    function aw.resumeCover()
      local aZ, a0, a1 = an.character()
      if not a1 or av.floor ~= an.room() then
        aG()
        return true, "cover-cleared"
      end
      if aO(a1.Position, 8) then
        aG()
        return aw.hide()
      end
      local a3, a4 = an.resumePosition()
      if a4 == "machine-occupied" or an.holdCover and an.holdCover() or aw.chaseThreat() or aw.detectedThreat() then
        av.clearSince = nil
        an.status("Waiting behind cover on the floor")
        return false, "ground-cover-wait"
      end
      if not a3 then
        return false, "waiting-for-ground-destination"
      end
      av.clearSince = av.clearSince or au()
      if au() - av.clearSince < (an.options.clearDelay or 2) then
        return false, "ground-cover-clearance"
      end
      aG()
      aw.stats.machineReturnMethod = "ground-tween"
      return aw.moveToMachine(a3)
    end
    function aw.isHidden()
      return av.active == true and av.kind == "ground" and aw.isGrounded()
    end
    function aw.inspectCover()
      local a0 = aY()[1]
      return a0 and {position = tostring(a0.position), part = a0.part:GetFullName(), kind = "ground"}
    end
    function aw.elevatorPosition()
      local a0 = aq:FindFirstChild("Elevators")
      local a1 = a0 and a0:FindFirstChild("Elevator")
      local a3 = a1 and a1:FindFirstChild("Base")
      return a3 and aw.groundPosition(a3.Position + aF * 3)
    end
    function aw.returnToElevator()
      return aS(function(a0)
        local a1, a3, a4 = an.character()
        local a6 = an.room()
        local a7 = aw.elevatorPosition()
        if not a4 or not a7 then
          return false, "elevator-unavailable"
        end
        aG()
        aw.stats.elevatorMode = "teleport"
        for a8 = 1, 6 do
          if not aU(a0, a1, a6) then
            return false, "cancelled"
          end
          if a4.Anchored then
            return false, "waiting-for-native-release"
          end
          a4.CFrame = CFrame.new(a7) * a4.CFrame.Rotation
          aw.stats.teleportAttempts += 1
          ar.Heartbeat:Wait()
        end
        local a8 = (a4.Position - a7).Magnitude < 3
        if a8 then
          aw.stats.teleports += 1
        end
        return a8, a8 and "ground-elevator-arrived" or "elevator-corrected"
      end)
    end
    aw.seekRefuge = aw.returnToElevator
    function aw.approachShop(a0, a1)
      local a3 = aw.pickupPosition(a0, a1)
      if not a3 then
        return false, "no-ground-shop-position"
      end
      return aS(function(a4)
        return aW(a3, a4, false)
      end)
    end
    function aw.encounter(a0, a1)
      return aS(function(a3)
        local a4, a6, a7 = an.character()
        local a8 = an.room()
        local a9 = a0.PrimaryPart or a0:FindFirstChild("HumanoidRootPart")
        if not a7 or not a9 then
          return false, "target-vanished"
        end
        aG()
        local ba = au() + 1
        repeat
          if not aU(a3, a4, a8) then
            return false, "cancelled"
          end
          local bb = Vector3.new(a9.CFrame.LookVector.X, 0, a9.CFrame.LookVector.Z)
          if bb.Magnitude < 0.1 then
            bb = Vector3.new(0, 0, -1)
          end
          local bc = aw.groundPosition(a9.Position + bb.Unit * 20)
          if not bc or not aL(bc) or aO(bc, 3) then
            return false, "no-ground-encounter-position"
          end
          if a7.Anchored then
            return false, "waiting-for-native-release"
          end
          a7.CFrame = CFrame.new(bc) * a7.CFrame.Rotation
          aw.stats.teleportAttempts += 1
          ar.Heartbeat:Wait()
          local bd = not aq:Raycast(a9.Position + aF, a7.Position - a9.Position, aK())
          local be, bh = an.detectedUs(a0, a4, bd)
          if be then
            if a1 then
              a1(bh)
            end
            return true, "native-detection"
          end
        until au() >= ba
        return false, "detection-unconfirmed-moving-on"
      end)
    end
    function aw.start()
      if aA then
        return
      end
      local a0 = 0
      aA = ar.Heartbeat:Connect(function()
        if au() < a0 or ay or not an.alive() or an.grabbed and an.grabbed() then
          return
        end
        a0 = au() + 0.1
        if an.activity() == "research" or an.activity() == "elevator" then
          return
        end
        local a1, a3, a4 = an.character()
        if not a4 or not an.room() then
          return
        end
        if av.active and not aO(a4.Position, 8) then
          return
        end
        if aw.shouldHide(a4.Position) then
          an.stopInteraction()
          if an.releaseExtraction then
            an.releaseExtraction("ground-threat")
          end
          task.spawn(aw.hide)
        end
      end)
    end
    function aw.stop()
      aR()
      if aA then
        aA:Disconnect()
        aA = nil
      end
      aG()
      ao.destroy()
    end
    aw.destroy = aw.stop
    return aw
  end
end)()

local ao = (function()
  return function(ao)
    local ap = game:GetService("Workspace")
    local aq = game:GetService("RunService")
    local ar = game:GetService("CollectionService")
    local as = ao.clock or os.clock
    local at = setmetatable({}, {__mode = "k"})
    local au = setmetatable({}, {__mode = "k"})
    local av = {}
    local aw = {stats = {inventories = 0, queries = 0, boxTests = 0}}
    local ax = {Ichor_Puddle_01 = true, Ichor_Puddle_02 = true, Ichor_Puddle_03 = true, FinnIchorPuddle = true}
    local function ay(az)
      if not az or not ax[az.Name] or az.Name == "FinnIchorPuddle" then
        return false
      end
      local aA = az
      while aA and aA ~= ap do
        if aA.Name:lower():find("finn", 1, true) then
          return false
        end
        aA = aA.Parent
      end
      return true
    end
    function aw.setQuestPuddle(az)
      if az == nil then
        aw.questTarget = nil
        return true
      end
      local aA = ao.room()
      if not ay(az) or not aA or not az:IsDescendantOf(aA) then
        return false
      end
      aw.questTarget = az
      return true
    end
    local function az(aA)
      local aB = aA.Name:lower():gsub("[^%a]", "")
      return aB:find("tendril", 1, true) ~= nil or aB:find("sprout", 1, true) ~= nil and (aB:find("tentacle", 1, true) ~= nil or aB:find("hazard", 1, true) ~= nil or aB:find("vine", 1, true) ~= nil) or aA:GetAttribute("IsSproutTendril") == true or aA:GetAttribute("IsSproutHazard") == true
    end
    local function aA(aB, aC)
      local aD = at[aB]
      if not aD or aD.kind ~= aC then
        at[aB] = {object = aB, kind = aC, reason = aC == "puddle" and "ichor-puddle" or aC}
      end
    end
    local function aB(aC)
      if not aC:IsA("BasePart") and not aC:IsA("Model") then
        return
      end
      if aC:IsA("BasePart") and aC:GetAttribute("IsBlotHand") == true then
        aA(aC, "blott-hand")
        return
      end
      if ax[aC.Name] then
        aA(aC, "puddle")
        return
      end
      local aD = ap:FindFirstChild("InGamePlayers")
      local aE = ao.character()
      if aD and aC:IsDescendantOf(aD) or aE and (aC == aE or aC:IsDescendantOf(aE)) then
        return
      end
      local aF, aG, aI = aC, aC, nil
      while aG and aG ~= ap do
        if aG.Name == "RollingPumpkinLocal" then
          return
        end
        if aG:IsA("BasePart") or aG:IsA("Model") then
          aF = aG
        end
        if az(aG) then
          aA(aF, "sprout-tendril")
          return
        end
        if aG:IsA("BasePart") or aG:IsA("Model") then
          local aJ = aG.Name:lower():gsub("[^%a]", "")
          local aK = aJ:find("rollingpumpkin", 1, true) or aG:GetAttribute("IsRollingPumpkin") == true or aG:GetAttribute("RollingPumpkin") == true or aG:GetAttribute("RollFullWidth") ~= nil or ar and ar:HasTag(aG, "RollingPumpkinRolling")
          if aK then
            aA(aG, "rolling-pumpkin")
            at[aG].motionRequired = false
            return
          end
          if aJ:find("pumpkin", 1, true) then
            aI = aG
          end
        end
        aG = aG.Parent
      end
      if aI then
        aA(aI, "rolling-pumpkin")
        at[aI].motionRequired = true
      end
    end
    local function aC(aD)
      local aE = aD.object
      if not aE:IsDescendantOf(ap) then
        at[aE] = nil
        return false
      end
      if aE:GetAttribute("Disabled") == true then
        return false
      end
      if aD.kind == "puddle" and aw.questTarget and ay(aE) and (aE == aw.questTarget or aE:IsDescendantOf(aw.questTarget)) then
        return false
      end
      if aD.kind == "sprout-tendril" or aD.kind == "blott-hand" or aD.kind == "rolling-pumpkin" then
        return true
      end
      local aF = ao.room()
      return aF ~= nil and aE:IsDescendantOf(aF) and (aD.kind ~= "puddle" or ao.options.avoidPuddles ~= false or ao.options.autoPuddleQuest == true)
    end
    local function aD(aE)
      local aF = aE.object
      local aG = as()
      if aE.motionRequired and aE.size and math.max(aE.size.X, aE.size.Y, aE.size.Z) < 6 and aG - (aE.updatedAt or 0) < 1 then
        return false
      end
      if aF:IsA("BasePart") then
        aE.cf, aE.size = aF.CFrame, aF.Size
        aE.updatedAt = aG
      elseif not aE.cf or not aE.updatedAt or aG - aE.updatedAt >= 0.025 then
        if not aF:FindFirstChildWhichIsA("BasePart", true) then
          return false
        end
        aE.cf, aE.size = aF:GetBoundingBox()
        aE.updatedAt = aG
      end
      if not aE.cf then
        return false
      end
      aE.velocity = Vector3.zero
      if aE.kind == "blott-hand" or aE.kind == "rolling-pumpkin" then
        local aI = aF:IsA("BasePart") and aF or aF.PrimaryPart or aF:FindFirstChild("HumanoidRootPart") or aF:FindFirstChildWhichIsA("BasePart", true)
        local aJ = aF:FindFirstChild("RollBody")
        if aJ and aJ.Value and aJ.Value:IsA("BasePart") and aJ.Value.Parent then
          aI = aJ.Value
          local aK, aL = aF:GetAttribute("RollExtentsPerWidth"), aF:GetAttribute("RollFullWidth")
          if typeof(aK) == "Vector3" and type(aL) == "number" and aL > 0 then
            local aN = aK * aL
            aE.size = Vector3.new(math.max(aE.size.X, aN.X), math.max(aE.size.Y, aN.Y, aN.Z), math.max(aE.size.Z, aN.Z))
          end
          local aN = aI.Parent:FindFirstChildOfClass("Humanoid")
          local aO = aI.Position.Y - aI.Size.Y * 0.5 - (aN and aN.HipHeight or 0)
          aE.cf = CFrame.new(Vector3.new(aI.Position.X, aO + aE.size.Y * 0.5, aI.Position.Z))
        end
        local aK = aI and aI.AssemblyLinearVelocity or Vector3.zero
        aK = Vector3.new(aK.X, 0, aK.Z)
        local aL = aE.observed
        if aL and aG - aL.at >= 0.04 and aG - aL.at < 0.75 then
          local aN = aE.cf.Position - aL.position
          local aO = Vector3.new(aN.X, 0, aN.Z) / (aG - aL.at)
          if aO.Magnitude > aK.Magnitude then
            aK = aO
          end
        elseif aL and aG - aL.at < 0.04 then
          aK = aL.velocity
        end
        local aN = aE.kind == "rolling-pumpkin" and 120 or 80
        if aK.Magnitude > aN then
          aK = aK.Unit * aN
        end
        if not aL or aG - aL.at >= 0.04 then
          aE.observed = {at = aG, position = aE.cf.Position, velocity = aK}
        end
        aE.velocity = aK
        if aE.motionRequired and (math.max(aE.size.X, aE.size.Y, aE.size.Z) < 6 or aK.Magnitude < 2) then
          return false
        end
        if aE.kind == "rolling-pumpkin" then
          local aO = math.max(aE.size.X, aE.size.Z) * 0.5
          local aR = aE.cf.Position + aK * 0.8
          aE.laneFrame = aK.Magnitude > 0.1 and CFrame.lookAt(aR, aR + aK) or CFrame.new(aR)
          aE.laneSize = Vector3.new(aO * 2, aE.size.Y, aO * 2 + aK.Magnitude * 1.6)
        end
      end
      return true
    end
    local function aE(aF, aG)
      return aF.kind == "puddle" and (aG or 2) or math.max(aF.kind == "sprout-tendril" and 12 or 8, aG or 0)
    end
    local function aF(aG, aI, aJ, aK, aL)
      local aN = aJ:PointToObjectSpace(aI)
      local aO = (aL or aG.size) * 0.5
      return math.abs(aN.X) <= aO.X + aK and math.abs(aN.Z) <= aO.Z + aK and aN.Y >= -aO.Y - 4 and aN.Y <= aO.Y + 7
    end
    local function aG(aI)
      if aI.kind ~= "blott-hand" or aI.velocity.Magnitude <= 0.1 then
        return {aI.cf}
      end
      return {aI.cf, aI.cf + aI.velocity * 0.2, aI.cf + aI.velocity * 0.4, aI.cf + aI.velocity * 0.6}
    end
    local function aI(aJ, aK, aL)
      aL = aE(aJ, aL)
      if aJ.kind == "rolling-pumpkin" then
        return aF(aJ, aK, aJ.laneFrame, aL, aJ.laneSize)
      end
      for aN, aO in ipairs(aG(aJ)) do
        if aF(aJ, aK, aO, aL) then
          return true
        end
      end
      return false
    end
    local function aJ(aK, aL, aN)
      aw.stats.queries += 1
      for aO, aR in pairs(at) do
        if (not aN or aR.kind == aN) and aC(aR) and aD(aR) and aI(aR, aK, aL) then
          return aR
        end
      end
    end
    function aw.handDangerAt(aK, aL)
      return aJ(aK, aL, "blott-hand")
    end
    function aw.sproutDangerAt(aK, aL)
      return aJ(aK, aL, "sprout-tendril")
    end
    function aw.pumpkinDangerAt(aK, aL)
      return aJ(aK, aL, "rolling-pumpkin")
    end
    function aw.pumpkinPursuitAt(aK)
      local aL, aN
      for aO, aR in pairs(at) do
        if aR.kind ~= "rolling-pumpkin" or not aC(aR) or not aD(aR) then
          continue
        end
        local aS = aK - aR.cf.Position
        local aU = Vector3.new(aS.X, 0, aS.Z).Magnitude
        local aV = math.max(aR.size.X, aR.size.Z) * 0.5
        if math.abs(aS.Y) <= aR.size.Y * 0.5 + 10 and aU < aV + 100 and (not aN or aU < aN) then
          aL, aN = aR, aU
        end
      end
      return aL
    end
    function aw.attackDangerAt(aK, aL)
      return aw.handDangerAt(aK, aL) or aw.sproutDangerAt(aK, aL) or aw.pumpkinDangerAt(aK, aL)
    end
    function aw.targets()
      local aK = {}
      for aL, aN in pairs(at) do
        if aC(aN) and aD(aN) then
          aK[#aK + 1] = {object = aN.object, kind = aN.kind}
        end
      end
      return aK
    end
    function aw.questPuddles()
      local aK, aL = {}, {}
      local aN = ao.room()
      if not aN then
        return aK
      end
      for aO, aR in pairs(at) do
        local aS = aR.object
        if aR.kind ~= "puddle" or not ay(aS) or not aS:IsDescendantOf(aN) or aS:GetAttribute("Disabled") == true then
          continue
        end
        while aS.Parent and ay(aS.Parent) do
          aS = aS.Parent
        end
        local aU = at[aS] or aR
        if not aL[aS] and aD(aU) then
          aL[aS] = true
          aK[#aK + 1] = {object = aS, position = aU.cf.Position}
        end
      end
      return aK
    end
    function aw.dangerAt(aK, aL)
      return aw.attackDangerAt(aK, aL) or aJ(aK, aL, "puddle")
    end
    local function aK(aL, aN, aO, aR, aS, aU)
      aw.stats.boxTests += 1
      local aV, aW = aR:PointToObjectSpace(aN), aR:PointToObjectSpace(aO)
      local aY = (aU or aL.size) * 0.5
      local a0, a3 = 0, 1
      for a4, a6 in ipairs({{"X", aY.X + aS, aY.X + aS}, {"Z", aY.Z + aS, aY.Z + aS}, {"Y", aY.Y + 4,
          aY.Y + 7}}) do
        local a7, a8 = aV[a6[1]], aW[a6[1]] - aV[a6[1]]
        if math.abs(a8) < 0.00001 then
          if a7 < -a6[2] or a7 > a6[3] then
            return false
          end
        else
          local a9, ba = (-a6[2] - a7) / a8, (a6[3] - a7) / a8
          if a9 > ba then
            a9, ba = ba, a9
          end
          a0, a3 = math.max(a0, a9), math.min(a3, ba)
          if a0 > a3 then
            return false
          end
        end
      end
      return true
    end
    function aw.segmentClear(aL, aN, aO)
      aw.stats.queries += 1
      for aR, aS in pairs(at) do
        if not aC(aS) or not aD(aS) then
          continue
        end
        local aU = aE(aS, aO)
        if aS.kind == "rolling-pumpkin" then
          if aK(aS, aL, aN, aS.laneFrame, aU, aS.laneSize) then
            local aV = aL - aS.cf.Position
            aV = Vector3.new(aV.X, 0, aV.Z)
            local aW = aN - aL
            aW = Vector3.new(aW.X, 0, aW.Z)
            if not aF(aS, aL, aS.laneFrame, aU, aS.laneSize) or aW.Magnitude < 0.00001 or aV:Dot(aW) < -0.00001 then
              return false, aS
            end
          end
          continue
        end
        for aV, aW in ipairs(aG(aS)) do
          if not aK(aS, aL, aN, aW, aU) then
            continue
          end
          if not aF(aS, aL, aW, aU) then
            return false, aS
          end
          local aY = aL - aW.Position
          aY = Vector3.new(aY.X, 0, aY.Z)
          local a0 = aN - aL
          a0 = Vector3.new(a0.X, 0, a0.Z)
          if a0.Magnitude < 0.00001 or aY:Dot(a0) < -0.00001 then
            return false, aS
          end
        end
      end
      return true
    end
    function aw.pumpkinEscapeClear(aL, aN, aO)
      local aR = (aN - aL).Magnitude / math.max(1, aO)
      local aS = (aN - aL) / math.max(0.01, aR)
      for aU, aV in pairs(at) do
        if not aC(aV) or not aD(aV) then
          continue
        end
        if aV.kind ~= "rolling-pumpkin" then
          local aW = aE(aV)
          for aY, a0 in ipairs(aG(aV)) do
            if aK(aV, aL, aN, a0, aW) then
              local a3 = aL - a0.Position
              local a4 = aN - aL
              if not aF(aV, aL, a0, aW) or Vector3.new(a3.X, 0, a3.Z):Dot(Vector3.new(a4.X, 0, a4.Z)) < 0 then
                return false, aV
              end
            end
          end
          continue
        end
        if math.abs(aL.Y - aV.cf.Position.Y) > aV.size.Y * 0.5 + 7 then
          continue
        end
        local aW = aL - aV.cf.Position
        aW = Vector3.new(aW.X, 0, aW.Z)
        local aY = aS - aV.velocity
        aY = Vector3.new(aY.X, 0, aY.Z)
        local a0 = aY:Dot(aY)
        local a3 = a0 > 0.001 and math.clamp(-aW:Dot(aY) / a0, 0, aR) or 0
        local a4 = math.max(aV.size.X, aV.size.Z) * 0.5 + 5
        local a6 = (aW + aY * a3).Magnitude
        if a6 < a4 and (a6 < aW.Magnitude - 0.05 or (aN - aV.cf.Position).Magnitude <= aW.Magnitude + 0.2) then
          return false, aV
        end
      end
      return aw.handDangerAt(aN) == nil and aw.sproutDangerAt(aN) == nil
    end
    function aw.pumpkinEscapeCandidates(aL, aN)
      if not aN or aN.kind ~= "rolling-pumpkin" or not aC(aN) or not aD(aN) then
        return {}
      end
      local aO = aN.velocity.Magnitude > 0.1 and aN.velocity.Unit or Vector3.new(0, 0, 1)
      local aR = Vector3.new(-aO.Z, 0, aO.X)
      local aS = aL - aN.cf.Position
      local aU = Vector3.new(aS.X, 0, aS.Z):Dot(aR)
      local aV = math.max(aN.size.X, aN.size.Z) * 0.5 + 50
      local aW = {}
      for aY, a0 in ipairs({aU >= 0 and 1 or -1, aU >= 0 and -1 or 1}) do
        local a3 = aR * (a0 * aV - aU)
        for a4, a6 in ipairs({0, -8, 8}) do
          aW[#aW + 1] = aL + a3 + aO * a6
        end
      end
      return aW
    end
    function aw.detours(aL, aN)
      local aO, aR = aw.segmentClear(aL, aN)
      if aO then
        return {}
      end
      local aS = (aR.kind == "blott-hand" or aR.kind == "rolling-pumpkin") and 12 + aR.velocity.Magnitude * 0.8 or aR.kind == "sprout-tendril" and 16 or 5
      local aU = aR.size * 0.5 + Vector3.new(aS, 0, aS)
      local aV = {}
      for aW, aY in ipairs({Vector3.new(-aU.X, 0, -aU.Z), Vector3.new(aU.X, 0, -aU.Z), Vector3.new(aU.X, 0, aU.Z),
          Vector3.new(-aU.X, 0, aU.Z)}) do
        local a0 = aR.cf:PointToWorldSpace(aY)
        table.insert(aV, Vector3.new(a0.X, aL.Y, a0.Z))
      end
      local aW = {}
      for aY = 1, 4 do
        local a0 = aY % 4 + 1
        table.insert(aW, {aV[aY], aV[a0]})
        table.insert(aW, {aV[a0], aV[aY]})
      end
      return aW
    end
    table.insert(av, ap.DescendantAdded:Connect(function(aL)
      aB(aL)
      if aL:IsA("BasePart") or aL:IsA("Model") then
        au[aL] = true
      end
    end))
    local aL = -math.huge
    table.insert(av, aq.Heartbeat:Connect(function()
      local aN = 0
      for aO in pairs(au) do
        au[aO] = nil
        if aO.Parent then
          aB(aO)
        end
        aN += 1
        if aN >= 128 then
          break
        end
      end
      if as() - aL >= 0.05 then
        aL = as()
        for aO, aR in pairs(at) do
          if aR.kind == "rolling-pumpkin" and aC(aR) then
            if not aR.motionRequired or not aR.size or math.max(aR.size.X, aR.size.Y, aR.size.Z) >= 6 then
              aD(aR)
            end
          end
        end
      end
    end))
    if ar then
      for aN, aO in ipairs(ar:GetTagged("RollingPumpkinRolling")) do
        aB(aO)
      end
      table.insert(av, ar:GetInstanceAddedSignal("RollingPumpkinRolling"):Connect(aB))
    end
    aw.stats.inventories += 1
    for aN, aO in ipairs(ap:GetDescendants()) do
      aB(aO)
    end
    function aw.destroy()
      for aN, aO in ipairs(av) do
        aO:Disconnect()
      end
      table.clear(at)
      table.clear(au)
    end
    return aw
  end
end)()

local ap = (function()
  return function(ap)
    local aq = ap.clock or os.clock
    local ar = {stats = {requests = 0, stops = 0, unanchors = 0, acknowledged = 0}}
    local as, at, au, av = nil, nil, false, false
    local function aw(ax)
      local ay = ax and ax:FindFirstChild("Decoding")
      return ay and ay.Value or nil
    end
    local function ax(ay, az, aA)
      if not ay or not ay.Parent then
        return false
      end
      if aw(az) == ay then
        return true
      end
      local aB = ay:FindFirstChild("Stats")
      local aC = false
      if aB then
        for aD, aE in ipairs(aB:GetChildren()) do
          if aE:IsA("ObjectValue") and aE.Name:match("^ActivePlayer%d*$") and aE.Value ~= nil then
            if aE.Value == az or aE.Value == ap.player then
              return true
            end
            aC = true
          end
        end
      end
      if not aA and not aC and ap.recentStart then
        local aD, aE = ap.recentStart()
        if aD == ay and aE and aq() - aE >= 0 and aq() - aE < 1.25 then
          return true
        end
      end
      return false
    end
    local function ay()
      if not as or au or not ap.enabled() then
        return false
      end
      local az, aA, aB = ap.character()
      return az == as.character and aB == as.root and aA and aA.Health > 0 and ap.room() == as.floor and as.machine.Parent ~= nil
    end
    function ar.pending()
      if not ay() then
        as = nil
        ar.stats.pending = false
        return false
      end
      return true
    end
    function ar.recent()
      if ar.pending() then
        return true
      end
      local az, aA = ap.character()
      return at ~= nil and ap.enabled() and not ap.coverPinned() and az == at.character and aA and aA.Health > 0 and ap.room() == at.floor and aq() - at.at < 1.5
    end
    function ar.ready()
      local az, aA, aB = ap.character()
      if not az or not aB or ar.pending() then
        return false
      end
      local aC = aw(az)
      if aC == true then
        return false
      end
      local aD = aC or ap.machine()
      return not ax(aD, az, true) and (not aB.Anchored or ap.coverPinned())
    end
    function ar.step()
      if not ar.pending() then
        return false
      end
      local az, aA, aB = ap.character()
      local aC = aw(az)
      if aC ~= nil and type(aC) ~= "boolean" and aC ~= as.machine then
        as = nil
        ar.stats.pending = false
        return false
      end
      if aC ~= true and not ax(as.machine, az, true) then
        if not ap.coverPinned() and aB.Anchored then
          aB.Anchored = false
          ar.stats.unanchors += 1
        end
        as = nil
        ar.stats.pending = false
        ar.stats.acknowledged += 1
        ar.stats.lastReason = "native-release-acknowledged"
        return true
      end
      local aD = aq() - as.at < 2 and 0.12 or 1
      if not av and aq() - (as.lastStop or -math.huge) >= aD then
        as.lastStop = aq()
        av = true
        local aE, aF = pcall(ap.stopNative, as.machine)
        av = false
        ar.stats.stops += 1
        if not aE then
          ar.stats.lastError = tostring(aF)
        end
      end
      ar.stats.pending = true
      return false
    end
    function ar.request(az)
      if au or not ap.enabled() then
        return false
      end
      local aA, aB, aC = ap.character()
      if not aA or not aB or aB.Health <= 0 or not aC or ap.coverPinned() then
        return false
      end
      local aD = aw(aA)
      local aE = (type(aD) ~= "boolean" and aD) or ap.machine()
      if not ax(aE, aA) then
        return false
      end
      if not as or as.character ~= aA or as.machine ~= aE or as.floor ~= ap.room() then
        as = {character = aA, root = aC, machine = aE, floor = ap.room(), at = aq()}
        at = {character = aA, floor = as.floor, at = as.at}
        ar.stats.requests += 1
        ar.stats.requestedAt = as.at
      end
      ar.stats.lastReason = az or "machine-danger"
      return ar.step()
    end
    function ar.reset()
      as, at = nil, nil
      ar.stats.pending = false
    end
    function ar.destroy()
      au = true
      ar.reset()
    end
    return ar
  end
end)()

local aq = (function()
  return function(aq)
    local ar = game:GetService("Players")
    local as = game:GetService("ReplicatedStorage")
    local at = game:GetService("RunService")
    local au = ar.LocalPlayer
    local av = {stats = {attempts = 0, accepted = 0, skippedTime = 0}, lastError = nil}
    local aw, ax, ay = false, 0, 0
    local az, aA, aB = nil, nil, nil
    local aC = {Heal = 0, Heal2 = 0, Machine = 1, Stamina = 2, Stamina2 = 2, AbilityCooldown = 3}
    local function aD(aE)
      local aF = (aE.Name .. " " .. aE.Value):lower():gsub("[^%a%d]", "")
      return aF:find("timesup", 1, true) ~= nil or aE.Name:lower():match("^time%d*$") ~= nil
    end
    function av.allowed(aE)
      return not aq.options.avoidTimeCards or not aD(aE)
    end
    function av.rank(aE)
      return (aq.options.prioritizeTimeCards and aD(aE) and -100 or 0) + (aC[aE.Name] or 20)
    end
    local function aE()
      local aF = aq.character()
      local aG = aF and aF:FindFirstChild("Stats")
      local aI = aG and aG:FindFirstChild("InElevator")
      return aI and aI.Value == true
    end
    local function aF()
      if aw or not aq.enabled() or not aq.options.autoCards or not aE() then
        return
      end
      local aG = workspace:FindFirstChild("Info")
      local aI = aG and aG:FindFirstChild("CardVoting")
      local aJ = aG and aG:FindFirstChild("CardVote")
      if not aI or aI.Value ~= true or not aJ then
        az = nil
        aA = nil
        return
      end
      local aK, aL = {}, {}
      for aN, aO in ipairs(aJ:GetChildren()) do
        if aO:IsA("StringValue") and aO:FindFirstChild("Votes") then
          table.insert(aL, aO.Name .. ":" .. aO.Value)
          if av.allowed(aO) then
            table.insert(aK, aO)
          end
        end
      end
      table.sort(aL)
      local aN = table.concat(aL, "|")
      local aO = tostring(aq.options.avoidTimeCards) .. ":" .. tostring(aq.options.prioritizeTimeCards)
      if az ~= aN or aB ~= aO then
        az, aA, ay, aB = aN, nil, 0, aO
      end
      if #aL == 0 then
        return
      end
      if #aK == 0 then
        av.stats.skippedTime = #aL
        aq.status("Cards: all offered names contain TIME · waiting")
        return
      end
      table.sort(aK, function(aR, aS)
        local aU, aV = av.rank(aR), av.rank(aS)
        return aU == aV and aR.Name < aS.Name or aU < aV
      end)
      local aR = aK[1]
      local aS = aR:FindFirstChild("Votes")
      if aS and aS:FindFirstChild(au.Name) then
        if aA ~= aR then
          av.stats.accepted += 1
          aA = aR
        end
        av.lastError = nil
        return
      end
      if os.clock() - ay < 2 then
        return
      end
      ay = os.clock()
      if aR.Parent ~= aJ or not aq.enabled() or not aq.options.autoCards or not aE() or aI.Value ~= true then
        return
      end
      if not av.allowed(aR) then
        return
      end
      local aU = as:FindFirstChild("Events")
      local aV = aU and aU:FindFirstChild("CardVoteEvent")
      if not aV then
        av.lastError = "CardVoteEvent unavailable"
        return
      end
      av.stats.attempts += 1
      aq.status("Voting for " .. aR.Value)
      aV:FireServer(aR)
      print("[FloorAuto] Card vote requested: " .. aR.Value)
    end
    local aG = at.Heartbeat:Connect(function()
      if os.clock() - ax < 0.25 then
        return
      end
      ax = os.clock()
      local aG, aI = pcall(aF)
      if not aG then
        av.lastError = tostring(aI)
      end
    end)
    function av.destroy()
      aw = true
      aG:Disconnect()
    end
    return av
  end
end)()

local ar = (function()
  return function(ar)
    local as = ar.state
    local at = game:GetService("Workspace")
    local au = game:GetService("ReplicatedStorage")
    local av = game:GetService("Players").LocalPlayer
    local aw = (function()
      local aw = {}
      function aw.name(ax)
        return tostring(ax):gsub("Monster$", "")
      end
      function aw.isCapsule(ax, ay)
        return ax.Name:lower():find("capsule", 1, true) ~= nil or ay:GetAttribute("CapsulePrompt") == true
      end
      function aw.realCapsule(ax, ay, az)
        if not ax or not ay or not ay.Parent or not ay:IsDescendantOf(ax) then
          return false, "missing-capsule-prompt"
        end
        if ax:FindFirstChild("Chaser", true) or ax:FindFirstChildOfClass("Humanoid") then
          return false, "fake-capsule"
        end
        local aA = ax.Parent
        while aA do
          if aA.Name == "Monsters" then
            return false, "fake-capsule"
          end
          aA = aA.Parent
        end
        for aB, aC in ipairs({ax, ay.Parent, ay}) do
          local aD = aC.Name:lower()
          if aD:find("fake", 1, true) or aD:find("trap", 1, true) or aD:find("rodger", 1, true) then
            return false, "fake-capsule"
          end
          for aE, aF in ipairs({"Fake", "IsFake", "FakeCapsule", "IsFakeCapsule", "Trap", "IsTrap", "RodgerCapsule"}) do
            if aC:GetAttribute(aF) == true then
              return false, "fake-capsule"
            end
          end
        end
        if ay:GetAttribute("CapsulePrompt") ~= true then
          return false, "unverified-capsule"
        end
        local aB = ay.Parent:FindFirstChild("Monster")
        if not aB or not aB:IsA("StringValue") or aB.Value == "" then
          return false, "unverified-capsule"
        end
        local aC = az and az:FindFirstChild(aB.Value)
        if not aC or not aC:IsA("ModuleScript") then
          return false, "unknown-capsule-monster"
        end
        return true, aB.Value
      end
      function aw.emerged(ax)
        if not aw.name(ax.Name):lower():find("gourdy", 1, true) then
          return true
        end
        if ax:GetAttribute("GourdyEmergenceComplete") == true then
          return true
        end
        if ax:GetAttribute("GourdyEmerging") == true then
          return false
        end
        local ay = ax:FindFirstChild("GourdyState")
        local az = ax:FindFirstChild("IsStationary")
        return (az and az.Value == false) or ax:GetAttribute("IsStationary") == false or (ay and (ay.Value == "Mobile" or ay.Value == "Rage")) or false
      end
      function aw.rage(ax)
        local ay = tonumber(ax:GetAttribute("GourdyRagePercent"))
        if ay then
          return math.clamp(ay, 0, 100)
        end
        local az = ax:FindFirstChild("GourdyRageBar", true)
        local aA = az and (az:FindFirstChild("Fill", true) or az:FindFirstChild("fill", true))
        return aA and aA:IsA("GuiObject") and math.clamp(aA.Size.X.Scale * 100, 0, 100) or nil
      end
      function aw.chasingUs(ax, ay, az)
        if not ay then
          return false
        end
        local aA = ax:FindFirstChild("ChasingValue", true)
        local aB = aA and aA:IsA("ObjectValue") and aA.Value
        return aB ~= nil and (aB == ay or aB == az or aB:IsDescendantOf(ay))
      end
      function aw.detectedUs(ax, ay, az, aA)
        if aw.chasingUs(ax, ay, az) then
          return true, "ChasingValue targets local character"
        end
        local aB = ax:FindFirstChild("ChasingValue", true)
        if aB and aB:IsA("ObjectValue") and aB.Value ~= nil then
          return false
        end
        local aC = ax:FindFirstChild("Alerted")
        if aA and (ax:GetAttribute("Alerted") == true or (aC and aC:IsA("BoolValue") and aC.Value)) then
          return true, "Native Alerted transition while local character is in view"
        end
        return false
      end
      function aw.new(ax)
        local ay = {hold = false, stage = "idle", floor = nil, records = setmetatable({}, {__mode = "k"}),
          observed = 0, failed = 0}
        local function az(aA, aB, aC)
          if ax.log then
            ax.log(aA, {twisted = aB and aB.Name, detail = aC})
          end
        end
        function ay.reset(aA)
          if ay.floor == aA then
            return
          end
          ay.floor = aA
          ay.hold = false
          ay.stage = "idle"
          ay.current = nil
          ay.records = setmetatable({}, {__mode = "k"})
        end
        function ay.pending(aA)
          local aB = {}
          local aC = aA and aA:FindFirstChild("Monsters")
          if aC then
            for aD, aE in ipairs(aC:GetChildren()) do
              if aE:IsA("Model") and ax.options.selectedTwisteds[aw.name(aE.Name)] == true and not (ay.records[aE] and ay.records[aE].done) then
                table.insert(aB, aE)
              end
            end
          end
          table.sort(aB, function(aD, aE)
            if (aw.name(aD.Name) == "Gourdy") ~= (aw.name(aE.Name) == "Gourdy") then
              return aw.name(aD.Name) == "Gourdy"
            end
            return aD.Name < aE.Name
          end)
          return aB
        end
        function ay.step(aA, aB, aC)
          ay.reset(aB)
          if not ax.options.researchMode or aC > 1 then
            ay.hold = false
            ay.stage = "idle"
            return false
          end
          local aD = ay.pending(aB)[1]
          if not aD then
            ay.hold = false
            ay.stage = "complete"
            ay.current = nil
            return false
          end
          ay.current = aD
          if ax.setActivity then
            ax.setActivity("research")
          end
          local aE = ay.records[aD] or {attempts = 0, nextAttempt = 0}
          ay.records[aD] = aE
          if not aw.emerged(aD) then
            ay.stage = "waiting-emergence"
            ay.hold = true
            if not aE.waitingLogged then
              az("research_wait_emergence", aD, aw.rage(aD))
              aE.waitingLogged = true
            end
            local aF, aG
            if ax.cover.active or ax.cover.pending then
              aF, aG = aA.resumeCover()
            else
              aF, aG = aA.hide()
            end
            local aI = aw.rage(aD)
            ax.status("Research · " .. (ax.cover.active and "hiding for " or "finding cover for ") .. aw.name(aD.Name) .. " · rage " .. (aI and string.format("%.0f%%", aI) or "unreadable") .. " · waiting to emerge")
            if not aF and aG ~= "research-hold-cover" and ax.report then
              ax.report("Research cover", aG)
            end
            return true
          end
          ay.hold = false
          ay.stage = "encounter"
          if ax.cover.active or ax.cover.pending then
            local aF, aG = aA.resumeCover()
            if not aF then
              ay.stage = "holding-cover"
              ax.status("Research · staying hidden until Twisteds clear")
              return true
            end
          end
          if ax.clock() < aE.nextAttempt then
            ax.status("Research · preparing another encounter with " .. aw.name(aD.Name))
            return true
          end
          aE.attempts += 1
          az("research_exposure_started", aD, {attempt = aE.attempts, rage = aw.rage(aD)})
          local aF, aG = aA.encounter(aD, function(aF)
            if aE.observed then
              return
            end
            aE.observed = true
            aE.done = true
            ay.observed += 1
            az("research_detection_observed", aD, {evidence = aF or "ChasingValue targets local character",
              rage = aw.rage(aD)})
          end)
          if not ax.alive() then
            return true
          end
          if not ax.options.researchMode then
            ay.hold = false
            ay.stage = "idle"
            return false
          end
          if aF or aE.observed then
            aE.done = true
            ay.stage = "retreated"
            az("research_retreat", aD, {result = aG, hidden = ax.cover.active == true})
          elseif aE.attempts >= 3 then
            aE.done = true
            aE.unverified = true
            ay.failed += 1
            az("research_encounter_unverified", aD, {reason = aG, attempts = aE.attempts})
            if ax.report then
              ax.report(aw.name(aD.Name), "Encounter unverified · " .. tostring(aG))
            end
          else
            aE.nextAttempt = ax.clock() + 1
            az("research_encounter_retry", aD, {reason = aG, attempt = aE.attempts})
          end
          return true
        end
        function ay.cancel()
          ay.hold = false
          ay.stage = "idle"
          ay.current = nil
        end
        return ay
      end
      return aw
    end)()
    local ax = (function()
      return function(ax)
        local ay = ax.clock or os.clock
        local az = {stats = {attempts = 0, bought = 0}, progress = ax.progress or {lastFloor = 0, lastBucket = 0}}
        local aA, aB, aC = nil, -math.huge, false
        local function aD(aE)
          local aF = aE.name:lower():gsub("[^%a]", "")
          return aF:find("bandage", 1, true) ~= nil or aF:find("healthkit", 1, true) ~= nil or aF:find("medkit", 1, true) ~= nil or aF:find("medicalkit", 1, true) ~= nil
        end
        local function aE(aF)
          return aD(aF) and not aF.name:lower():find("bandage", 1, true)
        end
        local function aF(aG)
          local aI = tostring(aG):lower():gsub("[^%a]", "")
          return (aI == "medkit" or aI == "medicalkit") and "healthkit" or aI
        end
        local function aG(aI, aJ)
          local aK = 0
          for aL, aN in pairs(aI or {}) do
            if aF(aL) == aF(aJ) then
              aK += tonumber(aN) or 0
            end
          end
          return aK
        end
        local function aI(aJ)
          return ax.enabled() and (ax.options.autoCheapestShop == true or ax.options.autoShop ~= false or ax.options.antiDandy == true or aJ.medicalNeeded) and aJ.inElevator and aJ.open and aJ.alive
        end
        function az.step()
          local aJ = ax.snapshot()
          if not aJ then
            return
          end
          local aK = math.max(0, tonumber(aJ.floor) or 0)
          if aJ.open and not aC then
            az.resetStore()
          end
          aC = aJ.open == true
          if aK < az.progress.lastFloor then
            az.progress.lastBucket = 0
            aA = nil
            az.resetStore()
          end
          az.progress.lastFloor = aK
          if aA then
            local aL = aJ.inventoryCounts and aA.inventoryCounts and aG(aJ.inventoryCounts, aA.item.name) > aG(aA.inventoryCounts, aA.item.name)
            local aN = not aJ.inventoryCounts and aJ.inventorySignature and aA.inventorySignature and aJ.inventorySignature ~= aA.inventorySignature
            if aJ.character == aA.character and ((tonumber(aJ.money) and aJ.money < aA.money) or aL or aN) then
              az.stats.bought += 1
              az.stats.lastItem = aA.item.name
              az.stats.lastFloor = aK
              az.stats.lastReason = "shop-bought"
              ax.status("Dandy: bought " .. aA.item.name .. " · next purchase at the next shop")
              aA = nil
              return
            end
            if aJ.character ~= aA.character or not aI(aJ) then
              aA = nil
              return
            end
            if ay() < aA.deadline then
              return
            end
            az.stats.lastReason = "shop-purchase-unconfirmed"
            aA = nil
            return
          end
          if not aI(aJ) then
            return
          end
          local aL = ax.options.autoCheapestShop == true
          if aJ.medicalNeeded then
            if az.medicalAttemptedStore == aJ.store then
              return
            end
          elseif az.attemptedStore == aJ.store then
            return
          end
          if ay() - aB < 0.5 then
            return
          end
          aB = ay()
          if type(aJ.money) ~= "number" then
            az.stats.lastReason = "shop-currency-unavailable"
            return
          end
          local aN = {}
          local aO = aJ.medicalNeeded == true
          for aR, aS in ipairs(aJ.items or {}) do
            if aS.available and type(aS.cost) == "number" and aS.cost >= 0 and aS.cost <= aJ.money and (aL or aO and aD(aS) or not aO and (aD(aS) or ax.options.antiDandy == true or not ax.options.selectedShopItems or ax.options.selectedShopItems[aS.name])) then
              table.insert(aN, aS)
            end
          end
          if #aN == 0 and aO and (ax.options.autoShop ~= false or ax.options.antiDandy == true) then
            aO = false
            for aR, aS in ipairs(aJ.items or {}) do
              if aS.available and type(aS.cost) == "number" and aS.cost >= 0 and aS.cost <= aJ.money and (ax.options.antiDandy == true or not ax.options.selectedShopItems or ax.options.selectedShopItems[aS.name]) then
                table.insert(aN, aS)
              end
            end
          end
          table.sort(aN, function(aR, aS)
            local aU, aV = aD(aR), aD(aS)
            if aU ~= aV then
              return aU
            end
            if aO and (tonumber(aJ.missingHealth) or 0) >= 2 then
              local aW, aY = aE(aR), aE(aS)
              if aW ~= aY then
                return aW
              end
            end
            return aR.cost == aS.cost and aR.name < aS.name or aR.cost < aS.cost
          end)
          local aR = aN[1]
          if not aR then
            az.stats.lastReason = "shop-no-affordable-item"
            return
          end
          if aO and az.medicalAttemptedStore == aJ.store or not aO and az.attemptedStore == aJ.store then
            return
          end
          if (aJ.freeSlots or 0) < 1 then
            az.stats.lastReason = "shop-inventory-full"
            if ax.makeRoom then
              ax.makeRoom()
            end
            return
          end
          local aS = ax.snapshot()
          if not aS or aS.store ~= aJ.store or not aI(aS) or aS.freeSlots < 1 or type(aS.money) ~= "number" or aS.money < aR.cost or not ax.safe() then
            return
          end
          local aU, aV = ax.purchase(aR)
          if not aU then
            az.stats.lastReason = aV
            return
          end
          if aO or aD(aR) then
            az.medicalAttemptedStore = aJ.store
          end
          az.attemptedStore = aJ.store
          az.stats.attempts += 1
          az.stats.lastReason = "shop-confirming"
          aA = {item = aR, money = aS.money, character = aS.character, inventorySignature = aS.inventorySignature,
            inventoryCounts = aS.inventoryCounts and table.clone(aS.inventoryCounts), medical = aO, deadline = ay() + 2}
        end
        function az.resetStore()
          az.attemptedStore = nil
          az.medicalAttemptedStore = nil
        end
        return az
      end
    end)()
    local ay = (function()
      return function(ay)
        local az = {}
        function az.run(aA)
          if not ay.active() then
            return false, "cancelled"
          end
          local aB = false
          local aC, aD, aE = xpcall(function()
            if ay.danger() then
              return false, "threat"
            end
            aB = true
            local aC, aD = ay.begin(aA)
            if not aC then
              return false, aD
            end
            if ay.slide then
              local aE = ay.confirmationTimeout or 0.6
              while aE > 0 do
                if not ay.active() then
                  return false, "cancelled"
                end
                if ay.confirmed(aA) then
                  return true, "collected"
                end
                if ay.danger() then
                  return false, "threat"
                end
                local aF = math.min(0.08, aE)
                ay.wait(aF)
                aE -= aF
              end
              if ay.confirmed(aA) then
                return true, "collected"
              end
              return false, "slide-pickup-unconfirmed"
            end
            for aE = 1, (ay.attempts or 8) do
              if not ay.active() then
                return false, "cancelled"
              end
              if ay.confirmed(aA) then
                return true, "collected"
              end
              if not ay.available(aA) then
                break
              end
              if ay.danger() then
                return false, "threat"
              end
              local aF, aG = ay.teleport(aA, aE)
              if aF == false then
                return false, aG or "pickup-position-changed"
              end
              local aI = aE == 1 and (ay.settle or 0) or (ay.stepSettle or 0)
              if aI > 0 then
                ay.wait(aI)
                if not ay.active() then
                  return false, "cancelled"
                end
                if ay.confirmed(aA) then
                  return true, "collected"
                end
                if not ay.available(aA) then
                  break
                end
              end
              if not ay.active() then
                return false, "cancelled"
              end
              if ay.danger() then
                return false, "threat"
              end
              ay.fire(aA, aE)
              ay.wait(ay.interval or 0.08)
            end
            local aE = ay.confirmationTimeout or 0
            while aE > 0 do
              if not ay.active() then
                return false, "cancelled"
              end
              if ay.confirmed(aA) then
                return true, "collected"
              end
              if ay.danger() then
                return false, "threat"
              end
              local aF = math.min(0.1, aE)
              ay.wait(aF)
              aE -= aF
            end
            if not ay.active() then
              return false, "cancelled"
            end
            if ay.confirmed(aA) then
              return true, "collected"
            end
            return false, "pickup-unconfirmed"
          end, debug.traceback)
          if aB then
            local aF, aG = pcall(ay.finish, aC and aE or "error")
            if not aF then
              return false, "pickup-cleanup: " .. tostring(aG)
            end
          end
          if not aC then
            return false, "pickup-error: " .. tostring(aD)
          end
          return aD, aE
        end
        return az
      end
    end)()
    local az = (function()
      return function(az)
        local aA = {stats = {attempts = 0, used = 0, rejected = 0}, cooldowns = {}, nextAt = 0}
        function aA.choose(aB)
          local aC, aD
          for aE, aF in ipairs(aB.inventory or {}) do
            local aG = aF.Value
            local aI, aJ = 0, 0
            if (aA.cooldowns[aG] or 0) > (az.clock()) then
              continue
            end
            local aK = (aB.maxHealth or aB.health) - (aB.health or 0)
            local aL = (aB.maxStamina or 0) - (aB.stamina or 0)
            if aG == "Bandage" and aK > 0 then
              aI = aK >= 2 and 110 or 125
            end
            if aG == "HealthKit" and aK > 0 then
              aI = aK >= 2 and 135 or 115
            end
            if aB.machine and aB.machineItems then
              local aN = (aB.required or 1) - (aB.amount or 0)
              if aG == "Valve" and aN > math.max(1, (aB.required or 1) * 0.05) then
                aI = 100
              end
              if aG == "JumperCable" and aN > math.max(1, (aB.required or 1) * 0.1) then
                aI = 95
              end
              if aG == "Instructions" and aN > 3 then
                aI, aJ = 85, 10
              end
              if aG == "ExtractionSpeedCandy" and aN > 3 then
                aI, aJ = 80, 5
              end
              if aG == "Stopwatch" and aN > 3 then
                aI, aJ = 78, 15
              end
              if aG == "SkillCheckCandy" and aN > 3 then
                aI, aJ = 75, 5
              end
            end
            if aG == "Pop" and aL >= (aB.drainForItems and 1 or 30) then
              aI = 60
            end
            if aG == "PopBottle" and aL >= (aB.drainForItems and 1 or 45) then
              aI = 65
            end
            if (aG == "Chocolate" or aG == "ChocolateBox") and aL >= 1 then
              aI, aJ = 50, 10
            end
            if (aG == "StaminaCandy" or aG == "ProteinBar") and aL >= (aB.drainForItems and 1 or 20) then
              aI, aJ = 45, aG == "ProteinBar" and 15 or 20
            end
            if aG == "SmokeBomb" and aB.danger and not aB.covered then
              aI = 120
            end
            if aG == "StealthCandy" and aB.danger then
              aI, aJ = 70, 5
            end
            if aG == "SpeedCandy" and aB.travelling and not aB.covered then
              aI, aJ = 35, 5
            end
            if aG == "Gumball" and (aB.machine or aB.travelling) then
              aI, aJ = 20, 5
            end
            if aI > 0 and (not aD or aI > aD) then
              aC = {slot = aF, name = aG, duration = aJ}
              aD = aI
            end
          end
          return aC
        end
        function aA.step()
          if not az.enabled() then
            return false
          end
          if aA.draining then
            return false
          end
          local aB = az.clock()
          if aA.pending then
            local aC = aA.pending
            if aC.slot.Value ~= aC.name or aC.charges and az.charges and az.charges(aC.slot) ~= aC.charges then
              aA.stats.used += 1
              aA.stats.lastUsed = aC.name
              aA.pending = nil
            elseif aB >= aC.untilAt then
              aA.stats.rejected += 1
              aA.pending = nil
            else
              return false
            end
          end
          if aB < aA.nextAt then
            return false
          end
          aA.nextAt = aB + 0.25
          local aC = az.snapshot()
          if not aC or not aC.alive then
            return false
          end
          local aD = aA.choose(aC)
          if not aD then
            if aC.drainForItems and aC.safeToDrain and az.drain and aB >= (aA.nextDrainAt or 0) and (aC.maxStamina or 0) - (aC.stamina or 0) < 1 then
              local aE = false
              for aF, aG in ipairs(aC.inventory or {}) do
                if ({Pop = true, PopBottle = true, Chocolate = true, ChocolateBox = true, StaminaCandy = true,
                    ProteinBar = true})[aG.Value] then
                  aE = true
                  break
                end
              end
              if aE then
                aA.draining = true
                aA.nextDrainAt = aB + 3
                az.drain(function(aF)
                  aA.draining = false
                  if aF then
                    aA.stats.staminaBursts = (aA.stats.staminaBursts or 0) + 1
                  end
                end)
              end
            end
            return false
          end
          aA.stats.attempts += 1
          aA.nextAt = aB + 0.7
          local aE = az.use(aD.slot)
          if not aE then
            aA.cooldowns[aD.name] = aB + 3
            return false
          end
          aA.cooldowns[aD.name] = aB + math.max(3, aD.duration)
          aA.pending = {slot = aD.slot, name = aD.name, untilAt = aB + 1.5, charges = az.charges and az.charges(aD.slot)}
          return true
        end
        return aA
      end
    end)()
    local aA = (function()
      return function(aA)
        local aB = {stats = {attempts = 0, opened = 0, unconfirmed = 0}, map = nil, index = 1, queue = {}}
        function aB.reset(aC)
          if aB.map == aC then
            return
          end
          aB.map = aC
          aB.index = 1
          aB.queue = {}
          local aD = aC and aC:FindFirstChild("TrickOrTreatDoors")
          if aD then
            for aE, aF in ipairs(aD:GetChildren()) do
              local aG = aF:FindFirstChildWhichIsA("ProximityPrompt", true)
              if aG then
                aB.queue[#aB.queue + 1] = {object = aF, prompt = aG, attempts = 0}
              end
            end
          end
        end
        function aB.step(aC)
          aB.reset(aC)
          if not aA.enabled() or not aA.options.autoHalloweenDoors or aA.current() or aA.covered() then
            return false
          end
          local aD = aB.queue[aB.index]
          if not aD then
            return false
          end
          aB.index += 1
          if not aD.object.Parent or not aD.prompt.Parent or not aD.prompt.Enabled then
            return true
          end
          if aA.danger() then
            aB.index -= 1
            return true
          end
          aD.attempts += 1
          aB.stats.attempts += 1
          local aE = aD.prompt.MaxActivationDistance
          if aE < 1 then
            aD.prompt.MaxActivationDistance = 8
          end
          aA.status("Opening Halloween door")
          local aF, aG, aI = pcall(function()
            local aF, aG = aA.travel(aD.prompt)
            if not aF then
              return false, aG
            end
            if not aA.enabled() or aA.danger() then
              return false, "door-interrupted"
            end
            return aA.knock(aD)
          end)
          if aD.prompt.Parent then
            aD.prompt.MaxActivationDistance = aE
          end
          if aF and aG then
            aB.stats.opened += 1
          else
            aB.stats.unconfirmed += 1
            aB.stats.lastReason = tostring(aF and aI or aG)
            if aI ~= "door-ambush" and aD.attempts < 3 and aA.enabled() and aD.object.Parent then
              aB.queue[#aB.queue + 1] = aD
            end
          end
          return true
        end
        return aB
      end
    end)()
    local aB = (function()
      return function(aB)
        local aC = {stats = {attempts = 0, collected = 0, returns = 0, failures = 0}, retry = {}, done = {},
          busy = false}
        function aC.reset(aD)
          if aC.floor == aD then
            return
          end
          aC.floor = aD
          aC.retry = {}
          aC.done = {}
          aC.targets = nil
          aC.scanAt = 0
          aC.nextAt = 0
        end
        function aC.selected(aD)
          local aE = aB.options.selectedCapsuleTwisteds or {}
          return aE["All Twisteds"] == true or aE[aD] == true or aE[tostring(aD):gsub("Monster$", "")] == true
        end
        function aC.step(aD)
          aC.reset(aD)
          if aC.busy or not aB.options.autoCapsules or not aB.active(aD) or not aB.eligible() then
            return false
          end
          if not aC.targets or aB.clock() >= (aC.scanAt or 0) then
            aC.targets = aB.targets(aD)
            aC.scanAt = aB.clock() + 0.5
          end
          local aE
          for aF, aG in ipairs(aC.targets) do
            local aI = aC.retry[aG.object]
            if aC.selected(aG.twisted) and not aC.done[aG.object] and (not aI or aB.clock() >= aI.at) and aB.available(aG) then
              aE = aG
              break
            end
          end
          if not aE then
            return false
          end
          if aB.clock() < (aC.nextAt or 0) then
            return true
          end
          aC.busy = true
          aC.stats.attempts += 1
          aC.stats.target = aE.twisted
          local function aF()
            return aB.options.autoCapsules and aB.active(aD) and aC.selected(aE.twisted)
          end
          local function aG(aI)
            for aJ = 1, 4 do
              if not aF() then
                return false, "capsule-cancelled"
              end
              if aB.confirmed(aE) then
                return true, "capsule-collected"
              end
              local aK, aL = aI()
              if not aK then
                return false, aL or "capsule-position-changed"
              end
              if not aB.available(aE) then
                return false, "capsule-unavailable"
              end
              aB.fire(aE)
              aB.wait(0.12)
            end
            local aJ = aB.clock() + 0.45
            while aF() and aB.clock() < aJ do
              if aB.confirmed(aE) then
                return true, "capsule-collected"
              end
              local aK, aL = aI()
              if not aK then
                return false, aL or "capsule-position-changed"
              end
              aB.wait(0.06)
            end
            return aF() and aB.confirmed(aE), "capsule-unconfirmed"
          end
          local aI, aJ, aK, aL = pcall(aB.trip, aE, {active = aF, collect = aG})
          aC.busy = false
          aC.stats.target = nil
          aC.nextAt = aB.clock() + 0.25
          if not aI then
            aK = "capsule-error: " .. tostring(aJ)
            aJ = false
          end
          aC.stats.lastTwisted = aE.twisted
          aC.stats.lastReason = aK
          if aL then
            aC.stats.returns += 1
          end
          if aJ then
            aC.done[aE.object] = true
            aC.retry[aE.object] = nil
            aC.stats.collected += 1
          else
            local aN = aC.retry[aE.object]
            local aO = (aN and aN.count or 0) + 1
            aC.retry[aE.object] = {count = aO, at = aB.clock() + math.min(15, 2 * aO)}
            aC.stats.failures += 1
          end
          return true
        end
        return aC
      end
    end)()
    local aC = {stats = {pickups = 0, pickupAttempts = 0, pickupTeleports = 0, observed = 0, skippedItems = 0},
      records = {}, retry = {}, floor = nil, holding = false, sweep = nil}
    aC.encounterNotices = {}
    function aC.confirmEncounter(aD, aE)
      local aF = aC.records[aD] or {}
      aC.records[aD] = aF
      if not aF.observed then
        aF.observed = true
        aF.evidence = aE or "native detection"
        aC.stats.observed += 1
      end
      local aG = aw.name(aD.Name)
      if as.options.encounterNotifications ~= false and not aC.encounterNotices[aG] and ar.notifyEncounter then
        aC.encounterNotices[aG] = true
        pcall(ar.notifyEncounter, aG, aF.evidence)
      end
    end
    local aD
    local aE = au:FindFirstChild("Events") and au.Events:FindFirstChild("GrantPlayerResearch")
    local aF
    if aE then
      aF = aE.OnClientEvent:Connect(function(aG)
        if type(aG) ~= "string" or not ar.enabled() then
          return
        end
        local aI = ar.room()
        local aJ = aI and aI:FindFirstChild("Monsters")
        if aC.reset then
          aC.reset(aI)
        end
        if aJ then
          for aK, aL in ipairs(aJ:GetChildren()) do
            if aL.Name == aG then
              local aN = aC.records[aL] or {}
              aC.records[aL] = aN
              if as.options.waitForMadness and aD and not aD(aL) then
                aN.earlyResearch = true
              elseif not aN.observed then
                aN.observed = true
                aN.evidence = "server GrantPlayerResearch"
                aC.stats.observed += 1
              end
            end
          end
        end
      end)
    end
    local function aG(aI, aJ, aK)
      local aL = aI and aI:FindFirstChild(aJ)
      if aL and aL:IsA("ValueBase") then
        return aL.Value
      end
      return aK
    end
    local function aI()
      local aJ = ar.character()
      local aK = aJ and aJ:FindFirstChild("Inventory")
      local aL, aN = {}, 0
      if aK then
        for aO, aR in ipairs(aK:GetChildren()) do
          if aR:IsA("StringValue") and aR.Name:match("^Slot%d+$") then
            aL[#aL + 1] = aR
            if aR.Value == "None" or aR.Value == "" then
              aN += 1
            end
          end
        end
      end
      return aL, aN
    end
    aC.slots = aI
    aC.autoItems = az({clock = os.clock, enabled = function()
      return ar.enabled() and as.options.useConsumables
    end, snapshot = function()
      local aJ, aK = ar.character()
      if not aJ or not aK then
        return nil
      end
      local aL = aJ:FindFirstChild("Stats")
      local aN = ar.current()
      local aO = aN and aN:FindFirstChild("Stats")
      return {alive = aK.Health > 0, inventory = aI(), health = aK.Health, maxHealth = aK.MaxHealth, stamina = aG(aL, "CurrentStamina", 0),
        maxStamina = aG(aL, "Stamina", 0), machine = aN ~= nil and (not as.cover.active and not as.cover.pending or as.cover.workingMachine == aN),
        machineItems = as.options.autoMachineItems, amount = aG(aO, "CurrentAmount", 0), required = aG(aO, "RequiredAmount", 1),
        danger = ar.danger(), covered = as.cover.active or as.cover.pending, travelling = as.activity == "machine-travel" or as.activity == "pickup",
        drainForItems = as.options.drainStaminaItems, safeToDrain = not aN and not as.cover.active and not as.cover.pending and not ar.danger() and as.nav and not as.nav.stats.motionMode}
    end, charges = function(aJ)
      return aG(aJ, "Current", nil)
    end, drain = function(aJ)
      if not as.nav then
        aJ(false)
        return
      end
      local aK = as.nav
      as.staminaSpending = true
      task.spawn(function()
        local aL, aN = pcall(aK.spendStamina, function()
          return ar.enabled() and as.nav == aK and not ar.current() and not ar.danger() and not as.cover.active
        end)
        as.staminaSpending = false
        aJ(aL and aN == true)
      end)
    end, use = function(aJ)
      local aK = ar.input()
      local aL = aK and aK._actions and aK._actions["Item" .. (aJ.Name:match("%d+$") or "1")]
      if not aL or not ar.enabled() then
        return false
      end
      return pcall(firesignal, aL.Pressed)
    end})
    function aC.stepAutoItems()
      return aC.autoItems.step()
    end
    function aC.doorAmbushAt(aJ, aK, aL)
      local aN = as.hazards and as.hazards.pumpkinDangerAt and as.hazards.pumpkinDangerAt(aJ.Position, 20)
      if aN then
        return aN, "rolling-pumpkin"
      end
      local aO = ar.room() and ar.room():FindFirstChild("Monsters") or aL
      if aO then
        for aR, aS in ipairs(aO:GetChildren()) do
          local aU = aS.PrimaryPart or aS:FindFirstChild("HumanoidRootPart")
          if not aK[aS] and aU and (aU.Position - aJ.Position).Magnitude < 70 then
            return {model = aS, reason = "door-twisted-ambush"}, "twisted"
          end
        end
      end
      local aR, aS = ar.danger()
      if aR then
        return aS or {reason = "door-danger"}, "twisted"
      end
    end
    function aC.watchDoorAmbush(aJ, aK, aL)
      local aN = os.clock() + 1.2
      while ar.enabled() and aJ.Parent and ar.room() == aC.floor and os.clock() < aN do
        local aO, aR = aC.doorAmbushAt(aJ, aK, aL)
        if aO then
          aC.stats.doorAmbushes = (aC.stats.doorAmbushes or 0) + 1
          aC.stats.lastDoorAmbush = aR
          as.nav.interrupt()
          as.nav.evade(aO)
          return true
        end
        task.wait(0.08)
      end
      return false
    end
    aC.doors = aA({options = as.options, enabled = ar.enabled, current = ar.current, danger = ar.danger,
      covered = function()
      return as.cover.active or as.cover.pending
    end, status = ar.status, travel = function(aJ)
      as.activity = "door"
      return as.nav.moveToPickup(aJ, true)
    end, knock = function(aJ)
      local aK, aL, aN = ar.character()
      local aO = aN and aN.Position
      local aR = ar.room() and ar.room():FindFirstChild("Monsters")
      local aS = {}
      if aR then
        for aU, aV in ipairs(aR:GetChildren()) do
          aS[aV] = true
        end
      end
      local aU = ar.promptPosition(aJ.prompt)
      if not aN or not aU or (aN.Position - aU).Magnitude > aJ.prompt.MaxActivationDistance then
        return false, "door-arrival-unconfirmed"
      end
      local aV = false
      local aW = au:FindFirstChild("Events")
      local aY = aW and aW:FindFirstChild("TrickOrTreatFeed")
      local a0 = aY and aY.OnClientEvent:Connect(function(...)
        for a0, a3 in ipairs({...}) do
          if a3 == av or a3 == av.Name or a3 == av.DisplayName then
            aV = true
          end
        end
      end)
      local a3, a4 = pcall(fireproximityprompt, aJ.prompt)
      if not a3 then
        if a0 then
          a0:Disconnect()
        end
        return false, tostring(a4)
      end
      local a6 = os.clock() + 1.5
      while ar.enabled() and ar.room() == aC.floor and os.clock() < a6 do
        if not aJ.prompt.Parent or not aJ.prompt.Enabled or aJ.object:GetAttribute("Opened") == true then
          aV = true
          break
        end
        if aC.doorAmbushAt(aN, aS, aR) then
          break
        end
        if (aN.Position - aO).Magnitude > 100 then
          aV = true
          local a7 = aW and aW:FindFirstChild("TrickOrTreatReturn")
          if a7 then
            a7:FireServer()
          end
          task.wait(0.3)
          break
        end
        if aV then
          break
        end
        task.wait(0.1)
      end
      if a0 then
        a0:Disconnect()
      end
      local a7 = aC.watchDoorAmbush(aN, aS, aR)
      return aV, aV and "door-confirmed" or a7 and "door-ambush" or "door-knock-unconfirmed"
    end})
    function aC.openDoors(aJ)
      return aC.doors.step(aJ)
    end
    local function aJ()
      local aL, aN = aI()
      if aN > 0 then
        return true
      end
      if not as.options.useConsumables then
        return false
      end
      local aO = {Gumball = true, StealthCandy = true, SpeedCandy = true, StaminaCandy = true, ProteinBar = true}
      for aR, aS in ipairs(aL) do
        if aO[aS.Value] then
          local aU = ar.input() and ar.input()._actions["Item" .. (aS.Name:match("%d+$") or "1")]
          if aU and ar.enabled() then
            pcall(firesignal, aU.Pressed)
            task.wait(0.2)
            local aV, aW = aI()
            return aW > 0
          end
        end
      end
      return false
    end
    function aC.reset(aL)
      local aN = aG(at:FindFirstChild("Info"), "Floor", nil)
      if aC.floor == aL and aC.floorNumber == aN then
        return
      end
      aC.floor = aL
      aC.floorNumber = aN
      aC.records = {}
      aC.encounterNotices = {}
      aC.retry = {}
      aC.collected = {}
      aC.holding = false
      aC.skip = false
      aC.current = nil
      aC.exitStarted = false
      aC.exitDone = false
      aC.exitDeadline = nil
      aC.sweep = nil
      aC.nextPickupAt = nil
      aC.pickup = nil
      as.pickup = nil
      aC.stats.pickupTarget = nil
      aC.slideActive = false
      aC.passivePickup = nil
      aC.passiveTargets = nil
      aC.passiveScanAt = nil
      aC.passivePulseAt = nil
      if aC.capsules then
        aC.capsules.reset(nil)
        aC.capsules.reset(aL)
      end
    end
    function aC.observe()
      local aL = ar.room()
      aC.reset(aL)
      local aN = aL and aL:FindFirstChild("Monsters")
      local aO = ar.character()
      if aN and aO then
        for aR, aS in ipairs(aN:GetChildren()) do
          local aU = aC.records[aS] or {}
          aC.records[aS] = aU
          local aV = aS.PrimaryPart or aS:FindFirstChild("HumanoidRootPart")
          if aV then
            local aW = os.clock()
            if not aU.position then
              aU.position = aV.Position
              aU.motionSampleAt = aW
            elseif aW - (aU.motionSampleAt or 0) >= 0.12 then
              local aY = aV.Position - aU.position
              if math.sqrt(aY.X * aY.X + aY.Z * aY.Z) > 0.15 then
                aU.lastMotion = aW
                aU.movingSince = aU.movingSince or aW
                if aW - aU.movingSince >= 0.24 then
                  aU.walkingObserved = true
                end
              else
                aU.movingSince = nil
                aU.walkingObserved = false
              end
              aU.position = aV.Position
              aU.motionSampleAt = aW
            end
          end
          if aw.chasingUs(aS, aO, av) and (not as.options.waitForMadness or not aD or aD(aS)) then
            aC.confirmEncounter(aS, "native ChasingValue")
          end
        end
      end
    end
    function aC.itemNames()
      local aL, aN = {}, {}
      local aO = au:FindFirstChild("ItemModules")
      if aO then
        for aR, aS in ipairs(aO:GetChildren()) do
          if aS:IsA("ModuleScript") then
            aN[aS.Name] = true
          end
        end
      end
      for aR, aS in ipairs({"Pumpkin", "Tape", "Tapes"}) do
        aN[aS] = true
      end
      local aR = ar.room()
      if aR then
        for aS, aU in ipairs({"Items", "HolidayPickups"}) do
          local aV = aR:FindFirstChild(aU)
          if aV then
            for aW, aY in ipairs(aV:GetChildren()) do
              aN[aY.Name] = true
            end
          end
        end
      end
      for aS in pairs(aN) do
        if not aS:lower():find("capsule", 1, true) then
          aL[#aL + 1] = aS
        end
      end
      table.sort(aL)
      return aL
    end
    function aC.sameItem(aL, aN)
      local function aO(aR)
        return tostring(aR or ""):lower():gsub("[^%w]", ""):gsub("%d+$", "")
      end
      return aO(aL) == aO(aN)
    end
    function aC.inventoryPickupConfirmed(aL, aN)
      for aO, aR in pairs(aL) do
        if aO.Value ~= aR and aC.sameItem(aO.Value, aN) then
          return true
        end
      end
      return false
    end
    function aC.selectedName(aL, aN, aO)
      if aw.isCapsule(aL, aN) then
        return nil
      end
      local aR = {aL.Name, aN.ObjectText, aN.ActionText, aL:GetAttribute("ItemName"), aL:GetAttribute("ItemType")}
      local aS = aL.Parent
      while aS and aS ~= aO do
        aR[#aR + 1] = aS.Name
        for aU, aV in ipairs({"ItemName", "ItemType"}) do
          local aW = aS:GetAttribute(aV)
          if type(aW) == "string" then
            aR[#aR + 1] = aW
          end
        end
        aS = aS.Parent
      end
      if aO.Name == "HolidayPickups" and aL.Name:lower():find("pumpkin", 1, true) then
        aR[#aR + 1] = "Pumpkin"
      end
      for aU, aV in pairs(as.options.selectedItems) do
        if aV then
          for aW, aY in pairs(aR) do
            if aC.sameItem(aY, aU) then
              return aU
            end
          end
        end
      end
    end
    local function aL(aN, aO)
      local aR = {}
      local aS, aU, aV = ar.character()
      if not aV then
        return aR
      end
      for aW, aY in ipairs({"Items", "HolidayPickups"}) do
        local a0 = aN and aN:FindFirstChild(aY)
        if a0 then
          for a3, a4 in ipairs(a0:GetDescendants()) do
            if not a4:IsA("ProximityPrompt") then
              continue
            end
            local a6 = a4.Parent
            while a6 and a6.Parent ~= a0 and not a6:IsA("Model") and not a6:IsA("BasePart") do
              a6 = a6.Parent
            end
            if not a6 or aC.collected and aC.collected[a6] then
              continue
            end
            local a7 = a4 and aw.isCapsule(a6, a4)
            local a8 = aY == "HolidayPickups" and a6.Name:lower():find("pumpkin", 1, true)
            local a9 = aC.selectedName(a6, a4, a0)
            if a4.Enabled and a4.MaxActivationDistance > 0.5 and a9 then
              local ba = not a7 or aw.realCapsule(a6, a4, au:FindFirstChild("MonsterData"))
              local bb = ar.promptPosition(a4)
              if ba and bb then
                aR[#aR + 1] = {object = a6, prompt = a4, position = bb, name = a9, kind = "loot", floor = aN}
              end
            end
          end
        end
      end
      table.sort(aR, function(aW, aY)
        return (aV.Position - aW.position).Magnitude < (aV.Position - aY.position).Magnitude
      end)
      return aR
    end
    aC.lootTargets = aL
    function aC.capsuleNames()
      local aN = {"All Twisteds"}
      local aO = {}
      local aR = au:FindFirstChild("MonsterData")
      if aR then
        for aU, aV in ipairs(aR:GetChildren()) do
          if aV:IsA("ModuleScript") then
            local aW = aw.name(aV.Name)
            if not aO[aW] then
              aO[aW] = true
              aN[#aN + 1] = aW
            end
          end
        end
      end
      table.sort(aN, function(aU, aV)
        if aU == "All Twisteds" then
          return true
        elseif aV == "All Twisteds" then
          return false
        end
        return aU < aV
      end)
      return aN
    end
    function aC.capsuleTargets(aN)
      local aO = {}
      local aR, aU, aV = ar.character()
      local aW = aN and aN:FindFirstChild("Items")
      local aY = au:FindFirstChild("MonsterData")
      if not aW or not aV then
        return aO
      end
      for a0, a3 in ipairs(aW:GetDescendants()) do
        if not a3:IsA("ProximityPrompt") or a3:GetAttribute("CapsulePrompt") ~= true then
          continue
        end
        local a4 = a3.Parent
        local a6 = a4
        while a6 and a6 ~= aW do
          if a6.Name:lower():find("capsule", 1, true) then
            a4 = a6
          end
          a6 = a6.Parent
        end
        local a7, a8 = aw.realCapsule(a4, a3, aY)
        local a9 = a7 and ar.promptPosition(a3)
        if a9 then
          aO[#aO + 1] = {object = a4, prompt = a3, position = a9, twisted = aw.name(a8), monster = a8,
            parent = a4.Parent, promptParent = a3.Parent, floor = aN}
        end
      end
      table.sort(aO, function(a0, a3)
        return (aV.Position - a0.position).Magnitude < (aV.Position - a3.position).Magnitude
      end)
      return aO
    end
    aC.capsules = aB({options = as.options, clock = os.clock, wait = function(aN)
      return task.wait(aN)
    end, targets = aC.capsuleTargets, active = function(aN)
      return ar.enabled() and not as.destroyed and ar.room() == aN and not aG(at:FindFirstChild("Info"), "Loading", false)
    end, eligible = function()
      return not ar.current() and not as.cover.active and not as.cover.pending and not as.shelter and not aC.pickup and not ar.danger()
    end, available = function(aN)
      if not aN.object.Parent or not aN.prompt.Parent or not aN.prompt.Enabled or not aN.object:IsDescendantOf(aN.floor) then
        return false
      end
      local aO, aU = aw.realCapsule(aN.object, aN.prompt, au:FindFirstChild("MonsterData"))
      return aO and aU == aN.monster
    end, confirmed = function(aN)
      return aN.object.Parent ~= aN.parent or aN.prompt.Parent ~= aN.promptParent
    end, fire = function(aN)
      aC.stats.capsulePickupAttempts = (aC.stats.capsulePickupAttempts or 0) + 1
      fireproximityprompt(aN.prompt)
    end, trip = function(aN, aO)
      local aU = as.activity
      as.activity = "capsule"
      local aV, aW, aY, a0 = pcall(as.nav.capsuleRoundTrip, aN.prompt, aO)
      if as.activity == "capsule" then
        as.activity = aU
      end
      if not aV then
        error(aW, 0)
      end
      return aW, aY, a0
    end})
    aC.stats.capsules = aC.capsules.stats
    function aC.collectCapsules(aN)
      return aC.capsules.step(aN)
    end
    function aC.storedItem(aN)
      for aO, aU in ipairs({"Pumpkin", "ResearchCapsule", "Tape", "Tapes"}) do
        if aC.sameItem(aN, aU) then
          return false
        end
      end
      return true
    end
    function aC.inPickupReach(aN)
      return as.nav.pickupInReach and as.nav.pickupInReach(aN.prompt) == true or false
    end
    function aC.setPickup(aN)
      aC.pickup = aN
      as.pickup = aN
      aC.stats.pickupTarget = aN and aN.name or nil
    end
    function aC.confirmedPickup(aN, aO, aU)
      return aN.object.Parent ~= aO or not aN.prompt.Parent or aC.inventoryPickupConfirmed(aU, aN.name)
    end
    function aC.creditPickup(aN)
      aC.collected = aC.collected or {}
      if not aC.collected[aN.object] then
        aC.collected[aN.object] = true
        aC.stats.pickups += 1
      end
      aC.retry[aN.object] = nil
      if aC.pickup and aC.pickup.object == aN.object then
        aC.setPickup(nil)
      end
    end
    function aC.stepSlidePickup(aN)
      if os.clock() < (aC.passivePulseAt or 0) then
        return
      end
      aC.passivePulseAt = os.clock() + 0.08
      local aO = ar.room()
      aC.reset(aO)
      local aU = aC.passivePickup
      if aU and aC.confirmedPickup(aU.target, aU.parent, aU.before) then
        aC.creditPickup(aU.target)
        aC.stats.passByPickups = (aC.stats.passByPickups or 0) + 1
        aC.passivePickup = nil
        aU = nil
      elseif aU and os.clock() - aU.at > 0.7 then
        aC.passivePickup = nil
        aU = nil
      end
      if not aN or as.options.itemPickupMode ~= "slide" or not as.options.autoLoot or not ar.enabled() or not aO or aC.slideActive or as.cover.active or as.cover.pending or as.shelter or ar.current() or ar.danger() then
        return
      end
      local aV, aW = ar.character()
      if not aW or aW.Health <= 0 then
        return
      end
      if not aC.passiveTargets or os.clock() >= (aC.passiveScanAt or 0) then
        aC.passiveTargets = aL(aO)
        aC.passiveScanAt = os.clock() + 0.5
      end
      if not aU then
        local aY, a0 = aI()
        for a3, a4 in ipairs(aC.passiveTargets) do
          if a4.object.Parent and a4.prompt.Parent and a4.prompt.Enabled and not (aC.collected and aC.collected[a4.object]) and as.options.selectedItems[a4.name] and (a0 > 0 or not aC.storedItem(a4.name)) and aC.inPickupReach(a4) then
            local a6 = {}
            for a7, a8 in ipairs(aY) do
              a6[a8] = a8.Value
            end
            aU = {target = a4, parent = a4.object.Parent, before = a6, at = os.clock(), attempts = 0}
            aC.passivePickup = aU
            break
          end
        end
      end
      if aU and aU.attempts < 4 and aU.target.prompt.Parent and aU.target.prompt.Enabled and as.options.selectedItems[aU.target.name] and aC.inPickupReach(aU.target) then
        aU.attempts += 1
        aC.stats.pickupAttempts += 1
        local aY = pcall(fireproximityprompt, aU.target.prompt)
        if not aY then
          aC.passivePickup = nil
        end
      end
    end
    function aC.activePickup(aN, aO)
      local aU = aC.pickup
      if not aU then
        return nil
      end
      if not as.options.autoLoot then
        aC.setPickup(nil)
        return nil
      end
      if aU.floor == aN then
        for aV, aW in ipairs(aO or aL(aN)) do
          if aW.object == aU.object and aW.prompt == aU.prompt then
            aU.unavailableAt = nil
            aC.setPickup(aW)
            return aW
          end
        end
        if aU.object.Parent and aU.object:IsDescendantOf(aN) and aU.prompt.Parent and not (aC.collected and aC.collected[aU.object]) and as.options.selectedItems[aU.name] then
          aU.unavailableAt = aU.unavailableAt or os.clock()
          if os.clock() - aU.unavailableAt < 1.5 then
            return aU
          end
          aC.stats.pickupInvalidated = "selected-prompt-unavailable"
        end
      end
      aC.setPickup(nil)
      return nil
    end
    function aC.collect(aN, aO)
      aC.reset(aN)
      if not as.options.autoLoot or as.cover.active or as.cover.pending or as.shelter then
        return false
      end
      if ar.current() then
        return false
      end
      if not aC.sweep or aC.sweep.done then
        aC.sweep = {startedAt = os.clock(), done = false}
      end
      local aU = aC.sweep
      if aU.done then
        return false
      end
      local aV = as.options.itemSweepBudget or 0
      if aV > 0 and os.clock() - aU.startedAt >= aV and not aC.activePickup(aN) then
        aU.done = true
        return false
      end
      local aW, aY = aI()
      local a0 = aL(aN, aO)
      local a3, a4, a6, a7 = nil, false, false, false
      local a8 = aC.activePickup(aN, a0)
      if a8 and (aY > 0 or not aC.storedItem(a8.name)) then
        if not a8.prompt.Enabled then
          ar.status("Keeping selected item · waiting for its prompt")
          return true
        end
        local a9 = aC.retry[a8.object]
        if a9 and os.clock() < a9.at then
          ar.status("Keeping the interrupted item · retrying shortly")
          return true
        end
        a3 = a8
      elseif a8 then
        aC.setPickup(nil)
      end
      local function a9()
        for ba, bb in ipairs(a0) do
          local bc = aC.retry[bb.object]
          if bc and os.clock() < bc.at then
            a6 = true
            a7 = a7 or bc.count < 3
          elseif aC.storedItem(bb.name) and aY <= 0 then
            a4 = true
          elseif aC.inPickupReach(bb) then
            a3 = bb
            return
          elseif not a3 then
            a3 = bb
          end
        end
      end
      if not a3 then
        a9()
      end
      if not a3 and a4 and aJ() then
        aW, aY = aI()
        a4 = false
        a9()
      end
      if not a3 then
        if a7 then
          ar.status("Retrying the pending selected item shortly")
          return true
        end
        aU.done = true
        aU.inventoryBlocked = a4
        if a4 then
          ar.status("Inventory full · use held items on machines, then resume pickups")
        elseif a6 then
          ar.status("Item pickups deferred · retrying after machine progress")
        end
        return false
      end
      aC.setPickup(a3)
      aU.inventoryBlocked = false
      as.activity = "pickup"
      local ba = as.generation
      local bb, bc, bd = ar.character()
      local be = a3.object.Parent
      local bh = aI()
      local bi = {}
      for bj, bk in ipairs(bh) do
        bi[bk] = bk.Value
      end
      local function bj()
        local bk, bl, bm = ar.character()
        return ar.enabled() and as.generation == ba and ar.room() == aN and bk == bb and bm == bd and bl and bl.Health > 0
      end
      local bk = as.options.itemPickupMode == "slide"
      local function bl()
        return ar.danger() or as.cover.active or as.cover.pending or as.shelter
      end
      local function bm()
        return aC.confirmedPickup(a3, be, bi)
      end
      local function bn(bo)
        aC.stats.pickupAttempts += 1
        fireproximityprompt(a3.prompt)
        if bo >= 3 and a3.prompt.Parent then
          a3.prompt:InputHoldBegin()
          a3.prompt:InputHoldEnd()
        end
      end
      aC.slideActive = bk
      local bo = ay({slide = bk, active = bj, danger = bl, confirmed = bm, available = function()
        return a3.object.Parent and a3.prompt.Parent and a3.prompt.Enabled
      end, begin = function()
        local bo = aC.retry[a3.object]
        if bk then
          return as.nav.slideToPickup(a3.prompt, bo and bo.count or 0, {active = bj, danger = bl, confirmed = bm,
            fire = bn})
        end
        if aC.inPickupReach(a3) then
          aC.stats.pickupsInReach = (aC.stats.pickupsInReach or 0) + 1
          return true, "pickup-already-in-reach"
        end
        return as.nav.moveToPickup(a3.prompt, true, bo and bo.count or 0)
      end, teleport = function()
        local bo = ar.promptPosition(a3.prompt)
        if not bo or (bd.Position - bo).Magnitude > a3.prompt.MaxActivationDistance - 0.1 or not as.nav.isGrounded() then
          return false, "pickup-position-changed"
        end
      end, fire = function(bo, bp)
        bn(bp)
      end, wait = task.wait, settle = 0, stepSettle = 0, interval = 0.1, attempts = 4, confirmationTimeout = 0.6,
        finish = function()
        aC.slideActive = false
      end})
      local bp, bq = bo.run(a3)
      aC.slideActive = false
      aC.stats.lastPickup = a3.name
      aC.stats.lastPickupReason = bq
      if bp then
        aC.creditPickup(a3)
      else
        local bs = aC.retry[a3.object]
        local bt = bq == "route-needs-cover" or bq == "twisted-on-direct-route" or bq == "twisted-route-changed" or bq == "no-route-around-twisteds"
        if bt and as.nav.waitForRoute then
          as.nav.waitForRoute(bq)
        end
        local by = as.cover.active or as.cover.pending or as.shelter or ar.danger() or bq == "threat" or bq == "health-loss" or bq == "twisted-detected" or bq == "twisted-chasing" or bq == "cancelled" or bt and as.nav.waitForRoute ~= nil
        local bB = bq == "server-correction" or bq == "pickup-position-changed"
        local bC = (bs and bs.count or 0) + (by and 0 or 1)
        aC.retry[a3.object] = {count = bC, at = os.clock() + (by and 0.1 or bB and 0.2 or bC < 3 and 0.4 or 2),
          forceTween = true}
        if by then
          aC.stats.pickupInterruptions = (aC.stats.pickupInterruptions or 0) + 1
        else
          aC.stats.skippedItems += 1
        end
        ar.status(by and "Item interrupted · keeping it for after cover" or bB and "Pickup position corrected · keeping the same item for tween recovery" or "Selected item still pending · " .. tostring(bq))
      end
      return true
    end
    function aC.pendingItems()
      local aN, aO = aI()
      if not as.options.autoLoot then
        return false
      end
      local aU = aC.activePickup(ar.room())
      if aU and (aO > 0 or not aC.storedItem(aU.name)) then
        return true
      end
      for aV, aY in ipairs(aL(ar.room())) do
        local a0 = aC.retry[aY.object]
        if (aO > 0 or not aC.storedItem(aY.name)) and (not a0 or os.clock() >= a0.at) then
          if aC.sweep and aC.sweep.done then
            aC.sweep = nil
          end
          return true
        end
      end
      return false
    end
    aD = function(aN)
      local aO = aN.Name:lower():find("gourdy", 1, true) ~= nil
      local aU = aC.records[aN]
      local aV = aU and aU.walkingObserved and aU.lastMotion and os.clock() - aU.lastMotion < 1
      if not aw.emerged(aN) and not (aO and (aV or aU and aU.mobilityConfirmed) and aN:GetAttribute("GourdyEmerging") ~= true) then
        return false
      end
      local aY = aw.rage(aN)
      local a0 = aN.Name:lower():find("gourdy", 1, true) or aY ~= nil or aN:GetAttribute("MadnessPercent") ~= nil
      if not a0 then
        return true
      end
      local a3 = aN:FindFirstChild("IsStationary")
      if a3 and a3.Value == true or aN:GetAttribute("IsStationary") == true or aN:GetAttribute("GourdyEmerging") == true and aN:GetAttribute("GourdyEmergenceComplete") ~= true then
        if aU then
          aU.mobilityConfirmed = false
        end
        return false
      end
      if aO and aU and aU.mobilityConfirmed then
        return true
      end
      local a4 = aN:FindFirstChild("Chaser")
      local a6 = a4 and a4:FindFirstChild("RunSpeed")
      local a7 = aV or aN:GetAttribute("LastAnimationState") == "Walk" or aN:GetAttribute("Wandering") == true
      local a8 = (aV or not a6 or a6.Value > 0 or aO and aw.emerged(aN)) and a7 == true
      if a8 and aO and aU then
        aU.mobilityConfirmed = true
      end
      return a8
    end
    function aC.waitForMobile(aN)
      aC.current = aN
      aC.holding = true
      as.activity = "research"
      as.researchActive = true
      local aO = ar.inElevator()
      if not aO then
        if as.cover.active or as.cover.pending then
          as.nav.resumeCover()
        elseif ar.hide then
          ar.hide("waiting-for-Gourdy-to-walk")
        else
          as.nav.hide("tween")
        end
        aO = as.cover.active == true
      end
      ar.status((aO and "Hidden · waiting for " or "Finding cover · waiting for ") .. aw.name(aN.Name) .. " to stand up and start walking before encounters · madness " .. tostring(aw.rage(aN) or aN:GetAttribute("MadnessPercent") or "?"))
      return true
    end
    function aC.research(aN)
      if not as.options.researchMode or aC.skip then
        aC.holding = false
        return false
      end
      aC.observe()
      local aO = aN and aN:FindFirstChild("Monsters")
      if not aO then
        return false
      end
      for aU, aV in ipairs(aO:GetChildren()) do
        if aV:IsA("Model") and aV.Name:lower():find("gourdy", 1, true) and not aD(aV) then
          return aC.waitForMobile(aV)
        end
      end
      local aU = {}
      local aV = false
      for aY, a0 in ipairs(aO:GetChildren()) do
        local a3 = aC.records[a0]
        if a0:IsA("Model") then
          local a4 = as.nav.encounterBlockedReason and as.nav.encounterBlockedReason(a0)
          if a4 then
            a3 = a3 or {}
            aC.records[a0] = a3
            a3.lastReason = a4
            aC.stats.encounterReasons = aC.stats.encounterReasons or {}
            aC.stats.encounterReasons[a0.Name] = a4
          elseif not (a3 and a3.attempted and a3.observed) then
            if a3 and a3.retryAt and os.clock() < a3.retryAt then
              aV = true
            else
              aU[#aU + 1] = a0
            end
          end
        end
      end
      table.sort(aU, function(aY, a0)
        local a3, a4 = aC.records[aY], aC.records[a0]
        local a6, a7 = a3 and a3.attempts or 0, a4 and a4.attempts or 0
        return a6 == a7 and aY.Name < a0.Name or a6 < a7
      end)
      local aY = aU[1]
      if not aY then
        aC.holding = false
        aC.current = nil
        if aV then
          ar.status("Encounter pending · waiting to retry safely")
          return true
        end
        return false
      end
      aC.current = aY
      as.activity = "research"
      as.researchActive = true
      local a0 = aC.records[aY] or {}
      aC.records[aY] = a0
      if a0.retryAt and os.clock() < a0.retryAt then
        ar.status("Encounter pending · waiting to retry safely")
        return true
      end
      if as.options.waitForMadness and not aD(aY) then
        return aC.waitForMobile(aY)
      end
      aC.holding = false
      as.shelter = false
      a0.attempted = true
      a0.attempts = (a0.attempts or 0) + 1
      local a3, a4 = as.nav.encounter(aY, function(a3)
        aC.confirmEncounter(aY, a3)
      end)
      if a3 then
        aC.confirmEncounter(aY, "native detection")
      end
      a0.lastReason = a4
      if a4 == "movement-busy" or a4 == "extraction-release-pending" or a4 == "connie-merged-with-machine" or a4 == "rodger-dormant-capsule" or a4 == "rodger-not-ready" then
        a0.attempted = false
        a0.attempts -= 1
        return true
      end
      aC.stats.encounterReasons = aC.stats.encounterReasons or {}
      aC.stats.encounterReasons[aY.Name] = a4
      if not a3 and not a0.observed then
        a0.retryAt = os.clock() + 0.4
        aC.stats.unconfirmed = (aC.stats.unconfirmed or 0) + 1
        ar.status((a0.attempts < 3 and "Encounter unconfirmed · retrying after the other Twisteds · " or "Encounter unconfirmed after 3 tries · ") .. aw.name(aY.Name) .. " · " .. tostring(a4))
      end
      return true
    end
    function aC.encounterExitRequired()
      local aN = at:FindFirstChild("Info")
      local aO = tonumber(aG(aN, "RequiredGenerators", nil))
      local aU = tonumber(aG(aN, "GeneratorsCompleted", nil))
      if aO and aO > 0 and aU and aU < aO and aG(aN, "FloorActive", true) == true and aG(aN, "Panic", false) ~= true then
        aC.exitStarted = false
        aC.exitDone = false
        aC.exitDeadline = nil
        as.researchActive = false
        as.postActive = false
        return false
      end
      if aC.floorNumber ~= aG(aN, "Floor", nil) then
        return false
      end
      if not aC.exitStarted then
        return false
      end
      if aC.exitDone then
        return true
      end
      if aG(aN, "FloorActive", true) == false then
        return true
      end
      local aV = tonumber(aG(aN, "PanicTimer", nil))
      if aG(aN, "Panic", false) == true and aV and aV <= 10 then
        return true
      end
      return aC.exitDeadline ~= nil and os.clock() >= aC.exitDeadline
    end
    function aC.endEncounters(aN)
      if not aC.exitDone then
        aC.exitDone = true
        aC.stats.encounterExitReason = aN or "encounters-finished"
        if as.nav then
          as.nav.interrupt()
        end
      end
      as.researchActive = false
      as.postActive = false
      aC.holding = false
      aC.current = nil
      ar.status("Returning to elevator · " .. tostring(aN or "encounters finished"))
      return false
    end
    function aC.afterMachines(aN)
      if not as.options.researchMode or aC.skip then
        as.researchActive = false
        as.postActive = false
        aC.holding = false
        return false
      end
      aC.reset(aN)
      if aC.exitDone then
        as.researchActive = false
        as.postActive = false
        aC.holding = false
        return false
      end
      as.postActive = true
      local aO = not aC.exitStarted
      if aO then
        aC.exitStarted = true
        aC.exitDeadline = os.clock() + 6
        as.nav.interrupt()
      end
      if aC.encounterExitRequired() then
        return aC.endEncounters("encounter time limit")
      end
      if aO then
        return true
      end
      local aU = aC.research(aN)
      if aC.exitDone or aC.encounterExitRequired() then
        return aC.endEncounters("encounter time limit")
      end
      if aU then
        return true
      end
      return aC.endEncounters("encounters finished")
    end
    local function aN()
      local aO, aU = ar.character()
      local aV = at:FindFirstChild("Info")
      local aY = at:FindFirstChild("Elevators")
      aY = aY and aY:FindFirstChild("Elevator")
      local a0 = aY and aY:FindFirstChild("DandyStore")
      local a3 = aV and aV:FindFirstChild("PlayerStats")
      local a4 = a3 and a3:FindFirstChild(av.Name)
      local a6, a7 = aI()
      local a8, a9 = {}, {}
      for ba, bb in ipairs(a6) do
        a8[#a8 + 1] = bb.Name .. ":" .. bb.Value
        a9[bb.Value] = (a9[bb.Value] or 0) + 1
      end
      table.sort(a8)
      local ba = {floor = aG(aV, "Floor", 0), open = aG(aV, "DandyStoreOpen", false), character = aO,
        alive = aU and aU.Health > 0, inElevator = ar.inElevator(), money = aG(a4, "SurvivalPoints", nil),
        store = a0, freeSlots = a7, inventoryCounts = a9, medicalNeeded = aU and aU.Health < aU.MaxHealth,
        missingHealth = aU and math.max(0, aU.MaxHealth - aU.Health) or 0, inventorySignature = table.concat(a8, "|"),
        items = {}}
      if ba.open and a0 then
        for bb, bc in ipairs(a0:GetChildren()) do
          if bc.Name:match("^Slot%d+$") then
            for bd, be in ipairs(bc:GetChildren()) do
              local bh = be:FindFirstChild("Cost")
              if bh and bh:IsA("ValueBase") then
                local bi = be:FindFirstChildWhichIsA("ClickDetector", true)
                local bj = be:FindFirstChildWhichIsA("ProximityPrompt", true)
                ba.items[#ba.items + 1] = {name = be.Name, object = be, cost = tonumber(bh.Value), available = bi and bi.MaxActivationDistance > 0 or bj and bj.Enabled,
                  click = bi, prompt = bj}
              end
            end
          end
        end
      end
      return ba
    end
    local function aO()
      return ar.enabled() and ar.inElevator() and not ar.current() and not as.cover.active and not as.cover.pending
    end
    aC.shop = ax({options = as.options, snapshot = aN, enabled = ar.enabled, safe = aO, status = ar.status,
      makeRoom = aJ, purchase = function(aU)
      if not aO() then
        return false, "shop-unsafe"
      end
      local aV = aU.click or aU.prompt
      if not aV or not aV.Parent or not aU.object.Parent then
        return false, "shop-control-unavailable"
      end
      local aY = ar.promptPosition(aV) or aU.object:IsA("Model") and aU.object:GetPivot().Position
      local a0, a3, a4 = ar.character()
      if not aY or not a4 then
        return false, "shop-position-unavailable"
      end
      if (a4.Position - aY).Magnitude > aV.MaxActivationDistance then
        local a6, a7 = as.nav.approachShop(aY, aV.MaxActivationDistance)
        return false, a6 and "shop-approached" or a7
      end
      if not aO() then
        return false, "shop-unsafe"
      end
      if aU.click then
        return pcall(fireclickdetector, aU.click)
      end
      return pcall(fireproximityprompt, aU.prompt)
    end})
    function aC.stepShop()
      if as.nav then
        aC.shop.step()
      end
    end
    function aC.destroy()
      if aF then
        aF:Disconnect()
      end
    end
    return aC
  end
end)()

local as = (function()
  return function(as)
    local at = (function()
      return function(at)
        local au = at.clock or os.clock
        local av = at.wallClock or tick
        local aw = {}
        local ax = {}
        local ay = false
        local az = {stats = {casts = 0, tracked = 0, errors = 0}}
        local aA = {GoobMonster = "Arm grab", ScrapsMonster = "Tail grab", GigiMonster = "Item grab",
          SproutMonster = "Tendrils", AstroMonster = "Tiredness", VeeMonster = "Pop-ups", TeaganMonster = "Tape steal",
          BassieMonster = "Vines"}
        local function aB(aC, aD, aE)
          if not aC then
            return
          end
          aE[#aE + 1] = aC:Connect(function(...)
            if ay then
              return
            end
            local aF, aG = pcall(aD, ...)
            if not aF then
              az.stats.errors += 1
              az.stats.lastError = tostring(aG)
            end
          end)
        end
        local function aC(aD, aE)
          local aF = at.duration and at.duration(aD, aE) or aE.AbilityCooldown
          return type(aF) == "number" and aF == aF and aF > 0 and math.min(aF, 600) or nil
        end
        local function aD(aE)
          if ay or not aE or not aE.Parent then
            return nil
          end
          local aF = aw[aE]
          if aF then
            return aF
          end
          local aG = at.config(aE)
          if not aG or not (aG.ChaseAbility or aG.AttackAbility) then
            return nil
          end
          local aI = aC(aE, aG)
          if not aI then
            return nil
          end
          aF = {model = aE, config = aG, duration = aI, name = aA[aE.Name] or "Ability", connections = {},
            bound = {}}
          aw[aE] = aF
          az.stats.tracked += 1
          return aF
        end
        function az.observe(aE, aF)
          local aG = aD(aE)
          if not aG then
            return false
          end
          local aI = au()
          if aG.untilAt and aI < aG.untilAt - 0.2 then
            return false
          end
          aG.duration = aC(aE, aG.config) or aG.duration
          aG.untilAt = aI + aG.duration
          aG.castAt = aI
          aG.source = aF or "observed cast"
          az.stats.casts += 1
          return true
        end
        function az.animation(aE, aF)
          local aG = aD(aE)
          if not aG or type(aF) ~= "string" then
            return
          end
          local aI = aF:lower():gsub("[^%a]", "")
          if aI == "windup" or aI == "grab" or aI == "ability" or aI == "cast" or aI == "bassieabilitystart" or aI == "attack" and aG.config.AttackAbility then
            az.observe(aE, "native animation: " .. aF)
          end
        end
        local function aE(aF, aG)
          if aF.bound[aG] then
            return
          end
          aF.bound[aG] = true
          if aG.Name == "Grabbing" and aG:IsA("BoolValue") then
            aB(aG.Changed, function(aI)
              if aI == true then
                az.observe(aF.model, "native Grabbing")
              end
            end, aF.connections)
          elseif aG:IsA("Sound") and ((aF.model.Name == "AstroMonster" or aF.model.Name == "VeeMonster") and aG.Name == "Bark" or aF.model.Name == "SproutMonster" and aG.Name == "Create") then
            aB(aG.Played, function()
              az.observe(aF.model, "native ability sound")
            end, aF.connections)
          elseif aG:IsA("Animator") then
            aB(aG.AnimationPlayed, function(aI)
              local aJ = aI.Animation
              if aJ then
                az.animation(aF.model, aJ.Name)
              end
            end, aF.connections)
          end
        end
        function az.watch(aF)
          local aG = aD(aF)
          if not aG or aG.watching then
            return aG
          end
          aG.watching = true
          for aI, aJ in ipairs(aF:GetDescendants()) do
            aE(aG, aJ)
          end
          aB(aF.DescendantAdded, function(aI)
            aE(aG, aI)
          end, aG.connections)
          aB(aF.AttributeChanged, function(aI)
            if aI == "LastAnimationState" then
              az.animation(aF, aF:GetAttribute(aI))
            elseif aI == "_MonsterAbilityFrozen" and aF.Name == "BassieMonster" and aF:GetAttribute(aI) == true then
              az.observe(aF, "native Bassie cast")
            end
          end, aG.connections)
          return aG
        end
        function az.snapshot(aF)
          local aG = az.watch(aF)
          if not aG then
            return nil
          end
          local aI = aF:FindFirstChild("Grabbing")
          local aJ = aI and aI:IsA("BoolValue") and aI.Value == true or aF.Name == "BassieMonster" and aF:GetAttribute("_MonsterAbilityFrozen") == true
          if aJ and not aG.wasActive then
            az.observe(aF, "replicated active ability")
          end
          aG.wasActive = aJ == true
          local aL = aG.untilAt and math.max(0, aG.untilAt - au()) or nil
          local aN = true
          if aF.Name == "BassieMonster" then
            local aO = aF:GetAttribute("_BassieLastSpotted")
            if type(aO) == "number" and aO > 0 and aO <= av() + 2 then
              aL = math.max(0, aO + aG.duration - av())
              aN = false
            end
          end
          return {name = aG.name, remaining = aL, duration = aG.duration, active = aJ == true, estimated = aN,
            source = aG.source}
        end
        function az.describe(aF)
          local aG = az.snapshot(aF)
          if not aG then
            return nil
          end
          if aG.remaining == nil then
            return aG.name .. " · cooldown unknown", aG
          end
          local aI = aG.estimated and "~" or ""
          local aJ = aG.remaining > 0 and aI .. string.format("%.1fs", aG.remaining) or aG.active and "cooldown pending" or aI .. "ready"
          return aG.name .. (aG.active and " · ACTIVE · " or " · ") .. aJ, aG
        end
        function az.remove(aF)
          local aG = aw[aF]
          if not aG then
            return
          end
          for aI, aJ in ipairs(aG.connections) do
            aJ:Disconnect()
          end
          aw[aF] = nil
          az.stats.tracked -= 1
        end
        function az.prune()
          local aF = {}
          for aG in pairs(aw) do
            if not aG.Parent or at.current and not at.current(aG) then
              aF[#aF + 1] = aG
            end
          end
          for aG, aI in ipairs(aF) do
            az.remove(aI)
          end
        end
        local aF = at.events
        if aF then
          local aG = aF:FindFirstChild("AnimateTower")
          aB(aG and aG.OnClientEvent, function(aI, aJ)
            if typeof(aI) == "Instance" then
              az.animation(aI, aJ)
            end
          end, ax)
          local aI = aF:FindFirstChild("RenderObject")
          aB(aI and aI.OnClientEvent, function(aJ, aL)
            if typeof(aJ) ~= "Instance" or type(aL) ~= "table" then
              return
            end
            if aJ.Name == "GoobGrab" or aJ.Name == "ScrapsGrab" or aJ.Name == "GigiGrab" then
              local aN = aL[1]
              if typeof(aN) == "Instance" then
                az.observe(aN, "native grab render")
              end
            end
          end, ax)
        end
        function az.destroy()
          if ay then
            return
          end
          ay = true
          for aG, aI in ipairs(ax) do
            aI:Disconnect()
          end
          local aG = {}
          for aI in pairs(aw) do
            aG[#aG + 1] = aI
          end
          for aI, aJ in ipairs(aG) do
            az.remove(aJ)
          end
        end
        return az
      end
    end)()
    local au = game:GetService("Players")
    local av = game:GetService("RunService")
    local aw = game:GetService("Workspace")
    local ax = game:GetService("ReplicatedStorage")
    local ay = Instance.new("Folder")
    ay.Name = "GograAutofarmESP"
    ay.Parent = aw
    local az = {}
    local aA = 0
    local aB = false
    local aC = {stats = {targets = 0, errors = 0, highlights = 0, rarities = {}}}
    local aD = {players = Color3.fromRGB(80, 210, 255), monsters = Color3.fromRGB(255, 90, 95), machines = Color3.fromRGB(105, 180, 255),
      items = Color3.fromRGB(120, 255, 145), elevator = Color3.fromRGB(255, 235, 110), shop = Color3.fromRGB(255, 175, 85),
      hazards = Color3.fromRGB(255, 95, 225)}
    local aE = {players = "espPlayers", monsters = "espMonsters", machines = "espMachines", items = "espItems",
      elevator = "espElevator", shop = "espShop", hazards = "espHazards"}
    local aF = {Common = Color3.fromRGB(225, 230, 235), Uncommon = Color3.fromRGB(85, 225, 125), Rare = Color3.fromRGB(85, 160, 255),
      Main = Color3.fromRGB(195, 110, 255), LETHAL = Color3.fromRGB(255, 55, 65), Unknown = aD.monsters}
    local aG = {common = "Common", uncommon = "Uncommon", rare = "Rare", main = "Main", maincharacter = "Main",
      lethal = "LETHAL"}
    local aI = {}
    function aC.config(aJ)
      local aL = ax:FindFirstChild("MonsterData")
      local aN = aL and aL:FindFirstChild(aJ.Name)
      local aO = aN and aI[aN]
      if not aO and aN and aN:IsA("ModuleScript") then
        local aU, aV = pcall(require, aN)
        if aU and type(aV) == "table" then
          aO = aV
          aI[aN] = aV
        end
      end
      return aO
    end
    function aC.rarity(aJ)
      local aL = aC.config(aJ)
      local aN = aJ:GetAttribute("Rarity") or aL and aL.Rarity
      local aO = aG[tostring(aN or ""):lower():gsub("[^%a]", "")] or "Unknown"
      if aJ:GetAttribute("Lethal") == true or aL and aL.Lethal == true then
        aO = "LETHAL"
      end
      return aO, aF[aO]
    end
    local aJ
    aC.cooldowns = at({config = aC.config, events = ax:FindFirstChild("Events"), current = function(aL)
      local aN = as.room()
      return aN ~= nil and aL:IsDescendantOf(aN)
    end, duration = function(aL, aN)
      if aL.Name == "BassieMonster" then
        if not aJ then
          local aO = ax:FindFirstChild("Modules")
          local aU = aO and aO:FindFirstChild("Data")
          local aV = aU and aU:FindFirstChild("BassieAbilityConfig")
          if aV then
            local aY, a3 = pcall(require, aV)
            if aY and type(a3) == "table" then
              aJ = a3
            end
          end
        end
        return aJ and aJ.COOLDOWN or aN.SpottedAbilityCooldown or aN.AbilityCooldown
      end
      return aN.AbilityCooldown
    end})
    local function aL(aN)
      if aN:IsA("BasePart") then
        return aN
      end
      return aN:IsA("Model") and aN.PrimaryPart or aN:FindFirstChild("HumanoidRootPart") or aN:FindFirstChild("Base") or aN:FindFirstChildWhichIsA("BasePart", true)
    end
    local function aN(aO)
      local aU = az[aO]
      if not aU then
        return
      end
      if aU.highlight then
        aU.highlight:Destroy()
      end
      if aU.cooldownBillboard then
        aU.cooldownBillboard:Destroy()
      end
      aU.billboard:Destroy()
      az[aO] = nil
    end
    local function aO()
      local aU = {}
      for aV in pairs(az) do
        aU[#aU + 1] = aV
      end
      for aV, aY in ipairs(aU) do
        aN(aY)
      end
      aC.stats.targets = 0
      aC.stats.highlights = 0
      aC.stats.rarities = {}
    end
    function aC.update()
      if aB then
        return
      end
      aC.cooldowns.prune()
      if as.state.destroyed or not as.state.options.espEnabled then
        aO()
        return
      end
      local aU = as.state.options
      local aV = {}
      local aY = {}
      local function a3(a4, a6, a7, a8, a9)
        if a4 and a4.Parent and aU[aE[a6]] ~= false then
          local ba = aL(a4)
          if ba and ba:IsA("BasePart") then
            aV[a4] = {kind = a6, name = a7, color = a8 or aD[a6], part = ba, rarity = a9}
          end
        end
      end
      local a4 = as.room()
      if a4 then
        for a6, a7 in ipairs({"monsters", "machines", "items"}) do
          local a8 = a7 == "monsters" and {"Monsters"} or a7 == "machines" and {"Generators"} or {"Items",
            "HolidayPickups"}
          for a9, ba in ipairs(a8) do
            local bb = a4:FindFirstChild(ba)
            if bb then
              for bc, bd in ipairs(bb:GetChildren()) do
                local be = bd.Name:gsub("Monster$", "")
                local bh, bi
                if a7 == "monsters" then
                  if as.state.progress then
                    be = as.state.progress.describe(bd, as.character(), au.LocalPlayer, aU)
                  end
                  bi, bh = aC.rarity(bd)
                  local bj = be:find("\n", 1, true)
                  be = bj and be:sub(1, bj - 1) .. " [" .. bi .. "]" .. be:sub(bj) or be .. " [" .. bi .. "]"
                end
                if a7 == "machines" then
                  local bj = bd:FindFirstChild("Stats")
                  local bk = bj and bj:FindFirstChild("Completed")
                  local bl = bj and bj:FindFirstChild("CurrentAmount")
                  local bm = bj and bj:FindFirstChild("RequiredAmount")
                  if bk and bk.Value then
                    be = "Machine · done"
                    bh = Color3.fromRGB(120, 240, 140)
                  elseif bl and bm then
                    be = "Machine · " .. math.floor(bl.Value / math.max(1, bm.Value) * 100) .. "%"
                  else
                    be = "Machine"
                  end
                end
                a3(bd, a7, be, bh, bi)
              end
            end
          end
        end
      end
      if aU.espPlayers then
        for a6, a7 in ipairs(au:GetPlayers()) do
          if a7 ~= au.LocalPlayer then
            a3(a7.Character, "players", a7.DisplayName)
          end
        end
      end
      local a6 = aw:FindFirstChild("Elevators")
      local a7 = a6 and a6:FindFirstChild("Elevator")
      if a7 then
        a3(a7:FindFirstChild("Base") or a7, "elevator", "Elevator")
        local a8 = a7:FindFirstChild("DandyStore")
        if a8 and aU.espShop then
          for a9, ba in ipairs(a8:GetDescendants()) do
            if ba:IsA("ProximityPrompt") then
              local bb = ba.Parent
              if bb and bb:IsA("Attachment") then
                bb = bb.Parent
              end
              a3(bb, "shop", ba.ObjectText ~= "" and ba.ObjectText or "Dandy shop")
            end
          end
        end
      end
      local a8 = as.state.hazards
      if aU.espHazards and a8 and a8.targets then
        for a9, ba in ipairs(a8.targets()) do
          a3(ba.object, "hazards", ba.kind)
        end
      end
      local a9, ba, bb = as.character()
      local bc, bd = 0, 0
      for be, bh in pairs(aV) do
        bc += 1
        local bi = az[be]
        if not bi then
          local bj = Instance.new("BillboardGui")
          bj.Name = "Label"
          bj.AlwaysOnTop = true
          bj.Size = UDim2.fromOffset(210, 23)
          bj.StudsOffset = Vector3.new(0, 3, 0)
          bj.Parent = ay
          local bk = Instance.new("TextLabel")
          bk.Size = UDim2.fromScale(1, 1)
          bk.BackgroundColor3 = Color3.new(0, 0, 0)
          bk.BackgroundTransparency = 1
          bk.BorderSizePixel = 0
          bk.Font = Enum.Font.GothamSemibold
          bk.TextSize = 13
          bk.TextStrokeTransparency = 0.5
          bk.Parent = bj
          bi = {billboard = bj, label = bk}
          az[be] = bi
        end
        local bj = aU.espCharacterOutlines ~= false and (bh.kind == "monsters" or bh.kind == "players")
        if bj then
          if not bi.highlight then
            local bk = Instance.new("Highlight")
            bk.Name = "CharacterOutline"
            bk.Adornee = be
            bk.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            bk.FillTransparency = 1
            bk.OutlineTransparency = 0
            bk.Parent = ay
            bi.highlight = bk
          end
          bi.highlight.OutlineColor = bh.color
          bi.highlight.Enabled = not bb or (bb.Position - bh.part.Position).Magnitude <= (aU.espDistance or 800)
          bd += 1
        elseif bi.highlight then
          bi.highlight:Destroy()
          bi.highlight = nil
        end
        if bh.rarity then
          aY[bh.rarity] = (aY[bh.rarity] or 0) + 1
        end
        bi.billboard.Adornee = bh.part
        bi.billboard.Size = bh.kind == "monsters" and UDim2.fromOffset(320, 68) or UDim2.fromOffset(210, 23)
        bi.label.TextWrapped = bh.kind == "monsters"
        bi.billboard.MaxDistance = aU.espDistance or 800
        bi.label.TextColor3 = bh.color
        local bk = bh.name
        if bb then
          local bl = " · " .. math.floor((bb.Position - bh.part.Position).Magnitude) .. " studs"
          local bm = bk:find("\n", 1, true)
          bk = bm and bk:sub(1, bm - 1) .. bl .. bk:sub(bm) or bk .. bl
        end
        bi.label.Text = bk
        local bl = bh.kind == "monsters" and aU.espAbilityCooldowns ~= false and aC.cooldowns.describe(be)
        if bl then
          if not bi.cooldownBillboard then
            local bm = Instance.new("BillboardGui")
            bm.Name = "AbilityCooldown"
            bm.AlwaysOnTop = true
            bm.Size = UDim2.fromOffset(280, 26)
            bm.StudsOffsetWorldSpace = Vector3.new(0, 2, 0)
            bm.Parent = ay
            local bn = Instance.new("TextLabel")
            bn.Name = "Countdown"
            bn.Size = UDim2.fromScale(1, 1)
            bn.BackgroundTransparency = 1
            bn.BorderSizePixel = 0
            bn.Font = Enum.Font.GothamBold
            bn.TextSize = 14
            bn.TextStrokeTransparency = 0.25
            bn.Parent = bm
            bi.cooldownBillboard = bm
            bi.cooldownLabel = bn
          end
          local bm = be:FindFirstChild("Head")
          local bn = be:FindFirstChild("HeadPart")
          if not (bm and bm:IsA("BasePart")) and bn and bn:IsA("ObjectValue") then
            bm = bn.Value
          end
          bi.cooldownBillboard.Adornee = bm and bm:IsA("BasePart") and bm or bh.part
          bi.cooldownBillboard.MaxDistance = aU.espDistance or 800
          bi.cooldownLabel.Text = bl
          bi.cooldownLabel.TextColor3 = bh.color
          bi.billboard.StudsOffset = Vector3.new(0, 0.8, 0)
        else
          if bi.cooldownBillboard then
            bi.cooldownBillboard:Destroy()
            bi.cooldownBillboard = nil
            bi.cooldownLabel = nil
          end
          bi.billboard.StudsOffset = Vector3.new(0, 3, 0)
        end
      end
      local be = {}
      for bh in pairs(az) do
        if not aV[bh] then
          be[#be + 1] = bh
        end
      end
      for bh, bi in ipairs(be) do
        aN(bi)
      end
      aC.stats.targets = bc
      aC.stats.highlights = bd
      aC.stats.rarities = aY
    end
    local aU = av.Heartbeat:Connect(function()
      if os.clock() < aA then
        return
      end
      aA = os.clock() + 0.1
      local aU, aV = pcall(aC.update)
      if not aU then
        aC.stats.errors += 1
        aC.stats.lastError = tostring(aV)
      end
    end)
    function aC.destroy()
      if aB then
        return
      end
      aB = true
      aU:Disconnect()
      aC.cooldowns.destroy()
      aO()
      ay:Destroy()
    end
    return aC
  end
end)()

local at = (function()
  return function(at)
    local au = {target = nil, floor = nil, retry = {}, routeRetry = {}, failures = {}, recovery = {},
      phase = "items", machineCommitted = false, stats = {machines = 0, starts = 0, interruptions = 0,
      stalls = 0, itemAttempts = 0, replans = 0}}
    local av, aw, ax, ay = 0, nil, nil, -math.huge
    local function az(aA)
      au.target = aA
      at.setTarget(aA)
      if aA then
        au.machineCommitted = true
      end
      av, aw, ax = at.clock(), nil, nil
    end
    local function aA(aB)
      at.status(aB)
    end
    local function aB()
      at.stop()
    end
    local function aC(aD)
      aD = type(aD) == "table" and aD.reason or aD
      return aD == "route-needs-cover" or aD == "twisted-on-direct-route" or aD == "twisted-route-changed" or aD == "no-route-around-twisteds" or aD == "hold-local-cover-route-too-long" or aD == "generator-area-unsafe" or aD == "twisted-too-close" or aD == "twisted-machine-contact"
    end
    local function aD(aE, aF)
      if not at.waitForRoute or not aC(aF) then
        return false
      end
      au.retry[aE.object] = at.clock() + 0.25
      au.routeRetry[aE.object] = "enemy"
      au.stats.routeCoverWaits = (au.stats.routeCoverWaits or 0) + 1
      at.waitForRoute(aE, aF)
      return true
    end
    local function aE(aF)
      return at.enabled() and at.alive() and at.floor() == aF
    end
    local function aF(aG, aI, aJ)
      if not at.replan then
        return false
      end
      local aL = au.recovery[aG.object] or {count = 0, at = -math.huge}
      au.recovery[aG.object] = aL
      aL.count += 1
      if aL.count < (aJ or 1) or at.clock() - aL.at < 0.7 then
        return false
      end
      aL.at = at.clock()
      if at.replan(aG, aI) then
        aL.count = 0
        au.stats.replans += 1
        au.retry[aG.object] = nil
        au.routeRetry[aG.object] = nil
        return true
      end
      return false
    end
    local function aG(aI)
      au.stats.interruptions += 1
      if au.target then
        au.retry[au.target.object] = nil
        au.routeRetry[au.target.object] = nil
        au.failures[au.target.object] = nil
        au.recovery[au.target.object] = nil
      end
      at.release(aI)
      aB()
      at.evade(aI)
    end
    function au.reset()
      aB()
      az(nil)
      au.floor = nil
      au.retry = {}
      au.routeRetry = {}
      au.failures = {}
      au.recovery = {}
      au.phase = "items"
      au.machineCommitted = false
      au.itemStartedAt = nil
      au.itemAttempts = 0
    end
    function au.restore(aI, aJ, aL, aN)
      if aI ~= at.floor() then
        return false
      end
      au.floor = aI
      at.floorChanged(aI)
      au.phase = aL == "machines" and "machines" or "items"
      au.machineCommitted = aN == true
      if aJ and at.valid(aJ) and not at.complete(aJ) then
        az(aJ)
        au.phase = "machines"
      end
      return true
    end
    function au.clearTarget()
      az(nil)
    end
    function au.selectTarget(aI)
      az(aI)
      au.stats.campSwitches = (au.stats.campSwitches or 0) + 1
    end
    function au.step()
      if not at.enabled() then
        return
      end
      if not at.alive() then
        aB()
        aA("Waiting for a living character")
        return
      end
      local aI = at.floor()
      if aI ~= au.floor then
        aB()
        az(nil)
        au.floor = aI
        au.retry = {}
        au.routeRetry = {}
        au.failures = {}
        au.recovery = {}
        au.phase = "items"
        au.machineCommitted = false
        au.itemStartedAt = nil
        au.itemAttempts = 0
        au.unsafeSince = nil
        at.floorChanged(aI)
      end
      if not aI or not at.ready(aI) then
        aB()
        aA("Waiting for the floor to load")
        return
      end
      if at.exitRequired() then
        if au.target and ax == au.target and at.valid(au.target) and at.complete(au.target) then
          au.stats.machines += 1
        end
        aB()
        az(nil)
        at.activity("elevator")
        if at.afterMachines and at.machinesFinished() and at.afterMachines(aI) then
          return
        end
        if at.inElevator() then
          aA("In elevator · waiting for next floor")
        else
          at.returnElevator()
        end
        return
      end
      if at.safetyBusy and at.safetyBusy() then
        return
      end
      if at.covered() then
        at.resumeCover()
        return
      end
      local aJ, aL = at.danger()
      if aJ then
        aG(aL)
        return
      end
      local aN = au.target
      local aO = at.current()
      if aO and (not aN or aN.object ~= aO) then
        for aU, aV in ipairs(at.targets(aI)) do
          if aV.object == aO and at.valid(aV) and not at.complete(aV) then
            az(aV)
            aN = aV
            au.phase = "machines"
            au.stats.nativeTargetRestores = (au.stats.nativeTargetRestores or 0) + 1
            break
          end
        end
      end
      if aN and not at.valid(aN) then
        az(nil)
        aN = nil
      end
      if aN and at.complete(aN) then
        if ax == aN then
          au.stats.machines += 1
        end
        aB()
        az(nil)
        aN = nil
        au.machineCommitted = false
        if at.pendingItems and at.pendingItems() then
          au.phase = "items"
          au.itemStartedAt = at.clock()
          au.itemAttempts = 0
        end
      end
      if at.collectCapsules and not at.current() and at.collectCapsules(aI) then
        return
      end
      if not aN and not au.machineCommitted and au.phase == "machines" and at.pendingItems and at.pendingItems() then
        au.phase = "items"
        au.itemStartedAt = at.clock()
        au.itemAttempts = 0
      end
      if not aN and au.phase == "items" then
        au.itemStartedAt = au.itemStartedAt or at.clock()
        at.activity("pickup")
        local aU = at.itemBudget and at.itemBudget() or 30
        local aV = at.itemAttemptsCap or 16
        local aY = at.pickupCommitted and at.pickupCommitted()
        if at.collectNearby and (aY or (aU == 0 or at.clock() - au.itemStartedAt < aU) and (aV == 0 or (au.itemAttempts or 0) < aV)) then
          local a3 = at.collectNearby(aI)
          if a3 then
            au.itemAttempts = (au.itemAttempts or 0) + 1
            au.stats.itemAttempts += 1
            return
          end
          if at.pickupCommitted and at.pickupCommitted() then
            aA("Keeping selected item · waiting for pickup recovery")
            return
          end
        end
        au.phase = "machines"
        at.activity("machine-travel")
      end
      if not aN then
        local aU, aV
        local aY = {}
        for a3, a4 in ipairs(at.targets(aI)) do
          if at.valid(a4) and not at.complete(a4) and at.usable(a4) and at.clock() >= (au.retry[a4.object] or 0) then
            local a6 = at.distance(a4)
            local a7, a8 = at.safe(a4)
            if a7 then
              if not aV or a6 < aV then
                aU, aV = a4, a6
              end
            else
              aY[#aY + 1] = {target = a4, reason = a8, score = a6, last = au.recovery[a4.object] and au.recovery[a4.object].at or -math.huge}
            end
          end
        end
        if not aU then
          table.sort(aY, function(a3, a4)
            return a3.last == a4.last and a3.score < a4.score or a3.last < a4.last
          end)
          for a3 = 1, math.min(2, #aY) do
            local a4 = aY[a3].target
            if aF(a4, "no-safe-machine-stand") and at.safe(a4) then
              aU = a4
              break
            end
          end
        end
        if not aU and at.waitForRoute and aY[1] and aC(aY[1].reason) then
          az(aY[1].target)
          aD(au.target, aY[1].reason)
          return
        end
        if aU then
          az(aU)
          aN = aU
        end
      end
      if not aN then
        aB()
        aA("Waiting for a safe, available machine")
        if not at.detectionOnly and at.clock() - ay > 2 then
          ay = at.clock()
          at.hideWait()
        end
        return
      end
      if not at.usable(aN) then
        aB()
        aA("Selected machine is occupied · waiting in cover")
        if not at.detectionOnly and at.clock() - ay > 2 then
          ay = at.clock()
          at.hideWait()
        end
        au.busySince = au.busySince or at.clock()
        if at.clock() - au.busySince > 3 then
          au.retry[aN.object] = at.clock() + 3
          az(nil)
          au.busySince = nil
        end
        return
      end
      au.busySince = nil
      local aU, aV = at.safe(aN)
      if not aU then
        if aV == "ichor-puddle" then
          aB()
          au.retry[aN.object] = at.clock() + 2
          az(nil)
          aA("No dry machine position · checking another approach")
          return
        end
        if at.camped and at.camped(aN) then
          aB()
          au.retry[aN.object] = at.clock() + 5
          az(nil)
          aA("Generator camped · selecting another machine")
          return
        end
        if at.detectionOnly then
          if aD(aN, aV) then
            return
          end
          if aF(aN, aV) then
            aA("Using a different approach to the same generator")
            return
          end
          aB()
          aA("Generator approach blocked · replanning around the obstacle")
          return
        end
        aB()
        aA(at.keepTargetInCover and "Selected generator blocked · staying in nearby cover" or "Selected machine unsafe · checking another machine")
        au.unsafeSince = au.unsafeSince or at.clock()
        if not at.keepTargetInCover and at.clock() - au.unsafeSince >= 2 then
          au.retry[aN.object] = at.clock() + 2
          az(nil)
          au.unsafeSince = nil
        end
        at.hideWait()
        return
      end
      au.unsafeSince = nil
      if at.current() ~= aN.object and at.clock() < (au.retry[aN.object] or 0) then
        if au.routeRetry[aN.object] then
          aA(au.routeRetry[aN.object] == "enemy" and "Going around Twisteds · replanning route" or "Going around an ichor puddle · replanning route")
        elseif at.keepTargetInCover and not at.detectionOnly then
          aB()
          aA("Machine retry · taking nearby cover before retrying")
          at.hideWait()
        else
          aA("Retrying selected machine shortly")
        end
        return
      end
      if at.current() == aN.object then
        au.retry[aN.object] = nil
        au.routeRetry[aN.object] = nil
        au.failures[aN.object] = nil
        au.recovery[aN.object] = nil
        at.activity("machine")
        local aY, a3 = at.progress(aN)
        if ax ~= aN then
          ax = aN
          av = at.clock()
          aw = aY
        end
        if aw == nil or aY > aw then
          av = at.clock()
        end
        aw = aY
        if at.clock() - av > 10 then
          au.stats.stalls += 1
          aB()
          au.retry[aN.object] = at.clock() + 3
          az(nil)
          aA("No machine progress · releasing and selecting another machine")
          return
        end
        at.work(aN)
        aA(string.format("Working %s · %d%%", aN.name, math.floor(math.clamp(aY / math.max(1, a3), 0, 1) * 100)))
        return
      end
      at.activity("machine-travel")
      local aY, a3 = at.begin(aN)
      if not aE(aI) or not at.valid(aN) or at.complete(aN) then
        return
      end
      if at.safetyBusy and at.safetyBusy() then
        return
      end
      if aY and at.current() == aN.object then
        au.stats.starts += 1
        au.failures[aN.object] = nil
        ax = aN
        av = at.clock()
        aw = at.progress(aN)
      else
        local a4, a6 = at.danger()
        local a7 = type(a3) == "table" and a3.reason or a3
        local a8 = a7 == "health-loss" or a7 == "twisted-detected" or a7 == "twisted-chasing" or a7 == "twisted-machine-contact" or a7 == "sprout-detected" or a7 == "twisted-imminent-contact"
        local ba = type(a7) == "string" and (a7 == "health-loss" or a7 == "danger" or a7 == "generator-area-unsafe" or a7 == "hold-local-cover-route-too-long" or a7 == "no-route-around-twisteds" or a7 == "attack-on-machine-route" or a7:sub(1, 7) == "twisted")
        if a4 or at.keepTargetInCover and (at.detectionOnly and a8 or not at.detectionOnly and ba) then
          aA("Machine interrupted · entering nearby cover")
          aG(a4 and a6 or a3)
          return
        end
        if aD(aN, a7) then
          return
        end
        if a7 == "server-correction" or a7 == "arrival not confirmed" or a7 == "movement-busy" or a7 == "machine-release-pending" or a7 == "extraction-release-pending" or a7 == "root-anchored" or a7 == "tween-cancelled" or a7 == "cover-resumed" then
          if aF(aN, a7, 3) then
            aA("Arrival kept failing · using another generator approach")
            return
          end
          au.retry[aN.object] = at.clock() + 0.2
          aA("Position corrected · retrying the same generator")
          return
        end
        if a7 == "noclip-not-ready" or a7 == "corrected-route-cooldown" then
          au.retry[aN.object] = at.clock() + 0.3
          aA("Collision recovery · keeping the same generator")
          return
        end
        if a7 == "ichor-puddle" or at.detectionOnly and ba then
          if aF(aN, a7, 3) then
            aA("Using another route to the selected generator")
            return
          end
          au.retry[aN.object] = at.clock() + 0.1
          au.routeRetry[aN.object] = a7 == "ichor-puddle" and "puddle" or "enemy"
          aA(a7 == "ichor-puddle" and "Going around an ichor puddle · replanning route" or "Going around Twisteds · replanning route")
          return
        end
        au.routeRetry[aN.object] = nil
        aB()
        au.retry[aN.object] = at.clock() + 0.5
        au.failures[aN.object] = (au.failures[aN.object] or 0) + 1
        if au.failures[aN.object] >= 2 then
          au.retry[aN.object] = at.clock() + 3
          az(nil)
        end
        aA("Machine retry · " .. tostring(a3 or "interaction unconfirmed"))
      end
    end
    return au
  end
end)()

local au = (function()
  return function(au)
    local av = {history = {}, queue = au.outbox or {}, stats = {sent = 0, failed = 0, suppressed = 0,
      queued = 0, last = "Ready"}}
    local aw, ax = false, false
    local ay = au.cooldowns or {}
    local az, aA = {}, {}
    local aB, aC = au.clock, au.epoch
    local function aD(aE, aF)
      local aG = tostring(aE or ""):gsub("https?://[^%s\"'<>]+", "[url]")
      if au.redact then
        aG = au.redact(aG)
      end
      aG = aG:gsub("```", "'''"):gsub("@everyone", "[everyone]"):gsub("@here", "[here]")
      local aI = aF or 900
      while #aG > aI and aI > 0 and (string.byte(aG, aI + 1) or 0) >= 128 and (string.byte(aG, aI + 1) or 0) < 192 do
        aI -= 1
      end
      return aG:sub(1, aI)
    end
    local function aE(aF, aG, aI)
      local aJ = type(aF)
      if aJ == "string" then
        return aD(aF, 700)
      end
      if aJ == "boolean" then
        return aF
      end
      if aJ == "number" then
        return aF == aF and math.abs(aF) < math.huge and aF or nil
      end
      if aJ ~= "table" or aG > 5 or aI[aF] then
        return nil
      end
      aI[aF] = true
      local aL = {}
      local aN = 0
      for aO, aU in pairs(aF) do
        if type(aO) == "string" or type(aO) == "number" then
          local aV = aE(aU, aG + 1, aI)
          if aV ~= nil then
            aL[aO] = aV
            aN += 1
            if aN >= 45 then
              break
            end
          end
        end
      end
      aI[aF] = nil
      return aL
    end
    local function aF()
      local aG, aI = pcall(au.snapshot)
      return aG and aE(aI, 0, {}) or {snapshotError = "Snapshot unavailable"}
    end
    local function aG(aI, aJ)
      local aL, aN = pcall(au.encode, aI)
      return aL and aD(aN, aJ) or "{}"
    end
    local function aI()
      av.stats.queued = #av.queue
      if au.persist then
        pcall(au.persist, av.queue, ay)
      end
    end
    function av.record(aJ, aL, aN)
      av.history[#av.history + 1] = {at = math.floor(aB() * 10) / 10, kind = aD(aJ, 50), detail = aD(aL, 180),
        run = aN or aF()}
      if #av.history > 40 then
        table.remove(av.history, 1)
      end
    end
    local function aJ(aL, aN, aO, aU)
      local aV = {}
      if aU then
        aV[#aV + 1] = {name = "Discord username", value = aU}
      end
      if aL ~= "suggestion" then
        local aY = {version = aO.version, map = aO.map, floor = aO.floor, health = aO.health, activity = aO.activity,
          status = aO.status, position = aO.position, target = aO.target, pickup = aO.pickup, blocked = aO.blocked,
          reason = aO.reason, speed = aO.speed, requestedSpeed = aO.requestedSpeed, corrections = aO.corrections}
        aV[#aV + 1] = {name = "Run and movement state", value = "```json\n" .. aG(aY, 980) .. "\n```"}
        aV[#aV + 1] = {name = "Collision, release and route", value = "```json\n" .. aG({collision = aO.collision,
          release = aO.release, cover = aO.cover, route = aO.route}, 980) .. "\n```"}
        local a3 = {}
        for a4 = math.max(1, #av.history - 9), #av.history do
          local a6 = av.history[a4]
          local a7 = a6.run or {}
          a3[#a3 + 1] = {at = a6.at, event = a6.kind, detail = a6.detail, status = a7.status, position = a7.position,
            activity = a7.activity, target = a7.target, pickup = a7.pickup, blocked = a7.blocked, reason = a7.reason}
        end
        aV[#aV + 1] = {name = "Recent movement history", value = "```json\n" .. aG(a3, 980) .. "\n```"}
        if aO.errors then
          aV[#aV + 1] = {name = "Recent script errors", value = aG(aO.errors, 980)}
        end
      end
      return {username = "Gogra reports", allowed_mentions = {parse = {}}, embeds = {{title = "Gogra · " .. aD(aL, 80),
        description = aD(aN, 1500), fields = aV, footer = {text = "Technical run diagnostics · " .. aD(aO.version or "unknown", 30)}}}}
    end
    function av.pump()
      if ax or #av.queue == 0 or av.queue[1].nextAt and aC() < av.queue[1].nextAt then
        return
      end
      ax = true
      au.spawn(function()
        while #av.queue > 0 do
          local aL = av.queue[1]
          if aL.nextAt and aC() < aL.nextAt then
            break
          end
          if not aL.at or aC() - aL.at > 900 then
            table.remove(av.queue, 1)
            aI()
            continue
          end
          local aN, aO, aU = pcall(au.send, aL.route, aL.payload)
          aO = aN and tonumber(aO) or 0
          if aO and aO >= 200 and aO < 300 then
            av.stats.sent += 1
            av.stats.last = aL.route .. " report sent"
            table.remove(av.queue, 1)
            aI()
          else
            aL.attempts = (aL.attempts or 0) + 1
            if (aO == 429 or aO == 0 or aO and aO >= 500) and aL.attempts < 4 then
              av.stats.last = "Report delayed · retrying"
              aI()
              au.wait(math.clamp(tonumber(aU) or 2 ^ aL.attempts, 1, 300))
            elseif aO == 429 or aO == 0 or aO and aO >= 500 then
              aL.attempts = 0
              aL.nextAt = aC() + 60
              av.stats.last = "Network unavailable · report saved for retry"
              aI()
              break
            else
              av.stats.failed += 1
              av.stats.last = "Report failed · HTTP " .. tostring(aO or 0)
              table.remove(av.queue, 1)
              aI()
            end
          end
          if #av.queue > 0 then
            au.wait(0.4)
          end
        end
        ax = false
      end)
    end
    local function aL(aN, aO, aU, aV, aY)
      local a3 = aF()
      av.record(aO, aU, a3)
      local a4 = {route = aN, payload = aJ(aO, aU, a3, aY), at = aC(), attempts = 0}
      if #av.queue >= 24 then
        table.remove(av.queue, #av.queue)
        av.stats.suppressed += 1
      end
      if aV then
        table.insert(av.queue, ax and math.min(2, #av.queue + 1) or 1, a4)
      else
        av.queue[#av.queue + 1] = a4
      end
      aI()
      av.pump()
      return true, "Queued"
    end
    function av.capture(aN, aO, aU)
      if aw or not au.autoEnabled() then
        return false, "disabled"
      end
      local aV = aD(aN, 60) .. ":" .. aD(aO, 160)
      local aY = aB()
      if az[aV] and aY - az[aV] < 30 then
        av.stats.suppressed += 1
        return false, "duplicate"
      end
      while aA[1] and aY - aA[1] > 60 do
        table.remove(aA, 1)
      end
      if #aA >= 6 and not aU then
        az[aV] = aY
        av.record(aN, aO)
        av.stats.suppressed += 1
        return false, "rate-limited"
      end
      az[aV] = aY
      aA[#aA + 1] = aY
      return aL("automatic", aN, aO, aU)
    end
    function av.submit(aN, aO, aU)
      if aw or aN ~= "bug" and aN ~= "suggestion" then
        return false, "Unavailable"
      end
      aU = tostring(aU or ""):match("^%s*(.-)%s*$") or ""
      aU = aU:gsub("^@", "")
      local aV = aU:match("^[%w_.]+#%d%d%d%d$") and #aU >= 7 and #aU <= 37
      if not aV then
        aU = aU:lower()
      end
      local aY = aU:match("^[a-z0-9_.]+$") and #aU >= 2 and #aU <= 32 and not aU:find("..", 1, true)
      if not aY and not aV then
        return false, "Enter your Discord username before submitting"
      end
      aO = tostring(aO or ""):match("^%s*(.-)%s*$") or ""
      if #aO < 5 then
        return false, "Write at least 5 characters"
      end
      if #aO > 1500 then
        return false, "Keep the message under 1500 characters"
      end
      local a3 = aC()
      local a4 = ay[aN] or 0
      if a3 - a4 < 60 then
        return false, "Wait " .. math.ceil(60 - (a3 - a4)) .. " seconds before sending another " .. aN
      end
      local a6 = aN .. ":" .. aD(aO, 1500)
      if az[a6] and aB() - az[a6] < 600 then
        return false, "This message was already submitted"
      end
      ay[aN] = a3
      az[a6] = aB()
      return aL(aN, aN, aO, false, aU)
    end
    function av.destroy()
      aw = true
      aI()
    end
    aI()
    av.pump()
    return av
  end
end)()

local av = (function()
  return function(av)
    local aw = {enabled = false, name = nil, state = "Off", lastError = nil, startAutofarm = true}
    local function ax(ay)
      return type(ay) == "string" and #ay > 0 and #ay <= 40 and ay:match("^[%w_-]+$") ~= nil
    end
    function aw.configure(ay, az, aA)
      assert(ax(ay), "Invalid autoload config name")
      az = az == true
      if az then
        assert(av.exists(ay), "Autoload config does not exist: " .. ay)
      end
      if aA == nil then
        aA = aw.startAutofarm
      end
      assert(type(aA) == "boolean", "Invalid autoload start setting")
      av.persist({version = 1, name = ay, enabled = az, startAutofarm = aA})
      aw.name, aw.enabled, aw.state, aw.lastError = ay, az, az and "Selected" or "Off", nil
      aw.startAutofarm = aA
      return true
    end
    function aw.restore()
      local ay, az = pcall(av.read)
      if not ay then
        aw.state = "Error"
        aw.lastError = tostring(az)
        return false, aw.lastError
      end
      if az == nil then
        if not av.exists("Default") then
          return true
        end
        ay, az = pcall(function()
          aw.configure("Default", true)
          return {version = 1, name = "Default", enabled = true, startAutofarm = aw.startAutofarm}
        end)
        if not ay then
          aw.state = "Error"
          aw.lastError = tostring(az)
          return false, aw.lastError
        end
      end
      if type(az) ~= "table" or az.version ~= 1 or not ax(az.name) or type(az.enabled) ~= "boolean" then
        aw.state = "Error"
        aw.lastError = "Invalid autoload selection"
        return false, aw.lastError
      end
      aw.name, aw.enabled = az.name, az.enabled
      if az.startAutofarm ~= nil and type(az.startAutofarm) ~= "boolean" then
        aw.state = "Error"
        aw.lastError = "Invalid autoload start setting"
        return false, aw.lastError
      end
      aw.startAutofarm = az.startAutofarm ~= false
      if not aw.enabled then
        aw.state = "Off"
        return true
      end
      if not av.exists(aw.name) then
        aw.state = "Error"
        aw.lastError = "Autoload config is missing: " .. aw.name
        return false, aw.lastError
      end
      ay, az = pcall(av.queue, aw.name)
      if not ay then
        aw.state = "Error"
        aw.lastError = tostring(az)
        return false, aw.lastError
      end
      aw.state = "waiting for game"
      return true
    end
    function aw.applied(ay)
      if aw.enabled and aw.name == ay then
        aw.state = "Loaded"
        aw.lastError = nil
      end
    end
    return aw
  end
end)()

local aw = (function()
  return {automatic = "https://discord.com/api/webhooks/1543736172461948978/BKMZlNeKHeKHhjq1-NeLquP4drNNJfkOxNemOiYsxSAhJdE8dr0BMOlb5A0CSfU5KDrz",
    bug = "https://discord.com/api/webhooks/1564996278767583414/X_iSq2EtFrb9ehVdp7Y1GP6BGkxRRvjG1JieOGqq8z9pO7CyjbIWuPq30dadmxNOo9e1",
    suggestion = "https://discord.com/api/webhooks/1564996387949514752/DPUdFL7xPHaU4r4h2l9eXb2ZgBiPEarDNpa-G5-jYlYivlyFV65uW5ynsb-1-mLda4u7"}
end)()

local ax, ay, az, aA, aB, aC

if e.GograAutofarm and e.GograAutofarm.Destroy then
  local aD = e.GograAutofarm
  if aD.sponsor and aD.sponsor.snapshot then
    local aE, aF = pcall(aD.sponsor.snapshot)
    if aE then
      aC = aF
    end
  end
  local aE = aD.cover and aD.cover.active and aD.cover.kind == "occluded-wall" and aD.nav and aD.nav.isHidden and aD.nav.isHidden() and table.clone(aD.cover)
  aA = aD.enabled == true
  if aA then
    aB = aD.pendingFocus or (aD.core and {floor = aD.core.floor, target = aD.target, phase = aD.core.phase,
      pickup = aD.pickup, machineCommitted = aD.core.machineCommitted or aD.target ~= nil})
  end
  if type(aD.options) == "table" then
    az = table.clone(aD.options)
  end
  aD.SetEnabled(false)
  if aD.centerLock then
    aD.centerLock:Disconnect()
    aD.centerLock = nil
  end
  aD.itemHold = nil
  if aD.cover and aD.cover.active and aD.noclip then
    ax, ay = aD.cover, aD.noclip
    aD.cover = {}
    aD.noclip = nil
  else
    if aE then
      ax = aE
    end
    if aD.noclip then
      aD.noclip.destroy()
      aD.noclip = nil
    end
    table.clear(aD.cover)
  end
  aD.Destroy()
end

if e.CodexFloorAuto and e.CodexFloorAuto.SetEnabled then
  pcall(e.CodexFloorAuto.SetEnabled, false)
end

local aD = {version = "4.8.57", enabled = false, destroyed = false, generation = 0, startPaused = e.GograAutofarmStartPaused == true,
  cover = ax or {}, noclip = ay, events = {}, errors = {}, status = "Loading", activity = "machine-travel",
  health = {losses = 0, pending = false}, teleportPolicy = {}, options = {automaticDiagnostics = true,
  controlMode = "autofarm", farmMode = "faster", machineMoveMethod = "tween", machineHideMode = "detected",
  tweenOnly = true, teleportOnly = false, quickEncounters = true, autoReturnLobby = true, soloRun = true,
  autoBarnaby = true, barnabyCoins = true, autoPuddleQuest = true, autoReady = true, selectedToon = "Current toon",
  tweenSpeed = 30, escapeTweenSpeed = 30, directGeneratorLevel = true, hideMode = "tween", hideTween = true,
  teleportHiding = false, noclip = true, fullBodyHiding = true, fastMachineTravel = true, clearDelay = 0.5,
  resumeDistance = 55, stuckTimeout = 2.5, stuckElevatorReset = true, afterHide = "same", coverPreference = "wall",
  itemMoveMethod = "tween", itemPickupMode = "slide", autoMachineItems = true, drainStaminaItems = true,
  autoHalloweenDoors = true, machineFromCover = true, itemSweepBudget = 0, safetyMargin = 3, lethalMargin = 25,
  coverHop = true, prioritizeSafety = true, researchMode = true, researchTeleport = false, waitForMadness = true,
  autoSkillChecks = true, extractionMode = "instant", autoEscapeSquirm = true, autoCards = true, avoidTimeCards = true,
  prioritizeTimeCards = false, hideSearchDistance = 60, machineCoverDistance = 90, wallCenterHiding = false,
  groundOnly = false, elevatorRefuge = false, returnToGenerator = true, allowEmergencyRetreat = true,
  autoLoot = true, autoCapsules = true, selectedCapsuleTwisteds = {["All Twisteds"] = true}, selectedItems = {Bandage = true,
  HealthKit = true, Pumpkin = true, Valve = true, JumperCable = true, Instructions = true, ExtractionSpeedCandy = true,
  SkillCheckCandy = true}, antiDandy = true, autoCheapestShop = true, antiAFK = true, autoShop = false,
  useConsumables = true, strictElevatorTeleport = false, reactiveHideOnly = false, closeHideDistance = 15,
  espEnabled = true, espPlayers = true, espMonsters = true, espMachines = true, espItems = true, espElevator = true,
  espShop = true, espHazards = true, espDistance = 800}}

e.GograAutofarmStartPaused = nil
aD.options.espResearch = true
aD.options.espThreatDetails = true
aD.options.researchNotifications = true
aD.options.encounterNotifications = true
aD.options.itemPickupDelay = 1
aD.options.espCharacterOutlines = true
aD.options.espAbilityCooldowns = true

if az then
  for aE, aF in pairs(aD.options) do
    local aG = az[aE]
    if type(aG) == type(aF) then
      aD.options[aE] = type(aG) == "table" and table.clone(aG) or aG
    end
  end
end

aD.options.machineMoveMethod = "tween"
aD.options.hideMode = "tween"
aD.options.tweenOnly = true

for aE in pairs(aD.options.selectedItems) do
  if aE:lower():find("capsule", 1, true) then
    aD.options.selectedItems[aE] = nil
  end
end

aD.options.escapeTweenSpeed = math.clamp(tonumber(aD.options.escapeTweenSpeed) or 30, 18, 30)
aD.options.directGeneratorLevel = false
aD.options.teleportHiding = false
aD.options.strictElevatorTeleport = false
aD.options.fullBodyHiding = true
e.GograAutofarm = aD
aD.pendingFocus = aB
aD.options.wallJukeFallback = true
aD.options.itemMoveMethod = "tween"

if aD.options.farmMode ~= "normal" and aD.options.farmMode ~= "faster" then
  aD.options.farmMode = "faster"
end

aD.coverWorkUnsupported = setmetatable({}, {__mode = "k"})
aD.antiAFK = {pulses = 0, errors = 0}

function aD.AntiAFKPulse()
  if aD.destroyed or not aD.options.antiAFK then
    return false, "disabled"
  end
  if os.clock() - (aD.antiAFK.lastAt or -math.huge) < 5 then
    return false, "cooldown"
  end
  aD.antiAFK.lastAt = os.clock()
  local aE, aF = pcall(function()
    local aE = game:GetService("VirtualUser")
    aE:CaptureController()
    aE:ClickButton2(Vector2.new(0, 0), workspace.CurrentCamera and workspace.CurrentCamera.CFrame or CFrame.new())
  end)
  if aE then
    aD.antiAFK.pulses += 1
    aD.antiAFK.lastError = nil
  else
    aD.antiAFK.errors += 1
    aD.antiAFK.lastError = tostring(aF)
  end
  return aE, aF
end

aD.events[#aD.events + 1] = k.Idled:Connect(function()
  aD.AntiAFKPulse()
end)

local function aE(aF, aG, aI)
  local aJ = aF and aF:FindFirstChild(aG)
  if aJ and aJ:IsA("ValueBase") then
    return aJ.Value
  end
  return aI
end

local function aF()
  local aG = k.Character
  return aG, aG and aG:FindFirstChildOfClass("Humanoid"), aG and aG:FindFirstChild("HumanoidRootPart")
end

local function aG()
  local aI = workspace:FindFirstChild("CurrentRoom")
  if aI then
    for aJ, aL in ipairs(aI:GetChildren()) do
      if aL:FindFirstChild("Generators") then
        return aL
      end
    end
  end
end

local function aI()
  local aJ, aL = aF()
  return aJ and aL and math.min(aL.Health, aE(aJ:FindFirstChild("Stats"), "Health", aL.Health)) or 0
end

local function aJ()
  local aL, aN, aO = aF()
  return aN ~= nil and aO ~= nil and aN.Health > 0 and aI() > 0
end

local function aL()
  return aD.enabled and not aD.destroyed
end

local function aN(aO)
  aD.status = tostring(aO)
end

aD.session = ak()

function aD.SessionSnapshot()
  local aO = workspace:FindFirstChild("Info")
  local aU = aG()
  local aV = aU and aU:FindFirstChild("Generators")
  local aY = 0
  for a3, a4 in ipairs(f:GetPlayers()) do
    if a4 ~= k then
      aY += 1
    end
  end
  return {run = game.PlaceId == 16552821455, solo = aD.options.soloRun, otherPlayers = aY, floor = aE(aO, "Floor", 0),
    mapReady = aV ~= nil and #aV:GetChildren() > 0, loading = aE(aO, "Loading", true), floorActive = aE(aO, "FloorActive", false),
    alive = aJ()}
end

function aD.ReadyForAutofarm()
  return aD.session.ready(aD.SessionSnapshot())
end

aD.lobby = aj({enabled = aL, status = function(aO)
  aD.lobbyStatus = aO
  aN("waiting for game")
end, character = aF})

aD.selection = ((function()
  return function(aO)
    local aU = aO.clock or os.clock
    local aV = aO.player or game:GetService("Players").LocalPlayer
    local aY = {stats = {selections = 0, readyRequests = 0}, nextAction = 0}
    local function a3()
      local a4 = game:GetService("ReplicatedStorage"):FindFirstChild("PlayerData")
      return a4 and (a4:FindFirstChild(tostring(aV.UserId)) or a4:FindFirstChild(aV.Name))
    end
    function aY.ownedToons()
      if aO.ownedToons then
        return aO.ownedToons()
      end
      local a4 = a3()
      local a6 = a4 and a4:FindFirstChild("Towers")
      if not a6 then
        return nil
      end
      local a7 = {}
      for a8, ba in ipairs(a6:GetChildren()) do
        if ba:IsA("StringValue") then
          a7[#a7 + 1] = ba.Name
        end
      end
      table.sort(a7)
      return a7
    end
    local function a4(a6)
      if not a6 then
        return false
      end
      while a6 do
        if a6:IsA("GuiObject") and not a6.Visible or a6:IsA("LayerCollector") and not a6.Enabled then
          return false
        end
        a6 = a6.Parent
      end
      return true
    end
    local function a6(a7, a8)
      return a7 and a7:FindFirstChild(a8)
    end
    function aY.snapshot()
      if aO.snapshot then
        return aO.snapshot()
      end
      local a7 = aV:FindFirstChildOfClass("PlayerGui")
      local a8 = a6(a7, "ScreenGui")
      local ba = a6(a8, "SelectionFrame")
      if not a4(ba) then
        return nil
      end
      local bb = a6(ba, "Margin")
      local bc = a6(bb, "CatalogFrame")
      local bd = a6(bc, "Toons")
      local be = a6(bd, "PreviewPane")
      local bh = a6(a6(be, "Title"), "ToonName")
      local bi = a6(a6(bb, "TeamFrame"), aV.Name)
      local bj = a6(bi, "ReadyText")
      local bk = a6(a6(a6(bb, "BottomFrame"), "ReadyStatus"), "ReadyUp")
      local bl = a3()
      local bm = a6(bl, "SelectedCharacter")
      local bn = aY.ownedToons()
      local bo = a6(bd, "ToonsCatalog")
      local bp = aO.options.selectedToon
      return {session = ba, selected = bm and bm.Value, owned = bn, ready = bj and bj.Visible == true or false,
        preview = bh and bh.Text, tile = bp and a6(bo, bp), equip = a6(be, "Equip"), readyButton = bk}
    end
    local function a7(a8)
      if aO.click then
        return aO.click(a8)
      end
      if not a8 or not a4(a8) then
        return false
      end
      local ba, bb = pcall(function()
        return a8.Interactable
      end)
      if ba and bb == false then
        return false
      end
      for bc, bd in ipairs({"Activated", "MouseButton1Click"}) do
        if type(firesignal) == "function" and type(getconnections) == "function" then
          local be = a8[bd]
          local bh, bi = pcall(getconnections, be)
          if bh and #bi > 0 then
            return pcall(firesignal, be)
          end
        end
      end
      return pcall(function()
        local bc = a8.AbsolutePosition + a8.AbsoluteSize * 0.5
        local bd = game:GetService("VirtualInputManager")
        bd:SendMouseButtonEvent(bc.X, bc.Y, 0, true, game, 0)
        bd:SendMouseButtonEvent(bc.X, bc.Y, 0, false, game, 0)
      end)
    end
    function aY.step()
      if not aO.enabled() then
        return false
      end
      local a8 = aY.snapshot()
      if not a8 then
        aY.session = nil
        aY.readyPending = false
        aY.nextAction = 0
        return false
      end
      if aY.session ~= a8.session then
        aY.session = a8.session
        aY.readyPending = false
        aY.nextAction = 0
      end
      if a8.ready then
        aO.status("Character selection · ready")
        return true
      end
      if aY.readyPending then
        aO.status("Character selection · Ready requested; waiting for confirmation")
        return true
      end
      local ba = aO.options.selectedToon or "Current toon"
      local bb = false
      for bc, bd in ipairs(a8.owned or {}) do
        if bd == ba then
          bb = true
        end
      end
      if ba ~= "Current toon" and not bb then
        aO.status("Character selection · selected Toon is unavailable; choose an owned Toon")
        return true
      end
      if aU() < aY.nextAction then
        return true
      end
      if ba ~= "Current toon" and a8.selected ~= ba then
        aY.nextAction = aU() + 0.75
        if a8.preview ~= ba then
          if a8.tile and a7(a8.tile) then
            aY.stats.selections += 1
          end
          aO.status("Character selection · previewing " .. ba)
        else
          if a8.equip then
            a7(a8.equip)
          end
          aO.status("Character selection · waiting for " .. ba .. " to equip")
        end
        return true
      end
      if not aO.options.autoReady then
        aO.status("Character selection · Auto Ready is off")
        return true
      end
      if not a8.selected or a8.selected == "" or not a8.owned then
        aO.status("Character selection · waiting for Toon inventory")
        return true
      end
      local bc = false
      for bd, be in ipairs(a8.owned) do
        if be == a8.selected then
          bc = true
        end
      end
      if not bc then
        aO.status("Character selection · waiting for an owned Toon to equip")
        return true
      end
      aY.nextAction = aU() + 0.75
      if a8.readyButton and a7(a8.readyButton) then
        aY.readyPending = true
        aY.stats.readyRequests += 1
        aO.status("Character selection · Ready requested for " .. a8.selected)
      end
      return true
    end
    function aY.refreshUI(a8)
      if not aY.dropdown then
        return
      end
      if not a8 and aU() < (aY.nextRefresh or 0) then
        return
      end
      aY.nextRefresh = aU() + 2
      local ba = {"Current toon"}
      for bb, bc in ipairs(aY.ownedToons() or {}) do
        ba[#ba + 1] = bc
      end
      local bb = table.concat(ba, "|")
      local bc = aO.options.selectedToon or "Current toon"
      if a8 or bb ~= aY.signature or bc ~= aY.uiSelected then
        aY.signature = bb
        aY.uiSelected = bc
        aY.syncing = true
        aY.dropdown:Refresh(ba, {bc})
        aY.syncing = false
      end
    end
    function aY.attachUI(a8)
      a8:CreateSection("Character selection")
      aY.toggle = a8:CreateToggle({Name = "Auto Ready after Toon selection", CurrentValue = aO.options.autoReady,
        Flag = "GograAutoReady", Callback = function(ba)
        aO.options.autoReady = ba == true
      end})
      aY.dropdown = a8:CreateDropdown({Name = "Toon to select · owned inventory", Options = {"Current toon"},
        CurrentOption = {aO.options.selectedToon or "Current toon"}, MultipleOptions = false, Flag = "GograSelectedToon",
        Callback = function(ba)
        if aY.syncing then
          return
        end
        aO.options.selectedToon = type(ba) == "table" and ba[1] or ba
      end})
      a8:CreateButton({Name = "Refresh owned Toons", Callback = function()
        aY.refreshUI(true)
      end})
      aY.refreshUI(true)
    end
    function aY.syncUI()
      if aY.toggle then
        aY.toggle:Set(aO.options.autoReady)
      end
      aY.refreshUI(true)
    end
    return aY
  end
end)())({options = aD.options, enabled = aL, status = aN})

local function aO()
  local aU = aF()
  local aV = aE(aU, "Decoding", nil)
  return typeof(aV) == "Instance" and aV or nil
end

local function aU()
  local aV = workspace:FindFirstChild("Info")
  local aY = aE(aV, "RequiredGenerators", math.huge)
  return aG() ~= nil and (aE(aV, "Panic", false) or not aE(aV, "FloorActive", true) or aY > 0 and aE(aV, "GeneratorsCompleted", 0) >= aY)
end

local aV, aY, a3, a4, a6, a7

local function a8(ba)
  local bb = g
  for bc, bd in ipairs(ba) do
    bb = bb and bb:FindFirstChild(bd)
  end
  assert(bb and bb:IsA("ModuleScript"), "Waiting for " .. table.concat(ba, "/"))
  return require(bb)
end

local function ba()
  return pcall(function()
    aV = a8({"SharedUtils", "InputService"})
    aY = a8({"Modules", "Core", "GameContext"})
    a3 = a8({"Modules", "ClientUI", "SkillCheckController"})
    a4 = a8({"Modules", "ClientUI", "GeneratorUIController"})
    local bb = k:FindFirstChildOfClass("PlayerScripts")
    local bc = bb and bb:FindFirstChild("PlayerModule")
    if bc then
      a6 = require(bc):GetControls()
    end
  end)
end

local bb, bc

local function bd(be)
  local bh, bi = aF()
  if be then
    if a6 then
      a6:Disable()
    end
    j:BindActionAtPriority("GograAutofarmMovement", function()
      return Enum.ContextActionResult.Sink
    end, false, 4000, Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward, Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump)
    if bi and bb ~= bi then
      if bb and bb.Parent then
        bb.AutoRotate = bc
      end
      bb, bc = bi, bi.AutoRotate
      bi.AutoRotate = false
    end
  else
    j:UnbindAction("GograAutofarmMovement")
    if a6 then
      a6:Enable()
    end
    if bb and bb.Parent then
      bb.AutoRotate = bc
    end
    bb = nil
  end
end

local function be()
  local bh = aF()
  local bi = aI()
  if aD.health.character ~= bh then
    aD.health.character = bh
    aD.health.last = bi
    aD.health.pending = false
  elseif aD.health.last and bi < aD.health.last and aL() then
    aD.health.losses += 1
    aD.health.pending = true
    aD.health.damageAt = os.clock()
    if aD.diagnostics then
      aD.diagnostics.capture(bi <= 1 and "critical-health" or "damage", "Health dropped from " .. tostring(aD.health.last) .. " to " .. tostring(bi), bi <= 1)
    end
    warn("[Gogra Autofarm] Damage detected; cancelling extraction")
  end
  aD.health.last = bi
  return aD.health.pending
end

local function bh(bi, bj)
  bi = bi == true
  if bi and not bj and aD.nav and not aD.nav.sprintSafe() then
    bi = false
  end
  local bk = aD.sprint ~= bi
  if not bk and (not bi or os.clock() - (aD.lastSprintSent or 0) < 0.75) then
    return
  end
  aD.sprint = bi
  aD.lastSprintSent = os.clock()
  local bl = aV and aV._actions and aV._actions.Sprint
  if bk and bl then
    pcall(firesignal, bi and bl.Pressed or bl.Released)
  end
  local bm = g:FindFirstChild("Events")
  local bn = bm and bm:FindFirstChild("SprintEvent")
  if bn then
    pcall(function()
      bn:FireServer(bi)
    end)
  end
end

local bi, bj = -math.huge, nil

local function bk(bl)
  local bm = bl and bl:FindFirstChild("Stats")
  if not bm then
    return
  end
  local bn = aF()
  local bo = aO() == bl
  for bp, bq in ipairs(bm:GetChildren()) do
    if bq:IsA("ObjectValue") and bq.Name:match("^ActivePlayer%d*$") and (bq.Value == k or bq.Value == bn) then
      bo = true
    end
  end
  if not bo and not (aD.startMachine == bl and os.clock() - (aD.startAt or 0) < 2.5) then
    return
  end
  if bl ~= bj or os.clock() - bi > 0.12 then
    bi, bj = os.clock(), bl
    local bp = bm:FindFirstChild("StopInteracting")
    if bp then
      pcall(function()
        bp:FireServer("Stop")
      end)
    end
    if a3 and a3.abortActive then
      pcall(a3.abortActive, bl)
    end
    if a4 and a4.ForceDisengage then
      local bq, bs = bn, aD.generation
      task.spawn(function()
        if aF() == bq and aD.generation == bs and (aO() == bl or aY and aY.currentgenerator == bl) then
          pcall(a4.ForceDisengage)
        end
      end)
    end
  end
end

local function bl()
  aD.itemHold = nil
end

local function bm()
  bl()
  local bn = aO() or aD.startMachine
  if bn then
    bk(bn)
  end
  bh(false)
end

local function bn(bo)
  return bo and bo.floor == aG() and bo.object.Parent ~= nil and bo.object:IsDescendantOf(bo.floor) and bo.prompt.Parent ~= nil
end

local function bo(bp)
  local bq = bp.object:FindFirstChild("Stats")
  return aE(bq, "Completed", false) or aE(bq, "CurrentAmount", 0) >= aE(bq, "RequiredAmount", math.huge)
end

local function bp(bq)
  local bs = bq.object:FindFirstChild("Stats")
  local bt = aF()
  if not bs then
    return false
  end
  if aE(bs, "Connie", false) then
    return false
  end
  for by, bB in ipairs(bs:GetChildren()) do
    if bB:IsA("ObjectValue") and bB.Name:match("^ActivePlayer%d*$") and bB.Value ~= nil and bB.Value ~= k and bB.Value ~= bt then
      return false
    end
  end
  return bq.prompt.Enabled or aO() == bq.object or aE(bs, "ActivePlayer", nil) == k or aE(bs, "ActivePlayer", nil) == bt or aD.startMachine == bq.object and os.clock() - (aD.startAt or 0) < 2.5
end

local function bq(bs)
  local bt = bs and bs.Parent
  if bt and bt:IsA("Attachment") then
    return bt.WorldPosition
  end
  if bt and bt:IsA("BasePart") then
    return bt.Position
  end
  if bt and bt:IsA("Model") then
    return bt:GetPivot().Position
  end
end

local function bs(bt)
  local by = {}
  local bB = bt and bt:FindFirstChild("Generators")
  if bB then
    for bC, bD in ipairs(bB:GetChildren()) do
      local bE = bD:FindFirstChild("Stats")
      local bF = bD:FindFirstChildWhichIsA("ProximityPrompt", true)
      if bE and bF and bE:FindFirstChild("Completed") then
        local bG = bq(bF)
        local bH = bD:FindFirstChild("TeleportPositions")
        local bI = bH and bH:FindFirstChild("TeleportPosition")
        if bI and bI:IsA("BasePart") then
          bG = bI.Position + Vector3.new(0, 2.5, 0)
        end
        if bG then
          by[#by + 1] = {object = bD, prompt = bF, position = bG, floor = bt, kind = "machine", name = "Machine " .. bC}
        end
      end
    end
  end
  return by
end

local function bt(by)
  if not bn(by) or not bp(by) then
    return false, "machine unavailable"
  end
  local bB, bC, bD = aF()
  local bE = aO() == by.object and bD and bD.Position or by.position
  if aO() == by.object and bD then
    by.position = bD.Position
  end
  local bF, bG = aD.nav.safeToMachine(bE, 3, false, aO() == by.object)
  if not bF and bG == "ichor-puddle" then
    if aO() == by.object then
      return true
    end
    local bH = bq(by.prompt)
    local bI = bH and aD.nav.machineApproach(by.position, bH, by.prompt.MaxActivationDistance)
    if bI then
      by.position = bI
      return aD.nav.safeToMachine(bI, 1, false, true)
    end
  end
  return bF, bG
end

local function by()
  local bC, bD, bE = aF()
  if not aD.nav or not bE then
    return false
  end
  return aD.nav.shouldHide(bE.Position)
end

local function bD()
  local bE, bF, bG = aF()
  if aD.nav and bG and aD.nav.safeHere(bG.Position, 2, true) then
    aD.health.pending = false
  end
end

local function bF()
  local bG = aD.cover.active and aD.target and aD.cover.workingMachine == aO() and aD.nav and aD.nav.canWorkFromCover(aD.target.prompt)
  if not aL() or not aJ() or not aD.nav or not aO() or not aD.target or aO() ~= aD.target.object or (aD.cover.active or aD.cover.pending) and not bG or aD.nav.stats.motionMode or aD.release and aD.release.pending() then
    return false
  end
  if aD.grabbed or be() then
    return false
  end
  if bG then
    return true
  end
  return not by() and bt(aD.target)
end

local function bG()
  local bH = aF()
  local bI, bJ, bL = aF()
  local bM = workspace:FindFirstChild("Elevators")
  local bN = bM and bM:FindFirstChild("Elevator")
  local bO = bN and bN:FindFirstChild("ElevatorHitBox")
  if bL and bO and bO:IsA("BasePart") then
    local bP = bO.CFrame:PointToObjectSpace(bL.Position)
    local bQ = bO.Size * 0.5
    return math.abs(bP.X) < bQ.X - 1 and math.abs(bP.Y) < bQ.Y and math.abs(bP.Z) < bQ.Z - 1
  end
  return aE(bH and bH:FindFirstChild("Stats"), "InElevator", false) == true
end

local function bH()
  if aD.shelter and (aD.shelterFloor ~= aG() or not bG()) then
    aD.shelter = false
  end
  return aD.shelter == true
end

local function bJ()
  if not bH() then
    return false
  end
  if aD.extras and aD.extras.holding then
    aN("Hidden · waiting for madness enemy to become mobile")
    return false
  end
  local bL = aD.target
  if not (bn(bL) and not bo(bL) and bp(bL) and bt(bL)) then
    bL = nil
    for bM, bN in ipairs(bs(aG())) do
      if bn(bN) and not bo(bN) and bp(bN) and bt(bN) then
        bL = bN
        break
      end
    end
    if bL and aD.core then
      aD.core.clearTarget()
    end
  end
  if bL and not aD.nav.chaseThreat() then
    aD.shelter = false
    aD.health.pending = false
    aN("Machine area clear · leaving refuge")
    return true
  end
  aN("Hidden in elevator refuge · waiting for a free, safe machine")
  return false
end

local function bL(bM, bN)
  bl()
  local bO = aD.generation
  local bP = bM.floor
  local bQ = aF()
  local function bR()
    if not aL() or aD.generation ~= bO or aF() ~= bQ or aG() ~= bP or not bn(bM) or bo(bM) then
      return false, "cancelled"
    end
    if aU() then
      return false, "exit-required"
    end
    if (aD.cover.active or aD.cover.pending) and not bN then
      return false, "cover-holding"
    end
    if bN then
      return aD.nav.canWorkFromCover(bM.prompt), "covered-interaction-unavailable"
    end
    local bT, bV = by()
    if bT then
      return false, type(bV) == "table" and bV.reason or bV
    end
    return bt(bM)
  end
  local bT, bV = bR()
  if not bT then
    return false, bV
  end
  if aO() == bM.object then
    return true
  end
  local bW, bX, bY = aF()
  local bZ = bq(bM.prompt)
  if not bZ then
    return false, "missing prompt"
  end
  if (bY.Position - bZ).Magnitude > math.max(0, bM.prompt.MaxActivationDistance - 0.35) then
    local b_, b0 = aD.nav.machineApproach(bM.position, bZ, bM.prompt.MaxActivationDistance)
    if not b_ then
      return false, b0
    end
    bM.position = b_
    local b1, b3 = aD.nav.moveToMachine(b_, 0.6)
    if not b1 then
      return false, b3
    end
  end
  bT, bV = bR()
  if not bT then
    return false, bV
  end
  bX, bX, bY = aF()
  bZ = bq(bM.prompt)
  if not bZ or (bY.Position - bZ).Magnitude > bM.prompt.MaxActivationDistance - 0.1 then
    return false, "arrival not confirmed"
  end
  if not bM.prompt.Enabled then
    return false, "machine occupied"
  end
  aD.startMachine, aD.startAt = bM.object, os.clock()
  if bN then
    aD.cover.workingMachine = bM.object
  end
  local b_, b0 = pcall(fireproximityprompt, bM.prompt)
  if not b_ then
    return false, tostring(b0)
  end
  local b1 = os.clock() + 2.5
  repeat
    if aO() == bM.object then
      if bN and not aD.nav.canWorkFromCover(bM.prompt) then
        bm()
        aD.cover.workingMachine = nil
        return false, "native-machine-moved-out-of-cover"
      end
      return true, "native interaction confirmed"
    end
    bT, bV = bR()
    if not bT then
      bm()
      return false, bV
    end
    task.wait(0.03)
  until os.clock() >= b1
  bm()
  return false, "native interaction unconfirmed"
end

function aD.ReplanMachine(bM, bN, bO)
  if not aL() or not aD.nav or not bn(bM) or not bp(bM) or aO() == bM.object or (aD.cover.active or aD.cover.pending) and not (bO == true and aD.cover.active) then
    return false
  end
  local bP = bq(bM.prompt)
  if not bP then
    return false
  end
  local bQ = aD.nav.machineApproach(bM.position, bP, bM.prompt.MaxActivationDistance, bM.position)
  if not bQ then
    return false
  end
  bM.position = bQ
  aD.nav.stats.machineReplans = (aD.nav.stats.machineReplans or 0) + 1
  aD.nav.stats.machineReplanReason = type(bN) == "table" and bN.reason or bN
  return true
end

function aD.WorkFromCover()
  local bM = aD.target
  if not aD.options.machineFromCover or not bn(bM) or bo(bM) or aD.coverWorkUnsupported[bM.object] or not aD.nav.canWorkFromCover(bM.prompt) then
    return false
  end
  local bN = tostring(bM.object:GetAttribute("MinigameType") or ""):lower()
  if bN:find("movement", 1, true) or bN:find("fish", 1, true) then
    return false
  end
  if aO() ~= bM.object then
    if aD.options.prioritizeSafety then
      aD.nav.stats.coverWorkBlocked = "native-cover-start-unverified"
      return false
    end
    local bO, bP = bL(bM, true)
    if not bO then
      aD.coverWorkUnsupported[bM.object] = bP or true
      aD.cover.workingMachine = nil
      return false
    end
  end
  aD.cover.workingMachine = bM.object
  local bO = bM.object:FindFirstChild("Stats")
  local bP = aE(bO, "CurrentAmount", 0)
  local bQ = aE(bO, "RequiredAmount", 1)
  if aD.cover.workAmount ~= bP then
    aD.cover.workAt = os.clock()
    aD.cover.workAmount = bP
  end
  aD.cover.workAt = aD.cover.workAt or os.clock()
  if os.clock() - aD.cover.workAt > 10 then
    bm()
    aD.coverWorkUnsupported[bM.object] = "no-progress"
    aD.cover.workingMachine = nil
    return false
  end
  aN(string.format("Hidden · extracting %s · %d%%", bM.name, math.floor(bP / math.max(1, bQ) * 100)))
  return true
end

local function bM()
  if aD.enabled and aD.core and aD.core.floor == aG() and not aD.pendingFocus then
    aD.pendingFocus = {floor = aD.core.floor, target = aD.target, phase = aD.core.phase, pickup = aD.pickup,
      machineCommitted = aD.core.machineCommitted}
  end
  aD.running = false
  if aD.lobby then
    aD.lobby.stop()
  end
  bm()
  if aD.centerLock then
    aD.centerLock:Disconnect()
    aD.centerLock = nil
  end
  if aD.nav then
    aD.lastNavStats = aD.nav.stats
    aD.nav.stop()
    aD.nav = nil
  end
  if aD.motionAnimations then
    aD.motionAnimations.destroy()
    aD.motionAnimations = nil
  end
  if aD.skill then
    aD.skill.stop()
    aD.skill = nil
  end
  if aD.release then
    aD.release.destroy()
    aD.release = nil
  end
  if aD.hazards then
    aD.hazards.destroy()
    aD.hazards = nil
  end
  if aD.cards then
    aD.cards.destroy()
    aD.cards = nil
  end
  if aD.extras then
    aD.extras.destroy()
    aD.extras = nil
  end
  if aD.noclip and not aD.cover.active then
    aD.noclip.destroy()
    aD.noclip = nil
  end
  aD.startMachine = nil
  aD.grabbed = false
  aD.health.pending = false
  bd(false)
end

local function bN(bO)
  local function bP(bQ)
    if not aD.destroyed and aD.enabled and aD.generation == bO then
      aN(bQ)
    end
  end
  local bQ, bR = ba()
  if not bQ then
    aD.waitReason = tostring(bR)
    aN("waiting for game")
    return false
  end
  if not aJ() then
    aN("waiting for game")
    return false
  end
  if type(firesignal) ~= "function" or type(fireproximityprompt) ~= "function" then
    aN("Missing native input support")
    return false
  end
  if aD.noclip then
    aD.noclip.destroy()
    aD.noclip = nil
  end
  aD.hazards = ao({character = aF, room = aG, options = aD.options})
  aD.motionAnimations = af({character = aF, run = function()
    return game.PlaceId == 16552821455
  end, identity = CFrame.identity, idle = function(bT)
    return bT.Priority == Enum.AnimationPriority.Idle
  end, wait = function()
    h.Heartbeat:Wait()
  end})
  aD.cards = aq({character = aF, room = aG, options = aD.options, enabled = aL, status = bP})
  local bT = ai({character = aF, room = aG, cover = aD.cover, keepEnabled = function()
    return aL() and not aD.destroyed and aD.options.noclip == true
  end, report = function(bT, bV)
    if aD.diagnostics then
      aD.diagnostics.capture(bT, bV)
    end
  end, enforceGround = function()
    return aD.nav and aD.nav.enforceGround and aD.nav.enforceGround()
  end, ownsHeight = function()
    return aD.nav and aD.nav.ownsHeight()
  end})
  aD.noclip = bT
  if aD.options.noclip or aD.cover.active or aD.cover.pending then
    bT.setEnabled(true)
  end
  aD.release = ap({character = aF, room = aG, player = k, enabled = aL, machine = function()
    return aO() or aD.startMachine
  end, recentStart = function()
    return aD.startMachine, aD.startAt
  end, coverPinned = function()
    return aD.nav and aD.nav.stats.coverPinned == true
  end, stopNative = bk})
  local bV = {options = aD.options, cover = aD.cover, teleportPolicy = aD.teleportPolicy, character = aF,
    room = aG, coverGeometry = ae, detectionOnly = true, hideWhilePlanning = true, animations = aD.motionAnimations,
    strictGround = true, nativeRoutes = true, floorFollowerFactory = ag, groundTweenFactory = ah, stuckResetFactory = ab,
    recoveryReady = aD.ReadyForAutofarm, encountersPending = function()
    return aD.postActive and aD.researchActive
  end, encounterExitRequired = function()
    return aD.extras and aD.extras.encounterExitRequired() or false
  end, encounterEmergencyExit = function(bV)
    if aD.extras then
      aD.extras.endEncounters(bV or "unsafe encounter")
    end
  end, machinesFinished = function()
    local bV = workspace:FindFirstChild("Info")
    local bX = aE(bV, "RequiredGenerators", math.huge)
    return bX > 0 and aE(bV, "GeneratorsCompleted", 0) >= bX
  end, alive = function()
    return aL() and aD.generation == bO and aJ()
  end, activity = function()
    return aD.activity
  end, exitRequired = function()
    return aD.extras and aD.extras.encounterExitRequired() or not aD.postActive and aU()
  end, status = bP, stopInteraction = bm, inputService = aV, gameContext = aY, hazards = aD.hazards, canExtract = bF,
    onTravelPulse = function(bV)
    if aD.extras then
      aD.extras.stepSlidePickup(bV)
    end
  end, grabbed = function()
    return aD.grabbed
  end, setSprint = bh, healthDanger = be, movementMachine = function()
    local bV = aO()
    local bX = bV and bV:GetAttribute("MinigameType")
    return bV ~= nil and (aY.currentMinigameType == "movement" or type(bX) == "string" and bX:lower():find("movement", 1, true) ~= nil)
  end, damageStamp = function()
    return aD.health.losses
  end, coverDamageHandled = function()
    aD.health.pending = false
  end, onCoverDisplaced = function()
    local bV = aD.cover.workingMachine or aO()
    if bV then
      aD.coverWorkUnsupported[bV] = "native-machine-repositions-character"
      aD.cover.workingMachine = nil
      bm()
    end
  end, releaseExtraction = function(bV)
    return aD.release.request(bV)
  end, releasePending = function()
    return aD.release.pending()
  end, releaseStep = function()
    return aD.release.step()
  end, releaseReady = function()
    return aD.release.ready()
  end, ensureNoclip = function()
    return bT.ensure()
  end, report = function(bV, bX)
    if aD.diagnostics then
      aD.diagnostics.capture(bV, bX)
    end
  end, machineEscapePending = function()
    return aD.release.recent()
  end, setTemporaryNoclip = function(bV)
    return bT.setEnabled(bV)
  end, refugeActive = bH, onRefuge = function(bV)
    aD.shelter = true
    aD.shelterFloor = bV
    aD.health.pending = false
  end, holdCover = function()
    return aD.extras and aD.extras.holding
  end, shopAllowed = function()
    return aL() and bG() and aE(workspace:FindFirstChild("Info"), "DandyStoreOpen", false)
  end, detectedUs = function(bV, bX, bY)
    local bZ = aE(bV, "ChasingValue", nil)
    if bZ then
      return bZ == bX or bZ == k or bZ:IsDescendantOf(bX)
    end
    return bY and (bV:GetAttribute("Alerted") == true or aE(bV, "Alerted", false)) or false
  end, researchObserved = function(bV)
    local bX = aD.extras and aD.extras.records[bV]
    return bX and bX.observed == true
  end, machinePosition = function()
    if aD.activity == "pickup" or aD.activity == "research" then
      return nil
    end
    return aD.target and aD.target.position, aD.target and aD.target.object
  end, machineTargetValid = function()
    return bn(aD.target) and not bo(aD.target) and bp(aD.target)
  end, replanCoverTarget = function(bV)
    if bV == "attack-on-machine-route" or bV == "twisted-on-direct-route" or bV == "twisted-route-changed" or bV == "twisted-on-exit-corridor" then
      local bX, bY, bZ = aF()
      for b_, b0 in ipairs(bs(aG())) do
        if (not aD.target or b0.object ~= aD.target.object) and bn(b0) and not bo(b0) and bp(b0) and bt(b0) and bZ and aD.nav.generatorLevelRoute(bZ.Position, b0.position, true) then
          if aD.core then
            aD.core.selectTarget(b0)
            return true
          end
        end
      end
      return false
    end
    return aD.ReplanMachine(aD.target, bV, true)
  end, resumeAllowed = function(bV, bY)
    if bY ~= "machine" then
      return true
    end
    return bn(aD.target) and not bo(aD.target) and bp(aD.target)
  end, resumePosition = function()
    if aU() and not aD.postActive then
      return nil, "elevator"
    end
    local bV = aD.extras and aD.extras.activePickup(aG())
    if bV and (not aD.core or aD.core.phase == "items") then
      return bq(bV.prompt) or bV.position, "pickup"
    end
    if aD.cover.active and aD.options.afterHide == "next" and not aD.cover.nextGeneratorChosen and bn(aD.target) then
      local bY, bZ
      local b_, b0, b1 = aF()
      for b3, b4 in ipairs(bs(aG())) do
        if b4.object ~= aD.target.object and bn(b4) and not bo(b4) and bp(b4) and bt(b4) then
          local b6 = (b1.Position - b4.position).Magnitude
          if not bZ or b6 < bZ then
            bY, bZ = b4, b6
          end
        end
      end
      if bY and aD.core then
        aD.core.selectTarget(bY)
        aD.cover.nextGeneratorChosen = true
      end
    end
    if aD.cover.active and bn(aD.target) and aD.nav.generatorCamped(aD.target.position, aD.target.object) then
      local bY, bZ
      local b0, b1, b3 = aF()
      for b4, b6 in ipairs(bs(aG())) do
        if b6.object ~= aD.target.object and bn(b6) and not bo(b6) and bp(b6) and bt(b6) then
          local b7 = (b3.Position - b6.position).Magnitude
          if not bZ or b7 < bZ then
            bY, bZ = b6, b7
          end
        end
      end
      if bY and aD.core then
        aD.core.selectTarget(bY)
        aN("Twisted camping generator · switching machines")
      end
    end
    if bn(aD.target) and not bo(aD.target) then
      if not bp(aD.target) then
        return nil, "machine-occupied"
      end
      return aD.target.position, "machine"
    end
    if not aD.postActive then
      for bY, bZ in ipairs(bs(aG())) do
        if bn(bZ) and not bo(bZ) and bp(bZ) and bt(bZ) then
          if aD.core then
            aD.core.selectTarget(bZ)
          end
          return bZ.position, "machine"
        end
      end
      return nil, "machine-occupied"
    end
    return nil, "entry"
  end}
  aD.nav = aa(bV)
  aD.skill = am(bV)
  aD.puddleQuest = (function(bY, bZ)
    return ((function()
      return function(b1)
        local b3 = b1.clock or os.clock
        local b4 = b1.wait or task.wait
        local b6 = {visited = setmetatable({}, {__mode = "k"}), retry = {}, stats = {stepped = 0, attempts = 0}}
        local function b7(b9, ca)
          local cb, cc = b9.X - ca.X, b9.Z - ca.Z
          return math.sqrt(cb * cb + cc * cc)
        end
        function b6.cancel()
          b1.setTarget(nil)
        end
        function b6.pending(b9)
          if not b1.options.autoPuddleQuest or not b1.enabled() or b1.isRibecca and not b1.isRibecca() then
            return false
          end
          local ca = b1.position()
          if not ca then
            return false
          end
          for cb, cc in ipairs(b1.targets()) do
            if cc.object.Name ~= "FinnIchorPuddle" and not b6.visited[cc.object] and b3() >= (b6.retry[cc.object] or 0) and b7(ca, cc.position) <= 120 then
              return true
            end
          end
          return false
        end
        function b6.step(b9)
          if b1.isRibecca and not b1.isRibecca() then
            b6.stats.lastReason = "requires-ribecca"
            return false
          end
          if not b1.options.autoPuddleQuest or not b1.enabled() or not b1.eligible() then
            return false
          end
          if b6.floor ~= b9 then
            b6.floor = b9
            b6.retry = {}
          end
          local ca = b1.position()
          if not ca then
            return false
          end
          local cb = {}
          for cc, cd in ipairs(b1.targets()) do
            local ce = cd.object
            if ce.Name ~= "FinnIchorPuddle" and not b6.visited[ce] and b3() >= (b6.retry[ce] or 0) and b7(ca, cd.position) <= 120 then
              cb[#cb + 1] = cd
            end
          end
          table.sort(cb, function(cc, cd)
            return b7(ca, cc.position) < b7(ca, cd.position)
          end)
          for cc, cd in ipairs(cb) do
            if not b1.setTarget(cd.object) then
              continue
            end
            local ce, cf = pcall(function()
              if not b1.safe(cd.position) then
                return false
              end
              b6.stats.attempts += 1
              b1.status("Ribecca Quest · stepping into an ordinary puddle")
              local ce = b1.move(cd.position)
              if not ce or not b1.enabled() or not b1.eligible() then
                return true
              end
              local cf = b1.position()
              if not cf or b7(cf, cd.position) > 1.75 or math.abs(cf.Y - cd.position.Y) > 10 then
                return true
              end
              local cg = b3() + 0.4
              while b3() < cg do
                if not b1.enabled() or not b1.options.autoPuddleQuest or not b1.eligible() or not b1.safe(b1.position()) then
                  return true
                end
                b4(0.1)
              end
              b6.visited[cd.object] = true
              b6.stats.stepped += 1
              b6.stats.lastReason = "puddle-entered"
              b1.status("Ribecca Quest · puddle entered; leaving it")
              if b1.safe(ca) then
                b1.move(ca)
              end
              return true
            end)
            b1.setTarget(nil)
            b6.retry[cd.object] = b3() + 5
            if not ce then
              b6.stats.lastReason = tostring(cf)
              return false
            end
            if cf then
              return true
            end
          end
          return false
        end
        return b6
      end
    end)())({options = aD.options, enabled = function()
      return aL() and aD.generation == bO
    end, position = function()
      local b1, b3, b4 = aF()
      return b4 and b4.Position
    end, isRibecca = function()
      local b3 = g:FindFirstChild("PlayerData")
      b3 = b3 and (b3:FindFirstChild(tostring(k.UserId)) or b3:FindFirstChild(k.Name))
      return aE(b3, "SelectedCharacter", "") == "Ribecca"
    end, eligible = function()
      return not aO() and not aU() and not aD.cover.active and not aD.cover.pending and not bZ.chaseThreat() and not bZ.detectedThreat()
    end, targets = function()
      return bY.questPuddles()
    end, setTarget = function(b3)
      return bY.setQuestPuddle(b3)
    end, safe = function(b3)
      return b3 and bZ.safeToInteract(b3, 0.8, true, true)
    end, move = function(b3)
      return bZ.manualTo(b3, 0.6, "tween")
    end, status = bP})
  end)(aD.hazards, aD.nav)
  aD.extras = ar({state = aD, character = aF, room = aG, enabled = aL, current = aO, danger = by, promptPosition = bq,
    inElevator = bG, input = function()
    return aV
  end, status = bP, notifyEncounter = function(bY)
    task.defer(function()
      if aD.destroyed or not aD.options.encounterNotifications or not a7 then
        return
      end
      pcall(function()
        a7:Notify({Title = "Encountered " .. bY, Content = "Twisted detection confirmed", Duration = 4,
          Image = "eye"})
      end)
    end)
  end, noclip = function(bY)
    return bT.setEnabled(bY)
  end, releaseItemHold = bl, hide = function(bY)
    aD.release.request(bY)
    bm()
    return aD.nav.hide("tween")
  end})
  local bY, bZ = aD.skill.start()
  if not bY then
    bM()
    aN("Waiting for skill controls · " .. tostring(bZ))
    return false
  end
  be()
  aD.health.pending = false
  bd(true)
  aD.nav.start()
  aD.core = at({clock = os.clock, enabled = aL, alive = aJ, floor = aG, keepTargetInCover = true, detectionOnly = true,
    itemBudget = function()
    return aD.options.itemSweepBudget
  end, itemAttemptsCap = 0, camped = function(b3)
    return aD.nav and aD.nav.generatorCamped(b3.position, b3.object)
  end, ready = function(b3)
    return aG() == b3 and not aE(workspace:FindFirstChild("Info"), "Loading", false)
  end, setTarget = function(b3)
    aD.target = b3
  end, floorChanged = function(b3)
    aD.health.pending = false
    aD.postActive = false
    aD.researchActive = false
    aD.shelter = false
    aD.extras.reset(b3)
    table.clear(aD.coverWorkUnsupported)
  end, status = bP, activity = function(b3)
    aD.activity = b3
  end, exitRequired = aU, inElevator = bG, stop = bm, release = function(b3)
    return aD.release.request(type(b3) == "table" and b3.reason or b3)
  end, machinesFinished = function()
    local b3 = workspace:FindFirstChild("Info")
    local b4 = aE(b3, "RequiredGenerators", math.huge)
    return b4 > 0 and aE(b3, "GeneratorsCompleted", 0) >= b4
  end, afterMachines = function(b3)
    return aD.extras.afterMachines(b3)
  end, collectNearby = function(b3)
    if aD.puddleQuest.step(b3) then
      return true
    end
    if aD.extras.collect(b3, true) then
      return true
    end
    return aD.extras.openDoors(b3)
  end, collectCapsules = function(b3)
    return aD.extras.collectCapsules(b3)
  end, pendingItems = function()
    return aD.puddleQuest and aD.puddleQuest.pending(aG()) or aD.extras and aD.extras.pendingItems()
  end, pickupCommitted = function()
    return aD.extras and aD.extras.activePickup(aG()) ~= nil
  end, safetyBusy = function()
    return aD.nav and aD.nav.stats.pumpkinDodging == true
  end, covered = function()
    return aD.cover.active or aD.cover.pending or bH()
  end, resumeCover = function()
    if bH() then
      return bJ()
    end
    if aD.WorkFromCover() then
      return false, "working-from-verified-cover"
    end
    local b3, b4 = aD.nav.resumeCover()
    if b3 then
      bD()
    end
    return b3, b4
  end, danger = by, evade = function(b3)
    local b4, b6 = aD.nav.evade(type(b3) == "table" and b3 or nil)
    if b4 then
      bD()
    end
    return b4, b6
  end, returnElevator = function()
    return aD.nav.returnToElevator()
  end, hideWait = function()
    return aD.nav.hide(aD.options.hideMode)
  end, waitForRoute = function(b3, b4)
    aD.target = b3
    aD.release.request("blocked-machine-route")
    bm()
    return aD.nav.waitForRoute(b4)
  end, valid = bn, complete = bo, usable = bp, targets = bs, safe = bt, distance = function(b3)
    local b4, b6, b7 = aF()
    return (b7.Position - b3.position).Magnitude
  end, current = aO, begin = bL, replan = aD.ReplanMachine, progress = function(b3)
    local b6 = b3.object:FindFirstChild("Stats")
    return aE(b6, "CurrentAmount", 0), aE(b6, "RequiredAmount", 1)
  end, work = function(b3)
    local b6 = b3.object:GetAttribute("MinigameType")
    local b7 = aY.currentMinigameType == "movement" or type(b6) == "string" and b6:lower():find("movement", 1, true) ~= nil
    bh(b7, b7)
  end})
  local b3 = aD.pendingFocus
  aD.pendingFocus = nil
  if b3 and b3.floor == aG() then
    aD.core.restore(b3.floor, b3.target, b3.phase, b3.machineCommitted)
    if b3.pickup and b3.phase == "items" then
      aD.extras.setPickup(b3.pickup)
      aD.extras.activePickup(aG())
    end
  end
  aN("Ready · farming machines")
  aD.running = true
  return true
end

local bO

function aD.ReturnLobby(bP, bQ)
  if bP == "character died" and aD.diagnostics then
    local bR = aF()
    if aD.reportedDeathCharacter ~= bR then
      aD.reportedDeathCharacter = bR
      aD.diagnostics.capture("death", "Character died; final movement and recent failures attached", true)
    end
  end
  if aD.destroyed or aD.returning or not bQ and not aD.options.autoReturnLobby or game.PlaceId == 16116270224 then
    return
  end
  if aD.diagnostics and bP ~= "character died" then
    aD.diagnostics.capture("lobby-return", bP or "Returning to lobby")
  end
  aD.returning = true
  if aD.SetEnabled then
    aD.SetEnabled(false)
  end
  aN("Returning to lobby · " .. tostring(bP or "character died"))
  task.spawn(function()
    for bR = 1, 3 do
      if aD.destroyed or game.PlaceId == 16116270224 then
        return
      end
      local bT, bV = pcall(function()
        game:GetService("TeleportService"):Teleport(16116270224, k)
      end)
      if not bT then
        warn("[Gogra Autofarm] Lobby return: " .. tostring(bV))
      end
      task.wait(5)
    end
    aD.returning = false
    aN("Lobby return failed · retry available")
  end)
end

function aD.CheckSoloRun()
  if aD.destroyed or not aD.session.shouldReturn(aD.SessionSnapshot()) then
    return false
  end
  aD.ReturnLobby("another player is in the run", true)
  return true
end

aD.events[#aD.events + 1] = f.PlayerAdded:Connect(function(bP)
  if bP ~= k and game.PlaceId == 16552821455 and aD.options.soloRun then
    aD.ReturnLobby("another player joined the run", true)
  end
end)

local bP = 0

aD.events[#aD.events + 1] = h.Heartbeat:Connect(function()
  if os.clock() >= bP then
    bP = os.clock() + 0.5
    aD.CheckSoloRun()
  end
end)

local bQ, bR, bT

aD.events[#aD.events + 1] = h.Heartbeat:Connect(function()
  if aD.destroyed or game.PlaceId ~= 16552821455 then
    return
  end
  local bV, bY = aF()
  if not bV or not bY then
    return
  end
  if bV ~= bQ then
    bQ = bV
    bT = false
    if bR then
      bR:Disconnect()
    end
    bR = bY.Died:Connect(function()
      aD.ReturnLobby("character died")
    end)
    aD.events[#aD.events + 1] = bR
  end
  local bZ = aI()
  if bZ > 0 then
    bT = true
  end
  if bY.Health <= 0 or bT and bZ <= 0 then
    aD.ReturnLobby("character died")
  end
end)

function aD.SetEnabled(bV)
  if aD.destroyed then
    return
  end
  bV = bV == true
  if bV and e.GograAutofarmSuspended then
    aN("Suspended after crash investigation")
    return
  end
  if aD.enabled == bV then
    return
  end
  aD.enabled = bV
  aD.generation += 1
  if bO then
    pcall(function()
      bO:Set(bV)
    end)
  end
  local bY = aD.generation
  if not bV then
    bM()
    aN(aD.cover.active and "Paused inside cover · move out to restore collision" or "Paused · manual controls restored")
    return
  end
  task.spawn(function()
    local bZ = false
    while aL() and aD.generation == bY do
      local b3, b6 = xpcall(function()
        if aD.returning or aD.CheckSoloRun() then
          return
        end
        if aD.selection.step() then
          return
        end
        if aD.lobby.isLobby() then
          if bZ then
            bM()
            bZ = false
          end
          aD.lobby.step()
          return
        end
        if not bZ then
          if not aD.ReadyForAutofarm() then
            aN("waiting for game")
            return
          end
          if aD.pendingConfig then
            aD.ApplyPendingConfig()
            if aD.CheckSoloRun() then
              return
            end
          end
          bZ = bN(bY)
        end
        if bZ then
          if not aJ() then
            aD.enabled = false
            aD.generation += 1
            bM()
            aN("Character died · autofarm stopped")
            if bO then
              pcall(function()
                bO:Set(false)
              end)
            end
            return
          end
          bd(true)
          if aD.nav and aD.nav.resetInProgress then
            aN("Stuck recovery · waiting for elevator ejection")
          elseif aD.grabbed then
            aN("Escaping Squirm · alternating struggle")
          elseif aD.staminaSpending then
            aN("Brief sprint to enable stamina item")
          else
            aD.core.step()
          end
        end
      end, debug.traceback)
      if aD.generation ~= bY then
        return
      end
      if not b3 then
        if aD.diagnostics then
          aD.diagnostics.capture("script-error", tostring(b6), true)
        end
        aD.errors[#aD.errors + 1] = tostring(b6)
        if #aD.errors > 10 then
          table.remove(aD.errors, 1)
        end
        warn("[Gogra Autofarm] " .. tostring(b6))
        bM()
        bZ = false
        aN("Recovering · " .. tostring(b6):sub(1, 100))
      end
      task.wait(bZ and 0.05 or 1)
    end
  end)
end

function aD.Destroy()
  if aD.destroyed then
    return
  end
  aD.enabled = false
  aD.generation += 1
  bM()
  aD.destroyed = true
  for bV, bY in ipairs(aD.events) do
    bY:Disconnect()
  end
  if aD.esp then
    aD.esp.destroy()
    aD.esp = nil
  end
  if aD.diagnostics then
    aD.diagnostics.destroy()
  end
  if aD.sponsor then
    local bV = aD.sponsor
    aD.sponsor = nil
    local bY, bZ = pcall(bV.destroy)
    if not bY then
      warn("[Gogra Autofarm] Overlay cleanup: " .. tostring(bZ))
    end
  end
  if a7 then
    pcall(function()
      a7:Destroy()
    end)
  end
  if e.GograAutofarm == aD then
    e.GograAutofarm = nil
  end
end

aD.Snapshot = function()
  return {version = aD.version, enabled = aD.enabled, status = aD.status, floor = aE(workspace:FindFirstChild("Info"), "Floor", 0),
    running = aD.running == true, waiting = aD.enabled and not aD.running, health = aI(), target = aD.target and aD.target.name,
    cover = aD.cover.active == true, errors = #aD.errors, navigation = aD.nav and aD.nav.stats or aD.lastNavStats,
    core = aD.core and aD.core.stats, skill = aD.skill and aD.skill.stats, arcade = aD.skill and aD.skill.arcade.stats,
    instant = aD.skill and aD.skill.instant.stats, release = aD.release and aD.release.stats, refuge = bH(),
    antiAFK = aD.antiAFK, esp = aD.esp and aD.esp.stats, extras = aD.extras and aD.extras.stats, shop = aD.extras and aD.extras.shop.stats,
    encounter = aD.extras and aD.extras.current and aD.extras.current.Name}
end

function aD.DiagnosticsSnapshot()
  local bV, bY, bZ = aF()
  local b3 = aG()
  local b6 = aD.nav and aD.nav.stats or aD.lastNavStats or {}
  local b7 = {}
  for b9 = math.max(1, #aD.errors - 2), #aD.errors do
    b7[#b7 + 1] = aD.errors[b9]
  end
  return {version = aD.version, map = b3 and b3.Name, floor = aE(workspace:FindFirstChild("Info"), "Floor", 0),
    health = aI(), status = aD.status, activity = aD.activity, target = aD.target and aD.target.name,
    pickup = aD.pickup and aD.pickup.name, position = bZ and tostring(bZ.Position), reason = b6.lastReason,
    blocked = b6.lastBlock or b6.travelBlocker, speed = b6.speed, requestedSpeed = b6.requestedSpeed,
    corrections = b6.corrections, collision = {enabled = aD.noclip and aD.noclip.enabled, error = aD.noclip and aD.noclip.lastError,
    stats = aD.noclip and aD.noclip.stats, lastCorrection = b6.lastCorrectionDetail, displacement = b6.lastTweenDisplacement,
    groundBlock = b6.groundBlock}, release = aD.release and aD.release.stats, cover = {active = aD.cover.active == true,
    pending = aD.cover.pending == true, kind = aD.cover.kind, reason = b6.returnReason or b6.coverFailure or b6.lastRetreatReason,
    wallSearch = b6.wallShelterSearch, entryConfirmedAt = b6.coverEntryConfirmedAt, entryRejected = b6.coverEntryRejected},
    route = {reason = b6.routeReason, replan = b6.replanReason, watchdog = b6.rescueReason, progress = b6.segments,
    poseWrites = b6.poseWrites, poseWritesSkipped = b6.poseWritesSkipped, groundParameters = b6.groundParameterBuilds,
    groundSamples = b6.grounding and b6.grounding.samples, stuckReset = b6.stuckReset}, errors = b7}
end

do
  local bV = game:GetService("HttpService")
  local function bY()
    if type(readfile) ~= "function" then
      return {}
    end
    local bZ, b3 = pcall(function()
      return bV:JSONDecode(readfile("GograAutofarm/reports-pending.json"))
    end)
    return bZ and type(b3) == "table" and b3 or {}
  end
  local bZ = bY()
  aD.diagnostics = au({clock = os.clock, epoch = os.time, spawn = task.spawn, wait = task.wait, encode = function(b3)
    return bV:JSONEncode(b3)
  end, snapshot = aD.DiagnosticsSnapshot, autoEnabled = function()
    return aD.options.automaticDiagnostics
  end, outbox = type(bZ.outbox) == "table" and bZ.outbox or {}, cooldowns = type(bZ.cooldowns) == "table" and bZ.cooldowns or {},
    redact = function(b3)
    for b6, b7 in ipairs({k.Name, k.DisplayName, tostring(k.UserId)}) do
      if #b7 >= 3 then
        b3 = b3:gsub(b7:gsub("([^%w])", "%%%1"), "[player]")
      end
    end
    return b3
  end, persist = function(b3, b6)
    if type(writefile) == "function" then
      if type(makefolder) == "function" and not isfolder("GograAutofarm") then
        makefolder("GograAutofarm")
      end
      writefile("GograAutofarm/reports-pending.json", bV:JSONEncode({outbox = b3, cooldowns = b6}))
    end
  end, send = function(b3, b6)
    local b7 = aw[b3]
    if not b7 then
      return 400
    end
    local b9 = request or http_request or syn and syn.request
    if type(b9) ~= "function" then
      return 0
    end
    local ca = b9({Url = b7 .. "?wait=true", Method = "POST", Headers = {["Content-Type"] = "application/json"},
      Body = bV:JSONEncode(b6), Timeout = 8})
    local cb = tonumber(ca.StatusCode or ca.Status)
    local cc
    if cb == 429 then
      local cd, ce = pcall(bV.JSONDecode, bV, ca.Body or "")
      cc = cd and ce.retry_after
    end
    return cb or 0, cc
  end})
  local b3 = 0
  local b6 = {}
  aD.events[#aD.events + 1] = h.Heartbeat:Connect(function()
    if aD.destroyed or os.clock() < b3 then
      return
    end
    b3 = os.clock() + 0.5
    aD.diagnostics.pump()
    if not aL() then
      return
    end
    local b7 = aD.DiagnosticsSnapshot()
    aD.diagnostics.record("movement", b7.reason, b7)
    local b9 = aD.nav and aD.nav.stats or {}
    if b6.map ~= aG() then
      b6 = {map = aG(), corrections = b9.corrections or 0}
    end
    if (b9.corrections or 0) > (b6.corrections or 0) then
      aD.diagnostics.capture("position-correction", "Movement was corrected; current blocker and collision state attached")
    end
    b6.corrections = b9.corrections or 0
    for ca, cb in pairs({noclip = aD.noclip, skill = aD.skill, release = aD.release, shop = aD.extras and aD.extras.shop,
        esp = aD.esp, progress = aD.progress}) do
      local cc = cb.lastError or cb.stats and cb.stats.lastError
      if cc and b6[ca] ~= tostring(cc) then
        b6[ca] = tostring(cc)
        aD.diagnostics.capture(ca .. "-error", tostring(cc))
      end
    end
  end)
  aD.events[#aD.events + 1] = game:GetService("LogService").MessageOut:Connect(function(b7, b9)
    if b9 ~= Enum.MessageType.MessageError and b9 ~= Enum.MessageType.MessageWarning then
      return
    end
    if b7:find("[Gogra Autofarm]", 1, true) or b7:find("[FloorAuto]", 1, true) or b7:find("Floor Auto noclip:", 1, true) then
      aD.diagnostics.capture("script-log", b7)
    end
  end)
end

local bV = {"autoCapsules", "selectedCapsuleTwisteds", "autoPuddleQuest", "autoReady", "selectedToon",
  "farmMode", "machineMoveMethod", "tweenSpeed", "escapeTweenSpeed", "directGeneratorLevel", "safetyMargin",
  "hideMode", "extractionMode", "autoLoot", "selectedItems", "itemMoveMethod", "itemPickupMode", "autoMachineItems",
  "afterHide", "coverPreference", "stuckTimeout", "stuckElevatorReset", "clearDelay", "resumeDistance",
  "drainStaminaItems", "autoHalloweenDoors", "machineFromCover", "avoidTimeCards", "itemSweepBudget",
  "researchMode", "researchTeleport", "waitForMadness", "antiDandy", "autoCheapestShop", "antiAFK", "autoShop",
  "useConsumables", "autoCards", "closeHideDistance", "autoBarnaby", "barnabyCoins", "soloRun", "espEnabled",
  "espPlayers", "espMonsters", "espMachines", "espItems", "espElevator", "espShop", "espHazards", "espDistance",
  "espResearch", "espThreatDetails", "espCharacterOutlines", "espAbilityCooldowns", "researchNotifications",
  "encounterNotifications", "automaticDiagnostics", "prioritizeSafety"}

local function bY(bZ)
  assert(type(bZ) == "string" and #bZ > 0 and #bZ <= 40 and bZ:match("^[%w_-]+$"), "Use letters, numbers, underscores or hyphens for the config name")
  return "GograAutofarm/configs/" .. bZ .. ".json"
end

function aD.ConfigNames()
  local bZ = {}
  if type(listfiles) == "function" and type(isfolder) == "function" and isfolder("GograAutofarm/configs") then
    for b3, b6 in ipairs(listfiles("GograAutofarm/configs")) do
      local b7 = b6:match("([^/\\]+)%.json$")
      if b7 then
        bZ[#bZ + 1] = b7
      end
    end
  end
  table.sort(bZ)
  return bZ
end

function aD.SaveConfig(bZ)
  local b3 = bY(bZ)
  assert(type(writefile) == "function" and type(makefolder) == "function" and type(isfolder) == "function", "Config filesystem is unavailable")
  if not isfolder("GograAutofarm") then
    makefolder("GograAutofarm")
  end
  if not isfolder("GograAutofarm/configs") then
    makefolder("GograAutofarm/configs")
  end
  local b6 = {}
  for b7, b9 in ipairs(bV) do
    b6[b9] = aD.options[b9]
  end
  local b7 = game:GetService("HttpService"):JSONEncode({version = 1, options = b6})
  writefile(b3, b7)
  assert(type(readfile) ~= "function" or readfile(b3) == b7, "Config readback did not match")
  if aD.autoload and (aD.autoload.enabled or not aD.autoload.name) then
    aD.autoload.configure(bZ, true)
  end
  aN("Saved config · " .. bZ)
end

function aD.LoadConfig(bZ, b3)
  local b6 = bY(bZ)
  assert(type(readfile) == "function", "Config filesystem is unavailable")
  local b7 = readfile(b6)
  assert(type(b7) == "string" and #b7 > 0, "Config file is missing or empty: " .. bZ)
  local b9 = game:GetService("HttpService"):JSONDecode(b7)
  assert(type(b9) == "table" and type(b9.options) == "table", "Invalid config file")
  local ca = {}
  local cb = {farmMode = {normal = true, faster = true}, machineMoveMethod = {auto = true, teleport = true,
    tween = true}, extractionMode = {instant = true, normal = true, perfect = true}, hideMode = {teleport = true,
    tween = true}, itemMoveMethod = {tween = true, teleport = true}, itemPickupMode = {slide = true, stand = true},
    afterHide = {next = true, same = true}, coverPreference = {wall = true, nearest = true}}
  for cc, cd in ipairs(bV) do
    local ce = b9.options[cd]
    if ce ~= nil then
      if cb[cd] then
        assert(cb[cd][ce], "Invalid " .. cd)
      elseif cd == "selectedToon" then
        assert(type(ce) == "string" and #ce > 0 and #ce <= 80, "Invalid Toon selection")
      elseif cd == "selectedItems" or cd == "selectedCapsuleTwisteds" then
        assert(type(ce) == "table", "Invalid item selection")
        local cf = {}
        for cg, ch in pairs(ce) do
          if type(cg) == "string" and #cg <= 80 and ch == true and (cd ~= "selectedItems" or not cg:lower():find("capsule", 1, true)) then
            cf[cg] = true
          end
        end
        ce = cf
      elseif cd == "tweenSpeed" then
        assert(type(ce) == "number", "Invalid speed")
        ce = math.clamp(ce, 12, 30)
      elseif cd == "safetyMargin" then
        assert(type(ce) == "number", "Invalid clearance")
        ce = math.clamp(ce, 0, 10)
      elseif cd == "closeHideDistance" then
        assert(type(ce) == "number", "Invalid hide distance")
        ce = math.clamp(ce, 6, 25)
      elseif cd == "espDistance" then
        assert(type(ce) == "number", "Invalid ESP distance")
        ce = math.clamp(ce, 100, 2000)
      elseif cd == "stuckTimeout" then
        assert(type(ce) == "number", "Invalid recovery delay")
        ce = math.clamp(ce, 1, 5)
      elseif cd == "clearDelay" then
        assert(type(ce) == "number", "Invalid cover delay")
        ce = math.clamp(ce, 0.2, 3)
      elseif cd == "resumeDistance" then
        assert(type(ce) == "number", "Invalid resume distance")
        ce = math.clamp(ce, 50, 60)
      elseif cd == "escapeTweenSpeed" then
        assert(type(ce) == "number", "Invalid escape speed")
        ce = math.clamp(ce, 18, 30)
      elseif cd == "itemSweepBudget" then
        assert(type(ce) == "number", "Invalid item sweep limit")
        ce = math.clamp(ce, 0, 90)
      elseif cd == "itemPickupDelay" then
        assert(type(ce) == "number", "Invalid pickup delay")
        ce = math.clamp(ce, 0.5, 3)
      else
        assert(type(ce) == "boolean", "Invalid " .. cd)
      end
      ca[cd] = ce
    end
  end
  for cc, cd in ipairs({"autoReady", "selectedToon"}) do
    if ca[cd] ~= nil then
      aD.options[cd] = ca[cd]
    end
  end
  if aD.selection then
    aD.selection.syncUI()
  end
  aD.pendingConfig = {name = bZ, options = ca}
  if b3 or not aD.ReadyForAutofarm() then
    aN("waiting for game")
    return
  end
  local cc = aL()
  aD.SetEnabled(false)
  aD.ApplyPendingConfig()
  if cc then
    aD.SetEnabled(true)
  end
  aN("Loaded config · " .. bZ)
end

function aD.ApplyPendingConfig()
  local bZ = aD.pendingConfig
  if not bZ then
    return false
  end
  if not aD.ReadyForAutofarm() then
    aN("waiting for game")
    return false
  end
  aD.pendingConfig = nil
  for b3, b6 in pairs(bZ.options) do
    aD.options[b3] = b6
  end
  aD.options.machineMoveMethod = "tween"
  aD.options.hideMode = "tween"
  aD.options.researchTeleport = false
  aD.options.directGeneratorLevel = false
  aD.options.tweenOnly = true
  aD.options.itemMoveMethod = "tween"
  aD.options.teleportHiding = false
  aD.options.strictElevatorTeleport = false
  aD.loadedConfigName = bZ.name
  if aD.autoload then
    aD.autoload.applied(bZ.name)
  end
  if aD.syncUI then
    aD.syncUI()
  end
  aN("Loaded config · " .. bZ.name)
  return true
end

aD.autoload = av({exists = function(bZ)
  if type(readfile) ~= "function" then
    return false
  end
  local b3, b6 = pcall(readfile, bY(bZ))
  return b3 and type(b6) == "string" and #b6 > 0
end, read = function()
  if type(readfile) ~= "function" then
    return nil
  end
  if type(isfile) == "function" and not isfile("GograAutofarm/autoload.json") then
    return nil
  end
  local bZ, b3 = pcall(readfile, "GograAutofarm/autoload.json")
  if not bZ then
    return nil
  end
  if type(b3) ~= "string" or #b3 == 0 then
    return nil
  end
  return game:GetService("HttpService"):JSONDecode(b3)
end, persist = function(bZ)
  assert(type(writefile) == "function" and type(makefolder) == "function" and type(isfolder) == "function", "Config filesystem is unavailable")
  if not isfolder("GograAutofarm") then
    makefolder("GograAutofarm")
  end
  writefile("GograAutofarm/autoload.json", game:GetService("HttpService"):JSONEncode(bZ))
end, queue = function(bZ)
  aD.LoadConfig(bZ, true)
end})

local bZ, b3, b6, b7 = 0, 0, false, 0

aD.events[#aD.events + 1] = h.Heartbeat:Connect(function()
  if aD.destroyed then
    return
  end
  if aD.pendingConfig and not aL() and aD.ReadyForAutofarm() then
    aD.ApplyPendingConfig()
  end
  if aD.progress and os.clock() >= b7 then
    b7 = os.clock() + 0.25
    local b9, ca = pcall(aD.progress.step)
    if not b9 then
      aD.progress.stats.lastError = tostring(ca)
    end
  end
  if aD.flushResearchNotice then
    aD.flushResearchNotice()
  end
  if aL() then
    be()
    if aD.release then
      aD.release.step()
    end
    if aD.extras then
      aD.extras.observe()
      if not aD.extras.exitDone and aD.extras.encounterExitRequired() then
        aD.extras.endEncounters("encounter time limit")
      end
      aD.extras.stepAutoItems()
      if not b6 and os.clock() >= b3 then
        b3 = os.clock() + 0.5
        b6 = true
        task.spawn(function()
          local b9 = aD.extras
          local ca, cb = pcall(function()
            if b9 then
              b9.stepShop()
            end
          end)
          if not ca then
            warn("[Gogra Autofarm] Shop: " .. tostring(cb))
          end
          b6 = false
        end)
      end
    end
  elseif aD.noclip and aD.cover.active then
    local b9 = aD.cover.part
    local ca, cb, cc = aF()
    local cd = false
    if cc and b9 and b9.Parent and aG() == aD.cover.floor then
      if aD.cover.geometry and aD.cover.geometryController then
        cd = aD.cover.geometryController.contains(aD.cover.geometry, cc.CFrame)
      else
        local ce = b9.CFrame:PointToObjectSpace(cc.Position)
        local cf = b9.Size * 0.5 + cc.Size * 0.5
        cd = math.abs(ce.X) <= cf.X and math.abs(ce.Y) <= cf.Y and math.abs(ce.Z) <= cf.Z
      end
    end
    if not cd or not ca then
      if aD.cover.geometryController then
        aD.cover.geometryController.destroy()
      end
      aD.noclip.destroy()
      aD.noclip = nil
      table.clear(aD.cover)
      aN("Paused · manual controls restored")
      if aD.unloadPending then
        aD.Destroy()
      end
    end
  end
  if aD.uiUpdate and os.clock() >= bZ then
    bZ = os.clock() + 0.3
    pcall(aD.uiUpdate)
  end
end)

local b9 = g:FindFirstChild("Events") and g.Events:FindFirstChild("TwistedSquirmGrab")

if b9 then
  local ca = 0
  local cb = "left"
  aD.events[#aD.events + 1] = b9.OnClientEvent:Connect(function(cc)
    if cc == "GrabStart" then
      aD.grabbed = true
      if aL() then
        bm()
        if aD.nav then
          aD.nav.interrupt()
        end
      end
    elseif cc == "GrabEnd" then
      aD.grabbed = false
    end
  end)
  aD.events[#aD.events + 1] = h.Heartbeat:Connect(function()
    if aL() and aD.grabbed and os.clock() >= ca then
      ca = os.clock() + 0.12
      b9:FireServer("Struggle", cb)
      cb = cb == "left" and "right" or "left"
    end
  end)
end

e.DISABLE_RAYFIELD_REQUESTS = true

local ca, cb = pcall(function()
  -- [Rayfield UI library removed, 3239 lines]
  local ca = a7:CreateWindow({Name = "Gogra Autofarm", LoadingTitle = "Gogra Autofarm", LoadingSubtitle = "Machines & survival",
    Theme = "Default", DisableRayfieldPrompts = true, ConfigurationSaving = {Enabled = false}, Discord = {Enabled = false},
    KeySystem = false})
  local cb = ca:CreateTab("Autofarm", "tractor")
  cb:CreateLabel("WARNING: Doesn't Work On Solara , Xeno!")
  local cc = {}
  aD.selection.attachUI(cb)
  cc.farmMode = cb:CreateDropdown({Name = "Farm mode", Options = {"Normal", "Faster farming"}, CurrentOption = {aD.options.farmMode == "faster" and "Faster farming" or "Normal"},
    MultipleOptions = false, Flag = "GograFarmMode", Callback = function(cd)
    local ce = type(cd) == "table" and cd[1] or cd
    aD.options.farmMode = ce == "Faster farming" and "faster" or "normal"
  end})
  cb:CreateLabel("Faster farming resumes when vision and the return route clear · Normal keeps the distance wait")
  bO = cb:CreateToggle({Name = "Autofarm", CurrentValue = false, Flag = "GograAutofarmEnabled", Callback = aD.SetEnabled})
  aD.toggle = bO
  local cd = cb:CreateLabel("Ready · F6 toggles autofarm")
  local ce = cb:CreateLabel("Waiting for a floor")
  local cf = cb:CreateLabel("Travel: Tween · generator travel and return")
  local cg = cb:CreateLabel("Dandy shop: waiting for an open shop")
  cc.machineMoveMethod = cb:CreateDropdown({Name = "Machine travel", Options = {"Tween"}, CurrentOption = {"Tween"},
    MultipleOptions = false, Flag = "GograMachineTravel", Callback = function(ch)
    local ci = type(ch) == "table" and ch[1] or ch
    aD.options.machineMoveMethod = "tween"
    aD.teleportPolicy.disabled = false
    aD.teleportPolicy.failures = 0
    if aD.nav then
      aD.nav.interrupt()
    end
  end})
  cc.tweenSpeed = cb:CreateSlider({Name = "Travel and hide speed", Range = {12, 30}, Increment = 1, Suffix = "studs/s",
    CurrentValue = 30, Flag = "GograTravelSpeed", Callback = function(ch)
    aD.options.tweenSpeed = math.clamp(ch, 12, 30)
  end})
  cc.escapeTweenSpeed = cb:CreateSlider({Name = "Escape and hide speed", Range = {18, 30}, Increment = 1,
    Suffix = "studs/s", CurrentValue = math.clamp(aD.options.escapeTweenSpeed, 18, 30), Flag = "GograEscapeSpeed",
    Callback = function(ch)
    aD.options.escapeTweenSpeed = math.clamp(ch, 18, 30)
  end})
  cc.safetyMargin = cb:CreateSlider({Name = "Extra threat clearance", Range = {0, 10}, Increment = 1,
    Suffix = "studs", CurrentValue = 3, Flag = "GograThreatClearance", Callback = function(ch)
    aD.options.safetyMargin = math.clamp(ch, 0, 10)
  end})
  cc.closeHideDistance = cb:CreateSlider({Name = "Hide when Twisted is this close", Range = {6, 25}, Increment = 1,
    Suffix = "studs", CurrentValue = 10, Flag = "GograCloseHide", Callback = function(ch)
    aD.options.closeHideDistance = math.clamp(ch, 6, 25)
  end})
  cc.extractionMode = cb:CreateDropdown({Name = "Extraction method", Options = {"Instant", "Perfect",
    "Normal"}, CurrentOption = {"Instant"}, MultipleOptions = false, Flag = "GograExtraction", Callback = function(ch)
    local ci = type(ch) == "table" and ch[1] or ch
    aD.options.extractionMode = ci:lower()
  end})
  cc.hideMode = cb:CreateDropdown({Name = "Hide travel", Options = {"Tween"}, CurrentOption = {"Tween"},
    MultipleOptions = false, Flag = "GograHideTravel", Callback = function(ch)
    local ci = type(ch) == "table" and ch[1] or ch
    aD.options.hideMode = ci:lower()
  end})
  local function ch(ci, cj, ck)
    cc[cj] = ci:CreateToggle({Name = ck, CurrentValue = aD.options[cj], Flag = "Gogra_" .. cj, Callback = function(cl)
      aD.options[cj] = cl == true
    end})
  end
  ch(cb, "antiDandy", "Buy from Dandy · bandages / medkits first")
  ch(cb, "antiAFK", "Anti-AFK · also active while paused")
  ch(cb, "autoReturnLobby", "Return to lobby after death")
  ch(cb, "useConsumables", "Automatically use useful items")
  ch(cb, "autoCards", "Automatically vote for floor cards")
  ch(cb, "autoBarnaby", "Auto Barnaby · glide through gaps")
  ch(cb, "barnabyCoins", "Collect Barnaby coins while gliding")
  local ci = ca:CreateTab("Safety & flow", "shield")
  ci:CreateLabel("Generator travel follows supported floors, ramps and stairs")
  ch(ci, "prioritizeSafety", "Prioritize safety · evade imminent contact")
  ch(ci, "autoCheapestShop", "Auto-buy Dandy item · heals first")
  ch(ci, "autoPuddleQuest", "Auto step in puddles · Ribecca Quest")
  ci:CreateLabel("Visits ordinary map puddles once per floor when safe · Finn's puddles stay blocked")
  ci:CreateLabel("Affordable Health Kits and Bandages take priority · otherwise buys the cheapest item · once per shop")
  ci:CreateLabel("Safety priority avoids contact; the Encounter toggle controls the floor-end sweep")
  ci:CreateLabel("Hold only after cover is verified · failed entry triggers local recovery")
  cc.afterHide = ci:CreateDropdown({Name = "After hiding", Options = {"Same generator", "Next safe generator"},
    CurrentOption = {"Same generator"}, MultipleOptions = false, Flag = "GograAfterHide", Callback = function(cj)
    local ck = type(cj) == "table" and cj[1] or cj
    aD.options.afterHide = ck == "Same generator" and "same" or "next"
  end})
  cc.coverPreference = ci:CreateDropdown({Name = "Cover preference", Options = {"Wall behind generator",
    "Nearest verified object"}, CurrentOption = {"Wall behind generator"}, MultipleOptions = false, Flag = "GograCoverPreference",
    Callback = function(cj)
    local ck = type(cj) == "table" and cj[1] or cj
    aD.options.coverPreference = ck == "Nearest verified object" and "nearest" or "wall"
  end})
  ch(ci, "stuckElevatorReset", "Reset at elevator after repeated movement blocks")
  ci:CreateLabel("Last resort: 3 blocked retries + 8s without progress · 45s cooldown · keeps the current task")
  cc.stuckTimeout = ci:CreateSlider({Name = "Stuck recovery delay", Range = {1, 5}, Increment = 0.5, Suffix = "s",
    CurrentValue = 2.5, Flag = "GograStuckTimeout", Callback = function(cj)
    aD.options.stuckTimeout = cj
  end})
  cc.clearDelay = ci:CreateSlider({Name = "Clear window before leaving cover", Range = {0.2, 3}, Increment = 0.1,
    Suffix = "s", CurrentValue = 0.5, Flag = "GograClearDelay", Callback = function(cj)
    aD.options.clearDelay = cj
  end})
  cc.resumeDistance = ci:CreateSlider({Name = "Twisted distance before resuming generator", Range = {50,
    60}, Increment = 1, Suffix = "studs", CurrentValue = 55, Flag = "GograResumeDistance", Callback = function(cj)
    aD.options.resumeDistance = cj
  end})
  ci:CreateButton({Name = "Recover into nearby cover now", Callback = function()
    if aD.nav then
      local cj = aD.nav
      cj.interrupt()
      task.defer(function()
        if aD.nav == cj then
          cj.hide("tween")
        end
      end)
    end
  end})
  local cj = ca:CreateTab("Items", "backpack")
  ch(cj, "autoLoot", "Automatically collect selected items")
  cc.itemPickupMode = cj:CreateDropdown({Name = "Pickup mode", Options = {"Slide pickup", "Stand pickup"},
    CurrentOption = {aD.options.itemPickupMode == "stand" and "Stand pickup" or "Slide pickup"}, MultipleOptions = false,
    Flag = "GograPickupMode", Callback = function(ck)
    local cl = type(ck) == "table" and ck[1] or ck
    aD.options.itemPickupMode = cl == "Stand pickup" and "stand" or "slide"
  end})
  cj:CreateLabel("Selected items use tween movement · interrupted items stay selected")
  ch(cj, "autoMachineItems", "Use machine-only items while extracting")
  ch(cj, "drainStaminaItems", "Spend stamina safely before cola and chocolates")
  ch(cj, "autoHalloweenDoors", "Automatically open Halloween doors")
  ch(ci, "machineFromCover", "Extract from cover when the native prompt stays in range")
  cc.itemSweepBudget = cj:CreateSlider({Name = "Item pass limit (0 finishes the pass)", Range = {0, 90},
    Increment = 5, Suffix = "s", CurrentValue = 0, Flag = "GograItemBudget", Callback = function(ck)
    aD.options.itemSweepBudget = ck
  end})
  cj:CreateLabel("Confirms pickup arrival · saves machine items, including Stopwatch, for extraction")
  local function ck()
    if aD.extras then
      return aD.extras.itemNames()
    end
    local cl, cm = {}, {}
    local cn = g:FindFirstChild("ItemModules")
    if cn then
      for co, cr in ipairs(cn:GetChildren()) do
        if cr:IsA("ModuleScript") then
          cm[cr.Name] = true
        end
      end
    end
    for co, cr in ipairs({"Pumpkin", "Tape", "Tapes"}) do
      cm[cr] = true
    end
    for co in pairs(cm) do
      if not co:lower():find("capsule", 1, true) then
        cl[#cl + 1] = co
      end
    end
    table.sort(cl)
    return cl
  end
  local function cl()
    local cm = {}
    for cn, co in pairs(aD.options.selectedItems) do
      if co then
        cm[#cm + 1] = cn
      end
    end
    table.sort(cm)
    return cm
  end
  cc.selectedItems = cj:CreateDropdown({Name = "Item selection", Options = ck(), CurrentOption = cl(),
    MultipleOptions = true, Flag = "GograSelectedItems", Callback = function(cm)
    local cn = {}
    for co, cr in ipairs(cm) do
      cn[cr] = true
    end
    aD.options.selectedItems = cn
  end})
  cj:CreateButton({Name = "Refresh item list from this floor", Callback = function()
    cc.selectedItems:Refresh(ck(), cl())
  end})
  local cm = ca:CreateTab("Auto Capsules", "flask-conical")
  ch(cm, "autoCapsules", "Auto Capsules · teleport, collect and return")
  local function cn()
    if aD.extras then
      return aD.extras.capsuleNames()
    end
    local co = {"All Twisteds"}
    local cr = g:FindFirstChild("MonsterData")
    if cr then
      for cu, cw in ipairs(cr:GetChildren()) do
        if cw:IsA("ModuleScript") then
          co[#co + 1] = cw.Name:gsub("Monster$", "")
        end
      end
    end
    table.sort(co, function(cu, cw)
      if cu == "All Twisteds" then
        return true
      elseif cw == "All Twisteds" then
        return false
      end
      return cu < cw
    end)
    return co
  end
  local function co()
    local cr = {}
    for cu, cw in pairs(aD.options.selectedCapsuleTwisteds) do
      if cw then
        cr[#cr + 1] = cu
      end
    end
    table.sort(cr)
    return cr
  end
  cc.selectedCapsuleTwisteds = cm:CreateDropdown({Name = "Capsules for these Twisteds", Options = cn(),
    CurrentOption = co(), MultipleOptions = true, Flag = "GograCapsuleTwisteds", Callback = function(cr)
    local cu = {}
    for cw, cx in ipairs(cr) do
      cu[cx] = true
    end
    if #cr > 1 and cu["All Twisteds"] then
      if aD.options.selectedCapsuleTwisteds["All Twisteds"] then
        cu["All Twisteds"] = nil
      else
        cu = {["All Twisteds"] = true}
      end
      task.defer(function()
        if aD.options.selectedCapsuleTwisteds == cu and cc.selectedCapsuleTwisteds then
          local cw = {}
          for cx in pairs(cu) do
            cw[#cw + 1] = cx
          end
          table.sort(cw)
          cc.selectedCapsuleTwisteds:Set(cw)
        end
      end)
    end
    aD.options.selectedCapsuleTwisteds = cu
  end})
  cm:CreateLabel("Collects selected research separately from normal items · returns to your previous position and task")
  cm:CreateButton({Name = "Refresh Twisted list", Callback = function()
    cc.selectedCapsuleTwisteds:Refresh(cn(), co())
  end})
  local cr = ca:CreateTab("Encounters", "eye")
  ch(cr, "researchMode", "Encounter all Twisteds before returning")
  ch(cr, "waitForMadness", "Wait for madness enemies to start walking")
  ch(cr, "researchNotifications", "Notify when native research increases")
  ch(cr, "encounterNotifications", "Notify which Twisted was encountered")
  cr:CreateLabel("Teleport into sight · detection or chase completes encounter · return to elevator")
  local cu = cr:CreateLabel("Native chase and research events confirm encounters")
  cr:CreateButton({Name = "Skip remaining encounters on this floor", Callback = function()
    if aD.extras then
      aD.extras.skip = true
      aD.extras.holding = false
    end
    aD.researchActive = false
    aD.postActive = false
    if aD.nav then
      aD.nav.interrupt()
    end
  end})
  local cw = ca:CreateTab("ESP", "scan-eye")
  for cx, cy in ipairs({{"espEnabled", "Enable ESP"}, {"espPlayers", "Players"}, {"espMonsters", "Twisteds"},
      {"espMachines", "Machines"}, {"espItems", "Items and holiday pickups"}, {"espElevator", "Elevator"},
      {"espShop", "Dandy shop"}, {"espHazards", "Blot hands, Sprout attacks and puddles"}}) do
    ch(cw, cy[1], cy[2])
  end
  ch(cw, "espResearch", "Twisted research percentage and session gains")
  ch(cw, "espThreatDetails", "Twisted chase state, speed and Gourdy madness")
  ch(cw, "espCharacterOutlines", "Player and Twisted outlines")
  ch(cw, "espAbilityCooldowns", "Ability countdowns above Twisted heads")
  cw:CreateLabel("~ = estimated from an observed cast · unknown until a cast is seen")
  cw:CreateLabel("Common: gray · Uncommon: green · Rare: blue · Main: purple · LETHAL: red")
  cc.espDistance = cw:CreateSlider({Name = "ESP distance", Range = {100, 2000}, Increment = 50, Suffix = "studs",
    CurrentValue = 800, Flag = "GograESPDistance", Callback = function(cx)
    aD.options.espDistance = math.clamp(cx, 100, 2000)
  end})
  aD.sponsor = ac({window = ca, settings = ad, initial = aC})
  local cx = ca:CreateTab("Configs", "save")
  local cy = ca:CreateTab("Reports", "message-square")
  cy:CreateLabel("Automatic reports contain technical run diagnostics · bug reports and suggestions use separate channels")
  ch(cy, "automaticDiagnostics", "Automatic error and death diagnostics")
  local cA = cy:CreateLabel("Ready · one submission per minute per form")
  local cB, cC = "", 0
  local cD, cE, cF = "", "", ""
  cy:CreateInput({Name = "Discord username · required", CurrentValue = "", PlaceholderText = "your.username or Username#1234",
    RemoveTextAfterFocusLost = false, Flag = "GograReportDiscord", Callback = function(cI)
    cF = tostring(cI)
  end})
  cy:CreateLabel("Your entered Discord username is sent with your bug report or suggestion for follow-up")
  cy:CreateSection("Bug report")
  cy:CreateInput({Name = "Describe the bug", CurrentValue = "", PlaceholderText = "What happened? What should have happened?",
    RemoveTextAfterFocusLost = false, Flag = "GograBugText", Callback = function(cI)
    cD = tostring(cI)
  end})
  cy:CreateButton({Name = "Send bug report", Callback = function()
    local cI, cJ = aD.diagnostics.submit("bug", cD, cF)
    cB, cC = cJ, os.clock() + 5
    cA:Set(cJ)
    if cI then
      cD = ""
    end
  end})
  cy:CreateSection("Suggestion")
  cy:CreateInput({Name = "Write a suggestion", CurrentValue = "", PlaceholderText = "What would you like improved?",
    RemoveTextAfterFocusLost = false, Flag = "GograSuggestionText", Callback = function(cI)
    cE = tostring(cI)
  end})
  cy:CreateButton({Name = "Send suggestion", Callback = function()
    local cI, cJ = aD.diagnostics.submit("suggestion", cE, cF)
    cB, cC = cJ, os.clock() + 5
    cA:Set(cJ)
    if cI then
      cE = ""
    end
  end})
  local cI = ca:CreateTab("Elevator", "arrow-up")
  ch(cI, "avoidTimeCards", "Ignore all Time's Up cards")
  ch(cI, "soloRun", "Return to lobby if another player is in the run")
  local cJ = "Default"
  cx:CreateInput({Name = "Config name", CurrentValue = "Default", PlaceholderText = "Default", RemoveTextAfterFocusLost = false,
    Flag = "GograConfigName", Callback = function(cL)
    cJ = cL
  end})
  local cL = aD.ConfigNames()
  if #cL == 0 then
    cL = {"Default"}
  end
  local cM = cx:CreateDropdown({Name = "Saved configs", Options = cL, CurrentOption = {cL[1]}, MultipleOptions = false,
    Flag = "GograSavedConfig", Callback = function(cM)
    cJ = type(cM) == "table" and cM[1] or cM
  end})
  local function cN(cO)
    local cQ, cT = pcall(cO)
    if not cQ then
      aN("Config · " .. tostring(cT))
    end
  end
  cx:CreateButton({Name = "Save config", Callback = function()
    cN(function()
      aD.SaveConfig(cJ)
      cM:Refresh(aD.ConfigNames(), {cJ})
    end)
  end})
  cx:CreateButton({Name = "Load config", Callback = function()
    cN(function()
      aD.LoadConfig(cJ)
    end)
  end})
  cx:CreateButton({Name = "Autoload selected config", Callback = function()
    cN(function()
      aD.autoload.configure(cJ, true)
    end)
  end})
  cx:CreateButton({Name = "Disable config autoload", Callback = function()
    cN(function()
      aD.autoload.configure(aD.autoload.name or cJ, false)
    end)
  end})
  aD.autoloadStartToggle = cx:CreateToggle({Name = "Start Autofarm with autoload", CurrentValue = true,
    Flag = "GograAutoloadStart", Callback = function(cO)
    if aD.autoloadStartSync then
      return
    end
    cN(function()
      if aD.autoload.name then
        aD.autoload.configure(aD.autoload.name, aD.autoload.enabled, cO == true)
      else
        aD.autoload.startAutofarm = cO == true
      end
    end)
  end})
  aD.autoloadLabel = cx:CreateLabel("Autoload: checking startup selection")
  cx:CreateButton({Name = "Refresh saved configs", Callback = function()
    cM:Refresh(aD.ConfigNames(), {cJ})
  end})
  aD.syncUI = function()
    aD.selection.syncUI()
    local cO = {farmMode = {normal = "Normal", faster = "Faster farming"}, machineMoveMethod = {auto = "Auto",
      teleport = "Teleport", tween = "Tween"}, extractionMode = {instant = "Instant", perfect = "Perfect",
      normal = "Normal"}, hideMode = {teleport = "Teleport", tween = "Tween"}, afterHide = {next = "Next safe generator",
      same = "Same generator"}, coverPreference = {wall = "Wall behind generator", nearest = "Nearest verified object"},
      itemMoveMethod = {teleport = "Teleport + tween fallback", tween = "Tween"}, itemPickupMode = {slide = "Slide pickup",
      stand = "Stand pickup"}}
    for cQ, cT in pairs(cc) do
      if cQ == "selectedItems" then
        cT:Set(cl())
      elseif cQ == "selectedCapsuleTwisteds" then
        cT:Set(co())
      elseif cO[cQ] then
        cT:Set({cO[cQ][aD.options[cQ]]})
      else
        cT:Set(aD.options[cQ])
      end
    end
  end
  cb:CreateButton({Name = "Retry teleport on this floor", Callback = function()
    aD.teleportPolicy.disabled = false
    aD.teleportPolicy.elevatorDisabled = false
    aD.teleportPolicy.failures = 0
    aN("Teleport retry enabled · next safe machine trip will test arrival")
  end})
  cb:CreateButton({Name = "Print diagnostics", Callback = function()
    print("GOGRA_AUTOFARM_STATUS", game:GetService("HttpService"):JSONEncode(aD.Snapshot()))
  end})
  cb:CreateButton({Name = "Unload", Callback = aD.Destroy})
  aD.uiUpdate = function()
    aD.selection.refreshUI()
    aD.autoloadLabel:Set("Autoload: " .. tostring(aD.autoload.name or "none") .. " · " .. tostring(aD.autoload.lastError or aD.autoload.state))
    cA:Set(os.clock() < cC and cB or aD.diagnostics.stats.last .. " · Sent " .. aD.diagnostics.stats.sent .. " · Pending " .. aD.diagnostics.stats.queued)
    cd:Set(aD.status)
    local cO = workspace:FindFirstChild("Info")
    ce:Set(aD.lobby.isLobby() and (aD.lobbyStatus or "waiting for game") or string.format("Floor %s · Health %s · Machines %s/%s", tostring(aE(cO, "Floor", 0)), tostring(aI()), tostring(aE(cO, "GeneratorsCompleted", 0)), tostring(aE(cO, "RequiredGenerators", 0))))
    local cQ = aD.nav and aD.nav.stats or {}
    cf:Set("Travel: " .. tostring(cQ.machineTravelMethod or aD.options.machineMoveMethod) .. " · Teleports " .. tostring(cQ.teleports or 0) .. " · Corrections " .. tostring(cQ.corrections or 0))
    local cT = aD.extras
    cu:Set(cT and string.format("Confirmed %s · Current %s · Pickups %s", tostring(cT.stats.observed), cT.current and cT.current.Name or "none", tostring(cT.stats.pickups)) or "Waiting for autofarm")
    local cW = cT and cT.shop.stats
    cg:Set(cW and ("Dandy shop: " .. tostring(cW.lastReason or "waiting") .. " · Purchases " .. tostring(cW.bought)) or "Dandy shop: waiting")
  end
end)

if not ca then
  if aD.diagnostics then
    aD.diagnostics.capture("ui-error", tostring(cb), true)
  end
  aD.Destroy()
  error("Rayfield could not load: " .. tostring(cb), 0)
end

aD.events[#aD.events + 1] = i.InputBegan:Connect(function(cc, cd)
  if not cd and not i:GetFocusedTextBox() and cc.KeyCode == Enum.KeyCode.F6 then
    bO:Set(not aD.enabled)
  end
end)

if not aD.returning then
  aN((aD.startPaused or aA == false) and (aD.cover.active and "Paused inside cover · F6 resumes autofarm" or "Paused · F6 resumes autofarm") or (aD.ReadyForAutofarm() and "Ready · F6 toggles autofarm" or "waiting for game"))
end

aD.researchNotices = {}
aD.nextResearchNotice = 0

aD.progress = al({clock = os.clock, folder = function()
  local cc = g:FindFirstChild("PlayerData")
  cc = cc and (cc:FindFirstChild(tostring(k.UserId)) or cc:FindFirstChild(k.Name))
  return cc and cc:FindFirstChild("Research")
end, known = function(cc)
  local cd = g:FindFirstChild("MonsterData")
  return cd and cd:FindFirstChild(cc) ~= nil
end, onGain = function(cc, cd, ce)
  if not aD.options.researchNotifications then
    return
  end
  local cf = aD.researchNotices[cc] or {delta = 0}
  cf.delta += cd
  cf.total = ce
  aD.researchNotices[cc] = cf
end})

function aD.flushResearchNotice()
  if os.clock() < aD.nextResearchNotice then
    return
  end
  local cc, cd = next(aD.researchNotices)
  if not cc then
    return
  end
  aD.researchNotices[cc] = nil
  aD.nextResearchNotice = os.clock() + 0.8
  if not aD.options.researchNotifications then
    return
  end
  local ce = (cd.total >= 100 and "Research complete · " or "Research gained · ") .. cc:gsub("Monster$", "")
  a7:Notify({Title = ce, Content = string.format("+%g%% research · %g%% total", cd.delta, cd.total),
    Duration = 5, Image = "search"})
end

aD.progress.step()
aD.esp = as({state = aD, character = aF, room = aG})

do
  local cc, cd = aD.autoload.restore()
  aD.autoloadStartSync = true
  pcall(function()
    aD.autoloadStartToggle:Set(aD.autoload.startAutofarm)
  end)
  aD.autoloadStartSync = false
  if not cc then
    warn("[Gogra Autofarm] Config autoload: " .. tostring(cd))
  elseif aD.pendingConfig then
    aD.ApplyPendingConfig()
  end
end

print("[Gogra Autofarm] Loaded v" .. aD.version .. " · F6 toggles · auto-hide always enabled")

if not aD.returning and aA ~= false and ((aD.autoload.enabled and aD.autoload.startAutofarm and aD.autoload.state ~= "Error") or not aD.startPaused and (aA == true or aA == nil and e.GograAutofarmAutoStart == true)) then
  aD.SetEnabled(true)
end
