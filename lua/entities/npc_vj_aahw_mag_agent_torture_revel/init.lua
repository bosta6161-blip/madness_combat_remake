AddCSLuaFile("shared.lua")
include('shared.lua')
ENT.Model = {"models/noob_dev2323/madness/npc/mag_torture_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 1500
ENT.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other

ENT.is_madness_combat_npc = true 
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self.totalDamage = {}
	self.GetDamageType = {} --need to gib work
	self.gib_type = "ok"
	self:SetCollisionBounds(Vector(30, 30, 150), Vector(-25, -25, 0))
	self.VJ_NPC_Class = {"CLASS_PLAYER_ALLY"} -- NPCs with the same class with be allied to each other
end
