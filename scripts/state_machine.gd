extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready():
    for child in get_children():
        if child is State:
            states[child.name.to_lower()] = child
            child.transition.connect(_on_child_transition)
    
    await get_tree().process_frame
    
    if initial_state:
        current_state = initial_state
        initial_state.enter()

func _process(delta):
    if current_state:
        current_state.update(delta)

func _physics_process(delta):
    if current_state:
        current_state.physics_update(delta)

func _on_child_transition(new_state_name: String):
    transition_state(new_state_name)

func transition_state(new_state_name: String):
    var new_state = states[new_state_name.to_lower()]
    if !new_state:
        push_error("State transition was emitted, but the target state wasn't found: ", new_state_name)
    
    var old_state = current_state
    current_state = new_state

    if old_state:
        old_state.exit()
    
    new_state.enter()