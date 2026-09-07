AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 90 

include( "noob_dev2323/madness_combat/grunt_range_script.lua" ) --include gore script

-- Custom
ENT.AAHW_NextRunT = 0
ENT.MaxAmmo = 12
ENT.Reloading = false
ENT.ReloadTime = 2.0 
ENT.grunt_no_pain_animation = true
ENT.grunt_hold_type = "pistol"

ENT.NextRangeAttackTime = 0.5 --grunt time delay

ENT.madness_weapon_status = {
    damege = 5,
    force = 10,
    amount = 1,
    spread = Vector(0.09, 0.09, 0.05)
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.gib_type = "ok"
	self:SetBodygroup(2, 1)
	self:SetSkin(1) 
	bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_glock_20.mdl",self)
    self.CurrentAmmo = 12
end