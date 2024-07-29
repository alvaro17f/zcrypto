const std = @import("std");
const style = @import("style.zig").Style;

pub fn fetch(response: *std.ArrayListAligned(u8, null), method: std.http.Method, url: []const u8) !std.http.Client.FetchResult {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const uri = std.Uri.parse(url) catch unreachable;

    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    const fetch_result = client.fetch(.{
        .method = method,
        .location = .{ .uri = uri },
        .response_storage = .{ .dynamic = response },
    }) catch {
        return error.FetchFailed;
    };

    return fetch_result;
}
