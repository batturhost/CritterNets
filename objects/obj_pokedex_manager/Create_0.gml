// --- Create Event ---

// 1. Get all critter data from the database
critter_keys = variable_struct_get_names(global.bestiary);
critter_count = array_length(critter_keys);
selected_index = 0; 

// Animation vars
animation_frame = 0;
animation_speed = 0.1; 

// 2. Define Window Layout
window_width = 1024;
window_height = 600;
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
// window_x2 and window_y2 calculated below

// ================== NEW DRAG VARS ==================
is_dragging = false;
drag_dx = 0;
drag_dy = 0;
// ===================================================

// 3. Initialize UI Variables (Placeholders)
list_x1 = 0; list_y1 = 0; list_w = 250; list_h = 0; list_x2 = 0; list_y2 = 0;
list_item_height = 20;
list_top_index = 0;

display_x = 0; display_y = 0; display_w = 0;

btn_w = 100; btn_h = 30;
btn_x1 = 0; btn_y1 = 0; btn_x2 = 0; btn_y2 = 0;
btn_hovering = false;


// --- 4. CALCULATE POSITIONS (Run once at start) ---
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// List Panel (Left Side)
list_x1 = window_x1 + 20;
list_y1 = window_y1 + 50;
list_h = window_height - 100;
list_x2 = list_x1 + list_w;
list_y2 = list_y1 + list_h;

// Display Panel (Right Side)
display_x = list_x2 + 20;
display_y = list_y1;
display_w = (window_x2 - 20) - display_x;

// "Back" Button
btn_x1 = window_x2 - btn_w - 15;
btn_y1 = window_y2 - btn_h - 15;
btn_x2 = btn_x1 + btn_w;
btn_y2 = btn_y1 + btn_h;