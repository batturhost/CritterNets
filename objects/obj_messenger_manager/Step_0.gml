// --- Step Event ---

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

// --- 1. Button Logic ---
btn_close_hover = point_in_box(_mx, _my, btn_close_x1, btn_close_y1, btn_close_x2, btn_close_y2);
btn_send_hover = point_in_box(_mx, _my, btn_send_x1, btn_send_y1, btn_send_x2, btn_send_y2);

if (_click) {
    if (btn_close_hover) {
        if (global.bargain_offered && !global.trapdoor_unlocked) {
            global.trapdoor_unlocked = true;
        }
        instance_destroy();
        exit;
    }
    
    if (!is_dragging) {
        // Check Buddy List Click
        if (point_in_box(_mx, _my, buddy_list_x, buddy_list_y, buddy_list_x + buddy_list_w, buddy_list_y + buddy_list_h)) {
            var _rel_y = _my - buddy_list_y;
            var _idx = floor(_rel_y / contact_item_height);
            
            if (_idx >= 0 && _idx < array_length(contact_list)) {
                selected_contact_index = _idx;
                selected_contact_name = contact_list[_idx];
            }
        }
    }
}

// --- 2. Dragging Logic ---
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

// --- 3. Recalculate Positions (Prevents Bouncy UI) ---
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

btn_close_x1 = window_x2 - 28;
btn_close_y1 = window_y1 + 6;
btn_close_x2 = window_x2 - 6;
btn_close_y2 = window_y1 + 28;

toolbar_y1 = window_y1 + 32;

// Left Pane
buddy_list_x = window_x1 + 10;
buddy_list_y = toolbar_y1 + toolbar_h + 10;

// Right Pane
chat_area_x = buddy_list_x + buddy_list_w + 10;
chat_area_y = buddy_list_y;
chat_area_h = buddy_list_h - 95; // FIX: Updated height calculation

input_area_x = chat_area_x;
input_area_y = chat_area_y + chat_area_h + 10;

// Send Button
btn_send_x1 = input_area_x + input_area_w - btn_send_w;
btn_send_y1 = input_area_y + input_area_h + 5;
btn_send_x2 = btn_send_x1 + btn_send_w;
btn_send_y2 = btn_send_y1 + btn_send_h;