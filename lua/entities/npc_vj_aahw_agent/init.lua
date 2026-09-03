AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 115 

ENT.ConstantlyFaceEnemy = true
ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.AnimTbl_RangeAttack = {"vjges_shoot"} -- Range Attack Animations
ENT.RangeDistance = 5000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 80 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?

ENT.NoChaseAfterCertainRange = true
ENT.NoChaseAfterCertainRange_FarDistance = 3000 
ENT.NoChaseAfterCertainRange_CloseDistance = 1 
ENT.NoChaseAfterCertainRange_Type = "Regular"
ENT.NextRangeAttackTime = 0

ENT.DisableFootStepSoundTimer = true -- If set to true, it will disable the time system for the footstep sound code, allowing you to use other ways like model events

//ENT.SoundTbl_RangeAttack = {"grunt/shoot1.wav"}
ENT.RangeAttackSoundLevel = 100

-- Custom
ENT.AAHW_NextRunT = 0
ENT.MaxAmmo = 0
ENT.CurrentAmmo = 0
ENT.Reloading = false
ENT.ReloadTime = 1.5 
ENT.grunt_no_pain_animation = true
ENT.grunt_hold_type = "pistol"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.gib_type = "ok"
	self:SetBodygroup(2, 1)
	self:SetSkin(1) 
	bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_glock_20.mdl",self)
    self.MaxAmmo = 12
    self.CurrentAmmo = 12
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
    if self.VJ_IsBeingControlled or self.IsGuard or self.Dead then return end

    -- Movement
    if IsValid(enemy) and CurTime() > self.AAHW_NextRunT then
        timer.Simple(math.Rand(0.2, 0.5), function() 
            if IsValid(self) 
            && !self:IsMoving() 
            && !self.Dead 
            && !self.IsDodging then 
                self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
            end
        end)

        self.AAHW_NextRunT = CurTime() + math.Rand(1.5, 2.5)
    end
end
function ENT:OnRangeAttack(status, enemy) 
    local enemy = self:GetEnemy()
    if not IsValid(enemy) then return end

    local attID = self:LookupAttachment("shot")


    local att = self:GetAttachment(attID)


    local bullet = {}
    bullet.Num = 1
    bullet.Src = att.Pos
    bullet.Dir = (enemy:BodyTarget(att.Pos) - att.Pos):GetNormalized()
    bullet.Tracer = 1
    bullet.TracerName = "Tracer"
    bullet.Spread = Vector(0.09, 0.09, 0.05)
    bullet.Damage = 5
    bullet.Force = 12
    VJ.EmitSound(self,"weapons/glock.wav", 80, 100)

    self:FireBullets(bullet) 

    ParticleEffectAttach("vj_rifle_full", PATTACH_POINT_FOLLOW, self, attID)
    print("bullet")
end