AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = {"models/noob_dev2323/madness/npc/grunt_npc.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 60 -- or you can use a convar: GetConVarNumber("vj_dum_dummy_h")
ENT.VJ_NPC_Class = {"CLASS_AAHW"} -- NPCs with the same class with be allied to each other

ENT.Bleeds = true -- Can it bleed? Controls all bleeding related components such blood decal, particle, pool, etc.
ENT.BloodColor = "red" -- Its blood type, this will determine the blood decal, particle, etc.
ENT.HasBloodDecal = true -- Should it spawn a decal when damaged?
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.BloodDecal = {"VJ_AAWH_GRUNT_BLOOD"}
ENT.HasBloodPool = false  -- Should a blood pool spawn by its corpse?

ENT.SightDistance = 18000 -- Initial sight distance | To retrieve: "self:GetMaxLookDistance()" | To change: "self:SetMaxLookDistance(distance)"

ENT.ControllerParams = {
	CameraMode = 1, -- Sets the default camera mode | 1 = Third Person, 2 = First Person
	ThirdP_Offset = Vector(0, 0, 0), -- The offset for the controller when the camera is in third person
	FirstP_Bone = "head", -- If left empty, the base will attempt to calculate a position for first person
	FirstP_Offset = Vector(10,0,15), -- The offset for the controller when the camera is in first person
	FirstP_ShrinkBone = true, -- Should the bone shrink? Useful if the bone is obscuring the player's view
	FirstP_CameraBoneAng = 0, -- Should the camera's angle be affected by the bone's angle? | 0 = No, 1 = Pitch, 2 = Yaw, 3 = Roll
	FirstP_CameraBoneAng_Offset = 0, -- How much should the camera's angle be rotated by? | Useful for weird bone angles
}

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamageType = DMG_CLUB
ENT.AnimTbl_MeleeAttack = {"vjges_punch01","vjges_punch02","vjges_melee_attack_01","vjges_melee_attack_02"} -- Melee Attack Animations
ENT.MeleeAttackAnimationAllowOtherTasks = true -- If set to true, the animation will not stop other tasks from playing, such as chasing | Useful for gesture attacks!
ENT.MeleeAttackDistance = 100 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 120 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0	 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 10
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds

ENT.AnimTbl_Flinch = {"vjges_flinch"} -- If it uses normal based animation, use this
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchChance = 1 -- Chance of it flinching from 1 to x | 1 will make it always flinch
	-- To let the base automatically detect the animation duration, set this to false:
ENT.NextMoveAfterFlinchTime = false -- How much time until it can move, attack, etc.
ENT.NextFlinchTime = 0.5 -- How much time until it can flinch again?
ENT.FlinchAnimationDecreaseLengthAmount = 0 -- This will decrease the time it can move, attack, etc. | Use it to fix animation pauses after it finished the flinch animation
ENT.HitGroupFlinching_DefaultWhenNotHit = true -- If it uses hitgroup flinching, should it do the regular flinch if it doesn't hit any of the specified hitgroups?
ENT.HitGroupFlinching_Values = nil -- EXAMPLES: {{HitGroup = {HITGROUP_HEAD}, Animation = {ACT_FLINCH_HEAD}}, {HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}

ENT.HasSounds = true -- Put to false to disable ALL sound
ENT.SoundTbl_MeleeAttack = {"noob_dev2323/madness/melee/Punch1.wav","noob_dev2323/madness/melee/Punch2.wav","noob_dev2323/madness/melee/Punch3.wav","noob_dev2323/madness/melee/Punch4.wav","noob_dev2323/madness/melee/Punch5.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"noob_dev2323/madness/grunt/Grunt.wav","noob_dev2323/madness/grunt/Grunt-1.wav","noob_dev2323/madness/grunt/Grunt-2.wav","noob_dev2323/madness/grunt/Grunt-3.wav","noob_dev2323/madness/grunt/Grunt-4.wav","noob_dev2323/madness/grunt/Grunt-5.wav","noob_dev2323/madness/grunt/Grunt-6.wav","noob_dev2323/madness/grunt/Grunt-7.wav","noob_dev2323/madness/grunt/Grunt-8.wav"}


ENT.Weapon_Disabled = true -- Disable the ability for it to use weapons


-----------------------------------sounds---------------------------
ENT.SoundTbl_MeleeAttackExtra = {"noob_dev2323/madness/grunt/gruntpunch1.wav","noob_dev2323/madness/grunt/gruntpunch2.wav","noob_dev2323/madness/grunt/gruntpunch3.wav","noob_dev2323/madness/grunt/gruntpunch4.wav"}
-----------------------------------custom---------------------------
ENT.is_madness_VR = false 
ENT.is_madness_combat_npc = true 
ENT.grunt_NextStumbleT = CurTime() + 3
ENT.grunt_NextText = CurTime() + 3
ENT.is_madness_hurt = false
ENT.AAHW_NextRunT = 0
-----------------------------------status---------------------------
ENT.grunt_hold_type = "none"
ENT.grunt_no_pain_animation = false
ENT.grunt_no_stun = false

ENT.madness_head_damege_table = {
	[13] = 3,
	[14] = 4,
	[16] = 2,
	[17] = 5,
}
function ENT:CustomOnInitialize()
	self.madness_gib_type = "ok"
end
function ENT:OnAlert(ent) 
	local dotext = math.random(1,3)
	if dotext < 3 then
		if CurTime() > self.grunt_NextText then
			self.grunt_NextText = CurTime() + 3
			madness_combat_snpc_doText(self,table.Random( madness_npc_text ))	
		end
	end
end
function ENT:TranslateActivity(act)
	if self.is_madness_hurt == true and self.grunt_no_pain_animation == false then --if is hurt swap animations
		if act == ACT_WALK then
			return ACT_WALK_HURT -- your activity here
		elseif act == ACT_RUN then
			return ACT_RUN_HURT -- your activity here
		elseif act == ACT_IDLE then
			return self:GetSequenceActivity(self:LookupSequence("idle_hunt")) -- your activity here
		end
	end
	if self.grunt_hold_type == "pistol" then --if is hurt swap animations
		if act == ACT_WALK then
			return ACT_WALK_PISTOL -- your activity here
		elseif act == ACT_RUN then
			return ACT_RUN_PISTOL -- your activity here
		elseif act == ACT_IDLE then
			return ACT_IDLE_PISTOL -- your activity here
		end
	end

    return act
end

function ENT:CustomOnTakeDamage_AfterDamage(dmginfo, hitgroup)
	if self:Health() <= (self:GetMaxHealth() / 2.2) and self.is_madness_hurt ~= true and self.grunt_no_pain_animation == false then
		self.is_madness_hurt = true
		self.NextAnyAttackTime_Melee = 0.5	 -- How much time until it can use any attack again? | Counted in Seconds
		self.MeleeAttackDamage = 7
		self.AnimTbl_MeleeAttack = {"vjges_punch_hunt_01","vjges_punch_hunt_02"} -- Melee Attack Animations
	end
	if self.grunt_no_stun == false then
		if ( hitgroup == HITGROUP_LEFTLEG ) or ( hitgroup == HITGROUP_RIGHTLEG ) and self:GetActivity() == ACT_RUN and math.random(1, 2) == 1 and dmginfo:GetDamage() >= 40 and self.CanFlinch == 1 then
			self.grunt_NextStumbleT = CurTime() + 3
			self:VJ_ACT_PLAYACTIVITY("run_stumble_01",true,2)
			self.CanFlinch = 0
			timer.Simple( 3, function()
				if IsValid(self) then
					self.CanFlinch = 1
				end
			end )
		end	
		if ( hitgroup == HITGROUP_CHEST ) or ( hitgroup == HITGROUP_STOMACH ) and math.random(1, 3) == 1 and dmginfo:GetDamage() >= 40 and self.CanFlinch == 1 then
			self.grunt_NextStumbleT = CurTime() + 3
			self:VJ_ACT_PLAYACTIVITY("stumble_back",true,2)
			self.CanFlinch = 0
			timer.Simple( 3, function()
				if IsValid(self) then
					self.CanFlinch = 1
				end
			end )
		end
	end
end

include( "noob_dev2323/madness_combat/grunt_gore_script.lua" ) --include gore script

-- All functions and variables are located inside the base files. It can be found in the GitHub Repository: https://github.com/DrVrej/VJ-Base