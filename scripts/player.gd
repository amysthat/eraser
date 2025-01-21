extends RigidBody2D
class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var player_float := $Float

var is_parrying: bool

func _process(_delta):
    if linear_velocity.x < 0 and not animated_sprite.flip_h:
        animated_sprite.flip_h = true
    elif linear_velocity.x > 0 and animated_sprite.flip_h:
        animated_sprite.flip_h = false

func play_animation(animation_name: String):
    animated_sprite.play(animation_name)

func on_hit_by_canon_ball(normal: Vector2):
    if not is_parrying:
        $StateMachine/hit_shock.normal = normal
        state_machine.transition_state("hit_shock")
    else:
        $StateMachine/parry.on_parry()
