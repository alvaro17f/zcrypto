const std = @import("std");
const tools = @import("tools.zig");
const style = @import("style.zig").Style;

const DeviceCheckResult = struct {
    found_devices: [][]const u8,
    missing_devices: [][]const u8,
};

pub fn checkDevices(allocator: std.mem.Allocator, devices: [][]const u8) !DeviceCheckResult {
    var found_devices = std.ArrayList([]const u8).init(allocator);
    var missing_devices = std.ArrayList([]const u8).init(allocator);

    for (devices) |device| {
        const device_path_exit_code = tools.runCmd(false, try std.fmt.allocPrint(allocator, "lsblk -o LABEL | grep -w {s}", .{device}));
        if (try device_path_exit_code == 0) {
            try found_devices.append(device);
        } else {
            try missing_devices.append(device);
        }
    }

    return .{ .found_devices = found_devices.items, .missing_devices = missing_devices.items };
}
