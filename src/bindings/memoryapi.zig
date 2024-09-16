const std = @import("std");
const win32 = std.os.windows;

// https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types
const WINAPI = win32.WINAPI;
const LPVOID = win32.LPVOID;
const SIZE_T = win32.SIZE_T;
const DWORD = win32.DWORD;
const BOOL = win32.BOOL;
const HRESULT = win32.LONG;

// allocation type
pub const MEM_COMMIT = 0x00001000;
pub const MEM_RESERVE = 0x00002000;
pub const MEM_RESET = 0x00080000;
pub const MEM_RESET_UNDO = 0x1000000;
pub const MEM_LARGE_PAGES = 0x20000000;
pub const MEM_PHYSICAL = 0x00400000;
pub const MEM_TOP_DOWN = 0x00100000;
pub const MEM_WRITE_WATCH = 0x00200000;

// protect
pub const PAGE_EXECUTE = 0x10;
pub const PAGE_EXECUTE_READ = 0x20;
pub const PAGE_EXECUTE_READWRITE = 0x40;
pub const PAGE_EXECUTE_WRITECOPY = 0x80;
pub const PAGE_NOACCESS = 0x01;
pub const PAGE_READONLY = 0x02;
pub const PAGE_READWRITE = 0x04;
pub const PAGE_WRITECOPY = 0x08;
pub const PAGE_TARGETS_INVALID = 0x40000000;
pub const PAGE_TARGETS_NO_UPDATE = 0x40000000;
pub const PAGE_GUARD = 0x100;
pub const PAGE_NOCACHE = 0x200;
pub const PAGE_WRITECOMBINE = 0x400;

// free type
pub const MEM_DECOMMIT = 0x00004000;
pub const MEM_RELEASE = 0x00008000;
pub const MEM_COALESCE_PLACEHOLDERS = 0x00000001;
pub const MEM_PRESERVE_PLACEHOLDER = 0x00000002;

// https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualalloc
pub extern "kernel32" fn VirtualAlloc(address: ?LPVOID, size: SIZE_T, allocationType: DWORD, protect: DWORD) callconv(WINAPI) LPVOID;

// https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualfree
pub extern "kernel32" fn VirtualFree(address: LPVOID, size: SIZE_T, freeType: DWORD) callconv(WINAPI) BOOL;
