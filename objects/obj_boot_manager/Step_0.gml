// --- Step Event ---

// We only want the buttons to work after the text is finished
if (current_line < array_length(text_lines)) {
    btn_hovering = false;
    btn_continue_hovering = false;
    exit;
}

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Check for button hover (DEBUG)
btn_hovering = point_in_box(_mx, _my, btn_x1, btn_y1, btn_x2, btn_y2);

// Check for button hover (CONTINUE)
btn_continue_hovering = point_in_box(_mx, _my, btn_continue_x1, btn_continue_y1, btn_continue_x2, btn_continue_y2);

// Check for button click (DEBUG)
if (btn_hovering && mouse_check_button_pressed(mb_left)) {
    // Go straight to the hub.
    room_goto(rm_hub);
}

// Check for button click (CONTINUE)
if (btn_continue_hovering && mouse_check_button_pressed(mb_left)) {
    // Go to the normal sign-up screen
    room_goto(rm_installer_start);
}