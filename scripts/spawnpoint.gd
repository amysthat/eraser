extends Node

@export var max_y := 120
@export var player: Player

var active_spawnpoint: Node2D

func _ready():
    Sections.instance.entered_section.connect(_on_entered_section)
    Sections.instance.set_spawn_of_player.connect(_set_player_spawn)

func _process(_delta):
    if player == null:
        return
    
    if player.global_position.y > max_y:
        respawn_player()

func respawn_player():
    print("Respawning player...")

    if active_spawnpoint == null:
        player.global_position = Vector2(164, 84) # start
        return

    player.global_position = active_spawnpoint.global_position

func _set_player_spawn(section: Section):
    active_spawnpoint = find_child(section.spawnpoint_marker_name)
    player.global_position = active_spawnpoint.global_position

func _on_entered_section(section: Section):
    active_spawnpoint = find_child(section.spawnpoint_marker_name)
    print("Spawnpoint set.")