// --- Cup Database Script ---
// This file defines the "story mode" progression

/// @function OpponentData(_name, _pfp_sprite, _team_keys, _team_levels, _lose_message, _is_glitched = false)
function OpponentData(_name, _pfp_sprite, _team_keys, _team_levels, _lose_message, _is_glitched = false) constructor {
    name = _name; 
    profile_pic_sprite = _pfp_sprite;
    critter_keys = _team_keys;
    critter_levels = _team_levels;
    lose_message = _lose_message;
    is_glitched = _is_glitched; // Is this an "unfair" glitched opponent?
}

/// @function CupData(_name, _level_cap, _opponents)
function CupData(_name, _level_cap, _opponents) constructor {
    cup_name = _name;
    level_cap = _level_cap;
    opponents = _opponents; 
}


/// @function init_cup_database()
/// @desc Creates all Cups and stores them in a global variable
function init_cup_database() {
    
    global.CupDatabase = []; // This array will hold all our cups in order

    // --- 1. BRONZE CUP (Cup Index 0) ---
    var _bronze_opponents = [
        
        // Opponent 0 (Easy)
        new OpponentData( "RabbitLuvr", spr_avatar_user_01, [ "rabbit" ], [ 8 ], "U got lucky... my rabbit is usually way faster." ),
        
        // Opponent 1 (Easy)
        new OpponentData( "GeckoGamer", spr_avatar_user_02, [ "gecko" ], [ 10 ], "My connection must be lagging." ),
        
        // Opponent 2 (Medium)
        new OpponentData( "CatAttack", spr_avatar_user_03, [ "cat", "chinchilla" ], [ 10, 11 ], "lol whatever. my chinchilla was bugged. reported." ),
        
        // Opponent 3 (Medium)
        new OpponentData( "SqueakSquad", spr_avatar_user_01, [ "pomeranian", "raccoon" ], [ 12, 12 ], "My critters didn't listen to me! Unfair!" ),
        
        // Opponent 4 ("THE WALL" / BOSS)
        new OpponentData(
            "BronzeMod",
            spr_avatar_user_03,
            [ "hedgehog", "koala", "snake" ], // Strong team
            [ 14, 14, 16 ], // Level 16 is ABOVE the cap
            "...Protocol violation detected. Account flagged.",
            true // This is an "unfair" glitched opponent
        )
    ];
    
    var _bronze_cup = new CupData( "Bronze Cup", 15, _bronze_opponents );
    array_push(global.CupDatabase, _bronze_cup);
}