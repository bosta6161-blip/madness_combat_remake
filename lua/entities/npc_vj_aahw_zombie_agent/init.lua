AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.Model = {"models/noob_dev2323/madness/npc/zeds_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 90 
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other

ENT.is_madness_combat_npc = true 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.gib_type = "ok"
	self:SetBodygroup(2, 1)
	self:SetSkin(1) 
end
