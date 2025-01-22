extends State

@export var plane: PlaneBody
@export var status_texture: Texture2D

@onready var timer := $Timer

func enter():
    plane.set_state_indicator(status_texture)
    plane.velocity = Vector2.ZERO

    plane.sprite.flip_h = plane.global_position.x < Player.instance.global_position.x

    timer.start()

func exit():
    plane.set_state_indicator(null)

func _on_timer_timeout():
    transition.emit("approach")
