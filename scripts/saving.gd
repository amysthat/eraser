extends Node

const GAME_SAVE_PATH := "user://save.json"
const GLOBAL_SAVE_PATH := "user://global.json"

var save_loaded: bool

# Save data
var saved_section_index: int

# Game Save
func load_game_save():
    if not has_game_save_data():
        return
    
    var file = FileAccess.open(GAME_SAVE_PATH, FileAccess.READ)
    var content = file.get_as_text()
    file.close()

    var data = JSON.parse_string(content)

    saved_section_index = data["section_index"]
    save_loaded = true

func save_game_to_disk():
    var data = {
        "section_index": saved_section_index,
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

    Engine.max_fps = data["max_fps"]
    DisplayServer.window_set_vsync_mode(data["vsync"] if DisplayServer.VSYNC_ENABLED else DisplayServer.VSYNC_DISABLED)
    AudioServer.set_bus_volume_db(Game.MASTER_BUS_ID, linear_to_db(data["master_volume"]))
    AudioServer.set_bus_mute(Game.MASTER_BUS_ID, data["master_volume"] == 0)
    AudioServer.set_bus_volume_db(Game.MUSIC_BUS_ID, linear_to_db(data["music_volume"]))
    AudioServer.set_bus_mute(Game.MUSIC_BUS_ID, data["music_volume"] == 0)

func save_global_to_disk():
    var data = {
        "max_fps": Engine.max_fps,
        "vsync": DisplayServer.window_get_vsync_mode(),
        "master_volume": db_to_linear(AudioServer.get_bus_volume_db(Game.MASTER_BUS_ID)),
        "music_volume": db_to_linear(AudioServer.get_bus_volume_db(Game.MUSIC_BUS_ID)),
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