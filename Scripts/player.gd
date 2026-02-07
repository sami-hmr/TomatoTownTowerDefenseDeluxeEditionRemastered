extends Node2D
@onready var ressource_container: HBoxContainer = $"../CanvasLayer/ressource_container"

var resources : Dictionary[String, int] = {
	"wood": 0,
	"stone": 0,
	"iron": 0,
	"juice" : 0
}

signal addResources(new_resources: Dictionary[String, int])
signal setResources(new_resources: Dictionary[String, int])


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_resources()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_resources()

func setup_resources():
	var resources_data = [
		{"frames": preload("res://Ressources/wood.tres"), "name": "wood", "amount": resources["wood"]},
		{"frames": preload("res://Ressources/stone.tres"), "name": "stone", "amount": resources["stone"]},
		{"frames": preload("res://Ressources/iron.tres"), "name": "iron", "amount": resources["iron"]},
		{"frames": preload("res://Ressources/juice.tres"), "name": "juice", "amount": resources["juice"]}
		]

	for data in resources_data:
		var indicator = preload("res://scenes/resource_indicator.tscn").instantiate()
		ressource_container.add_child(indicator)
		indicator.setup.call_deferred(data["frames"], data["name"], data["amount"])

func update_resources():
	var children : Array[Node] = ressource_container.get_children()
	for child in children:
		child.value = resources.get(child.resource_name, child.value)

func _on_add_resources(new_resources: Dictionary[String, int]) -> void:
	for resource_name in new_resources:
		resources[resource_name] += new_resources[resource_name]


func _on_set_resources(new_resources: Dictionary[String, int]) -> void:
	for resource_name in new_resources:
		resources[resource_name] = new_resources[resource_name]
