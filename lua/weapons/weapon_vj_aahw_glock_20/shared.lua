AddCSLuaFile()

SWEP.Base         = "weapon_base"
SWEP.PrintName    = "glock 20"
SWEP.Category     = "madness combat"
SWEP.Author       = "noob_dev2323"
SWEP.Instructions = "Click LMB to shot"

SWEP.HoldType       = "pistol"
SWEP.Slot           = 2
SWEP.SlotPos        = 0 
SWEP.Weight         = 5
SWEP.AutoSwitchTo   = true
SWEP.AutoSwitchFrom = false

SWEP.MuzzleAttachment			= "muvygdajdbzzle" 	-- Should be "1" for CSS models or "muzzle" for hl2 models

SWEP.Spawnable      = true
SWEP.AdminSpawnable = true

SWEP.ViewModelFlip  = false 
SWEP.UseHands       = true 
SWEP.DrawCrosshair  = true


SWEP.Primary.Delay = 0.1
SWEP.Primary.Automatic   = false  
SWEP.Primary.Ammo        = "Pistol"
SWEP.Primary.ClipSize    = 12
SWEP.Primary.ClipMax     = 90
SWEP.Primary.DefaultClip = 45
SWEP.Primary.Sound       = Sound("noob_dev2323/madness/weapons/glock.wav")

SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""


SWEP.ViewModelFOV  = 70
SWEP.BobScale  = 2
SWEP.ViewModel  = "models/noob_dev2323/madness/weapons/c_glock20.mdl"
SWEP.WorldModel = "models/noob_dev2323/weapons/w_double_barrel_shotgun.mdl"

SWEP.IronSightsPos = Vector(-5.8, -8, 2.4)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.IronSightTime = 0.15
SWEP.IronSights = false
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end
function SWEP:shit_sound()
	if client then return end
	self:EmitSound("noob_dev2323/shotgun_reload.mp3")
end 
function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:DefaultReload(ACT_VM_RELOAD)
end
function SWEP:PrimaryAttack()
	if client then return end
    -- Checks if we have enough ammo to shoot
    if (self:CanPrimaryAttack() == false) then return end
	if(self.Owner:GetAmmoCount( self.Primary.Ammo ) < 0)then
	    return
	end

	local bullet = {}

	bullet.Num = 1
	bullet.Spread = Vector(0.02,0.02, 0)
	bullet.Damage = 20
	bullet.Dir= self.Owner:GetAimVector()
	bullet.Src = self.Owner:GetShootPos()
	bullet.Force = 10
	bullet.Tracer = 1
	bullet.Attacker = self.Owner
 
    self:TakePrimaryAmmo(1)
	self:FireBullets( bullet )
	self.Owner:ViewPunch(Angle(math.random(0.5,1.5), 0, 0))
	self.Weapon:EmitSound(Sound(self.Primary.Sound),75,100,1)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)

    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:SecondaryAttack()
    -- Don't toggle anything here.
    -- Holding secondary fire controls the ironsights.
    self:SetNextSecondaryFire(CurTime() + 0.1)
end

function SWEP:GetViewModelPosition(pos, ang)
    local targetPos = self.IronSightsPos
    local targetAng = self.IronSightsAng

    if not self.Owner:KeyDown(IN_ATTACK2) then
        targetPos = Vector(0, 0, 0)
        targetAng = Vector(0, 0, 0)
    end

    local speed = FrameTime() * 12

    self.SightPos = self.SightPos or Vector(0, 0, 0)
    self.SightAng = self.SightAng or Vector(0, 0, 0)

    self.SightPos = LerpVector(speed, self.SightPos, targetPos)
    self.SightAng = LerpVector(speed, self.SightAng, targetAng)

    ang:RotateAroundAxis(ang:Right(), self.SightAng.x)
    ang:RotateAroundAxis(ang:Up(), self.SightAng.y)
    ang:RotateAroundAxis(ang:Forward(), self.SightAng.z)

    pos = pos + ang:Right() * self.SightPos.x
    pos = pos + ang:Forward() * self.SightPos.y
    pos = pos + ang:Up() * self.SightPos.z

    return pos, ang
end




