AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 100 --six seven six seven :/ 
ENT.HealthRegenParams = {
	Enabled = true , -- Can it regenerate its health?
	Amount = 2, -- How much should the health increase after every delay?
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
ENT.NextRangeAttackTime = 0 --grunt time delay
ENT.madness_bonemerge_prop = "models/noob_dev2323/madness/weapons/w_bombsuit.mdl"
ENT.madness_weapon_status = {
    damege = 3,
    force = 5,
    amount = 1,
    spread = Vector(0.04, 0.05, 0.04),
	custom_gun_sound = "noob_dev2323/madness/weapons/Silencer.wav",
	attachment = "shot4",
	noweaponflash = true
}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.gib_type = "ok"
	bonemerge_prop_on_npc("models/noob_dev2323/madness/weapons/w_h&k_mp5.mdl",self)
    bonemerge_prop_on_npc("models/noob_dev2323/madness/npc/w_glasses_body_guard.mdl",self)
    self.CurrentAmmo = 45
end
function ENT:CustomOnKilled(dmginfo,hitgroup)
    self:Give("weapon_aahw_glock_20")
    self:DropWeapon()
end