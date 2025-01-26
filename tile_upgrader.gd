@tool
extends Node

@export var tilemap: TileMapLayer

@export var run_code: bool = false: set = run

func run(_fake_bool = null):
    var locations = tilemap.get_used_cells()

    var changed_count = 0

    for loc in locations:
        if tilemap.get_cell_source_id(loc) == 0:
            tilemap.set_cell(loc, 1, Vector2.ZERO)
            changed_count += 1
    
    print("Upgrade finished. Total upgraded: ", changed_count)