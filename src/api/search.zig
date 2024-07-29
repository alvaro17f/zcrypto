const std = @import("std");
const style = @import("../utils/style.zig").Style;
const http = @import("../utils/http.zig");
const parser = @import("../utils/parser.zig");

const Search = struct {
    symbol: []const u8,
    name: []const u8,
};

const SearchData = struct {
    coins: []Search,
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

    const value = try parser.json(allocator, SearchData, response.items);

    for (value.coins) |crypto| {
        const symbol = crypto.symbol;
        const name = crypto.name;

        std.debug.print("{s}{s} - {s}{s}\n{s}", .{
            style.Magenta,
            symbol,
            style.Cyan,
            name,
            style.Reset,
        });
    }
}
