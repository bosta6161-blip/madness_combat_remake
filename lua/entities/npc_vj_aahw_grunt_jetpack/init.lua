AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/noob_dev2323/madness/npc/grunt_npc.mdl"
ENT.StartHealth = 60
ENT.SightAngle = 360
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Calm = 400
ENT.Aerial_FlyingSpeed_Alerted = 600
ENT.ControllerParams = {
	FirstP_Bone = "bip01 neck",
	FirstP_Offset = Vector(10, 0, -3),
}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.Bleeds = true -- Can it bleed? Controls all bleeding related components such blood decal, particle, pool, etc.
ENT.BloodColor = "red" -- Its blood type, this will determine the blood decal, particle, etc.
ENT.HasBloodDecal = true -- Should it spawn a decal when damaged?
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodDecal = {"VJ_AAWH_GRUNT_BLOOD"}
ENT.HasBloodPool = false  -- Should a blood pool spawn by its corpse?
ENT.ConstantlyFaceEnemy = true
ENT.HasMeleeAttack = false

ENT.HasRangeAttack = false 


ENT.LimitChaseDistance = true
ENT.LimitChaseDistance_Max = "UseRangeDistance"
ENT.LimitChaseDistance_Min = "UseRangeDistance"




ENT.Weapon_UnarmedBehavior = false   
ENT.Weapon_CanCrouchAttack = false  -- Can it crouch while firing a weapon?
ENT.AnimTbl_WeaponAttackCrouch = false  -- Animations to play while firing a weapon in crouched position
ENT.AnimTbl_WeaponAttack = ACT_IDLE_PISTOL -- Animations to play while firing a weapon
ENT.AnimTbl_WeaponAttackGesture = ACT_RANGE_ATTACK1   -- Gesture animations to play while firing a weapon | false = Don't play an animation
ENT.Weapon_CanMoveFire = true    -- Can it fire its weapon while it's moving

ENT.MainSoundPitch = 100

-- Custom

ENT.AlienC_FlyAnim_Forward = 0
ENT.AlienC_FlyAnim_Backward = 0
ENT.AlienC_FlyAnim_Right = 0
ENT.AlienC_FlyAnim_Left = 0
ENT.AlienC_FlyAnim_Up = 0
ENT.AlienC_FlyAnim_Down = 0

ENT.is_madness_combat_npc = true 
ENT.grunt_no_pain_animation = true
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:Give("weapon_vj_aahw_mp5")
	self.gib_type = "ok"
	bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_jetpack.mdl",self)
		self.AlienC_FlyAnim_Forward  = self:GetSequenceActivity(self:LookupSequence("forward"))
	self.AlienC_FlyAnim_Backward  = self:GetSequenceActivity(self:LookupSequence("backward"))
	self.AlienC_FlyAnim_Right  = self:GetSequenceActivity(self:LookupSequence("right"))
	self.AlienC_FlyAnim_Left  = self:GetSequenceActivity(self:LookupSequence("left"))
	self.AlienC_FlyAnim_Up  = self:GetSequenceActivity(self:LookupSequence("up"))
	self.AlienC_FlyAnim_Down  = self:GetSequenceActivity(self:LookupSequence("down"))
end

function ENT:TranslateActivity(act)
	if act == ACT_FLY then
		if self.AA_CurrentMovePosDir then
			local moveDir = self.AA_CurrentMovePosDir:GetNormal()
			-- Up-down
			local dotUp = moveDir:Dot(self:GetUp())
			if dotUp > 0.60 then
				return self.AlienC_FlyAnim_Up
			elseif dotUp < -0.60 then
				return self.AlienC_FlyAnim_Down
			end
			-- Forward-backward
			local dotForward = moveDir:Dot(self:GetForward())
			if dotForward > 0.5 then
				return self.AlienC_FlyAnim_Forward
			elseif dotForward < -0.5 then
				return self.AlienC_FlyAnim_Backward
			end
			-- Right-left
			local dotRight = moveDir:Dot(self:GetRight())
			if dotRight > 0.5 then
				return self.AlienC_FlyAnim_Right
			elseif dotRight < -0.5 then
				return self.AlienC_FlyAnim_Left
			end
		end
		return self.AlienC_FlyAnim_Up -- Fallback animation
	end
	return self.BaseClass.TranslateActivity(self, act)
end
