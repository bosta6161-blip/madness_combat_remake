madness_combat_text = {}
net.Receive("vj_madness_combat.text", function()
    local npc = net.ReadEntity()
    local text = net.ReadString()
    if IsValid(npc) then
        if !npc.madness_ChatText then
		    table.insert(madness_combat_text, npc)
	    end
        npc.madness_ChatText = text
        npc.madness_ChatTime = CurTime() + 3
    end
end)
local maxChatDistance = 1500

hook.Add("PostDrawTranslucentRenderables", "Draw_madness_NPCChat", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local plyPos = ply:EyePos()
    for _,npc in ipairs(madness_combat_text) do
		if not npc:IsValid() then
			table.RemoveByValue(madness_combat_text, npc) --remove ragdoll on the table
		end
        if IsValid(npc) and npc:IsNPC() and npc.madness_ChatText and npc.madness_ChatTime and CurTime() < npc.madness_ChatTime then
            local npcPos = npc:GetPos()
            local distance = plyPos:DistToSqr(npcPos) 

            
            if distance > (maxChatDistance * maxChatDistance) then continue end

            
            local trace = util.TraceLine({
                start = plyPos,
                endpos = npcPos + Vector(0, 0, 50), 
                filter = {ply, npc}, 
                mask = MASK_VISIBLE_AND_NPCS 
            })

            
            if trace.Hit then continue end 


            local minBounds, maxBounds = npc:GetModelBounds()
            local height = maxBounds.z - minBounds.z
            if height <= 0 then height = 40 end 


            local ang = ply:EyeAngles()
            ang:RotateAroundAxis(ang:Right(), 90)
            ang:RotateAroundAxis(ang:Up(), -90)


            cam.Start3D2D(npc:GetPos() + Vector(0, 0, height + 4), ang, 0.4)
                draw.SimpleTextOutlined(npc.madness_ChatText, "DermaLarge", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0, 0, 0))
            cam.End3D2D()
        end
	end
end)
net.Receive( "vj_madness_combat.vr_particles", function( len, ply )
    local ent = net.ReadEntity()
	madness_combat_vr_particles(ent)
end )
function madness_combat_vr_particles(ent)
    if ent:IsValid() then 
        local boneCount = ent:GetBoneCount()

        for i = 0, boneCount - 1 do
            local pos = ent:GetBonePosition(i+math.random(-5,5),math.random(-5,5),math.random(-5,5))

            if pos then
                for i=1,math.random(10,30) do
                local emitter = ParticleEmitter(pos)

                if emitter then
                    local particle = emitter:Add("decals/madness_trail", pos)

                    if particle then
                        particle:SetDieTime( 3 )

                        particle:SetStartAlpha( math.random( 200, 255 ) )
                        particle:SetColor( 0,255, 0 )
                        particle:SetStartSize( math.random( 1, 2,5 ) )

                        particle:SetEndAlpha( 0 )
                        particle:SetEndSize( 1 )
                        particle:SetVelocityScale(true)
                        particle:SetLighting( true)

                        particle:SetGravity( Vector( 0, 0, -350 ) )
                        particle:SetVelocity(Vector( math.random(-40,40), math.random(-40,40), math.random(50,140) ))
                        particle:SetCollide( true )	
                    end

                    emitter:Finish()
                end
            end
            end
        end  
    end
end