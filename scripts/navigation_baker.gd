@tool
extends Node

@export var colliders: Node2D
@export var run: bool: set = run_code

func run_code(_fake_bool = null):
    bake()

func _ready():
    await get_tree().process_frame
    await get_tree().process_frame
    await get_tree().process_frame
    await get_tree().process_frame
    await get_tree().process_frame

    bake()

func bake():
    var outlines = []

    for child in colliders.get_children():
        if child is CollisionShape2D:
            var shape = child.shape
            if shape is RectangleShape2D:
                outlines.append(_get_rectangle_outline(child, shape))
            else:
                push_error("Unsupported collider: %s" % shape)

    var nav_polygon = NavigationPolygon.new()
    var nav_region = NavigationRegion2D.new()
    nav_region.navigation_polygon = nav_polygon
    add_child(nav_region)

    # Sort outlines based on area (largest first) to avoid intersections
    outlines.sort_custom(_compare_outline_area)

    for outline in outlines:
        nav_polygon.add_outline(outline)

    nav_polygon.make_polygons_from_outlines()

func _get_rectangle_outline(collider, shape):
    var extents = shape.extents
    var points = [
        collider.to_global(Vector2(-extents.x, -extents.y)),
        collider.to_global(Vector2(extents.x, -extents.y)),
        collider.to_global(Vector2(extents.x, extents.y)),
        collider.to_global(Vector2(-extents.x, extents.y))
    ]
    return points

func _compare_outline_area(outline_a, outline_b):
    var area_a = _calculate_outline_area(outline_a)
    var area_b = _calculate_outline_area(outline_b)
    return area_a - area_b # Sort largest to smallest

func _calculate_outline_area(outline):
    var area = 0.0
    var n = outline.size()
    for i in range(n):
        var p1 = outline[i]
        var p2 = outline[(i + 1) % n]
        area += p1.x * p2.y - p2.x * p1.y
    return abs(area) / 2.0
