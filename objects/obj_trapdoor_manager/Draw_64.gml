// --- Draw GUI Event ---

draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// --- 1. Draw Main Window ---
draw_rectangle_95(window_x1, window_y1, window_x2, window_y2, "raised");
// Title Bar
draw_set_color(c_navy);
draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y1 + 32, false); 
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(window_x1 + (window_width / 2), window_y1 + 17, "TRAPDOOR.exe");

// --- 2. Draw Close Button ---
var _close_state = btn_close_hover ? "sunken" : "raised";
draw_rectangle_95(btn_close_x1, btn_close_y1, btn_close_x2, btn_close_y2, _close_state);
draw_set_color(c_black);
draw_set_font(fnt_vga);
draw_text(btn_close_x1 + 11, btn_close_y1 + 11, "X");

// --- 3. Draw Team List ---
draw_set_color(c_black);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

draw_text(window_x1 + 20, window_y1 + 50, "Select a specimen to optimize:");

var _team_size = array_length(global.PlayerData.team);
for (var i = 0; i < 6; i++) {
    var _btn = btn_team_layout[i];
    var _state = (menu_focus == i) ? "sunken" : "raised";
    
    // Draw the box for this slot
    draw_rectangle_95(_btn[0], _btn[1], _btn[2], _btn[3], _state);
    
    if (i < _team_size) {
        var _critter = global.PlayerData.team[i];
        
        if (_critter.is_corrupted) {
            draw_set_color(c_red); // Show corrupted status
        } else {
            draw_set_color(c_black);
        }
        
        draw_text(_btn[0] + 10, _btn[1] + 20, _critter.nickname);
        
        draw_set_halign(fa_right);
        if (_critter.is_corrupted) {
            draw_text(_btn[2] - 10, _btn[1] + 20, "[CORRUPTED]");
        } else {
            draw_text(_btn[2] - 10, _btn[1] + 20, "Lv. " + string(_critter.level));
        }
        draw_set_halign(fa_left);
    }
}

// --- 4. Draw Feedback Message ---
if (feedback_message_timer > 0) {
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(window_x1 + 2, window_y1 + 32, window_x2 - 2, window_y2 - 2, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_ext(window_x1 + (window_width / 2), window_y1 + (window_height / 2), feedback_message, 20, window_width - 40);
}

// --- 5. Reset Draw Settings ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);