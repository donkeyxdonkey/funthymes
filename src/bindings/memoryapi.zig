const std = @import("std");
const win32 = std.os.windows;

// https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
const WINAPI = win32.WINAPI;
const LPVOID = win32.LPVOID;

pub extern "kernel32" fn VirtualAlloc() callconv(WINAPI) LPVOID;

LPVOID VirtualAlloc(
  [in, optional] LPVOID lpAddress,
  [in]           SIZE_T dwSize,
  [in]           DWORD  flAllocationType,
  [in]           DWORD  flProtect
);