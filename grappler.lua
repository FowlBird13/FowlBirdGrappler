-- Sprite.new(identifier, sprite_path, image_number, x_origin, y_origin)

local SPRITE_PATH = path.combine(PATH, "Sprites")

-- Create a table with the basic animations
local sprites = {
    idle			    = Sprite.new("sGrapplerIdle",       path.combine(SPRITE_PATH, "idle.png"),          1, 15, 17),
    walk		        = Sprite.new("sGrapplerWalk",		path.combine(SPRITE_PATH, "walk.png"),          1, 15, 17),
    jump		        = Sprite.new("sGrapplerJump",		path.combine(SPRITE_PATH, "jump.png"),          1, 15, 17),
    jump_peak	        = Sprite.new("sGrapplerJumpPeak",	path.combine(SPRITE_PATH, "jump_peak.png"),     1, 15, 17),
    fall		        = Sprite.new("sGrapplerFall",		path.combine(SPRITE_PATH, "fall.png"),          1, 15, 17),
    climb		        = Sprite.new("sUtilitylimb",		path.combine(SPRITE_PATH, "climb.png"),         1, 13, 17),
    climb_hurt	        = Sprite.new("sUtilitylimbHurt",	path.combine(SPRITE_PATH, "climb.png"),         1, 13, 17),
    death		        = Sprite.new("sGrapplerDeath",		path.combine(SPRITE_PATH, "death.png"),         1, 15, 17),
    decoy		        = Sprite.new("sGrapplerDecoy",		path.combine(SPRITE_PATH, "decoy.png"),         1, 15, 17)
}

-- Create a table with the ability animations (referred to as "shoot")
local sGrapplerShoot = {
    shoot1_1            = Sprite.new("sGrapplerShoot1_1",   path.combine(SPRITE_PATH, "shoot1_1.png"),      5, 12, 50),
    shoot1_2            = Sprite.new("sGrapplerShoot1_2",   path.combine(SPRITE_PATH, "shoot1_2.png"),      5, 12, 50),
    shoot1_3            = Sprite.new("sGrapplerShoot1_3",   path.combine(SPRITE_PATH, "shoot1_3.png"),      5, 46, 50),
    shoot1b             = Sprite.new("sGrapplerShoot1b",    path.combine(SPRITE_PATH, "shoot1b.png"),       5, 7, 7),
    shoot2              = Sprite.new("sGrapplerShoot2",     path.combine(SPRITE_PATH, "shoot2.png"),        18, 16, 16),
    shoot2b             = Sprite.new("sGrapplerShoot2b",    path.combine(SPRITE_PATH, "shoot2b.png"),       18, 160, 16),
    shoot3              = Sprite.new("sGrapplerShoot3",   path.combine(SPRITE_PATH, "shoot3_1.png"),      7, 16, 16),
    shoot3b             = Sprite.new("sGrapplerShoot3b",  path.combine(SPRITE_PATH, "shoot3b.png"),     9, 16, 16),
    shoot3b_2           = Sprite.new("sGrapplerShoot3_old",  path.combine(SPRITE_PATH, "shoot3_old.png"),     1, 16, 16),
    shoot4b             = Sprite.new("sGrapplerShoot4",     path.combine(SPRITE_PATH, "shoot4b_test.png"),        6, 16, 16),
    shoot4              = Sprite.new("sGrapplerShoot4b",    path.combine(SPRITE_PATH, "cosmeticFlip.png"),  6, 16, 16)
    
}

local sGrapplerTornado = Sprite.new("sGrapplerTornado", path.combine(SPRITE_PATH, "tornado.png"),   3, 16, 16)
local sGrapplerPogoTracker = Sprite.new("sGrapplerPogoTracker", path.combine(SPRITE_PATH, "pogo_tracker.png"),   5, 7, 7)
local sHitSpark         = Sprite.new("sHitSpark",           path.combine(SPRITE_PATH, "hit_spark.png"),     6, 16, 16)
local sGrapplerSkills   = Sprite.new("sGrapplerSkills",     path.combine(SPRITE_PATH, "skills.png"),        10)
local sRopeTracer       = Sprite.new("sRopeTracer",         path.combine(SPRITE_PATH, "tracer.png",         1, 16, 16))
local sHook             = Sprite.new("sHook",               path.combine(SPRITE_PATH, "hook.png",           1, 16, 16))
local sSelectGrappler   = Sprite.new("sSelectGrappler",     path.combine(SPRITE_PATH, "select.png",         1, 28, 0))
local lightLineParticle   = Particle.new("sGrapplerLineParticle")
local particleWispGTracer = Particle.find("WispGTracer")
-- To Do: add tracer png

