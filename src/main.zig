const std = @import("std");

const util = @import("brucelib.util");

const platform = @import("brucelib.platform").using(.{
    .Profiler = util.ZtracyProfiler,
});

const graphics = @import("brucelib.graphics").using(.{
    .Profiler = util.ZtracyProfiler,
});

const audio = @import("brucelib.audio");

pub fn main() anyerror!void {
    try platform.run(.{
        .title = "new-project",
        .window_size = .{
            .width = 854,
            .height = 480,
        },
        .init_fn = init,
        .deinit_fn = deinit,
        .frame_fn = frame,
        .audio_playback = .{
            .callback = audioPlayback,
        },
    });
}

var audio_mixer: audio.Mixer = undefined;
var debug_gui_state: graphics.DebugGUI.State = .{};

fn init(allocator: std.mem.Allocator) !void {
    try graphics.init(allocator, platform);

    audio_mixer = audio.Mixer.init();
}

fn deinit(_: std.mem.Allocator) void {
    graphics.deinit();
}

fn frame(input: platform.FrameInput) !bool {
    if (input.quit_requested) {
        return false;
    }

    var draw_list = try graphics.beginDrawing(input.frame_arena_allocator);

    try graphics.setViewport(
        &draw_list,
        .{
            .x = 0,
            .y = 0,
            .width = input.window_size.width,
            .height = input.window_size.height,
        },
    );

    try graphics.clearViewport(&draw_list, graphics.Colour.orange);

    try graphics.setProjectionTransform(
        &draw_list,
        graphics.orthographic(
            @intToFloat(f32, input.window_size.width),
            @intToFloat(f32, input.window_size.height),
            0,
            1,
        ),
    );

    try graphics.setViewTransform(&draw_list, graphics.identityMatrix());

    try debugOverlay(input, &draw_list);

    try graphics.submitDrawList(&draw_list);

    return true;
}

fn audioPlayback(stream: platform.AudioPlaybackStream) !u32 {
    const num_frames = std.math.min(800, stream.max_frames);
    audio_mixer.mix(num_frames, stream.channels, stream.sample_rate, stream.sample_buf);
    return num_frames;
}

fn debugOverlay(input: platform.FrameInput, draw_list: *graphics.DrawList) !void {
    var debug_gui = try graphics.DebugGUI.begin(
        input.frame_arena_allocator,
        draw_list,
        @intToFloat(f32, input.window_size.width),
        @intToFloat(f32, input.window_size.height),
        &debug_gui_state,
    );

    try debug_gui.label(
        "{d:.2} ms update",
        .{@intToFloat(f32, input.debug_stats.prev_cpu_frame_elapsed) / 1e6},
    );

    const prev_frame_time_ms = @intToFloat(f32, input.prev_frame_elapsed) / 1e6;
    try debug_gui.label(
        "{d:.2} ms frame, {d:.0} FPS",
        .{ prev_frame_time_ms, 1e3 / prev_frame_time_ms },
    );

    try debug_gui.end();
}
