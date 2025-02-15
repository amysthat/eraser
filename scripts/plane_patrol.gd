extends State

signal set_return_patrol_point

@export var plane: PlaneBody
@export var status_texture: Texture2D
@export var speed: float
@export var detect_time: float

var detect_charge_time: float

func enter():
    var is_on_path = plane.global_position.distance_to(plane.path_follow.global_position) <= 1

    if not is_on_path:
        transition.emit("return_to_patrol")
        return
    
    plane.set_state_indicator(status_texture)
    plane.velocity = Vector2.ZERO

func update(delta: float):
    plane.path_follow.progress += speed * delta
    var is_to_the_right = plane.global_position.x < plane.path_follow.global_position.x
    plane.global_position = plane.path_follow.global_position

    plane.sprite.flip_h = is_to_the_right

    if plane.player_raycast.is_colliding() and plane.player_raycast.get_collider() == Player.instance and not Player.instance.is_hit():
        detect_charge_time += delta
    else:
        detect_charge_time = max(0, detect_charge_time - delta)

    if detect_charge_time >= detect_time:
        detect_charge_time = 0

        set_return_patrol_point.emit()
        transition.emit("detect_shock")

func exit():
    plane.set_state_indicator(null)
