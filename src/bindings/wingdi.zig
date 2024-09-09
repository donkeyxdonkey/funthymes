const std = @import("std");
const win32 = std.os.windows;

// rop - raster operation code
pub const PATCOPY = 0x00F00021; // Copies the specified pattern into the destination bitmap.
pub const PATINVERT = 0x005A0049; // Combines the colors of the specified pattern with the colors of the destination rectangle by using the Boolean XOR operator.
pub const DSTINVERT = 0x00550009; // Inverts the destination rectangle.
pub const BLACKNESS = 0x00000042; // Fills the destination rectangle using the color associated with index 0 in the physical palette. (This color is black for the default physical palette.)
pub const WHITENESS = 0x00FF0062; // Fills the destination rectangle using the color associated with index 1 in the physical palette. (This color is white for the default physical palette.)

// https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-patblt
// The PatBlt function paints the specified rectangle using the brush that is currently selected into the specified device context.
// The brush color and the surface color or colors are combined by using the specified raster operation.
pub extern "gdi32" fn PatBlt(
    hdc: win32.HDC,
    x: win32.BOOL,
    y: win32.BOOL,
    w: win32.BOOL,
    h: win32.BOOL,
    rop: win32.DWORD,
) win32.BOOL;
