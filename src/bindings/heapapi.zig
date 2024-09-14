const std = @import("std");
const win32 = std.os.windows;

// https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
const WINAPI = win32.WINAPI;
const LPVOID = win32.LPVOID;
const SIZE_T = win32.SIZE_T;
const DWORD = win32.DWORD;
const HANDLE = win32.HANDLE;

// https://learn.microsoft.com/en-us/windows/win32/api/heapapi/nf-heapapi-heapalloc
pub extern "kernel32" fn HeapAlloc(heapHandle: HANDLE, flags: DWORD, bytes: SIZE_T) callconv(WINAPI) LPVOID;
