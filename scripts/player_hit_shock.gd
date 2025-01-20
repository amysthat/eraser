extends State

@export var player: Player
@export var player_parry: Node
@export var cursor: Texture2D
@export var hit_texture: Texture2D

@export var hit_force_multiplier: float
@export var physics_material: PhysicsMaterial

@onready var shock_timer: Timer = $ShockTimer
@onready var fly_timer: Timer = $FlyTimer

var normal: Vector2

func enter():
	player.linear_velocity = Vector2.ZERO
	player.gravity_scale = 0
	player.sprite.texture = hit_texture
	Cursor.set_cursor_image(cursor)

	shock_timer.start()

func update(_delta: float):
	if Input.is_action_just_pressed("parry") and not shock_timer.is_stopped():
		shock_timer.stop()
		transition.emit("parry")
		player_parry.on_parry()

func _on_shock_timer_timeout():
	var impulse = -normal * hit_force_multiplier

	player.physics_material_override = physics_material
	player.apply_impulse(impulse)
	player.gravity_scale = 1
	
	fly_timer.start()

func _on_fly_timer_timeout():
	player.physics_material_override = null
	transition.emit("movement")
