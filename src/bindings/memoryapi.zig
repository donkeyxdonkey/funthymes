const std = @import("std");
const win32 = std.os.windows;

// https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
const WINAPI = win32.WINAPI;
const LPVOID = win32.LPVOID;
const SIZE_T = win32.SIZE_T;
const DWORD = win32.DWORD;

// https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualalloc
pub extern "kernel32" fn VirtualAlloc(address: LPVOID, size: SIZE_T, allocationType: DWORD, protect: DWORD) callconv(WINAPI) LPVOID;
