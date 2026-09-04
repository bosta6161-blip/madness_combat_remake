AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 115 

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_bullet_shotgunbullet" -- The entity that is spawned when range attacking
ENT.AnimTbl_RangeAttack = {"vjges_weaponshotg"} -- Range Attack Animations
ENT.RangeDistance = 5000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 80 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?

ENT.NoChaseAfterCertainRange = true
ENT.NoChaseAfterCertainRange_FarDistance = 3000 
ENT.NoChaseAfterCertainRange_CloseDistance = 1 
ENT.NoChaseAfterCertainRange_Type = "Regular"
ENT.NextRangeAttackTime = 0.5


ENT.RangeAttackSoundLevel = 100

-- Custom
ENT.AAHW_NextRunT = 0
ENT.MaxAmmo = 8
ENT.CurrentAmmo = 8
ENT.Reloading = false
ENT.ReloadTime = 2.0 
ENT.grunt_no_pain_animation = true
ENT.grunt_hold_type = "pistol"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.gib_type = "ok"
	self:SetBodygroup(2, 1)
	self:SetSkin(1) 
	bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_glock_20.mdl",self)
    self.CurrentAmmo = 12
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
    if self.VJ_IsBeingControlled or self.IsGuard or self.Dead then return end

-- should reload the moment there is no enemy or killed the enemy
    local enemy = self:GetEnemy()

    if not IsValid(enemy) then
        if not self.Reloading and self.CurrentAmmo < self.MaxAmmo then
            self:StartReload()
        end
    end

-- Movement
    if IsValid(enemy) and CurTime() > self.AAHW_NextRunT then
        timer.Simple(math.Rand(0.2, 0.5), function() 
            if IsValid(self) && !self:IsMoving() && !self.Dead then
                self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH")
            end
        end)

        self.AAHW_NextRunT = CurTime() + math.Rand(1.5, 2.5)
    end
end

