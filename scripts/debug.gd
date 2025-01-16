extends Node

func _process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		swap_fullscreen()
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func swap_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
