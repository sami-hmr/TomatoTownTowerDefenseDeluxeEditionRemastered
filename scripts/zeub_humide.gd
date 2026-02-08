extends CharacterBody2D


const SPEED = 300.0

func enemy():
	return

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var direction_y := Input.get_axis("up", "down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)


	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_method("bullet"):
		area.queue_free()
