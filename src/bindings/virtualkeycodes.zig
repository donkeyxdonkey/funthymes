pub const VK_LBUTTON = 0x01; // Left mouse button
pub const VK_RBUTTON = 0x02; // Right mouse button
pub const VK_CANCEL = 0x03; // Control-break processing
pub const VK_MBUTTON = 0x04; // Middle mouse button
pub const VK_XBUTTON1 = 0x05; // X1 mouse button
pub const VK_XBUTTON2 = 0x06; // X2 mouse button
// Reserved, no constant for 0x07
pub const VK_BACK = 0x08; // BACKSPACE key
pub const VK_TAB = 0x09; // TAB key
// Reserved, no constant for 0x0A-0x0B
pub const VK_CLEAR = 0x0C; // CLEAR key
pub const VK_RETURN = 0x0D; // ENTER key
// Unassigned, no constant for 0x0E-0x0F
pub const VK_SHIFT = 0x10; // SHIFT key
pub const VK_CONTROL = 0x11; // CTRL key
pub const VK_MENU = 0x12; // ALT key
pub const VK_PAUSE = 0x13; // PAUSE key
pub const VK_CAPITAL = 0x14; // CAPS LOCK key
pub const VK_KANA = 0x15; // IME Kana mode
pub const VK_HANGUL = 0x15; // IME Hangul mode
pub const VK_IME_ON = 0x16; // IME On
pub const VK_JUNJA = 0x17; // IME Junja mode
pub const VK_FINAL = 0x18; // IME final mode
pub const VK_HANJA = 0x19; // IME Hanja mode
pub const VK_KANJI = 0x19; // IME Kanji mode
pub const VK_IME_OFF = 0x1A; // IME Off
pub const VK_ESCAPE = 0x1B; // ESC key
pub const VK_CONVERT = 0x1C; // IME convert
pub const VK_NONCONVERT = 0x1D; // IME nonconvert
pub const VK_ACCEPT = 0x1E; // IME accept
pub const VK_MODECHANGE = 0x1F; // IME mode change request
pub const VK_SPACE = 0x20; // SPACEBAR
pub const VK_PRIOR = 0x21; // PAGE UP key
pub const VK_NEXT = 0x22; // PAGE DOWN key
pub const VK_END = 0x23; // END key
pub const VK_HOME = 0x24; // HOME key
pub const VK_LEFT = 0x25; // LEFT ARROW key
pub const VK_UP = 0x26; // UP ARROW key
pub const VK_RIGHT = 0x27; // RIGHT ARROW key
pub const VK_DOWN = 0x28; // DOWN ARROW key
pub const VK_SELECT = 0x29; // SELECT key
pub const VK_PRINT = 0x2A; // PRINT key
pub const VK_EXECUTE = 0x2B; // EXECUTE key
pub const VK_SNAPSHOT = 0x2C; // PRINT SCREEN key
pub const VK_INSERT = 0x2D; // INS key
pub const VK_DELETE = 0x2E; // DEL key
pub const VK_HELP = 0x2F; // HELP key

// direct ANSI Mapped
// 0x30 0 key
// 0x31 1 key
// 0x32 2 key
// 0x33 3 key
// 0x34 4 key
// 0x35 5 key
// 0x36 6 key
// 0x37 7 key
// 0x38 8 key
// 0x39 9 key
// Undefined, no constant for 0x3A-0x40
// 0x41 A key
// 0x42 B key
// 0x43 C key
// 0x44 D key
// 0x45 E key
// 0x46 F key
// 0x47 G key
// 0x48 H key
// 0x49 I key
// 0x4A J key
// 0x4B K key
// 0x4C L key
// 0x4D M key
// 0x4E N key
// 0x4F O key
// 0x50 P key
// 0x51 Q key
// 0x52 R key
// 0x53 S key
// 0x54 T key
// 0x55 U key
// 0x56 V key
// 0x57 W key
// 0x58 X key
// 0x59 Y key
// 0x5A Z key

