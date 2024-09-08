const std = @import("std");
const win32 = std.os.windows;
const print = std.debug.print;

pub const WNDCLASSEXW = extern struct {
    cbSize: win32.UINT = @sizeOf(WNDCLASSEXW),
    style: win32.UINT,
    lpfnWndProc: win32.PROC,
    cbClsExtra: i32 = 0,
    cbWndExtra: i32 = 0,
    hInstance: win32.HINSTANCE,
    hIcon: ?win32.HANDLE,
    hCursor: ?win32.HANDLE,
    hbrBackground: ?win32.HANDLE,
    lpszMenuName: ?[*:0]const u16,
    lpszClassName: [*:0]const u16,
    hIconSm: ?win32.HANDLE,
};

pub const MSG = extern struct {
    hWnd: ?win32.HWND,
    message: win32.UINT,
    wParam: win32.WPARAM,
    lParam: win32.LPARAM,
    time: win32.DWORD,
    pt: win32.POINT,
    lPrivate: win32.DWORD,
};

pub extern "user32" fn GetMessageW(lpMsg: *MSG, hWnd: ?win32.HWND, wMsgFilterMin: win32.UINT, wMsgFilterMax: win32.UINT) callconv(win32.WINAPI) win32.BOOL;

pub extern "user32" fn TranslateMessage(lpMsg: *const MSG) callconv(win32.WINAPI) win32.BOOL;

pub extern "user32" fn DispatchMessageW(lpMsg: *const MSG) callconv(win32.WINAPI) win32.LRESULT;

pub extern "user32" fn DefWindowProcA(hWnd: win32.HWND, Msg: win32.UINT, wParam: win32.WPARAM, lParam: win32.LPARAM) win32.LRESULT;

pub extern "user32" fn CreateWindowExW(dwExStyle: win32.DWORD, lpClassName: [*:0]const u16, lpWindowName: [*:0]const u16, dwStyle: win32.DWORD, X: i32, Y: i32, nWidth: i32, nHeight: i32, hWindParent: ?win32.HWND, hMenu: ?win32.HMENU, hInstance: win32.HINSTANCE, lpParam: ?win32.LPVOID) callconv(win32.WINAPI) ?win32.HWND;

pub extern "user32" fn RegisterClassExW(*const WNDCLASSEXW) callconv(win32.WINAPI) win32.ATOM;

pub fn wWinMain(instance: win32.HINSTANCE, hPrevInstance: ?win32.HINSTANCE, lpCmdLine: [*:0]u16, nCmdShow: i32) callconv(win32.WINAPI) i32 {
    _ = hPrevInstance;
    _ = lpCmdLine;
    _ = nCmdShow;

    //const CS_CLASSDC = 0x0040;
    //const CS_HREDRAW = 0x0002;
    //const CS_VREDRAW = 0x0001;

    const className = std.unicode.utf8ToUtf16LeStringLiteral("BengtsBullar");

    const w = WNDCLASSEXW{
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

    const cid = RegisterClassExW(&w);

    if (cid != 0) {
        const WS_OVERLAPPED = 0x00000000;
        const WS_CAPTION = 0x00C00000;
        const WS_SYSMENU = 0x00080000;
        const WS_THICKFRAME = 0x00040000;
        const WS_MINIMIZEBOX = 0x00020000;
        const WS_MAXIMIZEBOX = 0x00010000;

        const WS_WINDOWOVERLAPPED = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;
        const WS_VISIBLE = 0x10000000;

        const windowHandle = CreateWindowExW(
            0,
            className,
            className,
            WS_WINDOWOVERLAPPED | WS_VISIBLE,
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
                var Message: MSG = undefined;
                const MessageResult: win32.BOOL = GetMessageW(&Message, null, 0, 0);

                if (MessageResult > 0) {
                    _ = TranslateMessage(&Message);
                    _ = DispatchMessageW(&Message);
                } else {
                    break;
                }
            }
            _ = window;
        } else {
            const errorCode = win32.GetLastError();
            print("Error registering class: {d}\n", .{errorCode});
        }
    } else {
        const errorCode = win32.GetLastError();
        print("Error registering class: {d}\n", .{errorCode});
    }

    return 0;
}

pub fn mainWindowCallback(window: win32.HWND, message: win32.UINT, wParam: win32.WPARAM, lParam: win32.LPARAM) callconv(win32.WINAPI) win32.LRESULT {
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
            return DefWindowProcA(window, message, wParam, lParam);
        },
    }

    return result;
}
