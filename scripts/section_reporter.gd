extends Control

@export var name_label: Label
@export var completion_label: Label

func _ready():
    while Sections.instance == null:
        await get_tree().process_frame
    
    Sections.instance.entered_section.connect(_on_entered_section)

    while Sections.instance.current_section == null:
        await get_tree().process_frame

    _on_entered_section(Sections.instance.current_section)

func _on_entered_section(new_section: Section):
    name_label.text = new_section.display_name
    completion_label.text = "%s of %s" % [Sections.instance.current_section_index + 1, Sections.instance.sections.size()]
