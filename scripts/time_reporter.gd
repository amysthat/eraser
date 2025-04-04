extends Control

@export var label: Label

func _process(_delta: float) -> void:
    label.text = "%s (total: %s)" % [TimeManager.convert_time_into_legibile_time(TimeManager.elapsed_time_for_section), TimeManager.convert_time_into_legibile_time(TimeManager.elapsed_time)]
    visible = not Game.is_paused

