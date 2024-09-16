const std = @import("std");
const win32 = std.os.windows;

const WINAPI = win32.WINAPI;
const LPVOID = win32.LPVOID;
const SIZE_T = win32.SIZE_T;
const DWORD = win32.DWORD;
const BOOL = win32.BOOL;

//https://learn.microsoft.com/en-us/windows/win32/api/errhandlingapi/nf-errhandlingapi-getlasterror
pub extern fn GetLastError() callconv(WINAPI) DWORD;
