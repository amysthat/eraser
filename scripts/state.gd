extends Node
class_name State

@warning_ignore("unused_signal")
signal transition(new_state_name: String)

func enter():
    pass

func exit():
    pass

func update(_delta: float):
    pass

func physics_update(_delta: float):
    pass

func transition_to_self():
    transition.emit(name)
