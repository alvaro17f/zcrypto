const std = @import("std");
const style = @import("../utils/style.zig").Style;
const http = @import("../utils/http.zig");
const parser = @import("../utils/parser.zig");

const TopCoins = struct {
    rank: i64,
    code: []const u8,
    name: []const u8,
    price: f64,
};

const TopCoinsData = struct {
    data: []TopCoins,
};

pub fn topCoins(limit: u32) !void {
    if (limit == 0) {
        return std.debug.print("{s}Error: Limit must be greater than 0\n{s}", .{ style.Red, style.Reset });
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const URL = try std.fmt.allocPrint(allocator, "https://http-api.livecoinwatch.com/coins?offset=0&limit={d}&sort=rank&order=ascending&currency=USD", .{limit});

    var response = std.ArrayList(u8).init(allocator);
    defer response.deinit();

    _ = http.fetch(&response, std.http.Method.GET, URL) catch {
        std.debug.print("{s}\nError: unable to fetch the latest top coins. Try again later please.\n{s}", .{ style.Red, style.Reset });

        return std.process.exit(0);
    };

    const value = try parser.json(allocator, TopCoinsData, response.items);

    for (value.data) |crypto| {
        const rank = crypto.rank;
        const code = crypto.code;
        const name = crypto.name;
        const price = crypto.price;

        std.debug.print("{s}{d}. {s}{s} - {s}{s} - {s}{d:.2}${s}\n", .{ style.Magenta, rank, style.Cyan, code, style.Yellow, name, style.Green, price, style.Reset });
    }
}
