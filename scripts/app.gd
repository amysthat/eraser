class_name App extends Node

static var instance: App

signal app_ready

@onready var world_viewport : SubViewport = %World
@onready var world_render : TextureRect = %Render
@onready var ui_holder := %UI

var world: Node
var ui: Node

func _enter_tree():
    instance = self

func _ready() -> void:
    app_ready.emit()

func load_world_scene(scene: PackedScene) -> void:
    unload_world_scene()

    world = scene.instantiate()
    world_viewport.add_child(world)

func unload_world_scene() -> void:
    if world == null:
        return
    
    world.queue_free()
    world = null

func load_ui_scene(scene: PackedScene) -> void:
    unload_ui_scene()

    ui = scene.instantiate()
    ui_holder.add_child(ui)

func unload_ui_scene() -> void:
    if ui == null:
        return
    
    ui.queue_free()
    ui = null

func get_mouse_screen_position() -> Vector2:
    # Get mouse position in global (screen) coordinates
    var mouse_global_pos = get_viewport().get_mouse_position()
    
    var rect: Rect2 = world_render.get_global_rect()
    
    # Calculate mouse position relative to the TextureRect.
    var relative_mouse_pos = mouse_global_pos - rect.position
    
    # Scale ratio between the SubViewport and the TextureRect.
    var scale_x = world_viewport.size.x / rect.size.x
    var scale_y = world_viewport.size.y / rect.size.y
    
    # Multiply by the scale to get SubViewport coordinates
    var subviewport_mouse_pos = Vector2(
        relative_mouse_pos.x * scale_x,
        relative_mouse_pos.y * scale_y
    )

    return subviewport_mouse_pos

func get_global_mouse_position() -> Vector2:
    var mouse_pos_in_subviewport = get_mouse_screen_position()
    
    # Convert viewport coordinates to world position
    return world_viewport.get_camera_2d().get_canvas_transform().affine_inverse() * mouse_pos_in_subviewport
