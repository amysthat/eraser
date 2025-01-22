extends State

@export var plane: PlaneBody
@export var status_texture: Texture2D
@export var reach_radius: float
@export var speed: float
@export var up_from_player: float

func enter():
    plane.set_state_indicator(status_texture)

func update(_delta: float):
    if plane.player_raycast.is_colliding() and plane.player_raycast.get_collider() != Player.instance:
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
