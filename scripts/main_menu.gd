extends Control

@onready var continue_button := %Continue
@onready var remove_save_button := %"Remove Save"
@onready var save_info := %"Save Info"
@onready var best_times_button := %"Best Times"

@onready var settings_menu := $Settings
@onready var best_times_menu := $"Best Times"

@onready var section_data := preload("res://sections.tres")

func _ready():
    update_save_section()

func _process(_delta: float) -> void:
    best_times_button.visible = Game.game_completed

func _on_new_game_pressed():
    if Saving.has_game_save_data():
        Saving.remove_game_save_data()

    Game.begin_game()

func _on_continue_pressed():
    Game.begin_game()

func _on_quit_pressed():
    get_tree().quit()

func _on_settings_pressed():
    settings_menu.visible = true

func _on_remove_save_pressed():
    Saving.remove_game_save_data()
    update_save_section()

func update_save_section():
    continue_button.disabled = not Saving.has_game_save_data()
    remove_save_button.visible = Saving.has_game_save_data()
    save_info.visible = Saving.has_game_save_data()

    if Saving.has_game_save_data():
        save_info.text = "Section %s/%s: %s" % [Saving.saved_section_index + 1, Game.SECTION_COUNT - Game.HIDDEN_SECTION_COUNT, section_data.sections[Saving.saved_section_index].display_name]
        save_info.text += " | %s" % TimeManager.convert_time_into_legibile_time(TimeManager.elapsed_time)

func _on_best_times_pressed() -> void:
    best_times_menu.visible = true
