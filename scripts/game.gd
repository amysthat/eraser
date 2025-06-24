extends Node

signal on_pause_toggled
signal on_game_begin
signal on_game_end

signal on_game_completed

const WORLD_SCENE := "res://world.tscn"
const PAUSE_MENU_SCENE := "res://scenes/menus/in_game_hud.tscn"
const MAIN_MENU_SCENE := "res://scenes/menus/main_menu.tscn"

# TODO: Remove
@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

# TODO: This is a temporary solution, should be removed later
const SECTION_COUNT := 4
const HIDDEN_SECTION_COUNT := 1

var is_playing: bool
var is_paused: bool
var cannot_toggle_pause: bool

var game_completed: bool

func _enter_tree():
    process_mode = Node.PROCESS_MODE_ALWAYS

func _ready():
    App.instance.app_ready.connect(_on_app_ready)

func _on_app_ready():
    App.instance.load_ui_scene(load(MAIN_MENU_SCENE))

func begin_game() -> void:
    if is_playing:
        return
    
    is_playing = true
    is_paused = false
    cannot_toggle_pause = false

    TimeManager.elapsed_time = 0
    TimeManager.elapsed_time_for_section = 0

    if Saving.has_game_save_data():
        Saving.load_game_save()

    App.instance.load_world_scene(load(WORLD_SCENE))

    await get_tree().process_frame

    on_game_begin.emit()

    App.instance.load_ui_scene(load(PAUSE_MENU_SCENE))

func end_game(save_game: bool = true) -> void:
    if not is_playing:
        return
    
    on_game_end.emit()
    
    if save_game:
        Saving.save_game_to_disk()
    
    is_playing = false
    is_paused = false
    cannot_toggle_pause = false
    get_tree().paused = false
    Cursor.remove_cursor()

    App.instance.unload_world_scene()
    App.instance.load_ui_scene(load(MAIN_MENU_SCENE))

func toggle_pause() -> void:
    if cannot_toggle_pause:
        return

    is_paused = not is_paused
    get_tree().paused = is_paused
    on_pause_toggled.emit()

func complete_game() -> void:
    if game_completed:
        return
    
    game_completed = true
    Saving.save_global_to_disk()

    toggle_pause()
    cannot_toggle_pause = true

    on_game_completed.emit()

func end_complete_game() -> void:
    if not game_completed:
        return
    
    Saving.remove_game_save_data()
    end_game(false)

func reset_game_data() -> void:
    Saving.remove_game_save_data()
    Saving.remove_global_save_data()

    var can_restart_game := OS.has_feature("desktop") and not Engine.is_editor_hint()

    if can_restart_game:
        var exe_path = OS.get_executable_path()
        OS.create_process(exe_path, [])
        get_tree().quit()
        return
    
    # Manually reset game data

    Saving.initialize_global_save_data()

    TimeManager.elapsed_time = 0
    TimeManager.elapsed_time_for_section = 0
    TimeManager.best_times_for_sections = {}

    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
    DisplayServer.window_set_size(Vector2(1920, 1080))

    App.instance.unload_ui_scene()
    App.instance.load_ui_scene(load(MAIN_MENU_SCENE))
