extends State

@export var plane: PlaneBody
@export var status_texture: Texture2D
@export var speed: float

func enter():
    plane.set_state_indicator(status_texture)
    plane.collision.set_deferred("disabled", true)

func physics_update(_delta: float):
    var difference = plane.path_follow.global_position - plane.global_position

    if difference.length() <= 1:
        transition.emit("patrol")
    
    plane.velocity = difference.normalized() * speed

func exit():
    plane.set_state_indicator(null)
    plane.collision.set_deferred("disabled", false)
