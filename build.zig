const std = @import("std");

const brucelib = @import("brucelib/build.zig");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();
    
    const ztracy_enable = b.option(bool, "ztracy-enable", "Enable Tracy profiler markers") orelse false;
    const ztracy_options = brucelib.util.ztracy.BuildOptionsStep.init(b, .{ .enable_ztracy = ztracy_enable });

    const exe = b.addExecutable("new-project", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    exe.addPackage(brucelib.platform.pkg);
    exe.addPackage(brucelib.graphics.pkg);
    exe.addPackage(brucelib.audio.pkg);
    exe.addPackage(brucelib.algo.pkg);
    exe.addPackage(brucelib.util.getPkg(ztracy_options));
    
    brucelib.platform.link(exe);    
    brucelib.graphics.link(exe);
    brucelib.util.link(exe, ztracy_options);

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest("src/main.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}
