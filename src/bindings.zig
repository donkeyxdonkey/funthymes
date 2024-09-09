const std = @import("std");
const win32 = std.os.windows;

pub const bindings = extern struct {
    pub usingnamespace @import("bindings/wingdi.zig");
    pub usingnamespace @import("bindings/winuser.zig");
};