local slightLineParticle = Sprite.new("sRopeParticle", path.combine(SPRITE_PATH, "tracer.png",              1, 16, 16))


lightLineParticle:set_sprite(slightLineParticle, false, false, false) --sprite, animate, stretch, random
lightLineParticle:set_life(30, 30) --min, max
lightLineParticle:set_orientation(0, 0, 0, 0, true) --min, max, increase, wiggle, relative
lightLineParticle:set_speed(0, 0, 0, 0) --min, max, increase, wiggle
lightLineParticle:set_size(1, 1, 0, 0) --min, max, increase, wiggle
lightLineParticle:set_direction(0, 0, 0, 0) --min, max, increase, wiggle

--Sound effects
local wGrapplerSounds = {
    backstep        = Sound.find("HuntressShoot3B"),
    tether          = Sound.find("SniperShoot3"),
    swish           = Sound.find("Fwoosh"),
    quickWhip       = Sound.find("HuntressShoot2"),
    fullStockAlt1   = Sound.find("Jewel"),
    fullStockAlt2   = Sound.find("Medallion"),
    fullStockAlt3   = Sound.find("Mercenary_Parry_Ready"),
    tetherWhiff     = Sound.find("Mercenary_EviscerateWhiff"),
    fullyCharged    = Sound.find("BanditShoot4_1")
}


--Create the new survivor instance: grappler
local grappler = Survivor.new("grappler")

grappler.sprite_loadout = sSelectGrappler
grappler.sprite_idle = sprites.idle
grappler.sprite_title = sprites.walk
grappler.namespace = "Grappler"
grappler.cape_offset = Array.new({0, -8, 0, -5})

--The pogo tracker object created whenever Grappler is initiated
local objPogoTracker = Object.new("GrapplerPogoTracker")
objPogoTracker:set_sprite(sGrapplerPogoTracker)
objPogoTracker:set_depth(-280)
Callback.add(objPogoTracker.on_create, function(self)
    self.parent = -4 --returns an incorrect value if no parent is set
    self.image_index = 0
end)

Callback.add(grappler.on_init, function(actor)
	actor.sprite_idle			= sprites.idle
	actor.sprite_walk			= sprites.walk
	actor.sprite_jump			= sprites.jump
	actor.sprite_jump_peak		= sprites.jump_peak
	actor.sprite_fall			= sprites.fall
	actor.sprite_climb			= sprites.climb
	actor.sprite_death			= sprites.death
	actor.sprite_decoy			= sprites.decoy
	actor.sprite_climb_hurt		= sprites.climb_hurt

    --local data = Instance.get_data(actor) -- Not sure how to properly use this despite seeing it in every bit of mod code

    actor.pogo_charges          = 0
    actor.pogo_tracker          = objPogoTracker:create()
    actor.pogo_tracker.parent   = actor
    actor.primary_combo_timer    = 0 --The max combo is a local variable by the primary skill
end)

--These base stats and level stats need to be added and balanced. Miner and Drifter would be good to look at
grappler:set_stats_base({
    health = 10000,
    damage = 11,
    regen = 0.011
})

grappler:set_stats_level({
    health = 36,
    damage = 3,
    regen = 0.001,
    armor = 2,
})

local primary = grappler:get_skills(0)[1]
local secondary = grappler:get_skills(1)[1]
local utility = grappler:get_skills(2)[1]
local special = grappler:get_skills(3)[1]
local primaryAir = Skill.new("grapplerPrimaryAerial")
local secondaryAir = Skill.new("grapplerSecondaryAerial")
local utilityAir = Skill.new("grapplerUtilityAerial")
local specialAir = Skill.new("grapplerSpecialAerial")

primary.animation = sGrapplerShoot.shoot1_1
secondary.animation = sGrapplerShoot.shoot2
utility.animation = sGrapplerShoot.shoot3
special.animation = sGrapplerShoot.shoot4
primaryAir.animation = sGrapplerShoot.shoot1b
secondaryAir.animation = sGrapplerShoot.shoot2 --Reassign sprites for the new aerials
utilityAir.animation = sGrapplerShoot.shoot3b_1 --Reassign sprites for the new aerials
specialAir.animation = sGrapplerShoot.shoot4b --Reassign sprites for the new aerials

