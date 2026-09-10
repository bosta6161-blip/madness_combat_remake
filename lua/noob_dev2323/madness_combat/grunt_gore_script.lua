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
	if self.is_yellow_blood == true then
		for i = 0, corpseEnt:GetPhysicsObjectCount() - 1 do
			local phys = corpseEnt:GetPhysicsObjectNum(i)

			if IsValid(phys) then
				phys:SetMaterial("alienflesh")
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

		if self.HasGibOnDeathEffects and not self.isVR then
			local att = corpseEnt:GetAttachment(corpseEnt:LookupAttachment("head_gib"))

			local blood = EffectData()
			blood:SetOrigin(att.Pos)
			blood:SetScale(data.scale)
			blood:SetColor(VJ_Color2Byte(data.color))
			util.Effect("VJ_Blood1", blood)

			local particle = ents.Create("info_particle_system")
			local head = corpseEnt:GetAttachment(corpseEnt:LookupAttachment("head"))

			particle:SetKeyValue("effect_name", data.particle)
			particle:SetPos(head.Pos)
			particle:SetAngles(head.Ang)
			particle:SetParent(corpseEnt)
			particle:Fire("SetParentAttachment", "head")
			particle:Spawn()
			particle:Activate()
			particle:Fire("Start", "", 0)
			particle:Fire("Kill", "", 7)
		end

		corpseEnt.Head_gibbed = true

		if not self.isVR then

			for _, gib in ipairs(data.gibs) do
				local vel = Vector(math.Rand(-200, 200), math.Rand(-300, 300), math.Rand(200, 200))+Vector(dmginfo:GetDamageForce()/4)
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
end