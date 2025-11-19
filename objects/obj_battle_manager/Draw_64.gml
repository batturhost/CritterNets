// --- Draw GUI Event ---

if (!variable_instance_exists(id, "btn_main_menu")) {
    exit; 
}

draw_set_font(fnt_vga);

// Check if we are in a special "Download" UI state
if (current_state == BATTLE_STATE.WIN_DOWNLOAD_PROGRESS || current_state == BATTLE_STATE.WIN_DOWNLOAD_COMPLETE)
{
    #region // --- DOWNLOAD UI (SAME AS BEFORE) ---
    // 1. Background
    draw_set_color(c_teal);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_scanlines_95(0, 0, display_get_gui_width(), display_get_gui_height());
    
    var _win_w = 440; var _win_h = 400;
    var _win_x1 = (display_get_gui_width() / 2) - (_win_w / 2);
    var _win_y1 = (display_get_gui_height() / 2) - (_win_h / 2);
    var _win_x2 = _win_x1 + _win_w; var _win_y2 = _win_y1 + _win_h;

    draw_rectangle_95(_win_x1, _win_y1, _win_x2, _win_y2, "raised");
    draw_set_color(c_navy);
    draw_rectangle(_win_x1 + 2, _win_y1 + 2, _win_x2 - 2, _win_y1 + 32, false); 
    draw_set_color(c_white);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_font(fnt_vga);
    draw_text(_win_x1 + (_win_w / 2), _win_y1 + 17, "File Acquisition");
    
    if (current_state == BATTLE_STATE.WIN_DOWNLOAD_PROGRESS) {
        draw_set_halign(fa_center); draw_set_valign(fa_top);
        draw_set_color(c_black);
        draw_text(_win_x1 + (_win_w / 2), _win_y1 + 100, "Downloading Critter-File...");
        draw_text(_win_x1 + (_win_w / 2), _win_y1 + 120, download_filename);
        var _bar_x1 = _win_x1 + (_win_w / 2) - (download_bar_w / 2);
        var _bar_y1 = _win_y1 + (_win_h / 2);
        var _bar_x2 = _bar_x1 + download_bar_w;
        var _bar_y2 = _bar_y1 + download_bar_h;
        draw_rectangle_95(_bar_x1, _bar_y1, _bar_x2, _bar_y2, "sunken");
        var _fill_width = (download_bar_w - 4) * (download_current_percent / 100);
        draw_set_color(c_navy);
        draw_rectangle(_bar_x1 + 2, _bar_y1 + 2, _bar_x1 + 2 + _fill_width, _bar_y2 - 2, false);
        draw_set_color(c_white);
        draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_text(_bar_x1 + (download_bar_w / 2), _bar_y1 + (download_bar_h / 2), string(floor(download_current_percent)) + "%");
        draw_set_color(c_black);
        draw_set_halign(fa_center); draw_set_valign(fa_top);
        draw_text(_win_x1 + (_win_w / 2), _win_y2 - 40, "[Downloading...]");
    } else { 
        draw_set_halign(fa_center); draw_set_valign(fa_top);
        draw_set_color(c_black);
        var _text = "Critter-File Download Complete!";
        if (download_end_percent >= 100) {
            _text = "Download Complete! Critter Acquired!";
        }
        draw_text(_win_x1 + (_win_w / 2), _win_y1 + 60, _text);
        var _sprite_w = sprite_get_width(download_sprite);
        var _sprite_h = sprite_get_height(download_sprite);
        var _box_w = 250; var _box_h = 200;
        var _scale = min(_box_w / _sprite_w, _box_h / _sprite_h);
        var _sprite_x = _win_x1 + (_win_w / 2);
        var _sprite_y = _win_y1 + 180 + ((_sprite_h / 2) * _scale);
        draw_sprite_ext(download_sprite, 0, _sprite_x, _sprite_y, _scale, _scale, 0, c_white, 1);
        draw_text(_win_x1 + (_win_w / 2), _win_y2 - 120, "You acquired data for:");
        draw_set_color(c_yellow);
        draw_text(_win_x1 + (_win_w / 2), _win_y2 - 100, enemy_critter_data.animal_name);
    }
    #endregion
}
else
{
    // --- DRAW THE NORMAL BATTLE UI (SOLID STYLE) ---
    
    // 1a. Draw the Window Frame (Gray)
    draw_rectangle_95(window_x1, window_y1, window_x2, window_y2, "raised");

    // 1b. Draw the Battle Viewport (Teal + Scanlines)
    draw_set_color(c_teal); 
    var _inner_x = window_x1 + 2;
    var _inner_y = window_y1 + 32; 
    var _inner_w = (window_x2 - 2) - _inner_x;
    var _inner_h = (window_y2 - 2) - _inner_y;
    
    gpu_set_scissor(_inner_x, _inner_y, _inner_w, _inner_h); 
    draw_rectangle(_inner_x, _inner_y, _inner_x + _inner_w, _inner_y + _inner_h, false);
    draw_scanlines_95(_inner_x, _inner_y, _inner_x + _inner_w, _inner_y + _inner_h);
    gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height()); 
    
    // 1c. Draw the Title Bar
    draw_set_color(c_navy);
    draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y1 + 32, false); 
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_vga);
    draw_text(window_x1 + (window_width / 2), window_y1 + 17, "CNet_Browser.exe - [BATTLE]");
    draw_set_halign(fa_left);

    // --- 3. Draw the Critter Sprites (WITH ICE & GLITCH EFFECT) ---
    var sprite_y_offset = -25;
    
    // --- PLAYER ---
    if (instance_exists(player_actor)) {
        var _p_sprite = player_actor.sprite_index; var _p_scale = player_actor.my_scale;
        var _p_x = player_actor.x; var _p_y = player_actor.y; 
        var _p_frame = player_actor.animation_frame; var _p_alpha = player_actor.faint_alpha;
        var _p_y_scale = player_actor.faint_scale_y;
        
        // Shadow
        draw_set_color(c_black); draw_set_alpha(0.3 * _p_alpha);
        var _shadow_w = sprite_get_width(_p_sprite) * _p_scale * 0.5; var _shadow_h = _shadow_w * 0.3; 
        draw_ellipse(_p_x - _shadow_w, _p_y - _shadow_h, _p_x + _shadow_w, _p_y + _shadow_h, false);
        draw_set_alpha(1.0);
        
        // === GLITCH VISUALS ===
        if (player_critter_data.glitch_timer > 0) {
            var _shake_x = random_range(-2, 2);
            var _shake_y = random_range(-2, 2);
            draw_sprite_ext(_p_sprite, _p_frame, _p_x - 3 + _shake_x, _p_y - sprite_y_offset + _shake_y, _p_scale, _p_scale * _p_y_scale, 0, c_red, 0.5);
            draw_sprite_ext(_p_sprite, _p_frame, _p_x + 3 + _shake_x, _p_y - sprite_y_offset + _shake_y, _p_scale, _p_scale * _p_y_scale, 0, c_aqua, 0.5);
            draw_sprite_ext(_p_sprite, _p_frame, _p_x + _shake_x, _p_y - sprite_y_offset + _shake_y, _p_scale, _p_scale * _p_y_scale, 0, c_white, _p_alpha);
        } else {
            draw_sprite_ext(_p_sprite, _p_frame, _p_x, _p_y - sprite_y_offset, _p_scale, _p_scale * _p_y_scale, 0, c_white, _p_alpha);
        }

        // === ICE PARTICLE VISUALS ===
        if (player_actor.vfx_type == "ice") {
            for (var i = 0; i < array_length(player_actor.vfx_particles); i++) {
                var _p = player_actor.vfx_particles[i];
                var _px = player_actor.x + _p.x;
                var _py = player_actor.y - sprite_y_offset + _p.y;
                var _alpha = _p.life / _p.max_life;
                
                draw_set_alpha(_alpha);
                draw_set_color(make_color_rgb(170, 255, 255)); 
                var _size = 6 * _p.scale;
                draw_line_width(_px - _size, _py, _px + _size, _py, 3);
                draw_line_width(_px, _py - _size, _px, _py + _size, 3);
            }
            draw_set_alpha(1.0);
        }
        
        // === NEW: SNOW VISUALS ===
        if (player_actor.vfx_type == "snow") {
            for (var i = 0; i < array_length(player_actor.vfx_particles); i++) {
                var _p = player_actor.vfx_particles[i];
                var _px = player_actor.x + _p.x;
                var _py = player_actor.y - sprite_y_offset + _p.y;
                var _alpha = _p.life / _p.max_life;
                draw_set_alpha(_alpha);
                draw_set_color(c_white);
                draw_circle(_px, _py, 3 * _p.scale, false);
            }
            draw_set_alpha(1.0);
        }

        gpu_set_blendmode(bm_add);
        draw_sprite_ext(_p_sprite, _p_frame, _p_x, _p_y - sprite_y_offset, _p_scale, _p_scale * _p_y_scale, 0, player_actor.flash_color, player_actor.flash_alpha * _p_alpha);
        gpu_set_blendmode(bm_normal);
    }
    
    // --- ENEMY ---
    if (instance_exists(enemy_actor)) {
        var _e_sprite = enemy_actor.sprite_index; var _e_scale = enemy_actor.my_scale;
        var _e_x = enemy_actor.x; var _e_y = enemy_actor.y; 
        var _e_frame = enemy_actor.animation_frame; var _e_alpha = enemy_actor.faint_alpha;
        var _e_y_scale = enemy_actor.faint_scale_y;
        
        // Shadow
        draw_set_color(c_black); draw_set_alpha(0.3 * _e_alpha);
        var _shadow_w = sprite_get_width(_e_sprite) * _e_scale * 0.5; var _shadow_h = _shadow_w * 0.3; 
        draw_ellipse(_e_x - _shadow_w, _e_y - _shadow_h, _e_x + _shadow_w, _e_y + _shadow_h, false);
        draw_set_alpha(1.0);
        
        // === GLITCH VISUALS ===
        if (enemy_critter_data.glitch_timer > 0) {
            var _shake_x = random_range(-2, 2);
            draw_sprite_ext(_e_sprite, _e_frame, _e_x - 3 + _shake_x, _e_y - sprite_y_offset, _e_scale, _e_scale * _e_y_scale, 0, c_red, 0.5);
            draw_sprite_ext(_e_sprite, _e_frame, _e_x + 3 + _shake_x, _e_y - sprite_y_offset, _e_scale, _e_scale * _e_y_scale, 0, c_aqua, 0.5);
            draw_sprite_ext(_e_sprite, _e_frame, _e_x + _shake_x, _e_y - sprite_y_offset, _e_scale, _e_scale * _e_y_scale, 0, c_white, _e_alpha);
        } else {
            draw_sprite_ext(_e_sprite, _e_frame, _e_x, _e_y - sprite_y_offset, _e_scale, _e_scale * _e_y_scale, 0, c_white, _e_alpha);
        }

        // === ICE PARTICLE VISUALS ===
        if (enemy_actor.vfx_type == "ice") {
            for (var i = 0; i < array_length(enemy_actor.vfx_particles); i++) {
                var _p = enemy_actor.vfx_particles[i];
                var _px = enemy_actor.x + _p.x;
                var _py = enemy_actor.y - sprite_y_offset + _p.y;
                var _alpha = _p.life / _p.max_life;
                
                draw_set_alpha(_alpha);
                draw_set_color(make_color_rgb(170, 255, 255)); 
                var _size = 6 * _p.scale;
                draw_line_width(_px - _size, _py, _px + _size, _py, 3);
                draw_line_width(_px, _py - _size, _px, _py + _size, 3);
            }
            draw_set_alpha(1.0);
        }

        // === NEW: SNOW VISUALS ===
        if (enemy_actor.vfx_type == "snow") {
            for (var i = 0; i < array_length(enemy_actor.vfx_particles); i++) {
                var _p = enemy_actor.vfx_particles[i];
                var _px = enemy_actor.x + _p.x;
                var _py = enemy_actor.y - sprite_y_offset + _p.y;
                var _alpha = _p.life / _p.max_life;
                draw_set_alpha(_alpha);
                draw_set_color(c_white);
                draw_circle(_px, _py, 3 * _p.scale, false);
            }
            draw_set_alpha(1.0);
        }
        
        gpu_set_blendmode(bm_add);
        draw_sprite_ext(_e_sprite, _e_frame, _e_x, _e_y - sprite_y_offset, _e_scale, _e_scale * _e_y_scale, 0, enemy_actor.flash_color, enemy_actor.flash_alpha * _e_alpha);
        gpu_set_blendmode(bm_normal);
    }

    // --- 4. Draw Battle Log Box (SOLID GRAY) ---
    var _log_y1 = window_y1 + (window_height * 0.8);
    var _log_y2 = window_y2 - 5;
    draw_rectangle_95(window_x1 + 5, _log_y1, window_x2 - 5, _log_y2, "sunken");

    // --- 5. Draw Battle Log Text ---
    draw_set_font(fnt_vga);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_black); // Black text on gray box
    
    if (current_state == BATTLE_STATE.PLAYER_TURN && (current_menu == MENU.FIGHT || current_menu == MENU.TEAM)) {
        // Hide log
    } else {
        draw_text(window_x1 + 15, _log_y1 + 10, battle_log_text);
    }

    // --- 6. Info Boxes (SOLID GRAY) ---
    draw_set_halign(fa_left);
    draw_set_color(c_white); 
    
    // Enemy Box
    draw_rectangle_95(info_enemy_x1, info_enemy_y1, info_enemy_x2, info_enemy_y2, "raised");
    draw_set_color(c_black);
    draw_text(info_enemy_x1 + 10, info_enemy_y1 + 8, current_opponent_data.name); 
    draw_set_halign(fa_right);
    draw_text(info_enemy_x2 - 10, info_enemy_y1 + 8, "Lv. " + string(enemy_critter_data.level));
    draw_set_halign(fa_left);
    
    var _e_hp_perc = enemy_critter_data.hp / enemy_critter_data.max_hp;
    var _e_bar_x1 = info_enemy_x1 + 10; var _e_bar_y1 = info_enemy_y1 + 40;
    var _e_bar_x2 = info_enemy_x2 - 10; var _e_bar_y2 = info_enemy_y1 + 60;
    draw_rectangle_95(_e_bar_x1, _e_bar_y1, _e_bar_x2, _e_bar_y2, "sunken"); 
    draw_set_color(c_green); 
    draw_rectangle(_e_bar_x1 + 2, _e_bar_y1 + 2, _e_bar_x1 + 2 + ((_e_bar_x2 - _e_bar_x1 - 4) * _e_hp_perc), _e_bar_y2 - 2, false); 

    // Player Box
    draw_rectangle_95(info_player_x1, info_player_y1, info_player_x2, info_player_y2, "raised");
    draw_set_color(c_black);
    draw_text(info_player_x1 + 10, info_player_y1 + 8, player_critter_data.nickname); 
    draw_set_halign(fa_right);
    draw_text(info_player_x2 - 10, info_player_y1 + 8, "Lv. " + string(player_critter_data.level));
    draw_set_halign(fa_left);
    
    var _p_hp_perc = player_critter_data.hp / player_critter_data.max_hp;
    var _p_bar_x1 = info_player_x1 + 10; var _p_bar_y1 = info_player_y1 + 40;
    var _p_bar_x2 = info_player_x2 - 10; var _p_bar_y2 = info_player_y1 + 60;
    draw_rectangle_95(_p_bar_x1, _p_bar_y1, _p_bar_x2, _p_bar_y2, "sunken"); 
    draw_set_color(c_green); 
    // ================== FIX: Use correct bottom coordinate ==================
    draw_rectangle(_p_bar_x1 + 2, _p_bar_y1 + 2, _p_bar_x1 + 2 + ((_p_bar_x2 - _p_bar_x1 - 4) * _p_hp_perc), _p_bar_y2 - 2, false); 
    // ========================================================================

    // --- 7. DRAW THE BATTLE UI (BUTTONS) ---
    draw_set_color(c_white); 
    if (current_state == BATTLE_STATE.PLAYER_TURN) {
        draw_set_font(fnt_vga);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        switch (current_menu) {
            case MENU.MAIN:
                for (var i = 0; i < 4; i++) { 
                    var _btn = btn_main_menu[i]; 
                    var _state = (menu_focus == i) ? "sunken" : "raised"; 
                    draw_rectangle_95(_btn[0], _btn[1], _btn[2], _btn[3], _state); 
                    draw_set_color(c_black); 
                    draw_text(_btn[0] + 60, _btn[1] + 15, _btn[4]); 
                }
                break;
            case MENU.FIGHT:
                for (var i = 0; i < 4; i++) { 
                    var _btn = btn_move_menu[i]; 
                    var _state = (menu_focus == i) ? "sunken" : "raised"; 
                    draw_rectangle_95(_btn[0], _btn[1], _btn[2], _btn[3], _state); 
                    draw_set_color(c_black); 
                    draw_text(_btn[0] + 60, _btn[1] + 15, _btn[4]); 
                }
                break;
            
            case MENU.TEAM:
                // --- TEAM MENU DRAW ---
                // Use default gray box for background
                draw_rectangle_95(window_x1 + 5, _log_y1, window_x2 - 5, window_y2 - 5, "raised");

                var _team_size = array_length(global.PlayerData.team);
                for (var i = 0; i < 6; i++) {
                    var _btn = btn_team_layout[i]; 
                    var _state = (menu_focus == i) ? "sunken" : "raised";
                    draw_rectangle_95(_btn[0], _btn[1], _btn[2], _btn[3], _state);
                    if (i < _team_size) {
                        var _critter = global.PlayerData.team[i];
                        if (_critter.hp <= 0 || _critter == player_critter_data) {
                            draw_set_color(c_dkgray);
                        } else {
                            draw_set_color(c_black);
                        }
                        draw_set_halign(fa_left);
                        draw_set_valign(fa_top);
                        var _sprite = _critter.sprite_idle;
                        var _frame_w = 64; var _frame_h = 64;
                        var _frame_x1 = _btn[0] + 10; var _frame_y1 = _btn[1] + 8;
                        var _frame_x2 = _frame_x1 + _frame_w; var _frame_y2 = _frame_y1 + _frame_h;
                        
                        draw_rectangle_95(_frame_x1, _frame_y1, _frame_x2, _frame_y2, "sunken");
                        var _scale = min((_frame_w - 8) / sprite_get_width(_sprite), (_frame_h - 8) / sprite_get_height(_sprite));
                        var _icon_x = _frame_x1 + (_frame_w / 2);
                        var _icon_y_center = _frame_y1 + (_frame_h / 2);
                        var _icon_draw_y = _icon_y_center + ((sprite_get_height(_sprite)/2) * _scale);
                        
                        gpu_set_scissor(_frame_x1 + 2, _frame_y1 + 2, _frame_w - 4, _frame_h - 4);
                        draw_sprite_ext(_sprite, 0, _icon_x, _icon_draw_y, _scale, _scale, 0, c_white, 1);
                        gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());
                        
                        var _text_x = _frame_x2 + 10;
                        draw_text(_text_x, _btn[1] + 10, _critter.nickname);
                        draw_text(_text_x, _btn[1] + 30, "Lv. " + string(_critter.level));
                        var _hp_perc = _critter.hp / _critter.max_hp;
                        var _hp_bar_x1 = _text_x; var _hp_bar_y1 = _btn[1] + 55; var _hp_bar_w = 100; var _hp_bar_h = 10;
                        draw_rectangle_95(_hp_bar_x1, _hp_bar_y1, _hp_bar_x1 + _hp_bar_w, _hp_bar_y1 + _hp_bar_h, "sunken");
                        draw_set_color(c_green);
                        draw_rectangle(_hp_bar_x1 + 2, _hp_bar_y1 + 2, _hp_bar_x1 + 2 + ((_hp_bar_w - 4) * _hp_perc), _hp_bar_y1 + _hp_bar_h - 2, false);
                        draw_set_color(c_black);
                        draw_set_halign(fa_right);
                        draw_text(_btn[2] - 10, _btn[1] + 55, string(_critter.hp) + "/" + string(_critter.max_hp));
                    }
                }
                var _cancel_btn = btn_team_layout[6];
                var _cancel_state = (menu_focus == 6) ? "sunken" : "raised";
                draw_rectangle_95(_cancel_btn[0], _cancel_btn[1], _cancel_btn[2], _cancel_btn[3], _cancel_state);
                draw_set_color(c_black);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text(_cancel_btn[0] + 60, _cancel_btn[1] + 20, "CANCEL");
                break;
        }
    }
}

// --- 9. Reset Draw Settings ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);