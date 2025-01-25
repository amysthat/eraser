extends StaticBody2D

enum TileSide
{
    UPPER_LEFT,
    UPPER,
    UPPER_RIGHT,
    LEFT,
    RIGHT,
    LOWER_LEFT,
    LOWER,
    LOWER_RIGHT,
}

@export var tilemap: TileMapLayer

func _ready():
    run_code()

func run_code(_fake_bool = null):
    delete_children()
    
    var tile_size = tilemap.tile_set.tile_size
    var tilemap_locations = tilemap.get_used_cells()
    
    if tilemap_locations.size() == 0:
        return
    
    while tilemap_locations.size() > 0:
        var location = tilemap_locations.pop_back()
        var tile_data = tilemap.get_cell_tile_data(location)
        var tile_side = tile_data.get_custom_data("Collision Side") as int
        var world_location = tilemap.map_to_local(location)

        var collision_shape = create_collision_shape(world_location, tile_size)
        modify_sided_collision_shape(collision_shape, tile_side, tile_size)
        
        add_child(collision_shape, true)
        collision_shape.owner = get_tree().edited_scene_root

    ## Move this node's position to cover the tilemap
    position = tilemap.position

func create_collision_shape(pos, tile_size) -> CollisionShape2D:
    var collision_shape = CollisionShape2D.new()
    var rectangleShape = RectangleShape2D.new()
    
    rectangleShape.size = tile_size
    collision_shape.set_shape(rectangleShape)
    collision_shape.position = pos
    
    return collision_shape

func delete_children():
    for child in get_children():
        child.queue_free()

func modify_sided_collision_shape(collision_shape: CollisionShape2D, tile_side: TileSide, tile_size: Vector2):
    collision_shape.one_way_collision = true

    # 4^2 + 4^2 = 32^-2 (hypotenuse)

    match tile_side:
        TileSide.UPPER_LEFT:
            var convex_shape = ConvexPolygonShape2D.new()
            convex_shape.points = [Vector2(0, -5.65), Vector2(5.65, 0), Vector2(0, 5.65), Vector2(-5.65, 0)]
            collision_shape.set_shape(convex_shape)

            collision_shape.rotation_degrees = -45
        TileSide.UPPER:
            var rectangleShape = RectangleShape2D.new()
            rectangleShape.size = tile_size
            collision_shape.set_shape(rectangleShape)
        TileSide.UPPER_RIGHT:
            var convex_shape = ConvexPolygonShape2D.new()
            convex_shape.points = [Vector2(0, -5.65), Vector2(5.65, 0), Vector2(0, 5.65), Vector2(-5.65, 0)]
            collision_shape.set_shape(convex_shape)

            collision_shape.rotation_degrees = 45
        TileSide.LEFT:
            var rectangleShape = RectangleShape2D.new()
            rectangleShape.size = tile_size
            collision_shape.set_shape(rectangleShape)

            collision_shape.rotation_degrees = -90
        TileSide.RIGHT:
            var rectangleShape = RectangleShape2D.new()
            rectangleShape.size = tile_size
            collision_shape.set_shape(rectangleShape)

            collision_shape.rotation_degrees = 90
        TileSide.LOWER_LEFT:
            var convex_shape = ConvexPolygonShape2D.new()
            convex_shape.points = [Vector2(0, -5.65), Vector2(5.65, 0), Vector2(0, 5.65), Vector2(-5.65, 0)]
            collision_shape.set_shape(convex_shape)

            collision_shape.rotation_degrees = -135
        TileSide.LOWER:
            var rectangleShape = RectangleShape2D.new()
            rectangleShape.size = tile_size
            collision_shape.set_shape(rectangleShape)

            collision_shape.rotation_degrees = 180
        TileSide.LOWER_RIGHT:
            var convex_shape = ConvexPolygonShape2D.new()
            convex_shape.points = [Vector2(0, -5.65), Vector2(5.65, 0), Vector2(0, 5.65), Vector2(-5.65, 0)]
            collision_shape.set_shape(convex_shape)

            collision_shape.rotation_degrees = 135

func _sort_vectors_by_y(a, b):
    if a.y > b.y:
        return true
    if a.y == b.y:
        if a.x > b.x:
            return true
    return false