pub const VK_LWIN = 0x5B; // Left Windows key
pub const VK_RWIN = 0x5C; // Right Windows key
pub const VK_APPS = 0x5D; // Applications key
// Reserved, no constant for 0x5E
pub const VK_SLEEP = 0x5F; // Computer Sleep key
pub const VK_NUMPAD0 = 0x60; // Numeric keypad 0 key
pub const VK_NUMPAD1 = 0x61; // Numeric keypad 1 key
pub const VK_NUMPAD2 = 0x62; // Numeric keypad 2 key
pub const VK_NUMPAD3 = 0x63; // Numeric keypad 3 key
pub const VK_NUMPAD4 = 0x64; // Numeric keypad 4 key
pub const VK_NUMPAD5 = 0x65; // Numeric keypad 5 key
pub const VK_NUMPAD6 = 0x66; // Numeric keypad 6 key
pub const VK_NUMPAD7 = 0x67; // Numeric keypad 7 key
pub const VK_NUMPAD8 = 0x68; // Numeric keypad 8 key
pub const VK_NUMPAD9 = 0x69; // Numeric keypad 9 key
pub const VK_MULTIPLY = 0x6A; // Multiply key
pub const VK_ADD = 0x6B; // Add key
pub const VK_SEPARATOR = 0x6C; // Separator key
pub const VK_SUBTRACT = 0x6D; // Subtract key
pub const VK_DECIMAL = 0x6E; // Decimal key
pub const VK_DIVIDE = 0x6F; // Divide key
pub const VK_F1 = 0x70; // F1 key
pub const VK_F2 = 0x71; // F2 key
pub const VK_F3 = 0x72; // F3 key
pub const VK_F4 = 0x73; // F4 key
pub const VK_F5 = 0x74; // F5 key
pub const VK_F6 = 0x75; // F6 key
pub const VK_F7 = 0x76; // F7 key
pub const VK_F8 = 0x77; // F8 key
pub const VK_F9 = 0x78; // F9 key
pub const VK_F10 = 0x79; // F10 key
pub const VK_F11 = 0x7A; // F11 key
pub const VK_F12 = 0x7B; // F12 key
pub const VK_F13 = 0x7C; // F13 key
pub const VK_F14 = 0x7D; // F14 key
pub const VK_F15 = 0x7E; // F15 key
pub const VK_F16 = 0x7F; // F16 key
pub const VK_F17 = 0x80; // F17 key
pub const VK_F18 = 0x81; // F18 key
pub const VK_F19 = 0x82; // F19 key
pub const VK_F20 = 0x83; // F20 key
pub const VK_F21 = 0x84; // F21 key
pub const VK_F22 = 0x85; // F22 key
pub const VK_F23 = 0x86; // F23 key
pub const VK_F24 = 0x87; // F24 key
// Reserved, no constant for 0x88-0x8F
pub const VK_NUMLOCK = 0x90; // NUM LOCK key
pub const VK_SCROLL = 0x91; // SCROLL LOCK key
// OEM specific, no constant for 0x92-0x96
// Unassigned, no constant for 0x97-0x9F
pub const VK_LSHIFT = 0xA0; // Left SHIFT key
pub const VK_RSHIFT = 0xA1; // Right SHIFT key
pub const VK_LCONTROL = 0xA2; // Left CONTROL key
pub const VK_RCONTROL = 0xA3; // Right CONTROL key
pub const VK_LMENU = 0xA4; // Left ALT key
pub const VK_RMENU = 0xA5; // Right ALT key
pub const VK_BROWSER_BACK = 0xA6; // Browser Back key
pub const VK_BROWSER_FORWARD = 0xA7; // Browser Forward key
pub const VK_BROWSER_REFRESH = 0xA8; // Browser Refresh key
pub const VK_BROWSER_STOP = 0xA9; // Browser Stop key
pub const VK_BROWSER_SEARCH = 0xAA; // Browser Search key
pub const VK_BROWSER_FAVORITES = 0xAB; // Browser Favorites key
pub const VK_BROWSER_HOME = 0xAC; // Browser Start and Home key
pub const VK_VOLUME_MUTE = 0xAD; // Volume Mute key
pub const VK_VOLUME_DOWN = 0xAE; // Volume Down key
pub const VK_VOLUME_UP = 0xAF; // Volume Up key
pub const VK_MEDIA_NEXT_TRACK = 0xB0; // Next Track key
pub const VK_MEDIA_PREV_TRACK = 0xB1; // Previous Track key
pub const VK_MEDIA_STOP = 0xB2; // Stop Media key
pub const VK_MEDIA_PLAY_PAUSE = 0xB3; // Play/Pause Media key
pub const VK_LAUNCH_MAIL = 0xB4; // Start Mail key
pub const VK_LAUNCH_MEDIA_SELECT = 0xB5; // Select Media key
pub const VK_LAUNCH_APP1 = 0xB6; // Start Application 1 key
pub const VK_LAUNCH_APP2 = 0xB7; // Start Application 2 key
// Reserved, no constant for 0xB8-0xB9
pub const VK_OEM_1 = 0xBA; // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the ;: key
pub const VK_OEM_PLUS = 0xBB; // For any country/region, the + key
pub const VK_OEM_COMMA = 0xBC; // For any country/region, the , key
pub const VK_OEM_MINUS = 0xBD; // For any country/region, the - key
pub const VK_OEM_PERIOD = 0xBE; // For any country/region, the . key
pub const VK_OEM_2 = 0xBF; // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the /? key
pub const VK_OEM_3 = 0xC0; // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the `~ key
// Reserved, no constant for 0xC1-0xDA
pub const VK_OEM_4 = 0xDB; // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the [{ key
pub const VK_OEM_5 = 0xDC; // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the \| key
pub const VK_OEM_6 = 0xDD; // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the ]} key
pub const VK_OEM_7 = 0xDE; // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the '" key
pub const VK_OEM_8 = 0xDF; // Used for miscellaneous characters; it can vary by keyboard.
// Reserved, no constant for 0xE0
// OEM specific, no constant for 0xE1
pub const VK_OEM_102 = 0xE2; // The <> keys on the US standard keyboard, or the \| key on the non-US 102-key keyboard
// OEM specific, no constant for 0xE3-0xE4
pub const VK_PROCESSKEY = 0xE5; // IME PROCESS key
// OEM specific, no constant for 0xE6
pub const VK_PACKET = 0xE7; // Used to pass Unicode characters as if they were keystrokes.
// Unassigned, no constant for 0xE8
// OEM specific, no constant for 0xE9-0xF5
pub const VK_ATTN = 0xF6; // Attn key
pub const VK_CRSEL = 0xF7; // CrSel key
pub const VK_EXSEL = 0xF8; // ExSel key
pub const VK_EREOF = 0xF9; // Erase EOF key
pub const VK_PLAY = 0xFA; // Play key
pub const VK_ZOOM = 0xFB; // Zoom key
pub const VK_NONAME = 0xFC; // Reserved
pub const VK_PA1 = 0xFD; // PA1 key
pub const VK_OEM_CLEAR = 0xFE; // Clear key
