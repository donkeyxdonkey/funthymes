const std = @import("std");
const win32 = std.os.windows;

const WINAPI = win32.WINAPI;

const ATOM = win32.ATOM;
const HDC = win32.HDC;
const BOOL = win32.BOOL;
const RECT = win32.RECT;
const HWND = win32.HWND;
const UINT = win32.UINT;
const WPARAM = win32.WPARAM;
const LPARAM = win32.LPARAM;
const DWORD = win32.DWORD;
const POINT = win32.POINT;
const HINSTANCE = win32.HINSTANCE;
const PROC = win32.PROC;
const HANDLE = win32.HANDLE;
const LRESULT = win32.LRESULT;
const HMENU = win32.HMENU;
const LPVOID = win32.LPVOID;

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
    deviceContextHandle: HDC, // A handle to the display DC to be used for painting.
    eraseBackground: BOOL, // Indicates whether the background must be erased. This value is nonzero if the application should erase the background. The application is responsible for erasing the background if a window class is created without a background brush. For more information, see the description of the hbrBackground member of the WNDCLASS structure.
    rect: RECT, // A RECT structure that specifies the upper left and lower right corners of the rectangle in which the painting is requested, in device units relative to the upper-left corner of the client area.
    fRestore: BOOL, // Reserved; used internally by the system.
    fIncUpdate: BOOL, // Reserved; used internally by the system.
    rgbReserved: [32]u8, // Reserved; used internally by the system.
};

// https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-msg
pub const MSG = extern struct {
    handle: ?HWND, // A handle to the window whose window procedure receives the message. This member is NULL when the message is a thread message.
    message: UINT, // The message identifier. Applications can only use the low word; the high word is reserved by the system.
    wParam: WPARAM, // Additional information about the message. The exact meaning depends on the value of the message member.
    lParam: LPARAM, // Additional information about the message. The exact meaning depends on the value of the message member.
    time: DWORD, // The time at which the message was posted.
    cursorPosition: POINT, // The cursor position, in screen coordinates, when the message was posted.
    lPrivate: DWORD,
};

pub const WNDCLASSEXW = extern struct {
    cbSize: UINT = @sizeOf(WNDCLASSEXW),
    style: UINT,
    lpfnWndProc: PROC,
    cbClsExtra: i32 = 0,
    cbWndExtra: i32 = 0,
    hInstance: HINSTANCE,
    hIcon: ?HANDLE,
    hCursor: ?HANDLE,
    hbrBackground: ?HANDLE,
    lpszMenuName: ?[*:0]const u16,
    lpszClassName: [*:0]const u16,
    hIconSm: ?HANDLE,
};

pub extern "user32" fn BeginPaint(
    hWnd: HWND,
    lpPaint: *PAINTSTRUCT,
) callconv(WINAPI) HDC;

pub extern "user32" fn GetMessageW(lpMsg: *MSG, hWnd: ?HWND, wMsgFilterMin: UINT, wMsgFilterMax: UINT) callconv(WINAPI) BOOL;

pub extern "user32" fn TranslateMessage(lpMsg: *const MSG) callconv(WINAPI) BOOL;

pub extern "user32" fn DispatchMessageW(lpMsg: *const MSG) callconv(WINAPI) LRESULT;

pub extern "user32" fn DefWindowProcA(hWnd: HWND, Msg: UINT, wParam: WPARAM, lParam: LPARAM) LRESULT;

pub extern "user32" fn CreateWindowExW(dwExStyle: DWORD, lpClassName: [*:0]const u16, lpWindowName: [*:0]const u16, dwStyle: DWORD, X: i32, Y: i32, nWidth: i32, nHeight: i32, hWindParent: ?HWND, hMenu: ?HMENU, hInstance: HINSTANCE, lpParam: ?LPVOID) callconv(WINAPI) ?HWND;

pub extern "user32" fn RegisterClassExW(*const WNDCLASSEXW) callconv(WINAPI) ATOM;
