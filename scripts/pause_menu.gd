extends Control

@export var visiblity_node: Control
@export var settings_menu: Control
@export var best_times_menu: Control
@export var best_times_button: Button

@export var game_end_dialog: Control

func _ready():
    visiblity_node.visible = false

    best_times_button.visible = Game.game_completed

func _process(_delta):
    if Input.is_action_just_pressed("toggle_pause"):
        Game.toggle_pause()

    visiblity_node.visible = Game.is_paused && (not game_end_dialog.visible)

func _on_resume_pressed():
    Game.toggle_pause()

func _on_main_menu_pressed():
    Game.end_game()

func _on_settings_pressed():
    settings_menu.visible = true

func _on_best_time_pressed() -> void:
    best_times_menu.visible = true
