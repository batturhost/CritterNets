// --- scr_animal_helpers ---
// This script holds our "actor" functions

// --- ANIMAL INITIALIZER ---
function init_animal(_animal_object, _data, _sprite_to_use) {
    _animal_object.my_data = _data;
    _animal_object.sprite_index = _sprite_to_use;
    
    // Set its "home" position
    _animal_object.home_x = _animal_object.x;
    _animal_object.home_y = _animal_object.y;
}

// --- HURT EFFECT ---
function effect_play_hurt(_actor_object) {
    _actor_object.flash_alpha = 1.0;
    _actor_object.flash_color = c_white;
    _actor_object.shake_timer = 15;
}

// --- LUNGE EFFECT ---
function effect_play_lunge(_actor_object, _target_actor) {
    _actor_object.lunge_state = 1; 
    var _target_x = _actor_object.home_x + ((_target_actor.x - _actor_object.x) * 0.66);
    var _target_y = _actor_object.home_y + ((_target_actor.y - _actor_object.y) * 0.66); 
    _actor_object.lunge_target_x = _target_x;
    _actor_object.lunge_target_y = _target_y; 
}

// --- HEAL FLASH EFFECT ---
function effect_play_heal_flash(_actor_object) {
    _actor_object.flash_alpha = 1.0;
    _actor_object.flash_color = c_lime;
    _actor_object.shake_timer = 0;
}

// --- STAT FLASH EFFECT ---
function effect_play_stat_flash(_actor_object, _type = "debuff") {
    _actor_object.flash_alpha = 1.0;
    _actor_object.shake_timer = 0;
    if (_type == "debuff") {
        _actor_object.flash_color = c_red;
    } else {
        _actor_object.flash_color = c_aqua;
    }
}

// --- CHECK HEALTHY CRITTERS ---
function player_has_healthy_critters() {
    for (var i = 0; i < array_length(global.PlayerData.team); i++) {
        if (global.PlayerData.team[i].hp > 0) {
            return true; 
        }
    }
    return false;
}

// --- ICE EFFECT (SHARDS) ---
function effect_play_ice(_actor_object) {
    _actor_object.vfx_type = "ice";
    _actor_object.vfx_particles = []; 
    _actor_object.vfx_timer = 45; 
}

// ================== SNOW EFFECT (UPDATED) ==================
function effect_play_snow(_actor_object) {
    _actor_object.vfx_type = "snow";
    _actor_object.vfx_particles = []; 
    _actor_object.vfx_timer = 90; // Lasts 1.5 seconds
}
// ===========================================================