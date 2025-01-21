extends Node2D

@onready var font := ThemeDB.fallback_font

var counted_frames: int
var displayed_fps: int

var title: String

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS
    
    z_index = 999

    title = ProjectSettings.get_setting("application/config/name")

    if OS.is_debug_build():
        title += " (DEBUG)"

    var frame_timer = Timer.new()
    add_child(frame_timer)
    frame_timer.timeout.connect(_on_frame_timer_timeout)
    frame_timer.start()

func _process(_delta):
    counted_frames += 1

func _on_frame_timer_timeout():
    displayed_fps = counted_frames
    counted_frames = 0

    DisplayServer.window_set_title("%s | FPS: %s" % [title, displayed_fps])
