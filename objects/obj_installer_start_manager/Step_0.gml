// --- Step Event ---

// 1. Update Blink Timer
blink_timer = (blink_timer + 1) % 60;

// 2. Count down the delay
if (start_delay > 0) {
    start_delay--;
} 
else {
    // 3. Click anywhere to start (Only active after delay)
    if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_anykey)) {
        room_goto(rm_sign_up);
    }
}