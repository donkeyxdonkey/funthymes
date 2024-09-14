const std = @import("std");
const win32 = std.os.windows;

const WINAPI = win32.WINAPI;

const HDC = win32.HDC;
const BOOL = win32.BOOL;
const DWORD = win32.DWORD;
const WORD = win32.WORD;
const UINT = win32.UINT;
const HANDLE = win32.HANDLE;
const HBITMAP = win32.HANDLE;
const HGDIOBJ = win32.HANDLE;
const LONG = win32.LONG;

// rop - raster operation code
pub const PATCOPY = 0x00F00021; // Copies the specified pattern into the destination bitmap.
pub const PATINVERT = 0x005A0049; // Combines the colors of the specified pattern with the colors of the destination rectangle by using the Boolean XOR operator.
pub const DSTINVERT = 0x00550009; // Inverts the destination rectangle.
pub const BLACKNESS = 0x00000042; // Fills the destination rectangle using the color associated with index 0 in the physical palette. (This color is black for the default physical palette.)
pub const WHITENESS = 0x00FF0062; // Fills the destination rectangle using the color associated with index 1 in the physical palette. (This color is white for the default physical palette.)
pub const SRCCOPY = 13369376;

pub const DIB_RGB_COLORS = 0x00; // The color table contains literal RGB values.
pub const DIB_PAL_COLORS = 0x01; // The color table consists of an array of 16-bit indexes into the LogPalette object (section 2.2.17) that is currently defined in the playback device context.
pub const DIB_PAL_INDICES = 0x02; // No color table exists. The pixels in the DIB are indices into the current logical palette in the playback device context.

// bitmapcompression Compression Enumeration
pub const BI_RGB = 0x0000;
pub const BI_RLE8 = 0x0001;
pub const BI_RLE4 = 0x0002;
pub const BI_BITFIELDS = 0x0003;
pub const BI_JPEG = 0x0004;
pub const BI_PNG = 0x0005;
pub const BI_CMYK = 0x000B;
pub const BI_CMYKRLE8 = 0x000C;
pub const BI_CMYKRLE4 = 0x000D;

pub const BITMAPINFO = extern struct {
    header: BITMAPINFOHEADER,
    colors: [1]RGBQUAD,
};

pub const RGBQUAD = extern struct {
    blue: u8,
    green: u8,
    red: u8,
    reserved: u8,
};

// https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-bitmapinfoheader
pub const BITMAPINFOHEADER = extern struct {
    size: DWORD = @sizeOf(BITMAPINFOHEADER),
    width: i32,
    height: i32,
    planes: WORD,
    bitCount: WORD,
    compression: DWORD,
    sizeImage: DWORD,
    xPelsPerMeter: u32,
    yPelsPerMeter: u32,
    clrUsed: DWORD,
    clrImportant: DWORD,
};

// https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-patblt
// The PatBlt function paints the specified rectangle using the brush that is currently selected into the specified device context.
// The brush color and the surface color or colors are combined by using the specified raster operation.
pub extern "gdi32" fn PatBlt(
    hdc: HDC,
    x: BOOL,
    y: BOOL,
    width: BOOL,
    height: BOOL,
    rop: u32,
) callconv(WINAPI) BOOL;

// https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-createdibsection
pub extern "gdi32" fn CreateDIBSection(hdc: HDC, pbmi: *const BITMAPINFO, usage: UINT, ppvBits: **anyopaque, hSection: ?HANDLE, offset: DWORD) callconv(WINAPI) HBITMAP;

// https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-stretchdibits
pub extern "gdi32" fn StretchDIBits(hdc: HDC, xDest: i32, yDest: i32, DestWidth: i32, DestHeight: i32, xSrc: i32, ySrc: i32, SrcWidth: i32, SrcHeight: i32, lpBits: *anyopaque, lpbmi: *const BITMAPINFO, iUsage: UINT, rop: DWORD) callconv(WINAPI) i32;

// https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-deleteobject
pub extern "gdi32" fn DeleteObject(objectHandle: HGDIOBJ) callconv(WINAPI) BOOL;

// https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-createcompatibledc
pub extern "gdi32" fn CreateCompatibleDC(hdc: ?HDC) callconv(WINAPI) HDC;
