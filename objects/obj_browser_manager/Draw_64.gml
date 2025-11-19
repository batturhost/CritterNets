// --- Draw GUI Event ---

draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// --- 1. Draw Window Chrome (Transparent) ---

// 1a. Title Bar (Navy, 85% Opacity)
draw_set_alpha(0.85); 
draw_set_color(c_navy);
draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y1 + 32, false);
draw_set_alpha(1.0); // Reset alpha

// 1b. Title Text (Opaque)
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_vga_bold);
draw_text(window_x1 + (window_width / 2), window_y1 + 17, "Welcome, " + player_name + "!");
draw_set_font(fnt_vga);


// --- 2. Draw Left Sidebar (Teal, 85% Opacity) ---
draw_set_alpha(0.85); 
draw_set_color(c_teal);
draw_rectangle(sidebar_x1, sidebar_y1, sidebar_x2, sidebar_y2, false);
draw_set_alpha(1.0); // Reset alpha

// Add scanlines to the sidebar
draw_scanlines_95(sidebar_x1, sidebar_y1, sidebar_x2, sidebar_y2);

// Logo Area
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_font(fnt_vga_bold); 
draw_text(sidebar_x1 + (sidebar_w/2), sidebar_y1 + 30, "CritterNet");
draw_text(sidebar_x1 + (sidebar_w/2), sidebar_y1 + 50, "Online");
draw_set_font(fnt_vga);


// --- 3. Draw Sidebar Buttons ---
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_set_font(fnt_vga_bold); 

// Ranked
var _ranked_state = btn_ranked_hover ? "sunken" : "raised";
draw_rectangle_95(btn_ranked_x1, btn_ranked_y1, btn_ranked_x2, btn_ranked_y2, _ranked_state);
draw_text(btn_ranked_x1 + (sidebar_w/2) - 10, btn_ranked_y1 + 30, "Ranked Cup");

// Casual
var _casual_state = btn_casual_hover ? "sunken" : "raised";
draw_rectangle_95(btn_casual_x1, btn_casual_y1, btn_casual_x2, btn_casual_y2, _casual_state);
draw_text(btn_casual_x1 + (sidebar_w/2) - 10, btn_casual_y1 + 30, "Casual Match");

// Heal
var _heal_state = btn_heal_hover ? "sunken" : "raised";
draw_rectangle_95(btn_heal_x1, btn_heal_y1, btn_heal_x2, btn_heal_y2, _heal_state);
draw_text(btn_heal_x1 + (sidebar_w/2) - 10, btn_heal_y1 + 30, "Critter Center");

draw_set_font(fnt_vga); 


// --- 4. Draw Main Content Area (White Page, Opaque) ---
draw_set_color(c_white);
draw_rectangle(content_x1, content_y1, content_x2, content_y2, false);

gpu_set_scissor(content_x1, content_y1, content_x2 - content_x1, content_y2 - content_y1);

var _margin_x = content_x1 + 20;
var _curr_y = content_y1 + 20;
var _page_w = (content_x2 - content_x1) - 40;

// -- Header --
draw_set_color(c_black);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_vga_bold); 
draw_text(_margin_x, _curr_y, "CRITTERNET TODAY");
draw_set_font(fnt_vga);
_curr_y += 30;

// Date
var _date_str = string(current_month) + "/" + string(current_day) + "/1998";
draw_text(_margin_x, _curr_y, _date_str);
_curr_y += 30;

// -- Separator Line --
draw_set_color(c_gray);
draw_line(_margin_x, _curr_y, _margin_x + _page_w, _curr_y);
_curr_y += 20;

// -- Weather Widget --
draw_set_color(c_navy);
draw_set_font(fnt_vga_bold); 
draw_text(_margin_x, _curr_y, "Your Weather");
draw_set_font(fnt_vga);
_curr_y += 25;

draw_set_color(c_black);

if (sprite_exists(asset_get_index("spr_weather_icons"))) {
    var _w_sprite = spr_weather_icons;
    var _w_spr_w = sprite_get_width(_w_sprite);
    var _w_spr_h = sprite_get_height(_w_sprite);
    var _max_icon_size = 48;
    var _w_scale = min(_max_icon_size / _w_spr_w, _max_icon_size / _w_spr_h);
    
    draw_sprite_ext(_w_sprite, weather_icon_idx, _margin_x + 25, _curr_y + 25, _w_scale, _w_scale, 0, c_white, 1);
} else {
    draw_circle(_margin_x + 25, _curr_y + 25, 15, true);
}

// Draw Text
draw_text(_margin_x + 60, _curr_y + 5, weather_desc);

// Manual Degree Circle
draw_text(_margin_x + 60, _curr_y + 25, weather_string); 
var _temp_width = string_width(weather_string);
draw_circle(_margin_x + 60 + _temp_width + 3, _curr_y + 25 + 3, 2, true); 
draw_text(_margin_x + 60 + _temp_width + 8, _curr_y + 25, "C");

_curr_y += 60; 

// -- News Story --
draw_set_color(c_navy);
draw_set_font(fnt_vga_bold); 
draw_text(_margin_x, _curr_y, "Top News Story");
draw_set_font(fnt_vga);
_curr_y += 20;

draw_set_color(c_black);
draw_text_ext(_margin_x + 20, _curr_y, current_news, 20, _page_w - 20);
_curr_y += 60;

// -- Daily Deal --
draw_set_color(c_teal); 
draw_set_font(fnt_vga_bold); 
draw_text(_margin_x, _curr_y, "Earth's Best Deal:");
draw_set_font(fnt_vga);
_curr_y += 20;

draw_set_color(c_black);
draw_text_ext(_margin_x + 20, _curr_y, current_deal, 20, _page_w - 20);
_curr_y += 60;

// -- Did You Know? --
draw_set_color(c_maroon); 
draw_set_font(fnt_vga_bold); 
draw_text(_margin_x, _curr_y, "Did You Know?");
draw_set_font(fnt_vga);
_curr_y += 20;

draw_set_color(c_black);
draw_text_ext(_margin_x + 20, _curr_y, current_fact, 20, _page_w - 20);

gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());


// --- 5. Draw 3D Border (Last, to frame everything) ---
// This replaces the initial draw_rectangle_95, drawing just the outline
draw_border_95(window_x1, window_y1, window_x2, window_y2, "raised");


// --- 6. Draw Close Button ---
var _close_state = btn_close_hover ? "sunken" : "raised";
draw_rectangle_95(btn_close_x1, btn_close_y1, btn_close_x2, btn_close_y2, _close_state);
draw_set_color(c_black);
draw_set_font(fnt_vga);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(btn_close_x1 + 11, btn_close_y1 + 11, "X");


// --- 7. Draw Heal Feedback ---
if (heal_message_timer > 0) {
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(window_x1 + 2, window_y1 + 32, window_x2 - 2, window_y2 - 2, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_font(fnt_vga_bold); 
    draw_text(window_x1 + (window_width/2), window_y1 + (window_height/2), heal_message_text);
}

// --- 8. Reset ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_vga);