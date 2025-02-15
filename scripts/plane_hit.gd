extends State
class_name PlaneWeakState

enum WeakenReason
{
    PLAYER_PARRY,
    MISS,
}

@export var plane: PlaneBody
@export var status_texture: Texture2D
@export var plane_texture: Texture2D

@export_category("Time")
@export var player_parry_time: float
@export var miss_time: float

@onready var timer := $Timer

var weaken_reason: WeakenReason

var plane_old_texture

func enter():
    plane.velocity = Vector2.ZERO
    plane.set_state_indicator(status_texture)

    plane_old_texture = plane.sprite.texture
    plane.sprite.texture = plane_texture

    match weaken_reason:
        WeakenReason.PLAYER_PARRY:
            timer.start(player_parry_time)
        WeakenReason.MISS:
            timer.start(miss_time)

func _process(delta):
    plane.velocity = lerp(plane.velocity, Vector2.ZERO, 5 * delta)

func exit():
    plane.sprite.texture = plane_old_texture
    plane.set_state_indicator(null)

    timer.stop()

func enable_with_reason(reason_int: int):
    weaken_reason = reason_int as WeakenReason
    transition.emit("weak")

func _on_timer_timeout():
    transition.emit("approach")
