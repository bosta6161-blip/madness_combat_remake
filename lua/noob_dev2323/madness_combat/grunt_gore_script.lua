function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
	if GetConVar("vj_madness_gore"):GetInt() == 1 and not self.is_madness_VR then
		if dmginfo:GetDamageType() ~= 4 and dmginfo:GetDamage() >= 90 then
			if self.madness_head_damege_table[hitgroup] or hitgroup == 15 then 
				self.gib_type = "head_less"
			end
		elseif dmginfo:GetDamageType() ~= 4 and dmginfo:GetDamage() >= 25 then
			if self.madness_head_damege_table[hitgroup] then 
				self.head_damege_type = self.madness_head_damege_table[hitgroup]
				self.gib_type = "head_damege" 
			end
		end
		if hitgroup == 2 and dmginfo:GetDamage() >= 90 and dmginfo:GetDamageType() == DMG_SLASH then
			self.gib_type = "half"
        end
	end
	if hitgroup == HITGROUP_LEFTLEG and dmginfo:GetDamage() >= 25 then --Dismember foot code
		madness_combat_snpc_doText(self,"my LEG")
		self.gib_type = "l_leg"
	elseif hitgroup == HITGROUP_RIGHTLEG and dmginfo:GetDamage() >= 25 then --Dismember foot code
		madness_combat_snpc_doText(self,"my LEG")
		self.gib_type = "R_leg"
	end
	self.madness_last_dmg_total = dmginfo:GetDamage()
	self.madness_last_dmg_force = dmginfo:GetDamageForce()
end

