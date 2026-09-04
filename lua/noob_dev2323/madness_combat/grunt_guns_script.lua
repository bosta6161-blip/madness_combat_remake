---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	print(key)
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
    bullet.Num = 1
    bullet.Src = att.Pos
    bullet.Dir = (enemy:BodyTarget(att.Pos) - att.Pos):GetNormalized()
    bullet.Spread = Vector(0.09, 0.09, 0.05)
    bullet.Tracer = 1
    bullet.TracerName = "Tracer"
    bullet.Force = 4
    bullet.Damage = 4

    self:FireBullets(bullet)

	VJ.EmitSound(self, "weapons/glock.wav", 80, 100)

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
	self:PlayAnim({"vjges_reload_mp5"}, true, false)

    timer.Simple(self.ReloadTime, function()
        if not IsValid(self) then return end

        self.CurrentAmmo = self.MaxAmmo
        self.Reloading = false
        self.HasRangeAttack = true
    end)
end