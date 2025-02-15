extends Control

@onready var continue_button := %Continue
@onready var remove_save_button := % "Remove Save"
@onready var save_info := % "Save Info"

@onready var settings_menu := $Settings

@onready var section_data := preload("res://sections.tres")

func _ready():
    update_save_section()

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

    if (Saving.has_game_save_data()):
        save_info.text = "Section %s/%s: %s" % [Saving.saved_section_index + 1, Game.SECTION_COUNT, section_data.sections[Saving.saved_section_index].display_name]
