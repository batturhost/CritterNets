// --- Create Event ---

// --- 1. Get Battle Type ---
current_level_cap = level_cap;
if (is_casual == false) {
    current_opponent_data = opponent_data; 
    opponent_lose_message = current_opponent_data.lose_message;
} else {
    opponent_lose_message = ""; 
    var _all_keys = variable_struct_get_names(global.bestiary);
    var _player_key = global.PlayerData.team[0].animal_name;
    var _enemy_key = _all_keys[irandom(array_length(_all_keys) - 1)];
    while (_enemy_key == _player_key) {
        _enemy_key = _all_keys[irandom(array_length(_all_keys) - 1)];
    }
    var _enemy_db = global.bestiary[$ _enemy_key];
    var _player_level = global.PlayerData.team[0].level;
    current_opponent_data = {
        name: "Wild " + _enemy_db.animal_name,
        profile_pic_sprite: _enemy_db.sprite_idle,
        critter_keys: [ _enemy_key ],
        critter_levels: [ clamp(irandom_range(_player_level - 1, _player_level + 1), 1, current_level_cap) ]
    };
}

// 2. Define the Battle States
enum BATTLE_STATE {
    START, WAIT_FOR_START, PLAYER_TURN, PLAYER_MOVE_RUN,
    WAIT_FOR_PLAYER_MOVE, ENEMY_TURN, ENEMY_MOVE_RUN, WAIT_FOR_ENEMY_MOVE,
    
    // --- NEW PASSIVE DAMAGE STATES ---
    PLAYER_POST_TURN_DAMAGE, // For "Glitched" passive damage
    ENEMY_POST_TURN_DAMAGE,  //
    
    PLAYER_FAINT, ENEMY_FAINT, WAIT_FOR_FAINT,
    PLAYER_SWAP_OUT, PLAYER_SWAP_IN,
    WIN_DOWNLOAD_PROGRESS, WIN_DOWNLOAD_COMPLETE,
    WIN_XP_GAIN, WIN_CHECK_LEVEL, WIN_LEVEL_UP_MSG,
    WIN_END, LOSE
}
current_state = BATTLE_STATE.START;

// 3. Define the Player's Menu States
enum MENU { MAIN, FIGHT, TEAM }
current_menu = MENU.MAIN;
menu_focus = 0;

// 4. Define the 4:3 "Browser Window"
window_width = 960;
window_height = 720;
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2);
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

// 5. DRAGGING VARIABLES
is_dragging = false;
drag_dx = 0; 
drag_dy = 0; 

// 6. DEFINE UI POSITIONS
info_box_width = 300;
info_box_height = 80;
// (All other UI positions are set in the Step Event)

// --- 7. Setup Player's Critter ---
player_critter_data = global.PlayerData.team[0];
swap_target_index = 0;

// --- 8. Setup Enemy Critter ---
var _enemy_key = current_opponent_data.critter_keys[0]; 
var _enemy_level = current_opponent_data.critter_levels[0];
var _enemy_db = global.bestiary[$ _enemy_key];
enemy_critter_data = new AnimalData(
    _enemy_db.animal_name, _enemy_db.base_hp, _enemy_db.base_atk,
    _enemy_db.base_def, _enemy_db.base_spd, _enemy_level, 
    _enemy_db.sprite_idle, _enemy_db.sprite_idle_back, _enemy_db.sprite_signature_move,
    _enemy_db.moves, _enemy_db.blurb, _enemy_db.size
);
enemy_critter_data.nickname = _enemy_db.animal_name; 

// 9. Create the "Actors"
var _player_x_pos = window_x1 + (window_width * 0.3);
var _player_y_pos = window_y1 + (window_height * 0.7);
var _enemy_x_pos = window_x1 + (window_width * 0.75);
var _enemy_y_pos = window_y1 + (window_height * 0.30);
var _layer_id = layer_get_id("Instances");
player_actor = instance_create_layer(_player_x_pos, _player_y_pos, _layer_id, obj_player_critter);
enemy_actor = instance_create_layer(_enemy_x_pos, _enemy_y_pos, _layer_id, obj_enemy_critter);

