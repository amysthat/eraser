extends Node

var best_times_for_sections: Dictionary = {}

var elapsed_time_for_section: float
var elapsed_time: float

var best_time_for_section: float:
    get:
        if not best_times_for_sections.keys().has(Sections.instance.current_section_index):
            return -1
        
        return best_times_for_sections[Sections.instance.current_section_index]
    set(value): 
        best_times_for_sections[Sections.instance.current_section_index] = value
var best_time: float = -1

var timer_running: bool

func _ready() -> void:
    if timer_running:
        Game.on_game_begin.connect(start_timer)
        Game.on_game_end.connect(end_timer)

func _process(delta: float) -> void:
    elapsed_time += delta
    elapsed_time_for_section += delta

func start_timer() -> void:
    timer_running = true

func end_timer() -> void:
    timer_running = false

func finish_section() -> void:
    if elapsed_time_for_section < best_time_for_section or best_time_for_section < 0:
        best_time_for_section = elapsed_time_for_section

    Saving.save_global_to_disk()
    
    elapsed_time_for_section = 0

func finish_game_with_section() -> void:
    finish_section()

    if elapsed_time < best_time:
        best_time = elapsed_time
    
    elapsed_time = 0
