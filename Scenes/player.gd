extends Node2D
@onready var ressource_container: HBoxContainer = $Camera2D/ressource_container


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_resources()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup_resources():
	var resources_data = [
		{"frames": preload("res://Ressources/wood.tres"), "amount": 6},
		{"frames": preload("res://Ressources/stone.tres"), "amount": 7},
		{"frames": preload("res://Ressources/iron.tres"), "amount": 67}
		]
	
	for data in resources_data:
		var indicator = preload("res://Scenes/resource_indicator.tscn").instantiate()
		ressource_container.add_child(indicator)
		indicator.setup(data["frames"], data["amount"])
