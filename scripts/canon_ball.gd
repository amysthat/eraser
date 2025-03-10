extends Enemy
class_name CanonBall

@export_category("Collision")
@export_flags_2d_physics var enemy_layer: int
@export_flags_2d_physics var pacified_enemy_layer: int
@export_flags_2d_physics var default_and_player_mask: int
@export_flags_2d_physics var default_only_mask: int

@export_category("Textures")
@export var normal_texture: Texture2D
@export var pacified_texture: Texture2D

@export_category("Custom")
@export var speed := 3500.0
@export var is_invulnerable: bool

@onready var pacified_timer := $Pacified
@onready var sprite := $Sprite2D

func reset_life_timer_and_set_lifetime(time: float):
    $Lifetime.stop()
    $Lifetime.start(time)

func _physics_process(delta):
    velocity = -global_transform.x * speed * delta
    move_and_slide()

    if get_slide_collision_count() > 0:
        for i in range(0, get_slide_collision_count()):
            var collision = get_slide_collision(i)
            var body = collision.get_collider() as Node

            if body is Player:
                hit_player(collision.get_normal())
            else:
                if not is_invulnerable:
                    queue_free()

func _pacify():
    print("pacifying!")

    collision_mask = default_only_mask
    collision_layer = pacified_enemy_layer
    sprite.texture = pacified_texture
    pacified_timer.start()

func _on_pacified_timeout():
    collision_mask = default_and_player_mask
    collision_layer = enemy_layer
    sprite.texture = normal_texture

func _destroy():
    pacified_timer.stop()
    _pacify()

func is_pacified() -> bool:
    return collision_layer == pacified_enemy_layer
