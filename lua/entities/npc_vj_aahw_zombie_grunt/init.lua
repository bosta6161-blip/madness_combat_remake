AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = {"models/noob_dev2323/madness/npc/zeds_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 70 -- or you can use a convar: GetConVarNumber("vj_dum_dummy_h")
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other

ENT.Bleeds = true -- Can it bleed? Controls all bleeding related components such blood decal, particle, pool, etc.
ENT.BloodColor = "red" -- Its blood type, this will determine the blood decal, particle, etc.
ENT.HasBloodDecal = true -- Should it spawn a decal when damaged?
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodDecal = {"VJ_AAWH_GRUNT_BLOOD"}
ENT.HasBloodPool = false  -- Should a blood pool spawn by its corpse?

ENT.ControllerParams = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "head", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(0, 0, 20), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}
ENT.DeathCorpseSetBoneAngles = true -- This can be used to stop the corpse glitching or flying on death
ENT.DeathCorpseApplyForce = true  -- If false, force will not be applied to the corpse

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamageType = DMG_SLASH
ENT.AnimTbl_MeleeAttack = {"vjges_bite"} -- Melee Attack Animations
ENT.MeleeAttackAnimationAllowOtherTasks = true -- If set to true, the animation will not stop other tasks from playing, such as chasing | Useful for gesture attacks!
ENT.MeleeAttackDistance = 120 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 120 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.8	 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 20

ENT.AnimTbl_Flinch = {"vjges_flinch"} -- If it uses normal based animation, use this
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 14 -- Chance of it flinching from 1 to x | 1 will make it always flinch
	-- To let the base automatically detect the animation duration, set this to false:
