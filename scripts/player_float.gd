extends Node2D

@export var player_movement: Node
@export var down_force: float

@onready var player := $".."
@onready var progress_bar: Sprite2D = $Sprite2D
@onready var timer := $Timer

var is_floating: bool
var float_time: float

func _process(_delta):
	progress_bar.visible = is_floating

	if is_floating:
		progress_bar.region_rect.size.x = timer.time_left * 2
		progress_bar.position.x = (float_time - timer.time_left) * 2 / -2

func _physics_process(_delta):
	if not is_floating:
		return
	
	if player_movement.is_on_floor():
		disable_float()
	
	player.linear_velocity.y = down_force

func enable_float(time: float):
	float_time = time
	is_floating = true
	player_movement.dash_allowed = true
	timer.start(time)

func disable_float():
	is_floating = false
	timer.stop()

func _on_timer_timeout():
	is_floating = false

func get_gravity_scale():
	return 0 if is_floating else 1
