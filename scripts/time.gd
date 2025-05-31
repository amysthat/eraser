extends Node

var best_times_for_sections: Dictionary = {}

var elapsed_time_for_section: float
var elapsed_time: float

var best_time_for_section: float:
    get:
        if Sections.instance == null:
            print("TimeManager: Sections instance is null. Returning -1 for best time.")
            return -1

        if not best_times_for_sections.keys().has(Sections.instance.current_section_index):
            print("TimeManager: No best time set for current section index. Returning -1.")
            return -1
        
        return best_times_for_sections[Sections.instance.current_section_index]
    set(value):
        best_times_for_sections[Sections.instance.current_section_index] = value
var best_time: float = -1

var timer_running: bool

func _ready() -> void:
    Game.on_game_begin.connect(start_timer)
    Game.on_game_end.connect(end_timer)

func _process(delta: float) -> void:
    elapsed_time += delta
    elapsed_time_for_section += delta

func complete_missing_best_times() -> void:
    for i in range(load("res://sections.tres").sections.size()):
        if not best_times_for_sections.keys().has(i):
            best_times_for_sections[i] = -1

func start_timer() -> void:
    timer_running = true

func end_timer() -> void:
    timer_running = false

func finish_previous_section() -> void:
    print("TimeManager: Finishing previous section...")

    if Sections.instance.current_section_index < 1:
        print("TimeManager: First section encountered. Skipping.")
        return

    var index = Sections.instance.current_section_index - 1

    print("Section finished: ", index)

    var best_time_not_set = best_times_for_sections[index] < 0
    var new_record = elapsed_time_for_section < best_times_for_sections[index]

    print("Elapsed time for section: ", elapsed_time_for_section)
    print("Best time for section: ", best_times_for_sections[index])
    print("New record: ", new_record)
    print("Best time not set: ", best_time_not_set)

    if new_record or best_time_not_set:
        best_times_for_sections[index] = elapsed_time_for_section

    Saving.save_global_to_disk()
    
    elapsed_time_for_section = 0

# Currently unused.
func finish_game_with_section() -> void:
    finish_previous_section()

    if elapsed_time < best_time:
        best_time = elapsed_time
    
    elapsed_time = 0

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
