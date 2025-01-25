extends State

@export var plane: PlaneBody
@export var status_texture: Texture2D
@export var speed: float

var return_point: Vector2

func enter():
    plane.set_state_indicator(status_texture)

func physics_update(_delta: float):
    var difference = return_point - plane.global_position

    if difference.length() <= 1 or plane.get_slide_collision_count() > 0:
        transition.emit("patrol")
    
    plane.velocity = difference.normalized() * speed

func exit():
    plane.set_state_indicator(null)

func set_return_point_to_current_position():
    return_point = plane.global_position
