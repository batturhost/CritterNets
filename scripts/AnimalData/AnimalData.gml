// --- AnimalData Script ---
// This is the "constructor" for an animal's "Pokédex" entry.

function AnimalData(
    _name, _hp, _atk, _def, _spd, _level, 
    _sprite_idle, 
    _sprite_idle_back,
    _sprite_sig_move, 
    _moves, _blurb, _size
    ) constructor {
    
    // --- Pokedex Info ---
    animal_name = _name;
    nickname = _name; 
    blurb = _blurb;
    size = _size;
    gender = 0;
    is_corrupted = false;
    
    // ================== NEW VARIABLE ==================
    glitch_timer = 0; // How many turns the "Glitched" status is active
    // ================== END OF NEW VAR ================
    
    // --- Base Stats ---
    base_hp = _hp;
    base_atk = _atk;
    base_def = _def;
    base_spd = _spd;
    
    // --- Sprites ---
    sprite_idle = _sprite_idle; 
    sprite_idle_back = _sprite_idle_back; 
    sprite_signature_move = _sprite_sig_move;
    
    // --- Moves ---
    moves = _moves; 
    
    // --- Current Battle Stats ---
    level = _level;
    xp = 0; 
    xp_to_next = 0;
    hp = 0;
    max_hp = 0;
    atk = 0;
    defense = 0;
    speed = 0;
    
    // Stat Stages
    atk_stage = 0;
    def_stage = 0;
    spd_stage = 0;
}