extends Node

signal on_pause_toggled
signal on_game_begin
signal on_game_end

const WORLD_SCENE := "res://world.tscn"
const PAUSE_MENU_SCENE := "res://scenes/menus/in_game_hud.tscn"
const MAIN_MENU_SCENE := "res://scenes/menus/main_menu.tscn"

# TODO: Remove
@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

const SECTION_COUNT := 3

var is_playing: bool
var is_paused: bool

func _enter_tree():
    process_mode = Node.PROCESS_MODE_ALWAYS

    if get_tree().current_scene.name == "World":
        print("Starting in World scene.")
        await get_tree().process_frame

        begin_game()

func _ready():
    App.instance.app_ready.connect(_on_app_ready)

func _on_app_ready():
    App.instance.load_ui_scene(load(MAIN_MENU_SCENE))

func begin_game() -> void:
    if is_playing:
        return
    
    is_playing = true
    is_paused = false

    if Saving.has_game_save_data():
        Saving.load_game_save()

    App.instance.load_world_scene(load(WORLD_SCENE))

    await get_tree().process_frame

    on_game_begin.emit()

    App.instance.load_ui_scene(load(PAUSE_MENU_SCENE))

func end_game() -> void:
    if not is_playing:
        return
    
    Saving.save_game_to_disk()
    
    is_playing = false
    is_paused = false
    get_tree().paused = false
    Cursor.remove_cursor()

    App.instance.unload_world_scene()
    App.instance.load_ui_scene(load(MAIN_MENU_SCENE))

    await get_tree().process_frame
    
    on_game_end.emit()

func toggle_pause() -> void:
    is_paused = not is_paused
    get_tree().paused = is_paused
    on_pause_toggled.emit()
