// --- Mouse Left Button (DOWN) Event ---
// Check if the click is on the title bar to start dragging.
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Check coordinates of the title bar (from y1+2 to y1+32)
if (point_in_box(_mx, _my, window_x1, window_y1, window_x2, window_y1 + 32)) {
    is_dragging = true;
    
    // Calculate the offset (where the mouse clicked relative to the window's top-left)
    drag_dx = window_x1 - _mx;
    drag_dy = window_y1 - _my;
}