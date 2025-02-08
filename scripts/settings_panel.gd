extends CenterContainer

signal exit

@onready var max_fps_box: SpinBox = %MaxFPS
@onready var vsync: CheckButton = %VSync

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider

func _ready():
    visible = false

    max_fps_box.value = Engine.max_fps
    vsync.button_pressed = DisplayServer.window_get_vsync_mode()

    master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(Game.MASTER_BUS_ID))
    music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(Game.MUSIC_BUS_ID))

func _on_back_pressed():
    visible = false
    exit.emit()

@warning_ignore("narrowing_conversion")
func _on_fps_apply_pressed():
    Engine.max_fps = max_fps_box.value
    print("Max FPS set to: %s" % Engine.max_fps)

    Saving.save_global_to_disk()

func _on_v_sync_toggled(toggled_on: bool):
    if toggled_on:
        DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
    else:
        DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
        
    print("VSync set to: %s" % DisplayServer.window_get_vsync_mode())
    
    Saving.save_global_to_disk()

func _on_master_slider_value_changed(value: float):
    AudioServer.set_bus_volume_db(Game.MASTER_BUS_ID, linear_to_db(value))
    AudioServer.set_bus_mute(Game.MASTER_BUS_ID, value == 0)
    
    Saving.save_global_to_disk()

func _on_music_slider_value_changed(value: float):
    AudioServer.set_bus_volume_db(Game.MUSIC_BUS_ID, linear_to_db(value))
    AudioServer.set_bus_mute(Game.MUSIC_BUS_ID, value == 0)
    
    Saving.save_global_to_disk()
