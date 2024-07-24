const std = @import("std");
const app = @import("app/app.zig").app;
const eql = std.mem.eql;
const style = @import("utils/style.zig").Style;

const version = "0.1.0";

pub const Cli = struct {
    search: []const u8,
};

fn printHelp() void {
    std.debug.print(
        \\
        \\ ***************************************************
        \\ ZCRYPTO - A tool to watch crypto coin prices
        \\ ***************************************************
        \\ -s : coin to search
        \\ -h, help : Display this help message
        \\ -v, version : Display the current version
        \\
        \\
    , .{});
}

fn printVersion() void {
    std.debug.print("{s}\nZCRYPTO version: {s}{s}\n{s}", .{ style.Black, style.Cyan, version, style.Reset });
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var cli = Cli{ .search = undefined };

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len <= 1) {
        return try app(cli);
    }

    for (args[1..], 0..) |arg, idx| {
        if (arg[0] == '-') {
            for (arg[1..]) |flag| {
                switch (flag) {
                    'h' => {
                        return printHelp();
                    },
                    'v' => {
                        return printVersion();
                    },
                    's' => {
                        if (idx + 2 >= args.len) {
                            return std.debug.print("{s}Error: \"-{c}\" flag requires an argument\n{s}", .{ style.Red, flag, style.Reset });
                        }
                        if (flag == 's') cli.search = args[idx + 2];
                    },
                    else => return std.debug.print("{s}Error: Unknown flag \"-{c}\"\n{s}", .{ style.Red, flag, style.Reset }),
                }
            }
        } else if (idx == 0) {
            for (args[1..]) |argument| {
                if (eql(u8, argument, "help")) {
                    return printHelp();
                }
                if (eql(u8, argument, "version")) {
                    return printVersion();
                }
                if (eql(u8, argument, "search")) {
                    cli.search = args[idx + 2];
                }

                return std.debug.print("{s}Error: Unknown argument \"{s}\"\n{s}", .{ style.Red, argument, style.Reset });
            }
        }
    }

    return try app(cli);
}
