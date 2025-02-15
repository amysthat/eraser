extends RigidBody2D
class_name Player

static var instance

@export var invulnerabilty_time: float

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var player_float := $Float

var is_parrying: bool
var invulnerable_time: float

func _enter_tree():
    instance = self

func _process(delta):
    if linear_velocity.x < 0 and not animated_sprite.flip_h:
        animated_sprite.flip_h = true
    elif linear_velocity.x > 0 and animated_sprite.flip_h:
        animated_sprite.flip_h = false
    
    invulnerable_time -= delta

func play_animation(animation_name: String):
    animated_sprite.play(animation_name)

func on_hit(normal: Vector2, force_parry: bool = false):
    var is_invulnerable = invulnerable_time > 0
    if is_invulnerable:
        return

    invulnerable_time = invulnerabilty_time

    if is_parrying or force_parry:
        state_machine.transition_state("parry")
        $StateMachine/parry.on_parry()
    else:
        $StateMachine/hit_shock.normal = normal
        state_machine.transition_state("hit_shock")

func is_hit() -> bool:
    return state_machine.current_state.name == "hit_shock"