extends Camera2D

@export var shakeFade: float = 5

var rnd = RandomNumberGenerator.new()
var shake_strength: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func apply_shake(strength: float = 30.0):
	shake_strength = strength

func random_offset() -> Vector2:
	return Vector2(rnd.randf_range(-shake_strength, shake_strength), rnd.randf_range(-shake_strength, shake_strength))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shakeFade * delta)
		offset = random_offset()
