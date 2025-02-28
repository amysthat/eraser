extends State

@export var player: Player
@export var player_collision: CollisionShape2D
@export var player_parry: Node
@export var cursor: Texture2D
@export var hit_animation_name: String

@export var hit_force_multiplier: float
@export var physics_material: PhysicsMaterial

@onready var shock_timer: Timer = $ShockTimer
@onready var fly_timer: Timer = $FlyTimer

var normal: Vector2
var has_shock_ended: bool

func enter():
	player.player_float.disable_float()

	player.linear_velocity = Vector2.ZERO
	player.gravity_scale = 0
	player_collision.disabled = true
	player.play_animation(hit_animation_name)
	Cursor.set_cursor_image(cursor)

	player.global_position -= normal * 0.6
	has_shock_ended = false

	shock_timer.start()

func exit():
	player_collision.disabled = false
	player.physics_material_override = null

func update(_delta: float):
	if Input.is_action_just_pressed("parry") and not shock_timer.is_stopped():
		shock_timer.stop()
		transition.emit("parry")
	
	if not has_shock_ended:
		player.linear_velocity = Vector2.ZERO

func _on_shock_timer_timeout():
	var impulse = - normal * hit_force_multiplier

	player.physics_material_override = physics_material
	player.apply_impulse(impulse)
	player.gravity_scale = 1
	player_collision.disabled = false

	has_shock_ended = true
	
	fly_timer.start()

func _on_fly_timer_timeout():
	player.physics_material_override = null
	transition.emit("movement")
