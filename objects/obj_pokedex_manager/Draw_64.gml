// --- Draw GUI Event ---

draw_set_font(fnt_vga);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Define Custom Dark Teal for panels
var _col_dark_teal = make_color_rgb(0, 60, 60); 

// --- 1. Window Background (Teal + Scanlines - AERO STYLE) ---
draw_set_alpha(0.85); 
draw_set_color(c_teal);
draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y2 - 2, false);
draw_set_alpha(1.0);

draw_scanlines_95(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y2 - 2);


// --- 2. Title Bar (Transparent Navy) ---
draw_set_alpha(0.85);
draw_set_color(c_navy);
draw_rectangle(window_x1 + 2, window_y1 + 2, window_x2 - 2, window_y1 + 32, false); 
draw_set_alpha(1.0);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_vga_bold);
draw_text(window_x1 + (window_width / 2), window_y1 + 17, "CritterNet Bestiary");
draw_set_font(fnt_vga);


// --- 3. Back Button ---
var _btn_state = btn_hovering ? "sunken" : "raised";
draw_rectangle_95(btn_x1, btn_y1, btn_x2, btn_y2, _btn_state);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_vga_bold);
draw_text(btn_x1 + (btn_w / 2), btn_y1 + (btn_h / 2), "Back");
draw_set_font(fnt_vga);


// --- 4. List Panel (Left) - DARK TEAL GLASS ---
draw_set_alpha(0.8); 
draw_set_color(_col_dark_teal); // <-- DARK TEAL BACKGROUND
draw_rectangle(list_x1, list_y1, list_x2, list_y2, false);
draw_set_alpha(1.0);

draw_border_95(list_x1, list_y1, list_x2, list_y2, "sunken");

gpu_set_scissor(list_x1 + 2, list_y1 + 2, list_w - 4, list_h - 4);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

for (var i = list_top_index; i < critter_count; i++) {
    var _draw_y = list_y1 + 2 + ((i - list_top_index) * list_item_height);
    
    if (_draw_y > list_y2 - list_item_height) {
        break;
    }
    
    var _key = critter_keys[i];
    var _name = global.bestiary[$ _key].animal_name;
    
    if (i == selected_index) {
        // Selected: Navy bar
        draw_set_color(c_navy);
        draw_rectangle(list_x1 + 2, _draw_y, list_x2 - 2, _draw_y + list_item_height, false);
        draw_set_color(c_white);
    } else {
        // Unselected: White text on Dark Teal
        draw_set_color(c_white);
    }
    
    draw_text(list_x1 + 5, _draw_y + 2, _name);
}
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());


// --- 5. Display Panel (Right) ---
var _selected_key = critter_keys[selected_index];
var _data = global.bestiary[$ _selected_key];

// -- Column 1: Sprite & Blurb --
var _col1_x = display_x;
var _col1_w = (display_w / 2) - 10;

// A. Critter Name (Bold, White)
draw_set_font(fnt_vga_bold);
draw_set_color(c_white); 
draw_set_halign(fa_left);
draw_text(_col1_x, display_y, _data.animal_name);
draw_set_font(fnt_vga);

// B. Sprite Box
var _sprite = _data.sprite_idle;
var _sprite_w = sprite_get_width(_sprite);
var _sprite_h = sprite_get_height(_sprite);

var _box_w = _col1_w - 20;
var _box_h = 250;
var _box_center_x = _col1_x + (_col1_w / 2);
var _box_center_y = display_y + 170; 

// Draw Frame (Dark Teal Glass)
draw_set_alpha(0.8);
draw_set_color(_col_dark_teal); // <-- DARK TEAL BACKGROUND
draw_rectangle(_box_center_x - _box_w/2, _box_center_y - _box_h/2, _box_center_x + _box_w/2, _box_center_y + _box_h/2, false);
draw_set_alpha(1.0);

var _frame_x1 = _box_center_x - (_box_w / 2) - 2;
var _frame_y1 = _box_center_y - (_box_h / 2) - 2;
var _frame_x2 = _box_center_x + (_box_w / 2) + 2;
var _frame_y2 = _box_center_y + (_box_h / 2) + 2;
draw_border_95(_frame_x1, _frame_y1, _frame_x2, _frame_y2, "sunken");

var _scale_x = _box_w / _sprite_w;
var _scale_y = _box_h / _sprite_h;
var _scale = min(_scale_x, _scale_y); 

var _draw_x = _box_center_x;
var _draw_y = _box_center_y + ((_sprite_h / 2) * _scale);

var _num_frames = sprite_get_number(_sprite);
if (_num_frames > 1) {
    animation_frame = (animation_frame + animation_speed) % _num_frames;
} else {
    animation_frame = 0;
}

gpu_set_scissor(_frame_x1 + 2, _frame_y1 + 2, _frame_x2 - _frame_x1 - 4, _frame_y2 - _frame_y1 - 4);
draw_sprite_ext(_sprite, animation_frame, _draw_x, _draw_y, _scale, _scale, 0, c_white, 1);
gpu_set_scissor(0, 0, display_get_gui_width(), display_get_gui_height());

// C. Info (Blurb & Size)
var _info_y = _box_center_y + (_box_h / 2) + 20;
draw_set_color(c_white);
draw_text_ext(_col1_x, _info_y, _data.blurb, 20, _col1_w);
draw_text(_col1_x, _info_y + 100, _data.size);


// -- Column 2: Stats & Moves --
var _col2_x = display_x + (display_w / 2) + 10;
var _col2_y = display_y;

// D. Base Stats (Bold Header)
draw_set_font(fnt_vga_bold);
draw_text(_col2_x, _col2_y, "Base Stats");
draw_set_font(fnt_vga);

var _stats_y = _col2_y + 40;
draw_text(_col2_x, _stats_y + 00, "HP:     " + string(_data.base_hp));
draw_text(_col2_x, _stats_y + 20, "Attack: " + string(_data.base_atk));
draw_text(_col2_x, _stats_y + 40, "Defense:" + string(_data.base_def));
draw_text(_col2_x, _stats_y + 60, "Speed:  " + string(_data.base_spd));

// E. Known Moves (Bold Header)
var _moves_y = _stats_y + 130;
draw_set_font(fnt_vga_bold);
draw_text(_col2_x, _moves_y, "Known Moves");
draw_set_font(fnt_vga);

for (var m = 0; m < array_length(_data.moves); m++) {
    var _move_name = _data.moves[m].move_name;
    draw_text(_col2_x, _moves_y + 30 + (m * 20), "- " + _move_name);
}


// --- 6. Outer Border (Last) ---
draw_border_95(window_x1, window_y1, window_x2, window_y2, "raised");

// --- 7. Reset ---
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_vga);