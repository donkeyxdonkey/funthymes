const std = @import("std");
const win32 = std.os.windows;

const WINAPI = win32.WINAPI;

// https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
const ATOM = win32.ATOM;
const HDC = win32.HDC;
const BOOL = win32.BOOL;
const RECT = win32.RECT;
const HWND = win32.HWND;
const UINT = win32.UINT;
const WPARAM = win32.WPARAM;
const LPARAM = win32.LPARAM;
const BYTE = win32.BYTE;
const WORD = win32.WORD;
const DWORD = win32.DWORD;
const POINT = win32.POINT;
const HINSTANCE = win32.HINSTANCE;
const PROC = win32.PROC;
const HANDLE = win32.HANDLE;
const LRESULT = win32.LRESULT;
const HMENU = win32.HMENU;
const LPVOID = win32.LPVOID;
const SHORT = win32.SHORT;

pub const XINPUT_GAMEPAD_DPAD_UP = 0x0001;
pub const XINPUT_GAMEPAD_DPAD_DOWN = 0x0002;
pub const XINPUT_GAMEPAD_DPAD_LEFT = 0x0004;
pub const XINPUT_GAMEPAD_DPAD_RIGHT = 0x0008;
pub const XINPUT_GAMEPAD_START = 0x0010;
pub const XINPUT_GAMEPAD_BACK = 0x0020;
pub const XINPUT_GAMEPAD_LEFT_THUMB = 0x0040;
pub const XINPUT_GAMEPAD_RIGHT_THUMB = 0x0080;
pub const XINPUT_GAMEPAD_LEFT_SHOULDER = 0x0100;
pub const XINPUT_GAMEPAD_RIGHT_SHOULDER = 0x0200;
pub const XINPUT_GAMEPAD_A = 0x1000;
pub const XINPUT_GAMEPAD_B = 0x2000;
pub const XINPUT_GAMEPAD_X = 0x4000;
pub const XINPUT_GAMEPAD_Y = 0x8000;

// https://learn.microsoft.com/en-us/windows/win32/api/xinput/ns-xinput-xinput_state
pub const XINPUT_STATE = extern struct {
    packetNumber: DWORD,
    gamepad: XINPUT_GAMEPAD,
};

// https://learn.microsoft.com/en-us/windows/win32/api/xinput/ns-xinput-xinput_gamepad
pub const XINPUT_GAMEPAD = extern struct {
    buttons: WORD,
    lefTrigger: BYTE,
    rightTrigger: BYTE,
    thumbLX: SHORT,
    thumbLY: SHORT,
    thumbRX: SHORT,
    thumbRY: SHORT,
};

// https://learn.microsoft.com/en-us/windows/win32/api/xinput/nf-xinput-xinputgetstate
pub extern "Xinput1_4" fn XInputGetState(userIndex: DWORD, state: [*c]XINPUT_STATE) callconv(WINAPI) DWORD;
