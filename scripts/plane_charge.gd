extends State

@export var plane: PlaneBody
@export var status_texture: Texture2D
@export var speed: float

var angle: float

func enter():
    plane.set_state_indicator(status_texture)
    plane.velocity = Vector2.ZERO

    angle = (Player.instance.global_position - plane.global_position).angle()

func physics_update(_delta: float):
    plane.velocity = Vector2.from_angle(angle).normalized() * speed

func exit():
    print("exiting.")
    plane.set_state_indicator(null)
    plane.velocity = Vector2.ZERO
