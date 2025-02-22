@tool
extends Node2D

@export var height: float

func _process(_delta):
    if Engine.is_editor_hint():
        queue_redraw()
        return

    var localized_player_position = Player.instance.global_position - global_position

    for child in get_children():
        var kid = child as Node2D
        kid.position = Vector2(0, clamp(localized_player_position.y, - height / 2, height / 2))

func _draw():
    if not Engine.is_editor_hint():
        return

    var vector_size = Vector2.UP * height

    draw_line(- vector_size / 2, vector_size / 2, Color.RED)
