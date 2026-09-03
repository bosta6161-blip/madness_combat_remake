function ENT:CustomOnTakeDamage_OnBleed(dmginfo, hitgroup) 
	if GetConVar("vj_madness_gore"):GetInt() == 1 and not self.is_madness_VR then
		if dmginfo:GetDamageType() ~= 4 and dmginfo:GetDamage() >= 90 then
			if self.madness_head_damege_table[hitgroup] or hitgroup == 15 then 
				self.gib_type = "head_less"
			end
		elseif dmginfo:GetDamageType() ~= 4 and dmginfo:GetDamage() >= 20 then
			if self.madness_head_damege_table[hitgroup] then 
				self.head_damege_type = self.madness_head_damege_table[hitgroup]
				self.gib_type = "head_damege" 
			end
		end
	end
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
	if self.gib_type == "head_damege" then
		corpseEnt:SetBodygroup(1,self.head_damege_type)
		self:EmitSound("noob_dev2323/madness/grunt/die.wav", 500, 100, 6, CHAN_AUTO ) -- Same as below
		local att = self.head_damege_type
		if self.isVR == false then
			ParticleEffect("blood_impact_red_01_goop",self:GetAttachment(self:LookupAttachment(att)).Pos,self:GetAngles())
			sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
		end
	end
	if self.gib_type == "head_less" and not self.head_sliced then
		if self.HasGibOnDeathEffects and not self.isVR == true then
			local bloodeffect = EffectData()
			bloodeffect:SetOrigin(corpseEnt:GetAttachment(corpseEnt:LookupAttachment("head_gib")).Pos)
			if self.is_yellow_blood == true then
				bloodeffect:SetScale(15)
				bloodeffect:SetColor(VJ_Color2Byte(Color(229,255,0)))
			else
				bloodeffect:SetScale(30)
				bloodeffect:SetColor(VJ_Color2Byte(Color(130,19,10)))
			end

			util.Effect("VJ_Blood1",bloodeffect)

			local bloodeffect = ents.Create("info_particle_system")
			if self.is_yellow_blood == true then
				bloodeffect:SetKeyValue("effect_name","qblood_advisor_shrapnel_impact")
			else
				bloodeffect:SetKeyValue("effect_name","blood_advisor_puncture_withdraw")
			end
			bloodeffect:SetPos(corpseEnt:GetAttachment(corpseEnt:LookupAttachment("head")).Pos)
			bloodeffect:SetAngles(corpseEnt:GetAttachment(corpseEnt:LookupAttachment("head")).Ang)
			bloodeffect:SetParent(corpseEnt)
			bloodeffect:Fire("SetParentAttachment","head")
			bloodeffect:Spawn()
			bloodeffect:Activate()
			bloodeffect:Fire("Start","",0)
			bloodeffect:Fire("Kill","",7) 
		end
		corpseEnt.Head_gibbed = true 
		if self.is_madness_VR == false then
			local forceMult = math.Clamp(dmginfo:GetDamage(), 0, 1000 )
        	
			local Vel = dmginfo:GetDamageForce():GetNormalized()*forceMult + VectorRand()*forceMult
			if self.is_yellow_blood == true then
				if GetConVar("vj_madness_blood_mess"):GetInt() == 1 then 
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib03.mdl",{CollisionDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("4")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib03.mdl",{CollisionDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("2")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib03.mdl",{CollisionDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("2")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib03.mdl",{CollisionDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("4")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib03.mdl",{CollisionDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("2")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib03.mdl",{CollisionDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("2")).Pos,Ang=self:GetAngles(),Vel=vel})
				end
				self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib03.mdl",{CollisionDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("2")).Pos,Ang=self:GetAngles(),Vel=vel})
				self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib04.mdl",{CollisionDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("5")).Pos,Ang=self:GetAngles(),Vel=vel})
				self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib03.mdl",{CollisionDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos,Ang=self:GetAngles(),Vel=vel})
				self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib04.mdl",{CollisionDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos,Ang=self:GetAngles(),Vel=vel})
				self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib03.mdl",{CollisionDecal="VJ_AAWH_GRUNT_YELLOW_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head")).Pos,Ang=self:GetAngles(),Vel=vel})
			else
				if GetConVar("vj_madness_blood_mess"):GetInt() == 1 then 
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib02.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("2")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib01.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("5")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib02.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib02.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib01.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("4")).Pos,Ang=self:GetAngles(),Vel=vel})
					self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/gib01.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head")).Pos,Ang=self:GetAngles(),Vel=vel})
				end
				self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk2.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("2")).Pos,Ang=self:GetAngles(),Vel=vel})
				self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk1.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("5")).Pos,Ang=self:GetAngles(),Vel=vel})
				self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk6.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("4")).Pos,Ang=self:GetAngles(),Vel=vel})
				self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk4.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos,Ang=self:GetAngles(),Vel=vel})
				self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk5.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head_gib")).Pos,Ang=self:GetAngles(),Vel=vel})
				self:CreateGibEntity("obj_vj_gib","models/noob_dev2323/madness/gibs/head_chunk3.mdl",{CollisionDecal="VJ_AAWH_GRUNT_BLOOD",Pos=self:GetAttachment(self:LookupAttachment("head")).Pos,Ang=self:GetAngles(),Vel=vel})
			end
		end
		
		corpseEnt:SetBodygroup(2, 0)
		corpseEnt:SetBodygroup(1, 1)
		sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
	end
end