extends Node

signal on_pause_toggled
signal on_game_begin
signal on_game_end

@onready var pause_menu_scene := preload("res://pause_menu.tscn")

var is_playing: bool
var is_paused: bool

var pause_menu_instance: SubViewportContainer

func _enter_tree():
    process_mode = Node.PROCESS_MODE_ALWAYS

    if get_tree().current_scene.name == "World":
        print("Starting in World scene.")
        await get_tree().process_frame

        begin_game()

func begin_game():
    if is_playing:
        return
    
    is_playing = true
    is_paused = false

    if Saving.has_save_data():
        Saving.load_save()

    get_tree().change_scene_to_file("res://world.tscn")

    pause_menu_instance = pause_menu_scene.instantiate()
    get_tree().root.add_child(pause_menu_instance)

    await get_tree().process_frame

    on_game_begin.emit()

func end_game():
    if not is_playing:
        return
    
    Saving.save_to_disk()
    Saving.unload_save_data()
    
    is_playing = false
    is_paused = false
    get_tree().paused = false
    Cursor.remove_cursor()

    get_tree().change_scene_to_file("res://main_menu.tscn")

    pause_menu_instance.queue_free()
    pause_menu_instance = null

    await get_tree().process_frame
    
    on_game_end.emit()

func toggle_pause():
    is_paused = not is_paused
    get_tree().paused = is_paused
    on_pause_toggled.emit()