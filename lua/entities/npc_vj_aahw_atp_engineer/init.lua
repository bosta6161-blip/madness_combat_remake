AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100
ENT.BloodDecal = {"VJ_AAWH_GRUNT_YELLOW_BLOOD"}
ENT.BloodColor = "Yellow" -- Its blood type, this will determine the blood decal, particle, etc.

ENT.HealthRegenParams = {
	Enabled = true , -- Can it regenerate its health?
	Amount = 2, -- How much should the health increase after every delay?
	Delay = VJ.SET(1,1.5), -- Delay between each regeneration
	ResetOnDmg = true, -- Should the delay reset when it receives damage?
}
------ Grenade Attack ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = true 
ENT.GrenadeAttackEntity = "obj_vj_grenade" -- Entities that it can spawn when throwing a grenade | If set as a table, it picks a random entity | VJ: "obj_vj_grenade" | HL2: "npc_grenade_frag"
ENT.GrenadeAttackMinDistance = 400 -- Min distance an enemy must be to initiate a grenade attack
ENT.GrenadeAttackMaxDistance = 1500 -- Max distance an enemy must be to initiate a grenade attack
ENT.GrenadeAttackChance = 1-- 1 in x chance that it will throw a grenade when all the requirements are met | 1 = Throw it every time
ENT.GrenadeAttackModel = false -- Overrides the grenade model | Can be string or table | Does NOT apply to picked up grenades and forced grenade attacks with custom entity
ENT.GrenadeAttackAttachment = -1 -- The attachment that the grenade will be set to | -1 = Skip to use "self.GrenadeAttackBone" instead
ENT.GrenadeAttackBone = "R_hand" -- The bone that the grenade will be set to | -1 = Skip to use fail safe instead
	-- ====== Animation ====== --
ENT.AnimTbl_GrenadeAttack = "punch01" -- Animations to play when it throws a grenade | false = Don't play an animation
ENT.GrenadeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing an grenade attack animation?

include( "noob_dev2323/madness_combat/grunt_range_script.lua" ) --include gore script
ENT.RangeDistance = 1000 -- This is how far away it can shoot
ENT.AnimTbl_MeleeAttack = {"vjges_punch01","vjges_melee_attack_02"} -- Melee Attack Animations
-- Custom
ENT.AAHW_NextRunT = 0
ENT.MaxAmmo = 6
ENT.Reloading = false
ENT.ReloadTime = 2.0 

ENT.grunt_no_pain_animation = true
ENT.grunt_hold_type = "shotgun"
ENT.NextRangeAttackTime = 1 --grunt time delay
ENT.MeleeAttackDamage = 35
ENT.madness_weapon_status = {
    damege = 3,
    force = 20,
    amount = 12,
    spread = Vector(0.10,0.12,0.10),
	custom_gun_sound = "noob_dev2323/madness/weapons/mossberg.wav",
	attachment = "shot3"
}
ENT.HasMeleeAttackKnockBack = true  -- Should knockback be applied on melee hit? | Use "MeleeAttackKnockbackVelocity" function to edit the velocity
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.totalDamage = {}
	self.GetDamageType = {} --need to gib work
	self.gib_type = "ok"
	self.is_yellow_blood = true 
	self.protect = true
	self:SetBodygroup(2, 3)
	self:SetSkin(2)
	self:SetBodygroup(0, 1)
	bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_shotgun.mdl",self)
	self.CurrentAmmo = 6
	self.AnimTbl_RangeAttack = {"vjges_shotgun_shot"} -- Range Attack Animations
end
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	local damageForce = dmginfo:GetDamageForce():Length()
	self.Bleeds = true
	if self.protect == true and damageForce < 15000 then
		if hitgroup == 13 or hitgroup == 16 or hitgroup == 17 then
     		self.Bleeds = false -- Disable bleeding temporarily when shot at the helmet
			local dmg = dmginfo:GetDamage()/5
			dmginfo:SetDamage(dmg)
			local rico = EffectData()
			rico:SetOrigin(dmginfo:GetDamagePosition())
			rico:SetScale(4) -- Size
			rico:SetMagnitude(2) -- Effect type | 1 = Animated | 2 = Basic
			util.Effect("vj_madness_combat_spark", rico)
			sound.Play("noob_dev2323/madness/melee/rico" .. math.random(1, 5) .. ".wav",self:GetPos(),75,100,1)
		end
	end
end
function ENT:CustomOnKilled(dmginfo,hitgroup)
    self:Give("weapon_aahw_mossberg")
    self:DropWeapon()
end
function ENT:MeleeAttackKnockbackVelocity(hitEnt)
	return self:GetForward()*math.random(400, 400) + self:GetUp()*90
end
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
