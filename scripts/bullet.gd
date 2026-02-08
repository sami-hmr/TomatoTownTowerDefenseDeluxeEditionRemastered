extends Area2D

@onready var hitbox: CollisionShape2D = $CollisionShape2D

var target: Node2D = null
var speed: float = 100
var rotation_speed: float = 5.0
var damage: int = 0

func bullet():
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target and is_instance_valid(target):
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
		rotation  = direction.angle()
	else:
		queue_free()