-- assign a skill icon to each of the abilities
primary.sprite = sGrapplerSkills
primary.subimage = 0
secondary.sprite = sGrapplerSkills
secondary.subimage = 2
utility.sprite = sGrapplerSkills
utility.subimage = 4
special.sprite = sGrapplerSkills
special.subimage = 6
primaryAir.sprite = sGrapplerSkills
primaryAir.subimage = 1
secondaryAir.sprite = sGrapplerSkills
secondaryAir.subimage = 3
utilityAir.sprite = sGrapplerSkills
utilityAir.subimage = 5
specialAir.sprite = sGrapplerSkills
specialAir.subimage = 7

primary.damage = 1
primary.cooldown = 25
primary.is_primary = true
primary.ignore_aim_direction = false
local COMBO_TIMER_MAX = 20

secondary.damage = 0.5
secondary.cooldown = 2 * 60

utility.damage = 5
utility.cooldown = 4 * 60
utility.is_utility = true

special.damage = 3
special.cooldown = 2 * 60

primaryAir.damage = 1
primaryAir.cooldown = 35
primaryAir.is_primary = true
primaryAir.ignore_aim_direction = false
local MAX_POGO_CHARGE = 4
local EXECUTE_THRESHOLD = 0.2

secondaryAir.damage = 0.5
secondaryAir.cooldown = 60 * 4

utilityAir.damage = 5
utilityAir.cooldown = 60 * 3
utilityAir.is_utility = true

specialAir.damage = 0.5
specialAir.cooldown = 60 * 5

-- create states that the actor can "be in"
local statePrimary = ActorState.new(primary.identifier)
statePrimary.activity_flags = ActorState.ActivityFlag.ALLOW_ROPE_CANCEL
local stateSecondary = ActorState.new(secondary.identifier)
local stateUtility = ActorState.new(utility.identifier)
local stateSpecial = ActorState.new(special.identifier)
local statePrimaryAir = ActorState.new(primaryAir.identifier)
local stateSecondaryAir = ActorState.new(secondaryAir.identifier)
local stateUtilityAir = ActorState.new(utilityAir.identifier)
local stateSpecialAir = ActorState.new(specialAir.identifier)

-- Callback.add(grappler.on_step, function(actor)
--     if Util.bool(actor.free) then
--         gm.actor_skill_set(grappler, 0, "grapplerPrimaryAerial")
--     else
--         gm.actor_skill_set(grappler, 0, "grapplerZ")
--     end
    
-- end)

-- set grappler's state to the ability that is activated
Callback.add(primary.on_activate, function(actor, skill, slot)
    local player = Player.get_local()
    if Util.bool(actor.free) and actor.pogo_charges > 0 and player:control("down", 0) then
	    actor:set_state(statePrimaryAir)
    else
        actor:set_state(statePrimary)
    end
end)
Callback.add(secondary.on_activate, function(actor, skill, slot)
	local player = Player.get_local()
    if Util.bool(actor.free) and player:control("down", 0) then
	    actor:set_state(stateSecondaryAir)
    else
        actor:set_state(stateSecondary)
    end
end)
Callback.add(utility.on_activate, function(actor, skill, slot)
	local player = Player.get_local()
    if Util.bool(actor.free) and player:control("down", 0) then
	    actor:set_state(stateUtilityAir)
    else
        actor:set_state(stateUtility)
    end
end)
Callback.add(special.on_activate, function(actor, skill, slot)
	local player = Player.get_local()
    if Util.bool(actor.free) and player:control("down", 0) then
	    actor:set_state(stateSpecialAir)
    else
        actor:set_state(stateSpecial)
    end
end)

--Perform the skills 

-- Primary Skill
Callback.add(grappler.on_step, function(actor)
    -- This resets the primary attack if it hasn't been used within a short time
    if actor.primary_combo_timer < COMBO_TIMER_MAX then
        actor.primary_combo_timer = actor.primary_combo_timer + 1
    end
end)

Callback.add(statePrimary.on_enter, function(actor, data)
    actor.image_index = 0
    data.fired = 0

    -- cycle through the attack animations of the grounded move
    -- reset the animation order if it hasn't been used within a certain time
    if not data.attack_anim or actor.primary_combo_timer >= COMBO_TIMER_MAX then
        data.attack_anim = 0
    end
    if data.attack_anim == 1 then
        actor.sprite_index = sGrapplerShoot.shoot1_2
        data.attack_anim = 2
        primary.override_strafe_direction = true
        primary.ignore_aim_direction = true
    elseif data.attack_anim == 2 then
        actor.sprite_index = sGrapplerShoot.shoot1_3
        data.attack_anim = 0
        primary.ignore_aim_direction = false
        primary.override_strafe_direction = false
    elseif data.attack_anim == 0 then
        actor.sprite_index = sGrapplerShoot.shoot1_1
        data.attack_anim = 1
        primary.ignore_aim_direction = false
        primary.override_strafe_direction = false
    end
end)

