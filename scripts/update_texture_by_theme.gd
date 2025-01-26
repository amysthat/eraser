extends Node
class_name TextureUpdater

@export var sprite2d: Sprite2D
@export var texture_name: String

func _ready():
    ThemeManager.active_manager.subscribe(update_theme)

func update_theme():
    sprite2d.texture = ThemeManager.active_theme.get(texture_name)
