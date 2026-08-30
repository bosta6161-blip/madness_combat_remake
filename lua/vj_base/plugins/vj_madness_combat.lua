/*--------------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
VJ.AddPlugin("madness combat remake", "NPC")

local spawnCategory = "madness combat remake" -- Category, you can also set a category individually by replacing the spawnCategory with a string value

game.AddDecal("VJ_AAWH_GRUNT_BLOOD", {"decals/grunt/Blood01","decals/grunt/Blood02","decals/grunt/Blood03","decals/grunt/Blood04"})
game.AddDecal("VJ_AAWH_GRUNT_YELLOW_BLOOD", {"decals/yellow/yellow_01","decals/yellow/yellow_02","decals/yellow/yellow_03"})

VJ.AddNPC("aahw grunt", "npc_vj_aahw_grunt", spawnCategory) -- Adds a NPC to the spawnmenu
VJ.AddNPC_HUMAN("aahw agent", "npc_vj_aahw_agent",{"weapon_vj_aahw_glock_20"}, spawnCategory) -- Adds a NPC to the spawnmenu
VJ.AddNPC_HUMAN("aahw atp engineer", "npc_vj_aahw_atp_engineer",{"weapon_vj_aahw_mp5"}, spawnCategory) -- Adds a NPC to the spawnmenu
VJ.AddNPC_HUMAN("aahw atp soldier", "npc_vj_aahw_atp_soldier",{"weapon_vj_aahw_mp5"}, spawnCategory) -- Adds a NPC to the spawnmenu
VJ.AddNPC("aahw grunt melee", "npc_vj_aahw_grunt_melee", spawnCategory) -- Adds a NPC to the spawnmenu
VJ.AddNPC("mag agent torture", "npc_vj_aahw_mag_agent_torture", spawnCategory) -- Adds this abomination to the spawnmenu
VJ.AddNPC("aahw grunt suicidal bomber", "npc_vj_aahw_grunt_suicidal_bomber", spawnCategory) -- Adds a NPC to the spawnmenu
VJ.AddNPC("aahw vr training buddy", "npc_vj_aahw_vr_training_buddy", spawnCategory) -- Adds a NPC to the spawnmenu
VJ.AddNPC("aahw zombie grunt", "npc_vj_aahw_zombie_grunt", spawnCategory) -- Adds a NPC to the spawnmenu
VJ.AddClientConVar("vj_madness_blood_mess", 0)
VJ.AddClientConVar("vj_madness_gore", 1)
VJ.AddClientConVar("vj_madness_can_gib_ragdoll", 1)

if CLIENT then
	hook.Add("PopulateToolMenu", "VJ_ADDTOMENU_MADNESS_COMBAT", function()
		spawnmenu.AddToolMenuOption("DrVrej", "SNPC Configures", "madness combat remake snpc", "madness combat remake snpc", "", "", function(panel)
			if !game.SinglePlayer() && !LocalPlayer():IsAdmin() then
				panel:Help("#vjbase.menu.general.admin.not")
				panel:Help("#vjbase.menu.general.admin.only")
				return
			end
			panel:Help("#vjbase.menu.general.admin.only")
			panel:CheckBox("this make enemies die in a very gory way.", "vj_madness_blood_mess")
			panel:CheckBox("Enable Gore?", "vj_madness_gore")
			panel:CheckBox("Enable gib ragdoll?", "vj_madness_can_gib_ragdoll")
		end)
	end)
end