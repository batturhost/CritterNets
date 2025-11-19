// --- Step Event ---

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

// --- 1. Timers ---
if (heal_message_timer > 0) {
    heal_message_timer--;
}

// --- 2. Button Logic (FIXED NAMES) ---
btn_ranked_hover = point_in_box(_mx, _my, btn_ranked_x1, btn_ranked_y1, btn_ranked_x2, btn_ranked_y2);
btn_casual_hover = point_in_box(_mx, _my, btn_casual_x1, btn_casual_y1, btn_casual_x2, btn_casual_y2);
btn_heal_hover = point_in_box(_mx, _my, btn_heal_x1, btn_heal_y1, btn_heal_x2, btn_heal_y2);
btn_close_hover = point_in_box(_mx, _my, btn_close_x1, btn_close_y1, btn_close_x2, btn_close_y2);

if (_click) {
    if (btn_close_hover) {
        instance_destroy();
        exit;
    }
    
    if (!is_dragging) { 
        
        // RANKED MATCH
        if (btn_ranked_hover) {
            if (instance_exists(obj_battle_manager)) exit;
            if (global.PlayerData.current_opponent_index >= array_length(current_cup.opponents)) {
                heal_message_text = "You've beaten everyone in this cup!";
                heal_message_timer = 120;
            } else {
                var _opp_data = current_cup.opponents[global.PlayerData.current_opponent_index];
                var _battle_data = {
                    is_casual: false, 
                    opponent_data: _opp_data,
                    level_cap: current_level_cap
                };
                instance_create_layer(0, 0, "Instances", obj_battle_manager, _battle_data);
                instance_destroy();
            }
        }
        
        // CASUAL MATCH
        if (btn_casual_hover) {
            if (instance_exists(obj_battle_manager)) exit;
            var _cup = global.CupDatabase[global.PlayerData.current_cup_index];
            var _battle_data = {
                is_casual: true, 
                opponent_data: noone,
                level_cap: _cup.level_cap
            };
            instance_create_layer(0, 0, "Instances", obj_battle_manager, _battle_data);
            instance_destroy();
        }
        
        // HEAL
        if (btn_heal_hover) {
            for (var i = 0; i < array_length(global.PlayerData.team); i++) {
                var _critter = global.PlayerData.team[i];
                _critter.hp = _critter.max_hp;
                _critter.atk_stage = 0; _critter.def_stage = 0; _critter.spd_stage = 0;
            }
            heal_message_text = "All critters fully restored!";
            heal_message_timer = 120;
        }
    }
}

// --- 3. Dragging Logic ---
if (mouse_check_button_pressed(mb_left)) {
    if (global.dragged_window == noone) {
        if (point_in_box(_mx, _my, window_x1, window_y1, window_x2, window_y1 + 32) && !btn_close_hover) {
            is_dragging = true;
            global.dragged_window = id;
            drag_dx = window_x1 - _mx;
            drag_dy = window_y1 - _my;
            global.top_window_depth -= 1;
            depth = global.top_window_depth;
        }
    }
}

if (mouse_check_button_released(mb_left)) {
    is_dragging = false;
    if (global.dragged_window == id) {
        global.dragged_window = noone;
    }
}

if (is_dragging) {
    window_x1 = _mx + drag_dx;
    window_y1 = _my + drag_dy;
}

// --- 4. Recalculate Layout (FIXED NAMES) ---
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

sidebar_x1 = window_x1 + 2;
sidebar_y1 = window_y1 + 32;
sidebar_x2 = sidebar_x1 + sidebar_w;
sidebar_y2 = window_y2 - 2;

content_x1 = sidebar_x2;
content_y1 = sidebar_y1;
content_x2 = window_x2 - 2;
content_y2 = window_y2 - 2;

var _start_y = sidebar_y1 + 100;
var _btn_h = 60;
var _spacing = 10;

btn_ranked_x1 = sidebar_x1 + 10; btn_ranked_y1 = _start_y;
btn_ranked_x2 = sidebar_x2 - 10; btn_ranked_y2 = btn_ranked_y1 + _btn_h;

btn_casual_x1 = sidebar_x1 + 10; btn_casual_y1 = btn_ranked_y2 + _spacing;
btn_casual_x2 = sidebar_x2 - 10; btn_casual_y2 = btn_casual_y1 + _btn_h;

btn_heal_x1 = sidebar_x1 + 10; btn_heal_y1 = btn_casual_y2 + _spacing;
btn_heal_x2 = sidebar_x2 - 10; btn_heal_y2 = btn_heal_y1 + _btn_h;

btn_close_x1 = window_x2 - 28; btn_close_y1 = window_y1 + 6;
btn_close_x2 = window_x2 - 6; btn_close_y2 = window_y1 + 28;