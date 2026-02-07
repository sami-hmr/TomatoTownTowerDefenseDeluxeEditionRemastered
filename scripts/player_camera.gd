extends CharacterBody2D


const SPEED = 300.0
const x_max = 860
const x_min = 385
const y_min = 240
const y_max = 1200


func _physics_process(delta: float) -> void:
	print(position)
	var direction_x := Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var direction_y := Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	if position.x > x_max:
		position.x = x_max
	if position.x < x_min:
		position.x = x_min
	if position.y > y_max:
		position.y = y_max
	if position.y < y_min:
		position.y = y_min
	
