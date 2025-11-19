// --- scr_level_helpers ---

/// @function get_xp_for_level(level)
/// @arg level
/// @desc Calculates the TOTAL XP needed to reach a given level.
function get_xp_for_level(_level) {
    var _xp_val = _level * _level * _level;
    return floor(_xp_val);
}


/// @function recalculate_stats(critter_data)
/// @arg critter_data (e.g., player_critter_data)
/// @desc Calculates all stats AND starting XP.
function recalculate_stats(_critter_data) {
    
    var L = _critter_data.level;
    
    // Set the initial XP and XP to next level
    _critter_data.xp = get_xp_for_level(L);
    _critter_data.xp_to_next = get_xp_for_level(L + 1);
    
    // --- HP CALCULATION ---
    var B_HP = _critter_data.base_hp;
    _critter_data.max_hp = floor( (((B_HP * 2) * L) / 100) + L + 10 );
    
    // On the first-time calc, set current HP to max HP
    _critter_data.hp = _critter_data.max_hp;
    
    // --- OTHER STATS CALCULATION ---
    
    // Attack
    var B_ATK = _critter_data.base_atk;
    _critter_data.atk = floor( (((B_ATK * 2) * L) / 100) + 5 );
    
    // Defense
    var B_DEF = _critter_data.base_def;
    _critter_data.defense = floor( (((B_DEF * 2) * L) / 100) + 5 );
    
    // Speed
    var B_SPD = _critter_data.base_spd;
    _critter_data.speed = floor( (((B_SPD * 2) * L) / 100) + 5 );
}


// ================== NEW STAT FUNCTION ==================

/// @function get_stat_multiplier(stage)
/// @arg stage (e.g., -6 to +6)
/// @desc Converts a stat stage into a multiplier for the damage formula.
function get_stat_multiplier(_stage) {
    
    // This is the official Pokémon formula for stat modifiers
    
    if (_stage > 0) {
        // Buffs
        return (2 + _stage) / 2; // e.g., +1 = 1.5x, +2 = 2x, +6 = 4x
    }
    else if (_stage < 0) {
        // Debuffs
        return 2 / (2 - _stage); // e.g., -1 = 0.66x, -2 = 0.5x, -6 = 0.25x
    }
    else {
        // No change
        return 1.0;
    }
}
// ================== END OF NEW CODE ==================