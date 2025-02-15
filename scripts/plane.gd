extends CharacterBody2D
class_name PlaneBody

signal weaken(reason_int: int)
signal return_to_patrol_after_hitting_player

@export var path: Path2D
var path_follow: PathFollow2D

@onready var sprite := $Sprite2D
@onready var state_indicator_sprite := $StateIndicator
@onready var collision := $CollisionShape2D
@onready var player_raycast := $RayCast2D
@onready var state_machine := $StateMachine

func _ready():
    path_follow = PathFollow2D.new()
    path.add_child(path_follow)

func _process(_delta):
    if velocity.x > 0 and not sprite.flip_h:
        sprite.flip_h = true
    elif velocity.x < 0 and sprite.flip_h:
        sprite.flip_h = false
    
    if Player.instance != null:
        player_raycast.look_at(Player.instance.global_position)

func _physics_process(_delta):
    if get_slide_collision_count() > 0:
        var should_weaken: bool

        var knock_off := Vector2.ZERO

        for i in range(0, get_slide_collision_count()):
            var target_collision = get_slide_collision(i)
            var body = target_collision.get_collider() as Node

            knock_off += target_collision.get_normal() * 1.2

            if body is Player:
                var is_player_above_and_parrying = body.global_position.y < global_position.y and body.is_parrying
                print("is_player_above_and_parrying: ", is_player_above_and_parrying)
                
                if is_weak() or is_player_above_and_parrying:
                    print("destroyed!")
                    state_machine.transition_state("destroyed")
                    body.on_hit(target_collision.get_normal(), true)
                else:
                    print("hit player!")
                    body.on_hit(target_collision.get_normal())

                    if body.is_parrying:
                        print("player was parrying, weakened!")
                        weaken.emit(PlaneWeakState.WeakenReason.PLAYER_PARRY)
                    else:
                        print("return to patrol now!")
                        return_to_patrol_after_hitting_player.emit()

            elif body is not CanonBall:
                should_weaken = true
        
        position += knock_off
        
        if should_weaken:
            weaken.emit(PlaneWeakState.WeakenReason.MISS)
    
    move_and_slide()

func set_state_indicator(texture: Texture2D):
    state_indicator_sprite.texture = texture

func is_weak() -> bool:
    return state_machine.current_state.name == "weak"
