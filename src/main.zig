const std = @import("std");
const win32 = std.os.windows;
const print = std.debug.print;

extern "user32" fn MessageBoxA(?win32.HWND, [*:0]const u8, [*:0]const u8, u32) callconv(win32.WINAPI) i32;

pub fn wWinMain(hInstance: win32.HINSTANCE, hPrevInstance: ?win32.HINSTANCE, lpCmdLine: [*:0]u16, nCmdShow: i32) callconv(win32.WINAPI) i32 {
    const MB_OK = 0x00000000;
    const MB_ICONINFORMATION = 0x00000040;

    _ = MessageBoxA(null, "Calm down, you are not one of the turtles.", "Malte ftw!", MB_OK | MB_ICONINFORMATION);

    _ = hInstance;
    _ = hPrevInstance;
    _ = lpCmdLine;
    _ = nCmdShow;

    return 0;
}
