extends Node

const SAVE_PATH := "user://save.json"

var save_loaded: bool
var saved_section_index: int

func load_save():
    if not has_save_data():
        return
    
    var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
    var content = file.get_as_text()
    file.close()

    var data = JSON.parse_string(content)

    saved_section_index = data["section_index"]
    save_loaded = true

func save_to_disk():
    var data = {
        "section_index": saved_section_index,
    }

    var content = JSON.stringify(data)
    
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    file.store_string(content)
    file.close()

    print("Save finished.")

func remove_save_data():
    DirAccess.remove_absolute(SAVE_PATH)
    save_loaded = false

func unload_save_data():
    save_loaded = false

func has_save_data() -> bool:
    return FileAccess.file_exists(SAVE_PATH)
