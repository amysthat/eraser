extends PanelContainer

@export var time_label: Label

func _ready() -> void:
    visible = Game.game_completed

func _process(_delta: float) -> void:
    time_label.text = "Time: %s" % TimeManager.convert_time_into_legibile_time(TimeManager.elapsed_time)
	