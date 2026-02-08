extends PathFollow2D

@export var runspeed = 40
@export var move: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move:
		progress += runspeed * delta
