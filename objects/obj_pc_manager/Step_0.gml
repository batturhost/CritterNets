// --- Step Event ---

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);
var _held = mouse_check_button(mb_left);     // Needed for drag check
var _release = mouse_check_button_released(mb_left); 

// --- 1. Update Timers ---
if (feedback_message_timer > 0) {
    feedback_message_timer--;
}
if (preview_critter != noone) {
    var _sprite = preview_critter.sprite_idle;
    var _num_frames = sprite_get_number(_sprite);
    if (_num_frames > 1) {
        preview_anim_frame = (preview_anim_frame + preview_anim_speed) % _num_frames;
    }
}

// --- 2. Button Logic ---
btn_close_hover = point_in_box(_mx, _my, btn_close_x1, btn_close_y1, btn_close_x2, btn_close_y2);
btn_to_team_hover = point_in_box(_mx, _my, btn_to_team_x1, btn_to_team_y1, btn_to_team_x2, btn_to_team_y2);
btn_to_pc_hover = point_in_box(_mx, _my, btn_to_pc_x1, btn_to_pc_y1, btn_to_pc_x2, btn_to_pc_y2);

// --- 3. DRAG & DROP LOGIC (RESTORED & FIXED) ---
var _is_in_team_list = point_in_box(_mx, _my, team_list_x1, team_list_y1, team_list_x2, team_list_y2);

// --- 3a. CLICK: Start Holding ---
if (_click && !is_dragging && _is_in_team_list && feedback_message_timer <= 0) {
    var _click_index = floor((_my - team_list_y1) / team_item_height) + team_top_index;
    
    if (_click_index < array_length(global.PlayerData.team)) {
        held_critter_index = _click_index;
        drag_start_y = _my; // Record start pos
        is_dragging_critter = false; // Not dragging yet!
    }
}

// --- 3b. HOLD: Detect Drag Threshold ---
if (_held && held_critter_index != -1 && !is_dragging_critter) {
    // If moved more than 5 pixels, start dragging
    if (abs(_my - drag_start_y) > 5) {
        is_dragging_critter = true;
        drag_critter_data = global.PlayerData.team[held_critter_index];
        drag_y_offset = (_my - (team_list_y1 + 2 + ((held_critter_index - team_top_index) * team_item_height)));
        
        // Clear selections so visuals are clean
        team_selected_index = -1;
        pc_selected_index = -1;
        preview_critter = noone;
    }
}

// --- 3c. RELEASE: Drop OR Select ---
if (_release) {
    
    if (is_dragging_critter) {
        // --- DROP LOGIC ---
        if (_is_in_team_list) {
            var _critter_to_move = drag_critter_data;
            
            // 1. Remove from old spot
            array_delete(global.PlayerData.team, held_critter_index, 1);
            
            // 2. Calculate new spot (safely)
            var _drop_index = floor((_my - team_list_y1) / team_item_height) + team_top_index;
            _drop_index = clamp(_drop_index, 0, array_length(global.PlayerData.team));
            
            // 3. Insert
            array_insert(global.PlayerData.team, _drop_index, _critter_to_move);
        }
    } 
    else if (held_critter_index != -1) {
        // --- SELECT LOGIC (Click without drag) ---
        team_selected_index = held_critter_index;
        pc_selected_index = -1;
        preview_critter = global.PlayerData.team[held_critter_index];
        preview_anim_frame = 0;
    }
    
    // Reset Logic
    held_critter_index = -1;
    drag_critter_data = noone;
    is_dragging_critter = false;
    drop_indicator_y = -1;
}

// --- 3d. Update Drop Indicator ---
if (is_dragging_critter) {
    if (_is_in_team_list) {
        var _relative_y = _my - team_list_y1;
        var _hover_index = floor(_relative_y / team_item_height) + team_top_index;
        
        // Math to snap between items
        var _hover_y = team_list_y1 + 2 + ((_hover_index - team_top_index) * team_item_height);
        if (_my > _hover_y + (team_item_height / 2)) {
            _hover_index++;
        }
        _hover_index = clamp(_hover_index, 0, array_length(global.PlayerData.team));
        drop_indicator_y = team_list_y1 + 2 + ((_hover_index - team_top_index) * team_item_height);
    } else {
        drop_indicator_y = -1; 
    }
} else {
    drop_indicator_y = -1;
}


