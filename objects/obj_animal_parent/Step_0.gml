// --- Step Event ---

// 1. Animate the sprite manually
animation_frame = (animation_frame + animation_speed) % sprite_get_number(sprite_index);

// 2. Handle Hurt Effect (Flash)
if (flash_alpha > 0) {
    flash_alpha -= 0.05; 
}

// ================== VFX LOGIC (ADJUSTED) ==================

// --- ICE SHARDS (Explosive Upward) ---
if (vfx_type == "ice") {
    if (vfx_timer > 0) { 
        for (var k = 0; k < 4; k++) { 
            var _new_particle = {
                x: random_range(-40, 40), 
                y: random_range(-sprite_get_height(sprite_index) * my_scale * 0.8, 10), 
                speed_x: random_range(-1.5, 1.5),
                speed_y: random_range(-3.5, -1.5), 
                life: irandom_range(40, 60), 
                max_life: irandom_range(40, 60),
                scale: random_range(1.0, 2.5), 
            };
            array_push(vfx_particles, _new_particle);
        }
    }
    for (var i = array_length(vfx_particles) - 1; i >= 0; i--) {
        var _p = vfx_particles[i];
        _p.y += _p.speed_y; 
        _p.x += _p.speed_x * 0.5; 
        _p.life -= 1;
        _p.scale = (_p.life / _p.max_life) * _p.scale; 
        if (_p.life <= 0) { array_delete(vfx_particles, i, 1); i--; }
    }
    vfx_timer--;
    if (vfx_timer <= 0 && array_length(vfx_particles) == 0) vfx_type = "none"; 
}

// --- NEW SNOW LOGIC (High Density, Top-Right Origin, ADJUSTED Y) ---
else if (vfx_type == "snow") {
    if (vfx_timer > 0) { 
        // Spawn 10 particles per frame (Dense!)
        for (var k = 0; k < 10; k++) { 
            var _h = sprite_get_height(sprite_index) * my_scale;
            var _new_particle = {
                // Spawn range: From center to far right (0 to 120),
                // and now higher, but not TOO high up (1x to 2x sprite height above head)
                x: random_range(-20, 120), 
                y: random_range(-_h * 1.5, -_h * 0.5), // <-- Adjusted Y range (less high up)
                
                // Wind: Blowing Left (-3 to -1)
                speed_x: random_range(-3.0, -1.0), 
                // Gravity: Falling Fast (2 to 4)
                speed_y: random_range(2.0, 4.0), 
                
                life: irandom_range(40, 70), 
                max_life: irandom_range(40, 70),
                scale: random_range(0.5, 2.0), // Mix of small and large flakes
            };
            array_push(vfx_particles, _new_particle);
        }
    }

    for (var i = array_length(vfx_particles) - 1; i >= 0; i--) {
        var _p = vfx_particles[i];
        
        _p.y += _p.speed_y; 
        _p.x += _p.speed_x;
        _p.life -= 1;
        
        if (_p.life <= 0) {
            array_delete(vfx_particles, i, 1);
            i--; 
        }
    }
    
    vfx_timer--;
    if (vfx_timer <= 0 && array_length(vfx_particles) == 0) vfx_type = "none"; 
}
// ========================================================


// --- 3. Run State Logic ---

if (is_fainting) {
    if (faint_scale_y > 0) {
        faint_scale_y -= 0.02; 
        faint_alpha -= 0.02;   
    } else {
        faint_scale_y = 0;
        faint_alpha = 0;
    }
    
} else if (shake_timer > 0) {
    shake_timer--;
    lunge_current_x = random_range(-3, 3);
    lunge_current_y = random_range(-3, 3); 
    
} else {
    switch (lunge_state) {
        case 1: // Lunge Forward
            lunge_current_x = lerp(lunge_current_x, lunge_target_x - home_x, 0.1);
            lunge_current_y = lerp(lunge_current_y, lunge_target_y - home_y, 0.1); 
            
            if (abs(lunge_current_x - (lunge_target_x - home_x)) < 5) { 
                lunge_state = 2;
            }
            break;
            
        case 2: // Return Home
            lunge_current_x = lerp(lunge_current_x, 0, 0.1);
            lunge_current_y = lerp(lunge_current_y, 0, 0.1); 
            
            if (abs(lunge_current_x) < 1 && abs(lunge_current_y) < 1) {
                lunge_current_x = 0;
                lunge_current_y = 0;
                lunge_state = 0;
            }
            break;
            
        default:
            lunge_current_x = 0;
            lunge_current_y = 0;
            break;
    }
}

x = home_x + lunge_current_x;
y = home_y + lunge_current_y;