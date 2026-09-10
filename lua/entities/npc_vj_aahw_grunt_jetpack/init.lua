AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 40
ENT.SightAngle = 360
ENT.HullType = HULL_HUMAN
ENT.MovementType = VJ_MOVETYPE_AERIAL
ENT.Aerial_FlyingSpeed_Calm = 400
ENT.Aerial_FlyingSpeed_Alerted = 600

include( "noob_dev2323/madness_combat/grunt_range_script.lua" ) --include gore script


-- Custom
ENT.AlienC_FlyAnim_Forward = 0
ENT.AlienC_FlyAnim_Backward = 0
ENT.AlienC_FlyAnim_Right = 0
ENT.AlienC_FlyAnim_Left = 0
ENT.AlienC_FlyAnim_Up = 0
ENT.AlienC_FlyAnim_Down = 0

ENT.is_madness_combat_npc = true 
ENT.grunt_no_pain_animation = true
ENT.HitGroupFlinching_Values = nil
ENT.madness_bonemerge_prop = "models/noob_dev2323/madness/weapons/w_jetpack.mdl"

ENT.AAHW_NextRunT = 0
ENT.MaxAmmo = 45
ENT.Reloading = false
ENT.ReloadTime = 2.0 
ENT.grunt_hold_type = "pistol"

ENT.madness_weapon_status = {
    damege = 3,
    force = 5,
    amount = 1,
    spread = Vector(0.09, 0.09, 0.09),
	custom_gun_sound = "noob_dev2323/madness/weapons/MP5k.wav"
}
ENT.RangeDistance = 2000 -- This is how far away it can shoot
ENT.NextRangeAttackTime = 0 --grunt time delay
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.gib_type = "ok"
	bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_jetpack.mdl",self)
	bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_mp5.mdl",self)
    self.CurrentAmmo = 45
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
