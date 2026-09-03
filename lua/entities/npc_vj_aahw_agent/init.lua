AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60
ENT.grunt_status = {
	is_trained = false,
	no_pain = true,
	weapon = "pistol"
}

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
ENT.NextRangeAttackTime = 0.3


ENT.grunt_no_pain_animation = true
ENT.grunt_hold_type = "pistol"
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.gib_type = "ok"
	self:SetBodygroup(2, 1)
	self:SetSkin(1) 
	bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_glock_20.mdl",self)
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
end

---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
