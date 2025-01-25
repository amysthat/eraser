extends Control

@onready var continue_button := %Continue

@onready var settings_menu := $Settings
@onready var max_fps_box: SpinBox = %MaxFPS
@onready var vsync: CheckButton = %VSync

func _ready():
    settings_menu.visible = false

    max_fps_box.value = Engine.max_fps
    vsync.button_pressed = DisplayServer.window_get_vsync_mode()

    continue_button.disabled = not Saving.has_save_data()

func _on_new_game_pressed():
    if Saving.has_save_data():
        Saving.remove_save_data()

    Game.begin_game()

func _on_continue_pressed():
    Game.begin_game()

func _on_quit_pressed():
    get_tree().quit()

func _on_settings_pressed():
    settings_menu.visible = true

func _on_settings_back_pressed():
    settings_menu.visible = false

@warning_ignore("narrowing_conversion")
func _on_fps_apply_pressed():
    Engine.max_fps = max_fps_box.value
    print("Max FPS set to: %s" % Engine.max_fps)

func _on_v_sync_toggled(toggled_on: bool):
    if toggled_on:
        DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
    else:
        DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
        
    print("VSync set to: %s" % DisplayServer.window_get_vsync_mode())
