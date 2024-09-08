const std = @import("std");
const w32 = std.os.windows;
const b = @import("bindings.zig");
const print = std.debug.print;

pub fn wWinMain(instance: w32.HINSTANCE, previousInstance: ?w32.HINSTANCE, commandLine: [*:0]u16, windowSettings: i32) callconv(w32.WINAPI) i32 {
    _ = previousInstance;
    _ = commandLine; // https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-getcommandlinea
    _ = windowSettings; // https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow

    const className = std.unicode.utf8ToUtf16LeStringLiteral("BengtsBullar");

    const windowClass = b.WNDCLASSEXW{
        .style = 0,
        .lpfnWndProc = @ptrCast(@constCast(&mainWindowCallback)),
        .cbClsExtra = 0,
        .cbWndExtra = 0,
        .hInstance = instance,
        .hIcon = null,
        .hCursor = null,
        .hbrBackground = null,
        .lpszMenuName = null,
        .lpszClassName = className,
        .hIconSm = null,
    };

    if (b.RegisterClassExW(&windowClass) == 0) {
        const errorCode = w32.GetLastError();
        print("Error registering class: {d}\n", .{errorCode});
        return 0;
    }

    const windowHandle = b.CreateWindowExW(
        0,
        className,
        className,
        b.WS_WINDOWOVERLAPPED | b.WS_VISIBLE,
        100,
        100,
        800,
        600,
        null,
        null,
        instance,
        null,
    );

    if (windowHandle) |window| {
        while (true) {
            var Message: b.MSG = undefined;
            const MessageResult: w32.BOOL = b.GetMessageW(&Message, null, 0, 0);

            if (MessageResult > 0) {
                _ = b.TranslateMessage(&Message);
                _ = b.DispatchMessageW(&Message);
            } else {
                break;
            }
        }
        _ = window;
    } else {
        const errorCode = w32.GetLastError();
        print("Error registering class: {d}\n", .{errorCode});
    }

    return 0;
}

pub fn mainWindowCallback(window: w32.HWND, message: w32.UINT, wParam: w32.WPARAM, lParam: w32.LPARAM) callconv(w32.WINAPI) w32.LRESULT {
    const result: i64 = 0;

    switch (message) {
        b.WM_SIZE => {
            print("WM_SIZE\n", .{});
        },
        b.WM_DESTROY => {
            print("WM_DESTROY\n", .{});
        },
        b.WM_CLOSE => {
            print("WM_CLOSE\n", .{});
        },
        b.WM_ACTIVATEAPP => {
            print("WM_ACTIVATEAPP\n", .{});
        },
        b.WM_PAINT => {
            // jah
            print("WM_PAINT\n", .{});
        },
        else => {
            return b.DefWindowProcA(window, message, wParam, lParam);
        },
    }

    return result;
}
