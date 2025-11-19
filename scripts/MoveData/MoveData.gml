// --- MoveData Script ---
// This is a "constructor" - a template for creating "Move" data

// NEW: An enum to define our move types
enum MOVE_TYPE {
    DAMAGE,
    HEAL,
    STAT_BUFF,
    STAT_DEBUFF
}

// UPDATED: Added _type and _power arguments
function MoveData(_name, _atk, _accuracy, _description, _blurb, 
                  _type = MOVE_TYPE.DAMAGE, _power = 0) constructor {
    
    move_name = _name;
    atk = _atk; // Base power for DAMAGE moves
    accuracy = _accuracy;
    description = _description; 
    blurb = _blurb;
    
    // --- NEW VARIABLES ---
    move_type = _type;   // What kind of move is this?
    effect_power = _power; // How much does it heal? Or what's the stat power?
}