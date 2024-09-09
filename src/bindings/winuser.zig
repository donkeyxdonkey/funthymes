const std = @import("std");
const win32 = std.os.windows;

pub const CS_CLASSDC = 0x0040;
pub const CS_HREDRAW = 0x0002;
pub const CS_VREDRAW = 0x0001;

pub const WS_OVERLAPPED = 0x00000000;
pub const WS_CAPTION = 0x00C00000;
pub const WS_SYSMENU = 0x00080000;
pub const WS_THICKFRAME = 0x00040000;
pub const WS_MINIMIZEBOX = 0x00020000;
pub const WS_MAXIMIZEBOX = 0x00010000;

pub const WS_WINDOWOVERLAPPED = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;
pub const WS_VISIBLE = 0x10000000;

pub const WM_SIZE = 0x0005;
pub const WM_DESTROY = 0x0002;
pub const WM_PAINT = 0x000F;
pub const WM_CLOSE = 0x0010;
pub const WM_ACTIVATEAPP = 0x001C;

// https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-paintstruct
pub const PAINTSTRUCT = extern struct {
    deviceContextHandle: win32.HDC, // A handle to the display DC to be used for painting.
    fErase: win32.BOOL, // Indicates whether the background must be erased. This value is nonzero if the application should erase the background. The application is responsible for erasing the background if a window class is created without a background brush. For more information, see the description of the hbrBackground member of the WNDCLASS structure.
    rect: win32.RECT, // A RECT structure that specifies the upper left and lower right corners of the rectangle in which the painting is requested, in device units relative to the upper-left corner of the client area.
    fRestore: win32.BOOL, // Reserved; used internally by the system.
    fIncUpdate: win32.BOOL, // Reserved; used internally by the system.
    rgbReserved: [32]u8, // Reserved; used internally by the system.
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

pub extern "user32" fn BeginPaint(
    hWnd: win32.HWND,
    lpPaint: *PAINTSTRUCT,
) callconv(win32.WINAPI) win32.HDC;

pub extern "user32" fn GetMessageW(lpMsg: *MSG, hWnd: ?win32.HWND, wMsgFilterMin: win32.UINT, wMsgFilterMax: win32.UINT) callconv(win32.WINAPI) win32.BOOL;

pub extern "user32" fn TranslateMessage(lpMsg: *const MSG) callconv(win32.WINAPI) win32.BOOL;

pub extern "user32" fn DispatchMessageW(lpMsg: *const MSG) callconv(win32.WINAPI) win32.LRESULT;

pub extern "user32" fn DefWindowProcA(hWnd: win32.HWND, Msg: win32.UINT, wParam: win32.WPARAM, lParam: win32.LPARAM) win32.LRESULT;

pub extern "user32" fn CreateWindowExW(dwExStyle: win32.DWORD, lpClassName: [*:0]const u16, lpWindowName: [*:0]const u16, dwStyle: win32.DWORD, X: i32, Y: i32, nWidth: i32, nHeight: i32, hWindParent: ?win32.HWND, hMenu: ?win32.HMENU, hInstance: win32.HINSTANCE, lpParam: ?win32.LPVOID) callconv(win32.WINAPI) ?win32.HWND;

pub extern "user32" fn RegisterClassExW(*const WNDCLASSEXW) callconv(win32.WINAPI) win32.ATOM;
