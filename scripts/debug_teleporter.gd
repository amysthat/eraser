class_name DebugTeleporter extends Marker2D

func _process(_delta):
    if Input.is_action_just_pressed("debug_teleport"):
        Player.instance.global_position = global_position
