// --- Draw GUI Event ---

draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Define custom XP blue colors
var _xp_blue_light = make_color_rgb(170, 200, 240); 
var _xp_blue_dark = make_color_rgb(0, 80, 180);   
var _xp_bg_color = make_color_rgb(235, 240, 250);  

// --- 1. Main Window Background ---
draw_set_color(_xp_bg_color);
draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y2 - 2, false);


// --- 2. Title Bar (XP Blue Gradient) ---
draw_rectangle_color(
    window_x1 + 2, window_y1 + 2, 
    window_x2 - 2, window_y1 + 32, 
    _xp_blue_dark, _xp_blue_light, _xp_blue_light, _xp_blue_dark, 
    false
);

// Title Text
draw_set_color(c_white);
draw_set_halign(fa_left); 
draw_set_valign(fa_middle);
draw_set_font(fnt_vga_bold);
draw_text(window_x1 + 10, window_y1 + 17, "CNet Messenger - " + global.PlayerData.name);
draw_set_font(fnt_vga); // Reset font


// --- 3. Close Button (FIXED) ---
// We use the standard gray button style now instead of Red
var _close_state = btn_close_hover ? "sunken" : "raised";
draw_rectangle_95(btn_close_x1, btn_close_y1, btn_close_x2, btn_close_y2, _close_state);

draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Calculate exact center
var _btn_center_x = btn_close_x1 + ((btn_close_x2 - btn_close_x1) / 2);
var _btn_center_y = btn_close_y1 + ((btn_close_y2 - btn_close_y1) / 2);

// Offset slightly if button is pressed/sunken
if (_close_state == "sunken") {
    _btn_center_x += 1;
    _btn_center_y += 1;
}

draw_text(_btn_center_x, _btn_center_y, "X");


// --- 4. Menu Bar ---
var _menu_bar_y = toolbar_y1;
draw_set_color(c_black);
draw_set_valign(fa_top);
draw_set_halign(fa_left);
draw_text(window_x1 + 5, _menu_bar_y + 4, "File   Edit   Actions   Tools   Help");


// --- 5. "Buddy List" (Left Pane) ---
draw_set_color(c_white);
draw_rectangle(buddy_list_x, buddy_list_y, buddy_list_x + buddy_list_w, buddy_list_y + buddy_list_h, false);
draw_border_95(buddy_list_x, buddy_list_y, buddy_list_x + buddy_list_w, buddy_list_y + buddy_list_h, "sunken");

// Items
gpu_set_scissor(buddy_list_x + 2, buddy_list_y + 2, buddy_list_w - 4, buddy_list_h - 4);
for (var i = 0; i < array_length(contact_list); i++) {
    var _y = buddy_list_y + 2 + (i * contact_item_height);
    
    if (i == selected_contact_index) {
        draw_set_color(_xp_blue_dark); // Dark blue highlight
        draw_rectangle(buddy_list_x + 2, _y, buddy_list_x + buddy_list_w - 2, _y + contact_item_height, false);
        draw_set_color(c_white);
    } else {
        draw_set_color(c_black);
    }
    draw_text(buddy_list_x + 5, _y + 2, contact_list[i]);
}
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());


// --- 6. Chat Window (Right Top) ---
// Removed "Conversation:" label here.

draw_set_color(c_white);
draw_rectangle(chat_area_x, chat_area_y, chat_area_x + chat_area_w, chat_area_y + chat_area_h, false);
draw_border_95(chat_area_x, chat_area_y, chat_area_x + chat_area_w, chat_area_y + chat_area_h, "sunken");

// Messages
gpu_set_scissor(chat_area_x + 2, chat_area_y + 2, chat_area_w - 4, chat_area_h - 4);
var _log = chat_logs[$ selected_contact_name];

if (!is_undefined(_log)) {
    var _draw_y = chat_area_y + 5;
    draw_set_color(c_black); 
    
    for (var i = 0; i < array_length(_log); i++) {
        var _msg = _log[i];
        var _sender = selected_contact_name; 
        
        // Draw Sender Name
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(_xp_blue_dark);
        draw_set_font(fnt_vga_bold);
        draw_text(chat_area_x + 5, _draw_y, _sender + " says:");
        draw_set_font(fnt_vga); 
        
        _draw_y += 20; 
        
        // Draw Message Text
        draw_set_color(c_black);
        
        var _height = draw_text_ext(chat_area_x + 10, _draw_y, _msg, msg_line_height, chat_area_w - 20);
        if (!is_real(_height)) _height = 20; 
        
        _draw_y += _height + 10;
    }
}
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());


// --- 7. Input Box (Right Bottom) ---
draw_set_color(c_white);
draw_rectangle(input_area_x, input_area_y, input_area_x + input_area_w, input_area_y + input_area_h, false);
draw_border_95(input_area_x, input_area_y, input_area_x + input_area_w, input_area_y + input_area_h, "sunken");


// --- 8. Send Button ---
var _send_state = btn_send_hover ? "sunken" : "raised";
draw_rectangle_95(btn_send_x1, btn_send_y1, btn_send_x2, btn_send_y2, _send_state);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(btn_send_x1 + ((btn_send_x2 - btn_send_x1)/2), btn_send_y1 + (btn_send_h/2), "Send");


// --- 9. Outer Border ---
draw_border_95(window_x1, window_y1, window_x2, window_y2, "raised");


// --- 10. Reset ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_vga);