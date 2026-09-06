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
	if self.gib_type == "head_less" and not self.head_sliced then
		corpseEnt.Head_gibbed = true 
		if self.is_madness_VR == false then
			corpseEnt:SetBodygroup(2, 0)
			corpseEnt:SetBodygroup(1, 1)
			sound.Play("noob_dev2323/madness/gore/Dissmember" .. math.random(1,5) .. ".wav", corpseEnt:GetPos(), 75, 100, 1)
		end
	end
end