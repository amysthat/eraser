extends RigidBody2D
class_name Player

@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var player_float := $Float

var is_parrying: bool

func _process(_delta):
	if linear_velocity.x < 0 and not sprite.flip_h:
		sprite.flip_h = true
	elif linear_velocity.x > 0 and sprite.flip_h:
		sprite.flip_h = false

func on_hit_by_canon_ball(normal: Vector2):
	if not is_parrying:
		$StateMachine/hit_shock.normal = normal
		state_machine.transition_state("hit_shock")
	else:
		$StateMachine/parry.on_parry()