/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
-- Sound:
local drip_sounds = {
    "player/pl_shell1.wav",
    "player/pl_shell2.wav",
    "player/pl_shell3.wav",
}
function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
    local ang = data:GetAngles()

	local emitter = ParticleEmitter(self.Pos)
	if not emitter then return end
	
	local shell = emitter:Add("decals/smg_shell", self.Pos)
	shell:SetVelocity(
		ang:Right() * 80 +
		ang:Up() * 40 +
		VectorRand() * 15
	)
	shell:SetDieTime(5)
	shell:SetStartAlpha(255)
	shell:SetEndAlpha(255)
	shell:SetStartSize(2)
	shell:SetRoll(math.random(0, 360))
    shell:SetGravity(Vector(0, 0, -600))
	shell:SetBounce(0.4)
	shell:SetAirResistance(0)
	shell:SetStartLength(0)
	shell:SetEndLength(0)
	shell:SetVelocityScale(true)
	shell:SetCollide(true)
	shell:SetCollideCallback(function(_, pos, normal,hitnormal)
		sound.Play(table.Random(drip_sounds), pos, sound_level, math.Rand(95, 105),0.7)
	end)
	shell:SetColor(255, 255, 255)
	
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end