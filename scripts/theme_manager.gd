extends Node
class_name ThemeManager

# Static

static var active_theme: GameTheme:
    get: return _applied_theme
    set(value): update_theme(value)

static var _applied_theme: GameTheme
static var _active_manager: ThemeManager

static func update_theme(new_theme: GameTheme):
    _applied_theme = new_theme

    if _active_manager != null and _applied_theme != null:
        _active_manager.apply_theme()

# Instance

@export var tilemaps: Array[TileMapLayer]

@export var debug_theme: GameTheme

func _ready():
    _active_manager = self

    if active_theme != null:
        apply_theme()
    
    await get_tree().process_frame

    active_theme = debug_theme

func apply_theme():
    if active_theme == null:
        print("active_theme has been set to null.")

    print("Applying theme: ", active_theme.internal_name)
    print("Tileset ID: ", active_theme.tileset_source_id)
    print("Background color: ", active_theme.background_color)

    for tilemap in tilemaps:
        var cell_locations = tilemap.get_used_cells()

        for location in cell_locations:
            tilemap.set_cell(location, active_theme.tileset_source_id, tilemap.get_cell_atlas_coords(location), tilemap.get_cell_alternative_tile(location))
    
    RenderingServer.set_default_clear_color(active_theme.background_color)