ENT.NextMoveAfterFlinchTime = false -- How much time until it can move, attack, etc.
ENT.NextFlinchTime = 0.5 -- How much time until it can flinch again?
ENT.FlinchAnimationDecreaseLengthAmount = 0 -- This will decrease the time it can move, attack, etc. | Use it to fix animation pauses after it finished the flinch animation
ENT.HitGroupFlinching_DefaultWhenNotHit = true -- If it uses hitgroup flinching, should it do the regular flinch if it doesn't hit any of the specified hitgroups?
ENT.HitGroupFlinching_Values = nil -- EXAMPLES: {{HitGroup = {HITGROUP_HEAD}, Animation = {ACT_FLINCH_HEAD}}, {HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}

ENT.SoundTbl_MeleeAttack = {"noob_dev2323/madness/zeds/Bite1.wav","noob_dev2323/madness/zeds/Bite2.wav","noob_dev2323/madness/zeds/Bite3.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"noob_dev2323/madness/grunt/swoosh1.wav","noob_dev2323/madness/grunt/swoosh2.wav","noob_dev2323/madness/grunt/swoosh3.wav","noob_dev2323/madness/grunt/swoosh4.wav"}

ENT.DamageResponse = true -- Should it respond to damages while it has no enemy?
ENT.Weapon_Disabled = true   -- Disable the ability for it to use weapons

ENT.MeleeAttackSoundLevel = 100
ENT.SightDistance = 18000 -- Initial sight distance | To retrieve: "self:GetMaxLookDistance()" | To change: "self:SetMaxLookDistance(distance)"
-----------------------------------custom---------------------------
ENT.is_madness_combat_npc = true 
ENT.is_madness_hurt = false
ENT.has_jaw = true
ENT.grunt_status = {
	life = 40,
	is_trained = false 
}
ENT.madness_head_damege_table = {
	[14] = 3,
	[15] = 1,
	[16] = 2,
}
--13
function ENT:CustomOnInitialize()
	self.madness_gib_type = "ok"
end

function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
	if GetConVar("vj_madness_gore"):GetInt() == 1 and not self.is_madness_VR then
		if dmginfo:GetDamageType() ~= 4 and dmginfo:GetDamage() >= 70 then
			if self.madness_head_damege_table[hitgroup] or hitgroup == 13 then 
				self.gib_type = "head_less"
			end
		elseif dmginfo:GetDamageType() ~= 4 and dmginfo:GetDamage() >= 20 then
			if hitgroup == 13 and math.random(1, 2) == 1 then
				if self.HasGibDeathParticles == true then
					local bloodeffect = EffectData()
					bloodeffect:SetOrigin(self:GetAttachment(self:LookupAttachment("glasses")).Pos)
					bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
					bloodeffect:SetScale(30)
					util.Effect("VJ_Blood1",bloodeffect)
				end
				if self:GetBodygroup(3) == 0 then
					local Vel = self:GetRight()*math.Rand(-1000,1000)+self:GetForward()*math.Rand(-1000,10) 
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/jaw_prop.mdl",{BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("glasses")).Pos,Ang=self:GetAngles(),Vel=vel})
				end
				self.SoundTbl_MeleeAttack = {"noob_dev2323/madness/melee/Punch1.wav","noob_dev2323/madness/melee/Punch2.wav","noob_dev2323/madness/melee/Punch3.wav","noob_dev2323/madness/melee/Punch4.wav","noob_dev2323/madness/melee/Punch5.wav"}
				self.SoundTbl_BeforeMeleeAttack = {"noob_dev2323/madness/grunt/Grunt.wav","noob_dev2323/madness/grunt/Grunt-1.wav","noob_dev2323/madness/grunt/Grunt-2.wav","noob_dev2323/madness/grunt/Grunt-3.wav","noob_dev2323/madness/grunt/Grunt-4.wav","noob_dev2323/madness/grunt/Grunt-5.wav","noob_dev2323/madness/grunt/Grunt-6.wav","noob_dev2323/madness/grunt/Grunt-7.wav","noob_dev2323/madness/grunt/Grunt-8.wav"}
				self.AnimTbl_MeleeAttack = {"vjges_melee_attack_01","vjges_melee_attack_02"} -- Melee Attack Animations
				self:SetBodygroup(3, 1)
				self.has_jaw = false
			end
			if self.madness_head_damege_table[hitgroup] and not self.head_gib then 
				self.head_gib = true 
				local att = self.madness_head_damege_table[hitgroup]
				self:SetBodygroup(1,self.madness_head_damege_table[hitgroup])
				ParticleEffect("blood_impact_red_01_goop",self:GetAttachment(self:LookupAttachment(att)).Pos,self:GetAngles())
				sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", self:GetPos(), 75, 100, 1)
			end
			if hitgroup == HITGROUP_LEFTLEG then --Dismember foot code
				self.gib_type = "l_leg"
			elseif hitgroup == HITGROUP_RIGHTLEG then --Dismember foot code
				self.gib_type = "R_leg"
			end
		end
		if hitgroup == 2 and dmginfo:GetDamage() >= 90 and dmginfo:GetDamageType() == DMG_SLASH then
			self.gib_type = "half"
		end
		self.madness_last_dmg_total = dmginfo:GetDamage()
		self.madness_last_dmg_force = dmginfo:GetDamageForce()
	end
end

function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	corpseEnt.HLR_Corpse_Decal = self.HasBloodDecal and VJ_PICK(self.CustomBlood_Decal) or ""

	dmginfo:SetDamageForce(dmginfo:GetDamageForce()/3)
	corpseEnt:TakeDamageInfo(dmginfo)
	vj_madness_make_corpse_destructible(corpseEnt)
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
	if self.gib_type == "head_less" then
		local data = {
			particle = "blood_advisor_puncture_withdraw",
			decal = "VJ_AAWH_GRUNT_BLOOD",
			gibs = {
				{"models/noob_dev2323/madness/gibs/gib01.mdl", "2"},
				{"models/noob_dev2323/madness/gibs/gib02.mdl", "5"},
				{"models/noob_dev2323/madness/gibs/gib01.mdl", "4"},
				{"models/noob_dev2323/madness/gibs/gib02.mdl", "head"}
			}
		}

		if self.HasGibOnDeathEffects and GetConVar("vj_madness_blood"):GetInt() == 1 then
			vj_madness_make_blood(corpseEnt,"head")
		end

		corpseEnt.Head_gibbed = true

		for _, gib in ipairs(data.gibs) do
			local forceMult = math.Clamp(self.madness_last_dmg_total, 0, 2000 )
			local Vel = self.madness_last_dmg_force:GetNormalized()*forceMult + VectorRand()*forceMult
			local att = self:GetAttachment(self:LookupAttachment(gib[2]))

			self:CreateGibEntity(
				"obj_vj_gib",
				gib[1],
				{CollisionDecal = data.decal,Pos = att.Pos,Ang = self:GetAngles(),Vel = vel})
		end

		corpseEnt:SetBodygroup(2, 0)
		corpseEnt:SetBodygroup(3, 1)
		corpseEnt:SetBodygroup(1, 4)
		corpseEnt:SetBodygroup(4, 1)

		sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1, 5) .. ".wav",corpseEnt:GetPos(),75,100,1)
		local colide = corpseEnt:GetPhysicsObjectNum(corpseEnt:TranslateBoneToPhysBone(corpseEnt:LookupBone("head"))) --get bone id
		colide:EnableCollisions(false)
		colide:SetMass(0.01)
	end
	if self.gib_type == "half" then
		if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
			if self.is_yellow_blood == true then
				bloodeffect:SetColor(VJ_Color2Byte(Color(229,255,0)))
			else
				bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			end
			bloodeffect:SetScale(50)
			util.Effect("VJ_Blood1",bloodeffect)
		end
		sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
		local bone = corpseEnt:TranslateBoneToPhysBone(corpseEnt:LookupBone("torax"))
		corpseEnt:RemoveInternalConstraint(bone)
		local head_bone = corpseEnt:LookupBone("torax")
		local bone = corpseEnt:TranslateBoneToPhysBone(head_bone)
		local colide = corpseEnt:GetPhysicsObjectNum( bone )
		colide:AddVelocity(Vector(0,0,999))
		corpseEnt:SetBodygroup(0, 1)
	end
	if self:GetBodygroup(2) == 1 and math.random(1, 4) == 1 then
		local Vel = self:GetRight()*math.Rand(-1000,1000)+self:GetForward()*math.Rand(-1000,10) 
		corpseEnt:SetBodygroup(2,0)
		self:CreateGibEntity("prop_physics","models/noob_dev2323/madness/gibs/glasses_prop.mdl",{Pos=self:GetAttachment(self:LookupAttachment("glasses")).Pos,Ang=self:GetAngles(),Vel=vel})
	end

	if self.gib_type == "l_leg" then
		corpseEnt:ManipulateBoneScale(corpseEnt:LookupBone("L_foot"),Vector(0,0,0))
		local forceMult = math.Clamp(self.madness_last_dmg_total, 0, 2000 )
		local Vel = self.madness_last_dmg_force:GetNormalized()*forceMult + VectorRand()*forceMult

		self:CreateGibEntity("prop_physics","models/noob_dev2323/madness/gibs/feet.mdl",{Pos = corpseEnt:GetBonePosition(corpseEnt:LookupBone("L_foot")),Ang = self:GetAngles(),Vel = vel})
		local colide = corpseEnt:GetPhysicsObjectNum( corpseEnt:TranslateBoneToPhysBone(corpseEnt:LookupBone("L_foot")) )
		colide:EnableCollisions(false)
	end
	if self.gib_type == "R_leg" then
		corpseEnt:ManipulateBoneScale(corpseEnt:LookupBone("R_foot"),Vector(0,0,0))
		local forceMult = math.Clamp(self.madness_last_dmg_total, 0, 2000 )
		local Vel = self.madness_last_dmg_force:GetNormalized()*forceMult + VectorRand()*forceMult

		self:CreateGibEntity("prop_physics","models/noob_dev2323/madness/gibs/feet.mdl",{Pos = corpseEnt:GetBonePosition(corpseEnt:LookupBone("R_foot")),Ang = self:GetAngles(),Vel = vel})
		local colide = corpseEnt:GetPhysicsObjectNum( corpseEnt:TranslateBoneToPhysBone(corpseEnt:LookupBone("R_foot")) )
		colide:EnableCollisions(false)
	end

