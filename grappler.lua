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
    shoot2              = Sprite.new("sGrapplerShoot2",     path.combine(SPRITE_PATH, "shoot2.png"),        10, 16, 16),
    shoot3              = Sprite.new("sGrapplerShoot3_1",   path.combine(SPRITE_PATH, "shoot3_1.png"),      1, 16, 16),
    shoot3b_1           = Sprite.new("sGrapplerShoot3b_1",  path.combine(SPRITE_PATH, "shoot3b_1.png"),     1, 16, 16),
    shoot3b_2           = Sprite.new("sGrapplerShoot3b_2",  path.combine(SPRITE_PATH, "shoot3b_2.png"),     1, 16, 16),
    shoot4b              = Sprite.new("sGrapplerShoot4",     path.combine(SPRITE_PATH, "shoot4.png"),        1, 0, 0),
    shoot4             = Sprite.new("sGrapplerShoot4b",    path.combine(SPRITE_PATH, "cosmeticFlip.png"),  6, 16, 16),
    
}

local sHitSpark         = Sprite.new("sHitSpark",           path.combine(SPRITE_PATH, "hit_spark.png"),     6, 16, 16)
local sGrapplerSkills   = Sprite.new("sGrapplerSkills",     path.combine(SPRITE_PATH, "skills.png"),        5)
local sRopeTracer       = Sprite.new("sRopeTracer",         path.combine(SPRITE_PATH, "tracer.png",         1, 16, 16))
local sHook             = Sprite.new("sHook",               path.combine(SPRITE_PATH, "hook.png",           1, 16, 16))
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

--Create the new survivor instance: grappler
local grappler = Survivor.new("grappler")

grappler.sprite_idle = sprites.idle
grappler.sprite_title = sprites.walk
grappler.namespace = "Grappler"
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

primary.animation = sGrapplerShoot[1]
secondary.animation = sGrapplerShoot[4]
utility.animation = sGrapplerShoot[5]
special.animation = sGrapplerShoot[6]

-- assign a skill icon to each of the abilities
primary.sprite = sGrapplerSkills
primary.subimage = 0
secondary.sprite = sGrapplerSkills
secondary.subimage = 1
utility.sprite = sGrapplerSkills
utility.subimage = 2
special.sprite = sGrapplerSkills
special.subimage = 3

primary.damage = 1
primary.cooldown = 25
primary.is_primary = true
primary.ignore_aim_direction = false
local MAX_POGO_CHARGE = 3

secondary.damage = 0.5
secondary.cooldown = 2 * 60
secondary.is_utility = true

utility.damage = 5
utility.cooldown = 4 * 60

special.damage = 3
special.cooldown = 2 * 60

--create objects for the different skills
-- local oGrapplerWhip = Object.new("GrapplerWhip")
-- oGrapplerWhip:set_sprite(sGrapplerWhip)
-- oGrapplerWhip:set_depth(1)


-- create states that the actor can "be in"
local statePrimary = ActorState.new(primary.identifier)
statePrimary.activity_flags = ActorState.ActivityFlag.ALLOW_ROPE_CANCEL
local stateSecondary = ActorState.new(secondary.identifier)
local stateUtility = ActorState.new(utility.identifier)
local stateSpecial = ActorState.new(special.identifier)

-- set grappler's state to the ability that is activated
Callback.add(primary.on_activate, function(actor, skill, slot)
	actor:set_state(statePrimary)
end)
Callback.add(secondary.on_activate, function(actor, skill, slot)
	actor:set_state(stateSecondary)
end)
Callback.add(utility.on_activate, function(actor, skill, slot)
	actor:set_state(stateUtility)
end)
Callback.add(special.on_activate, function(actor, skill, slot)
	actor:set_state(stateSpecial)
end)

--Perform the skills 

-- Primary Skill
Callback.add(statePrimary.on_enter, function(actor, data)
    actor.image_index = 0
    data.fired = 0

    -- cycle through the attack animations of the grounded move
    if not data.attack_anim then
        data.attack_anim = 0
    end
    if actor.pogo_charges == nil then
        actor.pogo_charges = 0
    end

    local player = Player.get_local()
    data.perform_pogo = false
    if Util.bool(actor.free) and actor.pogo_charges > 0 and player:control("down", 0) then
        data.perform_pogo = true
    end


    if data.perform_pogo then
        actor.sprite_index = sGrapplerShoot.shoot1b
        data.attack_anim = 1
        primary.ignore_aim_direction = false
        primary.override_strafe_direction = false
    else
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
    end
    
    

end)

