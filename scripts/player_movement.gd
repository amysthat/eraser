extends State

@export_category("State")
@export var player: Player
@export var dash_available_cursor: Texture
@export var dash_unavailable_cursor: Texture
@export var normal_texture: Texture

@export_category("Movement")
@export var move_force: float = 200.0
@export var air_multiplier: float = 0.4
@export var jump_impulse: float = 500.0
@export var max_speed: float = 200.0
@export var ground_ray: RayCast2D

@export_category("Dash")
@export var dash_min_time: float

var dash_time: float

var dash_allowed := true

func enter():
	player.sprite.texture = normal_texture

func update(delta: float):
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
	
	dash_time -= delta

func physics_update(_delta: float):
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	var movement_force = move_force

	if not is_on_floor():
		movement_force *= air_multiplier

	if abs(player.linear_velocity.x) < max_speed:
		player.apply_force(Vector2(direction * movement_force, 0))

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		player.apply_impulse(Vector2(0, -jump_impulse))

	if player.linear_velocity.y > max_speed:
		player.linear_velocity.y = max_speed
	
	if is_on_floor():
		player.linear_damp = 0

		if dash_time <= 0:
			dash_allowed = true
	else:
		player.linear_damp = 3

		if player.linear_velocity.y > 0:
			player.apply_force(Vector2(0, 200))

func is_on_floor() -> bool:
	return ground_ray.is_colliding()
