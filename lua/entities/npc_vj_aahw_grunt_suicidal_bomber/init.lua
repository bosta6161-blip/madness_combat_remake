AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 30
ENT.VJ_NPC_Class = {"CLASS_AAHW"} -- NPCs with the same class with be allied to each other
ENT.Weapon_Disabled = true  -- Disable the ability for it to use weapons
ENT.MeleeAttackDistance = 79 -- How close does it have to be until it attacks?
ENT.self_bomb = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.totalDamage = {}
	self.GetDamageType = {} --need to gib work
	self.gib_type = "ok"
	self.MeleeAttackDamage = 0
	bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_bombsuit.mdl",self)
end
function ENT:OnMeleeAttack(status, enemy) 
	if IsValid(self) then
		VJ.EmitSound(self, "VJ.Explosion")
		util.BlastDamage(self, self, self:GetPos(), 200, 40)
		util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
		if self.HasGibOnDeathEffects then ParticleEffect("vj_explosion2",self:GetPos(), Angle(0, 0, 0)) end
	end
end
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if GetConVar("vj_madness_gore"):GetInt() == 0 then return end
	if dmginfo:GetDamageType() == DMG_BLAST then
		if IsValid(self) then
			VJ.EmitSound(self, "VJ.Explosion")
			util.BlastDamage(self, self, self:GetPos(), 200, 40)
			util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
			if self.HasGibOnDeathEffects then ParticleEffect("vj_explosion2",self:GetPos(), Angle(0, 0, 0)) end
		end 
	end 
	if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
			bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			bloodeffect:SetScale(50)
			util.Effect("VJ_Blood1",bloodeffect)
	end
	for i=1,math.random(6,15) do 
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
	end
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
