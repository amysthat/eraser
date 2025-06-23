extends Control

@export var name_label: Label
@export var completion_label: Label
@export var time_label: Label
@export var best_time: Label

func _ready():
    time_label.visible = Game.game_completed
    best_time.visible = Game.game_completed

    while Sections.instance == null:
        await get_tree().process_frame
    
    Sections.instance.entered_section.connect(_on_entered_section)

    while Sections.instance.current_section == null:
        await get_tree().process_frame

    _on_entered_section(Sections.instance.current_section)

func _process(_delta: float) -> void:
    time_label.text = "Been in this section for: %s" % TimeManager.convert_time_into_legibile_time(TimeManager.elapsed_time_for_section)

func _on_entered_section(new_section: Section):
    name_label.text = new_section.display_name
    completion_label.text = "%s of %s" % [Sections.instance.current_section_index + 1, Sections.instance.get_visible_section_count()]

    if TimeManager.best_time_for_section >= 0:
        best_time.visible = true
        best_time.text = "Best time for this section: %s" % TimeManager.convert_time_into_legibile_time(TimeManager.best_time_for_section)
    else:
        best_time.visible = false
