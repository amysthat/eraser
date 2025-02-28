extends State

@export var player: Player
@export var cursor: Resource
@export var parry_animation_name: String
@export var float_time: float
@export var parry_area: Area2D

@onready var timer := $Timer
@onready var shock_timer := $ShockTimer

func enter():
    player.play_animation(parry_animation_name)
    Cursor.set_cursor_image(cursor)
    
    timer.start()

    detect_enemy()

func exit():
    player.gravity_scale = 1

func _on_timer_timeout():
    transition.emit("movement")

func on_parry():
    timer.stop()
    shock_timer.start()

    player.linear_velocity = Vector2.ZERO
    player.gravity_scale = 0

func _on_shock_timer_timeout():
    player.player_float.enable_float(float_time)
    transition.emit("movement")

func detect_enemy():
    for body in parry_area.get_overlapping_bodies():
        if body is Enemy:
            var enemy = body as Enemy
            var offset = player.global_position - enemy.global_position

            enemy.hit_player(offset)
            on_parry()
