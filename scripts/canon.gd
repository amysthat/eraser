@tool
extends StaticBody2D
class_name Canon

@export var aim: float
@export var base_rotation: float

@onready var base := $Base
@onready var barrel := $Barrel
@onready var canon_hole := $Barrel/CanonHole
@onready var canon_ball_scene := preload("res://canon_ball.tscn")

func _process(_delta):
    barrel.rotation_degrees = aim
    base.rotation_degrees = base_rotation

    if Engine.is_editor_hint():
        queue_redraw()
        return

func _draw():
    if not Engine.is_editor_hint():
        return

    var aim_rad = deg_to_rad(aim) + PI
    var aim_vector = Vector2(cos(aim_rad), sin(aim_rad))
    aim_vector *= 290
    
    draw_line(Vector2.ZERO, aim_vector, Color.RED)

func _timer_timeout():
    shoot_canon_ball()

func shoot_canon_ball():
    var instance = canon_ball_scene.instantiate() as Node2D
    instance.global_position = canon_hole.global_position
    instance.global_rotation = canon_hole.global_rotation

    get_tree().current_scene.add_child(instance)