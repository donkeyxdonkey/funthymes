const std = @import("std");
const bindings = struct {
    pub usingnamespace @import("bindings/wingdi.zig");
    pub usingnamespace @import("bindings/winuser.zig");
    pub usingnamespace @import("bindings/memoryapi.zig");
    pub usingnamespace @import("bindings/heapapi.zig");
};

const b = bindings;
const print = std.debug.print;

const win32 = std.os.windows;
const WINAPI = win32.WINAPI;
const HINSTANCE = win32.HINSTANCE;
const BOOL = win32.BOOL;
const HWND = win32.HWND;
const UINT = win32.UINT;
const WPARAM = win32.WPARAM;
const LPARAM = win32.LPARAM;
const LRESULT = win32.LRESULT;
const HDC = win32.HDC;
const RECT = win32.RECT;
const HBITMAP = win32.HANDLE;

var running: bool = false;
var bitMapHandle: ?HBITMAP = null;
var bitmapDeviceContext: HDC = undefined;
var bitmapMemory: *anyopaque = undefined;
var bitmapInfo: b.BITMAPINFO = undefined;

fn init() void {
    bitmapInfo.header.planes = 1;
    bitmapInfo.header.bitCount = 32;
    bitmapInfo.header.compression = b.BI_RGB;
    bitmapInfo.header.sizeImage = 0;
    bitmapInfo.header.xPelsPerMeter = 0;
    bitmapInfo.header.yPelsPerMeter = 0;
    bitmapInfo.header.clrUsed = 0;
    bitmapInfo.header.clrImportant = 0;
}

pub fn wWinMain(instance: HINSTANCE, previousInstance: ?HINSTANCE, commandLine: [*:0]u16, windowSettings: i32) callconv(WINAPI) i32 {
    _ = previousInstance;
    _ = commandLine; // https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-getcommandlinea
    _ = windowSettings; // https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow
    init();
    const className = std.unicode.utf8ToUtf16LeStringLiteral("BengtsBullar");

    const windowClass = b.WNDCLASSEXW{
        .style = 0,
        .lpfnWndProc = @ptrCast(@constCast(&mainWindowCallback)),
        .allocExtraBytesStruct = 0,
        .allocExtraBytesWindow = 0,
        .instance = instance,
        .icon = null,
        .cursor = null,
        .handleBackground = null,
        .menuName = null,
        .className = className,
        .handleIcon = null,
    };

    if (b.RegisterClassExW(&windowClass) == 0) {
        const errorCode = win32.GetLastError();
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
        running = true;

        while (running) {
            var Message: b.MSG = undefined;
            const MessageResult: BOOL = b.GetMessageW(&Message, null, 0, 0);

            if (MessageResult > 0) {
                _ = b.TranslateMessage(&Message);
                _ = b.DispatchMessageW(&Message);
            } else {
                running = false;
            }
        }
        _ = window;
    } else {
        const errorCode = win32.GetLastError();
        print("Error registering class: {d}\n", .{errorCode});
    }

    return 0;
}

pub fn mainWindowCallback(window: HWND, message: UINT, wParam: WPARAM, lParam: LPARAM) callconv(WINAPI) LRESULT {
    const result: i64 = 0;

    switch (message) {
        b.WM_SIZE => {
            var clientRect: RECT = undefined;
            _ = b.GetClientRect(window, &clientRect);
            const width: i32 = clientRect.right - clientRect.left;
            const height: i32 = clientRect.bottom - clientRect.top;
            resizeDIBSection(width, height);
            print("WM_SIZE\n", .{});
        },
        b.WM_DESTROY => {
            running = false;
        },
        b.WM_CLOSE => {
            running = false;
        },
        b.WM_ACTIVATEAPP => {
            print("WM_ACTIVATEAPP\n", .{});
        },
        b.WM_PAINT => {
            var paint: b.PAINTSTRUCT = undefined;
            const deviceContext: HDC = b.BeginPaint(window, &paint);

            const x: i32 = paint.rect.left;
            const y: i32 = paint.rect.top;
            const width: i32 = paint.rect.right - paint.rect.left;
            const height: i32 = paint.rect.bottom - paint.rect.top;

            updateWindow(deviceContext, x, y, width, height);

            _ = b.PatBlt(deviceContext, x, y, width, height, b.WHITENESS);
            print("WM_PAINT\n", .{});
        },
        else => {
            return b.DefWindowProcA(window, message, wParam, lParam);
        },
    }

    return result;
}

fn resizeDIBSection(width: i32, height: i32) void {
    bitmapInfo.header.width = width;
    bitmapInfo.header.height = height;
    bitmapInfo.header.planes = 1;
    bitmapInfo.header.bitCount = 32;
    bitmapInfo.header.compression = b.BI_RGB;

    const bytesPerPixel = 4;
    const bitmapMemorySize = (width * height) * bytesPerPixel;
}

fn updateWindow(deviceContext: HDC, x: i32, y: i32, width: i32, height: i32) void {
    _ = b.StretchDIBits(deviceContext, x, y, width, height, x, y, width, height, bitmapMemory, &bitmapInfo, b.DIB_RGB_COLORS, b.SRCCOPY);
}
