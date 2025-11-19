// --- Create Event ---

// 1. Define Window Layout
window_width = 700;
window_height = 500;
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

is_dragging = false;
drag_dx = 0;
drag_dy = 0;

// 2. Define UI Panels
team_list_w = 250;
team_list_h = 350;
team_item_height = 20; 
team_top_index = 0; 
team_selected_index = -1; 

pc_list_w = 250;
pc_list_h = 350;
pc_grid_cols = 4;
pc_grid_padding = 8;
pc_grid_cell_size = (pc_list_w - (pc_grid_padding * (pc_grid_cols + 1))) / pc_grid_cols;
pc_scroll_top = 0;
pc_selected_index = -1;

// 3. Define Buttons
btn_w = 150;
btn_h = 28;
btn_to_team_hover = false;
btn_to_pc_hover = false;

// 4. Preview & Feedback Vars
preview_critter = noone; 
preview_anim_frame = 0;
preview_anim_speed = 0.1;
feedback_message = "";
feedback_message_timer = 0;

// 5. Drag/Drop Vars (FIXED: MATCHING STEP EVENT NAMES)
drag_critter_index = -1;
drag_critter_data = noone;
is_dragging_critter = false; // Helper logic (not strictly needed if using index check)
drag_start_y = 0;
drag_y_offset = 0; 
drop_indicator_y = -1;

// Held/Select vars (for the newer select logic)
held_critter_index = -1; 

// 6. INITIALIZE ALL UI POSITIONS
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