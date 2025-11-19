// --- Step Event ---

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);
var _key_up = keyboard_check_pressed(vk_up);
var _key_down = keyboard_check_pressed(vk_down);
var _key_enter = keyboard_check_pressed(vk_enter);

// 1. Update Timer
if (feedback_message_timer > 0) {
    feedback_message_timer--;
}

// 2. Handle Navigation
if (_key_up) { menu_focus = max(0, menu_focus - 1); }
if (_key_down) { menu_focus = min(5, menu_focus + 1); } // Only 6 slots

// 3. Button & Click Logic
btn_close_hover = point_in_box(_mx, _my, btn_close_x1, btn_close_y1, btn_close_x2, btn_close_y2);

if (_click) {
    if (btn_close_hover) {
        instance_destroy();
        exit;
    }
    
    // Click to dismiss message
    if (feedback_message_timer > 0) {
        feedback_message_timer = 0;
    }
    else if (!is_dragging) {
        
        // Check for click in Team List
        var _team_size = array_length(global.PlayerData.team);
        for (var i = 0; i < _team_size; i++) {
            var _btn = btn_team_layout[i];
            if (point_in_box(_mx, _my, _btn[0], _btn[1], _btn[2], _btn[3])) {
                menu_focus = i;
                _key_enter = true; // Treat click as Enter
            }
        }
    }
}

// 4. Handle "Enter" / Click action
if (_key_enter && feedback_message_timer <= 0) {
    
    if (menu_focus < array_length(global.PlayerData.team)) {
        
        var _critter = global.PlayerData.team[menu_focus];
        
        if (_critter.is_corrupted) {
            feedback_message = "Data for this specimen is already optimized.";
            feedback_message_timer = 120;
        } else {
            
            // --- THE CORRUPTION ---
            
            // 1. Find a generic move to replace
            var _move_to_replace = -1;
            for (var i = 0; i < array_length(_critter.moves); i++) {
                if (_critter.moves[i] == global.GENERIC_MOVE_AGITATE) {
                    _move_to_replace = i;
                    break;
                }
            }
            
            // If we didn't find "Agitate", just replace the first move
            if (_move_to_replace == -1) {
                _move_to_replace = 0; 
            }
            
            // 2. Replace the move
            _critter.moves[_move_to_replace] = global.MOVE_SYSTEM_CALL;
            
            // 3. Set the flag
            _critter.is_corrupted = true;
            
            // 4. Give feedback and close
            feedback_message = "Data for " + _critter.nickname + " has been... optimized.";
            feedback_message_timer = 180; // 3 seconds
        }
    }
}

// 5. Check if we should close after a message
if (feedback_message_timer == 1 && feedback_message != "") {
    instance_destroy();
}

// 6. DRAGGING LOGIC
if (mouse_check_button_pressed(mb_left)) {
    if (point_in_box(_mx, _my, window_x1, window_y1, window_x2, window_y1 + 32) && !btn_close_hover) {
        is_dragging = true;
        drag_dx = window_x1 - _mx;
        drag_dy = window_y1 - _my;
    }
}
if (mouse_check_button_released(mb_left)) {
    is_dragging = false;
}
if (is_dragging) {
    window_x1 = _mx + drag_dx;
    window_y1 = _my + drag_dy;
}

// 7. RECALCULATE ALL UI POSITIONS
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;
btn_close_x1 = window_x2 - 28;
btn_close_y1 = window_y1 + 6;
btn_close_x2 = window_x2 - 6;
btn_close_y2 = window_y1 + 28;

// Re-calc team layout
var _team_btn_w = 380;
var _team_btn_h = 40;
var _team_btn_x = window_x1 + (window_width / 2) - (_team_btn_w / 2);
var _team_btn_y_start = window_y1 + 80;
var _team_btn_v_space = 45;
btn_team_layout = []; // Clear the array
for (var i = 0; i < 6; i++) {
    var _btn_y = _team_btn_y_start + (i * _team_btn_v_space);
    array_push(btn_team_layout, [_team_btn_x, _btn_y, _team_btn_x + _team_btn_w, _btn_y + _team_btn_h]);
}