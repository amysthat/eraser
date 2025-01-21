extends Node2D

var sprite: Sprite2D

var current_cursor: Resource

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

    Game.on_pause_toggled.connect(_on_pause_toggled)

    sprite = Sprite2D.new()
    add_child(sprite)
    z_index = 999

func _process(_delta):
    position = get_global_mouse_position()

func set_cursor_image(image: Resource):
    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
    
    current_cursor = image
    sprite.texture = image

func remove_cursor():
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    
    current_cursor = null
    sprite.texture = null

func _on_pause_toggled():
    if current_cursor != null:
        if Game.is_paused:
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
            sprite.texture = null
        else:
            Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
            sprite.texture = current_cursor