const std = @import("std");
const print = std.debug.print;
const tools = @import("../utils/tools.zig");
const cmd = @import("../utils/commands.zig").cmd;
const Cli = @import("../main.zig").Cli;
const checkDevices = @import("../utils/devices.zig").checkDevices;
const style = @import("../utils/style.zig").Style;
const api = @import("../api/index.zig");

pub fn app(cli: Cli) !void {
    try api.topCoins(cli.limit);
}
