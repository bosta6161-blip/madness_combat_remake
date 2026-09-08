AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.VJ_NPC_Class = {"CLASS_AAHW"} -- NPCs with the same class with be allied to each other
ENT.MeleeAttackDistance = 130 -- How close does it have to be until it attacks?

ENT.grunt_no_pain_animation = true
ENT.grunt_no_stun = true 
ENT.grunt_is_melee = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.gib_type = "ok"
	self:EQUIP_A_MELEE_WEAPON()
end
function ENT:CustomOnTakeDamage_BeforeImmuneChecks(dmginfo, hitgroup)
	local damageForce = dmginfo:GetDamageForce():Length()
	self.Bleeds = true
	if damageForce < 15000 and math.random(1, 2) == 1 then
		if hitgroup == 13 or hitgroup == 16 or hitgroup == 17 then
     		self.Bleeds = false -- Disable bleeding temporarily when shot at the helmet
			dmginfo:SetDamage(1)
			
			self:VJ_ACT_PLAYACTIVITY("vjges_defense", false, 0, true, 0)

			local rico = EffectData()
			rico:SetOrigin(dmginfo:GetDamagePosition())
			rico:SetScale(4) -- Size
			util.Effect("vj_madness_combat_spark", rico)
			sound.Play("noob_dev2323/madness/melee/rico" .. math.random(1, 5) .. ".wav",self:GetPos(),75,100,1)
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
