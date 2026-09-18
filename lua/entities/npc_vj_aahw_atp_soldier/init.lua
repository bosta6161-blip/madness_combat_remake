AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 150
ENT.BloodDecal = {"VJ_AAWH_GRUNT_YELLOW_BLOOD"}
ENT.BloodColor = "Yellow" -- Its blood type, this will determine the blood decal, particle, etc.
ENT.HealthRegenParams = {
	Enabled = true , -- Can it regenerate its health?
	Amount = 3, -- How much should the health increase after every delay?
	Delay = VJ.SET(1,1.5), -- Delay between each regeneration
	ResetOnDmg = true, -- Should the delay reset when it receives damage?
}
include( "noob_dev2323/madness_combat/grunt_range_script.lua" ) --include gore script
ENT.MeleeAttackDamage = 25
-- Custom
ENT.MaxAmmo = 45
ENT.Reloading = false
ENT.ReloadTime = 2.0 
ENT.grunt_hold_type = "pistol"


ENT.grunt_no_pain_animation = true
ENT.grunt_hold_type = "pistol"
ENT.NextRangeAttackTime = 0 --grunt time delay
ENT.madness_weapon_status = {
    damege = 3,
    force = 5,
    amount = 1,
    spread = Vector(0.04, 0.05, 0.04),
	custom_gun_sound = "noob_dev2323/madness/weapons/MP5k.wav",
	attachment = "shot2"
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.gib_type = "ok"	
	self.is_yellow_blood = true 
	self:SetBodygroup(2, 2)
	self:SetSkin(2)
	bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_mp5.mdl",self)
    self.CurrentAmmo = 45
end

function ENT:CustomOnKilled(dmginfo,hitgroup)
    self:Give("weapon_aahw_mp5")
    self:DropWeapon()
end
---------------------------------------------------------------------------------------------------------------------------------------------
	-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
