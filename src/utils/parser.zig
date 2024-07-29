const std = @import("std");

pub fn json(allocator: std.mem.Allocator, comptime json_type: type, json_data: []const u8) !json_type {
    const parsed = try std.json.parseFromSlice(json_type, allocator, json_data, .{ .ignore_unknown_fields = true });
    defer parsed.deinit();

    return parsed.value;
}
