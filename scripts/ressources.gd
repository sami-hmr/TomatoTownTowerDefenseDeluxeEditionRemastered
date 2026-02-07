class_name Resources
extends Node2D

@export
var resource_list: Dictionary = {
	"wood": 0,
	"stone": 0,
	"iron": 0,
	"juice": 0,
	"time": 0
}

signal resource_updated(name: String, val: int)

func update_resource(name: String, val: int):
	resource_list[name] += val
	emit_signal("resource_updated", name, val)

func set_resource(name: String, val: int):
	resource_list[name] = val

func get_resource(name: String) -> int:
	return resource_list[name]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
