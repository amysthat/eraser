extends State

@export var plane: PlaneBody
@export var texture: Texture2D
@export var speed: float

var normal_texture: Texture2D
var start_point: Node2D

func enter():
    normal_texture = plane.sprite.texture

    plane.set_state_indicator(null)
    plane.sprite.texture = texture
    plane.collision.set_deferred("disabled", true)

    start_point = plane.get_closest_patrol_point()

func physics_update(_delta: float):
    var difference = start_point.global_position - plane.global_position

    if difference.length() <= 1:
        transition.emit("patrol")
    
    plane.velocity = difference.normalized() * speed

func exit():
    plane.sprite.texture = normal_texture
    plane.collision.set_deferred("disabled", false)
