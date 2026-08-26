AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/noob_dev2323/madness/npc/mag_torture_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 2500
ENT.HealthRegenParams = {
	Enabled = true , -- Can it regenerate its health?
	Amount = 10, -- How much should the health increase after every delay?
	Delay = VJ.SET(1,1.5), -- Delay between each regeneration
	ResetOnDmg = true, -- Should the delay reset when it receives damage?
}
ENT.JumpParams = {
	Enabled = true, -- Can it do movement jumps?
	MaxRise = 512, -- How high it can jump up ((S -> A) AND (S -> E))
	MaxDrop = 512, -- How low it can jump down (E -> S)
	MaxDistance = 1024, -- Maximum distance between Start (S) and End (E)
}
ENT.Weapon_Disabled = true   -- Disable the ability for it to use weapons

ENT.Bleeds = true -- Can it bleed? Controls all bleeding related components such blood decal, particle, pool, etc.
ENT.BloodColor = "red" -- Its blood type, this will determine the blood decal, particle, etc.
ENT.HasBloodDecal = true -- Should it spawn a decal when damaged?
ENT.BloodDecal = {"VJ_AAWH_GRUNT_BLOOD"}
ENT.HasBloodPool = false  -- Should a blood pool spawn by its corpse?

ENT.MeleeAttackDamageType = DMG_CLUB
ENT.AnimTbl_MeleeAttack = {"vjges_melee_attack_02"}
ENT.MeleeAttackDistance = 130-- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 150-- How far does the damage go?
ENT.MeleeAttackDamage = 55
ENT.MeleeAttackAnimationFaceEnemy = true-- Should it face the enemy while playing the melee attack animation?
ENT.HasMeleeAttackKnockBack = true -- Should knockback be applied on melee hit? | Use "MeleeAttackKnockbackVelocity" function to edit the velocity



ENT.Level = 1
ENT.aiai = false 
ENT.SoundTbl_FootStep = {"noob_dev2323/madness/grunt/foot_step.wav"}
ENT.HasWorldShakeOnMove = true 


ENT.SoundTbl_BeforeMeleeAttack = {"noob_dev2323/madness/mag/MAGAttack1.wav","noob_dev2323/madness/mag/MAGAttack2.wav","noob_dev2323/madness/mag/MAGAttack3.wav"}
ENT.SoundTbl_Death = {"noob_dev2323/madness/mag/MAGDEATHS - Trimmed (2).wav","noob_dev2323/madness/mag/MAGDEATHS - Trimmed (3).wav","noob_dev2323/madness/mag/MAGDEATHS - Trimmed.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------

function ENT:CustomOnInitialize()
	self.totalDamage = {}
	self.GetDamageType = {} --need to gib work
	self.gib_type = "ok"
	self:SetCollisionBounds(Vector(30, 30, 150), Vector(-25, -25, 0))
end

function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	local bones = {
		"r_upper_arm",
		"r_lower_arm",
		"l_upper_arm",
		"l_lower_arm",
	}
	for k, v in pairs( bones ) do
		local head_bone = corpseEnt:LookupBone(v)
		local bone = corpseEnt:TranslateBoneToPhysBone(head_bone)
		local colide = corpseEnt:GetPhysicsObjectNum( bone )
		colide:EnableCollisions(false)
	end
	if self.gib_head == true then
		local head_bone = corpseEnt:LookupBone("head")
		local bone = corpseEnt:TranslateBoneToPhysBone(head_bone)
		local colide = corpseEnt:GetPhysicsObjectNum( bone )
		colide:EnableCollisions(false)
	end
end
function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
    local damageForce = dmginfo:GetDamageForce():Length()
	local dmgType = dmginfo:GetDamageType()
    self.totalDamage[hitgroup] = (self.totalDamage[hitgroup] or 0) + damageForce

	if hitgroup == 2 and self.totalDamage[hitgroup] > 60000	 then    -- Dismember heads code
		if self:GetBodygroup(2) == 1 then
            return
        end	
		self:SetBodygroup(2, 1)
    end
end
function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() <= (self:GetMaxHealth() / 2.2) and self.is_madness_hurt ~= true then
		self.is_madness_hurt = true
		util.ScreenShake(self:GetPos(), 25, 15, 6, 3000)
		self:EmitSound( "noob_dev2323/madness/mag/MAGCHEERS - Trimmed.wav", 75, 100, 1, 136 )
	end
end
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	self.gib_head = true 

	if self.HasGibDeathParticles == true then
		local bloodeffect = EffectData()
		bloodeffect:SetOrigin(self:LocalToWorld(Vector(0,0,80)) +self:OBBCenter())
		bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
		bloodeffect:SetScale(100)
		util.Effect("VJ_Blood1",bloodeffect)
		
		
		local bloodspray = EffectData()
		bloodspray:SetOrigin(self:GetPos())
		bloodspray:SetScale(8)
		bloodspray:SetFlags(3)
		bloodspray:SetColor(0)
		util.Effect("bloodspray",bloodspray)
		util.Effect("bloodspray",bloodspray)
	end
	self:SetBodygroup(1, 1)
	self:SetBodygroup(2, 2)
	VJ_EmitSound(self, "vj_gib/gibbing1.wav")
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib02.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("2")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib01.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("5")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib02.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib02.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib01.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("4")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib01.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head")).Pos,Ang=self:GetAngles(),Vel=vel})

	self:SetBodygroup(5, 2)
end
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
