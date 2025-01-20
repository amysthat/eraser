extends Node2D

var sprite: Sprite2D

var current_cursor: Resource

func _ready():
	sprite = Sprite2D.new()
	add_child(sprite)
	sprite.z_index = 999

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