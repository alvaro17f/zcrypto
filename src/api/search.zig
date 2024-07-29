const std = @import("std");
const style = @import("../utils/style.zig").Style;
const http = @import("../utils/http.zig");

const CoinsData = struct {
    symbol: []const u8,
    name: []const u8,
};

pub fn search(query: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const URL = try std.fmt.allocPrint(allocator, "https://api.coingecko.com/api/v3/search?query={s}", .{query});

    var response = std.ArrayList(u8).init(allocator);
    defer response.deinit();

    _ = http.fetch(&response, std.http.Method.GET, URL) catch {
        std.debug.print("{s}\nError: unable to fetch. Try again later please.\n{s}", .{ style.Red, style.Reset });

        return std.process.exit(0);
    };

    const parsed = try std.json.parseFromSlice(std.json.Value, allocator, response.items, .{});
    defer parsed.deinit();

    const response_json = parsed.value.object;
    const coins = response_json.get("coins").?;
    const coins_items = coins.array.items;

    for (coins_items) |crypto| {
        const coin = crypto.object;
        const symbol = coin.get("symbol").?.string;
        const name = coin.get("name").?.string;

        const search_results = CoinsData{
            .symbol = symbol,
            .name = name,
        };

        std.debug.print("{s}{s} - {s}{s}\n{s}", .{
            style.Magenta,
            search_results.symbol,
            style.Cyan,
            search_results.name,
            style.Reset,
        });
    }
}
