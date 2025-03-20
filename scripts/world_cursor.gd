class_name WorldCursor extends Sprite2D

func _enter_tree() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _ready():
	Cursor.changed.connect(_on_cursor_changed)
	update_cursor()

func _process(_delta: float) -> void:
	global_position = App.instance.get_global_mouse_position()

func _on_cursor_changed():
	update_cursor()

func update_cursor() -> void:
	visible = Cursor.shown
	texture = Cursor.current
