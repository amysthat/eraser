extends State

@export var player: Player
@export var cursor: Resource
@export var charge_texture: Texture

const total_dash_time := 0.5
const disable_length := 1

var dash_vector: Vector2
var dash_time: float

var target_positon: Vector2

func enter():
	Cursor.set_cursor_image(cursor)
	player.sprite.texture = charge_texture
	
	dash_time = 0
	target_positon = player.global_position + dash_vector * total_dash_time / 2

func update(_delta):
	if dash_time >= total_dash_time:
		transition.emit("movement")
	
	if (player.global_position - target_positon).length() <= disable_length:
		transition.emit("movement")
	
	if Input.is_action_just_pressed("parry"):
		transition.emit("parry")

func physics_update(delta):
	dash_time += delta
	player.velocity = lerp(dash_vector, Vector2.ZERO, dash_time / total_dash_time)
