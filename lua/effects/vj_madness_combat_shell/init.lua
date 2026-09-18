/*-----------------------------------------------
	*** Copyright (c) 2012-2026 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Size = data:GetScale()
	local emitter = ParticleEmitter(self.Pos)
	if emitter == nil then return end
	
	local shell = emitter:Add("decals/madness_trail", self.Pos)
	shell:SetVelocity(VectorRand() * math.Rand(50, 50))
	shell:SetDieTime(math.Rand(0.3, 0.7))
	shell:SetStartAlpha(200)
	shell:SetEndAlpha(0)
	shell:SetStartSize(1)
	shell:SetEndSize(2)
	shell:SetRoll(math.random(0, 360))
	shell:SetGravity(Vector(math.random(-300, 300), math.random(-300,300), math.random(-200, -10)))
	shell:SetBounce(0.9)
	shell:SetAirResistance(120)
	shell:SetStartLength(0)
	shell:SetEndLength(0.2)
	shell:SetVelocityScale(true)
	shell:SetCollide(true)
	shell:SetColor(255, 231, 166)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Think()
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function EFFECT:Render() end