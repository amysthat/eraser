extends CenterContainer

signal exit

const RESOLUTIONS := {
	Vector2i(3840, 2160): "3840x2160",
	Vector2i(2560, 1440): "2560x1440",
	Vector2i(1920, 1080): "1920x1080",
	Vector2i(1600, 900): "1600x900",
	Vector2i(1280, 720): "1280x720",
}

@onready var max_fps_box: SpinBox = %MaxFPS
@onready var vsync: CheckButton = %VSync
@onready var resolution: MenuButton = %Resolution
@onready var fullscreen: CheckButton = %Fullscreen

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider

func _ready():
	visible = false

	max_fps_box.value = Engine.max_fps
	vsync.button_pressed = DisplayServer.window_get_vsync_mode()

	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(Game.MASTER_BUS_ID))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(Game.MUSIC_BUS_ID))

	for vec in RESOLUTIONS:
		var text = RESOLUTIONS[vec]

		resolution.get_popup().add_item(text)
		resolution.get_popup().set_item_as_checkable(resolution.get_popup().item_count - 1, true)
	
	update_resolution()

	resolution.get_popup().index_pressed.connect(_resolution_selected)

	get_tree().root.size_changed.connect(update_resolution)

func update_resolution():
	var current_size = DisplayServer.window_get_size(DisplayServer.window_get_current_screen())

	for i in range(resolution.get_popup().item_count):
		resolution.get_popup().set_item_checked(i, false)

	if RESOLUTIONS.has(current_size):
		var index = RESOLUTIONS.keys().find(current_size)
		resolution.get_popup().set_item_checked(index, true)
	
	var res_text = "%sx%s" % [current_size.x, current_size.y]
	var full_text = res_text

	match DisplayServer.window_get_mode(DisplayServer.window_get_current_screen()):
		DisplayServer.WindowMode.WINDOW_MODE_MAXIMIZED:
			full_text = "Maximized (%s)" % res_text
		DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			full_text = "Fullscreen (%s)" % res_text

	resolution.text = full_text

	fullscreen.set_pressed_no_signal(DisplayServer.window_get_mode(DisplayServer.window_get_current_screen()) == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _resolution_selected(index: int):
	var text = resolution.get_popup().get_item_text(index)

	var resolution_index = RESOLUTIONS.values().find(text)

	if resolution_index == -1:
		return

	var resolution_vec = RESOLUTIONS.keys()[resolution_index]
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED, DisplayServer.window_get_current_screen())
	DisplayServer.window_set_size(resolution_vec, DisplayServer.window_get_current_screen())

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

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	var target_mode = DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if toggled_on else DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(target_mode, DisplayServer.window_get_current_screen())
	print("Fullscreen set to: %s" % DisplayServer.window_get_mode(DisplayServer.window_get_current_screen()))
	update_resolution()
