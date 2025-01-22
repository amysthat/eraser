extends State
class_name PlaneWeakState

enum WeakenReason
{
    PLAYER_PARRY,
    MISS,
}

@export var plane: PlaneBody
@export var status_texture: Texture2D

@export_category("Time")
@export var player_parry_time: float
@export var miss_time: float

@onready var timer := $Timer

var weaken_reason: WeakenReason

func enter():
    plane.velocity = Vector2.ZERO
    plane.is_weak = true
    plane.set_state_indicator(status_texture)

    match weaken_reason:
        WeakenReason.PLAYER_PARRY:
            timer.start(player_parry_time)
        WeakenReason.MISS:
            timer.start(miss_time)

func exit():
    plane.is_weak = false
    plane.set_state_indicator(null)

    timer.stop()

func enable_with_reason(reason: WeakenReason):
    weaken_reason = reason
    transition.emit("weak")

func _on_timer_timeout():
    transition.emit("patrol")
