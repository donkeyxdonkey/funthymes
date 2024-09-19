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

pub const XINPUT_STATE = extern struct {
    packetNumber: DWORD,
    gamepad: XINPUT_GAMEPAD,
};

pub const XINPUT_GAMEPAD = extern struct {
    buttons: WORD,
    lefTrigger: BYTE,
    rightTrigger: BYTE,
    thumbLX: SHORT,
    thumbLY: SHORT,
    thumbRX: SHORT,
    thumbRY: SHORT,
};

pub extern "Xinput1_4" fn XInputGetState(userIndex: DWORD, state: *XINPUT_STATE) callconv(WINAPI) DWORD;
