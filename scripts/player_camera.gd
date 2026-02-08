extends CharacterBody2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var label := preload("res://scenes/label.tscn")
@onready var label_lose := preload("res://scenes/label_lose.tscn")
@onready var main = get_node("/root/main")
@onready var flash_rect: ColorRect = $ColorRect

const SPEED = 300.0
var pv = 1000


func shake_cam(strength: float = 30.0):
	camera_2d.apply_shake(strength)
	
func flash(speed: float, color: Color):
	flash_rect.color = color
	flash_rect.color.a = 1.0
	flash_rect.visible = true
	
	var tween = create_tween()
	tween.tween_property(flash_rect, "color:a", 0.0, speed)
	tween.tween_callback(func(): flash_rect.visible = false)

var moveable = true
var ended = false

signal death()

func check_win() -> bool:
	if ended == false:
		return false
	var childrens = get_parent().get_children()
	for child in childrens:
		if child.has_method("enemy"):
			return false
	return true
	pass

func _physics_process(delta: float) -> void:
	if check_win() == true:
		moveable = false
		camera_2d.zoom = Vector2(2.5, 2.5)
		position.x = 720
		position.y = 1280
		var you_win = label.instantiate()
		you_win.position.x = 720
		you_win.position.y = 1280
		you_win.scale = Vector2(4, 4)
		main.add_child(you_win)
		
		return
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
		camera_2d.zoom = Vector2(2.5, 2.5)
		death.emit()
		position.x = 720
		position.y = 1280
		var you_lose = label_lose.instantiate()
		you_lose.position.x = 720
		you_lose.position.y = 1280
		you_lose.scale = Vector2(4, 4)
		main.add_child(you_lose)
		flash(100, Color.RED)
	flash(1, Color.RED)
	shake_cam(30)
