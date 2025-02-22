extends CharacterBody2D
class_name Enemy

func hit_player(normal: Vector2):
    Player.instance.get_hit(normal, self)

func get_hit_by_player():
    if is_pacified():
        _destroy()
    else:
        _pacify()

func _pacify():
    push_error("_pacify callback is not set for ", name)

func _destroy():
    push_error("_destroy callback is not set for ", name)

func on_successful_hit():
    pass

func is_pacified() -> bool:
    push_error("is_pacified callback is not set for ", name)
    return false