Callback.add(statePrimary.on_step, function(actor, data)

    actor:skill_util_fix_hspeed()
    actor:actor_animation_set(actor.sprite_index, 0.3)
    local player = Player.get_local()

    if data.perform_pogo then
        if actor.image_index >= 1 and data.fired == 0 then
            data.fired = 1
            local damage = actor:skill_get_damage(primary)
            local attack_info = actor:fire_explosion(actor.x + actor.image_xscale*30, actor.y+32, 65, 65, damage, nil, sHitSpark).attack_info
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

            actor:fire_explosion(actor.x + actor.image_xscale*30, actor.y, 100, 65, damage, nil, sHitSpark)
            
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

Callback.add(Callback.ON_KILL_PROC, function(target, attacker)
    -- increase the charges of the pogo primary on a kill
    if attacker.pogo_charges ~= nil then
        if attacker.pogo_charges <= MAX_POGO_CHARGE then
            attacker.pogo_charges = attacker.pogo_charges + 1
        end
    end

end)

Callback.add(Callback.ON_ATTACK_HIT, function(hit_info)
    if hit_info.attack_info.is_pogo then
        hit_info.inflictor.pVspeed = -hit_info.inflictor.pVmax * 1.5
    end
end)

--Secondary skill
Callback.add(stateSecondary.on_enter, function(actor, data)
    actor.image_index = 0
    data.fired = 0
end)

Callback.add(stateSecondary.on_step, function (actor, data)
    actor:skill_util_fix_hspeed()
    actor:actor_animation_set(sGrapplerShoot.shoot2, 0.4)

    
    if actor.image_index >= 6 and data.fired == 0 then
        data.fired = 1
        local damage = actor:skill_get_damage(secondary)
        local attack_info = actor:fire_explosion(actor.x + actor.image_xscale * 150, actor.y, 320, 40, damage, nil, sHitSpark).attack_info
        attack_info.__secondary_yoink = 1
        attack_info.__attacker_x = actor.x
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

            target:apply_knockback(-direction, 20, force, 4)
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

    if dist > 8 then
        lead.pHspeed = lead.image_xscale * 10
    else
        lead.pGravity1 = 0.1
        lead.pHspeed = -lead.image_xscale * 5
        lead.pVspeed = -lead.pVmax * 2
        lead:fire_direct(victim, lead:skill_get_damage(utility))
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
end)

Callback.add(stateUtility.on_step, function(actor, data)
    actor:skill_util_fix_hspeed()
    actor:actor_animation_set(sGrapplerShoot.shoot3b_1, 1)
    if actor.image_index >= 0 and data.fired == 0 then
        data.fired = 1

        local damage = actor:skill_get_damage(utility) -- damage moved to the secondary explosion
        local direction = actor:skill_util_facing_direction()
        -- To Do: add tracer object sprite
        local attack_info
        attack_info = actor:fire_bullet(actor.x, actor.y, 700, direction, 1, nil, sHook, rope_tracer).attack_info
        attack_info.is_tether = true

       
        
        attack_info.__attacker = actor
        attack_info.__sideTether = 1
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
        
        local followUpAttack = tether.lead:fire_explosion(tether.victim_x + tether.lead.image_xscale * 1, tether.victim_y + tether.lead.image_xscale * 1, 64, 64, 1, nil, sHitSpark).attack_info
        followUpAttack.is_tether_followup = true
    end
    -- Create a secondary explosion around the first hit which applies aoe stun and damage
    if hit_info.attack_info.is_tether_followup then
        if Net.host then
            hit_info.target:apply_knockback(1, 90, 0, Actor.KnockbackKind.STANDARD)
        end
    end

end)

--Special Skill
Callback.add(stateSpecial.on_enter, function(actor, data)
    actor.image_index = 0
    data.fired = 0
    actor.image_index = 0
    if Util.bool(actor.free) then
        actor.sprite_index = sGrapplerShoot.shoot4
    else
        actor.sprite_index = sGrapplerShoot.shoot4
    end
end)

Callback.add(stateSpecial.on_step, function(actor, data)
    actor:actor_animation_set(actor.sprite_index, 0.3, false)
    actor:skill_util_fix_hspeed()
    if data.fired < 1  and not Util.bool(actor.free) then
        actor.invincible = math.max(actor.invincible, 3)
        actor.pHspeed = actor.image_xscale * -4 * actor.pHmax
        data.fired = 1
    elseif data.fired < 1 and not Util.bool(actor.free) then
        -- Wouldn't you like to know what goes in this block
    end

    actor:skill_util_exit_state_on_anim_end()
end)