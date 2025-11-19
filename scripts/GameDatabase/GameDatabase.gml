// --- GameDatabase Script ---
// This function will build our entire Bestiary

function init_database() {
    
    // --- 1. DEFINE SHARED MOVES ---
    
    global.GENERIC_MOVE_LUNGE = new MoveData("Lunge", 30, 100, "A basic physical lunge.", "A simple lunge.", 
        MOVE_TYPE.DAMAGE); 
        
    global.GENERIC_MOVE_AGITATE = new MoveData("Agitate", 0, 100, "The critter looks agitated.", "Lowers enemy defense.", 
        MOVE_TYPE.STAT_DEBUFF, -1); // -1 = Defense Down 1 Stage

    global.MOVE_SYSTEM_CALL = new MoveData("System_Call", 0, 100, "Corrupts data. [RISKY]", "Applies 'Glitched' status for 3 turns.",
        MOVE_TYPE.STAT_BUFF, 99); // 99 is a special ID we'll use for the "Glitched" state


    // --- 2. DEFINE OUR BESTIARY ---
    global.bestiary = {}; 
    
    
    // --- 3. ADD THE ARCTIC FOX (POLISHED) ---
    // Archetype: Speedster / Glass Cannon
    
    // Signature Move: Renamed to fit UI
    var move_glacial_pounce = new MoveData("Ice Pounce", 55, 95, "A freezing leap.", "Deals massive damage.", MOVE_TYPE.DAMAGE);
    
    // Utility Move: Raises Defense
    var move_snow_cloak = new MoveData("Snow Cloak", 0, 100, "Hides in snow.", "Raises user's defense.", MOVE_TYPE.STAT_BUFF);
    
    global.bestiary.arctic_fox = new AnimalData(
        "Arctic Fox",
        75, 115, 60, 145, 5,       // Stats (HP: Low, ATK: High, DEF: Low, SPD: Very High)
        spr_arctic_fox_idle,      // Idle sprite (Front)
        spr_arctic_fox_idle_back, // Idle sprite (Back)
        spr_arctic_fox_idle,      // Signature move
        [ global.GENERIC_MOVE_LUNGE, move_snow_cloak, move_glacial_pounce ],
        "Native to the Arctic regions of the Northern Hemisphere. Its thick fur turns white in winter for perfect camouflage.", // Real-world fact
        "Avg. Size: 3.5 kg" 
    );
    
    
    // --- 4. ADD THE CAPYBARA ---
    var move_take_nap = new MoveData("Take a Nap", 0, 100, "Heals 50 HP.", "Restores a small amount of HP.", 
        MOVE_TYPE.HEAL, 50); 
    
    global.bestiary.capybara = new AnimalData(
        "Capybara",
        190, 10, 140, 20, 5,       // Stats (HP, ATK, DEF, SPD, LVL)
        spr_capybara_idle,
        spr_capybara_idle_back,
        spr_capybara_idle,      // Signature move (placeholder)
        [ global.GENERIC_MOVE_LUNGE, global.GENERIC_MOVE_AGITATE, move_take_nap ],
        "A large, semi-aquatic rodent. It is known for its calm and sociable nature.", // Blurb
        "Avg. Size: 45 kg" // Size
    );

    // --- 5. ADD THE GOOSE ---
    var move_honk = new MoveData("HONK", 0, 100, "A terrifying noise.", "Lowers enemy defense.",
        MOVE_TYPE.STAT_DEBUFF, -1); 
    
    global.bestiary.goose = new AnimalData(
        "Goose",
        100, 70, 70, 70, 5, // Stats (HP, ATK, DEF, SPD, LVL)
        spr_goose_idle,
        spr_goose_idle_back,
        spr_goose_idle,         // Signature move (placeholder)
        [ global.GENERIC_MOVE_LUNGE, global.GENERIC_MOVE_AGITATE, move_honk ],
        "A large waterfowl known for its aggressive territorial behavior.", // Blurb
        "Avg. Size: 4.0 kg" // Size
    );

    // --- 6. ADD THE AXOLOTL ---
    var move_sig_axolotl = new MoveData("Regenerate", 0, 100, "Heals 50 HP.", "Restores a small amount of HP.", MOVE_TYPE.HEAL, 50);
    global.bestiary.axolotl = new AnimalData(
        "Axolotl",
        150, 50, 100, 40, 5, // Defensive/Healer
        spr_axolotl_idle, 
        spr_axolotl_idle_back, 
        spr_axolotl_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_axolotl, global.GENERIC_MOVE_AGITATE], 
        "A neotenic salamander. It is known for its ability to regenerate limbs.", 
        "Avg. Size: 0.2 kg"
    );
    
    // --- 7. ADD THE PANDA ---
    var move_sig_panda = new MoveData("Playful Roll", 40, 100, "A clumsy, adorable roll.", "A strong physical attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.panda = new AnimalData(
        "Panda",
        160, 90, 120, 40, 5, // Bulky
        spr_panda_idle, 
        spr_panda_idle_back, 
        spr_panda_idle, 
        [global.GENERIC_MOVE_LUNGE, global.GENERIC_MOVE_AGITATE, move_sig_panda], 
        "A large bear native to China. It is known for its black and white coat.", 
        "Avg. Size: 100 kg"
    );

    // --- 8. ADD THE BOX TURTLE ---
    var move_sig_box_turtle = new MoveData("Withdraw", 0, 100, "Hides in its shell.", "Sharply raises user's defense.", MOVE_TYPE.STAT_BUFF, 2);
    global.bestiary.box_turtle = new AnimalData(
        "Box Turtle",
        120, 40, 200, 20, 5, // Super Tank
        spr_box_turtle_idle, 
        spr_box_turtle_idle_back, 
        spr_box_turtle_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_box_turtle, global.GENERIC_MOVE_AGITATE], 
        "A turtle with a domed shell that is hinged, allowing it to close completely.", 
        "Avg. Size: 0.5 kg"
    );

    // --- 9. ADD THE CAT ---
    var move_sig_cat = new MoveData("Scratch", 40, 100, "A fast scratch.", "A basic, high-speed attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.cat = new AnimalData(
        "Cat",
        90, 110, 80, 160, 5, // Speedy Attacker
        spr_cat_idle, 
        spr_cat_idle_back, 
        spr_cat_idle, 
        [global.GENERIC_MOVE_LUNGE, global.GENERIC_MOVE_AGITATE, move_sig_cat], 
        "A small carnivorous mammal. It is often kept as a pet.", 
        "Avg. Size: 4.5 kg"
    );

    // --- 10. ADD THE CHINCHILLA ---
    var move_sig_chinchilla = new MoveData("Dust Bath", 0, 100, "Rolls in volcanic ash.", "Raises user's defense.", MOVE_TYPE.STAT_BUFF, 1);
    global.bestiary.chinchilla = new AnimalData(
        "Chinchilla",
        70, 60, 80, 190, 5, // Speedster
        spr_chinchilla_idle, 
        spr_chinchilla_idle_back, 
        spr_chinchilla_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_chinchilla, global.GENERIC_MOVE_AGITATE], 
        "A rodent known for its incredibly soft fur. It is highly social and active.", 
        "Avg. Size: 0.6 kg"
    );

    // --- 11. ADD THE DESERT RAIN FROG ---
    var move_sig_desert_rain_frog = new MoveData("Tiny Roar", 0, 100, "A squeak of rage.", "Lowers enemy attack.", MOVE_TYPE.STAT_DEBUFF, -1);
    global.bestiary.desert_rain_frog = new AnimalData(
        "Desert Rain Frog",
        100, 40, 80, 30, 5, // Defensive
        spr_desert_rain_frog_idle, 
        spr_desert_rain_frog_idle_back, 
        spr_desert_rain_frog_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_desert_rain_frog, global.GENERIC_MOVE_AGITATE], 
        "A small, burrowing frog. It has a round body and a distinctive, high-pitched call.", 
        "Avg. Size: 0.01 kg"
    );

    // --- 12. ADD THE GECKO ---
    var move_sig_gecko = new MoveData("Wall Climb", 0, 100, "Climbs the screen.", "Raises user's speed.", MOVE_TYPE.STAT_BUFF, 1);
    global.bestiary.gecko = new AnimalData(
        "Gecko",
        80, 70, 70, 160, 5, // Speedy
        spr_gecko_idle, 
        spr_gecko_idle_back, 
        spr_gecko_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_gecko, global.GENERIC_MOVE_AGITATE], 
        "A small lizard known for its specialized toe pads that allow it to climb.", 
        "Avg. Size: 0.05 kg"
    );

    // --- 13. ADD THE SNUB-NOSED MONKEY ---
    var move_sig_snub_nosed_monkey = new MoveData("Branch Whap", 40, 100, "A quick thwack.", "A simple physical attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.snub_nosed_monkey = new AnimalData(
        "Snub-Nosed Monkey",
        100, 110, 80, 130, 5, // Balanced Attacker
        spr_snub_nosed_monkey_idle, 
        spr_snub_nosed_monkey_idle_back, 
        spr_snub_nosed_monkey_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_snub_nosed_monkey, global.GENERIC_MOVE_AGITATE], 
        "A group of Old World monkeys known for their colorful faces and short snouts.", 
        "Avg. Size: 10 kg"
    );

    // --- 14. ADD THE HARP SEAL ---
    var move_sig_harp_seal = new MoveData("Ice Slide", 40, 100, "A fast slide on its belly.", "A quick physical attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.harp_seal = new AnimalData(
        "Harp Seal",
        170, 70, 110, 60, 5, // Bulky
        spr_harp_seal_idle, 
        spr_harp_seal_idle_back, 
        spr_harp_seal_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_harp_seal, global.GENERIC_MOVE_AGITATE], 
        "A species of earless seal. Pups are known for their bright white coats.", 
        "Avg. Size: 140 kg"
    );

    // --- 15. ADD THE HEDGEHOG ---
    var move_sig_hedgehog = new MoveData("Spiky Shield", 0, 100, "Curls into a spiky ball.", "Raises user's defense.", MOVE_TYPE.STAT_BUFF, 1);
    global.bestiary.hedgehog = new AnimalData(
        "Hedgehog",
        120, 70, 150, 60, 5, // Defensive
        spr_hedgehog_idle, 
        spr_hedgehog_idle_back, 
        spr_hedgehog_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_hedgehog, global.GENERIC_MOVE_AGITATE], 
        "A spiny mammal. It curls into a ball for defense.", 
        "Avg. Size: 0.8 kg"
    );

    // --- 16. ADD THE KOALA ---
    var move_sig_koala = new MoveData("Eucalyptus Eat", 0, 100, "Eats some leaves.", "Heals 40 HP.", MOVE_TYPE.HEAL, 40);
    global.bestiary.koala = new AnimalData(
        "Koala",
        160, 60, 110, 30, 5, // Bulky Healer
        spr_koala_idle, 
        spr_koala_idle_back, 
        spr_koala_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_koala, global.GENERIC_MOVE_AGITATE], 
        "An arboreal marsupial. It is herbivorous and sleeps for up to 20 hours a day.", 
        "Avg. Size: 9 kg"
    );

    // --- 17. ADD THE MEERKAT ---
    var move_sig_meerkat = new MoveData("Dig", 40, 100, "Digs and attacks.", "A quick burrowing attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.meerkat = new AnimalData(
        "Meerkat",
        70, 120, 60, 160, 5, // Glass Cannon
        spr_meerkat_idle, 
        spr_meerkat_idle_back, 
        spr_meerkat_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_meerkat, global.GENERIC_MOVE_AGITATE], 
        "A small mongoose. It is known for its upright posture and social colonies.", 
        "Avg. Size: 0.7 kg"
    );

    // --- 18. ADD THE OTTER ---
    var move_sig_otter = new MoveData("Water Jet", 40, 100, "A jet of water.", "A fast aquatic attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.otter = new AnimalData(
        "Otter",
        90, 100, 80, 140, 5, // Speedy Attacker
        spr_otter_idle, 
        spr_otter_idle_back, 
        spr_otter_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_otter, global.GENERIC_MOVE_AGITATE], 
        "A semiaquatic mammal. It is playful and known for using tools.", 
        "Avg. Size: 10 kg"
    );

    // --- 19. ADD THE PENGUIN ---
    var move_sig_penguin = new MoveData("Belly Slide", 40, 100, "A slide on its belly.", "A quick physical attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.penguin = new AnimalData(
        "Penguin",
        140, 80, 110, 80, 5, // Bulky
        spr_penguin_idle, 
        spr_penguin_idle_back, 
        spr_penguin_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_penguin, global.GENERIC_MOVE_AGITATE], 
        "A species of aquatic flightless bird. It is highly adapted to life in the water.", 
        "Avg. Size: 15 kg"
    );

    // --- 20. ADD THE POMERANIAN ---
    var move_sig_pomeranian = new MoveData("Yap", 0, 100, "An annoying, shrill bark.", "Lowers enemy attack.", MOVE_TYPE.STAT_DEBUFF, -1);
    global.bestiary.pomeranian = new AnimalData(
        "Pomeranian",
        70, 90, 60, 170, 5, // Speedy Attacker
        spr_pomeranian_idle, 
        spr_pomeranian_idle_back, 
        spr_pomeranian_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_pomeranian, global.GENERIC_MOVE_AGITATE], 
        "A breed of dog of the Spitz type. It is known for its small size and fluffy coat.", 
        "Avg. Size: 2.5 kg"
    );

    // --- 21. ADD THE RABBIT ---
    var move_sig_rabbit = new MoveData("Quick Hop", 40, 100, "A very fast hop.", "A speedy physical attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.rabbit = new AnimalData(
        "Rabbit",
        70, 70, 60, 200, 5, // Speedster
        spr_rabbit_idle, 
        spr_rabbit_idle_back, 
        spr_rabbit_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_rabbit, global.GENERIC_MOVE_AGITATE], 
        "A small mammal. It is known for its long ears, powerful hind legs, and high speed.", 
        "Avg. Size: 1.5 kg"
    );

    // --- 22. ADD THE RACCOON ---
    var move_sig_raccoon = new MoveData("Snatch", 40, 100, "A quick snatch.", "A sneaky physical attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.raccoon = new AnimalData(
        "Raccoon",
        100, 100, 100, 100, 5, // All-Rounder
        spr_raccoon_idle, 
        spr_raccoon_idle_back, 
        spr_raccoon_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_raccoon, global.GENERIC_MOVE_AGITATE], 
        "A medium-sized mammal known for its dexterity and facial mask.", 
        "Avg. Size: 7 kg"
    );

    // --- 23. ADD THE RED PANDA ---
    var move_sig_red_panda = new MoveData("Bamboo Bite", 40, 100, "A gentle but firm bite.", "Not just for bamboo.", MOVE_TYPE.DAMAGE);
    global.bestiary.red_panda = new AnimalData(
        "Red Panda",
        110, 90, 80, 120, 5, // Balanced Speedster
        spr_red_panda_idle, 
        spr_red_panda_idle_back, 
        spr_red_panda_idle, 
        [global.GENERIC_MOVE_LUNGE, global.GENERIC_MOVE_AGITATE, move_sig_red_panda], 
        "A small mammal with reddish-brown fur. It is arboreal and shy.", 
        "Avg.Size: 5 kg"
    );

    // --- 24. ADD THE SABLE ---
    var move_sig_sable = new MoveData("Fur Swipe", 40, 100, "A soft but fast swipe.", "A speedy physical attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.sable = new AnimalData(
        "Sable",
        80, 110, 70, 170, 5, // Speedy Attacker
        spr_sable_idle, 
        spr_sable_idle_back, 
        spr_sable_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_sable, global.GENERIC_MOVE_AGITATE], 
        "A species of marten. It is known for its highly prized, dark-brown fur.", 
        "Avg. Size: 1.3 kg"
    );

    // --- 25. ADD THE SEAGULL ---
    var move_sig_seagull = new MoveData("Dive", 45, 100, "A fast aerial dive.", "A powerful flying attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.seagull = new AnimalData(
        "Seagull",
        90, 120, 70, 150, 5, // Speedy Attacker
        spr_seagull_idle, 
        spr_seagull_idle_back, 
        spr_seagull_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_seagull, global.GENERIC_MOVE_AGITATE], 
        "A medium to large bird. It is typically grey or white, with black markings.", 
        "Avg. Size: 1.0 kg"
    );

    // --- 26. ADD THE SNAKE ---
    var move_sig_snake = new MoveData("Poison Bite", 45, 100, "A venomous bite.", "A strong, toxic attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.snake = new AnimalData(
        "Snake",
        80, 140, 70, 140, 5, // Speedy Attacker
        spr_snake_idle, 
        spr_snake_idle_back, 
        spr_snake_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_snake, global.GENERIC_MOVE_AGITATE], 
        "A legless, carnivorous reptile. Many species use venom to subdue prey.", 
        "Avg. Size: Varies"
    );

    // --- 27. ADD THE SUGAR GLIDER ---
    var move_sig_sugar_glider = new MoveData("Glide", 40, 100, "Glides at the foe.", "A fast physical attack.", MOVE_TYPE.DAMAGE);
    global.bestiary.sugar_glider = new AnimalData(
        "Sugar Glider",
        70, 80, 60, 190, 5, // Speedster
        spr_sugar_glider_idle, 
        spr_sugar_glider_idle_back, 
        spr_sugar_glider_idle, 
        [global.GENERIC_MOVE_LUNGE, move_sig_sugar_glider, global.GENERIC_MOVE_AGITATE], 
        "A small, nocturnal possum. It has a membrane that allows it to glide.", 
        "Avg. Size: 0.12 kg"
    );
}