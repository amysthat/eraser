@tool
extends Marker2D

@export var player: Player
@export var max_y: float

func _process(_delta):
    if Engine.is_editor_hint():
        queue_redraw()
        return

    if player.global_position.y > max_y:
        player.global_position = global_position

func _draw():
    if not Engine.is_editor_hint():
        return
    
    draw_line(Vector2(-500 - global_position.x, max_y - global_position.y), Vector2(500 - global_position.x, max_y - global_position.y), Color.RED)