// --- 4. Normal Click Logic (PC Box & Buttons) ---
if (_click) {
    if (btn_close_hover) {
        instance_destroy();
        exit;
    }
    
    if (feedback_message_timer > 0) {
        feedback_message_timer = 0;
    }
    else if (!is_dragging && held_critter_index == -1) { 
        
        // Note: Team List click handled above in 3a/3c
        
        // --- Click in PC List (Select) ---
        if (point_in_box(_mx, _my, pc_list_x1, pc_list_y1, pc_list_x2, pc_list_y2)) {
            var _mx_rel = _mx - (pc_list_x1 + pc_grid_padding);
            var _my_rel = _my - (pc_list_y1 + pc_grid_padding);
            var _col = floor(_mx_rel / (pc_grid_cell_size + pc_grid_padding));
            var _row = floor(_my_rel / (pc_grid_cell_size + pc_grid_padding)) + pc_scroll_top;
            
            if (_col >= 0 && _col < pc_grid_cols) {
                var _click_index = (_row * pc_grid_cols) + _col;
                if (_click_index < array_length(global.PlayerData.pc_box)) {
                    pc_selected_index = _click_index;
                    team_selected_index = -1;
                    preview_critter = global.PlayerData.pc_box[_click_index];
                    preview_anim_frame = 0;
                }
            }
        }
        
        // --- Click [Add to Team] ---
        if (btn_to_team_hover && pc_selected_index != -1) {
            if (array_length(global.PlayerData.team) < 6) {
                // 1. Get critter
                var _critter = global.PlayerData.pc_box[pc_selected_index];
                // 2. Remove from PC
                array_delete(global.PlayerData.pc_box, pc_selected_index, 1);
                // 3. Add to Team
                array_push(global.PlayerData.team, _critter);
                
                pc_selected_index = -1;
                preview_critter = noone;
            } else {
                feedback_message = "Your team is full! (Max 6)";
                feedback_message_timer = 120;
            }
        }
        
        // --- Click [Remove from Team] ---
        if (btn_to_pc_hover && team_selected_index != -1) {
            if (array_length(global.PlayerData.team) > 1) {
                // 1. Get critter
                var _critter = global.PlayerData.team[team_selected_index];
                // 2. Remove from Team
                array_delete(global.PlayerData.team, team_selected_index, 1);
                // 3. Add to PC
                array_push(global.PlayerData.pc_box, _critter);
                
                team_selected_index = -1;
                preview_critter = noone;
            } else {
                feedback_message = "You must have at least one critter in your team!";
                feedback_message_timer = 120;
            }
        }
    }
}

// --- 5. Scrolling Logic ---
var _scroll = mouse_wheel_down() - mouse_wheel_up();
if (_scroll != 0 && feedback_message_timer <= 0 && !is_dragging_critter) {
    if (_is_in_team_list) {
        var _max_scroll = max(0, array_length(global.PlayerData.team) - floor(team_list_h / team_item_height));
        team_top_index = clamp(team_top_index + _scroll, 0, _max_scroll);
    }
    if (point_in_box(_mx, _my, pc_list_x1, pc_list_y1, pc_list_x2, pc_list_y2)) {
        var _total_rows = ceil(array_length(global.PlayerData.pc_box) / pc_grid_cols);
        var _visible_rows = floor(pc_list_h / (pc_grid_cell_size + pc_grid_padding));
        var _max_scroll = max(0, _total_rows - _visible_rows);
        pc_scroll_top = clamp(pc_scroll_top + _scroll, 0, _max_scroll);
    }
}

// --- 6. WINDOW DRAGGING LOGIC ---
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

// --- 7. RECALCULATE ALL UI POSITIONS ---
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;
team_list_x1 = window_x1 + 20;
team_list_y1 = window_y1 + 80;
team_list_x2 = team_list_x1 + team_list_w;
team_list_y2 = team_list_y1 + team_list_h;
pc_list_x1 = window_x1 + window_width - 250 - 20;
pc_list_y1 = window_y1 + 80;
pc_list_x2 = pc_list_x1 + pc_list_w;
pc_list_y2 = pc_list_y1 + pc_list_h;
btn_close_x1 = window_x2 - 28;
btn_close_y1 = window_y1 + 6;
btn_close_x2 = window_x2 - 6;
btn_close_y2 = window_y1 + 28;
var _mid_x = window_x1 + (window_width / 2);
btn_to_team_x1 = _mid_x - (btn_w / 2);
btn_to_team_y1 = window_y1 + 350;
btn_to_team_x2 = btn_to_team_x1 + btn_w;
btn_to_team_y2 = btn_to_team_y1 + btn_h;
btn_to_pc_x1 = _mid_x - (btn_w / 2);
btn_to_pc_y1 = btn_to_team_y2 + 10;
btn_to_pc_x2 = btn_to_pc_x1 + btn_w;
btn_to_pc_y2 = btn_to_pc_y1 + btn_h;