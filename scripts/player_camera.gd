extends CharacterBody2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const SPEED = 300.0
const x_max = 860
const x_min = 385
const y_min = 240
const y_max = 1200

func shake_cam(strength: float = 30.0):
	camera_2d.apply_shake(strength)

var pv = 1000

var moveable = true


func _physics_process(delta: float) -> void:
	if moveable == false:
		return
	var cam_size : Vector2 = camera_2d.get_viewport_rect().size / camera_2d.zoom
	collision_shape_2d.shape.size = cam_size
	var direction_x := Input.get_axis("left", "right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var direction_y := Input.get_axis("up", "down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	handle_zoom()
	display_resource_container(cam_size)
	move_and_slide()

func display_resource_container(cam_size: Vector2):
	
	return

func handle_zoom():
	if (Input.is_action_just_released("zoom in")):
		camera_2d.zoom = Vector2(5, 5).min(camera_2d.zoom * 1.1)
	if (Input.is_action_just_released("zoom out")):
		camera_2d.zoom = Vector2(1.2, 1.2).max(camera_2d.zoom * 0.9)




func _on_mob_spawner_damage(count: int) -> void:
	pv -= count
	print("Village has been attacked, ", pv, " hp left")
	
	if pv <= 0:
		moveable = false
		camera_2d.zoom = Vector2(1.2, 1.2)
	pass # Replace with function body.
