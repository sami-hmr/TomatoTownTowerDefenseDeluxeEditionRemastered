extends PathFollow2D

@export var runspeed = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += runspeed
