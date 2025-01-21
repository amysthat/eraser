extends SubViewportContainer

@onready var sub_viewport := %SubViewport
@onready var canvas_layer := %CanvasLayer
@onready var content := %Content

func _ready():
    scale = Vector2.ONE / 6.0
    content.reparent(canvas_layer)

    visible = false

func _process(_delta):
    if Input.is_action_just_pressed("toggle_pause"):
        Game.toggle_pause()

    visible = Game.is_paused

    if Game.is_paused:
        global_position = get_viewport().get_camera_2d().get_screen_center_position() - Vector2(160, 90)

func _on_resume_pressed():
    Game.toggle_pause()

func _on_main_menu_pressed():
    Game.end_game()
