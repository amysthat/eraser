extends Control

@export var visiblity_node: Control

func _ready():
    visiblity_node.visible = false

func _process(_delta):
    if Input.is_action_just_pressed("toggle_pause"):
        Game.toggle_pause()

    visiblity_node.visible = Game.is_paused

func _on_resume_pressed():
    Game.toggle_pause()

func _on_main_menu_pressed():
    Game.end_game()
