extends CenterContainer

@onready var best_run_label := %"Best Run Label"
@onready var times_container := %Times

@onready var section_data := preload("res://sections.tres")

signal exit

func _ready():
	visible = false

	visibility_changed.connect(_on_visibility_changed)

func _on_back_pressed():
	visible = false
	exit.emit()

func _on_visibility_changed():
	update_contents()

func update_contents() -> void:
	update_best_run_label()
	update_best_times()

func update_best_run_label() -> void:
	if TimeManager.best_time < 0:
		best_run_label.visible = false
	else:
		best_run_label.visible = true
		best_run_label.text = "Best run: %s" % TimeManager.convert_time_into_legibile_time(TimeManager.best_time)

func update_best_times() -> void:
	for child in times_container.get_children():
		child.queue_free()
	
	for index in TimeManager.best_times_for_sections.keys():
		var section_name = section_data.sections[index].display_name

		var time_label = Label.new()
		time_label.text = "Section %s: %s\n" % [index + 1, section_name]

		var time = TimeManager.best_times_for_sections[index]
		
		if time >= 0:
			time_label.text += "          " + str(TimeManager.convert_time_into_legibile_time(time))
		else:
			time_label.text += "          N/A"

		times_container.add_child(time_label)
