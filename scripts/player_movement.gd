extends State

@export_category("State")
@export var player: Player
@export var dash_available_cursor: Texture2D
@export var dash_unavailable_cursor: Texture2D

@export_category("Movement")
@export var move_force: float = 200.0
@export var air_multiplier: float = 0.4
@export var jump_impulse: float = 500.0
@export var max_speed: float = 200.0
@export var ground_rays: Array[RayCast2D]

@export_category("Time")
@export var jump_input_time: float
@export var cayote_time: float

@export_category("Dash")
@export var dash_min_time: float

@export_category("Animation")
@export var idle_animation_name: String
@export var run_animation_name: String
@export var jump_animation_name: String
@export var fall_animation_name: String

var dash_time: float
var jump_requested: float
var last_grounded: float

var dash_allowed := true

func update(delta: float):
	handle_animations()
	
	if dash_allowed:
		Cursor.set_cursor_image(dash_available_cursor)
	else:
		Cursor.set_cursor_image(dash_unavailable_cursor)
	
	if Input.is_action_just_pressed("parry"):
		transition.emit("parry")
		
	if Input.is_action_pressed("dash_charge") and dash_allowed:
		dash_allowed = false
		dash_time = dash_min_time
		transition.emit("dash_charge")
	
	if Input.is_action_just_pressed("jump"):
		jump_requested = jump_input_time

	dash_time -= delta
	jump_requested -= delta
	last_grounded += delta

func _physics_process(_delta):
	if is_on_floor():
		player.linear_damp = 0
	else:
		player.linear_damp = 3

func physics_update(_delta: float):
	player.gravity_scale = player.player_float.get_gravity_scale()

	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	var movement_force = move_force

	if not is_on_floor():
		movement_force *= air_multiplier

	if is_on_floor():
		last_grounded = 0

	if abs(player.linear_velocity.x) < max_speed:
		player.apply_force(Vector2(direction * movement_force, 0))

	if player.linear_velocity.y > max_speed:
		player.linear_velocity.y = max_speed
	
	if is_on_floor():
		if dash_time <= 0:
			dash_allowed = true
	else:
		if player.linear_velocity.y > 0:
			player.apply_force(Vector2(0, 200))

	if last_grounded <= cayote_time and jump_requested > 0.0:
		player.linear_velocity.y = 0

		player.apply_impulse(Vector2(0, -jump_impulse))
		jump_requested = 0
		last_grounded = 5

func handle_animations():
	var is_y_still = abs(player.linear_velocity.y) < 1

	if is_y_still:
		var is_moving = abs(player.linear_velocity.x) > 10

		if is_moving:
			player.play_animation(run_animation_name)
		else:
			player.play_animation(idle_animation_name)
	else:
		var is_going_up = player.linear_velocity.y < 0

		if is_going_up:
			player.play_animation(jump_animation_name)
		else:
			player.play_animation(fall_animation_name)

func is_on_floor() -> bool:
	for ray in ground_rays:
		if ray.is_colliding():
			return true
	
	return false
