extends State

@export var plane: PlaneBody
@export var texture: Texture2D
@export var speed: float

@onready var timer := $Timer

var normal_texture: Texture2D
var allow_end: bool

func enter():
    normal_texture = plane.sprite.texture

    plane.set_state_indicator(null)
    plane.sprite.texture = texture
    plane.collision.set_deferred("disabled", true)

    allow_end = false
    timer.start()

func physics_update(delta: float):
    var difference = plane.path_follow.global_position - plane.global_position
    var reached_target = difference.length() <= 1

    if reached_target and allow_end:
        transition.emit("patrol")
    
    if not reached_target:
        plane.velocity = difference.normalized() * speed
    else:
        plane.velocity = lerp(plane.velocity, Vector2.ZERO, 5 * delta)

func exit():
    plane.sprite.texture = normal_texture
    plane.collision.set_deferred("disabled", false)

func _on_timer_timeout():
    allow_end = true
