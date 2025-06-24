extends PanelContainer

func _ready():
    visible = not Game.is_playing

func reset_game_data() -> void:
    Game.reset_game_data()