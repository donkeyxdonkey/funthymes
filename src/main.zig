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

var gBuffer: win32OffscreenBuffer = undefined;

const win32OffscreenBuffer = struct {
    info: b.BITMAPINFO,
    memory: *anyopaque,
    width: i32,
    height: i32,
    bytesPerPixel: i32,
};

const win32WindowDimension = struct {
    width: i32,
    height: i32,
};

fn GetWindowDimension(window: HWND) win32WindowDimension {
    var result: win32WindowDimension = undefined;

    var clientRect: RECT = undefined;
    b.GetClientRect(window, &clientRect);
    result.width = clientRect.right - clientRect.left;
    result.height = clientRect.bottom - clientRect.top;

    return result;
}

fn init() void {
    gBuffer.info.header.planes = 1;
    gBuffer.info.header.bitCount = 32;
    gBuffer.info.header.compression = b.BI_RGB;
    gBuffer.info.header.sizeImage = 0;
    gBuffer.info.header.xPelsPerMeter = 0;
    gBuffer.info.header.yPelsPerMeter = 0;
    gBuffer.info.header.clrUsed = 0;
    gBuffer.info.header.clrImportant = 0;
    gBuffer.bytesPerPixel = 4;
}

pub fn wWinMain(instance: HINSTANCE, previousInstance: ?HINSTANCE, commandLine: [*:0]u16, windowSettings: i32) callconv(WINAPI) i32 {
    _ = previousInstance;
    _ = commandLine; // https://learn.microsoft.com/en-us/windows/win32/api/processenv/nf-processenv-getcommandlinea
    _ = windowSettings; // https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow
    init();
    const className = std.unicode.utf8ToUtf16LeStringLiteral("BengtsBullar");

    const windowClass = b.WNDCLASSEXW{
        .style = b.CS_HREDRAW | b.CS_VREDRAW,
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

    const windowHandle = b.CreateWindowExW(0, className, className, b.WS_WINDOWOVERLAPPED | b.WS_VISIBLE, 100, 100, 800, 600, null, null, instance, null);

    if (windowHandle) |window| {
        var xOffset: usize = 0;
        var yOffset: usize = 0;

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

            renderWeirdGradient(gBuffer, xOffset, yOffset);
            const deviceContext: HDC = b.GetDC(window);
            var clientRect: RECT = undefined;
            _ = b.GetClientRect(window, &clientRect);
            const windowWidth = clientRect.right - clientRect.left;
            const windowHeight = clientRect.bottom - clientRect.top;
            updateWindow(gBuffer, deviceContext, clientRect, 0, 0, windowWidth, windowHeight);
            _ = b.ReleaseDC(window, deviceContext);
            xOffset += 1;
            yOffset += 1;
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
            resizeDIBSection(&gBuffer, width, height);
        },
        b.WM_DESTROY => {
            running = false;
        },
        b.WM_CLOSE => {
            running = false;
        },
        b.WM_ACTIVATEAPP => {},
        b.WM_PAINT => {
            var paint: b.PAINTSTRUCT = undefined;
            const deviceContext: HDC = b.BeginPaint(window, &paint);

            const x: i32 = paint.rect.left;
            const y: i32 = paint.rect.top;
            const width: i32 = paint.rect.right - paint.rect.left;
            const height: i32 = paint.rect.bottom - paint.rect.top;

            var clientRect: RECT = undefined;
            _ = b.GetClientRect(window, &clientRect);

            updateWindow(gBuffer, deviceContext, clientRect, x, y, width, height);
            _ = b.ReleaseDC(window, deviceContext);
        },
        else => {
            return b.DefWindowProcA(window, message, wParam, lParam);
        },
    }

    return result;
}

fn resizeDIBSection(buffer: *win32OffscreenBuffer, width: i32, height: i32) void {
    if (buffer.*.memory != undefined) {
        _ = b.VirtualFree(buffer.*.memory, 0, b.MEM_RELEASE);
    }

    buffer.*.width = width;
    buffer.*.height = height;

    buffer.*.info.header.size = @sizeOf(b.BITMAPINFOHEADER);
    buffer.*.info.header.width = buffer.*.width;
    buffer.*.info.header.height = -buffer.*.height;

    const bitmapMemorySize: usize = @as(usize, (@intCast((buffer.*.width * buffer.*.height) * buffer.*.bytesPerPixel)));
    buffer.*.memory = b.VirtualAlloc(null, bitmapMemorySize, b.MEM_COMMIT, b.PAGE_READWRITE);
    renderWeirdGradient(buffer.*, 100, 0);
}

fn renderWeirdGradient(buffer: win32OffscreenBuffer, xOffset: usize, yOffset: usize) void {
    const pitch: usize = @as(usize, @intCast(buffer.width * buffer.bytesPerPixel));
    var row: *u8 = @as(*u8, @ptrCast(buffer.memory));

    const w: usize = @as(usize, @intCast(buffer.height));
    const h: usize = @as(usize, @intCast(buffer.width));

    //const start = std.time.nanoTimestamp();

    for (0..w) |y| {
        var pixel: *u32 = @as(*u32, @ptrCast(@alignCast(row)));
        for (0..h) |x| {
            const blue: u8 = @truncate(x + xOffset);
            const green: u8 = @truncate(y + yOffset);

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

fn updateWindow(buffer: win32OffscreenBuffer, deviceContext: HDC, windowRect: RECT, x: i32, y: i32, width: i32, height: i32) void {
    _ = x;
    _ = y;
    _ = width;
    _ = height;

    const windowWidth = windowRect.right - windowRect.left;
    const windowHeight = windowRect.bottom - windowRect.top;

    //print("{any}\n", .{buffer.info});

    _ = b.StretchDIBits(deviceContext, 0, 0, windowWidth, windowHeight, 0, 0, buffer.width, buffer.height, buffer.memory, &buffer.info, b.DIB_RGB_COLORS, b.SRCCOPY);
}
