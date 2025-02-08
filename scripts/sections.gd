extends Node2D
class_name Sections

static var instance: Sections

signal entered_section(new_section: Section)
signal set_spawn_of_player(section: Section)

@export var sections: Array[Section]

var areas_to_sections: Dictionary

var current_section_area: SectionArea
var current_section: Section
var current_section_index: int

func _enter_tree():
    instance = self

func _ready():
    if Saving.save_loaded:
        set_spawn_of_player.emit(sections[Saving.saved_section_index])

func subscribe_area(area: SectionArea):
    var section_index = area.section_index
    areas_to_sections.get_or_add(area, sections[section_index])

    area.player_entered_area.connect(_on_player_entered_area)

func _on_player_entered_area(area: SectionArea):
    if current_section_area == area:
        return
    
    var target_index = sections.find(areas_to_sections[area])

    if current_section_index > target_index:
        print("Canceling section downgrade from ", current_section_index, " to ", target_index)
        return

    current_section_area = area
    current_section = areas_to_sections[area]
    current_section_index = sections.find(current_section)

    print("Entered section: %s (index: %s)" % [current_section.display_name, current_section_index])

    Saving.saved_section_index = current_section_index
    Saving.save_game_to_disk()

    entered_section.emit(current_section)
