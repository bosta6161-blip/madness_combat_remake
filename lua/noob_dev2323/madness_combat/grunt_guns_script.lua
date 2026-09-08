---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "event_emit step" then
		self:FootStepSoundCode()
	elseif key == "event_mattack both" then
		self:MeleeAttackCode()
	elseif key == "event_rattack" then
    if self.Reloading then return end

    if self.CurrentAmmo <= 0 then
        self:StartReload()
        return
    end

    local enemy = self:GetEnemy()
    if not IsValid(enemy) then return end

    local attID = self:LookupAttachment("shot")
    if not attID or attID <= 0 then return end

    local att = self:GetAttachment(attID)
    if not att then return end

    local bullet = {}
    bullet.Num = self.madness_weapon_status.amount
    bullet.Src = att.Pos
    bullet.Dir = (enemy:BodyTarget(att.Pos) - att.Pos):GetNormalized()
    bullet.Spread = self.madness_weapon_status.spread
    bullet.Tracer = 1
    bullet.TracerName = "Tracer"
    bullet.Force = self.madness_weapon_status.force
    bullet.Damage = self.madness_weapon_status.damege
	bullet.Attacker = self

    self:FireBullets(bullet)

    local gun_sound = "weapons/glock.wav"
    if self.madness_weapon_status.custom_gun_sound then
        gun_sound = self.madness_weapon_status.custom_gun_sound
    end
	VJ.EmitSound(self,gun_sound, 80, 100)

    ParticleEffectAttach("vj_rifle_full", PATTACH_POINT_FOLLOW, self, attID)
    self.CurrentAmmo = self.CurrentAmmo - 1
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- CUSTOM RELOAD COSMETIC THINGY
function ENT:StartReload()
    if self.Reloading then return end

    self.Reloading = true
    self.HasRangeAttack = false

	VJ.EmitSound(self, "weapons/shotgun/shotgun_reload1.wav", 75, 100)
	self:PlayAnim({"vjges_reload_pistol"}, true, false)

    timer.Simple(self.ReloadTime, function()
        if not IsValid(self) then return end

        self.CurrentAmmo = self.MaxAmmo
        self.Reloading = false
        self.HasRangeAttack = true
    end)
end