// 10. Initialize the Actors
init_animal(player_actor, player_critter_data, player_critter_data.sprite_idle_back);
init_animal(enemy_actor, enemy_critter_data, enemy_critter_data.sprite_idle);
recalculate_stats(player_critter_data);
recalculate_stats(enemy_critter_data);
player_critter_data.hp = global.PlayerData.team[0].hp; 

// 11. Set the Scales
player_actor.my_scale = 0.33 * 1.30;
enemy_actor.my_scale = 0.33;
if (player_critter_data.animal_name == "Capybara") {
    player_actor.my_scale *= 0.9;
}

// 12. Setup the rest
battle_log_text = "The battle begins!";
player_chosen_move = noone;
enemy_chosen_move = noone; 
is_force_swapping = false; 

// 13. DEFINE UI BUTTONS
btn_main_menu = [];
btn_move_menu = [];
btn_team_layout = [];

// 14. Download Animation Vars
download_start_percent = 0;
download_end_percent = 0;
download_current_percent = 0;
download_bar_x1 = 0;
download_bar_y1 = 0;
download_bar_w = 400;
download_bar_h = 30;
download_filename = "";
download_sprite = noone;

// 15. INITIALIZE ALL UI POSITIONS
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;
var _log_y1 = window_y1 + (window_height * 0.8);
info_enemy_x1 = window_x1 + 20;
info_enemy_y1 = window_y1 + 40;
info_enemy_x2 = info_enemy_x1 + info_box_width;
info_enemy_y2 = info_enemy_y1 + info_box_height;
info_player_x1 = window_x2 - info_box_width - 20;
info_player_y1 = _log_y1 - info_box_height - 10; 
info_player_x2 = info_player_x1 + info_box_width;
info_player_y2 = info_player_y1 + info_box_height;
var _btn_w = 120;
var _btn_h = 30;
var _btn_gutter = 10;
var _btn_base_x = window_x2 - (_btn_w * 2) - (_btn_gutter * 2);
var _btn_base_y = _log_y1 + 15;
btn_main_menu = [
    [_btn_base_x, _btn_base_y, _btn_base_x + _btn_w, _btn_base_y + _btn_h, "FIGHT"],
    [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h, "TEAM"],
    [_btn_base_x, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w, _btn_base_y + _btn_h * 2 + _btn_gutter, "ITEM"],
    [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h * 2 + _btn_gutter, "RUN"]
];
btn_move_menu = [
    [_btn_base_x, _btn_base_y, _btn_base_x + _btn_w, _btn_base_y + _btn_h, player_critter_data.moves[0].move_name],
    [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h, player_critter_data.moves[1].move_name],
    [_btn_base_x, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w, _btn_base_y + _btn_h * 2 + _btn_gutter, player_critter_data.moves[2].move_name],
    [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h * 2 + _btn_gutter, "BACK"]
];
var _team_btn_w = 400; var _team_btn_h = 100; var _team_box_padding = 10;
var _team_box_x_start = window_x1 + 40; var _team_box_y_start = window_y1 + 40;
for (var i = 0; i < 3; i++) {
    for (var j = 0; j < 2; j++) {
        var _x1 = _team_box_x_start + (j * (_team_btn_w + _team_box_padding));
        var _y1 = _team_box_y_start + (i * (_team_btn_h + _team_box_padding));
        array_push(btn_team_layout, [_x1, _y1, _x1 + _team_btn_w, _y1 + _team_btn_h]);
    }
}
var _cancel_x = window_x2 - 120 - 20; var _cancel_y = window_y2 - 40 - 20;
array_push(btn_team_layout, [_cancel_x, _cancel_y, _cancel_x + 120, _cancel_y + 40]);
download_bar_x1 = window_x1 + (window_width / 2) - (download_bar_w / 2);
download_bar_y1 = window_y1 + (window_height / 2);