extends RigidBody2D
class_name Player

static var instance

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var player_float := $Float

var is_parrying: bool

func _ready():
    instance = self

func _process(_delta):
    if linear_velocity.x < 0 and not animated_sprite.flip_h:
        animated_sprite.flip_h = true
    elif linear_velocity.x > 0 and animated_sprite.flip_h:
        animated_sprite.flip_h = false

func play_animation(animation_name: String):
    animated_sprite.play(animation_name)

func on_hit(normal: Vector2, force_parry: bool = false):
    if is_parrying or force_parry:
        state_machine.transition_state("parry")
        $StateMachine/parry.on_parry()
    else:
        $StateMachine/hit_shock.normal = normal
        state_machine.transition_state("hit_shock")
