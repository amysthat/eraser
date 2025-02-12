extends State

@export var player: Player
@export var animation_name: String
@export var cursor: Texture2D
@export var full_dash_time: float
@export var up_force: float

@onready var timer := $Timer

func enter():
    player.play_animation(animation_name)
    Cursor.set_cursor_image(cursor)
    player.player_float.disable_float()

func _on_dash_cast(dash_vector: Vector2):
    transition.emit("dash")
    player.apply_impulse(dash_vector)

    timer.start(full_dash_time)

func _on_timer_timeout():
    player.linear_velocity.y = -up_force
    transition.emit("movement")