Callback.add(statePrimary.on_step, function(actor, data)

    actor:skill_util_fix_hspeed()
    actor:actor_animation_set(actor.sprite_index, 0.3)
    -- local player = Player.get_local()

    if data.perform_pogo then
        if actor.image_index >= 1 and data.fired == 0 then
            data.fired = 1
            local damage = actor:skill_get_damage(primary)
            local attack_info = actor:fire_explosion(actor.x + actor.image_xscale*30, actor.y+32, 120, 120, damage, nil, sHitSpark).attack_info
            attack_info.is_pogo = true
            attack_info.attacker = actor
            actor.pogo_charges = actor.pogo_charges - 1
        end
    else
        --To Do: Stretch the third attacks hitbox so it scales with move speed.
        
        if data.attack_anim == 0 then
            actor.pHspeed = 3.0 * actor.pHmax * actor.image_xscale
        end

        if actor.image_index >= 0 and data.fired == 0 then
            data.fired = 1
            
            actor:skill_util_nudge_forward(2 * actor.image_xscale)

            local damage = actor:skill_get_damage(primary)

            actor:fire_explosion(actor.x + actor.image_xscale*30, actor.y, 100, 65, damage, nil, sHitSpark, false)
            wGrapplerSounds.quickWhip:play(actor.x, actor.y, 0.9, math.random() * 0.1 + 1.5)
        end
    end
    actor:skill_util_exit_state_on_anim_end()
    
end)

Callback.add(statePrimary.on_exit, function(actor, data)
    if data.attack_anim == 0 then
        local primary_skill = actor:get_active_skill(Skill.Slot.PRIMARY)
        primary_skill:override_cooldown(30)
    end
end)

Callback.add(objPogoTracker.on_draw, function(inst)
    if not Instance.exists(inst.parent) then
		inst:destroy()
		return
	end
    local actor = inst.parent
    inst.image_index = actor.pogo_charges
    inst:draw_sprite(sGrapplerPogoTracker, actor.pogo_charges, actor.ghost_x, actor.ghost_y + 20)
end)

Callback.add(statePrimary.on_exit, function(actor, data)
    actor.primary_combo_timer = 0
end)

--Primary Air Skill
Callback.add(statePrimaryAir.on_enter, function(actor, data)
    actor.image_index = 0
    data.fired = 0
    actor.sprite_index = sGrapplerShoot.shoot1b
end)

Callback.add(statePrimaryAir.on_step, function(actor, data)
    actor:skill_util_fix_hspeed()
    actor:actor_animation_set(actor.sprite_index, 0.3)

    if actor.image_index >= 1 and data.fired == 0 then
        data.fired = 1
        local damage = actor:skill_get_damage(primary)
        local attack_info = actor:fire_explosion(actor.x + actor.image_xscale*30, actor.y+32, 120, 120, damage, nil, sHitSpark).attack_info
        attack_info.is_pogo = true
        attack_info.attacker = actor
        actor.pogo_charges = actor.pogo_charges - 1
    end

    actor:skill_util_exit_state_on_anim_end()
end)

Callback.add(Callback.ON_KILL_PROC, function(target, attacker)
    -- increase the charges of the pogo primary on a kill
    if attacker.pogo_charges ~= nil then
        if attacker.pogo_charges < MAX_POGO_CHARGE then
            attacker.pogo_charges = attacker.pogo_charges + 1
            if attacker.pogo_charges == MAX_POGO_CHARGE then
                wGrapplerSounds.fullStockAlt1:play(attacker.x, attacker.y, 0.9, math.random() * 0.1 + 0.5)
            end
        end
    end

end)

Callback.add(Callback.ON_ATTACK_HIT, function(hit_info)
    if hit_info.attack_info.is_pogo then
        local inflictor = hit_info.inflictor
        local victim = hit_info.target
        inflictor.pVspeed = -hit_info.inflictor.pVmax * 1.5

        --execute enemies
        local executeThreshold = EXECUTE_THRESHOLD
        local maxhp = victim.maxhp
        local hp = victim.hp
        local missingPercent = (maxhp - hp) / maxhp

        local damage = (missingPercent * (maxhp * executeThreshold) / (1-executeThreshold)) / inflictor.damage
        inflictor:fire_direct(victim, damage, 0, victim.x, victim.y, nil, true)
    
    end
end)