end
function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if GetConVar("vj_madness_gore"):GetBool() then
	 	if self.HasGibDeathParticles == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(self:GetPos() +self:OBBCenter())
			if self.is_yellow_blood == true then
				bloodeffect:SetColor(VJ_Color2Byte(Color(229,255,0)))
			else
				bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			end
			bloodeffect:SetScale(50)
			util.Effect("VJ_Blood1",bloodeffect)
		end
		if GetConVar("vj_madness_blood_mess"):GetInt() == 1 then 
			for i=1,math.random(2,6) do 
				self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
				self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
			end
		end
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
		return true
	end
end
ENT.InfectionClasses = {
	npc_vj_aahw_grunt = true,
	npc_vj_aahw_armed_grunt = true,
	npc_vj_aahw_elite_bodyguards = true,
	npc_vj_aahw_grunt_melee = true,
	npc_vj_aahw_agent = true,
}

function ENT:CustomOnMeleeAttack_AfterChecks(TheHitEntity) 
	local victim = TheHitEntity
	local playercontroller = self.VJ_TheControllerEntity
	local cameramode = self.VJ_TheControllerEntity.VJC_Camera_Mode
	if victim.infected then return end
	if victim:IsNPC() and self.InfectionClasses[victim:GetClass()] and victim:Health() > 0 and self.has_jaw == true then -- make sure our victim is a valid infection target
		victim.infected = true 
		victim:VJ_ACT_PLAYACTIVITY("ACT_INFECTED",true,false,false) 
		victim.TurningSpeed = 0
		VJ_EmitSound(victim,"noob_dev2323/madness/grunt/die.wav")
		victim.HasDeathRagdoll = false
		local zClass = "npc_vj_aahw_zombie_grunt" --Fallback class for the zombie NPC we will spawn
		local zPos = victim:GetPos()
		victim.VJ_NPC_Class = {"CLASS_ZOMBIE"} --Stop NPCs from attacking victim
		victim.BringFriendsOnDeath = false
		victim:SetBodygroup(1,5)
		if victim:GetClass() == "npc_vj_aahw_agent" then
			zClass = "npc_vj_aahw_zombie_agent"
		end
		
		timer.Simple(0.5,function() -- Overridden to 30 seconds because Barney's infection animation loops instead of lasting a long time.
			if IsValid(victim) then
			
				local zombie = ents.Create(zClass)
				zombie:SetPos(zPos)
				zombie:SetAngles(victim:GetAngles())
				zombie:SetColor(victim:GetColor())
				zombie:SetMaterial(victim:GetMaterial())
				zombie:Spawn()
				zombie:AddEffects(32) -- hide zombie
				if IsValid(victim) then
					undo.ReplaceEntity(victim,zombie)
				end
				timer.Simple(0.52,function() --The zombie actually spawns in early and is hidden, this is to move the getup animation in place before showing the zombie model
					if IsValid(zombie) then
						SafeRemoveEntity(victim)
						zombie:SetPos(zPos)
						
						zombie:RemoveEffects(32)
						if zombie.HasGibDeathParticles == true then
							local bloodeffect = EffectData()
							bloodeffect:SetOrigin(zombie:GetPos() +zombie:OBBCenter())
							bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
							bloodeffect:SetScale(50)
							util.Effect("VJ_Blood1",bloodeffect)
						end
					end
				end)
			end
		end)
	end
end
-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base