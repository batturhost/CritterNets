// --- Step Event ---

// --- 1. Get Mouse GUI Coords ---
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// --- 2. DRAGGING LOGIC ---
if (mouse_check_button_pressed(mb_left)) {
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

// --- 3. RECALCULATE ALL UI POSITIONS ---
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;
player_actor.home_x = window_x1 + (window_width * 0.3);
player_actor.home_y = window_y1 + (window_height * 0.7);
enemy_actor.home_x = window_x1 + (window_width * 0.75);
enemy_actor.home_y = window_y1 + (window_height * 0.30);
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

// --- REBUILD BUTTON ARRAYS ---
// Format: [x1, y1, x2, y2, "Label"]

btn_main_menu = [
    [_btn_base_x, _btn_base_y, _btn_base_x + _btn_w, _btn_base_y + _btn_h, "FIGHT"],
    [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h, "TEAM"],
    [_btn_base_x, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w, _btn_base_y + _btn_h * 2 + _btn_gutter, "ITEM"],
    [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h * 2 + _btn_gutter, "RUN"]
];

// ================== THIS IS THE FIX ==================
// Added missing '_btn_base_y + _btn_h' to the second line
btn_move_menu = [
    [_btn_base_x, _btn_base_y, _btn_base_x + _btn_w, _btn_base_y + _btn_h, player_critter_data.moves[0].move_name],
    [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h, player_critter_data.moves[1].move_name], 
    [_btn_base_x, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w, _btn_base_y + _btn_h * 2 + _btn_gutter, player_critter_data.moves[2].move_name],
    [_btn_base_x + _btn_w + _btn_gutter, _btn_base_y + _btn_h + _btn_gutter, _btn_base_x + _btn_w * 2 + _btn_gutter, _btn_base_y + _btn_h * 2 + _btn_gutter, "BACK"]
];
// ================== END OF FIX =======================

// Team Layout Array
btn_team_layout = [];
var _team_btn_w = 400; 
var _team_btn_h = 100; 
var _team_box_padding = 10;
var _team_box_x_start = window_x1 + 40; 
var _team_box_y_start = window_y1 + 40;

for (var i = 0; i < 3; i++) {
    for (var j = 0; j < 2; j++) {
        var _x1 = _team_box_x_start + (j * (_team_btn_w + _team_box_padding));
        var _y1 = _team_box_y_start + (i * (_team_btn_h + _team_box_padding));
        array_push(btn_team_layout, [_x1, _y1, _x1 + _team_btn_w, _y1 + _team_btn_h]);
    }
}

var _cancel_x = window_x2 - 120 - 20; 
var _cancel_y = window_y2 - 40 - 20;
array_push(btn_team_layout, [_cancel_x, _cancel_y, _cancel_x + 120, _cancel_y + 40]);

download_bar_x1 = window_x1 + (window_width / 2) - (download_bar_w / 2);
download_bar_y1 = window_y1 + (window_height / 2);


// --- 4. Battle State Machine ---
switch (current_state) {
    
    case BATTLE_STATE.START:
        battle_log_text = current_opponent_data.name + " sent out " + enemy_critter_data.nickname + "!";
        alarm[0] = 120;
        current_state = BATTLE_STATE.WAIT_FOR_START;
        break;

    case BATTLE_STATE.PLAYER_TURN:
        if (is_force_swapping) {
            battle_log_text = player_critter_data.nickname + " fainted! Choose a new critter.";
        } else {
            battle_log_text = "What will " + player_critter_data.nickname + " do?";
        }
        
        var _key_enter = keyboard_check_pressed(vk_enter);
        var _up = keyboard_check_pressed(vk_up);
        var _down = keyboard_check_pressed(vk_down);
        var _left = keyboard_check_pressed(vk_left);
        var _right = keyboard_check_pressed(vk_right);
        var _click = mouse_check_button_pressed(mb_left);
        
        if (is_dragging) { _click = false; }
        
        // Navigation
        if (current_menu == MENU.MAIN || current_menu == MENU.FIGHT) {
            if (_up) { menu_focus = max(0, menu_focus - 2); }
            if (_down) { menu_focus = min(3, menu_focus + 2); }
            if (_left) { if (menu_focus == 1) { menu_focus = 0; } if (menu_focus == 3) { menu_focus = 2; } }
            if (_right) { if (menu_focus == 0) { menu_focus = 1; } if (menu_focus == 2) { menu_focus = 3; } }
        } else if (current_menu == MENU.TEAM) {
             if (_up) { if (menu_focus == 6) { menu_focus = 4; } else { menu_focus = max(0, menu_focus - 2); } }
             if (_down) { if (menu_focus >= 4) { menu_focus = 6; } else { menu_focus = min(5, menu_focus + 2); } }
             if (_left) { if (menu_focus % 2 == 1) { menu_focus--; } }
             if (_right) { if (menu_focus % 2 == 0 && menu_focus < 6) { menu_focus++; } }
        }
        
        // Menu Logic
        switch (current_menu) {
            case MENU.MAIN:
                for (var i = 0; i < 4; i++) { var _btn = btn_main_menu[i]; if (point_in_box(_mx, _my, _btn[0], _btn[1], _btn[2], _btn[3])) { menu_focus = i; if (_click) { _key_enter = true; } } }
                if (_key_enter) {
                    if (is_force_swapping && menu_focus != 1) {
                        battle_log_text = "You must choose a critter from your TEAM!";
                        break;
                    }
                    switch (menu_focus) {
                        case 0: current_menu = MENU.FIGHT; menu_focus = 0; break;
                        case 1: current_menu = MENU.TEAM; menu_focus = 0; break;
                        case 2: battle_log_text = "Item select not implemented yet!"; break;
                        case 3: if (is_casual) { battle_log_text = "You fled from the casual battle!"; current_state = BATTLE_STATE.LOSE; } else { battle_log_text = "You can't run from a ranked match!"; } break;
                    }
                }
                break;
            
            case MENU.FIGHT:
                for (var i = 0; i < 4; i++) { var _btn = btn_move_menu[i]; if (point_in_box(_mx, _my, _btn[0], _btn[1], _btn[2], _btn[3])) { menu_focus = i; if (_click) { _key_enter = true; } } }
                if (_key_enter) {
                    if (menu_focus < 3) { player_chosen_move = player_critter_data.moves[menu_focus]; current_state = BATTLE_STATE.PLAYER_MOVE_RUN; current_menu = MENU.MAIN; menu_focus = 0; }
                    else { current_menu = MENU.MAIN; menu_focus = 0; }
                }
                break;
                
            case MENU.TEAM:
                var _team_size = array_length(global.PlayerData.team);
                for (var i = 0; i < _team_size; i++) {
                    var _btn = btn_team_layout[i];
                    if (point_in_box(_mx, _my, _btn[0], _btn[1], _btn[2], _btn[3])) {
                        menu_focus = i;
                        if (_click) { _key_enter = true; }
                    }
                }
                var _cancel_btn = btn_team_layout[6];
                if (point_in_box(_mx, _my, _cancel_btn[0], _cancel_btn[1], _cancel_btn[2], _cancel_btn[3])) {
                    menu_focus = 6;
                    if (_click) { _key_enter = true; }
                }
                if (_key_enter) {
                    if (menu_focus == 6) {
                        if (is_force_swapping) {
                            battle_log_text = "You must choose a critter to continue!";
                        } else {
                            current_menu = MENU.MAIN;
                            menu_focus = 0;
                        }
                    }
                    else if (menu_focus < _team_size) {
                        var _target_critter = global.PlayerData.team[menu_focus];
                        if (_target_critter == player_critter_data) {
                            battle_log_text = _target_critter.nickname + " is already in battle!";
                        } else if (_target_critter.hp <= 0) {
                            battle_log_text = _target_critter.nickname + " is fainted!";
                        } else {
                            swap_target_index = menu_focus;
                            current_state = BATTLE_STATE.PLAYER_SWAP_OUT;
                            current_menu = MENU.MAIN;
                            menu_focus = 0;
                            is_force_swapping = false;
                        }
                    }
                }
                break;
        }
        break;
        
    case BATTLE_STATE.PLAYER_MOVE_RUN: 
        var _move = player_chosen_move; battle_log_text = player_critter_data.nickname + " used " + _move.move_name + "!";
        switch (_move.move_type) {
            case MOVE_TYPE.DAMAGE:
                effect_play_lunge(player_actor, enemy_actor);
                // Ice Effect Check
                if (_move.move_name == "Ice Pounce") {
                    effect_play_ice(player_actor);
                }
                var _atk_mult = get_stat_multiplier(player_critter_data.atk_stage); var _def_mult = get_stat_multiplier(enemy_critter_data.def_stage);
                var L = player_critter_data.level; var A = player_critter_data.atk * _atk_mult; var D = enemy_critter_data.defense * _def_mult; var P = _move.atk;
                var _damage = floor( ( ( ( (2 * L / 5) + 2 ) * P * (A / D) ) / 50 ) + 2 );
                enemy_critter_data.hp = max(0, enemy_critter_data.hp - _damage); effect_play_hurt(enemy_actor); break;
            case MOVE_TYPE.HEAL:
                player_critter_data.hp += _move.effect_power; player_critter_data.hp = min(player_critter_data.hp, player_critter_data.max_hp);
                effect_play_heal_flash(player_actor); battle_log_text = player_critter_data.nickname + " healed!"; break;
            case MOVE_TYPE.STAT_DEBUFF:
                enemy_critter_data.def_stage -= 1; enemy_critter_data.def_stage = clamp(enemy_critter_data.def_stage, -6, 6);
                effect_play_stat_flash(enemy_actor, "debuff"); battle_log_text = enemy_critter_data.nickname + "'s defense fell!"; break;
            case MOVE_TYPE.STAT_BUFF:
                if (_move == global.MOVE_SYSTEM_CALL) {
                    player_critter_data.glitch_timer = 3;
                    battle_log_text = player_critter_data.nickname + " is corrupting data!";
                    effect_play_hurt(player_actor); 
                } else if (_move.move_name == "Snow Cloak") {
                    effect_play_snow(player_actor);
                    battle_log_text = player_critter_data.nickname + " hid in the snow!";
                } else {
                    battle_log_text = player_critter_data.nickname + "'s defense rose!";
                }
                break;
        }
        alarm[0] = 120; current_state = BATTLE_STATE.WAIT_FOR_PLAYER_MOVE; break;

    case BATTLE_STATE.ENEMY_TURN:
        var _move_index = irandom_range(0, array_length(enemy_critter_data.moves) - 1); enemy_chosen_move = enemy_critter_data.moves[_move_index];
        current_state = BATTLE_STATE.ENEMY_MOVE_RUN; break;
        
    case BATTLE_STATE.ENEMY_MOVE_RUN:
        var _move = enemy_chosen_move; battle_log_text = enemy_critter_data.nickname + " used " + _move.move_name + "!";
        switch (_move.move_type) {
            case MOVE_TYPE.DAMAGE:
                effect_play_lunge(enemy_actor, player_actor);
                if (_move.move_name == "Ice Pounce") {
                    effect_play_ice(enemy_actor);
                }
                var _atk_mult = get_stat_multiplier(enemy_critter_data.atk_stage); var _def_mult = get_stat_multiplier(player_critter_data.def_stage);
                var L = enemy_critter_data.level; var A = enemy_critter_data.atk * _atk_mult; var D = player_critter_data.defense * _def_mult; var P = _move.atk;
                var _damage = floor( ( ( ( (2 * L / 5) + 2 ) * P * (A / D) ) / 50 ) + 2 );
                player_critter_data.hp = max(0, player_critter_data.hp - _damage); effect_play_hurt(player_actor); break;
            case MOVE_TYPE.HEAL:
                enemy_critter_data.hp += _move.effect_power; enemy_critter_data.hp = min(enemy_critter_data.hp, enemy_critter_data.max_hp);
                effect_play_heal_flash(enemy_actor); battle_log_text = enemy_critter_data.nickname + " healed!"; break;
            case MOVE_TYPE.STAT_DEBUFF:
                player_critter_data.def_stage -= 1; player_critter_data.def_stage = clamp(player_critter_data.def_stage, -6, 6);
                effect_play_stat_flash(player_actor, "debuff"); battle_log_text = player_critter_data.nickname + "'s defense fell!"; break;
            case MOVE_TYPE.STAT_BUFF:
                if (_move == global.MOVE_SYSTEM_CALL) {
                    enemy_critter_data.glitch_timer = 3;
                    battle_log_text = enemy_critter_data.nickname + " is corrupting data!";
                    effect_play_hurt(enemy_actor); 
                } else if (_move.move_name == "Snow Cloak") {
                    effect_play_snow(enemy_actor);
                    battle_log_text = enemy_critter_data.nickname + " hid in the snow!";
                } else {
                    battle_log_text = enemy_critter_data.nickname + "'s defense rose!";
                }
                break;
        }
        alarm[0] = 120; current_state = BATTLE_STATE.WAIT_FOR_ENEMY_MOVE; break;

    case BATTLE_STATE.PLAYER_FAINT:
        battle_log_text = player_critter_data.nickname + " fainted!"; player_actor.is_fainting = true;
        alarm[0] = 120; current_state = BATTLE_STATE.WAIT_FOR_FAINT; break;
    case BATTLE_STATE.ENEMY_FAINT:
        battle_log_text = enemy_critter_data.nickname + " fainted!"; enemy_actor.is_fainting = true;
        alarm[0] = 120; current_state = BATTLE_STATE.WAIT_FOR_FAINT; break;
    case BATTLE_STATE.PLAYER_SWAP_OUT:
        battle_log_text = player_critter_data.nickname + ", come back!";
        player_actor.is_fainting = true;
        alarm[0] = 90;
        current_state = BATTLE_STATE.PLAYER_SWAP_IN;
        break;
    case BATTLE_STATE.PLAYER_SWAP_IN:
        break;
    case BATTLE_STATE.WIN_DOWNLOAD_PROGRESS:
        if (download_current_percent < download_end_percent) {
            download_current_percent += 0.25; 
        } else {
            download_current_percent = download_end_percent;
            current_state = BATTLE_STATE.WIN_DOWNLOAD_COMPLETE;
            alarm[0] = 120; 
            if (download_current_percent >= 100) {
                var _key = current_opponent_data.critter_keys[0];
                var _data = global.bestiary[$ _key];
                var _level = enemy_critter_data.level;
                var _new_critter = new AnimalData(
                    _data.animal_name, _data.base_hp, _data.base_atk, _data.base_def, _data.base_spd,
                    _level, _data.sprite_idle, _data.sprite_idle_back, _data.sprite_signature_move,
                    _data.moves, _data.blurb, _data.size
                );
                _new_critter.nickname = _data.animal_name;
                _new_critter.gender = irandom(1);
                recalculate_stats(_new_critter);
                array_push(global.PlayerData.pc_box, _new_critter);
                global.PlayerData.collection_progress[$ _key] = 0;
            }
        }
        break;
    case BATTLE_STATE.WIN_DOWNLOAD_COMPLETE:
        break;
    case BATTLE_STATE.WIN_XP_GAIN:
        var _xp_gain = 100; 
        player_critter_data.xp += _xp_gain;
        battle_log_text = player_critter_data.nickname + " gained " + string(_xp_gain) + " XP!";
        alarm[0] = 120;
        current_state = BATTLE_STATE.WIN_CHECK_LEVEL;
        break;
    case BATTLE_STATE.WIN_CHECK_LEVEL:
    case BATTLE_STATE.WIN_LEVEL_UP_MSG:
        break;
    case BATTLE_STATE.WIN_END:
        battle_log_text = "You won the battle! Click to continue.";
        if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_enter)) {
            if (is_casual == false) { 
                global.PlayerData.team[0] = player_critter_data;
                global.PlayerData.current_opponent_index++;
                // array_push(global.unread_messages, opponent_lose_message); 
            } else {
                global.PlayerData.team[0] = player_critter_data;
            }
            instance_destroy(player_actor);
            instance_destroy(enemy_actor);
            instance_destroy();
        }
        break;
    case BATTLE_STATE.LOSE:
        battle_log_text = "You lost the battle... Click to continue.";
        if (is_casual == false && !global.bargain_offered) {
            if (current_opponent_data.name == "BronzeMod") {
                global.bargain_offered = true;
                var _msg1 = { from: "???", message: "...you cannot win." };
                var _msg2 = { from: "???", message: "...your tools are too simple." };
                var _msg3 = { from: "???", message: "...i can give you a better tool." };
                array_push(global.unread_messages, _msg1, _msg2, _msg3);
            }
        }
        if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_enter)) {
            global.PlayerData.team[0] = player_critter_data;
            instance_destroy(player_actor);
            instance_destroy(enemy_actor);
            instance_destroy();
        }
        break;
    
    // --- NEW PASSIVE DAMAGE STATES ---
    case BATTLE_STATE.PLAYER_POST_TURN_DAMAGE:
        battle_log_text = player_critter_data.nickname + " is damaged by the corruption!";
        var _passive_dmg = floor(player_critter_data.max_hp * 0.1); // 10% damage
        player_critter_data.hp = max(0, player_critter_data.hp - _passive_dmg);
        effect_play_hurt(player_actor); 
        alarm[0] = 90; 
        current_state = BATTLE_STATE.ENEMY_TURN; 
        break;
        
    case BATTLE_STATE.ENEMY_POST_TURN_DAMAGE:
        battle_log_text = enemy_critter_data.nickname + " is damaged by the corruption!";
        var _passive_dmg = floor(enemy_critter_data.max_hp * 0.1);
        enemy_critter_data.hp = max(0, enemy_critter_data.hp - _passive_dmg);
        effect_play_hurt(enemy_actor);
        alarm[0] = 90;
        current_state = BATTLE_STATE.PLAYER_TURN;
        break;
}