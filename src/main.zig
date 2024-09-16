const std = @import("std");
const bindings = struct {
    pub usingnamespace @import("bindings/wingdi.zig");
    pub usingnamespace @import("bindings/winuser.zig");
    pub usingnamespace @import("bindings/memoryapi.zig");
    pub usingnamespace @import("bindings/heapapi.zig");
    pub usingnamespace @import("bindings/errhandlingapi.zig");
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
const HRESULT = win32.LONG;

var running: bool = false;
var bitMapHandle: ?HBITMAP = null;
var bitmapDeviceContext: HDC = undefined;
var bitmapMemory: *anyopaque = undefined;
var bitmapInfo: b.BITMAPINFO = undefined;

var bitmapWidth: i32 = 0;
var bitmapHeight: i32 = 0;

const bytesPerPixel = 4;

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

    const windowClass = b.WNDCLASSEXW{ .style = 0, .lpfnWndProc = @ptrCast(@constCast(&mainWindowCallback)), .allocExtraBytesStruct = 0, .allocExtraBytesWindow = 0, .instance = instance, .icon = null, .cursor = null, .handleBackground = null, .menuName = null, .className = className, .handleIcon = null };

    if (b.RegisterClassExW(&windowClass) == 0) {
        const errorCode = win32.GetLastError();
        print("Error registering class: {d}\n", .{errorCode});
        return 0;
    }

    const windowHandle = b.CreateWindowExW(0, className, className, b.WS_WINDOWOVERLAPPED | b.WS_VISIBLE, 100, 100, 800, 600, null, null, instance, null);

    if (windowHandle) |window| {
        var xOffset: usize = 0;
        const yOffset: usize = 0;

        running = true;

        while (running) {
            var Message: b.MSG = undefined;

            while (b.PeekMessageW(&Message, null, 0, 0, b.PM_REMOVE) != 0) {
                if (Message.message == b.WM_QUIT) {
                    running = false;
                }
                _ = b.TranslateMessage(&Message);
                _ = b.DispatchMessageW(&Message);
            }

            renderWeirdGradient(xOffset, yOffset);
            const deviceContext: HDC = b.GetDC(window);
            var clientRect: RECT = undefined;
            _ = b.GetClientRect(window, &clientRect);
            const windowWidth = clientRect.right - clientRect.left;
            const windowHeight = clientRect.bottom - clientRect.top;
            updateWindow(deviceContext, &clientRect, 0, 0, windowWidth, windowHeight);
            _ = b.ReleaseDC(window, deviceContext);
            xOffset += 1;
        }
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
            //print("WM_SIZE\n", .{});
        },
        b.WM_DESTROY => {
            running = false;
        },
        b.WM_CLOSE => {
            running = false;
        },
        b.WM_ACTIVATEAPP => {
            //print("WM_ACTIVATEAPP\n", .{});
        },
        b.WM_PAINT => {
            var paint: b.PAINTSTRUCT = undefined;
            const deviceContext: HDC = b.BeginPaint(window, &paint);

            const x: i32 = paint.rect.left;
            const y: i32 = paint.rect.top;
            const width: i32 = paint.rect.right - paint.rect.left;
            const height: i32 = paint.rect.bottom - paint.rect.top;

            var clientRect: RECT = undefined;
            _ = b.GetClientRect(window, &clientRect);

            updateWindow(deviceContext, &clientRect, x, y, width, height);
            _ = b.ReleaseDC(window, deviceContext);
        },
        else => {
            return b.DefWindowProcA(window, message, wParam, lParam);
        },
    }

    return result;
}

fn resizeDIBSection(width: i32, height: i32) void {
    if (bitmapMemory != undefined) {
        _ = b.VirtualFree(bitmapMemory, 0, b.MEM_RELEASE);
    }

    bitmapWidth = width;
    bitmapHeight = height;

    bitmapInfo.header.size = @sizeOf(b.BITMAPINFOHEADER);
    bitmapInfo.header.width = bitmapWidth;
    bitmapInfo.header.height = -bitmapHeight;

    const bitmapMemorySize: usize = @as(usize, (@intCast((bitmapWidth * bitmapHeight) * bytesPerPixel)));
    bitmapMemory = b.VirtualAlloc(null, bitmapMemorySize, b.MEM_COMMIT, b.PAGE_READWRITE);
    renderWeirdGradient(100, 0);
}

fn renderWeirdGradient(xOffset: usize, yOffset: usize) void {
    const pitch: usize = @as(usize, @intCast(bitmapWidth * bytesPerPixel));
    var row: *u8 = @as(*u8, @ptrCast(bitmapMemory));

    const w: usize = @as(usize, @intCast(bitmapHeight));
    const h: usize = @as(usize, @intCast(bitmapWidth));

    //const start = std.time.nanoTimestamp();

    for (0..w) |y| {
        var pixel: *u32 = @as(*u32, @ptrCast(@alignCast(row)));
        for (0..h) |x| {
            const blue: u8 = @truncate(x + xOffset);
            const green: u8 = @truncate(y + yOffset);

            // från dox - "b must be comptime-known or have a type with log2 number of bits as a."
            //             så det fina med kråksången är logaritmen måste lira för aritmetikens skull
            //             kort och gott i fallet lär allt vara u32
            pixel.* = (@as(u32, @intCast(green)) << 8) | @as(u32, @intCast(blue));
            pixel = @ptrFromInt(@intFromPtr(pixel) + @sizeOf(u32));

            // annan variant av bit-skift men inte lika snabb
            //pixel.* = @as(u8, @intCast(x & 0xFF));
        }
        row = @ptrFromInt(@intFromPtr(row) + pitch);
    }

    //const end = std.time.nanoTimestamp();
    //std.debug.print("{d} ns\n", .{end - start});
}

fn updateWindow(deviceContext: HDC, windowRect: *RECT, x: i32, y: i32, width: i32, height: i32) void {
    _ = x;
    _ = y;
    _ = width;
    _ = height;

    const windowWidth = windowRect.*.right - windowRect.*.left;
    const windowHeight = windowRect.*.bottom - windowRect.*.top;

    //print("{any}\n", .{bitmapInfo});

    _ = b.StretchDIBits(deviceContext, 0, 0, windowWidth, windowHeight, 0, 0, bitmapWidth, bitmapHeight, bitmapMemory, &bitmapInfo, b.DIB_RGB_COLORS, b.SRCCOPY);
}
