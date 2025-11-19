// --- Alarm 0 Event ---
// This is the router that controls the battle flow

switch (current_state) {
    
    case BATTLE_STATE.WAIT_FOR_START:
        // The "Battle Begins!" message just finished.
        // Decide who goes first based on Speed.
        if (player_critter_data.speed >= enemy_critter_data.speed) {
            current_state = BATTLE_STATE.PLAYER_TURN;
        } else {
            current_state = BATTLE_STATE.ENEMY_TURN;
        }
        break;
        
    case BATTLE_STATE.WAIT_FOR_PLAYER_MOVE:
        // Player attack animation finished.
        if (enemy_critter_data.hp <= 0) {
            current_state = BATTLE_STATE.ENEMY_FAINT;
        } 
        else if (player_critter_data.glitch_timer > 0) {
            // Handle Glitch Self-Damage
            player_critter_data.glitch_timer--;
            current_state = BATTLE_STATE.PLAYER_POST_TURN_DAMAGE;
        }
        else {
            current_state = BATTLE_STATE.ENEMY_TURN;
        }
        break;
        
    case BATTLE_STATE.WAIT_FOR_ENEMY_MOVE:
        // Enemy attack animation finished.
        if (player_critter_data.hp <= 0) {
            current_state = BATTLE_STATE.PLAYER_FAINT;
        }
        else if (enemy_critter_data.glitch_timer > 0) {
            // Handle Glitch Self-Damage
            enemy_critter_data.glitch_timer--;
            current_state = BATTLE_STATE.ENEMY_POST_TURN_DAMAGE;
        }
        else {
            current_state = BATTLE_STATE.PLAYER_TURN;
        }
        break;
        
    case BATTLE_STATE.PLAYER_SWAP_IN:
        // The "Come back!" animation just finished
        var _new_critter = global.PlayerData.team[swap_target_index];
        player_critter_data = _new_critter;
        
        init_animal(player_actor, _new_critter, _new_critter.sprite_idle_back);
        
        player_actor.is_fainting = false;
        player_actor.faint_alpha = 1.0; // Make visible
        player_actor.faint_scale_y = 1.0;
        
        effect_play_heal_flash(player_actor); 
        
        // Update the move buttons
        btn_move_menu = [
            [btn_move_menu[0][0], btn_move_menu[0][1], btn_move_menu[0][2], btn_move_menu[0][3], _new_critter.moves[0].move_name],
            [btn_move_menu[1][0], btn_move_menu[1][1], btn_move_menu[1][2], btn_move_menu[1][3], _new_critter.moves[1].move_name],
            [btn_move_menu[2][0], btn_move_menu[2][1], btn_move_menu[2][2], btn_move_menu[2][3], _new_critter.moves[2].move_name],
            btn_move_menu[3] // The "BACK" button
        ];
        
        battle_log_text = "Go, " + _new_critter.nickname + "!";
        
        alarm[0] = 90;
        current_state = BATTLE_STATE.ENEMY_TURN;
        break;

    case BATTLE_STATE.WAIT_FOR_FAINT:
        if (player_actor.is_fainting && player_actor.faint_alpha <= 0) {
            // Player Fainted
            if (player_has_healthy_critters()) {
                is_force_swapping = true; 
                current_state = BATTLE_STATE.PLAYER_TURN;
                current_menu = MENU.TEAM;
                battle_log_text = "Choose your next critter.";
            } else {
                current_state = BATTLE_STATE.LOSE;
            }
        } 
        else if (enemy_actor.is_fainting && enemy_actor.faint_alpha <= 0) {
            // Enemy Fainted
            if (is_casual == true) {
                // Casual: Try to catch/download
                var _key = current_opponent_data.critter_keys[0];
                
                // TEST CODE: Instant 100%
                download_start_percent = 0;
                download_end_percent = 100;
                
                download_current_percent = download_start_percent;
                download_filename = _key + ".file";
                download_sprite = enemy_critter_data.sprite_idle; 
                current_state = BATTLE_STATE.WIN_DOWNLOAD_PROGRESS;
            } else {
                // Ranked: Just win
                current_state = BATTLE_STATE.WIN_XP_GAIN;
            }
        }
        break;
    
    case BATTLE_STATE.WIN_DOWNLOAD_COMPLETE:
        current_state = BATTLE_STATE.WIN_XP_GAIN;
        break;
        
    case BATTLE_STATE.WIN_CHECK_LEVEL:
        if (player_critter_data.xp >= player_critter_data.xp_to_next) {
            player_critter_data.level++;
            recalculate_stats(player_critter_data); 
            battle_log_text = player_critter_data.nickname + " grew to Level " + string(player_critter_data.level) + "!";
            alarm[0] = 120;
            current_state = BATTLE_STATE.WIN_LEVEL_UP_MSG;
        } else {
            current_state = BATTLE_STATE.WIN_END;
        }
        break;
        
    case BATTLE_STATE.WIN_LEVEL_UP_MSG:
        current_state = BATTLE_STATE.WIN_END;
        break;
        
    // --- PASSIVE DAMAGE TRANSITIONS ---
    case BATTLE_STATE.PLAYER_POST_TURN_DAMAGE:
        current_state = BATTLE_STATE.ENEMY_TURN;
        break;
        
    case BATTLE_STATE.ENEMY_POST_TURN_DAMAGE:
        current_state = BATTLE_STATE.PLAYER_TURN;
        break;
}