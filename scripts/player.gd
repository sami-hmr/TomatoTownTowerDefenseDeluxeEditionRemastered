extends Node2D
@onready var ressource_container: HBoxContainer = $"../CanvasLayer/ressource_container"

@onready var res: Resources = $"../Resources"
@onready var timer: Timer = $"../timer"

func _ready() -> void:
	setup_resources()

func _process(delta: float) -> void:
	update_resources()

func setup_resources():
	var resources_data = [
		{"frames": preload("res://Ressources/wood.tres"), "name": "wood", "amount": res.get_resource("wood")},
		{"frames": preload("res://Ressources/stone.tres"), "name": "stone", "amount": res.get_resource("stone")},
		{"frames": preload("res://Ressources/iron.tres"), "name": "iron", "amount": res.get_resource("iron")},
		{"frames": preload("res://Ressources/juice.tres"), "name": "juice", "amount": res.get_resource("juice")},
		{"frames": preload("res://Ressources/time.tres"), "name": "time", "amount": res.get_resource("time")}
		]

	for data in resources_data:
		var indicator = preload("res://scenes/resource_indicator.tscn").instantiate()
		ressource_container.add_child(indicator)
		if indicator.has_method("setup"):
			indicator.setup.call_deferred(data["frames"], data["name"], data["amount"])
		else:
			indicator.queue_free()

func update_time():
	self.res.set_resource("time", self.timer.time_left)

func update_resources():
	update_time()
	var children : Array[Node] = ressource_container.get_children()
	for child in children:
		child.value = res.get_resource(child.resource_name)