--Secondary skill
Callback.add(stateSecondary.on_enter, function(actor, data)
    actor.image_index = 0
    data.fired = 0
    data.charged = true
    wGrapplerSounds.fullyCharged:play(actor.x, actor.y, 0.9, math.random() * 0.05 + 0.5)
end)

Callback.add(stateSecondary.on_step, function (actor, data)
    actor:skill_util_fix_hspeed()
    actor:actor_animation_set(sGrapplerShoot.shoot2, 0.4)
    
    if actor.image_index < 8 then
        local secondary_skill = actor:get_active_skill(Skill.Slot.SECONDARY)
        secondary_skill:freeze_cooldown()
    end

    local release = not Util.bool(actor.x_skill)

    if release and data.charged and actor.image_index <= 7 then
        data.charged = false
        actor.image_index = 8
    end

    if actor.image_index >= 12 and data.fired == 0 then
        data.fired = 1
        local damage = actor:skill_get_damage(secondary)
        local attack_info = actor:fire_explosion(actor.x + actor.image_xscale * 150, actor.y, 320, 64, damage, nil, sHitSpark).attack_info
        attack_info.__secondary_yoink = 1
        attack_info.__attacker_x = actor.x
        attack_info.__is_charged = data.charged

        wGrapplerSounds.swish:play(actor.x, actor.y, 0.9, 0.9)
    end
    actor:skill_util_exit_state_on_anim_end()
end)

Callback.add(Callback.ON_ATTACK_HIT, function(hit_info)
    local is_secondary_hit = hit_info.attack_info.__secondary_yoink
    if Net.host then
        if is_secondary_hit then
            local target = hit_info.target
            local attacker_x = hit_info.attack_info.__attacker_x
            local direction = Math.sign(attacker_x - target.x)

            local distance = Math.distance(attacker_x, 0, target.x, 0)

            local force = distance/24

            local duration = 20
            if hit_info.attack_info.__is_charged then
                duration = 40
            end

            target:apply_knockback(-direction, duration, force, 4)
        end
    end
end)

--Secondary Air skill
local objScoopTether = Object.new("GrapplerScoop")
objScoopTether:set_depth(-280)

Callback.add(objScoopTether.on_create, function(self)
    self.target = -4
    self.x1 = "not a coordinate"
    self.y1 = "not a coordinate"
    self.parent = -5
end)

Callback.add(objScoopTether.on_step, function(self)
    if not Instance.exists(self.parent) or not Instance.exists(self.target) then self:destroy() return end --I assume this destroys the tether if the player dies (I stole it from Executioner)
    local target = self.target
    local speed = self.speed
    local x1 = self.x1
    local y1 = self.y1
    local facing = Math.sign(target.x-x1)
    local above = Math.sign(target.y-y1)


    if math.abs(target.x - x1) > speed or math.abs(target.y - y1) > speed then
        if  math.abs(target.x - x1) > speed then
            target.x = target.x - speed * facing
        end
        if math.abs(target.y - y1) > speed  then
            target.y = target.y - speed * above
        end
    else
        self:destroy()
        target.pVspeed = -1
    end
end)

-- Callback.add(objScoopTether.on_draw, function(self)
--     local width = 2
--     local x2 = self.target.x
--     local y2 = self.target.y
--     local x1 = self.x1
--     local y1 = self.y1

--     gm.draw_set_color(Color.from_rgb(255, 0, 0))
--     gm.draw_set_alpha(1)
    
    
--     gm.draw_line_width(x1, y1, x2, y2, width)
-- end)

Callback.add(stateSecondaryAir.on_enter, function(actor, data)
    actor.image_index = 0
    data.fired = 0
    data.charged = true
    data.freeze_x = actor.x
    data.freeze_y = actor.y
end)

