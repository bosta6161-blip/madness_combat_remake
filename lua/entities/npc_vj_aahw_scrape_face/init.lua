AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 400
ENT.VJ_IsHugeMonster = false -- Is this a huge monster?
ENT.HullType = HULL_HUMAN
ENT.HasHull = true -- Set to false to disable HULL
ENT.HullSizeNormal = true -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = true -- set to false to disable SetSolid
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle, etc.)
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.HasBloodDecal = true -- Does it spawn a decal when damaged?
ENT.HasBloodPool = false -- Does it have a blood pool?
ENT.BloodDecal = {"VJ_AAWH_GRUNT_BLOOD"}
ENT.CanOpenDoors = true -- Can it open doors?
ENT.VJ_NPC_Class = {"CLASS_ERROR"} -- NPCs with the same class with be allied to each other
ENT.Behavior = VJ_BEHAVIOR_AGGRESSIVE
ENT.EnemyXRayDetection = true  -- Can it detect enemies through walls & objects?
ENT.ControllerParams = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "head", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(10,0,15), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}
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
ENT.IdleDialogueDistance = 1000 -- How close should an ally be for it to initiate a dialogue
ENT.SightDistance = 18000 -- Initial sight distance | To retrieve: "self:GetMaxLookDistance()" | To change: "self:SetMaxLookDistance(distance)"
--------------------------------------------------------------------------------------------------------------

	-- ====== Corpse Variables ====== --
ENT.HasDeathRagdoll = false -- If set to false, it will not spawn the regular ragdoll of the SNPC


ENT.SoundTbl_Idle = {"hl1/ambience/signalgear1.wav"}
ENT.SoundTbl_MeleeAttack = {"ambient/voices/squeal1.wav","ambient/creatures/town_child_scream1.wav","npc/stalker/go_alert2.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"grunt/punch/swoosh1.wav","grunt/punch/swoosh2.wav","grunt/punch/swoosh3.wav","grunt/punch/swoosh4.wav"}
ENT.SoundTbl_Pain = {"npc/zombie/zombie_alert3.wav","npc/zombie/zombie_voice_idle11.wav"}

	-- ====== Dismemberment/Gib Variables ====== --
ENT.AllowedToGib = true -- Is it allowed to gib in general? This can be on death or when shot in a certain place
ENT.HasGibOnDeath = true -- Is it allowed to gib on death?
ENT.GibOnDeathDamagesTable = {"All"} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
ENT.HasGibOnDeathSounds = true -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibDeathParticles = true -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu

ENT.RunAwayOnUnknownDamage = true -- Should run away on damage
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"walk"} -- Melee Attack Animations
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 100 -- How far does the damage go?
ENT.MeleeAttackAnimationAllowOtherTasks = false 
ENT.TimeUntilMeleeAttackDamage = 0 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0	 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 100
ENT.MeleeAttackDamageType = DMG_BLAST
ENT.CanFlinch = 0 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
		return self:GetSequenceActivity(self:LookupSequence("run_scrape")) -- your activity here
end
function ENT:CustomOnInitialize()
	self:SetBodygroup(1,7)
	bonemerge_prop_on_npc("models/noob_dev2323/madness/npc/scrape_face.mdl",self)
end
function ENT:CustomOnThink_AIEnabled()
	local explodetime = GetConVarNumber("vj_madness_scrape_face_explodetime")
	timer.Simple(0 + explodetime, function()
		if IsValid(self) then
			self:TakeDamage(self:Health(), attacker, attacker)
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if GetConVar("vj_madness_gore"):GetBool() then
		local Vel = self:GetRight()*math.Rand(-1000,1000)+self:GetForward()*math.Rand(-1000,10) 
		if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
			bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			bloodeffect:SetScale(50)
			util.Effect("VJ_Blood1",bloodeffect)
		end
		for i=1,math.random(4,8) do 
			self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
			self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
		end
		self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk2.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("2")).Pos,Ang=self:GetAngles(),Vel=vel})
		self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk1.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("5")).Pos,Ang=self:GetAngles(),Vel=vel})
		self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk6.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("4")).Pos,Ang=self:GetAngles(),Vel=vel})
		self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk4.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos,Ang=self:GetAngles(),Vel=vel})
		self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk5.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos,Ang=self:GetAngles(),Vel=vel})
		self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk3.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head")).Pos,Ang=self:GetAngles(),Vel=vel})
		return true
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/