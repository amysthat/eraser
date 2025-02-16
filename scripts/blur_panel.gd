extends Panel

@export var target_lod: float
@export var speed: float

var current_lod: float

func _process(delta):
    visible = current_lod != 0.0

    var lod = target_lod if Game.is_paused else 0.0
    current_lod = lerp(current_lod, lod, speed * delta)

    material.set_shader_parameter("lod", current_lod)

    if get_viewport().get_camera_2d() != null:
        global_position = get_viewport().get_camera_2d().get_screen_center_position() - Vector2(160, 90)
