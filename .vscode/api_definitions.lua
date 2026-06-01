---@class Sprite
---@field new fun(identifier: string, sprite_path: string, image_number: number, x_origin: number, y_origin: number): Sprite

---@class Survivor
---@field new fun(name: string): Survivor
---@field on_init any

---@class Callback
---@field add fun(event: any, callback: function): any

---@class Initialize
---@field add fun(func: function): any

---@type table<string, any> mods

---@class path
---@field combine fun(...: string): string

---@class Sound
---@field new fun(id: string, sound_path: string): Sound

---@class Tracer
---@field new fun(id: string): any

---@class Skill

---@class Particle

---@class Array

---@class ActorState
---@field new fun(id: string): any