Callback.add(stateSecondaryAir.on_step, function(actor, data)
    actor:skill_util_fix_hspeed()
    actor:actor_animation_set(sGrapplerShoot.shoot2b, 0.3, false)
    actor.x = data.freeze_x
    actor.y = data.freeze_y
    actor.free = false
    
    local release = not Util.bool(actor.x_skill)

    if release and data.charged and actor.image_index <= 7 then
        data.charged = false
        actor.image_index = 8
    end

    if actor.image_index > 14 and data.fired == 0 then
        if data.charged then
            wGrapplerSounds.fullyCharged:play(actor.x, actor.y, 0.9, math.random() * 0.05 + 0.5)
        end
        local damage = actor:skill_get_damage(secondary)
        data.fired = true
        local attack_info = actor:fire_explosion(actor.x + actor.image_xscale * 1, actor.y + 76, 320, 140, damage, nil, sHitSpark).attack_info
        attack_info.__is_secondary_aerial = true
        attack_info.__charged_secondary_aerial = data.charged
    end

    actor:skill_util_exit_state_on_anim_end()
end)

Callback.add(stateSecondaryAir.on_exit, function(actor, data)
    actor.free = true
    actor.pVspeed = -5
end)

Callback.add(Callback.ON_ATTACK_HIT, function(hit_info)
    local attack_info = hit_info.attack_info
    if attack_info.__is_secondary_aerial then
        local attacker = hit_info.inflictor
        local victim = hit_info.target
        if attack_info.__charged_secondary_aerial and not victim:is_climbing() then
            local direction = attacker:skill_util_facing_direction()
            local side = 1
            if direction ~= 0 then
                side = -1
            end
            local pullForce = objScoopTether:create()
            pullForce.target = hit_info.target
            pullForce.speed = 15
            pullForce.x1 = attacker.x + 80*side
            pullForce.y1 = attacker.y
        else
            victim.pVspeed = -4 * victim.pHmax
        end
    end
end)

--Utility skill
local objTether = Object.new("GrapplerTether")
objTether:set_depth(-280)

Callback.add(objTether.on_create, function(self)
    self.lead = -4
    self.victim_x = "incorrect x" --These have filler values to throw exceptions if they reach functions without being changed
    self.victim_y = "incorrect y"
    self.stall_timer = 10
    self.lead_y = "incorrect lead y"
    self.lead_x = "incorrect lead x"
    -- self:instance_syn()
end)

Callback.add(objTether.on_step, function(self)
    if not Instance.exists(self.lead) then self:destroy() return end --I assume this destroys the tether if the player dies (I stole it from Executioner)

    local lead = self.lead
    local victim = self.victim
    local x1 = self.lead.x
    local y1 = self.lead.y
    local x2 = self.victim_x
    local y2 = self.victim_y
    local dist = Math.distance(x1, 0, x2, 0)
    local dir = Math.direction(x1, y1, x2, y2)
    local facing = Math.sign(x1-x2)
    local damage = lead:skill_get_damage(utility)
    local speed = 50
    local above = Math.sign(y1-y2)
    
    if self.stall_timer > 0 then
        self.stall_timer = self.stall_timer - 1
        lead.x = self.lead_x
        lead.y = self.lead_y
    elseif math.abs(lead.x - x2) > speed or math.abs(lead.y - y2) > speed then
        if  math.abs(lead.x - x2) > speed then
            lead.x = lead.x - speed * facing
        end
        if math.abs(lead.y - y2) > speed  then
            lead.y = lead.y - speed * above  
        end
    else
        lead.pGravity1 = 0.5
        lead.pHspeed = -lead.image_xscale * 3
        lead.pVspeed = -lead.pVmax * 2
        lead:fire_explosion(x2 + lead.image_xscale * 1, y2 + lead.image_xscale * 1, 64, 64, damage, nil, sHitSpark)
        self:destroy()
    end


end)

Callback.add(objTether.on_draw, function(self)
    local width = 2
    local x1 = self.lead.x
    local y1 = self.lead.y
    local x2 = self.victim_x
    local y2 = self.victim_y

    gm.draw_set_color(Color.from_rgb(0, 255, 255))
    gm.draw_set_alpha(1)
    
    
    gm.draw_line_width(x1, y1, x2, y1, width)
    
        

end)

Callback.add(objTether.on_destroy, function(self)
    if Instance.exists(self.lead) then
        local actor = self.lead
        actor.image_index = 3
    end
end)

local rope_tracer = Tracer.new("grapplerMantle")
rope_tracer.sparks_offset_y = -5
rope_tracer.show_sparks_if_miss = 1