function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	corpseEnt.HLR_Corpse_Decal = self.HasBloodDecal and VJ_PICK(self.CustomBlood_Decal) or ""

	if self.is_madness_VR == true then
		net.Start("vj_madness_combat.vr_particles")
			net.WriteEntity(corpseEnt)
		net.Broadcast()
		corpseEnt:RemoveAllDecals()
		corpseEnt:Fire("FadeAndRemove","",0.1)
		for i = 0, corpseEnt:GetPhysicsObjectCount() - 1 do
			local colide = corpseEnt:GetPhysicsObjectNum( i )
			colide:EnableGravity(false)
		end
		dmginfo:SetDamageForce(dmginfo:GetDamageForce()/3)
		corpseEnt:TakeDamageInfo(dmginfo)
	else
		dmginfo:SetDamageForce(dmginfo:GetDamageForce()/3)
		corpseEnt:TakeDamageInfo(dmginfo)
		vj_madness_make_corpse_destructible(corpseEnt)
	end

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
	if self.is_yellow_blood == true then
		for i = 0, corpseEnt:GetPhysicsObjectCount() - 1 do
			local phys = corpseEnt:GetPhysicsObjectNum(i)

			if IsValid(phys) then
				phys:SetMaterial("alienflesh")
			end
		end
	end
	if self.gib_type ~= "head_damege" and dmginfo:GetDamageType() == 4 or dmginfo:GetDamageType() == 1024 then
		local hit = madness_GetClosestPhysBone(corpseEnt,dmginfo).PhysicsBone --get hit physbone
		if hit == nil then
			return 
		end
		local bone = corpseEnt:TranslatePhysBoneToBone(hit)
		local bone_name = corpseEnt:GetBoneName( bone ) 
		self.head_sliced = true
		if bone_name == "head" then
			local distance = corpseEnt:GetBonePosition(corpseEnt:LookupBone("head")):Distance(dmginfo:GetDamagePosition())
			if distance > 18 then
				corpseEnt:SetBodygroup(1, 6)
				corpseEnt:SetBodygroup(2, 0)
				if self.is_madness_VR == false then
					sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
					if self.is_yellow_blood == true then
						self:CreateGibEntity("prop_physics","models/noob_dev2323/madness/gibs/half_head_alt.mdl",{Pos=corpseEnt:LocalToWorld(Vector(0,0,54)),Ang=corpseEnt:GetAngles()+Angle(0,0,0),Vel=corpseEnt:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})	
					else
						ParticleEffect("blood_impact_red_01_goop",self:GetAttachment(self:LookupAttachment("head_gib")).Pos,self:GetAngles())
						self:CreateGibEntity("prop_physics","models/noob_dev2323/madness/gibs/half_head.mdl",{Pos=corpseEnt:LocalToWorld(Vector(0,0,54)),Ang=corpseEnt:GetAngles()+Angle(0,0,0),Vel=corpseEnt:GetRight()*math.Rand(-350,350)+self:GetForward()*math.Rand(-200,-300)})	
					end
				end
			else 
				sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
				local bone = corpseEnt:TranslateBoneToPhysBone(corpseEnt:LookupBone("head"))
				corpseEnt:RemoveInternalConstraint(bone)
				local head_bone = corpseEnt:LookupBone("head")
				local bone = corpseEnt:TranslateBoneToPhysBone(head_bone)
				local colide = corpseEnt:GetPhysicsObjectNum( bone )
				colide:AddVelocity(dmginfo:GetDamageForce())
			end
		end
	end
	if self.gib_type == "head_damege" then
		corpseEnt:SetBodygroup(1,self.head_damege_type)
		self:EmitSound("noob_dev2323/madness/grunt/die.wav", 500, 100, 6, CHAN_AUTO ) -- Same as below
		local att = self.head_damege_type
		if self.isVR == false then
			ParticleEffect("blood_impact_red_01_goop",self:GetAttachment(self:LookupAttachment(att)).Pos,self:GetAngles())
			sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
		end
	end
	if self.melee_model then
		self:CreateGibEntity("prop_physics",self.melee_model,{Pos=self:LocalToWorld(Vector(-50,20,0)),Ang=self:GetAngles()+Angle(90,0,0),Vel=vel})
	end
	if self.madness_bonemerge_prop then
		bonemerge_prop_on_npc(self.madness_bonemerge_prop,corpseEnt)
	end
	if self.gib_type == "head_less" then
		local yellow = self.is_yellow_blood
		local data = yellow and {
			scale = 15,
			color = Color(229, 255, 0),
			particle = "qblood_advisor_shrapnel_impact",
			decal = "VJ_AAWH_GRUNT_YELLOW_BLOOD",
			gibs = {
				{"gib03.mdl", "2"},
				{"gib04.mdl", "5"},
				{"gib03.mdl", "head_gib"},
				{"gib04.mdl", "head_gib"},
				{"gib03.mdl", "head"}
			}
		} or {
			scale = 30,
			color = Color(130, 19, 10),
			particle = "blood_advisor_puncture_withdraw",
			decal = "VJ_AAWH_GRUNT_BLOOD",
			gibs = {
				{"head_chunk2.mdl", "2"},
				{"head_chunk1.mdl", "5"},
				{"head_chunk6.mdl", "4"},
				{"head_chunk4.mdl", "head_gib"},
				{"head_chunk5.mdl", "head_gib"},
				{"head_chunk3.mdl", "head"}
			}
		}

		if self.HasGibOnDeathEffects and not self.isVR and GetConVar("vj_madness_blood"):GetInt() == 1 then
			if self.is_yellow_blood == true then
				vj_madness_make_blood(corpseEnt,"head",true ) --i love shit code
			else
				vj_madness_make_blood(corpseEnt,"head")	
			end
		end

		corpseEnt.Head_gibbed = true

		if not self.isVR then

			for _, gib in ipairs(data.gibs) do
				local forceMult = math.Clamp(self.madness_last_dmg_total, 0, 2000 )
        		local Vel = self.madness_last_dmg_force:GetNormalized()*forceMult + VectorRand()*forceMult
				local att = self:GetAttachment(self:LookupAttachment(gib[2]))

				self:CreateGibEntity(
					"obj_vj_gib",
					"models/noob_dev2323/madness/gibs/" .. gib[1],
					{CollisionDecal = data.decal,Pos = att.Pos,Ang = self:GetAngles(),Vel = vel})
			end
		end

		corpseEnt:SetBodygroup(2, 0)
		corpseEnt:SetBodygroup(1, 1)

		sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1, 5) .. ".wav",corpseEnt:GetPos(),75,100,1)
	end
	if self.gib_type == "half" then
		if self.HasGibDeathParticles == true and not self.isVR == true then
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
		corpseEnt:SetBodygroup(0, 2)
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
	if self:GetClass() == "npc_vj_aahw_elite_bodyguards" and not self.gib_type == "head_less" then
		bonemerge_prop_on_npc("models/noob_dev2323/madness/npc/w_glasses_body_guard.mdl",corpseEnt)
	end
end

function ENT:SetUpGibesOnDeath(dmginfo,hitgroup)
	if GetConVar("vj_madness_gore"):GetInt() == 0 then return end
	if dmginfo:GetDamageType() == DMG_CRUSH and dmginfo:GetDamageType() == DMG_SLASH then
		self.gib_type = "half"
		return 
	end 
	if dmginfo:GetDamageType() == DMG_ENERGYBEAM or dmginfo:GetDamageType() == DMG_SLASH then
		return 
	end 
	if self.isVR then return end
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
	if self.is_yellow_blood == true then
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib03.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib04.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib03.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib04.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib03.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib04.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib03.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib04.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD"})
	else
	if GetConVar("vj_madness_blood_mess"):GetInt() == 1 then 
		for i=1,math.random(6,15) do 
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
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib02.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
		self:CreateGibEntity("obj_vj_gib", "models/noob_dev2323/madness/gibs/gib01.mdl", {BloodType="Red", BloodDecal="VJ_AAWH_GRUNT_BLOOD"})
	end

	return true
end