extends State

@export var player: Player
@export var cursor: Resource
@export var parry_texture: Texture

@onready var timer: Timer = $Timer

func enter():
	player.linear_velocity = Vector2.ZERO
	player.gravity_scale = 0
	player.sprite.texture = parry_texture
	Cursor.set_cursor_image(cursor)
	
	timer.start()

func exit():
	player.gravity_scale = 1

func _on_timer_timeout():
	transition.emit("movement")
