extends Area2D
class_name SectionArea

signal player_entered_area(area: SectionArea)

@export var section_index: int

func _ready():
    var sections = get_parent() as Sections
    sections.subscribe_area(self)

    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
    if body is Player:
        player_entered_area.emit(self)