extends Node2D
class_name Sections

static var instance: Sections

signal entered_section(new_section: Section)

@export var sections: Array[Section]

var areas_to_sections: Dictionary

var current_section_area: SectionArea
var current_section: Section
var current_section_index: int

func _enter_tree():
    instance = self

func subscribe_area(area: SectionArea):
    var section_index = area.section_index
    areas_to_sections.get_or_add(area, sections[section_index])

    area.player_entered_area.connect(_on_player_entered_area)

func _on_player_entered_area(area: SectionArea):
    if current_section_area == area:
        return

    current_section_area = area
    current_section = areas_to_sections[area]
    current_section_index = sections.find(current_section)

    print("Entered section: %s (index: %s)" % [current_section.display_name, current_section_index])

    entered_section.emit(current_section)
