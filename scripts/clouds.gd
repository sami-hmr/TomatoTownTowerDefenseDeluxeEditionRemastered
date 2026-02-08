extends Node2D

@onready var timer: Timer = get_parent().get_node("Player").get_node("timer")
@onready var cooldown: Timer = $Timer

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_cooldown_timeout() -> void:
	var created = preload("res://scenes/cloud.tscn").instantiate()
	created.global_position = Vector2(2000.0, rng.randi_range(0, 1800))
	created.size = rng.randf_range(0.8, 1.5)
	self.add_child(created)
	pass
