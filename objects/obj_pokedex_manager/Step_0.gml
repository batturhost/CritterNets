// --- Step Event ---

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _click = mouse_check_button_pressed(mb_left);

// --- 1. Button & Click Logic ---
btn_hovering = point_in_box(_mx, _my, btn_x1, btn_y1, btn_x2, btn_y2);

if (_click) {
    if (btn_hovering) {
        instance_destroy(); // Close the window
        exit;
    }
    
    if (!is_dragging) {
        // Check for list selection
        if (point_in_box(_mx, _my, list_x1, list_y1, list_x2, list_y2)) {
            var _relative_y = _my - list_y1;
            var _click_index = floor(_relative_y / list_item_height) + list_top_index;
            
            if (_click_index < critter_count) {
                selected_index = _click_index;
            }
        }
    }
}

// --- 2. Scrolling Logic ---
var _scroll = mouse_wheel_down() - mouse_wheel_up();
if (_scroll != 0) {
    if (point_in_box(_mx, _my, list_x1, list_y1, list_x2, list_y2)) {
        var _max_scroll = max(0, critter_count - floor(list_h / list_item_height));
        list_top_index = clamp(list_top_index + _scroll, 0, _max_scroll);
    }
}

// --- 3. DRAGGING LOGIC ---
if (mouse_check_button_pressed(mb_left)) {
    // Check title bar click (top 32 pixels)
    if (point_in_box(_mx, _my, window_x1, window_y1, window_x2, window_y1 + 32)) {
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


// --- 4. RECALCULATE UI POSITIONS ---
// This keeps the UI "glued" to the window as it moves
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// List Panel
list_x1 = window_x1 + 20;
list_y1 = window_y1 + 50;
list_x2 = list_x1 + list_w;
list_y2 = list_y1 + list_h;

// Display Panel
display_x = list_x2 + 20;
display_y = list_y1;
// display_w doesn't change based on position

// "Back" Button
btn_x1 = window_x2 - btn_w - 15;
btn_y1 = window_y2 - btn_h - 15;
btn_x2 = btn_x1 + btn_w;
btn_y2 = btn_y1 + btn_h;