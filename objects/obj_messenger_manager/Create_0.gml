// --- Create Event ---

// 1. Define Window Layout
window_width = 650;
window_height = 500;
window_x1 = (display_get_gui_width() / 2) - (window_width / 2);
window_y1 = (display_get_gui_height() / 2) - (window_height / 2); 
window_x2 = window_x1 + window_width;
window_y2 = window_y1 + window_height;

is_dragging = false;
drag_dx = 0;
drag_dy = 0;

// 2. Define Close Button
btn_close_x1 = 0; btn_close_y1 = 0; btn_close_x2 = 0; btn_close_y2 = 0;
btn_close_hover = false;

// 3. Layout Definitions (CLEANER LAYOUT - NO ICON BAR)
toolbar_y1 = window_y1 + 32; 
toolbar_h = 25; 

// Left Pane: Buddy List
buddy_list_x = window_x1 + 10;
buddy_list_y = toolbar_y1 + toolbar_h + 10; 
buddy_list_w = 180; 
buddy_list_h = window_height - (buddy_list_y - window_y1) - 20; 

// Right Pane: Chat Window
chat_area_x = buddy_list_x + buddy_list_w + 10;
chat_area_y = buddy_list_y; 
chat_area_w = (window_x2 - 10) - chat_area_x;

// FIX: Reduced height to make room for button at bottom
chat_area_h = buddy_list_h - 95; 

// Input Box (Bottom Right)
input_area_x = chat_area_x;
input_area_y = chat_area_y + chat_area_h + 10;
input_area_w = chat_area_w;
input_area_h = 50;

// Send Button
btn_send_w = 70;
btn_send_h = 25;
btn_send_x1 = input_area_x + input_area_w - btn_send_w;
btn_send_y1 = input_area_y + input_area_h + 5; 
btn_send_x2 = btn_send_x1 + btn_send_w;
btn_send_y2 = btn_send_y1 + btn_send_h;
btn_send_hover = false;

// 4. Data Processing
chat_logs = {}; 
contact_list = []; 

// Default System Message
array_push(contact_list, "System");
chat_logs[$ "System"] = ["Welcome to CNet Messenger.", "No new alerts."];

// ================== TEST CONVERSATION ==================
array_push(contact_list, "NetUser_01");
chat_logs[$ "NetUser_01"] = [
    "Yo! You're the new user right?", 
    "I saw your match in the casual lobby.", 
    "Your starter looks pretty strong!",
    "Watch out for BronzeMod though. I heard his team is hacked."
];
// ================== END TEST ==================

// Process Unread Messages from Global (Story Events)
for (var i = 0; i < array_length(global.unread_messages); i++) {
    var _msg_obj = global.unread_messages[i];
    var _sender = _msg_obj.from;
    var _message = _msg_obj.message;
    
    if (!variable_struct_exists(chat_logs, _sender)) {
        chat_logs[$ _sender] = [];
        array_push(contact_list, _sender);
    }
    array_push(chat_logs[$ _sender], _message);
}

global.unread_messages = [];

// 5. Selection State
selected_contact_index = 0;
selected_contact_name = contact_list[0];
contact_item_height = 24; 
msg_line_height = 20;