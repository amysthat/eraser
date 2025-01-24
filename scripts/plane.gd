extends CharacterBody2D
class_name PlaneBody

@export var patrol_points: Node2D

@onready var sprite := $Sprite2D
@onready var state_indicator_sprite := $StateIndicator
@onready var collision := $CollisionShape2D
@onready var player_raycast := $RayCast2D
@onready var state_machine := $StateMachine

var is_weak: bool

func _process(_delta):
    if velocity.x > 0 and not sprite.flip_h:
        sprite.flip_h = true
    elif velocity.x < 0 and sprite.flip_h:
        sprite.flip_h = false
    
    player_raycast.look_at(Player.instance.global_position)

func _physics_process(_delta):
    if get_slide_collision_count() > 0:
        var hit_player = false

        for i in range(0, get_slide_collision_count()):
            var target_collision = get_slide_collision(i)
            var body = target_collision.get_collider() as Node

            if body is Player:
                hit_player = true
                body.on_hit(target_collision.get_normal(), true)

                if is_weak:
                    state_machine.transition_state("destroyed")
                else:
                    $StateMachine/patrol.hold_attack_until_reach = true

                    if body.is_parrying:
                        $StateMachine/weak.enable_with_reason(PlaneWeakState.WeakenReason.PLAYER_PARRY)
            
            position += target_collision.get_normal() * 1.2
        
        if not hit_player:
            $StateMachine/weak.enable_with_reason(PlaneWeakState.WeakenReason.MISS)
            $StateMachine/patrol.hold_attack_until_reach = true
    
    move_and_slide()

func set_state_indicator(texture: Texture2D):
    state_indicator_sprite.texture = texture