-- Sprite.new(identifier, sprite_path, image_number, x_origin, y_origin)

local SPRITE_PATH = path.combine(PATH, "Sprites")

-- Create a table with the basic animations
local sprites = {
    idle			    = Sprite.new("sGrapplerIdle",       path.combine(SPRITE_PATH, "idle.png"),     1, 15, 17),
    walk		        = Sprite.new("sGrapplerWalk",		path.combine(SPRITE_PATH, "walk.png"),     1, 15, 17),
    jump		        = Sprite.new("sGrapplerJump",		path.combine(SPRITE_PATH, "jump.png"),     1, 15, 17),
    jump_peak	        = Sprite.new("sGrapplerJumpPeak",	path.combine(SPRITE_PATH, "jump_peak.png"), 1, 15, 17),
    fall		        = Sprite.new("sGrapplerFall",		path.combine(SPRITE_PATH, "fall.png"),     1, 15, 17),
    climb		        = Sprite.new("sUtilitylimb",		path.combine(SPRITE_PATH, "climb.png"),    1, 13, 17),
    climb_hurt	        = Sprite.new("sUtilitylimbHurt",	path.combine(SPRITE_PATH, "climb.png"),    1, 13, 17),
    death		        = Sprite.new("sGrapplerDeath",		path.combine(SPRITE_PATH, "death.png"),    1, 15, 17),
    decoy		        = Sprite.new("sGrapplerDecoy",		path.combine(SPRITE_PATH, "decoy.png"),    1, 15, 17)
}

-- Create a table with the ability animations (referred to as "shoot")
local sGrapplerShoot = {
    shoot1_1              = Sprite.new("sGrapplerShoot1_1",     path.combine(SPRITE_PATH, "shoot1_1.png"),       5, 15, 16),
    shoot1_2              = Sprite.new("sGrapplerShoot1_2",     path.combine(SPRITE_PATH, "shoot1_2.png"),       5, 15, 16),
    shoot1_3              = Sprite.new("sGrapplerShoot1_3",     path.combine(SPRITE_PATH, "shoot1_3.png"),       5, 15, 16),
    shoot2              = Sprite.new("sGrapplerShoot2",     path.combine(SPRITE_PATH, "shoot2.png"),     10, 16, 16),
    shoot3              = Sprite.new("sGrapplerShoot3",     path.combine(SPRITE_PATH, "shoot3.png"),       1, 0, 0),
    shoot4              = Sprite.new("sGrapplerShoot4",     path.combine(SPRITE_PATH, "shoot4.png"),       1, 0, 0)
}

local sHitSpark     = Sprite.new("sHitSpark",       path.combine(SPRITE_PATH, "hit_spark.png"), 6, 16, 16)
local sGrapplerSkills = Sprite.new("sGrapplerSkills", path.combine(SPRITE_PATH, "skills.png"), 5)





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

--These base stats and level stats needed to be added and balanced. Miner and Drifter would be good to look at
grappler:set_stats_base({
    health = 10000,
    damage = 10,
    regen = 100
})

grappler:set_stats_level({
    health = 1,
    damage = 2,
    regen = 1,
    armor = 1,
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
primary.cooldown = 1 * 60
secondary.damage = 3
secondary.cooldown = 2 *60
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
Callback.add(statePrimary.on_enter, function(actor, data)
    actor.image_index = 0
    data.fired = 0

    if not data.attack_anim then
        data.attack_anim = 0
    end

    actor.sprite_index = sGrapplerShoot.shoot1_1
    if data.attack_anim == 1 then
        actor.sprite_index = sGrapplerShoot.shoot1_2
    elseif data.attack_anim == 2 then
        actor.sprite_index = sGrapplerShoot.shoot1_3
    end

end)

Callback.add(statePrimary.on_step, function(actor, data)
    actor:skill_util_fix_hspeed()
    actor:actor_animation_set(actor.sprite_index, 0.3)

    if actor.image_index >= 0 and data.fired == 0 then
        data.fired = 1
        
        actor:skill_util_nudge_forward(2 * actor.image_xscale)

        local damage = actor:skill_get_damage(primary)

        actor:fire_explosion(actor.x + actor.image_xscale * 30, actor.y, 100, 65, damage, nil, sHitSpark)
    end
    
    
    actor:skill_util_exit_state_on_anim_end()
end)

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
        actor:fire_explosion(actor.x + actor.image_xscale * 30, actor.y, 320, 40, damage, nil, sHitSpark)
    end


    
    actor:skill_util_exit_state_on_anim_end()
end)