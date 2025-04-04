extends Node

const GAME_SAVE_PATH := "user://save.json"
const GLOBAL_SAVE_PATH := "user://global.json"

var save_loaded: bool

# Save data
var saved_section_index: int

# Events
func _ready() -> void:
    if has_global_save_data():
        load_global_save()
    else:
        initialize_global_save_data()
    
    if has_game_save_data():
        load_game_save()

# Game Save
func load_game_save():
    if not has_game_save_data():
        return
    
    var file = FileAccess.open(GAME_SAVE_PATH, FileAccess.READ)
    var content = file.get_as_text()
    file.close()

    var data = JSON.parse_string(content)

    saved_section_index = data["section_index"]
    TimeManager.elapsed_time = data["elapsed_time"]
    TimeManager.elapsed_time_for_section = data["elapsed_time_for_section"]
    save_loaded = true

func save_game_to_disk():
    var data = {
        "section_index": saved_section_index,
        "elapsed_time": TimeManager.elapsed_time,
        "elapsed_time_for_section": TimeManager.elapsed_time_for_section,
    }

    var content = JSON.stringify(data)
    
    var file = FileAccess.open(GAME_SAVE_PATH, FileAccess.WRITE)
    file.store_string(content)
    file.close()

func remove_game_save_data():
    DirAccess.remove_absolute(GAME_SAVE_PATH)
    save_loaded = false

func has_game_save_data() -> bool:
    return FileAccess.file_exists(GAME_SAVE_PATH)

# Global  Save
func load_global_save():
    if not has_global_save_data():
        return
    
    var file = FileAccess.open(GLOBAL_SAVE_PATH, FileAccess.READ)
    var content = file.get_as_text()
    file.close()

    var data = JSON.parse_string(content)

    Engine.max_fps = data["max_fps"] # FIXME: Doesn't really work?
    DisplayServer.window_set_vsync_mode(data["vsync"] if DisplayServer.VSYNC_ENABLED else DisplayServer.VSYNC_DISABLED)
    AudioServer.set_bus_volume_db(Game.MASTER_BUS_ID, linear_to_db(data["master_volume"]))
    AudioServer.set_bus_mute(Game.MASTER_BUS_ID, data["master_volume"] == 0)
    AudioServer.set_bus_volume_db(Game.MUSIC_BUS_ID, linear_to_db(data["music_volume"]))
    AudioServer.set_bus_mute(Game.MUSIC_BUS_ID, data["music_volume"] == 0)

    # This type of conversion is needed because godot loads JSON dictionaries as STRING-VALUE dictionaries.
    # Even if the original dictionary was INT-FLOAT, it gets saved and loaded as STRING-FLOAT,
    # And since dictionaries aren't statically typed, godot allowed multiple types as keys stored in the dictionary,
    # becoming this:
    # "0": -1,
    # "1": -1,
    # "2": -1,
    # 0: -1, ## From here on, TimeManager fills these in.
    # 1: -1,
    # 2: -1
    #
    # Therefore, this manual conversion is needed.
    
    var best_times: Dictionary
    for key in data["best_times"].keys():
        var index = int(key)
        best_times[index]= data["best_times"][key]

    TimeManager.best_times_for_sections = best_times
    TimeManager.best_time = data["best_time"]
    TimeManager.complete_missing_best_times()

func save_global_to_disk():
    var data = {
        "max_fps": Engine.max_fps,
        "vsync": DisplayServer.window_get_vsync_mode(),
        "master_volume": db_to_linear(AudioServer.get_bus_volume_db(Game.MASTER_BUS_ID)),
        "music_volume": db_to_linear(AudioServer.get_bus_volume_db(Game.MUSIC_BUS_ID)),
        "best_times": TimeManager.best_times_for_sections,
        "best_time": TimeManager.best_time,
    }

    var content = JSON.stringify(data)
    
    var file = FileAccess.open(GLOBAL_SAVE_PATH, FileAccess.WRITE)
    file.store_string(content)
    file.close()

func initialize_global_save_data():
    Engine.max_fps = 120
    DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
    AudioServer.set_bus_volume_db(Game.MASTER_BUS_ID, linear_to_db(1))
    AudioServer.set_bus_mute(Game.MASTER_BUS_ID, false)
    AudioServer.set_bus_volume_db(Game.MUSIC_BUS_ID, linear_to_db(1))
    AudioServer.set_bus_mute(Game.MUSIC_BUS_ID, false)

    save_global_to_disk()
    load_global_save()

func has_global_save_data() -> bool:
    return FileAccess.file_exists(GLOBAL_SAVE_PATH)
