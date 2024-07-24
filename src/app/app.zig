const std = @import("std");
const print = std.debug.print;
const tools = @import("../utils/tools.zig");
const cmd = @import("../utils/commands.zig").cmd;
const Cli = @import("../main.zig").Cli;
const checkDevices = @import("../utils/devices.zig").checkDevices;
const style = @import("../utils/style.zig").Style;

const CoinsData = struct {
    rank: i64,
    code: []const u8,
    name: []const u8,
    price: f64,
};

pub fn app(cli: Cli) !void {
    _ = cli;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var body = std.ArrayList(u8).init(allocator);
    defer body.deinit();

    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    _ = client.fetch(.{
        .location = .{ .url = "https://http-api.livecoinwatch.com/coins?offset=0&limit=10&sort=rank&order=ascending&currency=USD" },
        .response_storage = .{ .dynamic = &body },
    }) catch {
        print("{s}\nError: unable to fetch the latest top coins. Try again later please.\n{s}", .{ style.Red, style.Reset });

        return std.process.exit(0);
    };

    const parsed = try std.json.parseFromSlice(std.json.Value, allocator, body.items, .{});
    defer parsed.deinit();

    const response_json = parsed.value.object;
    const data = response_json.get("data").?;
    const data_items = data.array.items;

    var top_coins = CoinsData{
        .rank = undefined,
        .code = undefined,
        .name = undefined,
        .price = undefined,
    };

    for (data_items) |crypto| {
        const coin = crypto.object;
        const rank = coin.get("rank").?.integer;
        const code = coin.get("code").?.string;
        const name = coin.get("name").?.string;
        const price = coin.get("price").?.float;

        top_coins = .{ .rank = rank, .code = code, .name = name, .price = price };
        print("{s}{d}. {s}{s} - {s}{s} - {s}{d:.2}${s}\n", .{ style.Magenta, top_coins.rank, style.Cyan, top_coins.code, style.Yellow, top_coins.name, style.Green, top_coins.price, style.Reset });
    }
}