rope_tracer:set_callback(function(x1, y1, x2, y2, color)
    y1 = y1
	y2 = y2

    local distance = Math.distance(x1, y1, x2, y2)
    local direction = Math.direction(x1, y1, x2, y2)

    local inst = Object.find("EfLineTracer"):create(x1, y1) --gotta find the right object identifier
    
    inst.xend = x2
    inst.yend = y2
    inst.sprite_index = sHook
    inst.image_speed = 0.1
    inst.rate = 2
    inst.blend_1 = Color.from_rgb(255, 0, 0)
    inst.blend_2 = Color.from_rgb(255, 0, 0)
    inst.blend_rate = 1
    inst.image_alpha = 1
    inst.bm = 1
    inst.width = 1
    


    -- lightLineParticle:set_direction(direction, direction, 0, 0)

    -- local px = x1
    -- local i = 0
    -- local life_time = 0
    -- while i < distance do
    --     life_time = (distance - i)/15
    --     lightLineParticle:set_life(life_time, life_time)
	-- 	lightLineParticle:create_color(px, y1, Color.from_rgb(0, 255, 255), 1)
	-- 	px = px + gm.lengthdir_x(4, direction)
	-- 	i = i + 4
	-- end




end)

Callback.add(stateUtility.on_enter, function(actor, data)
    actor.image_index = 0
    data.fired = 0
    data.expire_timer = 0
end)

Callback.add(stateUtility.on_step, function(actor, data)
    actor:skill_util_fix_hspeed()
    actor:actor_animation_set(sGrapplerShoot.shoot3, 0.3)
    if actor.image_index >= 0 and data.fired == 0 then
        data.fired = 1
        local direction = actor:skill_util_facing_direction()
        -- To Do: add tracer object sprite
        local attack_info
        attack_info = actor:fire_bullet(actor.x, actor.y, 700, direction, 0, nil, sHook, rope_tracer).attack_info
        attack_info.is_tether = true
        attack_info.__attacker = actor
        attack_info.__sideTether = 1

        wGrapplerSounds.tether:play(actor.x, actor.y, 0.9, 1.5)
    end
    
    -- This if statement is used to hold the grappler in their
    -- dashing animation until the tether is destroyed.
    if actor.image_index < 2 then
        actor.image_index = 1
        data.expire_timer = data.expire_timer + 1
    end
    
    if data.expire_timer > 40 then
        actor.image_index = 6
    end

    actor:skill_util_exit_state_on_anim_end()
end)

Callback.add(Callback.ON_ATTACK_HIT, function(hit_info)
    if hit_info.attack_info.is_tether then
        local tether = objTether:create()
        tether.lead = hit_info.inflictor
        tether.victim = hit_info.target
        tether.victim_x = hit_info.target.x
        tether.victim_y = hit_info.target.y
        tether.lead_x = hit_info.inflictor.x
        tether.lead_y = hit_info.inflictor.y
        
        local followUpAttack = tether.lead:fire_explosion(tether.victim_x + tether.lead.image_xscale * 1, tether.victim_y + tether.lead.image_xscale * 1, 64, 64, 0, nil, sHitSpark).attack_info
        followUpAttack.is_tether_followup = true
    end
    -- Create a secondary explosion around the first hit which applies aoe stun
    if hit_info.attack_info.is_tether_followup then
        if Net.host then
            hit_info.target:apply_knockback(1, 90, 0, Actor.KnockbackKind.STANDARD)
        end
    end

end)

--Utility Air Skill
Callback.add(stateUtilityAir.on_enter, function(actor, data)
    data.fired = 0
    actor.image_index = 0
    actor.sprite_index = sGrapplerShoot.shoot3b
    data.x1 = actor.x
    data.y1 = actor.y
end)

Callback.add(stateUtilityAir.on_step, function(actor, data)
    actor:skill_util_fix_hspeed()
    actor:actor_animation_set(actor.sprite_index, 0.2, false)
    if actor.image_index <= 3 then
        actor.x = data.x1
        actor.y = data.y1
    end

    if data.fired < 1 and actor.image_index > 3 then
        data.fired = 1
        local dir = 225
        if 0 == actor:skill_util_facing_direction() then
            dir = -45
        end

        local attack_info
        attack_info = actor:fire_bullet(actor.x, actor.y, 700, dir, 0, nil, sHook, rope_tracer).attack_info
        attack_info.__is_down_tether = true
    end

    actor:skill_util_exit_state_on_anim_end()
end)

Callback.add(stateUtilityAir.on_exit, function(actor, data)
    actor.pVspeed = 0
end)

Callback.add(Callback.ON_ATTACK_HIT, function(hit_info)
    local attack_info = hit_info
    if attack_info.__is_down_tether then
        
    end
end)

