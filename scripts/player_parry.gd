extends State

@export var player: Player
@export var cursor: Resource
@export var parry_texture: Texture
@export var float_time: float

@onready var timer := $Timer
@onready var shock_timer := $ShockTimer

func enter():
	player.linear_velocity = Vector2.ZERO
	player.gravity_scale = 0
	player.sprite.texture = parry_texture
	Cursor.set_cursor_image(cursor)
	
	timer.start()
	player.is_parrying = true

func exit():
	player.gravity_scale = 1
	player.is_parrying = false

func _on_timer_timeout():
	transition.emit("movement")

func on_parry():
	timer.stop()
	shock_timer.start()

func _on_shock_timer_timeout():
	player.player_float.enable_float(float_time)
	transition.emit("movement")
