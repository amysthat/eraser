extends State

signal dash_cast(dash_vector: Vector2)

@export var player: Player
@export var cursor: Resource
@export var charge_texture: Texture
@export var dash_arrow_origin: Node2D
@export var full_charge_time: float
@export var max_charge_speed: float

var charge_time: float
var dash_rotation_rad: float

func enter():
	player.linear_velocity = Vector2.ZERO
	player.gravity_scale = 0
	Cursor.set_cursor_image(cursor)
	player.sprite.texture = charge_texture
	
	dash_arrow_origin.visible = true
	
	charge_time = 0

func exit():
	player.gravity_scale = 1
	dash_arrow_origin.visible = false

func update(_delta: float):
	charge_time += _delta
	
	var difference_vector = player.global_position - player.get_global_mouse_position()
	dash_rotation_rad = atan2(difference_vector.y, difference_vector.x) + PI
	dash_arrow_origin.rotation = dash_rotation_rad
	
	if Input.is_action_just_released("dash_charge") or charge_time >= full_charge_time:
		if charge_time <= full_charge_time / 5.0:
			transition.emit("movement")
			return
		
		dash()

func dash():
	var dash_multiplier = charge_time / full_charge_time
	var dash_vector = Vector2(max_charge_speed * cos(dash_rotation_rad), max_charge_speed * sin(dash_rotation_rad))
	dash_vector *= dash_multiplier
	
	player.apply_impulse(dash_vector)

	dash_cast.emit()

	transition.emit("movement")
