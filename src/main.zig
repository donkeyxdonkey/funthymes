const std = @import("std");
const w32 = std.os.windows;
const b = @import("bindings.zig");
const print = std.debug.print;

pub fn wWinMain(instance: w32.HINSTANCE, hPrevInstance: ?w32.HINSTANCE, lpCmdLine: [*:0]u16, nCmdShow: i32) callconv(w32.WINAPI) i32 {
    _ = hPrevInstance;
    _ = lpCmdLine;
    _ = nCmdShow;

    const className = std.unicode.utf8ToUtf16LeStringLiteral("BengtsBullar");

    const w = b.WNDCLASSEXW{
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

    const cid = b.RegisterClassExW(&w);

    if (cid == 0) {
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
    const WM_SIZE = 0x0005;
    const WM_DESTROY = 0x0002;
    const WM_CLOSE = 0x0010;
    const WM_ACTIVATEAPP = 0x001C;

    const result: i64 = 0;

    switch (message) {
        WM_SIZE => {
            print("WM_SIZE\n", .{});
        },
        WM_DESTROY => {
            print("WM_DESTROY\n", .{});
        },
        WM_CLOSE => {
            print("WM_CLOSE\n", .{});
        },
        WM_ACTIVATEAPP => {
            print("WM_ACTIVATEAPP\n", .{});
        },
        else => {
            return b.DefWindowProcA(window, message, wParam, lParam);
        },
    }

    return result;
}
