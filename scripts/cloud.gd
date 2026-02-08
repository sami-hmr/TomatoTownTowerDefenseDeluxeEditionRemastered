extends Node2D

@export var size: float = 1.0

func _ready() -> void:
	scale = Vector2(size, size)
	pass

func _process(delta: float) -> void:
	global_position.x -= (20 * size) * delta
	if global_position.x < (-150 * size):
		queue_free()
	pass
