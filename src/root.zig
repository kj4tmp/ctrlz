const std = @import("std");
const assert = std.debug.assert;

pub const Task = struct {
    name: []const u8,
    setupFn: *const fn (ctx: *anyopaque, maybe_allocator: ?std.mem.Allocator) error{ OutOfMemory, TaskSetupFailure }!void,
    cycleFn: *const fn (ctx: *anyopaque) void,
    shutdown: *const fn (ctx: *anyopaque) void,
    cycle_time_ns: u64,
    priority: i32,

    first_cycle_start_time: std.time.Instant,

    kill_requested: bool = false,
    thread: std.Thread,

    pub fn run(self: *Task) void {
        assert(self.kill_requested == false);

        while (true) {}
    }

    pub fn kill(self: *Task) void {
        self.kill_requested = true;
        self.thread.join();
    }
};

// given the time of the first cycle and the cycle duration, sleep until the next cycle
pub fn sleepUntilNextCycle(start_time: std.time.Instant, cycle_time_us: u32) void {
    const now = std.time.Instant.now() catch @panic("Timer unsupported.");
    // use modulo to sleep until the next cycle
    const time_to_sleep_ns = @as(u64, cycle_time_us) * std.time.ns_per_us - now.since(start_time) % (@as(u64, cycle_time_us) * std.time.ns_per_us);
    std.Thread.sleep(time_to_sleep_ns);
}

pub const TaskGroup = struct {
    affinity: std.os.linux.cpu_set_t,
    tasks: []const Task,
};

pub fn run(task_groups: []const TaskGroup, allocator: std.mem.Allocator) error{ OutOfMemory, TaskSetupFailure }!void {
    for (task_groups) |task_group| {}
}

test {
    std.testing.refAllDecls(@This());
}
