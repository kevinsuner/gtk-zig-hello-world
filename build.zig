const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "hello-world",
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);
    exe.linkLibC();
    exe.linkSystemLibrary("gtk4");
    exe.addCSourceFile(.{
        .file = std.Build.LazyPath.relative("main.c"),
        .flags = &.{},
    });

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
