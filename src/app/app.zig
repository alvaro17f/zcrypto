const Cli = @import("../main.zig").Cli;
const api = @import("../api/index.zig");

pub fn app(cli: Cli) !void {
    try api.topCoins(cli.limit);
}
