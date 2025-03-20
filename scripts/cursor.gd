extends Node

signal changed

var current: Texture2D
var shown: bool

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

    Game.on_pause_toggled.connect(_on_pause_toggled)

func set_cursor_image(image: Texture2D):
    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
    
    current = image
    shown = true
    changed.emit()

func remove_cursor():
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    
    current = null
    shown = false
    changed.emit()

func _on_pause_toggled():
    if current != null:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Game.is_paused else Input.MOUSE_MODE_HIDDEN
        shown = not Game.is_paused
        changed.emit()
