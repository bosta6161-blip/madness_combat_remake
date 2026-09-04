ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeAttackEntityToSpawn = "obj_vj_bullet_shotgunbullet" -- The entity that is spawned when range attacking
ENT.AnimTbl_RangeAttack = {"vjges_weaponshotg"} -- Range Attack Animations
ENT.RangeDistance = 5000 -- This is how far away it can shoot
ENT.RangeToMeleeDistance = 80 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = false -- How much time until the projectile code is ran?

ENT.NoChaseAfterCertainRange = true
ENT.NoChaseAfterCertainRange_FarDistance = 3000 
ENT.NoChaseAfterCertainRange_CloseDistance = 1 
ENT.NoChaseAfterCertainRange_Type = "Regular"


	-- ====== Constantly Face Enemy ====== --
ENT.ConstantlyFaceEnemy = true  -- Should it face the enemy constantly?
ENT.ConstantlyFaceEnemy_IfVisible = true -- Should it only face the enemy if it's visible?
ENT.ConstantlyFaceEnemy_IfAttacking = true  -- Should it face the enemy when attacking?
ENT.ConstantlyFaceEnemy_Postures = "Moving" -- "Both" = Moving or standing | "Moving" = Only when moving | "Standing" = Only when standing

ENT.RangeAttackSoundLevel = 100