--Special Skill
Callback.add(stateSpecial.on_enter, function(actor, data)
    actor.image_index = 0
    data.fired = 0
    actor.sprite_index = sGrapplerShoot.shoot4
end)

Callback.add(stateSpecial.on_step, function(actor, data)
    actor:actor_animation_set(actor.sprite_index, 0.3, false)
    actor:skill_util_fix_hspeed()

    if actor.image_index > 1 and data.fired < 1 then
        actor.invincible = math.max(actor.invincible, 30)
        actor.pHspeed = actor.image_xscale * -3 * actor.pHmax
        actor.pVspeed = actor.pVmax * -2
        data.fired = 1
        wGrapplerSounds.backstep:play(actor.x, actor.y, 0.9 + math.random() * 0.1, 0.9)
    end

    actor:skill_util_exit_state_on_anim_end()
end)

--Special Air Skill
local objLinks = Object.new("objGrapplerLink")
objLinks:set_depth(-280)
objLinks:set_sprite(sGrapplerTornado)

Callback.add(objLinks.on_create, function(inst)
    inst.parent = -4

    local data = Instance.get_data(inst)
    data.lifetime = 300
    data.targets = {}
    data.speed = 1
end)

Callback.add(objLinks.on_step, function(inst)
    if not Instance.exists(inst.parent) then inst:destroy() return end 

    local data = Instance.get_data(inst)

    if #data.targets <= 0 then
        inst:destroy()
        return
    end

    if data.lifetime >= 0 then
        data.lifetime = data.lifetime - 1
    else
        inst:destroy()
        return
    end

    --hold all enemies connected by the links in place
    for _, target in ipairs(data.targets) do
        target.enemy.x = target.x
        target.enemy.y = target.y
        if Net.Host then
            target.enemy:apply_knockback(1, 5, 0)
        end
    end



    --shorten the first tether until it deletes itself and deals damage to the target
    local speed = data.speed
    local x2 = data.targets[1].x
    local y2 = data.targets[1].y
    local facing = Math.sign(inst.x - x2)
    local above = Math.sign(inst.y - y2)

    if math.abs(inst.x - x2) > speed or math.abs(inst.y - y2) > speed then
        if  math.abs(inst.x - x2) > speed then
            inst.x = inst.x - speed * facing
        end
        if math.abs(inst.y - y2) > speed  then
            inst.y = inst.y - speed * above
        end
    else
        local damage = inst.parent:skill_get_damage(specialAir)
        inst.parent:fire_direct(data.targets[1].enemy, damage)
        table.remove(data.targets, 1)
    end

end)

Callback.add(objLinks.on_draw, function(inst)

    local data = Instance.get_data(inst)

    gm.draw_set_color(Color.from_rgb(0, 255, 255))
    gm.draw_set_alpha(1)
    local previousX = inst.x
    local previousY = inst.y

    if #data.targets > 0 then
        for _, target in ipairs(data.targets) do
            gm.draw_line_width(previousX, previousY, target.x, target.y, 2)
            previousX = target.x
            previousY = target.y
        end
    end
    
end)

Callback.add(objLinks.on_destroy, function(inst)
    
end)

Callback.add(stateSpecialAir.on_enter, function(actor, data)
    data.fired = 0
    actor.image_index = 0
    actor.sprite_index = sGrapplerShoot.shoot4b
    data.freeze_x = actor.x
    data.freeze_y = actor.y
end)

Callback.add(stateSpecialAir.on_step, function(actor, data)
    actor:skill_util_fix_hspeed()
    actor:actor_animation_set(actor.sprite_index, 0.2, false)
    actor.x = data.freeze_x
    actor.y = data.freeze_y
    actor.free = false

    if data.fired < 1 and actor.image_index > 3 then
        data.fired = 1
        local links = objLinks:create(actor.x, actor.y)
        links.parent = actor
        --an array table???
        local actors = actor:get_collisions_circle(gm.constants.pActorCollisionBase, 300)
        local indexCounter = 0
        local linkData = Instance.get_data(links)
        for _, enemy in ipairs(actors) do
            if Util.bool(enemy.free) and enemy.team ~= actor.team then

                table.insert(linkData.targets, {
                    enemy = enemy,
                    x = enemy.x,
                    y = enemy.y
                })
                indexCounter = indexCounter + 1
            end
        end
    end

    actor:skill_util_exit_state_on_anim_end()
end)

Callback.add(stateSpecialAir.on_exit, function(actor, data)
    actor.free = true
    actor.pVspeed = -2
end)