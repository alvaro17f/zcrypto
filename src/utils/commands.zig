const std = @import("std");
const style = @import("style.zig").Style;

pub const cmd = struct {
    pub fn configPrint(devices: [][]const u8, path: []const u8) void {
        std.debug.print(
            \\ {s}◉{s} devices{s} = {s}{s}{s}
            \\ {s}◉{s} path{s} = {s}{s}{s}
            \\
            \\
        , .{ style.Black, style.Red, style.Reset, style.Cyan, devices, style.Reset, style.Black, style.Red, style.Reset, style.Cyan, path, style.Reset });
    }

    pub fn gitPullCmd(allocator: std.mem.Allocator, repo: []const u8) ![]const u8 {
        return std.fmt.allocPrint(allocator, "git -C {s} pull", .{repo});
    }

    pub fn gitDiffCmd(allocator: std.mem.Allocator, repo: []const u8) ![]const u8 {
        return std.fmt.allocPrint(allocator, "git -C {s} diff --exit-code", .{repo});
    }

    pub fn gitStatusCmd(allocator: std.mem.Allocator, repo: []const u8) ![]const u8 {
        return std.fmt.allocPrint(allocator, "git -C {s} status --porcelain", .{repo});
    }

    pub fn gitAddCmd(allocator: std.mem.Allocator, repo: []const u8) ![]const u8 {
        return std.fmt.allocPrint(allocator, "git -C {s} add .", .{repo});
    }

    pub fn nixUpdateCmd(allocator: std.mem.Allocator, repo: []const u8) ![]const u8 {
        return std.fmt.allocPrint(allocator, "cd {s} && nix flake update", .{repo});
    }

    pub fn nixRebuildCmd(allocator: std.mem.Allocator, repo: []const u8, hostname: []const u8) ![]const u8 {
        return std.fmt.allocPrint(allocator, "sudo nixos-rebuild switch --flake {s}#{s} --show-trace", .{ repo, hostname });
    }

    pub fn nixKeepCmd(allocator: std.mem.Allocator, generations_to_keep: u8) ![]const u8 {
        return std.fmt.allocPrint(allocator, "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +{d}", .{generations_to_keep});
    }

    pub const nixDiffCmd = "nix profile diff-closures --profile /nix/var/nix/profiles/system | tac | awk '/Version/{print; exit} 1' | tac";
};
