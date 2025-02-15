extends State

@export var plane: PlaneBody
@export var status_texture: Texture2D
@export var reach_radius: float
@export var speed: float
@export var up_from_player: float
@export var sight_break_time: float

var cancel_time: float

func enter():
    if not can_see_player():
        print("can not see player!")
        transition.emit("patrol")
        return

    plane.set_state_indicator(status_texture)

func update(delta: float):
    if not can_see_player():
        cancel_time += delta
    else:
        cancel_time -= delta
    
    if cancel_time > sight_break_time:
        print("approach: can't see!")
        transition.emit("patrol")

func physics_update(_delta: float):
    var target_point = Player.instance.global_position + Vector2.UP * up_from_player

    var difference = target_point - plane.global_position

    if difference.length() <= reach_radius:
        transition.emit("charge")
        return
    
    plane.velocity = difference.normalized() * speed

func exit():
    plane.set_state_indicator(null)
    cancel_time = 0

func can_see_player() -> bool:
    return plane.player_raycast.is_colliding() and plane.player_raycast.get_collider() == Player.instance
