extends Control

@export var label: Label

func _process(_delta: float) -> void:
    label.text = "%s (total: %s)" % [convert_time_into_legibile_time(TimeManager.elapsed_time_for_section), convert_time_into_legibile_time(TimeManager.elapsed_time)]

@warning_ignore("integer_division")
func convert_time_into_legibile_time(time: float) -> String:
    var hours = int(time) / 3600
    var minutes = (int(time) % 3600) / 60
    var seconds = int(time) % 60
    var milliseconds = int((time - int(time)) * 100)

    if hours > 0:
        return "%02d:%02d:%02d.%02d" % [hours, minutes, seconds, milliseconds]
    else:
        return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
