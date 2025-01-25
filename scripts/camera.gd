extends Camera2D
class_name GameCamera

signal on_physics_update

@export var target_node: Node2D

var SPEED := 10.0

func _process(delta):
	if not target_node:
		return
	
	global_position = lerp(global_position, target_node.global_position, SPEED * delta)

func _physics_process(_delta):
	on_physics_update.emit()