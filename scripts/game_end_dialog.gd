extends Control

func _ready():
    Game.on_game_completed.connect(_on_game_completed)

func _on_game_completed():
    visible = true

func _on_main_menu_pressed():
    Game.end_complete_game()
