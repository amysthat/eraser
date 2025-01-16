extends CharacterBody2D

const SPEED = 3500.0

func _physics_process(delta):
	velocity = -global_transform.x * SPEED * delta
	move_and_slide()

	if get_slide_collision_count() > 0:
		queue_free()

		for i in range(0, get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var body = collision.get_collider() as Node

			if body is Player:
				body.on_hit_by_canon_ball(collision.get_normal())
