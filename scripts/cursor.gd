extends Node2D
class_name Cursor

static var instance

@onready var sprite := $Sprite

@export var initial_cursor : Texture

var current_cursor : Resource

func _ready():
	instance = self
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	if initial_cursor:
		set_cursor_image(initial_cursor)

func _process(_delta):
	position = get_global_mouse_position()

static func set_cursor_image(image: Resource):
	instance.current_cursor = image
	instance.sprite.texture = image
