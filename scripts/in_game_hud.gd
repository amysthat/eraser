extends SubViewportContainer

@onready var canvas_layer := $SubViewport/CanvasLayer
@onready var content := $Content

func _ready():
    scale = Vector2.ONE / 6.0
    content.reparent(canvas_layer)

func _process(_delta):
    if get_viewport().get_camera_2d() != null:
        global_position = get_viewport().get_camera_2d().get_screen_center_position() - Vector2(160, 90)
