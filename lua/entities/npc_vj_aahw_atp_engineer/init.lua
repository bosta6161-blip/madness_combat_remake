AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100
ENT.Weapon_Disabled = false   -- Disable the ability for it to use weapons
ENT.Weapon_IgnoreSpawnMenu = false  -- Should it ignore weapon overrides from the spawn menu?
ENT.BloodDecal = {"VJ_AAWH_GRUNT_YELLOW_BLOOD"}

------ Grenade Attack ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasGrenadeAttack = true 
ENT.GrenadeAttackEntity = "obj_vj_grenade" -- Entities that it can spawn when throwing a grenade | If set as a table, it picks a random entity | VJ: "obj_vj_grenade" | HL2: "npc_grenade_frag"
ENT.GrenadeAttackMinDistance = 400 -- Min distance an enemy must be to initiate a grenade attack
ENT.GrenadeAttackMaxDistance = 1500 -- Max distance an enemy must be to initiate a grenade attack
ENT.GrenadeAttackChance = 1-- 1 in x chance that it will throw a grenade when all the requirements are met | 1 = Throw it every time
ENT.GrenadeAttackModel = false -- Overrides the grenade model | Can be string or table | Does NOT apply to picked up grenades and forced grenade attacks with custom entity
ENT.GrenadeAttackAttachment = -1 -- The attachment that the grenade will be set to | -1 = Skip to use "self.GrenadeAttackBone" instead
ENT.GrenadeAttackBone = "ValveBiped.Bip01_R_Hand" -- The bone that the grenade will be set to | -1 = Skip to use fail safe instead
	-- ====== Animation ====== --
ENT.AnimTbl_GrenadeAttack = "punch01" -- Animations to play when it throws a grenade | false = Don't play an animation
ENT.GrenadeAttackAnimationFaceEnemy = true -- Should it face the enemy while playing an grenade attack animation?
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.totalDamage = {}
	self.GetDamageType = {} --need to gib work
	self.gib_type = "ok"
	self.is_yellow_blood = true 
	self.protect = true
	self:SetBodygroup(2, 3)
	self:SetSkin(2)
end
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	local damageForce = dmginfo:GetDamageForce():Length()
	self.Bleeds = true
	if self.protect == true and damageForce < 15000 then
		if hitgroup == 13 or hitgroup == 16 or hitgroup == 17 then
     		self.Bleeds = false -- Disable bleeding temporarily when shot at the helmet
			local dmg = dmginfo:GetDamage()/2.5
			dmginfo:SetDamage(dmg)
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
